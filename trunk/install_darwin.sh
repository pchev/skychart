#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart to $destdir

install -m 755 -d $destdir
cp -R -p system_integration/MacOSX/pkg/skychart.app $destdir/
#cp -R -p system_integration/MacOSX/pkg/cdcicon.app $destdir/
#cp -R -p system_integration/MacOSX/pkg/varobs_lpv_bulletin.app $destdir/
#cp -R -p system_integration/MacOSX/pkg/varobs.app $destdir/

install -v -m 755 -s skychart/cdc  $destdir/skychart.app/Contents/MacOS/skychart
#install -v -m 755 -s skychart/cdcicon $destdir/cdcicon.app/Contents/MacOS/cdcicon
#install -v -m 755 -s varobs/varobs $destdir/varobs.app/Contents/MacOS/varobs
#install -v -m 755 -s varobs/varobs_lpv_bulletin  $destdir/varobs_lpv_bulletin.app/Contents/MacOS/varobs_lpv_bulletin
install -v -m 755 skychart/library/getdss/libgetdss.dylib  $destdir/libgetdss.dylib
install -v -m 755 skychart/library/plan404/libplan404.dylib  $destdir/libplan404.dylib

