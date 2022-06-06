@echo off
setlocal enabledelayedexpansion


rem  Testing Parameter Behavior: `symsearchpath`
rem    To test for this, we will profile a run of program!ARCH!.exe and verify that the expected symbol was/wasn't found.
rem    1. Run without any search path. Ensure that the target symbol is NOT found. (verify search path is meaningful)
rem    2. Run with a search path. Ensure that the target symbol IS found. (verify search path)
rem    3. Run with an empty symbol cache. Ensure that the target symbol is NOT found. (verify cache is meaningful)
rem    4. Run with a search path and a symbol cache. Ensure that the symbol IS found. (build search cache)
rem    5. Run WITHOUT a search path and WITH a symbol cache. Ensure that the symbol IS found. (search cache only)
rem  Testing Parameter Ephemerality
rem    6. Run with a search path that doesn't contain the symbols. The saved search path does contain them.
rem    6. Run with a cache that doesn't contain the symbols. The saved search path does contain them.

set "PGMARCH=%~1"
set CONFIG_SYMPATH=SymbolSearchPath
set CONFIG_SYMCACHE=SymbolCache

set "SCRIPTS_DIR=%~dps0..\..\scripts"

set "EMPTY_SYMDIR=%~dp0empty_symdir"
set "EMPTY_SYMCACHE=%~dp0empty_symcache"

set "SYMDIR=%~dp0symdir!PGMARCH!"
set "SYMCACHE=%~dp0symcache!PGMARCH!"


:SCENARIO_1
rem    1. run without any options: not found
@echo.
@echo scenario 1: symbol not found
call %SCRIPTS_DIR%\clear_config
call :RUN_PROFILER ""
if !SYMBOL_FOUND! neq 0 (@echo ERROR: failed scenario 1) & exit /b 1

:SCENARIO_2
rem    2. run with search path: found
@echo.
@echo scenario 2: symbol found
call %SCRIPTS_DIR%\clear_config
call :RUN_PROFILER "/symsearchpath:!SYMDIR!"
if !SYMBOL_FOUND! neq 1 (@echo ERROR: failed scenario 2) & exit /b 1

:SCENARIO_3
rem    3. Run with an empty symbol cache: not found
@echo.
@echo scenario 3: symbol not found
call %SCRIPTS_DIR%\clear_config
call :CLEAR_DIR "!EMPTY_SYMCACHE!"
call :RUN_PROFILER "/symcachedir:!EMPTY_SYMCACHE!"
if !SYMBOL_FOUND! neq 0 (@echo ERROR: failed scenario 3) & exit /b 1

:SCENARIO_4
rem    4. run with a search path and a symbol cache: found
@echo.
@echo scenario 4: symbol found
call %SCRIPTS_DIR%\clear_config
call :RUN_PROFILER "/symsearchpath:!SYMDIR! /symcachedir:!SYMCACHE!"
if !SYMBOL_FOUND! neq 1 (@echo ERROR: failed scenario 4) & exit /b 1

:SCENARIO_5
rem    5. run WITHOUT a search path and WITH a symbol cache: found
@echo.
@echo scenario 5: symbol found
call %SCRIPTS_DIR%\clear_config
call :RUN_PROFILER "/symcachedir:!SYMCACHE!"
if !SYMBOL_FOUND! neq 1 (@echo ERROR: failed scenario 5) & exit /b 1


rem    6. run with a search path that doesn't contain the symbols, overriding one that contain them: not found
rem    Test the config value.
:SCENARIO_6a
@echo.
@echo scenario 6a: symbol found
call %SCRIPTS_DIR%\clear_config
call %SCRIPTS_DIR%\set_config %CONFIG_SYMPATH% "!SYMDIR!"
call :RUN_PROFILER
if !SYMBOL_FOUND! neq 1 (@echo ERROR: failed scenario 6a) & exit /b 1
:SCENARIO_6b
rem    Test the override
@echo.
@echo scenario 6b: symbol not found
call :CLEAR_DIR "!EMPTY_SYMDIR!"
call %SCRIPTS_DIR%\get_config %CONFIG_SYMPATH% PRE_RUN_SYMPATH
call :RUN_PROFILER "/symsearchpath:!EMPTY_SYMDIR!"
call %SCRIPTS_DIR%\get_config %CONFIG_SYMPATH% POST_RUN_SYMPATH
if !SYMBOL_FOUND! neq 0 (@echo ERROR: failed scenario 6b) & exit /b 1
if not "!PRE_RUN_SYMPATH!"=="!POST_RUN_SYMPATH!" (
	@echo ERROR: symbol path value was incorrectly changed to the cmdline override value.
	exit /b 1
)


rem    7. run with a cache that doesn't contain the symbols, overriding one that contain them: not found
rem    Test the config value.
:SCENARIO_7a
@echo.
@echo scenario 7a: symbol found
call %SCRIPTS_DIR%\clear_config
call %SCRIPTS_DIR%\set_config %CONFIG_SYMCACHE% "!SYMCACHE!"
call :RUN_PROFILER
if !SYMBOL_FOUND! neq 1 (@echo ERROR: failed scenario 7a) & exit /b 1
rem    Test the override
:SCENARIO_7b
@echo.
@echo scenario 7b: symbol not found
call :CLEAR_DIR "!EMPTY_SYMCACHE!"
call %SCRIPTS_DIR%\get_config %CONFIG_SYMCACHE% PRE_RUN_SYMCACHE
call :RUN_PROFILER "/symcachedir:!EMPTY_SYMCACHE!"
call %SCRIPTS_DIR%\get_config %CONFIG_SYMCACHE% POST_RUN_SYMCACHE
if !SYMBOL_FOUND! neq 0 (@echo ERROR: failed scenario 7b) & exit /b 1
if not "!PRE_RUN_SYMCACHE!"=="!POST_RUN_SYMCACHE!" (
	@echo ERROR: symbol cache was incorrectly changed to the cmdline override value.
	exit /b 1
)



exit /b

:SAVE_CONFIG
call %SCRIPTS_DIR%\get_config CONFIG_SYMPATH PRE_RUN_SYMPATH
call %SCRIPTS_DIR%\get_config CONFIG_SYMCACHE PRE_RUN_SYMCACHE



:CLEAR_DIR
if exist "%~1" rmdir /s /q "%~1"
mkdir "%~1"
exit /B



:RUN_PROFILER
SET SYMBOL_FOUND=
setlocal enabledelayedexpansion

rem  Callers should ensure that this parameter does not have/need embedded quotes. They will be lost.
set "ADDL_ARGS=%~1"

if exist program-!PGMARCH!.sleepy del program-!PGMARCH!.sleepy
rem  Ensure that we profile a matching-architecture executable so that the "mismatch" warning doesn't halt the test.
call %SCRIPTS_DIR%\sleepy!pgmarch! /r:program!pgmarch!.exe /o:program-!pgmarch!.sleepy !ADDL_ARGS!
if !ERRORLEVEL! neq 0 exit /b 1

rem  Check for the target symbol.
call %SCRIPTS_DIR%\test_symbol program-!pgmarch! vs_test_fun
set /a IS_SYMBOL_FOUND = 1 - !ERRORLEVEL!
@echo   Found Symbol: !IS_SYMBOL_FOUND!

endlocal & set SYMBOL_FOUND=%IS_SYMBOL_FOUND%
exit /b
