@echo off
setlocal enabledelayedexpansion

echo Updating WILL Wiki...

cd %~dp0\..

REM Combine all arguments into a single message
set "msg=%~1"
:loop
shift
if "%~1"=="" goto endloop
set "msg=!msg! %~1"
goto loop
:endloop

REM Stage and commit changes in wiki directory
cd wiki
git add .
git commit -m "!msg!"
git push origin master

echo Wiki update complete!
endlocal
