package net.multipaint.Security

import hr.ngs.patterns._




class InheritedRole @com.fasterxml.jackson.annotation.JsonIgnore  private(
	  private var _URI: String,
	  private var _Name: String,
	  @transient private var _Role: net.multipaint.Security.Role,
	  private var _RoleURI: String,
	  private var _ParentName: String,
	  @transient private var _ParentRole: net.multipaint.Security.Role,
	  private var _ParentRoleURI: String,
	  @transient private val __locator: Option[IServiceLocator]
	) extends Serializable with Revenj.Security.IUserRoles with IIdentifiable {
	
	
	
	
	@com.fasterxml.jackson.annotation.JsonProperty("URI")
	def URI = { 
		_URI
	}

	
	private [multipaint] def URI_= (value: String) { 
		_URI = value
		
	}

	
	override def hashCode = URI.hashCode
	override def equals(o: Any) = o match {
		case c: InheritedRole => c.URI == URI
		case _ => false
	}

	override def toString = "InheritedRole("+ URI +")"
	
		
	 def copy(Role: net.multipaint.Security.Role = null, ParentRole: net.multipaint.Security.Role = null): InheritedRole = {
		

			
		new InheritedRole(_URI = this.URI, __locator = this.__locator, _Name = if(Role != null) Role.Name else this._Name, _Role = if(Role != null) Role else _Role, _RoleURI = if (Role != null) Role.URI else this._RoleURI, _ParentName = if(ParentRole != null) ParentRole.Name else this._ParentName, _ParentRole = if(ParentRole != null) ParentRole else _ParentRole, _ParentRoleURI = if (ParentRole != null) ParentRole.URI else this._ParentRoleURI)
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

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("ParentName")
	 def ParentName = { 
		_ParentName
	}

	
	private [multipaint] def ParentName_= (value: String) { 
		_ParentName = value
		
	}

	
	
	def ParentRole = { 
	if(__locator.isDefined) {
			if (_ParentRole == null || _ParentRole.URI != ParentRoleURI)
				_ParentRole = __locator.get.resolve[net.multipaint.Security.IRoleRepository].find(ParentRoleURI).orNull
		}			
		_ParentRole
	}

	
	def ParentRole_= (value: net.multipaint.Security.Role) { 
		_ParentRole = value
		
		
		if(ParentName != value.Name)
			ParentName = value.Name
		_ParentRoleURI = value.URI
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("ParentRoleURI")
	def ParentRoleURI = {
		
		_ParentRoleURI
	}

	
	@com.fasterxml.jackson.annotation.JsonCreator private def this(
		@com.fasterxml.jackson.annotation.JacksonInject("__locator") __locator__ : IServiceLocator
	, @com.fasterxml.jackson.annotation.JsonProperty("URI") URI: String
	, @com.fasterxml.jackson.annotation.JsonProperty("Name") Name: String
	, @com.fasterxml.jackson.annotation.JsonProperty("RoleURI") RoleURI: String
	, @com.fasterxml.jackson.annotation.JsonProperty("ParentName") ParentName: String
	, @com.fasterxml.jackson.annotation.JsonProperty("ParentRoleURI") ParentRoleURI: String
	) =
	  this(_URI = URI, __locator = Some(__locator__), _Name = if (Name == null) "" else Name, _RoleURI = if (RoleURI == null) "" else RoleURI, _Role = null, _ParentName = if (ParentName == null) "" else ParentName, _ParentRoleURI = if (ParentRoleURI == null) "" else ParentRoleURI, _ParentRole = null)

}

object InheritedRole{

	def apply(
		Role: net.multipaint.Security.Role
	, ParentRole: net.multipaint.Security.Role
	) = {
		require(Role ne null, "Null value was provided for property \"Role\"")
		require(ParentRole ne null, "Null value was provided for property \"ParentRole\"")
		new InheritedRole(
			__locator = None
		, _URI = java.util.UUID.randomUUID.toString
		, _Name = Role.Name
		, _Role = Role
		, _RoleURI = Role.URI
		, _ParentName = ParentRole.Name
		, _ParentRole = ParentRole
		, _ParentRoleURI = ParentRole.URI)
	}

	
			
	private[Security] def buildInternal(__locator : IServiceLocator
		, URI: String
		, Name: String
		, Role: net.multipaint.Security.Role
		, RoleURI: String
		, ParentName: String
		, ParentRole: net.multipaint.Security.Role
		, ParentRoleURI: String) = 
		new InheritedRole(
			__locator = Some(__locator)
		, _URI = URI
		, _Name = Name
		, _Role = Role
		, _RoleURI = RoleURI
		, _ParentName = ParentName
		, _ParentRole = ParentRole
		, _ParentRoleURI = ParentRoleURI)

}
