#!/bin/bash 

version=4.3

basedir=/Volumes/TmpInst/skychart   # Be sure this is set to a non existent directory, it is removed after the run!

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
currentrev=$(git rev-list --count --first-parent HEAD)
LANG=$lang

# delete old files
  rm skychart-spice*.dmg
  rm -rf $basedir

# make spice Mac version
  ./configure $configopt prefix=$builddir target=x86_64-darwin
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_spice_base
  if [[ $? -ne 0 ]]; then exit 1;fi
  # pkg
  cp system_integration/MacOSX/skychart-data-spice-base.packproj $basedir
  cp system_integration/MacOSX/readme_spice.txt $basedir
  cd $basedir
  mv Cartes "Cartes du Ciel"
  freeze -v skychart-data-spice-base.packproj
  if [[ $? -ne 0 ]]; then exit 1;fi
  hdiutil create -anyowners -volname skychart-spice-base-$version-$currentrev-macosx -imagekey zlib-level=9 -format UDZO -srcfolder ./build skychart-spice-base-$version-$currentrev-macosx.dmg
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-spice-base*.dmg $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $basedir

  make install_spice_ext
  if [[ $? -ne 0 ]]; then exit 1;fi
  # pkg
  cp system_integration/MacOSX/skychart-data-spice-ext.packproj $basedir
  cp system_integration/MacOSX/readme_spice.txt $basedir
  cd $basedir
  mv Cartes "Cartes du Ciel"
  freeze -v skychart-data-spiceext.packproj
  if [[ $? -ne 0 ]]; then exit 1;fi
  hdiutil create -anyowners -volname skychart-spice-ext-$version-$currentrev-macosx -imagekey zlib-level=9 -format UDZO -srcfolder ./build skychart-spice-ext-$version-$currentrev-macosx.dmg
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart-spice-ext*.dmg $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  cd $wd
  rm -rf $basedir
  
