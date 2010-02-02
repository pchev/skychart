#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart to $destdir

install -d -m 755 $destdir
install -d -m 755 $destdir/skychart.app
install -d -m 755 $destdir/skychart.app/Contents
install -d -m 755 $destdir/skychart.app/Contents/MacOS
install -d -m 755 $destdir/skychart.app/Contents/Resources
install -v -m 644 system_integration/MacOSX/pkg/skychart.app/Contents/Info.plist $destdir/skychart.app/Contents/
install -v -m 644 system_integration/MacOSX/pkg/skychart.app/Contents/PkgInfo $destdir/skychart.app/Contents/
install -v -m 755 -s skychart/cdc  $destdir/skychart.app/Contents/MacOS/skychart
install -v -m 644 system_integration/MacOSX/pkg/skychart.app/Contents/Resources/README.rtf $destdir/skychart.app/Contents/Resources/
install -v -m 644 system_integration/MacOSX/pkg/skychart.app/Contents/Resources/cdcIcon2.icns $destdir/skychart.app/Contents/Resources/

install -d -m 755 $destdir/varobs.app
install -d -m 755 $destdir/varobs.app/Contents
install -d -m 755 $destdir/varobs.app/Contents/MacOS
install -d -m 755 $destdir/varobs.app/Contents/Resources
install -v -m 644 system_integration/MacOSX/pkg/varobs.app/Contents/Info.plist $destdir/varobs.app/Contents/
install -v -m 644 system_integration/MacOSX/pkg/varobs.app/Contents/PkgInfo $destdir/varobs.app/Contents/
install -v -m 755 -s varobs/varobs  $destdir/varobs.app/Contents/MacOS/varobs
install -v -m 644 system_integration/MacOSX/pkg/varobs.app/Contents/Resources/README.rtf $destdir/varobs.app/Contents/Resources/
install -v -m 644 system_integration/MacOSX/pkg/varobs.app/Contents/Resources/varobs.icns $destdir/varobs.app/Contents/Resources/

install -v -m 755 skychart/library/getdss/libgetdss.dylib  $destdir/libgetdss.dylib
install -v -m 755 skychart/library/plan404/libplan404.dylib  $destdir/libplan404.dylib

