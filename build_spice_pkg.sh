
#!/bin/bash 

version=4.3

builddir=/tmp/skychart  # Be sure this is set to a non existent directory, it is removed after the run!
export WINEPREFIX=~/.wineinno6
innosetup="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"  # Install under Wine from http://www.jrsoftware.org/isinfo.php
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

lang=LANG
LANG=C
currentrev=$(git rev-list --count --first-parent HEAD)
LANG=$lang

# delete old files
  rm skychart-spice-*.bz2
  rm skychart-spice*.deb
  rm skychart-spice*.rpm
  rm skychart-spice*.zip
  rm skychart-spice*.exe
  rm -rf $builddir

# make Linux 
if [[ $make_linux ]]; then
  ./configure $configopt prefix=$builddir 
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_spicebase
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  tar cvjf skychart-spice-base-$version-$currentrev-linux_all.tar.bz2 *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-spice*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mkdir debian/skychart-spice-base/usr/
  mv share debian/skychart-spice-base/usr/
  cd debian
  sz=$(du -s skychart-spice-base/usr | cut -f1)
  sed -i "s/%size%/$sz/" skychart-spice-base/DEBIAN/control  
  sed -i "/Version:/ s/3/$version-$currentrev/" skychart-spice-base/DEBIAN/control
  fakeroot dpkg-deb --build skychart-spice-base .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-spice-base*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mkdir -p rpm/RPMS/noarch
  mkdir rpm/SRPMS
  mkdir rpm/tmp
  mkdir -p rpm/skychart-spice-base/usr/
  mv debian/skychart-spice-base/usr/* rpm/skychart-spice-base/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/skychart-spice-base.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/skychart-spice-base.spec
  fakeroot rpmbuild  --buildroot "$builddir/rpm/skychart-spice-base" --define "_topdir $builddir/rpm/" -bb SPECS/skychart-spice-base.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/noarch/skychart-spice-base*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir
  
  make install_spiceext
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  tar cvjf skychart-spice-ext-$version-$currentrev-linux_all.tar.bz2 *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-spice*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mkdir debian/skychart-spice-ext/usr/
  mv share debian/skychart-spice-ext/usr/
  cd debian
  sz=$(du -s skychart-spice-ext/usr | cut -f1)
  sed -i "s/%size%/$sz/" skychart-spice-ext/DEBIAN/control  
  sed -i "/Version:/ s/3/$version-$currentrev/" skychart-spice-ext/DEBIAN/control
  fakeroot dpkg-deb --build skychart-spice-ext .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-spice-ext*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mkdir -p rpm/RPMS/noarch
  mkdir rpm/SRPMS
  mkdir rpm/tmp
  mkdir -p rpm/skychart-spice-ext/usr/
  mv debian/skychart-spice-ext/usr/* rpm/skychart-spice-ext/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/skychart-spice-ext.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/skychart-spice-ext.spec
  fakeroot rpmbuild  --buildroot "$builddir/rpm/skychart-spice-ext" --define "_topdir $builddir/rpm/" -bb SPECS/skychart-spice-ext.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/noarch/skychart-spice-ext*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir  
fi

# make Windows version
if [[ $make_win ]]; then
  rsync -a --exclude=.svn system_integration/Windows/installer/skychart-spice-base/* $builddir
  mkdir $builddir/Data
  ./configure $configopt prefix=$builddir/Data target=i386-win32,x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_spicebase
  if [[ $? -ne 0 ]]; then exit 1;fi
  # zip
  cd $builddir/Data
  zip -r  skychart-spice-base-$version-$currentrev-windows.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-spice-base*.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # exe
  cd $builddir
  sed -i "/AppVerName/ s/V3/V$version/" skychart-spice-base.iss
  sed -i "/OutputBaseFilename/ s/windows/$version-$currentrev-windows/" skychart-spice-base.iss
  wine "$innosetup" "$wine_build\skychart-spice-base.iss"
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv $builddir/skychart-spice-base*.exe $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir

  rsync -a --exclude=.svn system_integration/Windows/installer/skychart-spice-ext/* $builddir
  mkdir $builddir/Data
  ./configure $configopt prefix=$builddir/Data target=i386-win32,x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_spiceext
  if [[ $? -ne 0 ]]; then exit 1;fi
  # zip
  cd $builddir/Data
  zip -r  skychart-spice-ext-$version-$currentrev-windows.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-spice-ext*.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # exe
  cd $builddir
  sed -i "/AppVerName/ s/V3/V$version/" skychart-spice-ext.iss
  sed -i "/OutputBaseFilename/ s/windows/$version-$currentrev-windows/" skychart-spice-ext.iss
  wine "$innosetup" "$wine_build\skychart-spice-ext.iss"
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv $builddir/skychart-spice-ext*.exe $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $builddir
  
fi
