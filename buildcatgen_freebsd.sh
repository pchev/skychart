#!/bin/bash 

version=4.3

arch=$(uname -m)

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

# make FreeBSD version
  ./configure $configopt prefix=$builddir
  if [[ $? -ne 0 ]]; then exit 1;fi
  gmake clean
  cd skychart
  gmake catgen
  if [[ $? -ne 0 ]]; then exit 1;fi
  tar cvzf $wd/catgen-$version-$currentrev-FreeBSD_$arch.tgz catgen
  if [[ $? -ne 0 ]]; then exit 1;fi

cd $wd

