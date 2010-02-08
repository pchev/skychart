#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart to $destdir

install -v -m 755 -d $destdir

for f in $(sort dir.lst)
do
  install -v -m 755 -d $destdir/$f
done

for f in $(cat data.lst)
do
  install -v -m 644  $f $destdir/$f
done

for f in $(cat doc.lst)
do
  install -v -m 644  $f $destdir/$f
done


for f in $(find doc/wiki_doc/|grep -v .svn)
do
  install -v -D -m 644  $f $destdir/$f
done

#unzip -d $destdir/doc/ doc/wiki_doc.zip

for f in $(cat cat.lst)
do
  install -v -m 644  $f $destdir/$f
done


