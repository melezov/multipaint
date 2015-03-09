@echo off 
taskkill /F /FI "IMAGENAME eq Revenj*"
taskkill /F /IM nginx.exe
taskkill /F /IM php-cgi.exe

copy /Y "%~dp0events\Events\bin\Debug\Events.dll" "%~dp0plugins\Events.dll" > NUL

start /B /D "%~dp0revenj" Revenj.Http.exe
start /B /D "%~dp0signalr" Revenj.SignalR2SelfHost.exe
start /B /D "%~dp0..\nginx" nginx.exe
start /B php-cgi.exe -b localhost:9003

pause

taskkill /F /FI "IMAGENAME eq Revenj*"
taskkill /F /IM nginx.exe
taskkill /F /IM php-cgi.exe
