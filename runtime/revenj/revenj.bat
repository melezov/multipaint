@echo off 
taskkill /F /IM Revenj.Http.exe

if exist "%~dp0model\ServerModel.dll" del "%~dp0model\ServerModel.dll"
if exist "%~dp0events\events.dll" del "%~dp0events\events.dll"

copy "%~dp0..\..\server\csharp\model\ServerModel.dll" "%~dp0model"
copy "%~dp0..\..\server\csharp\events\bin\Debug\events.dll" "%~dp0events"

start /B /D "%~dp0bin" Revenj.Http.exe

echo Starting Revenj ...
echo.
pause > NUL 2>&1

echo.
echo Shutting down Revenj ...
taskkill /F /IM Revenj.Http.exe
