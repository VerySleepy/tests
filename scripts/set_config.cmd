@setlocal enabledelayedexpansion
@echo off

rem  Set a config value (that's a string/REG_SZ) in the registry.
rem  Usage: set_config.cmd <option_name> <new_value>

set "VALUE_NAME=%~1"
set "VALUE_DATA=%~2"

reg add "HKCU\SOFTWARE\codersnotes.com\Very Sleepy" /v "!VALUE_NAME!" /t REG_SZ /d "!VALUE_DATA!" /f

