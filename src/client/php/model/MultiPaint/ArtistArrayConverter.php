<?php
namespace MultiPaint;

require_once __DIR__.'/Artist.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class MultiPaint\Artist into a simple array and backwards.
 *
 * @package MultiPaint
 * @version 1.0.0.23658
 */
abstract class ArtistArrayConverter
{
    /**
     * @param array|\MultiPaint\Artist An object or an array of objects of type "MultiPaint\Artist"
     *
     * @return array A simple array representation
     */
    public static function toArray($item, $allowNullValues=false)
    {
        if ($item instanceof \MultiPaint\Artist)
            return self::toArrayObject($item);
        if (is_array($item))
            return self::toArrayList($item, $allowNullValues);

        throw new \InvalidArgumentException('Argument was not an instance of class "MultiPaint\Artist" nor an array of said instances!');
    }

    private static function toArrayObject($item)
    {
        $ret = array();
        $ret['URI'] = $item->URI;
        if($item->UserURI !== null)
            $ret['UserURI'] = $item->UserURI;
        $ret['UserID'] = $item->UserID;
        $ret['Name'] = $item->Name;
        $ret['CreatedAt'] = $item->CreatedAt->__toString();
        $ret['LastActiveAt'] = $item->LastActiveAt->__toString();
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
                if (!$val instanceof \MultiPaint\Artist)
                    throw new \InvalidArgumentException('Element with index "'.$key.'" was not an object of class "MultiPaint\Artist"! Type was: '.\NGS\Utils::getType($val));

                $ret[] = $val->toArray();
            }
        }

        return $ret;
    }

    public static function fromArray($item, \NGS\Client\HttpClient $client = null)
    {
        if ($item instanceof \MultiPaint\Artist)
            return $item;
        if (is_array($item))
            return new \MultiPaint\Artist($item, 'build_internal', $client);

        throw new \InvalidArgumentException('Argument was not an instance of class "MultiPaint\Artist" nor an array of said instances!');
    }

    public static function fromArrayList(array $items, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
    {
        try {
            foreach($items as $key => &$val) {
                if($allowNullValues && $val===null)
                    continue;
                if($val === null)
                    throw new \InvalidArgumentException('Null value found in provided array');
                if(!$val instanceof \MultiPaint\Artist)
                    $val = new \MultiPaint\Artist($val, 'build_internal', $client);
            }
        }
        catch (\Exception $e) {
            throw new \InvalidArgumentException('Element at index '.$key.' could not be converted to object "MultiPaint\Artist"!', 42, $e);
        }

        return $items;
    }
}
