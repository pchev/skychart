#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/skychart
fi

echo Install skychart doc to $destdir

install -v -m 755 -d $destdir
install -v -m 755 -d $destdir/share
install -v -m 755 -d $destdir/share/skychart

for f in $(sort dir-doc.lst)
do
  install -v -m 755 -d $destdir/share/skychart/$f
done

for f in $(cat doc.lst)
do
  install -v -m 644  $f $destdir/share/skychart/$f
done

if [ ! -d doc/wiki_doc ]; then
  cd wiki_doc
  ./getdoc.sh
  ./copydoc.sh
  cd ..
fi

# create directories
for f in $(find doc/wiki_doc -type d |grep -v .svn)
do  
 if [ -d $f ]
   then  install -v -d -m 755  $destdir/share/skychart/$f
 fi
done

# install files
for f in $(find doc/wiki_doc/|grep -v .svn)
do
  install -v -m 644  $f $destdir/share/skychart/$f
done


