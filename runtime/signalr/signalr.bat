@echo off 
taskkill /F /IM Revenj.SignalR2SelfHost.exe

if exist "%~dp0model\ServerModel.dll" del "%~dp0model\ServerModel.dll"

copy "%~dp0..\..\server\csharp\model\ServerModel.dll" "%~dp0model"

start /B /D "%~dp0bin" Revenj.SignalR2SelfHost.exe

echo Starting SignalR ...
echo.
pause > NUL 2>&1

echo.
echo Shutting down SignalR ...
taskkill /F /IM Revenj.SignalR2SelfHost.exe
