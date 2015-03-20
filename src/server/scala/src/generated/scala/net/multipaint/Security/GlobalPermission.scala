package net.multipaint.Security

import hr.ngs.patterns._




class GlobalPermission @com.fasterxml.jackson.annotation.JsonIgnore  private(
	  private var _URI: String,
	  private var _Name: String,
	  private var _IsAllowed: Boolean,
	  @transient private val __locator: Option[IServiceLocator]
	) extends Serializable with Revenj.Security.IGlobalPermission with IIdentifiable {
	
	
	
	
	@com.fasterxml.jackson.annotation.JsonProperty("URI")
	def URI = { 
		_URI
	}

	
	private [multipaint] def URI_= (value: String) { 
		_URI = value
		
	}

	
	override def hashCode = URI.hashCode
	override def equals(o: Any) = o match {
		case c: GlobalPermission => c.URI == URI
		case _ => false
	}

	override def toString = "GlobalPermission("+ URI +")"
	
		
	 def copy(Name: String = this._Name, IsAllowed: Boolean = this._IsAllowed): GlobalPermission = {
		

			
	require(Name ne null, "Null value was provided for property \"Name\"")
	com.dslplatform.api.Guards.checkLength(Name, 200)
		new GlobalPermission(_URI = this.URI, __locator = this.__locator, _Name = Name, _IsAllowed = IsAllowed)
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("Name")
	def Name = { 
		_Name
	}

	
	def Name_= (value: String) { 
		com.dslplatform.api.Guards.checkLength(value, 200)
		_Name = value
		
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
	, @com.fasterxml.jackson.annotation.JsonProperty("IsAllowed") IsAllowed: Boolean
	) =
	  this(_URI = URI, __locator = Some(__locator__), _Name = if (Name == null) "" else Name, _IsAllowed = IsAllowed)

}

object GlobalPermission{

	def apply(
		Name: String = ""
	, IsAllowed: Boolean = false
	) = {
		require(Name ne null, "Null value was provided for property \"Name\"")
		com.dslplatform.api.Guards.checkLength(Name, 200)
		new GlobalPermission(
			__locator = None
		, _URI = java.util.UUID.randomUUID.toString
		, _Name = Name
		, _IsAllowed = IsAllowed)
	}

	
			
	private[Security] def buildInternal(__locator : IServiceLocator
		, URI: String
		, Name: String
		, IsAllowed: Boolean) = 
		new GlobalPermission(
			__locator = Some(__locator)
		, _URI = URI
		, _Name = Name
		, _IsAllowed = IsAllowed)

}
