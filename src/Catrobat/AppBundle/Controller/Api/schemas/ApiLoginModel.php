<?php
/**
 * Created by PhpStorm.
 * User: catroweb
 * Date: 7/30/18
 * Time: 10:48 AM
 */

namespace Catrobat\AppBundle\Controller\Api\schemas;


use Swagger\Annotations as SWG;
/**
 * @SWG\Definition(
 *   required={"statusCode", "answer", "token"},
 *   type="object",
 *   )
 */
class ApiLoginModel extends ApiDefaultModel
{
  /**
   * @SWG\Property(example=" ae2b1fca515949e5d54fb22b8ed95575")
   * @var string
   */
  protected $token;
}