@echo off
setlocal enabledelayedexpansion
if not exist program.exe call build

set SLEEPY_SILENT_CRASH=1

for %%b in (32 64) do (
	echo Testing %%b
	if exist program-%%b.sleepy del program-%%b.sleepy
	call ..\..\scripts\sleepy%%b /d:1 /t:60 /r:program.exe /o:program-%%b.sleepy
	if !ERRORLEVEL! neq 0 exit /b 1

	call ..\..\scripts\test_symbol program-%%b program.vs_test_fun
	if !ERRORLEVEL! neq 0 echo Symbols not decoded & exit /b 1
)

echo %~dp0 OK
