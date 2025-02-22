#!/bin/bash 

version=4.3

builddir=/tmp/skychart  # Be sure this is set to a non existent directory, it is removed after the run!

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

save_PATH=$PATH
wd=`pwd`

# check if new revision since last run
read lastrev <last.build
currentrev=$(git rev-list --count --first-parent HEAD)
if [[ -z $currentrev ]]; then 
 currentrev=$(grep RevisionStr skychart/revision.inc| sed "s/const RevisionStr = '//"| sed "s/';//")
fi
echo $lastrev ' - ' $currentrev
if [[ $lastrev -ne $currentrev ]]; then

# delete old files
  rm skychart-qt6*.deb
  rm skychart-qt6*.xz
  rm -rf $builddir

# make Linux arm64 version
  ./configure $configopt prefix=$builddir target=aarch64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=aarch64 OS_TARGET=linux LCL_PLATFORM=qt6 clean
  make CPU_TARGET=aarch64 OS_TARGET=linux LCL_PLATFORM=qt6 opt_target=-k--build-id
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_doc
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_nonfree
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  cd ..
  tar cvJf skychart-qt6-$version-${currentrev}_linux_arm64.tar.xz skychart
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.tar.xz $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mkdir debian/skychartqt6arm/usr/
  mv bin debian/skychartqt6arm/usr/
  mv share debian/skychartqt6arm/usr/
  cd debian
  sed -i "/Version:/ s/3/$version-$currentrev/" skychartqt6arm/DEBIAN/control
  fakeroot dpkg-deb --build skychartqt6arm .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir

# store revision 
  echo $currentrev > last.build
else
  echo Already build at revision $currentrev
  exit 4
fi

