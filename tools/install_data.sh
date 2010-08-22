#!/bin/bash

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

for f in $(cat doc.lst)
do
  install -v -m 644  $f $destdir/share/skychart/$f
done

for f in $(cat cat.lst)
do
  install -v -m 644  $f $destdir/share/skychart/$f
done

if [ ! -d doc/wiki_doc ]; then
  cd wiki_doc
  ./getdoc.sh
  ./copydoc.sh
fi

for f in $(find doc/wiki_doc/|grep -v .svn)
do
  install -v -D -m 644  $f $destdir/share/skychart/$f
done

#unzip -d $destdir/share/skychart/doc/ doc/wiki_doc.zip

