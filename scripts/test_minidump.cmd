@echo off

rem  usage: test_minidump.cmd <sleepy_file_basename>

if exist %1 rmdir /S /Q %1
call %~dp0\unpack_to %1.sleepy %1 > nul
if errorlevel 1 exit /b 1

set FOUND=0
if exist "%~1\minidump.dmp" set FOUND=1

if %FOUND% == 0 exit /b 1
