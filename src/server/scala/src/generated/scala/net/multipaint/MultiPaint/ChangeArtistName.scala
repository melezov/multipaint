package net.multipaint.MultiPaint



import org.joda.time.DateTime


case class ChangeArtistName private(
	  @com.fasterxml.jackson.annotation.JsonProperty("URI")private val _URI: String,
	  @com.fasterxml.jackson.annotation.JsonProperty("CreatedAt")private val _createdAt: DateTime,
	  @com.fasterxml.jackson.annotation.JsonProperty("ProcessedAt")private val _processedAt: Option[DateTime],
	  @com.fasterxml.jackson.annotation.JsonProperty("NewName")private val  _NewName: String
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
		val other = obj.asInstanceOf[ChangeArtistName]
		URI != null && URI.equals(other.URI)
	}

	override def toString() = "ChangeArtistName(" + URI + ')' 
	
		
	 def copy(NewName: String = this.NewName): ChangeArtistName = {
		

			
	require(NewName ne null, "Null value was provided for property \"NewName\"")
		new ChangeArtistName(_URI = this.URI, _createdAt = this.createdAt, _processedAt = this.processedAt, _NewName = NewName)
	}

	val NewName: String = if (_NewName != null) _NewName else ""
}

object ChangeArtistName{

	
			
  def apply(NewName: String = "") = {
	
	require(NewName ne null, "Null value was provided for property \"NewName\"")
	new ChangeArtistName(_URI = java.util.UUID.randomUUID.toString, _createdAt = DateTime.now, _processedAt = None , _NewName = NewName)
  }
}
