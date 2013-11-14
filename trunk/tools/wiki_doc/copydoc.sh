#!/bin/bash -x
#  copie  la doc

rm -rf ../doc/wiki_doc
mkdir ../doc/wiki_doc
rm doc_*/robots.txt
cp -R -p doc_*/* ../doc/wiki_doc/

