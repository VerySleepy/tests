@echo off

pushd "%~dp0"
cd ..

if not exist toolchains mkdir toolchains

rem Note: we must use cmd /c instead of call, as otherwise cmd will re-interpret the %-sequences in the URL

cmd /c scripts\toolchains_download_sf_one https://sourceforge.net/projects/mingw-w64/files/Toolchains%%20targetting%%20Win32/Personal%%20Builds/mingw-builds/4.9.1/threads-posix/dwarf/ i686-4.9.1-release-posix-dwarf-rt_v3-rev0.7z
if errorlevel 1 exit /b 1
cmd /c scripts\toolchains_download_sf_one https://sourceforge.net/projects/mingw-w64/files/Toolchains%%20targetting%%20Win64/Personal%%20Builds/mingw-builds/4.9.1/threads-posix/seh/   x86_64-4.9.1-release-posix-seh-rt_v3-rev0.7z
if errorlevel 1 exit /b 1



popd
