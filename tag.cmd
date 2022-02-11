@echo off
setlocal
set name=%~nx1
set tag=%2
ren "%name%" "[%tag%] %name%"
exit 0