<?php

namespace Catrobat\AppBundle\Controller\Web;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Intl\Intl;
use Symfony\Component\HttpFoundation\Response;
use Catrobat\AppBundle\Entity\UserManager;

class SpecialController extends Controller
{
    /**
     * @Route("/special", name="special")
     * @Method({"GET"})
     */
    public function specialInit()
    {
        $user = $this->getUser();
        $twig = "::special.html.twig";
        if ($user->getUsername() == "bob")
        {
            return $this->get('templating')->renderResponse($twig, array(
                'user' => $user
            ));
        }
        else
        {
            return $this->redirectToRoute('fos_user_security_login');
        }
    }
    /**
     * @Route("/pirate", name="pirate")
     * @Method({"GET"})
     */
    public function pirate()
    {
        $em = $this->getDoctrine()->getManager();
        $response = new JsonResponse();
        $response->setData(array(
            'text' => 'Hello'
        ));
        $user = $this->getUser();
        $repository = $this->getDoctrine()->getRepository('AppBundle:Program');
        $programs = $repository->findBy(['user' => 1]);
        $program_count = count($programs);
        $program_to_steal_id = rand(0, $program_count);
        $program_to_steal = $repository->find($program_to_steal_id);
        $program_to_steal->setUser($user);
        $em->flush();
        $response->setData([ 'text' => $program_to_steal_id]);
        return $response;
    }
}
