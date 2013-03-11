@echo off
rem
rem create freepascal Makefile to build skychart
rem
rem set the variable below before to run
rem
rem To compile the C libraries getdss and plan404 
rem you need to install Mingw and add them to your PATH
rem I have success with http://mingw-w64.sourceforge.net

rem ################################################################
rem start parameters

rem where you install sed  ( http://gnuwin32.sourceforge.net/packages/sed.htm )
set sed=C:\GnuWin32\bin

rem where you install fpc 
set fpc=C:\pp\bin\x86_64-win64

rem where you install lazarus (keep double \\ for path) 
set lazarus=C:\\lazarus

rem where you want to install CdC (keep double \\ for path)
set prefix=C:\\appli\\cdc

rem end of parameters
rem ################################################################

set basedir=%CD%
set PATH=%basedir%;%fpc%;%sed%;%PATH%

rem test sed
sed --version
if %ERRORLEVEL% NEQ 0 (
  echo .
  echo Please edit configure.cmd to set the path to fpc, lazarus and sed
  goto :EOF
)
rem test fpc
fpc -iV
if %ERRORLEVEL% NEQ 0 (
  echo .
  echo Please edit configure.cmd to set the path to fpc, lazarus and sed
  goto :EOF
)

echo skychart\component\synapse\source\lib > dirs.lst
echo skychart\component\libsql >> dirs.lst
echo skychart\component\mrecsort >> dirs.lst
echo skychart\component\uniqueinstance >> dirs.lst
echo skychart\component\xmlparser >> dirs.lst
echo skychart\component\enhedits >> dirs.lst
echo skychart\component\radec >> dirs.lst
echo skychart\component\zoomimage >> dirs.lst
echo skychart\component\downloaddialog >> dirs.lst
echo skychart\component\jdcalendar >> dirs.lst
echo skychart\component\multidoc >> dirs.lst
echo skychart\component\vo >> dirs.lst
echo skychart\component >> dirs.lst
echo skychart\library\catalog >> dirs.lst
echo skychart\library\elp82 >> dirs.lst
echo skychart\library\satxy >> dirs.lst
echo skychart\library\series96 >> dirs.lst
echo skychart\library >> dirs.lst
echo skychart >> dirs.lst
echo varobs >> dirs.lst
echo . >> dirs.lst

echo using fpc in %fpc%
echo using Lazarus in %lazarus%
echo installing in %prefix%

for /F  %%d in (dirs.lst) do  (
   echo creating %%d\Makefile 
   cd %%d
   sed "s/\%%LAZDIR\%%/%lazarus%/" Makefile.in > Makefile.fpc
   sed -i "s/\%%PREFIX\%%/%prefix%/" Makefile.fpc
   fpcmake -q Makefile.fpc
   cd %basedir%
)
del dirs.lst

cd tools
sed "s/\%%PREFIX\%%/%prefix%/" Makefile.in > Makefile
cd %basedir%

echo You can now run make 
echo then make install 
echo and make install_data
