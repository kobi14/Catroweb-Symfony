<?php
namespace Catrobat\AppBundle\Controller\Api\schemas;

use Swagger\Annotations as SWG;

/**
 * @SWG\Definition(
 *   required={"statusCode"},
 *   type="object",
 *   )
 */
class ApiDefaultModel
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