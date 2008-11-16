#!/bin/bash 

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
svn up --non-interactive

# check if new revision since last run
read lastrev <last.build
lang=LANG
LANG=C
currentrev=`svn info . | grep Revision: | sed 's/Revision: //'`
LANG=$lang
echo $lastrev ' - ' $currentrev
if [[ $lastrev -ne $currentrev ]]; then

# delete old files
  rm skychart*.bz2
  rm skychart*.deb
  rm skychart*.rpm
  rm skychart*.zip
  rm skychart*.exe
  rm bin-*.zip
  rm bin-*.bz2
  rm -rf $builddir

# make Linux version
  ./configure $configopt prefix=$builddir
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
  tar cvjf skychart-3.0.1.5-linux.tar.bz2 *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mv bin debian/skychart/usr/
  mv lib debian/skychart/usr/
  mv share debian/skychart/usr/
  cd debian
  fakeroot dpkg-deb --build skychart .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mv debian/skychart/usr/* rpm/skychart/usr/
  cd rpm
  fakeroot rpmbuild  --define "_topdir $builddir/rpm/" -bb SPECS/skychart.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/i386/skychart*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  #debug
  cd $wd
  mkdir $builddir/debug
  cp skychart/cdc $builddir/debug/skychart
  cp skychart/cdcicon $builddir/debug/
  cp varobs/varobs $builddir/debug/
  cp varobs/varobs_lpv_bulletin $builddir/debug/
  cd $builddir/debug/
  tar cvjf bin-linux-debug.tar.bz2 *
  mv bin-linux-debug.tar.bz2 $wd

  cd $wd
  rm -rf $builddir

# make Windows version
  rsync -a --exclude=.svn system_integration/Windows/installer/skychart/* $builddir
  ./configure $configopt prefix=$builddir/Data
  if [[ $? -ne 0 ]]; then exit 1;fi
  make OS_TARGET=win32 CPU_TARGET=i386 clean
  make OS_TARGET=win32 CPU_TARGET=i386
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  # zip
  cd $builddir/Data
  zip -r  skychart-3.0.1.5-windows.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # exe
  wine "$innosetup" "$issscript"
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv $builddir/skychart*.exe $wd
  #debug
  cd $wd
  mkdir $builddir/debug
  cp skychart/cdc.exe $builddir/debug/skychart.exe
  cp skychart/cdcicon.exe $builddir/debug/
  cp varobs/varobs.exe $builddir/debug/
  cp varobs/varobs_lpv_bulletin.exe $builddir/debug/
  cd $builddir/debug/
  zip bin-windows-debug.zip *
  mv bin-windows-debug.zip $wd

  cd $wd
  rm -rf $builddir

# store revision 
  echo $currentrev > last.build
else
  echo Already build at revision $currentrev
exit 1
fi

