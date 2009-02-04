#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Uninstall skychart from $destdir

rm -fv $destdir/skychart.app/Contents/MacOS/skychart
rm -fv $destdir/cdcicon.app/Contents/MacOS/cdcicon
rm -fv $destdir/varobs.app/Contents/MacOS/varobs
rm -fv $destdir/varobs_lpv_bulletin.app/Contents/MacOS/varobs_lpv_bulletin
rm -fv $destdir/libgetdss.dylib
rm -fv $destdir/libplan404.dylib

rm -rf $destdir/skychart.app 
rm -rf $destdir/cdcicon.app
rm -rf $destdir/varobs_lpv_bulletin.app
rm -rf $destdir/varobs.app
