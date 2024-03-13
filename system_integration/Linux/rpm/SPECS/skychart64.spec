Summary: Skychart / Cartes du Ciel planetarium software
Name: skychart
Version: 3
Release: 1
Group: Sciences/Astronomy
License: GPLv2+
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: x86_64
Provides: skychart
Requires: libpasastro libchealpix.so.0()(64bit) libQt5Pas.so.1()(64bit) libglib-2.0.so.0 sqlite3 xplanet espeak
AutoReqProv: no

%description
Planetarium software for the advanced amateur astronomer.

%files
%defattr(-,root,root)
/usr/bin/skychart
/usr/bin/cdcicon
/usr/bin/catgen
/usr/bin/varobs
/usr/share/doc/skychart
/usr/share/applications/net.ap_i.skychart.desktop
/usr/share/applications/net.ap_i.catgen.desktop
/usr/share/applications/net.ap_i.varobs.desktop
/usr/share/metainfo/net.ap_i.skychart.metainfo.xml
/usr/share/metainfo/net.ap_i.catgen.metainfo.xml
/usr/share/metainfo/net.ap_i.varobs.metainfo.xml
/usr/share/mime/packages/net.ap_i.skychart.xml
/usr/share/pixmaps/skychart.png
/usr/share/pixmaps/catgen.png
/usr/share/pixmaps/varobs.png
/usr/share/icons/hicolor/32x32/apps/skychart.png
/usr/share/icons/hicolor/32x32/apps/catgen.png
/usr/share/icons/hicolor/32x32/apps/varobs.png
/usr/share/icons/hicolor/48x48/apps/skychart.png
/usr/share/icons/hicolor/48x48/apps/catgen.png
/usr/share/icons/hicolor/48x48/apps/varobs.png
/usr/share/icons/hicolor/96x96/apps/skychart.png
/usr/share/icons/hicolor/96x96/apps/catgen.png
/usr/share/icons/hicolor/96x96/apps/varobs.png
/usr/share/icons/hicolor/scalable/apps/skychart.svg
/usr/share/icons/hicolor/scalable/apps/catgen.svg
/usr/share/icons/hicolor/scalable/apps/varobs.svg
/usr/share/skychart/data
/usr/share/skychart/cat/DSoutlines
/usr/share/skychart/cat/milkyway
/usr/share/skychart/cat/openngc
/usr/share/skychart/cat/RealSky
/usr/share/skychart/cat/sac
/usr/share/skychart/cat/xhip
/usr/share/skychart/doc/html_doc
/usr/share/skychart/doc/releasenotes*.txt
/usr/share/skychart/doc/varobs
/usr/share/skychart/doc/wiki_doc
