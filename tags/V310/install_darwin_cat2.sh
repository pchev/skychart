#!/bin/bash

# install nebulae catalog data

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

echo Install nebulae catalog to $destdir

install -m 755 -d $destdir

InstCat catalog_gcm $destdir
InstCat catalog_gpn $destdir
InstCat catalog_lbn $destdir
InstCat catalog_ngc $destdir
InstCat catalog_ocl $destdir
InstCat catalog_pgc $destdir

