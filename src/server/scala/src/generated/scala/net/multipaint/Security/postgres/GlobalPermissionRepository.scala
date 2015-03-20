package net.multipaint.Security.postgres

import hr.ngs.patterns._




class GlobalPermissionRepository(
	  private val sessionFactory: org.pgscala.PGSessionFactory,
	  private val locator: IServiceLocator
	) extends net.multipaint.Security.IGlobalPermissionRepository {
	
	
	
	import org.pgscala._

	val converter = net.multipaint.Security.postgres.GlobalPermissionConverter

	val createFromResultSet = (rS: PGScalaResultSet) =>
		converter.fromPGString(rS.one[String], locator)

	def find(uris: Traversable[String]): IndexedSeq[net.multipaint.Security.GlobalPermission] = {
		val pks = if(uris eq null) Array.empty[String] else uris.filter(_ ne null).toArray
		if (pks.isEmpty) {
			IndexedSeq.empty
		}
		else {
			val formattedUris = postgres.Utils.buildSimpleUriList(pks)
			sessionFactory.using( _.arr("""SELECT r
FROM "Security"."GlobalPermission_entity" r
WHERE r."Name" IN (%s)""".format(formattedUris)) (createFromResultSet)
			)
		}
	}
	
	private val typeConverter = net.multipaint.Security.postgres.GlobalPermissionConverter
	private val rootTypeConverter = typeConverter.toPGString _

	def persist(
		  insert: Traversable[net.multipaint.Security.GlobalPermission]
		, update: Traversable[(net.multipaint.Security.GlobalPermission, net.multipaint.Security.GlobalPermission)]
		, delete: Traversable[net.multipaint.Security.GlobalPermission]): IndexedSeq[String] = {

		sessionFactory.using{ dbSession =>
			val insertValues = insert.toArray
			val updateValues = update.toArray
			val deleteValues = delete.toArray



			insertValues foreach { item => item.URI = typeConverter.buildURI(item.Name) }
			updateValues foreach { case(_, item) => item.URI = typeConverter.buildURI(item.Name) }

			val sqlCom = new StringBuilder("""/*NO LOAD BALANCE*/SELECT "Security"."persist_GlobalPermission"(
					%s::"Security"."GlobalPermission_entity"[],
					%s::"Security".">update-GlobalPermission-pair<"[],
					%s::"Security"."GlobalPermission_entity"[]""".format(
				postgres.Utils.createArrayLiteral(insertValues, rootTypeConverter),
				postgres.Utils.createArrayPairLiteral(updateValues, rootTypeConverter),
				postgres.Utils.createArrayLiteral(deleteValues, rootTypeConverter)))

			sqlCom.append(")")

			dbSession.exec(sqlCom.toString)


			insertValues.map(_.URI)
		} // using
	}

}
