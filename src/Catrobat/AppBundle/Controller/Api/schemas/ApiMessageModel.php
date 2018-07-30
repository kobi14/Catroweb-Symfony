<?php

namespace Catrobat\AppBundle\Controller\Api\schemas;

use Swagger\Annotations as SWG;
/**
 * @SWG\Definition(
 *   required={"statusCode", "answer"},
 *   type="object",
 *   )
 */
class ApiMessageModel extends ApiDefaultModel
{
  /**
   * @SWG\Property(example="This is not the answer you are looking for!")
   * @var string
   */
  protected $answer;
}