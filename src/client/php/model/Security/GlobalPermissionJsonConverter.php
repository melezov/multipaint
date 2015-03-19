<?php
namespace Security;



require_once __DIR__.'/GlobalPermissionArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class Security\GlobalPermission into a JSON string and backwards via an array converter.
 *
 * @package Security
 * @version 1.2.5555.22839
 */
abstract class GlobalPermissionJsonConverter
{/**
	 * @param string Json representation of the object(s)
	 *
	 * @return \Security\GlobalPermission[]|\Security\GlobalPermission An object or an array of objects of type "Security\GlobalPermission"
	 */
	public static function fromJson($item, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
	{
		$obj = json_decode($item, true);

		return \NGS\Utils::isJsonArray($item)
			? \Security\GlobalPermissionArrayConverter::fromArrayList($obj, $allowNullValues, $client)
			: \Security\GlobalPermissionArrayConverter::fromArray($obj, $client);
	}

	/**
	 * @param array|\Security\GlobalPermission An object or an array of objects of type "Security\GlobalPermission"
	 *
	 * @return string Json representation of the object(s)
	 */
	public static function toJson($item)
	{
		$arr = \Security\GlobalPermissionArrayConverter::toArray($item);
		if(is_array($item))
			return json_encode($arr);
		if(empty($arr))
			return '{}';
		return json_encode($arr);
	}

	
}