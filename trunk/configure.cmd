@echo off
rem
rem create freepascal Makefile to build skychart
rem
rem syntaxe :
rem            ./configure [fpc=path_to_fpc] [lazarus=path_to_lazarus] [prefix=install_path]
rem

set lazarus=D:\\\lazarus
set fpc=D:\\\lazarus\\\fpc\\\2.2.2\\\bin\\\i386-win32
set prefix=C:\\\temp
set basedir=%CD%

set PATH=%basedir%;%fpc%;C:\WINDOWS\system32;C:\WINDOWS

echo skychart\\\component\\\synapse\\\source\\\lib > dirs.lst
echo skychart\\\component\\\libsql >> dirs.lst
echo skychart\\\component\\\mrecsort >> dirs.lst
echo skychart\\\component\\\uniqueinstance >> dirs.lst
echo skychart\\\component\\\xmlparser >> dirs.lst
echo skychart\\\component\\\enhedits >> dirs.lst
echo skychart\\\component\\\radec >> dirs.lst
echo skychart\\\component\\\zoomimage >> dirs.lst
echo skychart\\\component\\\downloaddialog >> dirs.lst
echo skychart\\\component\\\jdcalendar >> dirs.lst
echo skychart\\\component\\\multidoc >> dirs.lst
echo skychart\\\component\\\vo >> dirs.lst
echo skychart\\\component >> dirs.lst
echo skychart\\\library\\\catalog >> dirs.lst
echo skychart\\\library\\\elp82 >> dirs.lst
echo skychart\\\library\\\satxy >> dirs.lst
echo skychart\\\library\\\series96 >> dirs.lst
echo skychart\\\library >> dirs.lst
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

rem  replace fpc install by own script and add uninstall script
sed  -i "s/^install:\(.*\)$/install: \n\t.\\\install.cmd \$(PREFIX)\nuninstall: \n\t.\\\uninstall.cmd \$(PREFIX)/g" Makefile

rem add data install
echo data: >> Makefile
echo 	$(MAKE) -C tools all >> Makefile
echo install_data: >> Makefile
echo 	$(MAKE) -C tools install >> Makefile 
echo uninstall_data: >> Makefile
echo 	$(MAKE) -C tools uninstall >> Makefile

cd tools
sed "s/\%%PREFIX\%%/%prefix%/" Makefile.in > Makefile
cd %basedir%

echo You can now run make 
echo then make install 
echo and make install_data
