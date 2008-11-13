#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart to $destdir

install -m 755 -d $destdir
fpc-i386-win32-strip -v -o $destdir/skychart.exe skychart/cdc.exe 
fpc-i386-win32-strip -v -o $destdir/cdcicon.exe skychart/cdcicon.exe
fpc-i386-win32-strip -v -o $destdir/varobs.exe varobs/varobs.exe
fpc-i386-win32-strip -v -o $destdir/varobs_lpv_bulletin.exe varobs/varobs_lpv_bulletin.exe
install -v -m 644 skychart/library/getdss/libgetdss.dll  $destdir/
install -v -m 644 skychart/library/plan404/libplan404.dll  $destdir/

unzip -d $destdir system_integration/Windows/data/sqlite3.zip
unzip -d $destdir system_integration/Windows/data/plugins.zip
unzip -d $destdir system_integration/Windows/data/planetrender.zip
unzip -d $destdir system_integration/Windows/data/zlib.zip
