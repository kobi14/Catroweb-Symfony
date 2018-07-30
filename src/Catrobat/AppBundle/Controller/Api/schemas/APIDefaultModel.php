<?php
namespace Catrobat\AppBundle\Controller\Api\schemas;

use Swagger\Annotations as SWG;

/**
 * @SWG\Definition(
 *   required={"statusCode", "answer"},
 *   type="object",
 *   )
 */
class APIDefaultModel
{
  /**
   * @SWG\Property(format="int64", example="200")
   * @var int
   */
  protected $statusCode;

  /**
   * @SWG\Property(example="")
   * @var string
   */
  protected $preHeaderMessages;

}