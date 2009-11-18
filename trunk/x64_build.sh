#!/bin/bash 

version=3.1

builddir=/tmp/skychart  # Be sure this is set to a non existent directory, it is removed after the run!
innosetup="C:\Program Files\Inno Setup 5\ISCC.exe"  # Install under Wine from http://www.jrsoftware.org/isinfo.php
issscript="Z:\tmp\skychart\cdcv3.iss" # Change to match builddir, Z: is defined in ~/.wine/dosdevices

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

wd=`pwd`

# update to last revision
#svn up --force --non-interactive --accept theirs-full    # svn 1.5 only
svn -R revert .
svn up --non-interactive

# check if new revision since last run
read lastrev <last.build
lang=LANG
LANG=C
currentrev=`svn info . | grep Revision: | sed 's/Revision: //'`
LANG=$lang
echo $lastrev ' - ' $currentrev
#if [[ $lastrev -ne $currentrev ]]; then

# delete old files
  rm skychart*.bz2
  rm skychart*.deb
  rm skychart*.rpm
  rm skychart*.zip
  rm skychart*.exe
  rm bin-*.zip
  rm bin-*.bz2
  rm -rf $builddir

# make amd64 Linux version
  ./configure $configopt prefix=$builddir target=x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make clean
  make
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  tar cvjf skychart-$version-$currentrev-linux_amd64.tar.bz2 *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mv bin debian/skychart64/usr/
  mv lib debian/skychart64/usr/
  mv share debian/skychart64/usr/
  cd debian
  sed -i "/Version:/ s/3/$version-$currentrev/" skychart64/DEBIAN/control
  fakeroot dpkg-deb --build skychart64 .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mv debian/skychart64/usr/* rpm/skychart/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/skychart64.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/skychart64.spec
# rpm 4.7
  fakeroot rpmbuild  --buildroot "$builddir/rpm/skychart" --define "_topdir $builddir/rpm/" -bb SPECS/skychart64.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/x86_64/skychart*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  #debug
  cd $wd
  mkdir $builddir/debug
  cp skychart/cdc $builddir/debug/skychart
  cp skychart/cdcicon $builddir/debug/
  cp varobs/varobs $builddir/debug/
  cp varobs/varobs_lpv_bulletin $builddir/debug/
  cd $builddir/debug/
  tar cvjf bin-linux_amd64-debug-$currentrev.tar.bz2 *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv bin-*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
#  rm -rf $builddir

