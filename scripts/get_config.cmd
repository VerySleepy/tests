@SETLOCAL ENABLEDELAYEDEXPANSION
@ECHO OFF

REM  Retrieve a config value from the registry and store it in the specified environment variable.
REM  Usage: get_config.cmd <option_name> <target_envvar>

SET "VALUE_NAME=%~1"
SET "VAR_NAME=%~2"

FOR /F "usebackq tokens=*" %%v IN (`PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "Get-ItemPropertyValue -Path 'Registry::HKEY_CURRENT_USER\SOFTWARE\codersnotes.com\Very Sleepy' -Name '!VALUE_NAME!' -ErrorAction:SilentlyContinue" ^<NUL`) DO SET "VALUE=%%~v"

ENDLOCAL & SET "%VAR_NAME%=%VALUE%"

