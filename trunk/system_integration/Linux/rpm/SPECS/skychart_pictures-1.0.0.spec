Summary: Skychart / Cartes du Ciel Pictures of Deepsky objects
Name: skychart_pictures
Version: 1.0.0.1
Release: 1
Group: Sciences/Astronomy
License: GPL
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: i386
Provides: skychart_pictures
Requires: skychart
AutoReqProv: no

%description
Pictures of Deepsky objects to use with Skychart planetarium software. 

%changelog
* Sun Jun 5 2005 Patrick Chevalley
 - fixed bad picture for NGC 4527

%files
%defattr(-,root,root)
/usr/share/apps/skychart

