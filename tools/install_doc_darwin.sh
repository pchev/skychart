#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart doc to $destdir

install -v -m 755 -d $destdir

for f in $(sort dir-doc.lst)
do
  install -v -m 755 -d $destdir/$f
done

for f in $(cat doc.lst)
do
  install -v -m 644  $f $destdir/$f
done

if [ ! -d doc/wiki_doc ]; then
  cd wiki_doc
  ./getdoc.sh
  ./copydoc.sh
  cd ..
fi

for f in $(find doc/wiki_doc/|grep -v .svn)
do
 if [ ! -d $f ]
  then install -v -m 644  $f $destdir/$f
 fi
done
