package net.multipaint.Security.postgres



import org.pgscala.converters._
import org.pgscala.util._
import hr.ngs.patterns._

object GlobalPermissionConverter {

	private val logger = org.slf4j.LoggerFactory.getLogger(getClass)

	def fromPGString(record: String, locator: IServiceLocator): net.multipaint.Security.GlobalPermission = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.GlobalPermission.buildInternal(
			__locator = locator
		, URI = parseUri(items)
		, Name = PGStringConverter.fromPGString(items(NamePos))
		, IsAllowed = PGBooleanConverter.fromPGString(items(IsAllowedPos))
		)
	}

	def fromPGOptionString(record: String, locator: IServiceLocator): Option[net.multipaint.Security.GlobalPermission] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGString(record, locator))
	}

	def fromPGStringExtended(record: String, locator: IServiceLocator): net.multipaint.Security.GlobalPermission = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.GlobalPermission.buildInternal(
			__locator = locator
		, URI = parseUriExtended(items)
		, Name = PGStringConverter.fromPGString(items(NamePosExtended))
		, IsAllowed = PGBooleanConverter.fromPGString(items(IsAllowedPosExtended))
		)
	}

	def fromPGOptionStringExtended(record: String, locator: IServiceLocator): Option[net.multipaint.Security.GlobalPermission] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGStringExtended(record, locator))
	}

	def toPGString(item: net.multipaint.Security.GlobalPermission): String = {
		val items = new Array[String](columnCount) 
		items(NamePos) = PGStringConverter.toPGString(item.Name)
		items(IsAllowedPos) = PGBooleanConverter.toPGString(item.IsAllowed)
		PGRecord.pack(items)
	}

	def toPGOptionString(item: Option[net.multipaint.Security.GlobalPermission]): String = {
		if (item.isDefined) toPGString(item.get)
		else null
	}

	def toPGStringExtended(item: net.multipaint.Security.GlobalPermission): String = {
		val items = new Array[String](extendedColumnCount) 
		items(NamePosExtended) = PGStringConverter.toPGString(item.Name)
		items(IsAllowedPosExtended) = PGBooleanConverter.toPGString(item.IsAllowed)
		PGRecord.pack(items)
	}

	def toPGOptionStringExtended(item: Option[net.multipaint.Security.GlobalPermission]): String = {
		if (item.isDefined) toPGStringExtended(item.get)
		else null
	}

	def initializeProperties(postgresUtils: PostgresUtils) {
		
		columnCount = postgresUtils.getColumnCount("Security", "GlobalPermission_entity")
		extendedColumnCount = postgresUtils.getColumnCount("Security", "-ngs_GlobalPermission_type-")
		NamePos = postgresUtils.getIndexes("Security", "GlobalPermission_entity").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.GlobalPermission_entity. Check if database is out of sync with code!"""); -1
		}		
		NamePosExtended = postgresUtils.getIndexes("Security", "-ngs_GlobalPermission_type-").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.GlobalPermission. Check if database is out of sync with code!"""); -1
		}		
		IsAllowedPos = postgresUtils.getIndexes("Security", "GlobalPermission_entity").get("IsAllowed") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "IsAllowed" in type Security.GlobalPermission_entity. Check if database is out of sync with code!"""); -1
		}		
		IsAllowedPosExtended = postgresUtils.getIndexes("Security", "-ngs_GlobalPermission_type-").get("IsAllowed") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "IsAllowed" in type Security.GlobalPermission. Check if database is out of sync with code!"""); -1
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
	private var IsAllowedPos = -1 
	private var IsAllowedPosExtended = -1 
}
