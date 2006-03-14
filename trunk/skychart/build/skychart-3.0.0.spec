Summary: Skychart / Cartes du Ciel planetarium software
Name: skychart
Version: 3.0.1.0
Release: 1
Group: Sciences/Astronomy
License: GPL
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: i386
Provides: skychart libplan404.so libgetdss.so
Requires: gtk+ gdk-pixbuf libsqlite3.so.0
AutoReqProv: no

%description
Planetarium software for the advanced amateur astronomer.

%files
%defattr(-,root,root)
/usr/bin/skychart
/usr/lib/libplan404.so
/usr/lib/libgetdss.so
/usr/share/applications/skychart.desktop
/usr/share/pixmaps/skychart.xpm
/usr/share/apps/skychart

