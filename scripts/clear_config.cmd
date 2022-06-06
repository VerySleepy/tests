REM Clear the saved config options (in the registry)
SET "TMPOUT=%TEMP%\set_config.out"

REG DELETE "HKCU\SOFTWARE\codersnotes.com\Very Sleepy" /F >"%TMPOUT%" 2>&1
if ERRORLEVEL 1 (
	rem  reg.exe outputs "The operation completed successfully." on success.
	rem    This is nice, but is undesirable for our tests.
	rem    Only emit the output if something fails.
	@echo %~n0: failure
	@type "%TMPOUT%"
	exit /b !ERRORLEVEL!
)
