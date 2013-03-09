Summary: Skychart / Cartes du Ciel planetarium software
Name: skychart
Version: 3
Release: 1
Group: Sciences/Astronomy
License: GPLv2+
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: i386
Provides: skychart libplan404.so libgetdss.so libcdcwcs.so
Requires: gtk2 glib2 pango libjpeg libpng sqlite xplanet
AutoReqProv: no

%description
Planetarium software for the advanced amateur astronomer.

%files
%defattr(-,root,root)
/usr/bin/skychart
/usr/bin/cdcicon
/usr/bin/varobs
/usr/bin/varobs_lpv_bulletin
/usr/lib/libplan404.so
/usr/lib/libgetdss.so
/usr/lib/libcdcwcs.so
/usr/share/applications/skychart.desktop
/usr/share/pixmaps/skychart.png
/usr/share/icons/hicolor/48x48/apps/skychart.png
/usr/share/icons/hicolor/scalable/apps/skychart.svg
/usr/share/doc/skychart
/usr/share/skychart

