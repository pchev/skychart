#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Uninstall skychart from $destdir

rm -fv $destdir/skychart.exe
rm -fv $destdir/cdcicon.exe
rm -fv $destdir/varobs.exe
rm -fv $destdir/varobs_lpv_bulletin.exe
rm -fv $destdir/libgetdss.dll
rm -fv $destdir/libplan404.dll
rm -fv $destdir/sqlite3.dll
rm -fv $destdir/libFPlanetRender.dll
rm -fv $destdir/zlib1.dll
