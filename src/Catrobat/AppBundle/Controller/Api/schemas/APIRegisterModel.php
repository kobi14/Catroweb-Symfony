<?php

namespace Catrobat\AppBundle\Controller\Api\schemas;

use Swagger\Annotations as SWG;
/**
 * @SWG\Definition(
 *   required={"statusCode", "answer", "token"},
 *   type="object",
 *   )
 */
class APIRegisterModel extends APIDefaultModel
{
  /**
   * @SWG\Property(example="This is not the answer you are looking for!")
   * @var string
   */
  protected $answer;

  /**
   * @SWG\Property(example=" ae2b1fca515949e5d54fb22b8ed95575")
   * @var string
   */
  protected $token;
}