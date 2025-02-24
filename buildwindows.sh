#!/bin/bash 

version=4.3

builddir=/tmp/skychartwin  # Be sure this is set to a non existent directory, it is removed after the run!
export WINEPREFIX=~/.wine
innosetup="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"  # Install under Wine from http://www.jrsoftware.org/isinfo.php
wine_build="Z:\tmp\skychartwin" # Change to match builddir, Z: is defined in ~/.wine/dosdevices

arch=$(arch)

# adjuste here the target you want to crossbuild
# You MUST crosscompile Freepascal and Lazarus for this targets! 

extratarget=",x86_64-linux"

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
  rm skychart*.zip
  rm skychart*.exe
  rm -rf $builddir

# make Windows i386 version
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
  zip -r  skychart-$version-$currentrev-windows-x32.zip *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.zip $wd
  # exe
  cd $builddir
  sed -i "/AppVerName/ s/V3/V$version/" cdcv3.iss
  sed -i "/OutputBaseFilename/ s/windows-x32/$version-$currentrev-windows-x32/" cdcv3.iss
  wine "$innosetup" "$wine_build\cdcv3.iss"
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv $builddir/skychart*.exe $wd
  cd $wd
  rm -rf $builddir

# make Windows x86_64 version
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

cd $wd
rm -rf $builddir


# store revision 
  echo $currentrev > last.build
else
  echo Already build at revision $currentrev
  exit 4
fi

