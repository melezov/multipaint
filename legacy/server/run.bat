@echo off 
taskkill /F /FI "IMAGENAME eq Revenj*"
rem taskkill /F /IM nginx.exe
rem taskkill /F /IM php-cgi.exe

copy /Y "%~dp0events\Events\bin\Debug\Events.dll" "%~dp0plugins\Events.dll" > NUL

start /B /D "%~dp0revenj" Revenj.Http.exe
rem start /B /D "%~dp0signalr" Revenj.SignalR2SelfHost.exe
rem start /B /D "%~dp0..\nginx" nginx.exe
rem start /B php-cgi.exe -b localhost:9003

pause

taskkill /F /FI "IMAGENAME eq Revenj*"
rem taskkill /F /IM nginx.exe
rem taskkill /F /IM php-cgi.exe
