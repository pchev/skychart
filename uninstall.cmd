@echo off

set destdir=%1%

if not defined destdir ( 
  echo Specify the install directory 
  exit 1
)

if not exist %destdir% ( 
  echo directory %destdir% do not exist 
  exit 1
)

echo uninstall skychart from %destdir%

del /F %destdir%\skychart.exe 
del /F %destdir%\varobs.exe
del /F %destdir%\varobs_lpv_bulletin.exe
del /F %destdir%\libgetdss.dll
del /F %destdir%\libplan404.dll  
del /F %destdir%\sqlite3.dll  
