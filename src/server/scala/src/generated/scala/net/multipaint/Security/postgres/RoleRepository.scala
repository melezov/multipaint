package net.multipaint.Security.postgres

import hr.ngs.patterns._




class RoleRepository(
	  private val sessionFactory: org.pgscala.PGSessionFactory,
	  private val locator: IServiceLocator
	) extends net.multipaint.Security.IRoleRepository {
	
	
	
	import org.pgscala._

	val converter = net.multipaint.Security.postgres.RoleConverter

	val createFromResultSet = (rS: PGScalaResultSet) =>
		converter.fromPGString(rS.one[String], locator)

	def find(uris: Traversable[String]): IndexedSeq[net.multipaint.Security.Role] = {
		val pks = if(uris eq null) Array.empty[String] else uris.filter(_ ne null).toArray
		if (pks.isEmpty) {
			IndexedSeq.empty
		}
		else {
			val formattedUris = postgres.Utils.buildSimpleUriList(pks)
			sessionFactory.using( _.arr("""SELECT r
FROM "Security"."Role_entity" r
WHERE r."Name" IN (%s)""".format(formattedUris)) (createFromResultSet)
			)
		}
	}
	
	private val typeConverter = net.multipaint.Security.postgres.RoleConverter
	private val rootTypeConverter = typeConverter.toPGString _

	def persist(
		  insert: Traversable[net.multipaint.Security.Role]
		, update: Traversable[(net.multipaint.Security.Role, net.multipaint.Security.Role)]
		, delete: Traversable[net.multipaint.Security.Role]): IndexedSeq[String] = {

		sessionFactory.using{ dbSession =>
			val insertValues = insert.toArray
			val updateValues = update.toArray
			val deleteValues = delete.toArray



			insertValues foreach { item => item.URI = typeConverter.buildURI(item.Name) }
			updateValues foreach { case(_, item) => item.URI = typeConverter.buildURI(item.Name) }

			val sqlCom = new StringBuilder("""/*NO LOAD BALANCE*/SELECT "Security"."persist_Role"(
					%s::"Security"."Role_entity"[],
					%s::"Security".">update-Role-pair<"[],
					%s::"Security"."Role_entity"[]""".format(
				postgres.Utils.createArrayLiteral(insertValues, rootTypeConverter),
				postgres.Utils.createArrayPairLiteral(updateValues, rootTypeConverter),
				postgres.Utils.createArrayLiteral(deleteValues, rootTypeConverter)))

			sqlCom.append(")")

			dbSession.exec(sqlCom.toString)


			insertValues.map(_.URI)
		} // using
	}

}
