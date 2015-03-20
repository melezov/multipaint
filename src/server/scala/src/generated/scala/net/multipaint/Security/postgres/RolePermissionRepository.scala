package net.multipaint.Security.postgres

import hr.ngs.patterns._




class RolePermissionRepository(
	  private val sessionFactory: org.pgscala.PGSessionFactory,
	  private val locator: IServiceLocator
	) extends net.multipaint.Security.IRolePermissionRepository {
	
	
	
	import org.pgscala._

	val converter = net.multipaint.Security.postgres.RolePermissionConverter

	val createFromResultSet = (rS: PGScalaResultSet) =>
		converter.fromPGString(rS.one[String], locator)

	def find(uris: Traversable[String]): IndexedSeq[net.multipaint.Security.RolePermission] = {
		val pks = if(uris eq null) Array.empty[String] else uris.filter(_ ne null).toArray
		if (pks.isEmpty) {
			IndexedSeq.empty
		}
		else {
			val formattedUris = postgres.Utils.buildCompositeUriList(pks)
			sessionFactory.using( _.arr("""SELECT r
FROM "Security"."RolePermission_entity" r
WHERE (r."Name", r."RoleID") IN (%s)""".format(formattedUris)) (createFromResultSet)
			)
		}
	}
	
	private val typeConverter = net.multipaint.Security.postgres.RolePermissionConverter
	private val rootTypeConverter = typeConverter.toPGString _

	def persist(
		  insert: Traversable[net.multipaint.Security.RolePermission]
		, update: Traversable[(net.multipaint.Security.RolePermission, net.multipaint.Security.RolePermission)]
		, delete: Traversable[net.multipaint.Security.RolePermission]): IndexedSeq[String] = {

		sessionFactory.using{ dbSession =>
			val insertValues = insert.toArray
			val updateValues = update.toArray
			val deleteValues = delete.toArray



			insertValues foreach { item => item.URI = typeConverter.buildURI(item.Name, item.RoleID) }
			updateValues foreach { case(_, item) => item.URI = typeConverter.buildURI(item.Name, item.RoleID) }

			val sqlCom = new StringBuilder("""/*NO LOAD BALANCE*/SELECT "Security"."persist_RolePermission"(
					%s::"Security"."RolePermission_entity"[],
					%s::"Security".">update-RolePermission-pair<"[],
					%s::"Security"."RolePermission_entity"[]""".format(
				postgres.Utils.createArrayLiteral(insertValues, rootTypeConverter),
				postgres.Utils.createArrayPairLiteral(updateValues, rootTypeConverter),
				postgres.Utils.createArrayLiteral(deleteValues, rootTypeConverter)))

			sqlCom.append(")")

			dbSession.exec(sqlCom.toString)


			insertValues.map(_.URI)
		} // using
	}

}
