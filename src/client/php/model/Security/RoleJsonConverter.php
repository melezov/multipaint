<?php
namespace Security;

require_once __DIR__.'/RoleArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class Security\Role into a JSON string and backwards via an array converter.
 *
 * @package Security
 * @version 1.0.0.23658
 */
abstract class RoleJsonConverter
{
    /**
     * @param string Json representation of the object(s)
     *
     * @return \Security\Role[]|\Security\Role An object or an array of objects of type "Security\Role"
     */
    public static function fromJson($item, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
    {
        $obj = json_decode($item, true);

        return \NGS\Utils::isJsonArray($item)
            ? \Security\RoleArrayConverter::fromArrayList($obj, $allowNullValues, $client)
            : \Security\RoleArrayConverter::fromArray($obj, $client);
    }

    /**
     * @param array|\Security\Role An object or an array of objects of type "Security\Role"
     *
     * @return string Json representation of the object(s)
     */
    public static function toJson($item)
    {
        $arr = \Security\RoleArrayConverter::toArray($item);
        if(is_array($item))
            return json_encode($arr);
        if(empty($arr))
            return '{}';
        return json_encode($arr);
    }
}
