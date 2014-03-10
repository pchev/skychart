#!/bin/bash 

# Script to make the full source tar for release

version=3.9
pkg=trunk
#pkg=tags/V36
repo=http://svn.code.sf.net/p/skychart/code

builddir=/tmp/skychart-src  # Be sure this is set to a non existent directory, it is removed after the run!

wd=`pwd`

# Get revision number
svnrev=$(LC_ALL=C svn --non-interactive info $wd |grep "Last Changed Rev:" | sed 's/Last Changed Rev: //')
verdir=skychart-$version-$svnrev-src

mkdir -p $builddir
cd $builddir

# export sources
svn export $repo/$pkg $verdir

# revision include
cat <<EOF > $verdir/skychart/revision.inc
// Created by source export for version $version
const RevisionStr = '$svnrev';
EOF

# download doc
cd $verdir/tools
if [ -f /home/transfert/daily_build/doc_skychart.tgz ]; then
  cd doc
  tar xzf /home/transfert/daily_build/doc_skychart.tgz
else
  ./refresh_wiki_doc.sh 
fi
cd $builddir

# download jpleph
cd $verdir/BaseData
wget http://sourceforge.net/projects/skychart/files/4-source_data/data_jpleph.tgz
cd -

# tar files
tar cvJf $verdir.tar.xz $verdir

mv $verdir.tar.xz $wd/

cd $wd
rm -rf $builddir

