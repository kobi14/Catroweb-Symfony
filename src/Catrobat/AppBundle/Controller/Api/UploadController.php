<?php

namespace Catrobat\AppBundle\Controller\Api;

use Catrobat\AppBundle\Entity\GameJam;
use Catrobat\AppBundle\Entity\Program;
use Catrobat\AppBundle\Entity\NewProgramNotification;
use Catrobat\AppBundle\Entity\User;
use Psr\Log\LoggerInterface;
use Symfony\Component\HttpFoundation\File\File;
use Symfony\Component\HttpFoundation\Request;
use Catrobat\AppBundle\Entity\UserManager;
use Catrobat\AppBundle\Requests\AddProgramRequest;
use Catrobat\AppBundle\Entity\ProgramManager;
use Catrobat\AppBundle\Services\TokenGenerator;
use Symfony\Component\HttpFoundation\JsonResponse;
use Catrobat\AppBundle\StatusCode;
use Symfony\Component\Routing\Annotation\Route;
use Catrobat\AppBundle\Exceptions\Upload\MissingChecksumException;
use Catrobat\AppBundle\Exceptions\Upload\InvalidChecksumException;
use Catrobat\AppBundle\Exceptions\Upload\MissingPostDataException;
use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorage;
use Symfony\Component\Translation\TranslatorInterface;
use Catrobat\AppBundle\Entity\GameJamRepository;
use Catrobat\AppBundle\Exceptions\Upload\NoGameJamException;


class UploadController
{
  private $usermanager;

  private $tokenstorage;

  private $programmanager;

  private $gamejamrepository;

  private $tokengenerator;

  private $translator;

  private $logger;


  /**
   * UploadController constructor.
   *
   * @param UserManager         $usermanager
   * @param TokenStorage        $tokenstorage
   * @param ProgramManager      $programmanager
   * @param GameJamRepository   $gamejamrepository
   * @param TokenGenerator      $tokengenerator
   * @param TranslatorInterface $translator
   */
  public function __construct(UserManager $usermanager, TokenStorage $tokenstorage, ProgramManager $programmanager,
                              GameJamRepository $gamejamrepository, TokenGenerator $tokengenerator,
                              TranslatorInterface $translator, LoggerInterface $logger)
  {
    $this->usermanager = $usermanager;
    $this->tokenstorage = $tokenstorage;
    $this->programmanager = $programmanager;
    $this->gamejamrepository = $gamejamrepository;
    $this->tokengenerator = $tokengenerator;
    $this->translator = $translator;
    $this->logger = $logger;
  }


  /**
   * @Route("/api/upload/upload.json", name="catrobat_api_upload", defaults={"_format": "json"}, methods={"POST"})
   *
   * @param Request $request
   *
   * @return JsonResponse
   */
  public function uploadAction(Request $request)
  {
    $this->logger->error("UploadAction called");
    return $this->processUpload($request);
  }


  /**
   * @Route("/api/gamejam/submit.json", name="catrobat_api_gamejam_submit", defaults={"_format": "json"}, methods={"POST"})
   *
   * @param Request $request
   *
   * @throws NoGameJamException
   * @return JsonResponse
   */
  public function submitAction(Request $request)
  {
    $jam = $this->gamejamrepository->getCurrentGameJam();
    if ($jam === null)
    {
      throw new NoGameJamException();
    }

    return $this->processUpload($request, $jam);
  }

  /**
   * @param Request $request
   * @param null    $gamejam
   *
   * @return JsonResponse
   */
  private function processUpload(Request $request, $gamejam = null)
  {

    if ($request->files->count() !== 1)
    {
      throw new MissingPostDataException();
    }
    elseif (!$request->request->has('fileChecksum'))
    {
      throw new MissingChecksumException();
    }

    /**
     * @var $file File
     * @var $user User
     */
    $file = array_values($request->files->all())[0];
    if (md5_file($file->getPathname()) !== $request->request->get('fileChecksum'))
    {
      throw new InvalidChecksumException();
    }

    $user = $this->tokenstorage->getToken()->getUser();

    $flavor = 'pocketcode';
    if ($user->getNolbUser())
    {
      $flavor = 'create@school';
    }
    if ($request->request->has('flavor'))
    {
      $flavor = $request->request->get('flavor');
    }

    $add_program_request = new AddProgramRequest($user, $file, $request->getClientIp(),
      $gamejam, $request->request->get('deviceLanguage'), $flavor);

    $program = $this->programmanager->addProgram($add_program_request);
    if ($program === null)
    {
      $response = $this->createUploadFailedResponse($request, $gamejam, $user);
    }
    else
    {
      /**
       * @var $user User
       */
      foreach ($user->getFollowers() as $follower)
      {
        $notification_service = $request->get("catro_notification_service");
        $notification = new NewProgramNotification(
          $follower,
          "New Program Follows notification",
          "new program",
          $program
        );
        $notification_service->addNotification($notification);
      }
      $response = $this->createUploadResponse($request, $gamejam, $user, $program);
    }

    return JsonResponse::create($response);
  }

  /**
   * @param $gamejam
   * @param $user
   * @param $program
   * @param $request
   *
   * @return mixed
   */
  private function assembleFormUrl($gamejam, $user, $program, $request)
  {
    /**
     * @var $gamejam GameJam
     */
    $languageCode = $this->getLanguageCode($request);

    $url = $gamejam->getFormUrl();
    $url = str_replace("%CAT_ID%", $program->getId(), $url);
    $url = str_replace("%CAT_MAIL%", $user->getEmail(), $url);
    $url = str_replace("%CAT_NAME%", $user->getUsername(), $url);
    $url = str_replace("%CAT_LANGUAGE%", $languageCode, $url);

    return $url;
  }

  /**
   * @param       $message
   * @param array $parameters
   *
   * @return string
   */
  private function trans($message, $parameters = [])
  {
    return $this->translator->trans($message, $parameters, 'catroweb');
  }

  /**
   * @param $request
   *
   * @return string
   */
  private function getLanguageCode(Request $request)
  {
    $languageCode = strtoupper(substr($request->getLocale(), 0, 2));
    if ($languageCode !== "DE")
    {
      $languageCode = "EN";
    }

    return $languageCode;
  }

  /**
   * @param Request $request
   * @param         $gamejam
   * @param         $user
   * @param         $program
   * @param         $response
   *
   * @return mixed
   */
  private function createUploadResponse(Request $request, $gamejam, $user, $program)
  {
    /**
     * @var $user    User
     * @var $program Program
     */
    $response = [];
    $user->setUploadToken($this->tokengenerator->generateToken());
    $this->usermanager->updateUser($user);

    $response['projectId'] = $program->getId();
    $response['statusCode'] = StatusCode::OK;
    $response['answer'] = $this->trans('success.upload');
    $response['token'] = $user->getUploadToken();
    if ($gamejam !== null && !$program->isAcceptedForGameJam())
    {
      $response['form'] = $this->assembleFormUrl($gamejam, $user, $program, $request);
    }

    $request->attributes->set('post_to_facebook', true);
    $request->attributes->set('program_id', $program->getId());
    $response['preHeaderMessages'] = '';

    return $response;
  }

  /**
   * @param  $request
   * @param  $user
   * @param  $gamejam
   *
   * @return array
   */
  private function createUploadFailedResponse($request, $gamejam, $user)
  {
    /**
     * @var $user User
     */
    $response = [];
    $user->setUploadToken($this->tokengenerator->generateToken());
    $this->usermanager->updateUser($user);

    $response['projectId'] = 0;
    $response['statusCode'] = StatusCode::FILE_UPLOAD_FAILED;
    $response['answer'] = $this->trans('failure.upload');
    $response['token'] = $user->getUploadToken();

    $request->attributes->set('post_to_facebook', false);
    $request->attributes->set('program_id', 0);
    $response['preHeaderMessages'] = '';

    return $response;
  }
}
