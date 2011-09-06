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

lang=LANG
LANG=C
currentrev=`svn info . | grep Revision: | sed 's/Revision: //'`
LANG=$lang

# delete old files
  rm skychart-data-stars*.dmg
  rm -rf $basedir

# make Stars Mac version
  ./configure $configopt prefix=$builddir target=i386-darwin
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_cat1
  if [[ $? -ne 0 ]]; then exit 1;fi
  # pkg
  cp system_integration/MacOSX/skychart-data-stars.packproj $basedir
  cp system_integration/MacOSX/readme_stars.txt $basedir
  cd $basedir
  mv Cartes "Cartes du Ciel"
  freeze -v skychart-data-stars.packproj
  if [[ $? -ne 0 ]]; then exit 1;fi
  hdiutil create -anyowners -volname skychart-data-stars-$version-$currentrev-macosx -imagekey zlib-level=9 -format UDZO -srcfolder ./build skychart-data-stars-$version-$currentrev-macosx.dmg
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-data-stars*.dmg $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $basedir

