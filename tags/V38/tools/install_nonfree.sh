#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart nonfree to $destdir

install -v -m 755 -d $destdir
install -v -m 755 -d $destdir/share
install -v -m 755 -d $destdir/share/skychart

for f in $(sort dir-nonfree.lst)
do
  install -v -m 755 -d $destdir/share/skychart/$f
done

for f in $(cat nonfree.lst)
do
  install -v -m 644  $f $destdir/share/skychart/$f
done
