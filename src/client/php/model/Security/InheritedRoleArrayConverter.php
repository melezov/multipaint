<?php
namespace Security;



require_once __DIR__.'/InheritedRole.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class Security\InheritedRole into a simple array and backwards.
 *
 * @package Security
 * @version 1.2.5555.22839
 */
abstract class InheritedRoleArrayConverter
{/**
	 * @param array|\Security\InheritedRole An object or an array of objects of type "Security\InheritedRole"
	 *
	 * @return array A simple array representation
	 */
	public static function toArray($item, $allowNullValues=false)
	{
		if ($item instanceof \Security\InheritedRole)
			return self::toArrayObject($item);
		if (is_array($item))
			return self::toArrayList($item, $allowNullValues);

		throw new \InvalidArgumentException('Argument was not an instance of class "Security\InheritedRole" nor an array of said instances!');
	}

	private static function toArrayObject($item)
	{
		$ret = array();
		$ret['URI'] = $item->URI;
		$ret['Name'] = $item->Name;
		if($item->RoleURI !== null) 
			$ret['RoleURI'] = $item->RoleURI;
		$ret['ParentName'] = $item->ParentName;
		if($item->ParentRoleURI !== null) 
			$ret['ParentRoleURI'] = $item->ParentRoleURI;
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
				if (!$val instanceof \Security\InheritedRole)
					throw new \InvalidArgumentException('Element with index "'.$key.'" was not an object of class "Security\InheritedRole"! Type was: '.\NGS\Utils::getType($val));

				$ret[] = $val->toArray();
			}
		}

		return $ret;
	}

	public static function fromArray($item, \NGS\Client\HttpClient $client = null)
	{
		if ($item instanceof \Security\InheritedRole)
			return $item;
		if (is_array($item))
			return new \Security\InheritedRole($item, 'build_internal', $client);

		throw new \InvalidArgumentException('Argument was not an instance of class "Security\InheritedRole" nor an array of said instances!');
	}

	public static function fromArrayList(array $items, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
	{
		try {
			foreach($items as $key => &$val) {
				if($allowNullValues && $val===null)
					continue;
				if($val === null)
					throw new \InvalidArgumentException('Null value found in provided array');
				if(!$val instanceof \Security\InheritedRole)
					$val = new \Security\InheritedRole($val, 'build_internal', $client);
			}
		}
		catch (\Exception $e) {
			throw new \InvalidArgumentException('Element at index '.$key.' could not be converted to object "Security\InheritedRole"!', 42, $e);
		}		

		return $items;
	}

	
}