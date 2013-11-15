#!/bin/bash
#
#  script to make the pdf documentation 
#  
#  Requirement:
#    - run "make refresh_doc" in the tools directory 
#    - install wkhtmltopdf from http://code.google.com/p/wkhtmltopdf/
#

langs='ca  en  es  fr  it  nl  ru  tr  uk'

rm doc_*.pdf

cd wiki_doc

// main loop
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

if [ -f "$lang/documentation/virtual_observatory_interface.html" ]; then 
  sed -i '/\/catalog.html/ a '$lang'\/documentation\/virtual_observatory_interface.html' fl.txt
fi

if [ -f "$lang/documentation/telescope_ascom.html" ]; then 
 sed -i '/\/system.html/ a '$lang'\/documentation\/telescope_ascom.html \n'$lang'\/documentation\/telescope_indi.html \n'$lang'\/documentation\/telescope_lx200.html \n'$lang'\/documentation\/telescope_encoder.html ' fl.txt
fi

# create title page

dt='Edited: '$(LC_ALL=C date '+%B %d %Y')
t='Cartes du Ciel / Skychart'
lastv='Last version is available from the wiki at'
l='Users documentation'
if [[ $lang = 'ca' ]]; then 
  l='Catalan documentation' 
fi
if [[ $lang = 'en' ]]; then 
  l='English documentation' 
fi
if [[ $lang = 'es' ]]; then
  l='Spanish documentation'
fi
if [[ $lang = 'fr' ]]; then
  dt='Version du: '$(LC_ALL=fr_FR.utf8 date '+%d %B %Y')
  t='Cartes du Ciel'
  l='Documentation en français'
  lastv='La dernière version est disponible depuis le Wiki'
fi
if [[ $lang = 'it' ]]; then
  l='Italian documentation'
fi
if [[ $lang = 'nl' ]]; then
  l='Dutch documentation'
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
</center>
</body>
</html>
EOF

# all in one line
sed -i ':a;N;$!ba;s/\n/ /g' fl.txt 
# read the list of file
fl=$(<fl.txt)

# create pdf
wkhtmltopdf --use-xserver --dpi 96 --enable-toc-back-links  --enable-external-links --enable-internal-links --footer-right '[page]' $fl toc ../doc_$lang.pdf

# cleanup
rm fl.txt $lang/documentation/00_title.html

# end main loop
done


