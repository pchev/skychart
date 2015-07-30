#!/bin/bash 

version=3.11

builddir=/tmp/skychart  # Be sure this is set to a non existent directory, it is removed after the run!

arch=$(uname -m)

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

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
  rm skychart*.xz
  rm bin-*.xz
  rm -rf $builddir

# make FreeBSD version
  ./configure $configopt prefix=$builddir
  if [[ $? -ne 0 ]]; then exit 1;fi
  gmake clean all
  if [[ $? -ne 0 ]]; then exit 1;fi
  gmake install
  if [[ $? -ne 0 ]]; then exit 1;fi
  gmake install_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  gmake install_doc
  if [[ $? -ne 0 ]]; then exit 1;fi
  gmake install_nonfree
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  cd ..
  tar cvJf skychart-$version-$currentrev-FreeBSD_$arch.tar.xz skychart
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.tar.xz $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  #debug
  cd $wd
  rm -rf $builddir
  gmake clean
  fpcopts="-O1 -g -gl -Ci -Co -Ct" gmake all
  if [[ $? -ne 0 ]]; then exit 1;fi
  mkdir $builddir
  mkdir $builddir/debug
  cp skychart/cdc $builddir/debug/skychart
  cp skychart/cdcicon $builddir/debug/
  cp varobs/varobs $builddir/debug/
  cp varobs/varobs_lpv_bulletin $builddir/debug/
  cd $builddir
  tar cvJf bin-FreeBSD_$arch-debug-$currentrev.tar.xz debug
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv bin-*.tar.xz $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

cd $wd
rm -rf $builddir

# store revision 
  echo $currentrev > last.build
else
  echo Already build at revision $currentrev
  exit 4
fi

