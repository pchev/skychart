#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart to $destdir

install -v -m 755 -d $destdir
install -v -m 755 -d $destdir/share
install -v -m 755 -d $destdir/share/apps
install -v -m 755 -d $destdir/share/apps/skychart

for f in $(sort dir.lst)
do
  install -v -m 755 -d $destdir/share/apps/skychart/$f
done

for f in $(cat data.lst)
do
  install -v -m 644  $f $destdir/share/apps/skychart/$f
done

for f in $(cat doc.lst)
do
  install -v -m 644  $f $destdir/share/apps/skychart/$f
done

for f in $(cat cat.lst)
do
  install -v -m 644  $f $destdir/share/apps/skychart/$f
done

unzip -d $destdir/share/apps/skychart/doc/ doc/wiki_doc.zip
