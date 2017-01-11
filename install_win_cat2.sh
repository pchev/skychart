#!/bin/bash

# install nebulae catalog data

function InstCat {
  pkg=$1.tgz
  ddir=$2
  pkgz=BaseData/$pkg
  if [ ! -e $pkgz ]; then
     wget http://sourceforge.net/projects/skychart/files/4-source_data/$pkg -O $pkgz
  fi
  tar xvzf $pkgz -C $ddir
}

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install nebulae catalog data to $destdir

install -m 755 -d $destdir

InstCat catalog_gcm $destdir
InstCat catalog_gpn $destdir
InstCat catalog_lbn $destdir
InstCat catalog_ocl $destdir
InstCat catalog_leda $destdir
