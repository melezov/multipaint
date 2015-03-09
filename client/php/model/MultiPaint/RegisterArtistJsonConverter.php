<?php
namespace MultiPaint;

require_once __DIR__.'/RegisterArtistArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class MultiPaint\RegisterArtist into a JSON string and backwards via an array converter.
 *
 * @package MultiPaint
 * @version 1.0.0.23658
 */
abstract class RegisterArtistJsonConverter
{
    /**
     * @param string Json representation of the object(s)
     *
     * @return \MultiPaint\RegisterArtist[]|\MultiPaint\RegisterArtist An object or an array of objects of type "MultiPaint\RegisterArtist"
     */
    public static function fromJson($item, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
    {
        $obj = json_decode($item, true);

        return \NGS\Utils::isJsonArray($item)
            ? \MultiPaint\RegisterArtistArrayConverter::fromArrayList($obj, $allowNullValues, $client)
            : \MultiPaint\RegisterArtistArrayConverter::fromArray($obj, $client);
    }

    /**
     * @param array|\MultiPaint\RegisterArtist An object or an array of objects of type "MultiPaint\RegisterArtist"
     *
     * @return string Json representation of the object(s)
     */
    public static function toJson($item)
    {
        $arr = \MultiPaint\RegisterArtistArrayConverter::toArray($item);
        if(is_array($item))
            return json_encode($arr);
        if(empty($arr))
            return '{}';
        return json_encode($arr);
    }
}
