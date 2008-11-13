#!/bin/bash 

builddir=/tmp/skychart  # Be sur this is set!
innosetup="C:\Program Files\Inno Setup 5\ISCC.exe"  # Install under Wine from http://www.jrsoftware.org/isinfo.php
issscript="Z:\tmp\skychart\cdcv3.iss" # Change to match builddir, Z: is defined in ~.wine 

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

wd=`pwd`

# update to last revision
svn up

# check if new revision from last run
read lastrev <build_daily.last
lang=LANG
LANG=C
currentrev=`svn info . | grep Revision: | sed 's/Revision: //'`
LANG=$lang
echo $lastrev ' - ' $currentrev
if [[ $lastrev -ne $currentrev ]]; then

# delete old files
  rm skychart-linux.tar.bz2
  rm skychart-windows.zip
  rm skychart-*.exe
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
  cd $builddir
  tar cvjf skychart-linux.tar.bz2 *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-linux.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $builddir

# make Windows version
  cp -a system_integration/Windows/installer/skychart $builddir
  ./configure $configopt prefix=$builddir/Data
  if [[ $? -ne 0 ]]; then exit 1;fi
  make OS_TARGET=win32 CPU_TARGET=i386 clean
  make OS_TARGET=win32 CPU_TARGET=i386
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $builddir/Data
  zip -r  skychart-windows.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-windows.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  wine "$innosetup" "$issscript"
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv $builddir/skychart-*.exe $wd

  cd $wd
  rm -rf $builddir

# store revision 
  echo $currentrev > build_daily.last
else
  echo Already build at revision $currentrev
exit 1
fi

