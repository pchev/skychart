Summary: Skychart / Cartes du Ciel Pictures of Deepsky objects
Name: skychart-data-pictures
Version: 3
Release: 1
Group: Sciences/Astronomy
License: GPL
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: noarch
Provides: skychart-data-pictures
Conflicts: skychart_pictures
Requires: skychart
AutoReqProv: no

%description
Pictures of Deepsky objects to use with Skychart planetarium software. 

%changelog
* Thu Sep 9 2009 Patrick Chevalley
 - new package name

* Wed Aug 26 2009 Patrick Chevalley
 - Change install directory

* Sun Jun 5 2005 Patrick Chevalley
 - fixed bad picture for NGC 4527

%files
%defattr(-,root,root)
/usr/share/skychart

