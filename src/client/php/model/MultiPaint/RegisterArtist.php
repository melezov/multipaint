<?php
namespace MultiPaint;



require_once __DIR__.'/RegisterArtistJsonConverter.php';
require_once __DIR__.'/RegisterArtistArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * @property string $URI a unique object identifier (read-only)
 * @property string $Name a string
 * @property string $UserID a string, can be null
 * @property string $Password a string, can be null
 *
 * @package MultiPaint
 * @version 1.2.5555.22839
 */
class RegisterArtist extends \NGS\Patterns\DomainEvent
{
    /**
     * HttpClient bound to this instance
     *
     * @var \NGS\Client\HttpClient
     */
    private $__client__;
	protected $URI;
	protected $Name;
	protected $UserID;
	protected $Password;

	/**
	 * Constructs object using a key-property array or instance of class "MultiPaint\RegisterArtist"
	 *
	 * @param array|void $data key-property array or instance of class "MultiPaint\RegisterArtist" or pass void to provide all fields with defaults
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
		if(!array_key_exists('Name', $data))
			$data['Name'] = ''; // a string
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
		if (array_key_exists('Name', $data))
			$this->setName($data['Name']);
		unset($data['Name']);
		if (array_key_exists('UserID', $data))
			$this->setUserID($data['UserID']);
		unset($data['UserID']);
		if (array_key_exists('Password', $data))
			$this->setPassword($data['Password']);
		unset($data['Password']);

		if (count($data) !== 0 && \NGS\Utils::WarningsAsErrors())
			throw new \InvalidArgumentException('Superflous array keys found in "MultiPaint\RegisterArtist" constructor: '.implode(', ', array_keys($data)));
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
	public function getName()
	{
		return $this->Name;
	}

	/**
	 * @return string a string, can be null
	 */
	public function getUserID()
	{
		return $this->UserID;
	}

	/**
	 * @return string a string, can be null
	 */
	public function getPassword()
	{
		return $this->Password;
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
		if ($name === 'Name')
			return $this->getName(); // a string
		if ($name === 'UserID')
			return $this->getUserID(); // a string, can be null
		if ($name === 'Password')
			return $this->getPassword(); // a string, can be null

		throw new \InvalidArgumentException('Property "'.$name.'" in class "MultiPaint\RegisterArtist" does not exist and could not be retrieved!');
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
		if ($name === 'Name')
			return true; // a string (always set)
		if ($name === 'UserID')
			return $this->getUserID() !== null; // a string, can be null
		if ($name === 'Password')
			return $this->getPassword() !== null; // a string, can be null

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

	private function updateWithAnother(\MultiPaint\RegisterArtist $result) 
	{
		$this->URI = $result->URI;
		
		$this->Name = $result->Name;
		$this->UserID = $result->UserID;
		$this->Password = $result->Password;
	}
	
	/**
	 * @param string $value a string
	 *
	 * @return string
	 */
	public function setName($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "Name" cannot be set to null because it is non-nullable!');
		$value = \NGS\Converter\PrimitiveConverter::toString($value);
		$this->Name = $value;
		return $value;
	}

	/**
	 * @param string $value a string, can be null
	 *
	 * @return string
	 */
	public function setUserID($value)
	{
		$value = $value !== null ? \NGS\Converter\PrimitiveConverter::toString($value) : null;
		$this->UserID = $value;
		return $value;
	}

	/**
	 * @param string $value a string, can be null
	 *
	 * @return string
	 */
	public function setPassword($value)
	{
		$value = $value !== null ? \NGS\Converter\PrimitiveConverter::toString($value) : null;
		$this->Password = $value;
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
			throw new \LogicException('Property "URI" in "MultiPaint\RegisterArtist" cannot be set, because event URI is populated by server!');
		if ($name === 'Name')
			return $this->setName($value); // a string
		if ($name === 'UserID')
			return $this->setUserID($value); // a string, can be null
		if ($name === 'Password')
			return $this->setPassword($value); // a string, can be null
		throw new \InvalidArgumentException('Property "'.$name.'" in class "MultiPaint\RegisterArtist" does not exist and could not be set!');
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
		if ($name === 'Name')
			throw new \LogicException('The property "Name" cannot be unset because it is non-nullable!'); // a string (cannot be unset)
		if ($name === 'UserID')
			$this->setUserID(null);; // a string, can be null
		if ($name === 'Password')
			$this->setPassword(null);; // a string, can be null
	}

	

	public function toJson() 
	{
		return \MultiPaint\RegisterArtistJsonConverter::toJson($this);
	}

	public static function fromJson($item) 
	{
		return \MultiPaint\RegisterArtistJsonConverter::fromJson($item);
	}

	
	public function __toString()
	{
		return 'MultiPaint\RegisterArtist'.$this->toJson();
	}

	public function __clone()
	{
		return \MultiPaint\RegisterArtistArrayConverter::fromArray(\MultiPaint\RegisterArtistArrayConverter::toArray($this));
	}

	public function toArray()
	{
		return \MultiPaint\RegisterArtistArrayConverter::toArray($this);
	}

	
}