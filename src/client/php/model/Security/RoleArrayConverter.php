<?php
namespace Security;



require_once __DIR__.'/Role.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class Security\Role into a simple array and backwards.
 *
 * @package Security
 * @version 1.2.5555.22839
 */
abstract class RoleArrayConverter
{/**
	 * @param array|\Security\Role An object or an array of objects of type "Security\Role"
	 *
	 * @return array A simple array representation
	 */
	public static function toArray($item, $allowNullValues=false)
	{
		if ($item instanceof \Security\Role)
			return self::toArrayObject($item);
		if (is_array($item))
			return self::toArrayList($item, $allowNullValues);

		throw new \InvalidArgumentException('Argument was not an instance of class "Security\Role" nor an array of said instances!');
	}

	private static function toArrayObject($item)
	{
		$ret = array();
		$ret['URI'] = $item->URI;
		$ret['Name'] = $item->Name;
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
				if (!$val instanceof \Security\Role)
					throw new \InvalidArgumentException('Element with index "'.$key.'" was not an object of class "Security\Role"! Type was: '.\NGS\Utils::getType($val));

				$ret[] = $val->toArray();
			}
		}

		return $ret;
	}

	public static function fromArray($item, \NGS\Client\HttpClient $client = null)
	{
		if ($item instanceof \Security\Role)
			return $item;
		if (is_array($item))
			return new \Security\Role($item, 'build_internal', $client);

		throw new \InvalidArgumentException('Argument was not an instance of class "Security\Role" nor an array of said instances!');
	}

	public static function fromArrayList(array $items, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
	{
		try {
			foreach($items as $key => &$val) {
				if($allowNullValues && $val===null)
					continue;
				if($val === null)
					throw new \InvalidArgumentException('Null value found in provided array');
				if(!$val instanceof \Security\Role)
					$val = new \Security\Role($val, 'build_internal', $client);
			}
		}
		catch (\Exception $e) {
			throw new \InvalidArgumentException('Element at index '.$key.' could not be converted to object "Security\Role"!', 42, $e);
		}		

		return $items;
	}

	
}