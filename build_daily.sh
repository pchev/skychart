#!/bin/bash 

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
currentrev=`svn info . | grep Revision: | sed 's/Revision: //'`
echo $lastrev ' - ' $currentrev
if [[ $lastrev -ne $currentrev ]]; then

# delete old files
  rm skychart-linux.tgz
  rm skychart-windows.zip
  rm -rf /tmp/skychart

# run configure
  ./configure $configopt prefix=/tmp/skychart
  if [[ $? -ne 0 ]]; then exit 1;fi

# make Linux version
  make clean
  make
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd /tmp/skychart
  tar cvzf skychart-linux.tgz *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-linux.tgz $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf /tmp/skychart

# make Windows version
  make OS_TARGET=win32 CPU_TARGET=i386 clean
  make OS_TARGET=win32 CPU_TARGET=i386
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd /tmp/skychart
  zip -r  skychart-windows.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-windows.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf /tmp/skychart

# store revision 
  echo $currentrev > build_daily.last
else
  echo Already build at revision $currentrev
exit 1
fi

