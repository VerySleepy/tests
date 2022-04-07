@setlocal enabledelayedexpansion
@echo off

rem  usage: test_stat.cmd <sleepy_file_basename> <stat_descr> <target_envvar>
rem  Get <stat_descr> from Stats.txt and save its value in <target_envvar>

set "SLEEPY_BASE=%~1"
set "STAT_DESCR=%~2"
set "TARGET_ENVVAR=%~3"

if exist "!SLEEPY_BASE!" rmdir /S /Q "!SLEEPY_BASE!"
call %~dp0\unpack_to "!SLEEPY_BASE!.sleepy" "!SLEEPY_BASE!" > nul
if errorlevel 1 exit 1

set FOUND=0
set STAT_VALUE=_NOT_FOUND_
if exist "!SLEEPY_BASE!\Stats.txt" (
   for /f "tokens=1,2* delims=: " %%a in (!SLEEPY_BASE!\Stats.txt) do (
       if "%%~a"=="!STAT_DESCR!" (
          set FOUND=1
          set "STAT_VALUE=%%~b"
       )
   )
)
if %FOUND% == 0 exit /b 1

ENDLOCAL & set "%TARGET_ENVVAR%=%STAT_VALUE%"
