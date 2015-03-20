package net.multipaint.Security.postgres

import hr.ngs.patterns._




class InheritedRoleRepository(
	  private val sessionFactory: org.pgscala.PGSessionFactory,
	  private val locator: IServiceLocator
	) extends net.multipaint.Security.IInheritedRoleRepository {
	
	
	
	import org.pgscala._

	val converter = net.multipaint.Security.postgres.InheritedRoleConverter

	val createFromResultSet = (rS: PGScalaResultSet) =>
		converter.fromPGString(rS.one[String], locator)

	def find(uris: Traversable[String]): IndexedSeq[net.multipaint.Security.InheritedRole] = {
		val pks = if(uris eq null) Array.empty[String] else uris.filter(_ ne null).toArray
		if (pks.isEmpty) {
			IndexedSeq.empty
		}
		else {
			val formattedUris = postgres.Utils.buildCompositeUriList(pks)
			sessionFactory.using( _.arr("""SELECT r
FROM "Security"."InheritedRole_entity" r
WHERE (r."Name", r."ParentName") IN (%s)""".format(formattedUris)) (createFromResultSet)
			)
		}
	}
	
	private val typeConverter = net.multipaint.Security.postgres.InheritedRoleConverter
	private val rootTypeConverter = typeConverter.toPGString _

	def persist(
		  insert: Traversable[net.multipaint.Security.InheritedRole]
		, update: Traversable[(net.multipaint.Security.InheritedRole, net.multipaint.Security.InheritedRole)]
		, delete: Traversable[net.multipaint.Security.InheritedRole]): IndexedSeq[String] = {

		sessionFactory.using{ dbSession =>
			val insertValues = insert.toArray
			val updateValues = update.toArray
			val deleteValues = delete.toArray



			insertValues foreach { item => item.URI = typeConverter.buildURI(item.Name, item.ParentName) }
			updateValues foreach { case(_, item) => item.URI = typeConverter.buildURI(item.Name, item.ParentName) }

			val sqlCom = new StringBuilder("""/*NO LOAD BALANCE*/SELECT "Security"."persist_InheritedRole"(
					%s::"Security"."InheritedRole_entity"[],
					%s::"Security".">update-InheritedRole-pair<"[],
					%s::"Security"."InheritedRole_entity"[]""".format(
				postgres.Utils.createArrayLiteral(insertValues, rootTypeConverter),
				postgres.Utils.createArrayPairLiteral(updateValues, rootTypeConverter),
				postgres.Utils.createArrayLiteral(deleteValues, rootTypeConverter)))

			sqlCom.append(")")

			dbSession.exec(sqlCom.toString)


			insertValues.map(_.URI)
		} // using
	}

}
