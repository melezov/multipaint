package net.multipaint.MultiPaint

import hr.ngs.patterns._




class Artist @com.fasterxml.jackson.annotation.JsonIgnore  private(
	  private var _URI: String,
	  @transient private var _User: net.multipaint.Security.User,
	  private var _UserURI: String,
	  private var _UserID: String,
	  private var _Name: String,
	  private var _CreatedAt: org.joda.time.DateTime,
	  private var _LastActiveAt: org.joda.time.DateTime,
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
		case c: Artist => c.URI == URI
		case _ => false
	}

	override def toString = "Artist("+ URI +")"
	
		
	 def copy(User: net.multipaint.Security.User = null, Name: String = this._Name, LastActiveAt: org.joda.time.DateTime = this._LastActiveAt): Artist = {
		

			
	require(Name ne null, "Null value was provided for property \"Name\"")
	require(LastActiveAt ne null, "Null value was provided for property \"LastActiveAt\"")
		new Artist(_URI = this.URI, __locator = this.__locator, _User = if(User != null) User else _User, _UserURI = if (User != null) User.URI else this._UserURI, _UserID = if(User != null) User.Name else this._UserID, _Name = Name, _CreatedAt = _CreatedAt, _LastActiveAt = LastActiveAt)
	}

	
	
	def User = { 
	if(__locator.isDefined) {
			if (_User == null || _User.URI != UserURI)
				_User = __locator.get.resolve[net.multipaint.Security.IUserRepository].find(UserURI).orNull
		}			
		_User
	}

	
	def User_= (value: net.multipaint.Security.User) { 
		_User = value
		
		
		if(UserID != value.Name)
			UserID = value.Name
		_UserURI = value.URI
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("UserURI")
	def UserURI = {
		
		_UserURI
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("UserID")
	 def UserID = { 
		_UserID
	}

	
	private [multipaint] def UserID_= (value: String) { 
		_UserID = value
		
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("Name")
	def Name = { 
		_Name
	}

	
	def Name_= (value: String) { 
		_Name = value
		
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("CreatedAt")
	def CreatedAt = { 
		_CreatedAt
	}

	
	private [multipaint] def CreatedAt_= (value: org.joda.time.DateTime) { 
		_CreatedAt = value
		
	}

	
	
	@com.fasterxml.jackson.annotation.JsonProperty("LastActiveAt")
	def LastActiveAt = { 
		_LastActiveAt
	}

	
	def LastActiveAt_= (value: org.joda.time.DateTime) { 
		_LastActiveAt = value
		
	}

	
	@com.fasterxml.jackson.annotation.JsonCreator private def this(
		@com.fasterxml.jackson.annotation.JacksonInject("__locator") __locator__ : IServiceLocator
	, @com.fasterxml.jackson.annotation.JsonProperty("URI") URI: String
	, @com.fasterxml.jackson.annotation.JsonProperty("UserURI") UserURI: String
	, @com.fasterxml.jackson.annotation.JsonProperty("UserID") UserID: String
	, @com.fasterxml.jackson.annotation.JsonProperty("Name") Name: String
	, @com.fasterxml.jackson.annotation.JsonProperty("CreatedAt") CreatedAt: org.joda.time.DateTime
	, @com.fasterxml.jackson.annotation.JsonProperty("LastActiveAt") LastActiveAt: org.joda.time.DateTime
	) =
	  this(_URI = URI, __locator = Some(__locator__), _UserURI = if (UserURI == null) "" else UserURI, _User = null, _UserID = if (UserID == null) "" else UserID, _Name = if (Name == null) "" else Name, _CreatedAt = if (CreatedAt == null) org.joda.time.DateTime.now else CreatedAt, _LastActiveAt = if (LastActiveAt == null) org.joda.time.DateTime.now else LastActiveAt)

}

object Artist{

	def apply(
		User: net.multipaint.Security.User
	, Name: String = ""
	, LastActiveAt: org.joda.time.DateTime = org.joda.time.DateTime.now
	) = {
		require(User ne null, "Null value was provided for property \"User\"")
		require(Name ne null, "Null value was provided for property \"Name\"")
		require(LastActiveAt ne null, "Null value was provided for property \"LastActiveAt\"")
		new Artist(
			__locator = None
		, _URI = java.util.UUID.randomUUID.toString
		, _User = User
		, _UserURI = User.URI
		, _UserID = User.Name
		, _Name = Name
		, _CreatedAt = org.joda.time.DateTime.now
		, _LastActiveAt = LastActiveAt)
	}

	
			


case class ActiveUsers (
	   Since: org.joda.time.DateTime = org.joda.time.DateTime.now
	) {
	
	
	require(Since ne null, "Null value was provided for property \"Since\"")
}

			
	private[MultiPaint] def buildInternal(__locator : IServiceLocator
		, URI: String
		, User: net.multipaint.Security.User
		, UserURI: String
		, UserID: String
		, Name: String
		, CreatedAt: org.joda.time.DateTime
		, LastActiveAt: org.joda.time.DateTime) = 
		new Artist(
			__locator = Some(__locator)
		, _URI = URI
		, _User = User
		, _UserURI = UserURI
		, _UserID = UserID
		, _Name = Name
		, _CreatedAt = CreatedAt
		, _LastActiveAt = LastActiveAt)

}
