#!/bin/bash 

# Script to make the full source tar for release

version=3.5
pkg=trunk
#pkg=tags/V36
repo=https://svn.origo.ethz.ch/skychart

builddir=/tmp/skychart-src  # Be sure this is set to a non existent directory, it is removed after the run!
verdir=skychart-$version-src

mkdir -p $builddir
cd $builddir

# export sources
svn export $repo/$pkg $verdir

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
