package net.multipaint.Security

import hr.ngs.patterns._




class User @com.fasterxml.jackson.annotation.JsonIgnore  private(
	  private var _URI: String,
	  private var _Name: String,
	  @transient private var _Role: net.multipaint.Security.Role,
	  private var _RoleURI: String,
	  private var _PasswordHash: Array[Byte],
	  private var _IsAllowed: Boolean,
	  @transient private val __locator: Option[IServiceLocator]
	) extends Serializable with Revenj.Security.IUser with IIdentifiable {
	
	
	
	
	@com.fasterxml.jackson.annotation.JsonProperty("URI")
	def URI = { 
		_URI
	}

	
	private [multipaint] def URI_= (value: String) { 
		_URI = value
		
	}

	
	override def hashCode = URI.hashCode
	override def equals(o: Any) = o match {
		case c: User => c.URI == URI
		case _ => false
	}

	override def toString = "User("+ URI +")"
	
		
	 def copy(Role: net.multipaint.Security.Role = null, PasswordHash: Array[Byte] = this._PasswordHash, IsAllowed: Boolean = this._IsAllowed): User = {
		

			
	require(PasswordHash ne null, "Null value was provided for property \"PasswordHash\"")
		new User(_URI = this.URI, __locator = this.__locator, _Name = if(Role != null) Role.Name else this._Name, _Role = if(Role != null) Role else _Role, _RoleURI = if (Role != null) Role.URI else this._RoleURI, _PasswordHash = PasswordHash, _IsAllowed = IsAllowed)
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("Name")
	 def Name = { 
		_Name
	}

	
	private [multipaint] def Name_= (value: String) { 
		_Name = value
		
	}

	
	
	def Role = { 
	if(__locator.isDefined) {
			if (_Role == null || _Role.URI != RoleURI)
				_Role = __locator.get.resolve[net.multipaint.Security.IRoleRepository].find(RoleURI).orNull
		}			
		_Role
	}

	
	def Role_= (value: net.multipaint.Security.Role) { 
		_Role = value
		
		
		if(Name != value.Name)
			Name = value.Name
		_RoleURI = value.URI
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("RoleURI")
	def RoleURI = {
		
		_RoleURI
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("PasswordHash")
	def PasswordHash = { 
		_PasswordHash
	}

	
	def PasswordHash_= (value: Array[Byte]) { 
		_PasswordHash = value
		
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("IsAllowed")
	def IsAllowed = { 
		_IsAllowed
	}

	
	def IsAllowed_= (value: Boolean) { 
		_IsAllowed = value
		
	}

	
	@com.fasterxml.jackson.annotation.JsonCreator private def this(
		@com.fasterxml.jackson.annotation.JacksonInject("__locator") __locator__ : IServiceLocator
	, @com.fasterxml.jackson.annotation.JsonProperty("URI") URI: String
	, @com.fasterxml.jackson.annotation.JsonProperty("Name") Name: String
	, @com.fasterxml.jackson.annotation.JsonProperty("RoleURI") RoleURI: String
	, @com.fasterxml.jackson.annotation.JsonProperty("PasswordHash") PasswordHash: Array[Byte]
	, @com.fasterxml.jackson.annotation.JsonProperty("IsAllowed") IsAllowed: Boolean
	) =
	  this(_URI = URI, __locator = Some(__locator__), _Name = if (Name == null) "" else Name, _RoleURI = if (RoleURI == null) "" else RoleURI, _Role = null, _PasswordHash = if (PasswordHash == null) Array[Byte]() else PasswordHash, _IsAllowed = IsAllowed)

}

object User{

	def apply(
		Role: net.multipaint.Security.Role
	, PasswordHash: Array[Byte] = Array[Byte]()
	, IsAllowed: Boolean = false
	) = {
		require(Role ne null, "Null value was provided for property \"Role\"")
		require(PasswordHash ne null, "Null value was provided for property \"PasswordHash\"")
		new User(
			__locator = None
		, _URI = java.util.UUID.randomUUID.toString
		, _Name = Role.Name
		, _Role = Role
		, _RoleURI = Role.URI
		, _PasswordHash = PasswordHash
		, _IsAllowed = IsAllowed)
	}

	
			
	private[Security] def buildInternal(__locator : IServiceLocator
		, URI: String
		, Name: String
		, Role: net.multipaint.Security.Role
		, RoleURI: String
		, PasswordHash: Array[Byte]
		, IsAllowed: Boolean) = 
		new User(
			__locator = Some(__locator)
		, _URI = URI
		, _Name = Name
		, _Role = Role
		, _RoleURI = RoleURI
		, _PasswordHash = PasswordHash
		, _IsAllowed = IsAllowed)

}
