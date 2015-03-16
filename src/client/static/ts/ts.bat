@echo off

dir /b /s "%~dp0*.ts" > "%~dp0ts-all.txt"
tsc "@%~dp0ts-all.txt" -target ES5 --out "%~dp0..\js\multipaint.js" --sourceMap
del "%~dp0ts-all.txt"
