@setlocal
@echo off
cd /d "%~dp0"
call ..\..\scripts\clear_env.cmd

rem  Build executables for two different architectures.
rem    Ensure that the .pdb is _not_ in the same dir as the executable.

SETLOCAL
call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
cl /MD /Z7 program.c /Fe:program32.exe /link /DEBUG:FASTLINK
if not exist "%~dp0symdir32" mkdir "%~dp0symdir32"
move /y program32.pdb "%~dp0symdir32"
ENDLOCAL

SETLOCAL
call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
cl /MD /Z7 program.c /Fe:program64.exe /link /DEBUG:FASTLINK
if not exist "%~dp0symdir64" mkdir "%~dp0symdir64"
move /y program64.pdb "%~dp0symdir64"
ENDLOCAL
