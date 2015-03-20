package net.multipaint.Security

import hr.ngs.patterns._




class Role @com.fasterxml.jackson.annotation.JsonIgnore  private(
	  private var _URI: String,
	  private var _Name: String,
	  @transient private val __locator: Option[IServiceLocator]
	) extends Serializable with IIdentifiable {
	
	
	
	
	@com.fasterxml.jackson.annotation.JsonProperty("URI")
	def URI = { 
		_URI
	}

	
	private [multipaint] def URI_= (value: String) { 
		_URI = value
		
	}

	
	override def hashCode = URI.hashCode
	override def equals(o: Any) = o match {
		case c: Role => c.URI == URI
		case _ => false
	}

	override def toString = "Role("+ URI +")"
	
		
	 def copy(Name: String = this._Name): Role = {
		

			
	require(Name ne null, "Null value was provided for property \"Name\"")
	com.dslplatform.api.Guards.checkLength(Name, 100)
		new Role(_URI = this.URI, __locator = this.__locator, _Name = Name)
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("Name")
	def Name = { 
		_Name
	}

	
	def Name_= (value: String) { 
		com.dslplatform.api.Guards.checkLength(value, 100)
		_Name = value
		
	}

	
	@com.fasterxml.jackson.annotation.JsonCreator private def this(
		@com.fasterxml.jackson.annotation.JacksonInject("__locator") __locator__ : IServiceLocator
	, @com.fasterxml.jackson.annotation.JsonProperty("URI") URI: String
	, @com.fasterxml.jackson.annotation.JsonProperty("Name") Name: String
	) =
	  this(_URI = URI, __locator = Some(__locator__), _Name = if (Name == null) "" else Name)

}

object Role{

	def apply(
		Name: String = ""
	) = {
		require(Name ne null, "Null value was provided for property \"Name\"")
		com.dslplatform.api.Guards.checkLength(Name, 100)
		new Role(
			__locator = None
		, _URI = java.util.UUID.randomUUID.toString
		, _Name = Name)
	}

	
			
	private[Security] def buildInternal(__locator : IServiceLocator
		, URI: String
		, Name: String) = 
		new Role(
			__locator = Some(__locator)
		, _URI = URI
		, _Name = Name)

}
