#!/bin/bash -x
#  copie  la doc

mkdir ../doc/wiki_doc
rm -rf ../doc/wiki_doc/*
rm doc_*/robots.txt
cp -a doc_*/* ../doc/wiki_doc/

