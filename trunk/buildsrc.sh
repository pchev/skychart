#!/bin/bash 

# Script to make the full source tar for release

version=3.7
pkg=trunk
#pkg=tags/V36
repo=https://skychart.svn.sourceforge.net/svnroot/skychart

builddir=/tmp/skychart-src  # Be sure this is set to a non existent directory, it is removed after the run!

wd=`pwd`

# Get revision number
svnrev=$(LANG=C svn info $repo/$pkg |grep "Last Changed Rev:" | sed 's/Last Changed Rev: //')
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
./refresh_wiki_doc.sh 
cd -

# download jpleph
cd $verdir/BaseData
wget http://sourceforge.net/projects/skychart/files/4-source_data/data_jpleph.tgz
cd -

# tar files
tar cvjf $verdir.tar.bz2 $verdir

mv $verdir.tar.bz2 $wd/

cd $wd
rm -rf $builddir

