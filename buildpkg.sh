#!/bin/bash 

version=4.3

builddir=/tmp/skychart  # Be sure this is set to a non existent directory, it is removed after the run!
export WINEPREFIX=~/.wine
innosetup="C:\Program Files\Inno Setup 6\ISCC.exe"  # Install under Wine from http://www.jrsoftware.org/isinfo.php
wine_build="Z:\tmp\skychart" # Change to match builddir, Z: is defined in ~/.wine/dosdevices

arch=$(arch)

# adjuste here the target you want to crossbuild
# You MUST crosscompile Freepascal and Lazarus for this targets! 

unset extratarget
unset make_debug

unset make_linux32
unset make_linux64
unset make_win32
unset make_win64

if [[ $arch == i686 ]]; then 
   make_linux32=1
fi
if [[ $arch == x86_64 ]]; then 
   make_linux64=1
   make_win32=1
   make_win64=1
   extratarget=",x86_64-linux"
fi

# For win32 and win64 target you must also install the corresponding mingw-w64 to build the C library
#mingw32=/opt/mingw-w32/bin/
#mingw64=/opt/mingw-w64/bin/

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
  rm skychart*.xz
  rm skychart*.deb
  rm skychart*.rpm
  rm skychart*.zip
  rm skychart*.exe
  rm update-bin-*.zip
  rm bin-*.zip
  rm bin-*.xz
  rm -rf $builddir

# make Linux i386 version
if [[ $make_linux32 ]]; then
  ./configure $configopt prefix=$builddir target=i386-linux$extratarget
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
  tar cvJf skychart-$version-${currentrev}_linux_i386.tar.xz skychart
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.tar.xz $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mkdir debian/skychart/usr/
  mv bin debian/skychart/usr/
  mv share debian/skychart/usr/
  cd debian
  sz=$(du -s skychart/usr | cut -f1)
  sed -i "s/%size%/$sz/" skychart/DEBIAN/control
  sed -i "/Version:/ s/3/$version-$currentrev/" skychart/DEBIAN/control
  fakeroot dpkg-deb -Zxz --build skychart .
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
  mv debian/skychart/usr/* rpm/skychart/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/skychart.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/skychart.spec
  setarch i386 fakeroot rpmbuild  --buildroot "$builddir/rpm/skychart" --define "_topdir $builddir/rpm/" --define "_binary_payload w7.xzdio" -bb SPECS/skychart.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/i386/skychart*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  if [[ $make_debug ]]; then
    #debug
    cd $wd
    rm -rf $builddir
    make CPU_TARGET=i386 OS_TARGET=linux clean
    fpcopts="-O1 -g -gl -Ci -Co -Ct" make CPU_TARGET=i386 OS_TARGET=linux
    if [[ $? -ne 0 ]]; then exit 1;fi
    mkdir $builddir
    mkdir $builddir/debug
    cp skychart/cdc $builddir/debug/skychart
    cp skychart/cdcicon $builddir/debug/
    cp varobs/varobs $builddir/debug/
    cp varobs/varobs_lpv_bulletin $builddir/debug/
    cd $builddir
    tar cvJf bin-linux_i386-debug-$currentrev.tar.xz debug
    if [[ $? -ne 0 ]]; then exit 1;fi
    mv bin-*.tar.xz $wd
    if [[ $? -ne 0 ]]; then exit 1;fi
  fi
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
  tar cvJf skychart-$version-${currentrev}_linux_x86_64.tar.xz skychart
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.tar.xz $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mkdir debian/skychart64/usr/
  mv bin debian/skychart64/usr/
  mv share debian/skychart64/usr/
  cd debian
  sz=$(du -s skychart64/usr | cut -f1)
  sed -i "s/%size%/$sz/" skychart64/DEBIAN/control
  sed -i "/Version:/ s/3/$version-$currentrev/" skychart64/DEBIAN/control
  fakeroot dpkg-deb -Zxz --build skychart64 .
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
  mv debian/skychart64/usr/* rpm/skychart/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/skychart64.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/skychart64.spec
# rpm 4.7
  fakeroot rpmbuild  --buildroot "$builddir/rpm/skychart" --define "_topdir $builddir/rpm/" --define "_binary_payload w7.xzdio"  -bb SPECS/skychart64.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/x86_64/skychart*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  if [[ $make_debug ]]; then
    #debug
    cd $wd
    rm -rf $builddir
    make CPU_TARGET=x86_64 OS_TARGET=linux clean
    fpcopts="-O1 -g -gl -Ci -Co -Ct" make CPU_TARGET=x86_64 OS_TARGET=linux
    if [[ $? -ne 0 ]]; then exit 1;fi
    mkdir $builddir
    mkdir $builddir/debug
    cp skychart/cdc $builddir/debug/skychart
    cp skychart/cdcicon $builddir/debug/
    cp varobs/varobs $builddir/debug/
    cp varobs/varobs_lpv_bulletin $builddir/debug/
    cd $builddir
    tar cvJf bin-linux_x86_64-debug-$currentrev.tar.xz debug
    if [[ $? -ne 0 ]]; then exit 1;fi
    mv bin-*.tar.xz $wd
    if [[ $? -ne 0 ]]; then exit 1;fi
  fi
  cd $wd
  rm -rf $builddir
fi

# make Windows i386 version
if [[ $make_win32 ]]; then
  rsync -a --exclude=.svn system_integration/Windows/installer/skychart/* $builddir
  mkdir $builddir/Data
  export PATH=$mingw32:$save_PATH
  ./configure $configopt prefix=$builddir/Data target=i386-win32$extratarget
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
  if [[ $make_debug ]]; then
    #debug
    cd $wd
    rm -rf $builddir
    make  OS_TARGET=win32 CPU_TARGET=i386 clean
    fpcopts="-O1 -g -gl -Ci -Co -Ct" make  OS_TARGET=win32 CPU_TARGET=i386
    if [[ $? -ne 0 ]]; then exit 1;fi
    mkdir $builddir
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
  fi
  cd $wd
  rm -rf $builddir
fi

# make Windows x86_64 version
if [[ $make_win64 ]]; then
  rsync -a --exclude=.svn system_integration/Windows/installer/skychart/* $builddir
  mkdir $builddir/Data
  export PATH=$mingw64:$save_PATH
  ./configure $configopt prefix=$builddir/Data target=x86_64-win64$extratarget
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
  if [[ $make_debug ]]; then
    #debug
    cd $wd
    rm -rf $builddir
    make OS_TARGET=win64 CPU_TARGET=x86_64 clean
    fpcopts="-O1 -g -gl -Ci -Co -Ct" make OS_TARGET=win64 CPU_TARGET=x86_64
    if [[ $? -ne 0 ]]; then exit 1;fi
    mkdir $builddir
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
fi

cd $wd
rm -rf $builddir


# store revision 
  echo $currentrev > last.build
else
  echo Already build at revision $currentrev
  exit 4
fi

