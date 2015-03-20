package net.multipaint.MultiPaint.postgres

import hr.ngs.patterns._




class ArtistRepository(
	  private val sessionFactory: org.pgscala.PGSessionFactory,
	  private val locator: IServiceLocator
	) extends net.multipaint.MultiPaint.IArtistRepository {
	
	
	
	import org.pgscala._

	val converter = net.multipaint.MultiPaint.postgres.ArtistConverter

	val createFromResultSet = (rS: PGScalaResultSet) =>
		converter.fromPGString(rS.one[String], locator)

	def find(uris: Traversable[String]): IndexedSeq[net.multipaint.MultiPaint.Artist] = {
		val pks = if(uris eq null) Array.empty[String] else uris.filter(_ ne null).toArray
		if (pks.isEmpty) {
			IndexedSeq.empty
		}
		else {
			val formattedUris = postgres.Utils.buildSimpleUriList(pks)
			sessionFactory.using( _.arr("""SELECT r
FROM "MultiPaint"."Artist_entity" r
WHERE r."UserID" IN (%s)""".format(formattedUris)) (createFromResultSet)
			)
		}
	}
	def ActiveUsers(Since: org.joda.time.DateTime): IndexedSeq[net.multipaint.MultiPaint.Artist] = {
		/*artist => artist.LastActiveAt >= Since*/
		throw new UnsupportedOperationException("Please implement ActiveUsers and register implementation in the container")
	}			
	
	private val typeConverter = net.multipaint.MultiPaint.postgres.ArtistConverter
	private val rootTypeConverter = typeConverter.toPGString _

	def persist(
		  insert: Traversable[net.multipaint.MultiPaint.Artist]
		, update: Traversable[(net.multipaint.MultiPaint.Artist, net.multipaint.MultiPaint.Artist)]
		, delete: Traversable[net.multipaint.MultiPaint.Artist]): IndexedSeq[String] = {

		sessionFactory.using{ dbSession =>
			val insertValues = insert.toArray
			val updateValues = update.toArray
			val deleteValues = delete.toArray



			insertValues foreach { item => item.URI = typeConverter.buildURI(item.UserID) }
			updateValues foreach { case(_, item) => item.URI = typeConverter.buildURI(item.UserID) }

			val sqlCom = new StringBuilder("""/*NO LOAD BALANCE*/SELECT "MultiPaint"."persist_Artist"(
					%s::"MultiPaint"."Artist_entity"[],
					%s::"MultiPaint".">update-Artist-pair<"[],
					%s::"MultiPaint"."Artist_entity"[]""".format(
				postgres.Utils.createArrayLiteral(insertValues, rootTypeConverter),
				postgres.Utils.createArrayPairLiteral(updateValues, rootTypeConverter),
				postgres.Utils.createArrayLiteral(deleteValues, rootTypeConverter)))

			sqlCom.append(")")

			dbSession.exec(sqlCom.toString)


			insertValues.map(_.URI)
		} // using
	}

}
