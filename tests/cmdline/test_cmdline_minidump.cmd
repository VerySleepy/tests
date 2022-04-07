@echo off
setlocal enabledelayedexpansion

set "PGMARCH=%~1"

call ..\..\scripts\get_config SaveMinidump START_MINIDUMP_VALUE
IF NOT "!START_MINIDUMP_VALUE!"=="" (IF "START_MINIDUMP_VALUE"=="429496729" (SET /A START_MINIDUMP_VALUE=-1) ELSE (SET /A START_MINIDUMP_VALUE=START_MINIDUMP_VALUE))

SET TEST_MINIDUMP_VALUE=2

IF "!START_MINIDUMP_VALUE!"=="!TEST_MINIDUMP_VALUE!" (SET /A TEST_MINIDUMP_VALUE=TEST_MINIDUMP_VALUE+1)
@echo  Test MiniDump value: !TEST_MINIDUMP_VALUE!

if exist program-!PGMARCH!.sleepy del program-!PGMARCH!.sleepy
rem  Ensure that we profile a matching-architecture executable so that the "mismatch" warning doesn't halt the test.
call ..\..\scripts\sleepy!pgmarch! /r:program!pgmarch!.exe /o:program-!pgmarch!.sleepy /minidump:!TEST_MINIDUMP_VALUE!
if !ERRORLEVEL! neq 0 exit /b 1

rem  Verify the capture has a dump.
call ..\..\scripts\test_minidump program-!pgmarch!
if !ERRORLEVEL! neq 0 echo Minidump not taken & exit /b 1

rem  Verify that the config value didn't change to what we specified.
rem  It will change if it wasn't set, but not to what we specified.
call ..\..\scripts\get_config SaveMinidump FINAL_MINIDUMP_VALUE

IF "!FINAL_MINIDUMP_VALUE!"=="!TEST_MINIDUMP_VALUE!" (
   echo ERROR: SaveMinidump value was changed to the cmdline override value.
   exit /b 1
)
