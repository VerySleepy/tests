@echo off
cd /d "%~dp0"
cmd /c ..\..\scripts\toolchains_download.cmd
call ..\..\scripts\clear_env.cmd

rem https://sourceforge.net/projects/mingw/files/MinGW/Base/gcc/Version4/Previous%20Testing_%20gcc-4.3.0-20080502-mingw32-alpha/gcc-4.3.0-20080502-mingw32-alpha-bin.7z/download
::set PATH=%~dp0\..\..\toolchains\gcc-4.3.0-20080502-mingw32-alpha-bin\bin;%~dp0\..\..\toolchains\gcc-4.3.0-20080502-mingw32-alpha-bin\libexec\gcc\mingw32\4.3.0;%PATH%

rem https://sourceforge.net/projects/mingw/files/MinGW/Base/binutils/binutils-2.19/binutils-2.19-2-mingw32-bin.tar.gz/download
::set PATH=%~dp0\..\..\toolchains\binutils-2.19-2-mingw32-bin\bin;%PATH%

rem https://sourceforge.net/projects/mingw/files/MinGW/Base/gcc/Version4/Previous%20Testing_%20gcc-4.3.0-20080502-mingw32-alpha/gcc-part-core-4.3.0-20080502-2-mingw32-alpha-bin.tar.gz/download
::set PATH=%~dp0\..\..\toolchains\gcc-4.3.3-tdm-1-dw2-core\bin;%PATH%

rem https://sourceforge.net/projects/mingw/files/MinGW/Base/mingwrt/mingwrt-3.18/mingwrt-3.18-mingw32-dev.tar.gz/download
::set LIBPATH=%~dp0\..\..\toolchains\mingwrt-3.18-mingw32-dev\lib

::%~dp0\..\..\toolchains\gcc-4.3.0-20080502-mingw32-alpha-bin\bin\gcc.exe -g -o%~dp0/test -L-L%LIBPATH% %~dp0/test.c

cd C:\Temp

rem gcc43 = binutils-2.19-2-mingw32-bin + gcc-4.3.0-20080502-mingw32-alpha-bin + mingwrt-3.18-mingw32-dev + w32api-3.14-mingw32-dev

"%~dp0\..\..\toolchains\gcc43\bin\gcc.exe" -g -o%~dp0/test -L-L%LIBPATH% %~dp0/test.c
