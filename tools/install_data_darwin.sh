#!/bin/bash

function InstData {
  pkg=$1.tgz
  ddir=$2
  pkgz=BaseData/$pkg
  if [ ! -e $pkgz ]; then
     curl -L -o $pkgz http://download.origo.ethz.ch/skychart/2075/$pkg
  fi
  tar xvzf $pkgz -C $ddir
}

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

for f in $(find doc/wiki_doc|grep -v .svn)
do  
 if [ -d $f ]
   then  install -v -d -m 755  $destdir/$f
 fi
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

for f in $(cat cat.lst)
do
  install -v -m 644  $f $destdir/$f
done

InstData data_jpleph $destdir

