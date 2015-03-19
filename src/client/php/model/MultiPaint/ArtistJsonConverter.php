<?php
namespace MultiPaint;



require_once __DIR__.'/ArtistArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class MultiPaint\Artist into a JSON string and backwards via an array converter.
 *
 * @package MultiPaint
 * @version 1.2.5555.22839
 */
abstract class ArtistJsonConverter
{/**
	 * @param string Json representation of the object(s)
	 *
	 * @return \MultiPaint\Artist[]|\MultiPaint\Artist An object or an array of objects of type "MultiPaint\Artist"
	 */
	public static function fromJson($item, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
	{
		$obj = json_decode($item, true);

		return \NGS\Utils::isJsonArray($item)
			? \MultiPaint\ArtistArrayConverter::fromArrayList($obj, $allowNullValues, $client)
			: \MultiPaint\ArtistArrayConverter::fromArray($obj, $client);
	}

	/**
	 * @param array|\MultiPaint\Artist An object or an array of objects of type "MultiPaint\Artist"
	 *
	 * @return string Json representation of the object(s)
	 */
	public static function toJson($item)
	{
		$arr = \MultiPaint\ArtistArrayConverter::toArray($item);
		if(is_array($item))
			return json_encode($arr);
		if(empty($arr))
			return '{}';
		return json_encode($arr);
	}

	
}