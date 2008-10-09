#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Uninstall skychart from $destdir

for f in $(cat data.lst)
do
  rm $destdir/share/apps/skychart/$f
done

for f in $(cat doc.lst)
do
  rm $destdir/share/apps/skychart/$f
done

for f in $(cat cat.lst)
do
  rm $destdir/share/apps/skychart/$f
done

rmdir $destdir/share/apps/skychart
rmdir $destdir/share/apps
rmdir $destdir/share
rmdir $destdir/bin
rmdir $destdir/lib