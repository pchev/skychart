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

echo Uninstall skychart from %destdir%
for /F "usebackq" %%d in (`sed "s#/#\\#g" data.lst`) do (
  del /F /Q  %destdir%\%%d > null 2>&1
)

for /F "usebackq" %%d in (`sed "s#/#\\#g" doc.lst`) do (
  del /F /Q  %destdir%\%%d > null 2>&1
)

del /F /S /Q %destdir%\doc\wiki_doc > null 2>&1

for /F "usebackq" %%d in (`sed "s#/#\\#g" cat.lst`) do (
  del /F /Q  %destdir%\%%d > null 2>&1
)

for /F "usebackq" %%d in (`sed "s#/#\\#g" dir.lst`) do (
  rmdir /S /Q %destdir%\%%d > null 2>&1
)
del null
exit 0
