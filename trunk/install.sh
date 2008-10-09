#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart to $destdir

install -m 755 -d $destdir/bin
install -m 755 -d $destdir/lib
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/apps
install -m 755 -d $destdir/share/apps/skychart

for f in $(cat data.lst)
do
  install -v -D -m 644  tools/$f $destdir/share/apps/skychart/$f
done

for f in $(cat doc.lst)
do
  install -v -D -m 644  tools/$f $destdir/share/apps/skychart/$f
done

for f in $(cat cat.lst)
do
  install -v -D -m 644  tools/$f $destdir/share/apps/skychart/$f
done