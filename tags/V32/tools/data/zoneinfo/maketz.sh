#!/bin/bash
#
# create minimal time zone information for Skychart
#

wd=`pwd`

rm -rf tzdata zoneinfo
mkdir tzdata
mkdir zoneinfo

wget 'ftp://elsie.nci.nih.gov/pub/tz*.tar.gz'

cd tzdata

tar xzf ../tzcode*.tar.gz
tar xzf ../tzdata*.tar.gz

make TOPDIR=$wd/tzdata/ install

cd etc/zoneinfo
cp zone.tab $wd/zoneinfo
cat zone.tab |grep -v \# | cut -f3 |xargs -I'{}' -n1  cp --parent '{}' $wd/zoneinfo
cp -a Etc $wd/zoneinfo

cd $wd
rm ../../../system_integration/Windows/data/zoneinfo.zip
zip -r ../../../system_integration/Windows/data/zoneinfo.zip zoneinfo

rm -rf tzdata zoneinfo
rm tzcode*
rm tzdata*
