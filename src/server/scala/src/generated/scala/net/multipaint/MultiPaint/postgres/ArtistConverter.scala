package net.multipaint.MultiPaint.postgres



import org.pgscala.converters._
import org.pgscala.util._
import hr.ngs.patterns._

object ArtistConverter {

	private val logger = org.slf4j.LoggerFactory.getLogger(getClass)

	def fromPGString(record: String, locator: IServiceLocator): net.multipaint.MultiPaint.Artist = {
		val items = PGRecord.unpack(record)
		net.multipaint.MultiPaint.Artist.buildInternal(
			__locator = locator
		, URI = parseUri(items)
		, User = null
		, UserURI = items(UserURIPos)
		, UserID = PGStringConverter.fromPGString(items(UserIDPos))
		, Name = PGStringConverter.fromPGString(items(NamePos))
		, CreatedAt = PGDateTimeConverter.fromPGString(items(CreatedAtPos))
		, LastActiveAt = PGDateTimeConverter.fromPGString(items(LastActiveAtPos))
		)
	}

	def fromPGOptionString(record: String, locator: IServiceLocator): Option[net.multipaint.MultiPaint.Artist] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGString(record, locator))
	}

	def fromPGStringExtended(record: String, locator: IServiceLocator): net.multipaint.MultiPaint.Artist = {
		val items = PGRecord.unpack(record)
		net.multipaint.MultiPaint.Artist.buildInternal(
			__locator = locator
		, URI = parseUriExtended(items)
		, User = null
		, UserURI = items(UserURIPosExtended)
		, UserID = PGStringConverter.fromPGString(items(UserIDPosExtended))
		, Name = PGStringConverter.fromPGString(items(NamePosExtended))
		, CreatedAt = PGDateTimeConverter.fromPGString(items(CreatedAtPosExtended))
		, LastActiveAt = PGDateTimeConverter.fromPGString(items(LastActiveAtPosExtended))
		)
	}

	def fromPGOptionStringExtended(record: String, locator: IServiceLocator): Option[net.multipaint.MultiPaint.Artist] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGStringExtended(record, locator))
	}

	def toPGString(item: net.multipaint.MultiPaint.Artist): String = {
		val items = new Array[String](columnCount) 
		items(UserURIPos) = item.UserURI
		items(UserIDPos) = PGStringConverter.toPGString(item.UserID)
		items(NamePos) = PGStringConverter.toPGString(item.Name)
		items(CreatedAtPos) = PGDateTimeConverter.toPGString(item.CreatedAt)
		items(LastActiveAtPos) = PGDateTimeConverter.toPGString(item.LastActiveAt)
		PGRecord.pack(items)
	}

	def toPGOptionString(item: Option[net.multipaint.MultiPaint.Artist]): String = {
		if (item.isDefined) toPGString(item.get)
		else null
	}

	def toPGStringExtended(item: net.multipaint.MultiPaint.Artist): String = {
		val items = new Array[String](extendedColumnCount) 
		items(UserURIPosExtended) = item.UserURI
		items(UserIDPosExtended) = PGStringConverter.toPGString(item.UserID)
		items(NamePosExtended) = PGStringConverter.toPGString(item.Name)
		items(CreatedAtPosExtended) = PGDateTimeConverter.toPGString(item.CreatedAt)
		items(LastActiveAtPosExtended) = PGDateTimeConverter.toPGString(item.LastActiveAt)
		PGRecord.pack(items)
	}

	def toPGOptionStringExtended(item: Option[net.multipaint.MultiPaint.Artist]): String = {
		if (item.isDefined) toPGStringExtended(item.get)
		else null
	}

	def initializeProperties(postgresUtils: PostgresUtils) {
		
		columnCount = postgresUtils.getColumnCount("MultiPaint", "Artist_entity")
		extendedColumnCount = postgresUtils.getColumnCount("MultiPaint", "-ngs_Artist_type-")
		UserURIPos = postgresUtils.getIndexes("MultiPaint", "Artist_entity").get("UserURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "UserURI" in type MultiPaint.Artist_entity. Check if database is out of sync with code!"""); -1
		}		
		UserURIPosExtended = postgresUtils.getIndexes("MultiPaint", "-ngs_Artist_type-").get("UserURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "UserURI" in type MultiPaint.Artist. Check if database is out of sync with code!"""); -1
		}		
		UserIDPos = postgresUtils.getIndexes("MultiPaint", "Artist_entity").get("UserID") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "UserID" in type MultiPaint.Artist_entity. Check if database is out of sync with code!"""); -1
		}		
		UserIDPosExtended = postgresUtils.getIndexes("MultiPaint", "-ngs_Artist_type-").get("UserID") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "UserID" in type MultiPaint.Artist. Check if database is out of sync with code!"""); -1
		}		
		NamePos = postgresUtils.getIndexes("MultiPaint", "Artist_entity").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type MultiPaint.Artist_entity. Check if database is out of sync with code!"""); -1
		}		
		NamePosExtended = postgresUtils.getIndexes("MultiPaint", "-ngs_Artist_type-").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type MultiPaint.Artist. Check if database is out of sync with code!"""); -1
		}		
		CreatedAtPos = postgresUtils.getIndexes("MultiPaint", "Artist_entity").get("CreatedAt") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "CreatedAt" in type MultiPaint.Artist_entity. Check if database is out of sync with code!"""); -1
		}		
		CreatedAtPosExtended = postgresUtils.getIndexes("MultiPaint", "-ngs_Artist_type-").get("CreatedAt") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "CreatedAt" in type MultiPaint.Artist. Check if database is out of sync with code!"""); -1
		}		
		LastActiveAtPos = postgresUtils.getIndexes("MultiPaint", "Artist_entity").get("LastActiveAt") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "LastActiveAt" in type MultiPaint.Artist_entity. Check if database is out of sync with code!"""); -1
		}		
		LastActiveAtPosExtended = postgresUtils.getIndexes("MultiPaint", "-ngs_Artist_type-").get("LastActiveAt") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "LastActiveAt" in type MultiPaint.Artist. Check if database is out of sync with code!"""); -1
		}		
	}

	
	
	def parseUri(items: Array[String]) : String = {
		items(UserIDPos)
	}
	def parseUriExtended(items: Array[String]) : String = {
		items(UserIDPosExtended)
	}
	
	private var columnCount = -1
	private var extendedColumnCount = -1

	
	def buildURI(UserID: String) : String = {
		PGStringConverter.toPGString(UserID)
	}
	private var UserURIPos = -1 
	private var UserURIPosExtended = -1 
	private var UserIDPos = -1 
	private var UserIDPosExtended = -1 
	private var NamePos = -1 
	private var NamePosExtended = -1 
	private var CreatedAtPos = -1 
	private var CreatedAtPosExtended = -1 
	private var LastActiveAtPos = -1 
	private var LastActiveAtPosExtended = -1 
}
