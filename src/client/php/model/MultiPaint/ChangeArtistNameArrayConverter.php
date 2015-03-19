<?php
namespace MultiPaint;



require_once __DIR__.'/ChangeArtistName.php';

/**
 * Generated from NGS DSL
 *
 * Converts an object of class MultiPaint\ChangeArtistName into a simple array and backwards.
 *
 * @package MultiPaint
 * @version 1.2.5555.22839
 */
abstract class ChangeArtistNameArrayConverter
{/**
	 * @param array|\MultiPaint\ChangeArtistName An object or an array of objects of type "MultiPaint\ChangeArtistName"
	 *
	 * @return array A simple array representation
	 */
	public static function toArray($item, $allowNullValues=false)
	{
		if ($item instanceof \MultiPaint\ChangeArtistName)
			return self::toArrayObject($item);
		if (is_array($item))
			return self::toArrayList($item, $allowNullValues);

		throw new \InvalidArgumentException('Argument was not an instance of class "MultiPaint\ChangeArtistName" nor an array of said instances!');
	}

	private static function toArrayObject($item)
	{
		$ret = array();
		$ret['URI'] = $item->URI;
		$ret['NewName'] = $item->NewName;
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
				if (!$val instanceof \MultiPaint\ChangeArtistName)
					throw new \InvalidArgumentException('Element with index "'.$key.'" was not an object of class "MultiPaint\ChangeArtistName"! Type was: '.\NGS\Utils::getType($val));

				$ret[] = $val->toArray();
			}
		}

		return $ret;
	}

	public static function fromArray($item, \NGS\Client\HttpClient $client = null)
	{
		if ($item instanceof \MultiPaint\ChangeArtistName)
			return $item;
		if (is_array($item))
			return new \MultiPaint\ChangeArtistName($item);

		throw new \InvalidArgumentException('Argument was not an instance of class "MultiPaint\ChangeArtistName" nor an array of said instances!');
	}

	public static function fromArrayList(array $items, $allowNullValues=false, \NGS\Client\HttpClient $client = null)
	{
		try {
			foreach($items as $key => &$val) {
				if($allowNullValues && $val===null)
					continue;
				if($val === null)
					throw new \InvalidArgumentException('Null value found in provided array');
				if(!$val instanceof \MultiPaint\ChangeArtistName)
					$val = new \MultiPaint\ChangeArtistName($val);
			}
		}
		catch (\Exception $e) {
			throw new \InvalidArgumentException('Element at index '.$key.' could not be converted to object "MultiPaint\ChangeArtistName"!', 42, $e);
		}		

		return $items;
	}

	
}