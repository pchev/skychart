Summary: Skychart / Cartes du Ciel DSO catalog
Name: skychart-data-dso
Version: 3
Release: 1
Group: Sciences/Astronomy
License: GPLv2+
URL: http://skychart.origo.ethz.ch
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: noarch
Provides: skychart-data-dso
Requires: skychart
AutoReqProv: no

%description
DSO catalog data for use with Skychart planetarium software. 

%changelog
* Thu Sep 9 2010 Patrick Chevalley
 - Initial release

%files
%defattr(-,root,root)
/usr/share/skychart
