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

del %destdir%\skychart.exe
xcopy /Y /F skychart\cdc.exe %destdir%\
rename %destdir%\cdc.exe skychart.exe
xcopy /Y /F skychart\cdcicon.exe %destdir%\
xcopy /Y /F varobs\varobs.exe %destdir%\
xcopy /Y /F varobs\varobs_lpv_bulletin.exe %destdir%\

strip -v %destdir%\skychart.exe
strip -v %destdir%\cdcicon.exe
strip -v %destdir%\varobs.exe
strip -v %destdir%\varobs_lpv_bulletin.exe

xcopy /Y /F skychart\library\getdss\libgetdss.dll  %destdir%\
xcopy /Y /F skychart\library\plan404\libplan404.dll  %destdir%\

unzip -o -d %destdir% system_integration\Windows\data\sqlite3.zip 
unzip -o -d %destdir% system_integration\Windows\data\planetrender.zip
unzip -o -d %destdir% system_integration\Windows\data\zlib.zip
