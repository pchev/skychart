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
install -m 755 -d $destdir/share/metainfo
install -m 755 -d $destdir/share/applications
install -m 755 -d $destdir/share/mime
install -m 755 -d $destdir/share/mime/packages
install -m 755 -d $destdir/share/doc
install -m 755 -d $destdir/share/doc/skychart
install -m 755 -d $destdir/share/pixmaps
install -m 755 -d $destdir/share/icons
install -m 755 -d $destdir/share/icons/hicolor
install -m 755 -d $destdir/share/icons/hicolor/32x32
install -m 755 -d $destdir/share/icons/hicolor/32x32/apps
install -m 755 -d $destdir/share/icons/hicolor/48x48
install -m 755 -d $destdir/share/icons/hicolor/48x48/apps
install -m 755 -d $destdir/share/icons/hicolor/96x96
install -m 755 -d $destdir/share/icons/hicolor/96x96/apps
install -m 755 -d $destdir/share/icons/hicolor/scalable
install -m 755 -d $destdir/share/icons/hicolor/scalable/apps

install -v -m 755 -s skychart/cdc  $destdir/bin/skychart
install -v -m 755 -s skychart/cdcicon  $destdir/bin/cdcicon
install -v -m 755 -s skychart/catgen  $destdir/bin/catgen
install -v -m 755 -s varobs/varobs  $destdir/bin/varobs
install -v -m 644 system_integration/Linux/share/applications/net.ap_i.skychart.desktop $destdir/share/applications/net.ap_i.skychart.desktop
install -v -m 644 system_integration/Linux/share/applications/net.ap_i.catgen.desktop $destdir/share/applications/net.ap_i.catgen.desktop
install -v -m 644 system_integration/Linux/share/applications/net.ap_i.varobs.desktop $destdir/share/applications/net.ap_i.varobs.desktop
install -v -m 644 system_integration/Linux/share/metainfo/net.ap_i.skychart.metainfo.xml $destdir/share/metainfo/net.ap_i.skychart.metainfo.xml
install -v -m 644 system_integration/Linux/share/metainfo/net.ap_i.catgen.metainfo.xml $destdir/share/metainfo/net.ap_i.catgen.metainfo.xml
install -v -m 644 system_integration/Linux/share/metainfo/net.ap_i.varobs.metainfo.xml $destdir/share/metainfo/net.ap_i.varobs.metainfo.xml
install -v -m 644 system_integration/Linux/share/mime/packages/net.ap_i.skychart.xml $destdir/share/mime/packages/net.ap_i.skychart.xml
install -v -m 644 system_integration/Linux/share/doc/skychart/changelog $destdir/share/doc/skychart/changelog
install -v -m 644 system_integration/Linux/share/doc/skychart/copyright $destdir/share/doc/skychart/copyright
install -v -m 644 system_integration/Linux/share/pixmaps/skychart.png $destdir/share/pixmaps/skychart.png
install -v -m 644 system_integration/Linux/share/pixmaps/catgen.png $destdir/share/pixmaps/catgen.png
install -v -m 644 system_integration/Linux/share/pixmaps/varobs.png $destdir/share/pixmaps/varobs.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/32x32/apps/skychart.png $destdir/share/icons/hicolor/32x32/apps/skychart.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/32x32/apps/catgen.png $destdir/share/icons/hicolor/32x32/apps/catgen.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/32x32/apps/varobs.png $destdir/share/icons/hicolor/32x32/apps/varobs.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/48x48/apps/skychart.png $destdir/share/icons/hicolor/48x48/apps/skychart.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/48x48/apps/catgen.png $destdir/share/icons/hicolor/48x48/apps/catgen.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/48x48/apps/varobs.png $destdir/share/icons/hicolor/48x48/apps/varobs.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/96x96/apps/skychart.png $destdir/share/icons/hicolor/96x96/apps/skychart.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/96x96/apps/catgen.png $destdir/share/icons/hicolor/96x96/apps/catgen.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/96x96/apps/varobs.png $destdir/share/icons/hicolor/96x96/apps/varobs.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/scalable/apps/skychart.svg $destdir/share/icons/hicolor/scalable/apps/skychart.svg
install -v -m 644 system_integration/Linux/share/icons/hicolor/scalable/apps/catgen.svg $destdir/share/icons/hicolor/scalable/apps/catgen.svg
install -v -m 644 system_integration/Linux/share/icons/hicolor/scalable/apps/varobs.svg $destdir/share/icons/hicolor/scalable/apps/varobs.svg
