Summary: Skychart / Cartes du Ciel SPICE base data
Name: skychart-spice-base
Version: 3
Release: 2
Group: Sciences/Astronomy
License: GPLv2+
URL: http://skychart.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: noarch
Provides: skychart-spice-base
Requires: skychart
AutoReqProv: no

%description
SPICE kernel to compute satellite position

%changelog
* Wed Oct 28 2020 Patrick Chevalley
 - Initial release

%files
%defattr(-,root,root)
/usr/share/skychart/data/spice_eph/cdcbase.bsp

