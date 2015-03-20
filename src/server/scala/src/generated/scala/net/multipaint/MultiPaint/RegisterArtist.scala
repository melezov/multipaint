package net.multipaint.MultiPaint



import org.joda.time.DateTime


case class RegisterArtist private(
	  @com.fasterxml.jackson.annotation.JsonProperty("URI")private val _URI: String,
	  @com.fasterxml.jackson.annotation.JsonProperty("CreatedAt")private val _createdAt: DateTime,
	  @com.fasterxml.jackson.annotation.JsonProperty("ProcessedAt")private val _processedAt: Option[DateTime],
	  @com.fasterxml.jackson.annotation.JsonProperty("Name")private val  _Name: String,
	  @com.fasterxml.jackson.annotation.JsonProperty("UserID")private val  _UserID: Option[String],
	  @com.fasterxml.jackson.annotation.JsonProperty("Password")private val  _Password: Option[String]
	) {
	
	
	
	val URI: String = if (_URI != null) _URI else java.util.UUID.randomUUID.toString
	val createdAt: DateTime = if (_createdAt != null) _createdAt else DateTime.now
	val processedAt: Option[DateTime] = if (_processedAt != null) _processedAt else None

	override def hashCode() = URI.hashCode

	override def equals(obj: Any): Boolean = {
		if (this == obj)
			return true
		if (obj == null)
			return false
		if (getClass() != obj.getClass())
			return false
		val other = obj.asInstanceOf[RegisterArtist]
		URI != null && URI.equals(other.URI)
	}

	override def toString() = "RegisterArtist(" + URI + ')' 
	
		
	 def copy(Name: String = this.Name, UserID: Option[String] = this.UserID, Password: Option[String] = this.Password): RegisterArtist = {
		

			
	require(Name ne null, "Null value was provided for property \"Name\"")
	require(UserID ne null, "Null value was provided for property \"UserID\"")
	if (UserID.isDefined) require(UserID.get ne null, "Null value was provided for property \"UserID\"")
	require(Password ne null, "Null value was provided for property \"Password\"")
	if (Password.isDefined) require(Password.get ne null, "Null value was provided for property \"Password\"")
		new RegisterArtist(_URI = this.URI, _createdAt = this.createdAt, _processedAt = this.processedAt, _Name = Name, _UserID = UserID, _Password = Password)
	}

	val Name: String = if (_Name != null) _Name else ""
	
	if (_UserID != null && _UserID.isDefined) require(_UserID.get ne null, "Property \"UserID\" can't be Some(null)")
	val UserID: Option[String] = if (_UserID != null) _UserID else None
	
	if (_Password != null && _Password.isDefined) require(_Password.get ne null, "Property \"Password\" can't be Some(null)")
	val Password: Option[String] = if (_Password != null) _Password else None
}

object RegisterArtist{

	
			
  def apply(Name: String = "", UserID: Option[String] = None, Password: Option[String] = None) = {
	
	require(Name ne null, "Null value was provided for property \"Name\"")
	require(UserID ne null, "Null value was provided for property \"UserID\"")
	if (UserID.isDefined) require(UserID.get ne null, "Null value was provided for property \"UserID\"")
	require(Password ne null, "Null value was provided for property \"Password\"")
	if (Password.isDefined) require(Password.get ne null, "Null value was provided for property \"Password\"")
	new RegisterArtist(_URI = java.util.UUID.randomUUID.toString, _createdAt = DateTime.now, _processedAt = None , _Name = Name, _UserID = UserID, _Password = Password)
  }
}
