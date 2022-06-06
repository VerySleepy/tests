@setlocal enabledelayedexpansion
@echo off

rem  Set a config value (that's a string/REG_SZ) in the registry.
rem  Usage: set_config.cmd option_name new_value

set "VALUE_NAME=%~1"
set "VALUE_DATA=%~2"

SET "TMPOUT=%TEMP%\set_config.out"
reg add "HKCU\SOFTWARE\codersnotes.com\Very Sleepy" /v "!VALUE_NAME!" /t REG_SZ /d "!VALUE_DATA!" /f >"%TMPOUT%" 2>&1
if ERRORLEVEL 1 (
	rem  reg.exe outputs "The operation completed successfully." on success.
	rem	 This is nice, but is undesirable for our tests.
	rem	 Only emit the output if something fails.
	@type "%TMPOUT%"
	exit /b !ERRORLEVEL!
)

