#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Uninstall skychart from $destdir

rm -fv $destdir/bin/skychart
rm -fv $destdir/bin/cdcicon
rm -fv $destdir/bin/varobs
rm -fv $destdir/bin/varobs_lpv_bulletin
rm -fv $destdir/lib/libgetdss.so
rm -fv $destdir/lib/libplan404.so
rm -fv $destdir/share/applications/skychart.desktop
rm -fv $destdir/share/doc/skychart/changelog
rm -fv $destdir/share/doc/skychart/copyright
rm -fv $destdir/share/pixmaps/skychart.xpm

rmdir -v $destdir/share/doc/skychart
