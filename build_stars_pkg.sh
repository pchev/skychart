#!/bin/bash 

version=3.8

builddir=/tmp/skychart  # Be sure this is set to a non existent directory, it is removed after the run!
innosetup="C:\Program Files\Inno Setup 5\ISCC.exe"  # Install under Wine from http://www.jrsoftware.org/isinfo.php
wine_build="Z:\tmp\skychart" # Change to match builddir, Z: is defined in ~/.wine/dosdevices

# adjuste here the target you want to crossbuild

unset make_linux
make_linux=1
unset make_win
make_win=1

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

wd=`pwd`

currentrev=`LC_ALL=C svn info . | grep Revision: | sed 's/Revision: //'`

# delete old files
  rm skychart-data-stars*.bz2
  rm skychart-data-stars*.deb
  rm skychart-data-stars*.rpm
  rm skychart-data-stars*.zip
  rm skychart-data-stars*.exe
  rm -rf $builddir

# make Linux 
if [[ $make_linux ]]; then
  ./configure $configopt prefix=$builddir target=i386-linux,x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_cat1
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  tar cvjf skychart-data-stars-$version-$currentrev-linux_all.tar.bz2 *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-data-stars*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mv share debian/skychart-data-stars/usr/
  cd debian
  sed -i "/Version:/ s/3/$version-$currentrev/" skychart-data-stars/DEBIAN/control
  fakeroot dpkg-deb --build skychart-data-stars .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-data-stars*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mv debian/skychart-data-stars/usr/* rpm/skychart-data-stars/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/skychart-data-stars.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/skychart-data-stars.spec
  fakeroot rpmbuild  --buildroot "$builddir/rpm/skychart-data-stars" --define "_topdir $builddir/rpm/" -bb SPECS/skychart-data-stars.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/noarch/skychart-data-stars*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir
fi

# make Windows version
if [[ $make_win ]]; then
  rsync -a --exclude=.svn system_integration/Windows/installer/skychart-data-stars/* $builddir
  ./configure $configopt prefix=$builddir/Data target=i386-win32,x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_cat1
  if [[ $? -ne 0 ]]; then exit 1;fi
  # zip
  cd $builddir/Data
  zip -r  skychart-data-stars-$version-$currentrev-windows.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-data-star*.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # exe
  cd $builddir
  sed -i "/AppVerName/ s/V3/V$version/" skychart-data-stars.iss
  sed -i "/OutputBaseFilename/ s/windows/$version-$currentrev-windows/" skychart-data-stars.iss
  wine "$innosetup" "$wine_build\skychart-data-stars.iss"
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv $builddir/skychart-data-stars*.exe $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir
fi
