#!/bin/bash

# install nebulae catalog data

function InstPict {
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

echo Install DSO pictures to $destdir

install -m 755 -d $destdir
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/skychart

InstPict pictures_sac $destdir/share/skychart
