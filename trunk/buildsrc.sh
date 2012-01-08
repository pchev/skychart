#!/bin/bash 

# Script to make the full source tar for release

version=3.5
pkg=trunk
#pkg=tags/V36
repo=https://svn.origo.ethz.ch/skychart

builddir=/tmp/skychart-src  # Be sure this is set to a non existent directory, it is removed after the run!
verdir=skychart-$version-src

wd=`pwd`

mkdir -p $builddir
cd $builddir

# export sources
svn export $repo/$pkg $verdir

# revision include
svnrev=$(LANG=C svn info $repo/$pkg |grep "Last Changed Rev:" | sed 's/Last Changed Rev: //')
cat <<EOF > $verdir/skychart/revision.inc
// Created by source export for version $version
const RevisionStr = '$svnrev';
EOF

# download doc
cd $verdir/tools
./refresh_wiki_doc.sh 
cd -

# download jpleph
cd $verdir/BaseData
wget http://download.origo.ethz.ch/skychart/2443/data_jpleph.tgz
cd -

# tar files
tar cvzf $verdir.tgz $verdir

mv $verdir.tgz $wd/

cd $wd
rm -rf $builddir
