#!/bin/bash

# install SPICE base data

function InstSpice {
  pkg=$1.tar.xz
  ddir=$2
  pkgz=BaseData/$pkg
  if [ ! -e $pkgz ]; then
     wget http://sourceforge.net/projects/skychart/files/4-source_data/$pkg -O $pkgz
  fi
  tar xvJf $pkgz -C $ddir
}

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install SPICE base to $destdir

install -m 755 -d $destdir
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/skychart

InstSpice data_spicebase $destdir/share/skychart
