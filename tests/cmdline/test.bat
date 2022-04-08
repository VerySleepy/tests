@echo off
setlocal enabledelayedexpansion
if not exist program32.exe call build
if not exist program64.exe call build

rem https://github.com/VerySleepy/verysleepy/issues/28

rem Verify that command-line options are honored and do not override saved configuration settings.

set SLEEPY_SILENT_CRASH=1

for %%b in (32 64) do (
	echo Testing %%b

        FOR %%o in (minidump samplerate symopts) do (
		rem  Discard any saved config options.
		call ..\..\scripts\clear_config
	
                call test_cmdline_%%o.cmd %%b
		if !ERRORLEVEL! neq 0 exit /b 1
	)
)

echo %~dp0 OK
