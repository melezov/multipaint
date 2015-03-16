@echo off

taskkill /F /IM nginx.exe

echo Copying static resources ...
if exist "%~dp0static" rmdir /S /Q "%~dp0static"
mkdir "%~dp0static"

mkdir "%~dp0static\css"
copy "%~dp0..\..\client\static\css\*.css" "%~dp0static\css"

mkdir "%~dp0static\js"
copy "%~dp0..\..\client\static\js\*.js" "%~dp0static\js"

mkdir "%~dp0static\images"
copy "%~dp0..\..\client\static\images\*.png" "%~dp0static\images"

copy "%~dp0..\..\client\static\favicon\favicon.ico" "%~dp0static\images"

start /B nginx.exe

echo Starting Nginx ...
echo.
pause > NUL 2>&1

echo.
echo Shutting down Nginx ...
taskkill /F /IM nginx.exe
