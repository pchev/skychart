Summary: Skychart / Cartes du Ciel planetarium software
Name: skychart
Version: 3
Release: 1
Group: Sciences/Astronomy
License: GPL
URL: http://skychart.origo.ethz.ch
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: i386
Provides: skychart libplan404.so libgetdss.so
Requires: gtk2 glib2 pango libjpeg libpng sqlite
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
/usr/share/applications/skychart.desktop
/usr/share/pixmaps/skychart.png
/usr/share/doc/skychart
/usr/share/skychart

