@echo off
cd /d "%~dp0"
call ..\..\scripts\clear_env.cmd

call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86

cl /MD /Z7 /DEBUG program.c
