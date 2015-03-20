package net.multipaint.Security

import hr.ngs.patterns._




class RolePermission @com.fasterxml.jackson.annotation.JsonIgnore  private(
	  private var _URI: String,
	  private var _Name: String,
	  @transient private var _Role: net.multipaint.Security.Role,
	  private var _RoleURI: String,
	  private var _RoleID: String,
	  private var _IsAllowed: Boolean,
	  @transient private val __locator: Option[IServiceLocator]
	) extends Serializable with Revenj.Security.IRolePermission with IIdentifiable {
	
	
	
	
	@com.fasterxml.jackson.annotation.JsonProperty("URI")
	def URI = { 
		_URI
	}

	
	private [multipaint] def URI_= (value: String) { 
		_URI = value
		
	}

	
	override def hashCode = URI.hashCode
	override def equals(o: Any) = o match {
		case c: RolePermission => c.URI == URI
		case _ => false
	}

	override def toString = "RolePermission("+ URI +")"
	
		
	 def copy(Name: String = this._Name, Role: net.multipaint.Security.Role = null, IsAllowed: Boolean = this._IsAllowed): RolePermission = {
		

			
	require(Name ne null, "Null value was provided for property \"Name\"")
	com.dslplatform.api.Guards.checkLength(Name, 200)
		new RolePermission(_URI = this.URI, __locator = this.__locator, _Name = Name, _Role = if(Role != null) Role else _Role, _RoleURI = if (Role != null) Role.URI else this._RoleURI, _RoleID = if(Role != null) Role.Name else this._RoleID, _IsAllowed = IsAllowed)
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("Name")
	def Name = { 
		_Name
	}

	
	def Name_= (value: String) { 
		com.dslplatform.api.Guards.checkLength(value, 200)
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
		
		
		if(RoleID != value.Name)
			RoleID = value.Name
		_RoleURI = value.URI
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("RoleURI")
	def RoleURI = {
		
		_RoleURI
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("RoleID")
	 def RoleID = { 
		_RoleID
	}

	
	private [multipaint] def RoleID_= (value: String) { 
		_RoleID = value
		
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
	, @com.fasterxml.jackson.annotation.JsonProperty("RoleID") RoleID: String
	, @com.fasterxml.jackson.annotation.JsonProperty("IsAllowed") IsAllowed: Boolean
	) =
	  this(_URI = URI, __locator = Some(__locator__), _Name = if (Name == null) "" else Name, _RoleURI = if (RoleURI == null) "" else RoleURI, _Role = null, _RoleID = if (RoleID == null) "" else RoleID, _IsAllowed = IsAllowed)

}

object RolePermission{

	def apply(
		Name: String = ""
	, Role: net.multipaint.Security.Role
	, IsAllowed: Boolean = false
	) = {
		require(Name ne null, "Null value was provided for property \"Name\"")
		com.dslplatform.api.Guards.checkLength(Name, 200)
		require(Role ne null, "Null value was provided for property \"Role\"")
		new RolePermission(
			__locator = None
		, _URI = java.util.UUID.randomUUID.toString
		, _Name = Name
		, _Role = Role
		, _RoleURI = Role.URI
		, _RoleID = Role.Name
		, _IsAllowed = IsAllowed)
	}

	
			
	private[Security] def buildInternal(__locator : IServiceLocator
		, URI: String
		, Name: String
		, Role: net.multipaint.Security.Role
		, RoleURI: String
		, RoleID: String
		, IsAllowed: Boolean) = 
		new RolePermission(
			__locator = Some(__locator)
		, _URI = URI
		, _Name = Name
		, _Role = Role
		, _RoleURI = RoleURI
		, _RoleID = RoleID
		, _IsAllowed = IsAllowed)

}
