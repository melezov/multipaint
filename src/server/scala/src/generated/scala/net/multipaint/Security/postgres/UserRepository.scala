package net.multipaint.Security.postgres

import hr.ngs.patterns._




class UserRepository(
	  private val sessionFactory: org.pgscala.PGSessionFactory,
	  private val locator: IServiceLocator
	) extends net.multipaint.Security.IUserRepository {
	
	
	
	import org.pgscala._

	val converter = net.multipaint.Security.postgres.UserConverter

	val createFromResultSet = (rS: PGScalaResultSet) =>
		converter.fromPGString(rS.one[String], locator)

	def find(uris: Traversable[String]): IndexedSeq[net.multipaint.Security.User] = {
		val pks = if(uris eq null) Array.empty[String] else uris.filter(_ ne null).toArray
		if (pks.isEmpty) {
			IndexedSeq.empty
		}
		else {
			val formattedUris = postgres.Utils.buildSimpleUriList(pks)
			sessionFactory.using( _.arr("""SELECT r
FROM "Security"."User_entity" r
WHERE r."Name" IN (%s)""".format(formattedUris)) (createFromResultSet)
			)
		}
	}
	
	private val typeConverter = net.multipaint.Security.postgres.UserConverter
	private val rootTypeConverter = typeConverter.toPGString _

	def persist(
		  insert: Traversable[net.multipaint.Security.User]
		, update: Traversable[(net.multipaint.Security.User, net.multipaint.Security.User)]
		, delete: Traversable[net.multipaint.Security.User]): IndexedSeq[String] = {

		sessionFactory.using{ dbSession =>
			val insertValues = insert.toArray
			val updateValues = update.toArray
			val deleteValues = delete.toArray



			insertValues foreach { item => item.URI = typeConverter.buildURI(item.Name) }
			updateValues foreach { case(_, item) => item.URI = typeConverter.buildURI(item.Name) }

			val sqlCom = new StringBuilder("""/*NO LOAD BALANCE*/SELECT "Security"."persist_User"(
					%s::"Security"."User_entity"[],
					%s::"Security".">update-User-pair<"[],
					%s::"Security"."User_entity"[]""".format(
				postgres.Utils.createArrayLiteral(insertValues, rootTypeConverter),
				postgres.Utils.createArrayPairLiteral(updateValues, rootTypeConverter),
				postgres.Utils.createArrayLiteral(deleteValues, rootTypeConverter)))

			sqlCom.append(")")

			dbSession.exec(sqlCom.toString)


			insertValues.map(_.URI)
		} // using
	}

}
