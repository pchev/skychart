#!/bin/bash

echo refresh documentation pages from the wiki 

  rm -rf doc/wiki_doc/*
  cd wiki_doc
  ./getdoc.sh
  ./copydoc.sh
  cd ..

