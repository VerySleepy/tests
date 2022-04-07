@setlocal
@echo off
cd /d "%~dp0"
call ..\..\scripts\clear_env.cmd

rem https://github.com/VerySleepy/verysleepy/issues/28

SETLOCAL
call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
cl /MD /Z7 program.c /Fe:program32.exe /link /DEBUG:FASTLINK
ENDLOCAL

SETLOCAL
call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
cl /MD /Z7 program.c /Fe:program64.exe /link /DEBUG:FASTLINK
ENDLOCAL
