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
 - Remove NGC and update PGC/Leda

%files
%defattr(-,root,root)
/usr/share/skychart
/usr/share/appdata/skychart-data-dso.metainfo.xml
