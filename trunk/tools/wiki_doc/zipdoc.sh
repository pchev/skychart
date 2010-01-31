#!/bin/bash -x
#  copie et zip la doc

mkdir ../doc/wiki_doc
rm -rf ../doc/wiki_doc/*
rm doc_*/robots.txt
cp -a doc_*/* ../doc/wiki_doc/
cd ../doc/
rm wiki_doc.zip
zip -r wiki_doc.zip wiki_doc
rm -rf wiki_doc
cd -

