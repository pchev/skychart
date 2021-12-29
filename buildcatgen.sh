#!/bin/bash 

version=4.3

arch=$(arch)

# adjuste here the target you want to crossbuild
# You MUST crosscompile Freepascal and Lazarus for this targets! 

unset extratarget

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

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

save_PATH=$PATH
wd=`pwd`

currentrev=$(git rev-list --count --first-parent HEAD)
if [[ -z $currentrev ]]; then 
 currentrev=$(grep RevisionStr skychart/revision.inc| sed "s/const RevisionStr = '//"| sed "s/';//")
fi

# delete old files
  rm catgen*.tgz
  rm catgen*.zip
  
# make Linux i386 version
if [[ $make_linux32 ]]; then
  ./configure $configopt target=i386-linux$extratarget
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=i386 OS_TARGET=linux clean
  cd skychart
  make CPU_TARGET=i386 OS_TARGET=linux catgen
  if [[ $? -ne 0 ]]; then exit 1;fi
  tar cvzf $wd/catgen-$version-$currentrev-linux_i386.tgz catgen
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
fi

# make Linux x86_64 version
if [[ $make_linux64 ]]; then
  ./configure $configopt target=x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=x86_64 OS_TARGET=linux clean
  cd skychart
  make CPU_TARGET=x86_64 OS_TARGET=linux catgen
  if [[ $? -ne 0 ]]; then exit 1;fi
  tar cvzf $wd/catgen-$version-$currentrev-linux_x86_64.tgz catgen
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
fi

# make Windows i386 version
if [[ $make_win32 ]]; then
  ./configure $configopt target=i386-win32$extratarget
  if [[ $? -ne 0 ]]; then exit 1;fi
  make OS_TARGET=win32 CPU_TARGET=i386 clean
  cd skychart
  make OS_TARGET=win32 CPU_TARGET=i386 catgen
  if [[ $? -ne 0 ]]; then exit 1;fi
  zip $wd/catgen-$version-$currentrev-windows-i386.zip catgen.exe
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
fi

# make Windows x86_64 version
if [[ $make_win64 ]]; then
  ./configure $configopt target=x86_64-win64$extratarget
  if [[ $? -ne 0 ]]; then exit 1;fi
  make OS_TARGET=win64 CPU_TARGET=x86_64 clean
  cd skychart
  make OS_TARGET=win64 CPU_TARGET=x86_64 catgen
  if [[ $? -ne 0 ]]; then exit 1;fi
  zip  $wd/catgen-$version-$currentrev-windows-x64.zip catgen.exe
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
fi
