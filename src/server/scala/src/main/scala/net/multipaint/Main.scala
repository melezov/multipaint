package net.multipaint

import net.multipaint.MultiPaint._
import net.multipaint.Security.Role
import org.pgscala._
import hr.ngs.patterns._
import org.slf4j.LoggerFactory

object Main extends App {
  private val dbCreds = {
    PGCredentials(
      host     = "localhost"
    , port     = 5432
    , dbName   = "multipaint"
    , user     = "multipaint"
    , password = "changeit"
    , sslMode  = "require"
    )
  }

  val logger = LoggerFactory.getLogger("multipaint-server")

  private val container = new DependencyContainer()
    .register(logger)
    .register[PGSessionFactory](new PGSimple(dbCreds))
    .register[PostgresUtils]

    MultiPaint.postgres.initialize(container)
    Security.postgres.initialize(container)

  // TODO: Scala server processing
}
