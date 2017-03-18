#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Uninstall skychart from $destdir

for f in $(cat data.lst)
do
  rm -fv $destdir/$f
done

for f in $(cat data-nonfree.lst)
do
  rm -fv $destdir/$f
done

rm -rf $destdir/data/zoneinfo

for f in $(cat doc.lst)
do
  rm -fv $destdir/$f
done

rm -rf $destdir/doc/wiki_doc

for f in $(cat cat.lst)
do
  rm -fv $destdir/$f
done

for f in $(sort -r dir-nonfree.lst)
do
  rmdir -v $destdir/$f
done
for f in $(sort -r dir-doc.lst)
do
  rmdir -v $destdir/$f
done
for f in $(sort -r dir.lst)
do
  rmdir -v $destdir/$f
done

