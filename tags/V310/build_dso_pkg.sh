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
  rm skychart-data-dso*.bz2
  rm skychart-data-dso*.deb
  rm skychart-data-dso*.rpm
  rm skychart-data-dso*.zip
  rm skychart-data-dso*.exe
  rm -rf $builddir

# make Linux 
if [[ $make_linux ]]; then
  ./configure $configopt prefix=$builddir target=i386-linux,x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_cat2
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  tar cvjf skychart-data-dso-$version-$currentrev-linux_all.tar.bz2 *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-data-dso*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mv share debian/skychart-data-dso/usr/
  cd debian
  sed -i "/Version:/ s/3/$version-$currentrev/" skychart-data-dso/DEBIAN/control
  fakeroot dpkg-deb --build skychart-data-dso .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-data-dso*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mv debian/skychart-data-dso/usr/* rpm/skychart-data-dso/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/skychart-data-dso.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/skychart-data-dso.spec
  fakeroot rpmbuild  --buildroot "$builddir/rpm/skychart-data-dso" --define "_topdir $builddir/rpm/" -bb SPECS/skychart-data-dso.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/noarch/skychart-data-dso*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir
fi

# make Windows version
if [[ $make_win ]]; then
  rsync -a --exclude=.svn system_integration/Windows/installer/skychart-data-dso/* $builddir
  ./configure $configopt prefix=$builddir/Data target=i386-win32,x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_cat2
  if [[ $? -ne 0 ]]; then exit 1;fi
  # zip
  cd $builddir/Data
  zip -r  skychart-data-dso-$version-$currentrev-windows.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-data-dso*.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # exe
  cd $builddir
  sed -i "/AppVerName/ s/V3/V$version/" skychart-data-dso.iss
  sed -i "/OutputBaseFilename/ s/windows/$version-$currentrev-windows/" skychart-data-dso.iss
  wine "$innosetup" "$wine_build\skychart-data-dso.iss"
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv $builddir/skychart-data-dso*.exe $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir
fi
