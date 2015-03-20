name := "multipaint-server"

scalaVersion  := "2.11.6"

scalacOptions := Seq(
  "-unchecked", 
  "-deprecation", 
  "-encoding", "UTF-8"
)

libraryDependencies ++= Seq(
  "hr.ngs" %% "dsl-server-core" % "0.4.3-SNAPSHOT"
, "ch.qos.logback" % "logback-classic" % "1.1.2"
)

unmanagedSourceDirectories in Compile += baseDirectory.value / "src" / "generated" / "scala"

resolvers in ThisBuild := Seq("NGS Nexus" at "http://ngs.hr/nexus/content/groups/public/")
