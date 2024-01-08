#!/bin/bash

OS_TARGET=$1
destdir=$2

if [ -z "$OS_TARGET=" ]; then
   export OS_TARGET==win32
fi

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart $OS_TARGET to $destdir

install -m 755 -d $destdir

if [ $OS_TARGET = win32 ]; then 
  strip -v -o $destdir/skychart.exe skychart/cdc.exe 
  strip -v -o $destdir/cdcicon.exe skychart/cdcicon.exe
  strip -v -o $destdir/catgen.exe skychart/catgen.exe
  strip -v -o $destdir/varobs.exe varobs/varobs.exe
  strip -v -o $destdir/libplan404.dll skychart/library/plan404/libplan404.dll
  strip -v -o $destdir/libcdcwcs.dll skychart/library/wcs/libcdcwcs.dll
  strip -v -o $destdir/libgetdss.dll skychart/library/getdss/libgetdss.dll
  strip -v -o $destdir/libchealpix.dll skychart/library/chealpix/libchealpix.dll
  strip -v -o $destdir/libcalceph.dll skychart/library/calceph/libcalceph.dll
  unzip -d $destdir system_integration/Windows/data/sqlite3.zip
  unzip -d $destdir system_integration/Windows/data/zlib.zip
  unzip -d $destdir system_integration/Windows/data/openssl-win32.zip
  unzip -d $destdir system_integration/Windows/data/openssl1-win32.zip
  install -m 755 -d $destdir/data
  install -m 755 -d $destdir/data/planet
  unzip -d $destdir/data/planet/ system_integration/Windows/data/xplanet-windows.zip
fi
if [ $OS_TARGET = win64 ]; then
  strip -v -o $destdir/skychart.exe skychart/cdc.exe
  strip -v -o $destdir/cdcicon.exe skychart/cdcicon.exe
  strip -v -o $destdir/catgen.exe skychart/catgen.exe
  strip -v -o $destdir/varobs.exe varobs/varobs.exe
  strip -v -o $destdir/libplan404.dll skychart/library/plan404/libplan404.dll
  strip -v -o $destdir/libcdcwcs.dll skychart/library/wcs/libcdcwcs.dll
  strip -v -o $destdir/libgetdss.dll skychart/library/getdss/libgetdss.dll
  strip -v -o $destdir/libchealpix.dll skychart/library/chealpix/libchealpix.dll
  strip -v -o $destdir/libcalceph.dll skychart/library/calceph/libcalceph.dll
  unzip -d $destdir system_integration/Windows/data/sqlite3_x64.zip
  unzip -d $destdir system_integration/Windows/data/zlib_x64.zip
  unzip -d $destdir system_integration/Windows/data/openssl-win64.zip
  unzip -d $destdir system_integration/Windows/data/openssl1-win64.zip
  install -m 755 -d $destdir/data
  install -m 755 -d $destdir/data/planet
  unzip -d $destdir/data/planet/ system_integration/Windows/data/xplanet-windows.zip
fi

