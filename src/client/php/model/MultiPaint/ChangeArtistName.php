<?php
namespace MultiPaint;



require_once __DIR__.'/ChangeArtistNameJsonConverter.php';
require_once __DIR__.'/ChangeArtistNameArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * @property string $URI a unique object identifier (read-only)
 * @property string $NewName a string
 *
 * @package MultiPaint
 * @version 1.2.5555.22839
 */
class ChangeArtistName extends \NGS\Patterns\DomainEvent
{
    /**
     * HttpClient bound to this instance
     *
     * @var \NGS\Client\HttpClient
     */
    private $__client__;
	protected $URI;
	protected $NewName;

	/**
	 * Constructs object using a key-property array or instance of class "MultiPaint\ChangeArtistName"
	 *
	 * @param array|void $data key-property array or instance of class "MultiPaint\ChangeArtistName" or pass void to provide all fields with defaults
	 */
	public function __construct($data = array(), \NGS\Client\HttpClient $client = null)
	{ 
		$this->__client__ = $client !== null ? $client : \NGS\Client\HttpClient::instance();
		if (is_array($data)) {
			$this->fromArray($data);
		} else {
			throw new \InvalidArgumentException('Constructor parameter must be an array! Type was: '.\NGS\Utils::getType($data));
		}
	}

	/**
	 * Supply default values for uninitialized properties
	 *
	 * @param array $data key-property array which will be filled in-place
	 */
	private static function provideDefaults(array &$data)
	{
		if(!array_key_exists('URI', $data)) 
			$data['URI'] = null; //a string representing a unique object identifier
		if(!array_key_exists('NewName', $data))
			$data['NewName'] = ''; // a string
	}

	/**
	 * Constructs object from a key-property array
	 *
	 * @param array $data key-property array
	 */
	private function fromArray(array $data)
	{
		$this->provideDefaults($data);

		
		if(isset($data['URI']))
			$this->URI = \NGS\Converter\PrimitiveConverter::toString($data['URI']);
		unset($data['URI']);
		if (array_key_exists('NewName', $data))
			$this->setNewName($data['NewName']);
		unset($data['NewName']);

		if (count($data) !== 0 && \NGS\Utils::WarningsAsErrors())
			throw new \InvalidArgumentException('Superflous array keys found in "MultiPaint\ChangeArtistName" constructor: '.implode(', ', array_keys($data)));
	}

	
// ============================================================================

	/**
	 * Helper getter function, body for magic method $this->__get('URI')
	 * URI is a string representation of the primary key.
	 *
	 * @return string unique resource identifier representing this object
	 */
	public function getURI()
	{
		return $this->URI;
	}
	
	/**
	 * @return string a string
	 */
	public function getNewName()
	{
		return $this->NewName;
	}


	/**
	 * Property getter which throws Exceptions on invalid access
	 *
	 * @param string $name Property name
	 *
	 * @return mixed
	 */
	public function __get($name)
	{
		if ($name === 'URI')
			return $this->getURI(); // a string representing a unique object identifier
		if ($name === 'NewName')
			return $this->getNewName(); // a string

		throw new \InvalidArgumentException('Property "'.$name.'" in class "MultiPaint\ChangeArtistName" does not exist and could not be retrieved!');
	}

	
// ============================================================================

	/**
	 * Property existence checker
	 *
	 * @param string $name Property name to check for existence
	 *
	 * @return bool will return true if and only if the property exist and is not null
	 */
	public function __isset($name)
	{ 
		if ($name === 'URI')
			return $this->URI !== null;
		if ($name === 'NewName')
			return true; // a string (always set)

		return false;
	}

	
	/**
     * Submits event
     *
     * @return string Created event URI
     */
	public function submit()
	{
		$proxy = new \NGS\Client\DomainProxy($this->__client__);
		$processedEvent = $proxy->submitEvent($this, true);
		$this->updateWithAnother($processedEvent);
		return $this->URI;
	}

	private function updateWithAnother(\MultiPaint\ChangeArtistName $result) 
	{
		$this->URI = $result->URI;
		
		$this->NewName = $result->NewName;
	}
	
	/**
	 * @param string $value a string
	 *
	 * @return string
	 */
	public function setNewName($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "NewName" cannot be set to null because it is non-nullable!');
		$value = \NGS\Converter\PrimitiveConverter::toString($value);
		$this->NewName = $value;
		return $value;
	}


	/**
	 * Property setter which checks for invalid access to domain event properties and enforces proper type checks
	 *
	 * @param string $name Property name
	 * @param mixed $value Property value
	 */
	public function __set($name, $value)
	{ 
		if ($name === 'URI')
			throw new \LogicException('Property "URI" in "MultiPaint\ChangeArtistName" cannot be set, because event URI is populated by server!');
		if ($name === 'NewName')
			return $this->setNewName($value); // a string
		throw new \InvalidArgumentException('Property "'.$name.'" in class "MultiPaint\ChangeArtistName" does not exist and could not be set!');
	}

	/**
	 * Will unset a property if it exists, but throw an exception if it is not nullable
	 *
	 * @param string $name Property name to unset (set to null)
	 */
	public function __unset($name)
	{ 
		if ($name === 'URI')
			throw new \LogicException('The property "URI" cannot be unset because event URI is created by server!');
		if ($name === 'NewName')
			throw new \LogicException('The property "NewName" cannot be unset because it is non-nullable!'); // a string (cannot be unset)
	}

	

	public function toJson() 
	{
		return \MultiPaint\ChangeArtistNameJsonConverter::toJson($this);
	}

	public static function fromJson($item) 
	{
		return \MultiPaint\ChangeArtistNameJsonConverter::fromJson($item);
	}

	
	public function __toString()
	{
		return 'MultiPaint\ChangeArtistName'.$this->toJson();
	}

	public function __clone()
	{
		return \MultiPaint\ChangeArtistNameArrayConverter::fromArray(\MultiPaint\ChangeArtistNameArrayConverter::toArray($this));
	}

	public function toArray()
	{
		return \MultiPaint\ChangeArtistNameArrayConverter::toArray($this);
	}

	
}