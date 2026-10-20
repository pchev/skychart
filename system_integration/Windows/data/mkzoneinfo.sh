#!/bin/bash
#
# create minimal time zone information for windows
#

wd=`pwd`

rm -rf tzdata zoneinfo
rm zoneinfo.zip
mkdir tzdata
mkdir zoneinfo

wget --retr-symlinks 'ftp://ftp.iana.org/tz/tzcode-latest.tar.gz'
if [[ $? != 0 ]]; then echo wget error;  exit 1; fi
wget --retr-symlinks 'ftp://ftp.iana.org/tz/tzdata-latest.tar.gz'
if [[ $? != 0 ]]; then echo wget error;  exit 1; fi

cd tzdata

tar xzf ../tzcode*.tar.gz
tar xzf ../tzdata*.tar.gz

make TOPDIR=$wd/tzdata/ ZFLAGS="-b fat" install
if [[ $? != 0 ]]; then echo make error;  exit 1; fi

cd usr/share/zoneinfo
if [[ $? != 0 ]]; then  exit 1; fi
cp zone.tab $wd/zoneinfo
if [[ $? != 0 ]]; then  exit 1; fi
cat zone.tab |grep -v \# | cut -f3 |xargs -I'{}' -n1  cp --parent '{}' $wd/zoneinfo
if [[ $? != 0 ]]; then  exit 1; fi
cp -a Etc $wd/zoneinfo
if [[ $? != 0 ]]; then  exit 1; fi

cd $wd
zip -r zoneinfo.zip zoneinfo

rm -rf tzdata
rm tzcode*
rm tzdata*
