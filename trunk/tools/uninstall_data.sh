#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Uninstall skychart from $destdir

for f in $(cat data.lst)
do
  rm -v $destdir/share/apps/skychart/$f
done

for f in $(cat doc.lst)
do
  rm -v $destdir/share/apps/skychart/$f
done

for f in $(cat cat.lst)
do
  rm -v $destdir/share/apps/skychart/$f
done

for f in $(sort -r dir.lst)
do
  rmdir -v $destdir/share/apps/skychart/$f
done

rmdir -v $destdir/share/apps/skychart
rmdir -v $destdir/share/apps
rmdir -v $destdir/share
rmdir -v $destdir

