Summary: Skychart / Cartes du Ciel SPICE extended data
Name: skychart-spice-ext
Version: 3
Release: 2
Group: Sciences/Astronomy
License: GPLv2+
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: noarch
Provides: skychart-spice-ext
Requires: skychart skychart-spice-base
AutoReqProv: no

%description
SPICE kernel to compute satellite position

%changelog
* Wed Oct 28 2020 Patrick Chevalley
 - Initial release

%files
%defattr(-,root,root)
/usr/share/skychart/data/spice_eph/cdcext.bsp

