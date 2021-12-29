#!/bin/bash 

version=4.3

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

wd=`pwd`

currentrev=$(git rev-list --count --first-parent HEAD)
if [[ -z $currentrev ]]; then 
 currentrev=$(grep RevisionStr skychart/revision.inc| sed "s/const RevisionStr = '//"| sed "s/';//")
fi

# delete old files
  rm catgen*.tgz

# make x86_64 Mac version
  ./configure $configopt prefix=$builddir target=x86_64-darwin
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=x86_64 clean
  cd skychart
  make CPU_TARGET=x86_64 catgen
  if [[ $? -ne 0 ]]; then exit 1;fi
  tar cvzf $wd/catgen-$version-$currentrev-macos_x86_64.tgz catgen
  cd $wd

