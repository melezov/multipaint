<?php
namespace Security;



require_once __DIR__.'/InheritedRoleArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class Security\InheritedRole into a JSON string and backwards via an array converter.
 *
 * @package Security
 * @version 1.2.5555.22839
 */
abstract class InheritedRoleJsonConverter
{/**
	 * @param string Json representation of the object(s)
	 *
	 * @return \Security\InheritedRole[]|\Security\InheritedRole An object or an array of objects of type "Security\InheritedRole"
	 */
	public static function fromJson($item, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
	{
		$obj = json_decode($item, true);

		return \NGS\Utils::isJsonArray($item)
			? \Security\InheritedRoleArrayConverter::fromArrayList($obj, $allowNullValues, $client)
			: \Security\InheritedRoleArrayConverter::fromArray($obj, $client);
	}

	/**
	 * @param array|\Security\InheritedRole An object or an array of objects of type "Security\InheritedRole"
	 *
	 * @return string Json representation of the object(s)
	 */
	public static function toJson($item)
	{
		$arr = \Security\InheritedRoleArrayConverter::toArray($item);
		if(is_array($item))
			return json_encode($arr);
		if(empty($arr))
			return '{}';
		return json_encode($arr);
	}

	
}