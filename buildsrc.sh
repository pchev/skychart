#!/bin/bash 

# Script to make the full source tar for release

version=4.2.1
repo=https://github.com/pchev/skychart.git

builddir=/tmp/skychart-src  # Be sure this is set to a non existent directory, it is removed after the run!

wd=`pwd`

# Get revision number
rev=$(git rev-list --count --first-parent HEAD)
verdir=skychart-$version-$rev-src

mkdir -p $builddir
cd $builddir
if [[ $? -ne 0 ]]; then exit 1;fi

# export sources
svn export $repo/trunk $verdir

# revision include
cat <<EOF > $verdir/skychart/revision.inc
// Created by source export for version $version
const RevisionStr = '$rev';
EOF

# download doc
cd $verdir/tools
if [ -f /data/transfert/daily_build/doc_skychart.tgz ]; then
  cd doc
  tar xzf /data/transfert/daily_build/doc_skychart.tgz
else
  ./refresh_wiki_doc.sh 
fi
cd $builddir

# download jpleph
cd $verdir/BaseData
wget http://sourceforge.net/projects/skychart/files/4-source_data/data_jpleph.tgz
cd $builddir

# tar files
tar cvJf $verdir.tar.xz $verdir

mv $verdir.tar.xz $wd/

cd $wd
rm -rf $builddir


