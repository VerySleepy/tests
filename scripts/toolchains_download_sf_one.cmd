@echo off

cmd /c "%~dp0\download_sf" %1 %2
if errorlevel 1 exit /b 1

set DEST=%~2

if [%DEST:~-3%] == [.7z] (
	call "%~dp0\unpack_to" "toolchains\%DEST%" "toolchains\%DEST:~0,-3%"
) else (
	echo Unknown extension: %2
	exit /b 1
)
