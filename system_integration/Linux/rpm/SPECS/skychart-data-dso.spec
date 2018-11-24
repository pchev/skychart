Summary: Skychart / Cartes du Ciel DSO catalog
Name: skychart-data-dso
Version: 3
Release: 1
Group: Sciences/Astronomy
License: GPLv2+
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: noarch
Provides: skychart-data-dso
Requires: skychart
AutoReqProv: no

%description
DSO catalog data for use with Skychart planetarium software. 

%changelog
* Wed Jan 11 2017 Patrick Chevalley
 - Remove NGC, add Sharpless HII Regions,Barnard Dark Objects and update PGC/Leda

%files
%defattr(-,root,root)
/usr/share/skychart/cat/leda
/usr/share/skychart/cat/lbn
/usr/share/skychart/cat/ocl
/usr/share/skychart/cat/gcm
/usr/share/skychart/cat/gpn
/usr/share/skychart/cat/barnard
/usr/share/skychart/cat/sh2
/usr/share/metainfo/skychart-data-dso.metainfo.xml
