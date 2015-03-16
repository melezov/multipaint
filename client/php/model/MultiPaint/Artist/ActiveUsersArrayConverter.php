<?php
namespace MultiPaint\Artist;

require_once __DIR__.'/ActiveUsers.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class MultiPaint\Artist\ActiveUsers into a simple array and backwards.
 *
 * @package MultiPaint
 * @version 1.0.0.23658
 */
abstract class ActiveUsersArrayConverter
{
    /**
     * @param array|\MultiPaint\Artist\ActiveUsers An object or an array of objects of type "MultiPaint\Artist\ActiveUsers"
     *
     * @return array A simple array representation
     */
    public static function toArray($item, $allowNullValues=false)
    {
        if ($item instanceof \MultiPaint\Artist\ActiveUsers)
            return self::toArrayObject($item);
        if (is_array($item))
            return self::toArrayList($item, $allowNullValues);

        throw new \InvalidArgumentException('Argument was not an instance of class "MultiPaint\Artist\ActiveUsers" nor an array of said instances!');
    }

    private static function toArrayObject($item)
    {
        $ret = array();
        $ret['Since'] = $item->Since->__toString();
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
                if (!$val instanceof \MultiPaint\Artist\ActiveUsers)
                    throw new \InvalidArgumentException('Element with index "'.$key.'" was not an object of class "MultiPaint\Artist\ActiveUsers"! Type was: '.\NGS\Utils::getType($val));

                $ret[] = $val->toArray();
            }
        }

        return $ret;
    }

    public static function fromArray($item, \NGS\Client\HttpClient $client = null)
    {
        if ($item instanceof \MultiPaint\Artist\ActiveUsers)
            return $item;
        if (is_array($item))
            return new \MultiPaint\Artist\ActiveUsers($item);

        throw new \InvalidArgumentException('Argument was not an instance of class "MultiPaint\Artist\ActiveUsers" nor an array of said instances!');
    }

    public static function fromArrayList(array $items, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
    {
        try {
            foreach($items as $key => &$val) {
                if($allowNullValues && $val===null)
                    continue;
                if($val === null)
                    throw new \InvalidArgumentException('Null value found in provided array');
                if(!$val instanceof \MultiPaint\Artist\ActiveUsers)
                    $val = new \MultiPaint\Artist\ActiveUsers($val);
            }
        }
        catch (\Exception $e) {
            throw new \InvalidArgumentException('Element at index '.$key.' could not be converted to object "MultiPaint\Artist\ActiveUsers"!', 42, $e);
        }

        return $items;
    }
}
