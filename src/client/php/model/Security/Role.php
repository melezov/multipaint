<?php
namespace Security;

require_once __DIR__.'/RoleJsonConverter.php';
require_once __DIR__.'/RoleArrayConverter.php';

/**
 * Generated from NGS DSL
 *
 * @property string $URI a unique object identifier (read-only)
 * @property string $Name a string of length 100
 *
 * @package Security
 * @version 1.0.0.23658
 */
class Role extends \NGS\Patterns\AggregateRoot implements \IteratorAggregate
{
    /**
     * HttpClient bound to this instance
     *
     * @var \NGS\Client\HttpClient
     */
    private $__client__;
    protected $URI;
    protected $Name;

    /**
     * Constructs object using a key-property array or instance of class "Security\Role"
     *
     * @param array|void $data key-property array or instance of class "Security\Role" or pass void to provide all fields with defaults
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

        if (count($data) !== 0 && \NGS\Utils::WarningsAsErrors())
            throw new \InvalidArgumentException('Superflous array keys found in "Security\Role" constructor: '.implode(', ', array_keys($data)));
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

        throw new \InvalidArgumentException('Property "'.$name.'" in class "Security\Role" does not exist and could not be retrieved!');
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
            return true; // a string of length 100 (always set)

        return false;
    }

    private static $_read_only_properties = array('URI', );

    /**
     * @param string $value a string of length 100
     *
     * @return string
     */
    public function setName($value)
    {
        if ($value === null)
            throw new \InvalidArgumentException('Property "Name" cannot be set to null because it is non-nullable!');
        $value = \NGS\Converter\PrimitiveConverter::toFixedString($value, 100);
        $this->Name = $value;
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
            throw new \LogicException('Property "'.$name.'" in "Security\Role" cannot be set, because it is read-only!');
        if ($name === 'Name')
            return $this->setName($value); // a string of length 100
        throw new \InvalidArgumentException('Property "'.$name.'" in class "Security\Role" does not exist and could not be set!');
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
        if ($name === 'Name')
            throw new \LogicException('The property "Name" cannot be unset because it is non-nullable!'); // a string of length 100 (cannot be unset)
    }

    /**
     * Finds one or more objects by one or more URIs.
     * @param string|array Single string or array of strings representing URIs
     * @param \NGS\Client\HttpClient $client Client instance or null for global instance
     * @return \Security\Role|\Security\Role[] if single string is given, or array of objects
     * @throws \NGS\Client\Exception\NotFoundException When argument is a single string URI and object
     * is not found.
     */
    public static function find($uri, \NGS\Client\HttpClient $client=null)
    {
        if(is_array($uri)) {
            $uri = \NGS\Converter\PrimitiveConverter::toStringArray($uri);
            $proxy = new \NGS\Client\DomainProxy($client);
            return $proxy->find('Security\Role', $uri);
        }
        $uri = \NGS\Converter\PrimitiveConverter::toString($uri);
        $proxy = new \NGS\Client\CrudProxy($client);
        return $proxy->read('Security\Role', $uri);
    }
    /**
     * Checks if object with given URI exists. It won't throw an exception if
     * object is not found (as Identifiable::find would).
     * @param string $uri Object URI
     * @param \NGS\Client\HttpClient $client Client instance or null for global instance
     * @return bool True if object was found, false otherwise.
     */
    public static function exists($uri, \NGS\Client\HttpClient $client=null)
    {
        $uri = \NGS\Converter\PrimitiveConverter::toString($uri);
        $res = self::find(array($uri));
        return !empty($res);
    }

    public static function search($limit = null, $offset = null, \NGS\Client\HttpClient $client = null)
    {
        $proxy = new \NGS\Client\DomainProxy($client);
        return $proxy->search('Security\Role', $limit, $offset);
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
            return $proxy->count('Security\Role');
        }
        throw new \InvalidArgumentException('Count argument must be a client or specification instance');
    }
        public static function findAll($limit = null, $offset = null, \NGS\Client\HttpClient $client = null)
        {
            return static::search($limit, $offset, $client);
        }

    /**
     * Persists object on the server.
     * Insert is performed if object's URI is not set, otherwise, if URI is set,
     * current object is updated.
     *
     * @return \Security\Role Modified object instance
     */
    public function persist()
    {
        return $this->getURI() === null
            ? $this->create()
            : $this->update();
    }

    /**
     * Creates object on the server.
     *
     * @return \Security\Role Created object instance
     */
    public function create()
    {

        $proxy = new \NGS\Client\CrudProxy($this->__client__);
        $newObject = $proxy->create($this);
        $this->updateWithAnother($newObject);

        return $this;
    }

    /**
     * Updates object on the server.
     *
     * @return \Security\Role Modified object instance
     */
    public function update()
    {
        if ($this->URI === null) {
            throw new \LogicException('Cannot update instance of root "'.get_class($this).'" before creating it (instance URI was null).');
        }

        $proxy = new \NGS\Client\CrudProxy($this->__client__);
        $newObject = $proxy->update($this);
        $this->updateWithAnother($newObject);

        return $this;
    }

    /**
     * Deletes object from the server
     *
     * @return \Security\Role Deleted object
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

    private function updateWithAnother(\Security\Role $result)
    {
        $this->URI = $result->URI;

        $this->Name = $result->Name;
    }
    private static $_Artist;
    /**
     * Static instance: Artist
     *
     * @return \Security\Role object of type \Security\Role
     */
    public static function Artist()
    {
        if (self::$_Artist === null)
            self::$_Artist = self::find('Artist');
        return self::$_Artist;
    }

    /**
     * Static instances
     *
     * @return \Security\Role[] array of all static instances of type \Security\Role
     */
    public static function getStaticValues()
    {
        $result = array();
        $result[] = self::Artist();
        return $result;
    }

    public function toJson()
    {
        return \Security\RoleJsonConverter::toJson($this);
    }

    public static function fromJson($item)
    {
        return \Security\RoleJsonConverter::fromJson($item);
    }

    public function __toString()
    {
        return 'Security\Role'.$this->toJson();
    }

    public function __clone()
    {
        return \Security\RoleArrayConverter::fromArray(\Security\RoleArrayConverter::toArray($this), $this->__client__);
    }

    public function toArray()
    {
        return \Security\RoleArrayConverter::toArray($this);
    }

    /**
     * Implementation of the IteratorAggregate interface via \ArrayIterator
     *
     * @return \Traversable a new iterator specially created for this iteration
     */
    public function getIterator()
    {
        return new \ArrayIterator(\Security\RoleArrayConverter::toArray($this));
    }
}
