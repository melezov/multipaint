@echo off 
taskkill /F /IM php-cgi.exe

echo Bundling PHP ...
echo.

if exist "%~dp0app\client.phar" del "%~dp0app\client.phar"

php.exe "%~dp0bundle\bundle.php"

start /B php-cgi.exe -b multipaint-php:9003
echo.
echo Starting PHP ...
echo.
pause > NUL 2>&1

echo.
echo Shutting down PHP ...
taskkill /F /IM php-cgi.exe
