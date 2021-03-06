<?php
namespace MultiPaint;



require_once __DIR__.'/ArtistJsonConverter.php';
require_once __DIR__.'/ArtistArrayConverter.php';
require_once __DIR__.'/../Security/User.php';

/**
 * Generated from NGS DSL
 *
 * @property string $URI a unique object identifier (read-only)
 * @property string $UserURI reference to an object of class "Security\User" (read-only)
 * @property \Security\User $User an object of class "Security\User"
 * @property string $Name a string
 * @property \NGS\Timestamp $CreatedAt autogenerated by server (read-only)
 * @property \NGS\Timestamp $LastActiveAt a timestamp with time zone
 *
 * @package MultiPaint
 * @version 1.2.5555.22839
 */
class Artist extends \NGS\Patterns\AggregateRoot implements \IteratorAggregate
{
    /**
     * HttpClient bound to this instance
     *
     * @var \NGS\Client\HttpClient
     */
    private $__client__;
	protected $URI;
	protected $UserURI;
	protected $User;
	protected $UserID;
	protected $Name;
	protected $CreatedAt;
	protected $LastActiveAt;

	/**
	 * Constructs object using a key-property array or instance of class "MultiPaint\Artist"
	 *
	 * @param array|void $data key-property array or instance of class "MultiPaint\Artist" or pass void to provide all fields with defaults
	 */
	public function __construct($data = array(), $construction_type = '', \NGS\Client\HttpClient $client = null)
	{ 
		if(is_array($data) && $construction_type !== 'build_internal') {
			foreach($data as $key => $val) {
				if(in_array($key, self::$_read_only_properties, true))
					throw new \LogicException($key.' is a read only property and can\'t be set through the constructor.');
			}
		}
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
		if(!array_key_exists('UserID', $data))
			$data['UserID'] = ''; // a string of length 100
		if(!array_key_exists('Name', $data))
			$data['Name'] = ''; // a string
		if(!array_key_exists('CreatedAt', $data))
			$data['CreatedAt'] = new \NGS\Timestamp(); // a timestamp with time zone
		if(!array_key_exists('LastActiveAt', $data))
			$data['LastActiveAt'] = new \NGS\Timestamp(); // a timestamp with time zone
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
		if (array_key_exists('User', $data))
			$this->setUser($data['User']);
		unset($data['User']);
		if(array_key_exists('UserURI', $data))
			$this->UserURI = \NGS\Converter\PrimitiveConverter::toString($data['UserURI']);
		unset($data['UserURI']);
		if (array_key_exists('UserID', $data))
			$this->setUserID($data['UserID']);
		unset($data['UserID']);
		if (array_key_exists('Name', $data))
			$this->setName($data['Name']);
		unset($data['Name']);
		if (array_key_exists('CreatedAt', $data))
			$this->setCreatedAt($data['CreatedAt']);
		unset($data['CreatedAt']);
		if (array_key_exists('LastActiveAt', $data))
			$this->setLastActiveAt($data['LastActiveAt']);
		unset($data['LastActiveAt']);

		if (count($data) !== 0 && \NGS\Utils::WarningsAsErrors())
			throw new \InvalidArgumentException('Superflous array keys found in "MultiPaint\Artist" constructor: '.implode(', ', array_keys($data)));
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
	 * @return \Security\User a reference to an object of class "Security\User"
	 */
	public function getUserURI()
	{
		return $this->UserURI;
	}

	/**
	 * @return \Security\User an object of class "Security\User"
	 */
	public function getUser()
	{
		if ($this->UserURI !== null && $this->User === null) {
			$proxy = new \NGS\Client\CrudProxy($this->__client__);
			$this->User = $proxy->read('Security\\User', $this->UserURI);
		}
		return $this->User;
	}

	/**
	 * @return string a string of length 100
	 */
	public function getUserID()
	{
		return $this->UserID;
	}

	/**
	 * @return string a string
	 */
	public function getName()
	{
		return $this->Name;
	}

	/**
	 * @return \NGS\Timestamp a timestamp with time zone
	 */
	public function getCreatedAt()
	{
		return $this->CreatedAt;
	}

	/**
	 * @return \NGS\Timestamp a timestamp with time zone
	 */
	public function getLastActiveAt()
	{
		return $this->LastActiveAt;
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
		if ($name === 'UserURI')
			return $this->getUserURI(); // a reference to an object of class "Security\User"
		if ($name === 'User')
			return $this->getUser(); // an object of class "Security\User"
		if ($name === 'UserID')
			return $this->getUserID(); // a string of length 100
		if ($name === 'Name')
			return $this->getName(); // a string
		if ($name === 'CreatedAt')
			return $this->getCreatedAt(); // a timestamp with time zone
		if ($name === 'LastActiveAt')
			return $this->getLastActiveAt(); // a timestamp with time zone

		throw new \InvalidArgumentException('Property "'.$name.'" in class "MultiPaint\Artist" does not exist and could not be retrieved!');
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
		if ($name === 'User')
			return true; // an object of class "Security\User" (always set)
		if ($name === 'Name')
			return true; // a string (always set)
		if ($name === 'LastActiveAt')
			return true; // a timestamp with time zone (always set)

		return false;
	}

	
	private static $_read_only_properties = array('URI', 'UserURI', 'UserID', 'CreatedAt', );

	
	/**
	 * @param \Security\User $value an object of class "Security\User"
	 *
	 * @return \Security\User
	 */
	public function setUser($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "User" cannot be set to null because it is non-nullable!');
		$value = \Security\UserArrayConverter::fromArray($value, $this->__client__);
		if ($value->URI === null)
			throw new \InvalidArgumentException('Value of property "User" cannot have URI set to null because it\'s a reference! Reference values must have non-null URIs!');
		$this->User = $value;
		$this->UserURI = $value->URI;
		$this->UserID = $value->Name;
		return $value;
	}

	/**
	 * @param string $value a string of length 100
	 *
	 * @return string
	 */
	private function setUserID($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "UserID" cannot be set to null because it is non-nullable!');
		$value = \NGS\Converter\PrimitiveConverter::toFixedString($value, 100);
		$this->UserID = $value;
		return $value;
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
	 * @param \NGS\Timestamp $value a timestamp with time zone
	 *
	 * @return \NGS\Timestamp
	 */
	private function setCreatedAt($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "CreatedAt" cannot be set to null because it is non-nullable!');
		$value = new \NGS\Timestamp($value);
		$this->CreatedAt = $value;
		return $value;
	}

	/**
	 * @param \NGS\Timestamp $value a timestamp with time zone
	 *
	 * @return \NGS\Timestamp
	 */
	public function setLastActiveAt($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "LastActiveAt" cannot be set to null because it is non-nullable!');
		$value = new \NGS\Timestamp($value);
		$this->LastActiveAt = $value;
		return $value;
	}


	/**
	 * Property setter which checks for invalid access to entity properties and enforces proper type checks
	 *
	 * @param string $name Property name
	 * @param mixed $value Property value
	 */
	public function __set($name, $value)
	{ 
		if(in_array($name, self::$_read_only_properties, true))
			throw new \LogicException('Property "'.$name.'" in "MultiPaint\Artist" cannot be set, because it is read-only!');
		if ($name === 'User')
			return $this->setUser($value); // an object of class "Security\User"
		if ($name === 'Name')
			return $this->setName($value); // a string
		if ($name === 'LastActiveAt')
			return $this->setLastActiveAt($value); // a timestamp with time zone
		throw new \InvalidArgumentException('Property "'.$name.'" in class "MultiPaint\Artist" does not exist and could not be set!');
	}

	/**
	 * Will unset a property if it exists, but throw an exception if it is not nullable
	 *
	 * @param string $name Property name to unset (set to null)
	 */
	public function __unset($name)
	{ 
		if(in_array($name, self::$_read_only_properties, true))
			throw new \LogicException('Property "'.$name.'" cannot be unset, because it is read-only!');
		if ($name === 'User')
			throw new \LogicException('The property "User" cannot be unset because it is non-nullable!'); // an object of class "Security\User" (cannot be unset)
		if ($name === 'Name')
			throw new \LogicException('The property "Name" cannot be unset because it is non-nullable!'); // a string (cannot be unset)
		if ($name === 'LastActiveAt')
			throw new \LogicException('The property "LastActiveAt" cannot be unset because it is non-nullable!'); // a timestamp with time zone (cannot be unset)
	}

	
	/**
     * Finds one or more objects by one or more URIs.
     * @param string|array Single string or array of strings representing URIs
     * @param \NGS\Client\HttpClient $client Client instance or null for global instance
     * @return \MultiPaint\Artist|\MultiPaint\Artist[] if single string is given, or array of objects
     * @throws \NGS\Client\Exception\NotFoundException When argument is a single string URI and object
     * is not found.
     */
    public static function find($uri, \NGS\Client\HttpClient $client=null)
    {
        if(is_array($uri)) {
            $uri = \NGS\Converter\PrimitiveConverter::toStringArray($uri);
			$proxy = new \NGS\Client\DomainProxy($client);
            return $proxy->find('MultiPaint\Artist', $uri);
        }
        $uri = \NGS\Converter\PrimitiveConverter::toString($uri);
		$proxy = new \NGS\Client\CrudProxy($client);
        return $proxy->read('MultiPaint\Artist', $uri);
    }

	public static function search($limit = null, $offset = null, \NGS\Client\HttpClient $client = null)
	{
		$proxy = new \NGS\Client\DomainProxy($client);
		return $proxy->search('MultiPaint\Artist', $limit, $offset);
	}

	/**
		* Count all objects or count using specification
		* @param \NGS\Patterns\Specification|\NGS\Client\HttpClient Specification or client instance
		* @param \NGS\Client\HttpClient Client instance
		* @return int Total count
		*/
	public static function count($context = null, \NGS\Client\HttpClient $client = null)
	{
		if ($context instanceof \NGS\Patterns\Specification) {
			$proxy = new \NGS\Client\DomainProxy($client);
			return $proxy->countWithSpecification($context);
		}
		if ($context instanceof \NGS\Client\HttpClient || $context === null) {
			$proxy = new \NGS\Client\DomainProxy($context);
			return $proxy->count('MultiPaint\Artist');
		} 
		throw new \InvalidArgumentException('Count argument must be a client or specification instance');
	}

	/**
	 * Creates object on the server.
	 *
	 * @return \MultiPaint\Artist Created object instance
	 */
	public function create()
	{
		
		
		if ($this->UserURI === null && $this->UserID !== null) {
			throw new \LogicException('Cannot persist instance of "MultiPaint\Artist" because reference "User" was not assigned');
		}
		$proxy = new \NGS\Client\CrudProxy($this->__client__);
		$newObject = $proxy->create($this);
		$this->updateWithAnother($newObject);
		
		return $this;
	}

	/**
	 * Updates object on the server.
	 *
	 * @return \MultiPaint\Artist Modified object instance
	 */
	public function update()
	{
		if ($this->URI === null) {
			throw new \LogicException('Cannot update instance of root "'.get_class($this).'" before creating it (instance URI was null).');
		}
		
		
		if ($this->UserURI === null && $this->UserID !== null) {
			throw new \LogicException('Cannot persist instance of "MultiPaint\Artist" because reference "User" was not assigned');
		}
		$proxy = new \NGS\Client\CrudProxy($this->__client__);
		$newObject = $proxy->update($this);
		$this->updateWithAnother($newObject);
		
		return $this;
	}

	/**
	 * Deletes object from the server
	 *
	 * @return \MultiPaint\Artist Deleted object
	 * @throws \LogicException If object instance was created, but not persisted
	 */
	public function delete()
	{
		if ($this->URI === null) {
			throw new \LogicException('Cannot delete instance of root "'.get_class($this).'" because it\'s URI was null.');
		}
		$proxy = new \NGS\Client\CrudProxy($this->__client__);
		return $proxy->delete(get_called_class(), $this->URI);
	}

	private function updateWithAnother(\MultiPaint\Artist $result) 
	{
		$this->URI = $result->URI;
		
		$this->User = $result->User;
		$this->UserURI = $result->UserURI;
		$this->UserID = $result->UserID;
		$this->Name = $result->Name;
		$this->CreatedAt = $result->CreatedAt;
		$this->LastActiveAt = $result->LastActiveAt;
	}

	public function toJson() 
	{
		return \MultiPaint\ArtistJsonConverter::toJson($this);
	}

	public static function fromJson($item) 
	{
		return \MultiPaint\ArtistJsonConverter::fromJson($item);
	}

	
	public function __toString()
	{
		return 'MultiPaint\Artist'.$this->toJson();
	}

	public function __clone()
	{
		return \MultiPaint\ArtistArrayConverter::fromArray(\MultiPaint\ArtistArrayConverter::toArray($this), $this->__client__);
	}

	public function toArray()
	{
		return \MultiPaint\ArtistArrayConverter::toArray($this);
	}

	

	/**
	 * Implementation of the IteratorAggregate interface via \ArrayIterator
	 *
	 * @return \Traversable a new iterator specially created for this iteration
	 */
	public function getIterator()
	{
		return new \ArrayIterator(\MultiPaint\ArtistArrayConverter::toArray($this));
	}

	
	/**
	 * Find data using declared specification ActiveUsers
	 * Search can be limited by $limit and $offset integer arguments
	 *
	 * @return array of objects that satisfy specification
	 */
	public static function ActiveUsers($Since, $limit = null, $offset = null, \NGS\Client\HttpClient $client = null)
	{
		// require_once __DIR__.'/MultiPaint\Artist/ActiveUsers.php';
		$proxy = new \NGS\Client\DomainProxy($client);
		$specification = new \MultiPaint\Artist\ActiveUsers(array('Since' => $Since));
		return $proxy->searchWithSpecification('MultiPaint\Artist', $specification, $limit, $offset);
	}
}