<?php
namespace MultiPaint\Artist;



require_once __DIR__.'/ActiveUsersArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class MultiPaint\Artist\ActiveUsers into a JSON string and backwards via an array converter.
 *
 * @package MultiPaint
 * @version 1.2.5555.22839
 */
abstract class ActiveUsersJsonConverter
{/**
	 * @param string Json representation of the object(s)
	 *
	 * @return \MultiPaint\Artist\ActiveUsers[]|\MultiPaint\Artist\ActiveUsers An object or an array of objects of type "MultiPaint\Artist\ActiveUsers"
	 */
	public static function fromJson($item, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
	{
		$obj = json_decode($item, true);

		return \NGS\Utils::isJsonArray($item)
			? \MultiPaint\Artist\ActiveUsersArrayConverter::fromArrayList($obj, $allowNullValues, $client)
			: \MultiPaint\Artist\ActiveUsersArrayConverter::fromArray($obj, $client);
	}

	/**
	 * @param array|\MultiPaint\Artist\ActiveUsers An object or an array of objects of type "MultiPaint\Artist\ActiveUsers"
	 *
	 * @return string Json representation of the object(s)
	 */
	public static function toJson($item)
	{
		$arr = \MultiPaint\Artist\ActiveUsersArrayConverter::toArray($item);
		if(is_array($item))
			return json_encode($arr);
		if(empty($arr))
			return '{}';
		return json_encode($arr);
	}

	
}