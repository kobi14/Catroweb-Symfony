<?php

namespace Catrobat\AppBundle\Controller\Web;

use Catrobat\AppBundle\Entity\Program;
use Catrobat\AppBundle\Entity\User;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Security\Core\Exception\AccessDeniedException;

/**
 * Class StealProgramController
 * @package Catrobat\AppBundle\Controller\Web
 */
class StealProgramController extends Controller
{

  /**
   * @Route("/profile/stealProgram", name="profile_stealProgram", methods={"POST"})
   *
   * @param Request $request
   *
   * @return mixed
   *
   * @throws AccessDeniedException
   */
  public function profileStealProgramAction(Request $request)
  {
    /**
     * @var $user User
     */
    $user = $this->getUser();

    if (!$user)
    {
      return $this->redirectToRoute('fos_user_security_login');
    }

    if ($user->getUsername() !== 'bob')
    {
      throw $this->createAccessDeniedException('User not allowed to steal a program');
    }

    $submittedToken = $request->request->get('token');
    if ($this->isCsrfTokenValid('profile-stealProgram', $submittedToken))
    {
      $progs = $this->get('programmanager')->getUserPrograms(1);
      if (count($progs) === 0)
      {
        throw new \RuntimeException("No program found.");
      }

      /** @var Program $prog_to_steal */
      $prog_to_steal = $progs[array_rand($progs, 1)];
      $prog_to_steal->setUser($user);

      $em = $this->getDoctrine()->getManager();
      $em->persist($prog_to_steal);
      $em->flush();

      return $this->redirectToRoute('profile');
    }
    else
    {
      throw $this->createAccessDeniedException("CSRF invalid.");
    }
  }

}
