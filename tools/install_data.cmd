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

echo Install skychart data to %destdir%

for /F "usebackq" %%d in (`sed "s#/#\\#g" dir.lst`) do (
  echo mkdir %destdir%\%%d 
  mkdir %destdir%\%%d 
)

for /F "usebackq" %%d in (`sed "s#/#\\#g" data.lst`) do (
  echo %%d - %destdir%\%%d
  copy /Y %%d %destdir%\%%d 
)
unzip -d %destdir%\data ..\system_integration\Windows\data\zoneinfo.zip 

for /F "usebackq" %%d in (`sed "s#/#\\#g" doc.lst`) do (
  echo %%d - %destdir%\%%d
  copy /Y %%d %destdir%\%%d 
)

unzip -d %destdir%\doc doc\wiki_doc.zip 

for /F "usebackq" %%d in (`sed "s#/#\\#g" cat.lst`) do (
  echo %%d - %destdir%\%%d
  copy /Y %%d %destdir%\%%d 
)
