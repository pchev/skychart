#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Uninstall skychart from $destdir

rm -v $destdir/bin/skychart
rm -v $destdir/lib/libgetdss.so
rm -v $destdir/lib/libplan404.so
rm -v $destdir/share/applications/skychart.desktop
rm -v $destdir/share/doc/skychart/changelog
rm -v $destdir/share/doc/skychart/copyright
rm -v $destdir/share/pixmaps/skychart.xpm

rmdir -v $destdir/share/doc/skychart
rmdir -v $destdir/share/doc
rmdir -v $destdir/share/applications
rmdir -v $destdir/share/pixmaps
rmdir -v $destdir/share
rmdir -v $destdir/bin
rmdir -v $destdir/lib
rmdir -v $destdir
