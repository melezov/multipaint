package net.multipaint.Security.postgres



import org.pgscala.converters._
import org.pgscala.util._
import hr.ngs.patterns._

object RoleConverter {

	private val logger = org.slf4j.LoggerFactory.getLogger(getClass)

	def fromPGString(record: String, locator: IServiceLocator): net.multipaint.Security.Role = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.Role.buildInternal(
			__locator = locator
		, URI = parseUri(items)
		, Name = PGStringConverter.fromPGString(items(NamePos))
		)
	}

	def fromPGOptionString(record: String, locator: IServiceLocator): Option[net.multipaint.Security.Role] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGString(record, locator))
	}

	def fromPGStringExtended(record: String, locator: IServiceLocator): net.multipaint.Security.Role = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.Role.buildInternal(
			__locator = locator
		, URI = parseUriExtended(items)
		, Name = PGStringConverter.fromPGString(items(NamePosExtended))
		)
	}

	def fromPGOptionStringExtended(record: String, locator: IServiceLocator): Option[net.multipaint.Security.Role] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGStringExtended(record, locator))
	}

	def toPGString(item: net.multipaint.Security.Role): String = {
		val items = new Array[String](columnCount) 
		items(NamePos) = PGStringConverter.toPGString(item.Name)
		PGRecord.pack(items)
	}

	def toPGOptionString(item: Option[net.multipaint.Security.Role]): String = {
		if (item.isDefined) toPGString(item.get)
		else null
	}

	def toPGStringExtended(item: net.multipaint.Security.Role): String = {
		val items = new Array[String](extendedColumnCount) 
		items(NamePosExtended) = PGStringConverter.toPGString(item.Name)
		PGRecord.pack(items)
	}

	def toPGOptionStringExtended(item: Option[net.multipaint.Security.Role]): String = {
		if (item.isDefined) toPGStringExtended(item.get)
		else null
	}

	def initializeProperties(postgresUtils: PostgresUtils) {
		
		columnCount = postgresUtils.getColumnCount("Security", "Role_entity")
		extendedColumnCount = postgresUtils.getColumnCount("Security", "-ngs_Role_type-")
		NamePos = postgresUtils.getIndexes("Security", "Role_entity").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.Role_entity. Check if database is out of sync with code!"""); -1
		}		
		NamePosExtended = postgresUtils.getIndexes("Security", "-ngs_Role_type-").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.Role. Check if database is out of sync with code!"""); -1
		}		
	}

	
	
	def parseUri(items: Array[String]) : String = {
		items(NamePos)
	}
	def parseUriExtended(items: Array[String]) : String = {
		items(NamePosExtended)
	}
	
	private var columnCount = -1
	private var extendedColumnCount = -1

	
	def buildURI(Name: String) : String = {
		PGStringConverter.toPGString(Name)
	}
	private var NamePos = -1 
	private var NamePosExtended = -1 
}
