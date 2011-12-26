#!/bin/bash

# install star catalog data

function InstCat {
  pkg=$1.tgz
  ddir=$2
  pkgz=BaseData/$pkg
  if [ ! -e $pkgz ]; then
     wget http://download.origo.ethz.ch/skychart/2075/$pkg -O $pkgz
  fi
  tar xvzf $pkgz -C $ddir
}

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install star catalog data to $destdir

install -m 755 -d $destdir
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/skychart

InstCat catalog_gcvs $destdir/share/skychart
InstCat catalog_idx  $destdir/share/skychart
InstCat catalog_tycho2 $destdir/share/skychart
InstCat catalog_wds $destdir/share/skychart
