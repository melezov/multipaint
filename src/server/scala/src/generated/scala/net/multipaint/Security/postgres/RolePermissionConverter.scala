package net.multipaint.Security.postgres



import org.pgscala.converters._
import org.pgscala.util._
import hr.ngs.patterns._

object RolePermissionConverter {

	private val logger = org.slf4j.LoggerFactory.getLogger(getClass)

	def fromPGString(record: String, locator: IServiceLocator): net.multipaint.Security.RolePermission = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.RolePermission.buildInternal(
			__locator = locator
		, URI = parseUri(items)
		, Name = PGStringConverter.fromPGString(items(NamePos))
		, Role = null
		, RoleURI = items(RoleURIPos)
		, RoleID = PGStringConverter.fromPGString(items(RoleIDPos))
		, IsAllowed = PGBooleanConverter.fromPGString(items(IsAllowedPos))
		)
	}

	def fromPGOptionString(record: String, locator: IServiceLocator): Option[net.multipaint.Security.RolePermission] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGString(record, locator))
	}

	def fromPGStringExtended(record: String, locator: IServiceLocator): net.multipaint.Security.RolePermission = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.RolePermission.buildInternal(
			__locator = locator
		, URI = parseUriExtended(items)
		, Name = PGStringConverter.fromPGString(items(NamePosExtended))
		, Role = null
		, RoleURI = items(RoleURIPosExtended)
		, RoleID = PGStringConverter.fromPGString(items(RoleIDPosExtended))
		, IsAllowed = PGBooleanConverter.fromPGString(items(IsAllowedPosExtended))
		)
	}

	def fromPGOptionStringExtended(record: String, locator: IServiceLocator): Option[net.multipaint.Security.RolePermission] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGStringExtended(record, locator))
	}

	def toPGString(item: net.multipaint.Security.RolePermission): String = {
		val items = new Array[String](columnCount) 
		items(NamePos) = PGStringConverter.toPGString(item.Name)
		items(RoleURIPos) = item.RoleURI
		items(RoleIDPos) = PGStringConverter.toPGString(item.RoleID)
		items(IsAllowedPos) = PGBooleanConverter.toPGString(item.IsAllowed)
		PGRecord.pack(items)
	}

	def toPGOptionString(item: Option[net.multipaint.Security.RolePermission]): String = {
		if (item.isDefined) toPGString(item.get)
		else null
	}

	def toPGStringExtended(item: net.multipaint.Security.RolePermission): String = {
		val items = new Array[String](extendedColumnCount) 
		items(NamePosExtended) = PGStringConverter.toPGString(item.Name)
		items(RoleURIPosExtended) = item.RoleURI
		items(RoleIDPosExtended) = PGStringConverter.toPGString(item.RoleID)
		items(IsAllowedPosExtended) = PGBooleanConverter.toPGString(item.IsAllowed)
		PGRecord.pack(items)
	}

	def toPGOptionStringExtended(item: Option[net.multipaint.Security.RolePermission]): String = {
		if (item.isDefined) toPGStringExtended(item.get)
		else null
	}

	def initializeProperties(postgresUtils: PostgresUtils) {
		
		columnCount = postgresUtils.getColumnCount("Security", "RolePermission_entity")
		extendedColumnCount = postgresUtils.getColumnCount("Security", "-ngs_RolePermission_type-")
		NamePos = postgresUtils.getIndexes("Security", "RolePermission_entity").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.RolePermission_entity. Check if database is out of sync with code!"""); -1
		}		
		NamePosExtended = postgresUtils.getIndexes("Security", "-ngs_RolePermission_type-").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.RolePermission. Check if database is out of sync with code!"""); -1
		}		
		RoleURIPos = postgresUtils.getIndexes("Security", "RolePermission_entity").get("RoleURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "RoleURI" in type Security.RolePermission_entity. Check if database is out of sync with code!"""); -1
		}		
		RoleURIPosExtended = postgresUtils.getIndexes("Security", "-ngs_RolePermission_type-").get("RoleURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "RoleURI" in type Security.RolePermission. Check if database is out of sync with code!"""); -1
		}		
		RoleIDPos = postgresUtils.getIndexes("Security", "RolePermission_entity").get("RoleID") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "RoleID" in type Security.RolePermission_entity. Check if database is out of sync with code!"""); -1
		}		
		RoleIDPosExtended = postgresUtils.getIndexes("Security", "-ngs_RolePermission_type-").get("RoleID") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "RoleID" in type Security.RolePermission. Check if database is out of sync with code!"""); -1
		}		
		IsAllowedPos = postgresUtils.getIndexes("Security", "RolePermission_entity").get("IsAllowed") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "IsAllowed" in type Security.RolePermission_entity. Check if database is out of sync with code!"""); -1
		}		
		IsAllowedPosExtended = postgresUtils.getIndexes("Security", "-ngs_RolePermission_type-").get("IsAllowed") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "IsAllowed" in type Security.RolePermission. Check if database is out of sync with code!"""); -1
		}		
	}

	
	
	def parseUri(items: Array[String]) : String = {
		items(NamePos).replace("\\","\\\\").replace("/", "\\/")
	}
	def parseUriExtended(items: Array[String]) : String = {
		items(NamePosExtended).replace("\\","\\\\").replace("/", "\\/")
	}
	
	private var columnCount = -1
	private var extendedColumnCount = -1

	
	def buildURI(Name: String, RoleID: String) : String = {
		val _uriParts = new Array[String](2) 
		_uriParts(0) = PGStringConverter.toPGString(Name)
		_uriParts(1) = PGStringConverter.toPGString(RoleID)
		postgres.Utils.buildURI(_uriParts)
	}
	private var NamePos = -1 
	private var NamePosExtended = -1 
	private var RoleURIPos = -1 
	private var RoleURIPosExtended = -1 
	private var RoleIDPos = -1 
	private var RoleIDPosExtended = -1 
	private var IsAllowedPos = -1 
	private var IsAllowedPosExtended = -1 
}
