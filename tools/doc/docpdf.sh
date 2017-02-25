#!/bin/bash
#
#  script to make the pdf documentation 
#  
#  Requirement:
#    - run "make refresh_doc" in the tools directory 
#    - install wkhtmltopdf from http://code.google.com/p/wkhtmltopdf/
#

langs='ca  en  es  fr  it  nl  uk'
suffix=$1

rm doc_*.pdf pdflist.txt

cd wiki_doc

# main loop
for lang in $langs; do

echo $lang

# main index order
grep '<li class="level1"><div class="li"> <a href="' $lang/documentation/start.html \
     | sed 's/<li class="level1"><div class="li"> <a href="//'| cut -d\" -f1 \
     | awk '{printf ("'$lang'/documentation/%s \n", $1)}' > fl.txt

# remove external links
sed -i '/http:/ d' fl.txt
# remove new index
sed -i '/\/news\/start/ d' fl.txt

# insert title and doc index
sed -i '1 i '$lang'\/documentation\/00_title.html\n'$lang'\/documentation\/start.html' fl.txt

# insert pages not in index 

if [ -f "$lang/documentation/quick_start_solar_system.html" ]; then
  sed -i '/\/quick_start_guide.html/ a '$lang'\/documentation\/quick_start_chart.html \n'$lang'\/documentation\/quick_start_solar_system.html \n'$lang'\/documentation\/quick_start_deep_sky.html \n'$lang'\/documentation\/quick_start_telescope.html \n'$lang'\/documentation\/quick_start_server.html' fl.txt
fi

if [ -f "$lang/documentation/projection_comparison.html" ]; then
  sed -i '/\/chart_coordinates.html/ a '$lang'\/documentation\/projection_comparison.html' fl.txt
fi

if [ -f "$lang/documentation/image_list.html" ]; then
  sed -i '/\/pictures.html/ a '$lang'\/documentation\/image_list.html' fl.txt
fi

if [ -f "$lang/documentation/virtual_observatory_interface.html" ]; then 
  sed -i '/\/catalog.html/ a '$lang'\/documentation\/virtual_observatory_interface.html' fl.txt
fi

if [ -f "$lang/documentation/telescope_ascom.html" ]; then 
 sed -i '/\/system.html/ a '$lang'\/documentation\/telescope_ascom.html \n'$lang'\/documentation\/telescope_indi.html \n'$lang'\/documentation\/telescope_lx200.html \n'$lang'\/documentation\/telescope_encoder.html ' fl.txt
fi

# all in one line
sed -i ':a;N;$!ba;s/\n/ /g' fl.txt 
# read the list of file
fl=$(<fl.txt)

# create title page

dt='Edited: '$(LC_ALL=C date '+%B %d %Y')
t='Cartes du Ciel / Skychart'
lastv='Last version is available from the wiki at'
l='Users documentation'
tocl='Table of Content'
if [[ $lang = 'ca' ]]; then 
  t='Cartes del Cel'
  l='Documentació en català'
  dt='Editat: '$(LC_ALL=ca_ES.utf8 date '+%d %B %Y')
  lastv='La darrera versió està disponible des del wiki a'
  tocl='Taula de continguts'
fi
if [[ $lang = 'en' ]]; then 
  l='English documentation' 
fi
if [[ $lang = 'es' ]]; then
  t='Cartes du Ciel / SkyChart'
  l='Documentación en español'
  dt='Edición: '$(LC_ALL=es_ES.utf8 date '+%d %B %Y')
  lastv='La versión más reciente está disponible en la wiki'
  tocl='Tabla de contenidos' 
fi
if [[ $lang = 'fr' ]]; then
  t='Cartes du Ciel'
  l='Documentation en français'
  dt='Version du: '$(LC_ALL=fr_FR.utf8 date '+%d %B %Y')
  lastv='La dernière version est disponible depuis le Wiki'
  tocl='Table des matières'
fi
if [[ $lang = 'it' ]]; then
  l='Italian documentation'
fi
if [[ $lang = 'nl' ]]; then
  t='Cartes du Ciel / Skychart'
  l='Engelstalige documentatie'
  dt='Geschreven: '$(LC_ALL=nl_NL.utf8 date '+%d %B %Y')
  lastv='Laatste versie is beschikbaar op deze wiki'
  tocl='Inhoudsopgave'
fi
if [[ $lang = 'ru' ]]; then
  l='Russian documentation'
fi
if [[ $lang = 'tr' ]]; then
  l='Turkish documentation'
fi
if [[ $lang = 'uk' ]]; then
  l='Ukrainian documentation'
fi

cp ../cdctitle.png  $lang/documentation/

cat > $lang/documentation/00_title.html << EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
</head>
<body>
<center>
<br/><br/><br/><br/><br/><br/><br/><br/>
<H1> $t </H1>
<br/><br/>
<b>$l</b>
<br/><br/>
$dt
<br/><br/>
$lastv <br/>
<a href="http://www.ap-i.net/skychart/$lang/documentation/start">http://www.ap-i.net/skychart/$lang/documentation/start</a>
<br/><br/>
<br/><br/>
<br/><br/>
<br/><br/>
<img src="cdctitle.png" width="100%">
</center>
</body>
</html>
EOF

# toc
wkhtmltopdf --dump-default-toc-xsl > toc.xsl
sed -i "s/Table of Content/$tocl/g" toc.xsl

# create pdf
wkhtmltopdf --quiet --dpi 96 --enable-toc-back-links  --enable-external-links --enable-internal-links --footer-right '[page]' $fl toc --xsl-style-sheet toc.xsl  tmp.pdf

# fix for anchor bug : http://code.google.com/p/wkhtmltopdf/issues/detail?id=463
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 -dColorImageResolution=300 -dGrayImageResolution=300 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=../doc_${suffix}_${lang}.pdf tmp.pdf

echo doc_${suffix}_${lang}.pdf >> ../pdflist.txt

# cleanup
rm tmp.pdf fl.txt toc.xsl $lang/documentation/00_title.html $lang/documentation/cdctitle.png

# end main loop
done


