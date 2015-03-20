package net.multipaint.Security.postgres



import org.pgscala.converters._
import org.pgscala.util._
import hr.ngs.patterns._

object UserConverter {

	private val logger = org.slf4j.LoggerFactory.getLogger(getClass)

	def fromPGString(record: String, locator: IServiceLocator): net.multipaint.Security.User = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.User.buildInternal(
			__locator = locator
		, URI = parseUri(items)
		, Name = PGStringConverter.fromPGString(items(NamePos))
		, Role = null
		, RoleURI = items(RoleURIPos)
		, PasswordHash = PGByteArrayConverter.fromPGString(items(PasswordHashPos))
		, IsAllowed = PGBooleanConverter.fromPGString(items(IsAllowedPos))
		)
	}

	def fromPGOptionString(record: String, locator: IServiceLocator): Option[net.multipaint.Security.User] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGString(record, locator))
	}

	def fromPGStringExtended(record: String, locator: IServiceLocator): net.multipaint.Security.User = {
		val items = PGRecord.unpack(record)
		net.multipaint.Security.User.buildInternal(
			__locator = locator
		, URI = parseUriExtended(items)
		, Name = PGStringConverter.fromPGString(items(NamePosExtended))
		, Role = null
		, RoleURI = items(RoleURIPosExtended)
		, PasswordHash = PGByteArrayConverter.fromPGString(items(PasswordHashPosExtended))
		, IsAllowed = PGBooleanConverter.fromPGString(items(IsAllowedPosExtended))
		)
	}

	def fromPGOptionStringExtended(record: String, locator: IServiceLocator): Option[net.multipaint.Security.User] = {
		if (record == null || record.isEmpty) None
		else Some(fromPGStringExtended(record, locator))
	}

	def toPGString(item: net.multipaint.Security.User): String = {
		val items = new Array[String](columnCount) 
		items(NamePos) = PGStringConverter.toPGString(item.Name)
		items(RoleURIPos) = item.RoleURI
		items(PasswordHashPos) = PGByteArrayConverter.toPGString(item.PasswordHash)
		items(IsAllowedPos) = PGBooleanConverter.toPGString(item.IsAllowed)
		PGRecord.pack(items)
	}

	def toPGOptionString(item: Option[net.multipaint.Security.User]): String = {
		if (item.isDefined) toPGString(item.get)
		else null
	}

	def toPGStringExtended(item: net.multipaint.Security.User): String = {
		val items = new Array[String](extendedColumnCount) 
		items(NamePosExtended) = PGStringConverter.toPGString(item.Name)
		items(RoleURIPosExtended) = item.RoleURI
		items(PasswordHashPosExtended) = PGByteArrayConverter.toPGString(item.PasswordHash)
		items(IsAllowedPosExtended) = PGBooleanConverter.toPGString(item.IsAllowed)
		PGRecord.pack(items)
	}

	def toPGOptionStringExtended(item: Option[net.multipaint.Security.User]): String = {
		if (item.isDefined) toPGStringExtended(item.get)
		else null
	}

	def initializeProperties(postgresUtils: PostgresUtils) {
		
		columnCount = postgresUtils.getColumnCount("Security", "User_entity")
		extendedColumnCount = postgresUtils.getColumnCount("Security", "-ngs_User_type-")
		NamePos = postgresUtils.getIndexes("Security", "User_entity").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.User_entity. Check if database is out of sync with code!"""); -1
		}		
		NamePosExtended = postgresUtils.getIndexes("Security", "-ngs_User_type-").get("Name") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "Name" in type Security.User. Check if database is out of sync with code!"""); -1
		}		
		RoleURIPos = postgresUtils.getIndexes("Security", "User_entity").get("RoleURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "RoleURI" in type Security.User_entity. Check if database is out of sync with code!"""); -1
		}		
		RoleURIPosExtended = postgresUtils.getIndexes("Security", "-ngs_User_type-").get("RoleURI") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "RoleURI" in type Security.User. Check if database is out of sync with code!"""); -1
		}		
		PasswordHashPos = postgresUtils.getIndexes("Security", "User_entity").get("PasswordHash") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "PasswordHash" in type Security.User_entity. Check if database is out of sync with code!"""); -1
		}		
		PasswordHashPosExtended = postgresUtils.getIndexes("Security", "-ngs_User_type-").get("PasswordHash") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "PasswordHash" in type Security.User. Check if database is out of sync with code!"""); -1
		}		
		IsAllowedPos = postgresUtils.getIndexes("Security", "User_entity").get("IsAllowed") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "IsAllowed" in type Security.User_entity. Check if database is out of sync with code!"""); -1
		}		
		IsAllowedPosExtended = postgresUtils.getIndexes("Security", "-ngs_User_type-").get("IsAllowed") match {
			case Some(index) => index - 1
			case None => logger.error("""Couldn't find column "IsAllowed" in type Security.User. Check if database is out of sync with code!"""); -1
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
	private var RoleURIPos = -1 
	private var RoleURIPosExtended = -1 
	private var PasswordHashPos = -1 
	private var PasswordHashPosExtended = -1 
	private var IsAllowedPos = -1 
	private var IsAllowedPosExtended = -1 
}
