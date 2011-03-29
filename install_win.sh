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
  i386-win32-strip -v -o $destdir/skychart.exe skychart/cdc.exe 
  i386-win32-strip -v -o $destdir/cdcicon.exe skychart/cdcicon.exe
  i386-win32-strip -v -o $destdir/varobs.exe varobs/varobs.exe
  i386-win32-strip -v -o $destdir/varobs_lpv_bulletin.exe varobs/varobs_lpv_bulletin.exe
  install -v -m 644 skychart/library/getdss/libgetdss.dll  $destdir/
  install -v -m 644 skychart/library/plan404/libplan404.dll  $destdir/
  unzip -d $destdir system_integration/Windows/data/sqlite3.zip
  unzip -d $destdir system_integration/Windows/data/plugins.zip
  unzip -d $destdir system_integration/Windows/data/zlib.zip
  install -m 755 -d $destdir/data
  install -m 755 -d $destdir/data/planet
  unzip -d $destdir/data/planet/ system_integration/Windows/data/xplanet-windows.zip
fi
if [ $OS_TARGET = win64 ]; then
  x86_64-win64-strip -v -o $destdir/skychart.exe skychart/cdc.exe
  x86_64-win64-strip -v -o $destdir/cdcicon.exe skychart/cdcicon.exe
  x86_64-win64-strip -v -o $destdir/varobs.exe varobs/varobs.exe
  x86_64-win64-strip -v -o $destdir/varobs_lpv_bulletin.exe varobs/varobs_lpv_bulletin.exe
  install -v -m 644 skychart/library/plan404/libplan404_x64.dll  $destdir/libplan404.dll
  unzip -d $destdir system_integration/Windows/data/sqlite3_x64.zip
  unzip -d $destdir system_integration/Windows/data/zlib_x64.zip
  install -m 755 -d $destdir/data
  install -m 755 -d $destdir/data/planet
  unzip -d $destdir/data/planet/ system_integration/Windows/data/xplanet-windows.zip
  # win64 specific:
  install -m 755 -d $destdir/data
  install -m 755 -d $destdir/data/iridflar
  unzip -d $destdir/data/iridflar system_integration/Windows/data/dosbox.zip
fi

