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
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/appdata
install -m 755 -d $destdir/share/skychart
install -v -m 644 system_integration/Linux/skychart-data-dso/share/appdata/skychart-data-dso.metainfo.xml $destdir/share/appdata/skychart-data-dso.metainfo.xml

InstCat catalog_gcm $destdir/share/skychart
InstCat catalog_gpn $destdir/share/skychart
InstCat catalog_lbn $destdir/share/skychart
InstCat catalog_ocl $destdir/share/skychart
InstCat catalog_leda $destdir/share/skychart
InstCat catalog_barnard $destdir/share/skychart
InstCat catalog_sh2 $destdir/share/skychart
