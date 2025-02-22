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

echo $version-$currentrev > beta.txt

# delete old files
  rm skychart-qt6*.xz
  rm skychart-qt6*.deb
  rm skychart-qt6*.rpm
  rm -rf $builddir

# make Linux x86_64 version
  ./configure $configopt prefix=$builddir target=x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=x86_64 OS_TARGET=linux LCL_PLATFORM=qt6 clean
  make CPU_TARGET=x86_64 OS_TARGET=linux LCL_PLATFORM=qt6 opt_target=-k--build-id
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
  tar cvJf skychart-qt6-$version-${currentrev}_linux_x86_64.tar.xz skychart
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.tar.xz $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mkdir debian/skychartqt6/usr/
  mv bin debian/skychartqt6/usr/
  mv share debian/skychartqt6/usr/
  cd debian
  sz=$(du -s skychartqt6/usr | cut -f1)
  sed -i "s/%size%/$sz/" skychartqt6/DEBIAN/control
  sed -i "/Version:/ s/3/$version-$currentrev/" skychartqt6/DEBIAN/control
  fakeroot dpkg-deb -Zxz --build skychartqt6 .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mkdir -p rpm/RPMS/x86_64
  mkdir -p rpm/RPMS/i386
  mkdir rpm/SRPMS
  mkdir rpm/tmp
  mkdir -p rpm/skychart/usr/
  mv debian/skychartqt6/usr/* rpm/skychart/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/skychartqt6.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/skychartqt6.spec
# rpm 4.7
  fakeroot rpmbuild  --buildroot "$builddir/rpm/skychart" --define "_topdir $builddir/rpm/" --define "_binary_payload w7.xzdio"  -bb SPECS/skychartqt6.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/x86_64/skychart*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir

# store revision 
  echo $currentrev > last.build
else
  echo Already build at revision $currentrev
  exit 4
fi

