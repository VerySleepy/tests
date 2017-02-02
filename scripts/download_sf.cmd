@echo off
setlocal enabledelayedexpansion

set DEST=%~2
set URL=%~1%~2/download

cmd /c scripts\download "%URL%" "toolchains\%DEST%"
if errorlevel 1 exit /b 1

