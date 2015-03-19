<?php
namespace MultiPaint\Artist;



require_once __DIR__.'/ActiveUsersJsonConverter.php';
require_once __DIR__.'/ActiveUsersArrayConverter.php';
require_once __DIR__.'/../Artist.php';

/**
 * Generated from NGS DSL
 *
 * @property \NGS\Timestamp $Since a timestamp with time zone
 *
 * @package MultiPaint
 * @version 1.2.5555.22839
 */
class ActiveUsers extends \NGS\Patterns\Specification
{
    /**
     * HttpClient bound to this instance
     *
     * @var \NGS\Client\HttpClient
     */
    private $__client__;
	protected $Since;

	/**
	 * Constructs object using a key-property array or instance of class "MultiPaint\Artist\ActiveUsers"
	 *
	 * @param array|void $data key-property array or instance of class "MultiPaint\Artist\ActiveUsers" or pass void to provide all fields with defaults
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
		if(!array_key_exists('Since', $data))
			$data['Since'] = new \NGS\Timestamp(); // a timestamp with time zone
	}

	/**
	 * Constructs object from a key-property array
	 *
	 * @param array $data key-property array
	 */
	private function fromArray(array $data)
	{
		$this->provideDefaults($data);

		
		if (array_key_exists('Since', $data))
			$this->setSince($data['Since']);
		unset($data['Since']);

		if (count($data) !== 0 && \NGS\Utils::WarningsAsErrors())
			throw new \InvalidArgumentException('Superflous array keys found in "MultiPaint\Artist\ActiveUsers" constructor: '.implode(', ', array_keys($data)));
	}

	
// ============================================================================

	
	/**
	 * @return \NGS\Timestamp a timestamp with time zone
	 */
	public function getSince()
	{
		return $this->Since;
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
		if ($name === 'Since')
			return $this->getSince(); // a timestamp with time zone

		throw new \InvalidArgumentException('Property "'.$name.'" in class "MultiPaint\Artist\ActiveUsers" does not exist and could not be retrieved!');
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
		if ($name === 'Since')
			return true; // a timestamp with time zone (always set)

		return false;
	}

	
	
	/**
	 * @param \NGS\Timestamp $value a timestamp with time zone
	 *
	 * @return \NGS\Timestamp
	 */
	public function setSince($value)
	{
		if ($value === null)
			throw new \InvalidArgumentException('Property "Since" cannot be set to null because it is non-nullable!');
		$value = new \NGS\Timestamp($value);
		$this->Since = $value;
		return $value;
	}


	/**
	 * Property setter which checks for invalid access to specification properties and enforces proper type checks
	 *
	 * @param string $name Property name
	 * @param mixed $value Property value
	 */
	public function __set($name, $value)
	{ 
		if ($name === 'Since')
			return $this->setSince($value); // a timestamp with time zone
		throw new \InvalidArgumentException('Property "'.$name.'" in class "MultiPaint\Artist\ActiveUsers" does not exist and could not be set!');
	}

	/**
	 * Will unset a property if it exists, but throw an exception if it is not nullable
	 *
	 * @param string $name Property name to unset (set to null)
	 */
	public function __unset($name)
	{ 
		if ($name === 'Since')
			throw new \LogicException('The property "Since" cannot be unset because it is non-nullable!'); // a timestamp with time zone (cannot be unset)
	}

	
	/**
     * Search domain object using conditions in specification
     *
     * @param type $limit
     * @param type $offset
     * @param array $order
     * @return array Array of found objects, or empty array if none found
     */
    public function search($limit = null, $offset = null, array $order = null)
    {
        $class = get_class($this);
        $target = substr($class, 0, strrpos($class, '\\'));
        $proxy = new \NGS\Client\DomainProxy($this->__client__);
        return $proxy->searchWithSpecification($target, $this, $limit, $offset, $order);
    }

    /**
     * Count domain object using conditions in specification
     *
     * @return int
     */
    public function count()
    {
        $proxy = new \NGS\Client\DomainProxy($this->__client__);
        return $proxy->countWithSpecification($this);
    }

    /**
     * Creates an instance of SearchBuilder from specification.
     *
     * @see \NGS\Patterns\SearchBuilder
     * @return \NGS\Patterns\SearchBuilder
     */
    public function builder()
    {
        return new \NGS\Patterns\SearchBuilder($this, $this->__client__);
    }

	public function toJson() 
	{
		return \MultiPaint\Artist\ActiveUsersJsonConverter::toJson($this);
	}

	public static function fromJson($item) 
	{
		return \MultiPaint\Artist\ActiveUsersJsonConverter::fromJson($item);
	}

	
	public function __toString()
	{
		return 'MultiPaint\Artist\ActiveUsers'.$this->toJson();
	}

	public function __clone()
	{
		return \MultiPaint\Artist\ActiveUsersArrayConverter::fromArray(\MultiPaint\Artist\ActiveUsersArrayConverter::toArray($this));
	}

	public function toArray()
	{
		return \MultiPaint\Artist\ActiveUsersArrayConverter::toArray($this);
	}

	
}