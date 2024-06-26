#!/bin/bash

# install star catalog data

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

echo Install star catalog data to $destdir

install -m 755 -d $destdir
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/metainfo
install -m 755 -d $destdir/share/skychart
install -v -m 644 system_integration/Linux/skychart-data-stars/share/metainfo/net.ap_i.skychart.skychart_data_stars.metainfo.xml $destdir/share/metainfo/net.ap_i.skychart.skychart_data_stars.metainfo.xml

InstCat catalog_gcvs $destdir/share/skychart
InstCat catalog_idx  $destdir/share/skychart
InstCat catalog_tycho2 $destdir/share/skychart
InstCat catalog_wds $destdir/share/skychart
