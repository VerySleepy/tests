@echo off
setlocal enabledelayedexpansion

set "PGMARCH=%~1"

set "SCRIPTS_DIR=%~dps0..\..\scripts"

call %SCRIPTS_DIR%\get_config SaveMinidump START_MINIDUMP_VALUE
IF NOT "!START_MINIDUMP_VALUE!"=="" (IF "START_MINIDUMP_VALUE"=="429496729" (set /a START_MINIDUMP_VALUE=-1) ELSE (set /a START_MINIDUMP_VALUE=START_MINIDUMP_VALUE))

rem
rem  Test with the behavior turned OFF.
rem

set TEST_MINIDUMP_VALUE=2

if "!START_MINIDUMP_VALUE!"=="!TEST_MINIDUMP_VALUE!" (set /a TEST_MINIDUMP_VALUE=TEST_MINIDUMP_VALUE+1)
@echo Test MiniDump value: !TEST_MINIDUMP_VALUE!

if exist program-!PGMARCH!.sleepy del program-!PGMARCH!.sleepy
rem  Ensure that we profile a matching-architecture executable so that the "mismatch" warning doesn't halt the test.
call %SCRIPTS_DIR%\sleepy!pgmarch! /r:program!pgmarch!.exe /o:program-!pgmarch!.sleepy /minidump:!TEST_MINIDUMP_VALUE!
if !ERRORLEVEL! neq 0 exit /b 1

rem  Verify the capture has a dump.
call %SCRIPTS_DIR%\test_minidump program-!pgmarch!
if !ERRORLEVEL! neq 0 ( @echo	Minidump not taken & exit /b 1 ) else ( @echo	Minidump taken )

rem  Verify that the config value didn't change to what we specified.
rem  It will change if it wasn't set, but not to what we specified.
call %SCRIPTS_DIR%\get_config SaveMinidump FINAL_MINIDUMP_VALUE

if "!FINAL_MINIDUMP_VALUE!"=="!TEST_MINIDUMP_VALUE!" (
	@echo ERROR: SaveMinidump value was changed to the cmdline override value.
	exit /b 1
)


rem
rem  Test with the behavior turned OFF.
rem

rem	Anything less than 0 means "no minidump"
rem	We want to use something different than what's in the saved config (often, -1).
set TEST_MINIDUMP_VALUE=-2

if "!START_MINIDUMP_VALUE!"=="!TEST_MINIDUMP_VALUE!" (set /a TEST_MINIDUMP_VALUE=TEST_MINIDUMP_VALUE+1)
@echo Test MiniDump value: !TEST_MINIDUMP_VALUE!

if exist program-!PGMARCH!.sleepy del program-!PGMARCH!.sleepy
rem  Ensure that we profile a matching-architecture executable so that the "mismatch" warning doesn't halt the test.
call %SCRIPTS_DIR%\sleepy!pgmarch! /r:program!pgmarch!.exe /o:program-!pgmarch!.sleepy /minidump:!TEST_MINIDUMP_VALUE!
if !ERRORLEVEL! neq 0 exit /b 1

rem  Verify the capture does not dave a dump.
call %SCRIPTS_DIR%\test_minidump program-!pgmarch!
if !ERRORLEVEL! neq 1 ( @echo	Minidump taken but should not have been & exit /b 1 ) else ( @echo	Minidump not taken )

rem  Verify that the config value didn't change to what we specified.
rem  It will change if it wasn't set, but not to what we specified.
call %SCRIPTS_DIR%\get_config SaveMinidump FINAL_MINIDUMP_VALUE

if "!FINAL_MINIDUMP_VALUE!"=="!TEST_MINIDUMP_VALUE!" (
	@echo ERROR: SaveMinidump value was changed to the cmdline override value.
	exit /b 1
)
