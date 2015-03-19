<?php
namespace Security;



require_once __DIR__.'/InheritedRoleJsonConverter.php';
require_once __DIR__.'/InheritedRoleArrayConverter.php';
require_once __DIR__.'/Role.php';

/**
 * Generated from NGS DSL
 *
 * @property string $URI a unique object identifier (read-only)
 * @property string $RoleURI reference to an object of class "Security\Role" (read-only)
 * @property \Security\Role $Role an object of class "Security\Role"
 * @property string $ParentRoleURI reference to an object of class "Security\Role" (read-only)
 * @property \Security\Role $ParentRole an object of class "Security\Role"
 *
 * @package Security
 * @version 1.2.5555.22839
 */
class InheritedRole extends \NGS\Patterns\AggregateRoot implements \IteratorAggregate
{
    /**
     * HttpClient bound to this instance
     *
     * @var \NGS\Client\HttpClient
     */
    private $__client__;
	protected $URI;
	protected $Name;
	protected $RoleURI;
	protected $Role;
	protected $ParentName;
	protected $ParentRoleURI;
	protected $ParentRole;

	/**
	 * Constructs object using a key-property array or instance of class "Security\InheritedRole"
	 *
	 * @param array|void $data key-property array or instance of class "Security\InheritedRole" or pass void to provide all fields with defaults
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
		if(!array_key_exists('Name', $data))
			$data['Name'] = ''; // a string of length 100
		if(!array_key_exists('ParentName', $data))
			$data['ParentName'] = ''; // a string of length 100
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
		if (array_key_exists('Role', $data))
			$this->setRole($data['Role']);
		unset($data['Role']);
		if(array_key_exists('RoleURI', $data))
			$this->RoleURI = \NGS\Converter\PrimitiveConverter::toString($data['RoleURI']);
		unset($data['RoleURI']);
		if (array_key_exists('ParentName', $data))
			$this->setParentName($data['ParentName']);
		unset($data['ParentName']);
		if (array_key_exists('ParentRole', $data))
			$this->setParentRole($data['ParentRole']);
		unset($data['ParentRole']);
		if(array_key_exists('ParentRoleURI', $data))
			$this->ParentRoleURI = \NGS\Converter\PrimitiveConverter::toString($data['ParentRoleURI']);
		unset($data['ParentRoleURI']);

		if (count($data) !== 0 && \NGS\Utils::WarningsAsErrors())
			throw new \InvalidArgumentException('Superflous array keys found in "Security\InheritedRole" constructor: '.implode(', ', array_keys($data)));
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
	 * @return string a string of length 100
	 */
	public function getName()
	{
		return $this->Name;
	}

	/**
	 * @return \Security\Role a reference to an object of class "Security\Role"
	 */
	public function getRoleURI()
	{
		return $this->RoleURI;
	}

	/**
	 * @return \Security\Role an object of class "Security\Role"
	 */
	public function getRole()
	{
		if ($this->RoleURI !== null && $this->Role === null) {
			$proxy = new \NGS\Client\CrudProxy($this->__client__);
			$this->Role = $proxy->read('Security\\Role', $this->RoleURI);
		}
		return $this->Role;
	}

	/**
	 * @return string a string of length 100
	 */
	public function getParentName()
	{
		return $this->ParentName;
	}

	/**
	 * @return \Security\Role a reference to an object of class "Security\Role"
	 */
	public function getParentRoleURI()
	{
		return $this->ParentRoleURI;
	}

	/**
	 * @return \Security\Role an object of class "Security\Role"
	 */
	public function getParentRole()
	{
		if ($this->ParentRoleURI !== null && $this->ParentRole === null) {
			$proxy = new \NGS\Client\CrudProxy($this->__client__);
			$this->ParentRole = $proxy->read('Security\\Role', $this->ParentRoleURI);
		}
		return $this->ParentRole;
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
			return $this->getName(); // a string of length 100
		if ($name === 'RoleURI')
			return $this->getRoleURI(); // a reference to an object of class "Security\Role"
		if ($name === 'Role')
			return $this->getRole(); // an object of class "Security\Role"
		if ($name === 'ParentName')
			return $this->getParentName(); // a string of length 100
		if ($name === 'ParentRoleURI')
			return $this->getParentRoleURI(); // a reference to an object of class "Security\Role"
		if ($name === 'ParentRole')
			return $this->getParentRole(); // an object of class "Security\Role"

		throw new \InvalidArgumentException('Property "'.$name.'" in class "Security\InheritedRole" does not exist and could not be retrieved!');
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
		if ($name === 'Role')
			return true; // an object of class "Security\Role" (always set)
		if ($name === 'ParentRole')
			return true; // an object of class "Security\Role" (always set)

		return false;
	}

	
	private static $_read_only_properties = array('URI', 'Name', 'RoleURI', 'ParentName', 'ParentRoleURI', );

	
	/**
	 * @param string $value a string of length 100
	 *
	 * @return string
	 */
	private function setName($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "Name" cannot be set to null because it is non-nullable!');
		$value = \NGS\Converter\PrimitiveConverter::toFixedString($value, 100);
		$this->Name = $value;
		return $value;
	}

	/**
	 * @param \Security\Role $value an object of class "Security\Role"
	 *
	 * @return \Security\Role
	 */
	public function setRole($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "Role" cannot be set to null because it is non-nullable!');
		$value = \Security\RoleArrayConverter::fromArray($value, $this->__client__);
		if ($value->URI === null)
			throw new \InvalidArgumentException('Value of property "Role" cannot have URI set to null because it\'s a reference! Reference values must have non-null URIs!');
		$this->Role = $value;
		$this->RoleURI = $value->URI;
		$this->Name = $value->Name;
		return $value;
	}

	/**
	 * @param string $value a string of length 100
	 *
	 * @return string
	 */
	private function setParentName($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "ParentName" cannot be set to null because it is non-nullable!');
		$value = \NGS\Converter\PrimitiveConverter::toFixedString($value, 100);
		$this->ParentName = $value;
		return $value;
	}

	/**
	 * @param \Security\Role $value an object of class "Security\Role"
	 *
	 * @return \Security\Role
	 */
	public function setParentRole($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "ParentRole" cannot be set to null because it is non-nullable!');
		$value = \Security\RoleArrayConverter::fromArray($value, $this->__client__);
		if ($value->URI === null)
			throw new \InvalidArgumentException('Value of property "ParentRole" cannot have URI set to null because it\'s a reference! Reference values must have non-null URIs!');
		$this->ParentRole = $value;
		$this->ParentRoleURI = $value->URI;
		$this->ParentName = $value->Name;
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
			throw new \LogicException('Property "'.$name.'" in "Security\InheritedRole" cannot be set, because it is read-only!');
		if ($name === 'Role')
			return $this->setRole($value); // an object of class "Security\Role"
		if ($name === 'ParentRole')
			return $this->setParentRole($value); // an object of class "Security\Role"
		throw new \InvalidArgumentException('Property "'.$name.'" in class "Security\InheritedRole" does not exist and could not be set!');
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
		if ($name === 'Role')
			throw new \LogicException('The property "Role" cannot be unset because it is non-nullable!'); // an object of class "Security\Role" (cannot be unset)
		if ($name === 'ParentRole')
			throw new \LogicException('The property "ParentRole" cannot be unset because it is non-nullable!'); // an object of class "Security\Role" (cannot be unset)
	}

	
	/**
     * Finds one or more objects by one or more URIs.
     * @param string|array Single string or array of strings representing URIs
     * @param \NGS\Client\HttpClient $client Client instance or null for global instance
     * @return \Security\InheritedRole|\Security\InheritedRole[] if single string is given, or array of objects
     * @throws \NGS\Client\Exception\NotFoundException When argument is a single string URI and object
     * is not found.
     */
    public static function find($uri, \NGS\Client\HttpClient $client=null)
    {
        if(is_array($uri)) {
            $uri = \NGS\Converter\PrimitiveConverter::toStringArray($uri);
			$proxy = new \NGS\Client\DomainProxy($client);
            return $proxy->find('Security\InheritedRole', $uri);
        }
        $uri = \NGS\Converter\PrimitiveConverter::toString($uri);
		$proxy = new \NGS\Client\CrudProxy($client);
        return $proxy->read('Security\InheritedRole', $uri);
    }

	public static function search($limit = null, $offset = null, \NGS\Client\HttpClient $client = null)
	{
		$proxy = new \NGS\Client\DomainProxy($client);
		return $proxy->search('Security\InheritedRole', $limit, $offset);
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
			return $proxy->count('Security\InheritedRole');
		} 
		throw new \InvalidArgumentException('Count argument must be a client or specification instance');
	}

	/**
	 * Creates object on the server.
	 *
	 * @return \Security\InheritedRole Created object instance
	 */
	public function create()
	{
		
		
		if ($this->RoleURI === null && $this->Name !== null) {
			throw new \LogicException('Cannot persist instance of "Security\InheritedRole" because reference "Role" was not assigned');
		}
		if ($this->ParentRoleURI === null && $this->ParentName !== null) {
			throw new \LogicException('Cannot persist instance of "Security\InheritedRole" because reference "ParentRole" was not assigned');
		}
		$proxy = new \NGS\Client\CrudProxy($this->__client__);
		$newObject = $proxy->create($this);
		$this->updateWithAnother($newObject);
		
		return $this;
	}

	/**
	 * Updates object on the server.
	 *
	 * @return \Security\InheritedRole Modified object instance
	 */
	public function update()
	{
		if ($this->URI === null) {
			throw new \LogicException('Cannot update instance of root "'.get_class($this).'" before creating it (instance URI was null).');
		}
		
		
		if ($this->RoleURI === null && $this->Name !== null) {
			throw new \LogicException('Cannot persist instance of "Security\InheritedRole" because reference "Role" was not assigned');
		}
		if ($this->ParentRoleURI === null && $this->ParentName !== null) {
			throw new \LogicException('Cannot persist instance of "Security\InheritedRole" because reference "ParentRole" was not assigned');
		}
		$proxy = new \NGS\Client\CrudProxy($this->__client__);
		$newObject = $proxy->update($this);
		$this->updateWithAnother($newObject);
		
		return $this;
	}

	/**
	 * Deletes object from the server
	 *
	 * @return \Security\InheritedRole Deleted object
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

	private function updateWithAnother(\Security\InheritedRole $result) 
	{
		$this->URI = $result->URI;
		
		$this->Name = $result->Name;
		$this->Role = $result->Role;
		$this->RoleURI = $result->RoleURI;
		$this->ParentName = $result->ParentName;
		$this->ParentRole = $result->ParentRole;
		$this->ParentRoleURI = $result->ParentRoleURI;
	}

	public function toJson() 
	{
		return \Security\InheritedRoleJsonConverter::toJson($this);
	}

	public static function fromJson($item) 
	{
		return \Security\InheritedRoleJsonConverter::fromJson($item);
	}

	
	public function __toString()
	{
		return 'Security\InheritedRole'.$this->toJson();
	}

	public function __clone()
	{
		return \Security\InheritedRoleArrayConverter::fromArray(\Security\InheritedRoleArrayConverter::toArray($this), $this->__client__);
	}

	public function toArray()
	{
		return \Security\InheritedRoleArrayConverter::toArray($this);
	}

	

	/**
	 * Implementation of the IteratorAggregate interface via \ArrayIterator
	 *
	 * @return \Traversable a new iterator specially created for this iteration
	 */
	public function getIterator()
	{
		return new \ArrayIterator(\Security\InheritedRoleArrayConverter::toArray($this));
	}

	
}