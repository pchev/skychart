#!/bin/bash 

version=3.7

builddir=/tmp/skychart  # Be sure this is set to a non existent directory, it is removed after the run!
innosetup="C:\Program Files\Inno Setup 5\ISCC.exe"  # Install under Wine from http://www.jrsoftware.org/isinfo.php
wine_build="Z:\tmp\skychart" # Change to match builddir, Z: is defined in ~/.wine/dosdevices

arch=$(arch)

# adjuste here the target you want to crossbuild
# You MUST crosscompile Freepascal and Lazarus for this targets! 

unset make_linux32
make_linux32=1
unset make_linux64
if [[ $arch == x86_64 ]]; then make_linux64=1;fi
unset make_win32
make_win32=1
unset make_win64
make_win64=1

# For win32 and win64 target you must also install the corresponding mingw-w64 to build the C library
mingw32=/opt/mingw-w32/bin/
mingw64=/opt/mingw-w64/bin/

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
currentrev=$(LANG=C svn info . | grep Revision: | sed 's/Revision: //')
if [[ -z $currentrev ]]; then 
 currentrev=$(grep RevisionStr skychart/revision.inc| sed "s/const RevisionStr = '//"| sed "s/';//")
fi
echo $lastrev ' - ' $currentrev
if [[ $lastrev -ne $currentrev ]]; then

# delete old files
  rm skychart*.bz2
  rm skychart*.deb
  rm skychart*.rpm
  rm skychart*.zip
  rm skychart*.exe
  rm update-bin-*.zip
  rm bin-*.zip
  rm bin-*.bz2
  rm -rf $builddir

# make Linux i386 version
if [[ $make_linux32 ]]; then
  ./configure $configopt prefix=$builddir target=i386-linux,x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=i386 OS_TARGET=linux clean
  make CPU_TARGET=i386 OS_TARGET=linux
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
  tar cvjf skychart-$version-$currentrev-linux_i386.tar.bz2 skychart
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
  mv debian/skychart/usr/bin/skychart debian/skychart/usr/bin/skychart-bin
  cp $wd/system_integration/Linux/bin/skychart debian/skychart/usr/bin/skychart
  cd debian
  sed -i "/Version:/ s/3/$version-$currentrev/" skychart/DEBIAN/control
  fakeroot dpkg-deb --build skychart .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  rm skychart/usr/bin/skychart
  mv skychart/usr/bin/skychart-bin skychart/usr/bin/skychart
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mv debian/skychart/usr/* rpm/skychart/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/skychart.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/skychart.spec
  setarch i386 fakeroot rpmbuild  --buildroot "$builddir/rpm/skychart" --define "_topdir $builddir/rpm/" -bb SPECS/skychart.spec
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
  cd $builddir
  tar cvjf bin-linux_i386-debug-$currentrev.tar.bz2 debug
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv bin-*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $builddir
fi

# make Linux x86_64 version
if [[ $make_linux64 ]]; then
  ./configure $configopt prefix=$builddir target=x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=x86_64 OS_TARGET=linux clean
  make CPU_TARGET=x86_64 OS_TARGET=linux
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
  tar cvjf skychart-$version-$currentrev-linux_x86_64.tar.bz2 skychart
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
  mv debian/skychart64/usr/bin/skychart debian/skychart64/usr/bin/skychart-bin
  cp $wd/system_integration/Linux/bin/skychart debian/skychart64/usr/bin/skychart
  cd debian
  sed -i "/Version:/ s/3/$version-$currentrev/" skychart64/DEBIAN/control
  fakeroot dpkg-deb --build skychart64 .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  rm skychart64/usr/bin/skychart
  mv skychart64/usr/bin/skychart-bin skychart64/usr/bin/skychart
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mv debian/skychart64/usr/* rpm/skychart/usr/
  # Redhat 64bits lib is lib64 
  mv rpm/skychart/usr/lib rpm/skychart/usr/lib64
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
  cd $builddir
  tar cvjf bin-linux_x86_64-debug-$currentrev.tar.bz2 debug
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv bin-*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $builddir
fi

# make Windows i386 version
if [[ $make_win32 ]]; then
  rsync -a --exclude=.svn system_integration/Windows/installer/skychart/* $builddir
  export PATH=$mingw32:$save_PATH
  ./configure $configopt prefix=$builddir/Data target=i386-win32,x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make OS_TARGET=win32 CPU_TARGET=i386 clean
  make OS_TARGET=win32 CPU_TARGET=i386
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_doc
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_nonfree
  if [[ $? -ne 0 ]]; then exit 1;fi
  # zip
  cd $builddir/Data
  zip -r  skychart-$version-$currentrev-windows.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.zip $wd
  zip  update-bin-$version-$currentrev-windows.zip skychart.exe
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv update-bin-*.zip $wd
  # exe
  cd $builddir
  sed -i "/AppVerName/ s/V3/V$version/" cdcv3.iss
  sed -i "/OutputBaseFilename/ s/windows/$version-$currentrev-windows/" cdcv3.iss
  wine "$innosetup" "$wine_build\cdcv3.iss"
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
  zip bin-windows_i386-debug-$currentrev.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv bin-*.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $builddir
fi

# make Windows x86_64 version
if [[ $make_win64 ]]; then
  rsync -a --exclude=.svn system_integration/Windows/installer/skychart/* $builddir
  export PATH=$mingw64:$save_PATH
  ./configure $configopt prefix=$builddir/Data target=x86_64-win64,x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make OS_TARGET=win64 CPU_TARGET=x86_64 clean
  make OS_TARGET=win64 CPU_TARGET=x86_64
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win64
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_doc
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_win_nonfree
  if [[ $? -ne 0 ]]; then exit 1;fi
  # zip
  cd $builddir/Data
  zip -r  skychart-$version-$currentrev-windows-x64.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # exe
  cd $builddir
  sed -i "/AppVerName/ s/V3/V$version/" cdcv3_64.iss
  sed -i "/OutputBaseFilename/ s/windows-x64/$version-$currentrev-windows-x64/" cdcv3_64.iss
  wine "$innosetup" "$wine_build\cdcv3_64.iss"
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
  zip bin-windows-x64-debug-$currentrev.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv bin-*.zip $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
fi

cd $wd
rm -rf $builddir


# store revision 
  echo $currentrev > last.build
else
  echo Already build at revision $currentrev
  exit 4
fi

