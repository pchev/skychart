#!/bin/bash -x
#  copie  la doc

mkdir ../doc/wiki_doc
rm doc_*/robots.txt
cp -R -p doc_*/* ../doc/wiki_doc/

