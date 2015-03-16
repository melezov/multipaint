<?php
namespace Security;

require_once __DIR__.'/RolePermissionArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class Security\RolePermission into a JSON string and backwards via an array converter.
 *
 * @package Security
 * @version 1.0.0.23658
 */
abstract class RolePermissionJsonConverter
{
    /**
     * @param string Json representation of the object(s)
     *
     * @return \Security\RolePermission[]|\Security\RolePermission An object or an array of objects of type "Security\RolePermission"
     */
    public static function fromJson($item, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
    {
        $obj = json_decode($item, true);

        return \NGS\Utils::isJsonArray($item)
            ? \Security\RolePermissionArrayConverter::fromArrayList($obj, $allowNullValues, $client)
            : \Security\RolePermissionArrayConverter::fromArray($obj, $client);
    }

    /**
     * @param array|\Security\RolePermission An object or an array of objects of type "Security\RolePermission"
     *
     * @return string Json representation of the object(s)
     */
    public static function toJson($item)
    {
        $arr = \Security\RolePermissionArrayConverter::toArray($item);
        if(is_array($item))
            return json_encode($arr);
        if(empty($arr))
            return '{}';
        return json_encode($arr);
    }
}
