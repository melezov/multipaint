
java -jar "%~dp0dsl-clc.jar"^
  -u=marko@mentat-labs.com ^
  -db=localhost:5432/multipaint?user=multipaint^&password=changeit ^
  -dsl="%~dp0..\..\dsl" ^
  -java_client="%~dp0lib\model.jar" ^
  -download ^
  -dependencies:java_client="%~dp0dependencies" ^
  -settings=active-record,manual-json