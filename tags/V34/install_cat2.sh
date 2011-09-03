#!/bin/bash

# install nebulae catalog data

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

echo Install nebulae catalog data to $destdir

install -m 755 -d $destdir
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/skychart

InstCat catalog_gcm $destdir/share/skychart
InstCat catalog_gpn $destdir/share/skychart
InstCat catalog_lbn $destdir/share/skychart
InstCat catalog_ngc $destdir/share/skychart
InstCat catalog_ocl $destdir/share/skychart
InstCat catalog_pgc $destdir/share/skychart
