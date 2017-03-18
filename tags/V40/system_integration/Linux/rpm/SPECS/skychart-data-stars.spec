Summary: Skychart / Cartes du Ciel stars catalog
Name: skychart-data-stars
Version: 3
Release: 2
Group: Sciences/Astronomy
License: GPLv2+
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: noarch
Provides: skychart-data-stars
Requires: skychart
AutoReqProv: no

%description
Stars catalog data for use with Skychart planetarium software. 

%changelog
* Wed Jan 11 2017 Patrick Chevalley
  - New version of WDS and GCVS catalog

* Mon Dec 26 2011 Patrick Chevalley
  - Remove sky2000 catalog

* Thu Sep 9 2010 Patrick Chevalley
 - Initial release

%files
%defattr(-,root,root)
/usr/share/skychart
/usr/share/appdata/skychart-data-stars.metainfo.xml
