#!/bin/bash 

version=4.3

basedir=/tmp/skychart    # Be sure this is set to a non existent directory, it is removed after the run!

builddir=$basedir/Cartes

unset make_debug
unset extratarget

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

arch=$(arch)
wd=`pwd`

if [[ $arch == arm64 ]]; then
 extratarget=",aarch64-darwin"
fi

# check if new revision since last run
read lastrev <last.build
currentrev=$(git rev-list --count --first-parent HEAD)
if [[ -z $currentrev ]]; then 
 currentrev=$(grep RevisionStr skychart/revision.inc| sed "s/const RevisionStr = '//"| sed "s/';//")
fi
echo $lastrev ' - ' $currentrev
if [[ $lastrev -ne $currentrev ]]; then

# delete old files
  rm skychart-*.dmg
  rm bin-*.bz2
  rm -rf $basedir

# make x86_64 Mac version
  ./configure $configopt prefix=$builddir target=x86_64-darwin$extratarget
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=x86_64 clean
  fpcopts="-CX -XX -Xs -Cs8388608" make CPU_TARGET=x86_64
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install CPU_TARGET=x86_64
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_data
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_doc
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install_nonfree
  if [[ $? -ne 0 ]]; then exit 1;fi
  # pkg
  sed -i.bak "22s/1.0/$version/"  $builddir/skychart.app/Contents/Info.plist
  sed -i.bak "22s/1.0/$version/"  $builddir/cdcicon.app/Contents/Info.plist
  sed -i.bak "22s/1.0/$version/"  $builddir/varobs_lpv_bulletin.app/Contents/Info.plist
  sed -i.bak "22s/1.0/$version/"  $builddir/varobs.app/Contents/Info.plist
  rm $builddir/skychart.app/Contents/Info.plist.bak
  rm $builddir/cdcicon.app/Contents/Info.plist.bak
  rm $builddir/varobs_lpv_bulletin.app/Contents/Info.plist.bak
  rm $builddir/varobs.app/Contents/Info.plist.bak
  cp system_integration/MacOSX/skychart64.pkgproj $basedir
  cp system_integration/MacOSX/readme.txt $basedir
  cd $basedir
  mv Cartes "Cartes du Ciel"
  packagesbuild -v skychart64.pkgproj
  if [[ $? -ne 0 ]]; then exit 1;fi
  cp readme.txt build/
  hdiutil create -anyowners -volname skychart-$version-$currentrev-x86_64-macosx -imagekey zlib-level=9 -format UDZO -srcfolder ./build skychart-$version-$currentrev-x86_64-macosx.dmg
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv skychart*.dmg $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  if [[ $make_debug ]]; then
    #debug
    cd $wd
    rm -rf $basedir
    make CPU_TARGET=x86_64 clean
    fpcopts="-g -gl -Ci -Co -Ct -Cs8388608" Make CPU_TARGET=x86_64
    if [[ $? -ne 0 ]]; then exit 1;fi
    mkdir $basedir
    mkdir $basedir/debug
    cp skychart/cdc $basedir/debug/skychart
    cp varobs/varobs $basedir/debug/
    cd $basedir/debug/
    if [[ $? -ne 0 ]]; then exit 1;fi
    tar cvjf bin-macosx-x86_64-debug-$currentrev.tar.bz2 *
    if [[ $? -ne 0 ]]; then exit 1;fi
    mv bin-*.tar.bz2 $wd
    if [[ $? -ne 0 ]]; then exit 1;fi
  fi
  cd $wd
  rm -rf $basedir

# store revision 
  echo $currentrev > last.build
else
  echo Already build at revision $currentrev
  exit 4
fi

