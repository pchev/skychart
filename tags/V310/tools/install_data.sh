#!/bin/bash

function InstData {
  pkg=$1.tgz
  ddir=$2
  pkgz=../BaseData/$pkg
  if [ ! -e $pkgz ]; then
     wget http://sourceforge.net/projects/skychart/files/4-source_data/$pkg -O $pkgz
  fi
  tar xvzf $pkgz -C $ddir
}

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart to $destdir

install -v -m 755 -d $destdir
install -v -m 755 -d $destdir/share
install -v -m 755 -d $destdir/share/skychart

for f in $(sort dir.lst)
do
  install -v -m 755 -d $destdir/share/skychart/$f
done

for f in $(cat data.lst)
do
  install -v -m 644  $f $destdir/share/skychart/$f
done

for f in $(cat cat.lst)
do
  install -v -m 644  $f $destdir/share/skychart/$f
done

InstData data_jpleph $destdir/share/skychart


