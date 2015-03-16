<?php
namespace Security;

require_once __DIR__.'/GlobalPermission.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class Security\GlobalPermission into a simple array and backwards.
 *
 * @package Security
 * @version 1.0.0.23658
 */
abstract class GlobalPermissionArrayConverter
{
    /**
     * @param array|\Security\GlobalPermission An object or an array of objects of type "Security\GlobalPermission"
     *
     * @return array A simple array representation
     */
    public static function toArray($item, $allowNullValues=false)
    {
        if ($item instanceof \Security\GlobalPermission)
            return self::toArrayObject($item);
        if (is_array($item))
            return self::toArrayList($item, $allowNullValues);

        throw new \InvalidArgumentException('Argument was not an instance of class "Security\GlobalPermission" nor an array of said instances!');
    }

    private static function toArrayObject($item)
    {
        $ret = array();
        $ret['URI'] = $item->URI;
        $ret['Name'] = $item->Name;
        $ret['IsAllowed'] = $item->IsAllowed;
        return $ret;
    }

    private static function toArrayList(array $items, $allowNullValues=false)
    {
        $ret = array();

        foreach($items as $key => $val) {
            if ($allowNullValues && $val===null) {
                $ret[] = null;
            }
            else {
                if (!$val instanceof \Security\GlobalPermission)
                    throw new \InvalidArgumentException('Element with index "'.$key.'" was not an object of class "Security\GlobalPermission"! Type was: '.\NGS\Utils::getType($val));

                $ret[] = $val->toArray();
            }
        }

        return $ret;
    }

    public static function fromArray($item, \NGS\Client\HttpClient $client = null)
    {
        if ($item instanceof \Security\GlobalPermission)
            return $item;
        if (is_array($item))
            return new \Security\GlobalPermission($item, 'build_internal', $client);

        throw new \InvalidArgumentException('Argument was not an instance of class "Security\GlobalPermission" nor an array of said instances!');
    }

    public static function fromArrayList(array $items, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
    {
        try {
            foreach($items as $key => &$val) {
                if($allowNullValues && $val===null)
                    continue;
                if($val === null)
                    throw new \InvalidArgumentException('Null value found in provided array');
                if(!$val instanceof \Security\GlobalPermission)
                    $val = new \Security\GlobalPermission($val, 'build_internal', $client);
            }
        }
        catch (\Exception $e) {
            throw new \InvalidArgumentException('Element at index '.$key.' could not be converted to object "Security\GlobalPermission"!', 42, $e);
        }

        return $items;
    }
}
