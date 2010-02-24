#!/bin/bash 

version=3.1

basedir=/tmp/skychart   # Be sure this is set to a non existent directory, it is removed after the run!

builddir=$basedir/Cartes

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

wd=`pwd`

# update to last revision
#svn up --force --non-interactive --accept theirs-full    # svn 1.5 only
#svn -R revert .
#svn up --non-interactive

# check if new revision since last run
read lastrev <last.build
lang=LANG
LANG=C
currentrev=`svn info . | grep Revision: | sed 's/Revision: //'`
LANG=$lang
echo $lastrev ' - ' $currentrev
if [[ $lastrev -ne $currentrev ]]; then

# delete old files
  rm skychart*.dmg
  rm bin-*.zip
  rm -rf $basedir

# make i386 Mac version
  ./configure $configopt prefix=$builddir target=i386-darwin
  if [[ $? -ne 0 ]]; then exit 1;fi
  make clean
  make
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  # pkg
  cp system_integration/MacOSX/skychart.packproj $basedir
  cd $basedir
  mv Cartes "Cartes du Ciel"
  freeze -v skychart.packproj
  if [[ $? -ne 0 ]]; then exit 1;fi
  hdiutil create -anyowners -volname skychart-$version-$currentrev-i386-macosx -imagekey zlib-level=9 -format UDZO -srcfolder ./build skychart-$version-$currentrev-i386-macosx.dmg
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.dmg $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  #debug
  cd $wd
  mkdir $basedir/debug
  cp skychart/cdc $basedir/debug/skychart
  cp varobs/varobs $basedir/debug/
  cd $basedir/debug/
  if [[ $? -ne 0 ]]; then exit 1;fi
  tar cvjf bin-macosx-debug-$currentrev.tar.bz2 *
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv bin-*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $basedir

# store revision 
  echo $currentrev > last.build
else
  echo Already build at revision $currentrev
  exit 4
fi

