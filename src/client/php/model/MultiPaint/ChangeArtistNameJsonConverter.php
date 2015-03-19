<?php
namespace MultiPaint;



require_once __DIR__.'/ChangeArtistNameArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class MultiPaint\ChangeArtistName into a JSON string and backwards via an array converter.
 *
 * @package MultiPaint
 * @version 1.2.5555.22839
 */
abstract class ChangeArtistNameJsonConverter
{/**
	 * @param string Json representation of the object(s)
	 *
	 * @return \MultiPaint\ChangeArtistName[]|\MultiPaint\ChangeArtistName An object or an array of objects of type "MultiPaint\ChangeArtistName"
	 */
	public static function fromJson($item, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
	{
		$obj = json_decode($item, true);

		return \NGS\Utils::isJsonArray($item)
			? \MultiPaint\ChangeArtistNameArrayConverter::fromArrayList($obj, $allowNullValues, $client)
			: \MultiPaint\ChangeArtistNameArrayConverter::fromArray($obj, $client);
	}

	/**
	 * @param array|\MultiPaint\ChangeArtistName An object or an array of objects of type "MultiPaint\ChangeArtistName"
	 *
	 * @return string Json representation of the object(s)
	 */
	public static function toJson($item)
	{
		$arr = \MultiPaint\ChangeArtistNameArrayConverter::toArray($item);
		if(is_array($item))
			return json_encode($arr);
		if(empty($arr))
			return '{}';
		return json_encode($arr);
	}

	
}