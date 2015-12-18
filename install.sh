#!/bin/bash

destdir=$1

cpu_target=$2

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart to $destdir

install -m 755 -d $destdir
install -m 755 -d $destdir/bin
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/appdata
install -m 755 -d $destdir/share/applications
install -m 755 -d $destdir/share/doc
install -m 755 -d $destdir/share/doc/skychart
install -m 755 -d $destdir/share/pixmaps
install -m 755 -d $destdir/share/icons
install -m 755 -d $destdir/share/icons/hicolor
install -m 755 -d $destdir/share/icons/hicolor/48x48
install -m 755 -d $destdir/share/icons/hicolor/48x48/apps
install -m 755 -d $destdir/share/icons/hicolor/scalable
install -m 755 -d $destdir/share/icons/hicolor/scalable/apps

install -v -m 755 -s skychart/cdc  $destdir/bin/skychart
install -v -m 755 -s skychart/cdcicon  $destdir/bin/cdcicon
install -v -m 755 -s varobs/varobs  $destdir/bin/varobs
install -v -m 755 -s varobs/varobs_lpv_bulletin  $destdir/bin/varobs_lpv_bulletin
install -v -m 644 system_integration/Linux/share/applications/skychart.desktop $destdir/share/applications/skychart.desktop
install -v -m 644 system_integration/Linux/share/appdata/skychart.appdata.xml $destdir/share/appdata/skychart.appdata.xml
install -v -m 644 system_integration/Linux/share/doc/skychart/changelog $destdir/share/doc/skychart/changelog
install -v -m 644 system_integration/Linux/share/doc/skychart/copyright $destdir/share/doc/skychart/copyright
install -v -m 644 system_integration/Linux/share/pixmaps/skychart.png $destdir/share/pixmaps/skychart.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/48x48/apps/skychart.png $destdir/share/icons/hicolor/48x48/apps/skychart.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/scalable/apps/skychart.svg $destdir/share/icons/hicolor/scalable/apps/skychart.svg

