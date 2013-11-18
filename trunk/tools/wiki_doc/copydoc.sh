#!/bin/bash
#  copie  la doc

rm -rf ../doc/wiki_doc
mkdir ../doc/wiki_doc
rm doc_*/robots.txt
cp -R -p doc_*/* ../doc/wiki_doc/
cp print.css ../doc/wiki_doc/lib/exe/
cd ../doc/wiki_doc/lib/exe
css=$(ls -1 css.php*|head -1)
rm $css
mv print.css $css
cd -
