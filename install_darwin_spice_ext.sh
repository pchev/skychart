#!/bin/bash

# install SPICE ext data

function InstSpice {
  pkg=$1.tar.xz
  ddir=$2
  pkgz=BaseData/$pkg
  if [ ! -e $pkgz ]; then
     curl -L -o $pkgz http://sourceforge.net/projects/skychart/files/4-source_data/$pkg
  fi
  tar xvJf $pkgz -C $ddir
}

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install SPICE ext to $destdir

install -m 755 -d $destdir

InstSpice data_spiceext $destdir
