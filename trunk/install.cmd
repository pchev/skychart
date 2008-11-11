@echo off

set destdir=%1%

if not defined destdir ( 
  echo Specify the install directory 
  exit 1
)

if not exist %destdir% ( 
  echo create directory %destdir% 
  mkdir %destdir%
)

if not exist %destdir% ( 
  echo directory %destdir% do not exist 
  exit 1
)

echo Install skychart to %destdir%

strip -v -o %destdir%\skychart.exe skychart\cdc.exe 
strip -v -o %destdir%\cdcicon.exe skychart\cdcicon.exe
strip -v -o %destdir%\varobs.exe varobs\varobs.exe
strip -v -o %destdir%\varobs_lpv_bulletin.exe varobs\varobs_lpv_bulletin.exe
xcopy /Y /F skychart\library\getdss\libgetdss.dll  %destdir%\
xcopy /Y /F skychart\library\plan404\libplan404.dll  %destdir%\

unzip -d %destdir% system_integration\Windows\data\sqlite3.zip 
unzip -d %destdir% system_integration\Windows\data\plugins.zip 
