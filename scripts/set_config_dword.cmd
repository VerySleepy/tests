@setlocal enabledelayedexpansion
@echo off

rem  Set a config value (that's a DWORD) in the registry.
rem  Usage: set_config_dword.cmd <option_name> <new_value>

set "VALUE_NAME=%~1"
set "VALUE_DATA=%~2"

reg add "HKCU\SOFTWARE\codersnotes.com\Very Sleepy" /v "!VALUE_NAME!" /t REG_DWORD /d !VALUE_DATA! /f

