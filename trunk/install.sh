#!/bin/bash

destdir=$1

cpu_target=$2

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart to $destdir

install -m 755 -d $destdir
install -m 755 -d $destdir/bin
install -m 755 -d $destdir/lib
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/applications
install -m 755 -d $destdir/share/doc
install -m 755 -d $destdir/share/doc/skychart
install -m 755 -d $destdir/share/pixmaps

install -v -m 755 -s skychart/cdc  $destdir/bin/skychart
install -v -m 755 -s skychart/cdcicon  $destdir/bin/cdcicon
install -v -m 755 -s varobs/varobs  $destdir/bin/varobs
install -v -m 755 -s varobs/varobs_lpv_bulletin  $destdir/bin/varobs_lpv_bulletin
install -v -m 644 -s skychart/library/getdss/libgetdss.so  $destdir/lib/libgetdss.so
install -v -m 644 -s skychart/library/plan404/libplan404.so  $destdir/lib/libplan404.so
install -v -m 644 system_integration/Linux/share/applications/skychart.desktop $destdir/share/applications/skychart.desktop
install -v -m 644 system_integration/Linux/share/doc/skychart/changelog $destdir/share/doc/skychart/changelog
install -v -m 644 system_integration/Linux/share/doc/skychart/copyright $destdir/share/doc/skychart/copyright
install -v -m 644 system_integration/Linux/share/pixmaps/skychart.xpm $destdir/share/pixmaps/skychart.png

