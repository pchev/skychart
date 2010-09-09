#!/bin/bash

# install nebulae catalog data

function InstPict {
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

echo Install DSO pictures to $destdir

install -m 755 -d $destdir

InstPict pictures_sac $destdir
