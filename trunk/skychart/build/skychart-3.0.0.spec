Summary: Skychart / Cartes du Ciel planetarium software
Name: skychart
Version: 3.0.0.9
Release: 1
Group: Sciences/Astronomy
Copyright: GPL
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: i386
Provides: skychart libcatalog.so libCities.so libplan404.so libsatxy.so libgetdss.so
Requires: libborqt
AutoReqProv: no

%description
Planetarium software for the advanced amateur astronomer. 

%files
%defattr(-,root,root)
/usr/bin/cdc_clx
/usr/bin/skychart
/usr/lib/libCities.so
/usr/lib/libcatalog.so
/usr/lib/libplan404.so
/usr/lib/libsatxy.so
/usr/lib/libgetdss.so
/usr/share/apps/skychart

