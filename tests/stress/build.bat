@echo off
cd /d "%~dp0"
cmd /c ..\..\scripts\toolchains_download.cmd
call ..\..\scripts\clear_env.cmd

"%~dp0\..\..\toolchains\dmd.2.073.0.windows\dmd2\windows\bin\dmd" program.d -c -betterC -m32mscoff -g -release
if %ERRORLEVEL% neq 0 exit /b 1

call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86

link program.obj kernel32.lib /NOLOGO /SUBSYSTEM:WINDOWS /OUT:program.exe /DEBUG /ENTRY:start
