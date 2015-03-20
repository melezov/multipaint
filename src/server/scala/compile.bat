@echo off

java -jar "%~dp0dsl-clc.jar"^
  -u=marko@mentat-labs.com ^
  -db=localhost:5432/multipaint?user=multipaint^&password=changeit ^
  -dsl="%~dp0..\..\dsl" ^
  -scala_server="%~dp0src\generated\scala" ^
  -download ^
  -namespace=net.multipaint ^
  -settings=active-record,manual-json ^
  -apply

java -jar "%~dp0dcf.jar" "~dp0."
