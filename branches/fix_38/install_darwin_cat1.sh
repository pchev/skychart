#!/bin/bash

# install star catalog data

function InstCat {
  pkg=$1.tgz
  ddir=$2
  pkgz=BaseData/$pkg
  if [ ! -e $pkgz ]; then
     curl -L -o $pkgz http://sourceforge.net/projects/skychart/files/4-source_data/$pkg
  fi
  tar xvzf $pkgz -C $ddir
}

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install star catalog to $destdir

install -m 755 -d $destdir

InstCat catalog_gcvs $destdir
InstCat catalog_idx  $destdir
InstCat catalog_tycho2  $destdir
InstCat catalog_wds  $destdir

