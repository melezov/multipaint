package net.multipaint.Security.postgres



import org.pgscala.converters._
import org.pgscala.util._
import hr.ngs.patterns._

object InheritedRoleConverter {

	private val logger = org.slf4j.LoggerFactory.getLogger(getClass)

	def fromPGString(record: String, locator: IServiceLocator): net.multipaint.Security.InheritedRole = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.InheritedRole.buildInternal(
			__locator = locator
		, URI = parseUri(items)
		, Name = PGStringConverter.fromPGString(items(NamePos))
		, Role = null
		, RoleURI = items(RoleURIPos)
		, ParentName = PGStringConverter.fromPGString(items(ParentNamePos))
		, ParentRole = null
		, ParentRoleURI = items(ParentRoleURIPos)
		)
	}

	def fromPGOptionString(record: String, locator: IServiceLocator): Option[net.multipaint.Security.InheritedRole] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGString(record, locator))
	}

	def fromPGStringExtended(record: String, locator: IServiceLocator): net.multipaint.Security.InheritedRole = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.InheritedRole.buildInternal(
			__locator = locator
		, URI = parseUriExtended(items)
		, Name = PGStringConverter.fromPGString(items(NamePosExtended))
		, Role = null
		, RoleURI = items(RoleURIPosExtended)
		, ParentName = PGStringConverter.fromPGString(items(ParentNamePosExtended))
		, ParentRole = null
		, ParentRoleURI = items(ParentRoleURIPosExtended)
		)
	}

	def fromPGOptionStringExtended(record: String, locator: IServiceLocator): Option[net.multipaint.Security.InheritedRole] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGStringExtended(record, locator))
	}

	def toPGString(item: net.multipaint.Security.InheritedRole): String = {
		val items = new Array[String](columnCount) 
		items(NamePos) = PGStringConverter.toPGString(item.Name)
		items(RoleURIPos) = item.RoleURI
		items(ParentNamePos) = PGStringConverter.toPGString(item.ParentName)
		items(ParentRoleURIPos) = item.ParentRoleURI
		PGRecord.pack(items)
	}

	def toPGOptionString(item: Option[net.multipaint.Security.InheritedRole]): String = {
		if (item.isDefined) toPGString(item.get)
		else null
	}

	def toPGStringExtended(item: net.multipaint.Security.InheritedRole): String = {
		val items = new Array[String](extendedColumnCount) 
		items(NamePosExtended) = PGStringConverter.toPGString(item.Name)
		items(RoleURIPosExtended) = item.RoleURI
		items(ParentNamePosExtended) = PGStringConverter.toPGString(item.ParentName)
		items(ParentRoleURIPosExtended) = item.ParentRoleURI
		PGRecord.pack(items)
	}

	def toPGOptionStringExtended(item: Option[net.multipaint.Security.InheritedRole]): String = {
		if (item.isDefined) toPGStringExtended(item.get)
		else null
	}

	def initializeProperties(postgresUtils: PostgresUtils) {
		
		columnCount = postgresUtils.getColumnCount("Security", "InheritedRole_entity")
		extendedColumnCount = postgresUtils.getColumnCount("Security", "-ngs_InheritedRole_type-")
		NamePos = postgresUtils.getIndexes("Security", "InheritedRole_entity").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.InheritedRole_entity. Check if database is out of sync with code!"""); -1
		}		
		NamePosExtended = postgresUtils.getIndexes("Security", "-ngs_InheritedRole_type-").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.InheritedRole. Check if database is out of sync with code!"""); -1
		}		
		RoleURIPos = postgresUtils.getIndexes("Security", "InheritedRole_entity").get("RoleURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "RoleURI" in type Security.InheritedRole_entity. Check if database is out of sync with code!"""); -1
		}		
		RoleURIPosExtended = postgresUtils.getIndexes("Security", "-ngs_InheritedRole_type-").get("RoleURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "RoleURI" in type Security.InheritedRole. Check if database is out of sync with code!"""); -1
		}		
		ParentNamePos = postgresUtils.getIndexes("Security", "InheritedRole_entity").get("ParentName") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "ParentName" in type Security.InheritedRole_entity. Check if database is out of sync with code!"""); -1
		}		
		ParentNamePosExtended = postgresUtils.getIndexes("Security", "-ngs_InheritedRole_type-").get("ParentName") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "ParentName" in type Security.InheritedRole. Check if database is out of sync with code!"""); -1
		}		
		ParentRoleURIPos = postgresUtils.getIndexes("Security", "InheritedRole_entity").get("ParentRoleURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "ParentRoleURI" in type Security.InheritedRole_entity. Check if database is out of sync with code!"""); -1
		}		
		ParentRoleURIPosExtended = postgresUtils.getIndexes("Security", "-ngs_InheritedRole_type-").get("ParentRoleURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "ParentRoleURI" in type Security.InheritedRole. Check if database is out of sync with code!"""); -1
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

	
	def buildURI(Name: String, ParentName: String) : String = {
		val _uriParts = new Array[String](2) 
		_uriParts(0) = PGStringConverter.toPGString(Name)
		_uriParts(1) = PGStringConverter.toPGString(ParentName)
		postgres.Utils.buildURI(_uriParts)
	}
	private var NamePos = -1 
	private var NamePosExtended = -1 
	private var RoleURIPos = -1 
	private var RoleURIPosExtended = -1 
	private var ParentNamePos = -1 
	private var ParentNamePosExtended = -1 
	private var ParentRoleURIPos = -1 
	private var ParentRoleURIPosExtended = -1 
}
