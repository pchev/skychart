#!/bin/bash

# Make a pdf from the wiki documentation
# use wkhtmltopdf available from https://code.google.com/p/wkhtmltopdf/
#
# syntax: ./mkdocpdf.sh [language]
#

lang=$1
if [ -z $lang ] ; then exit 1 ; fi

# copy data from local wiki copy (run "make refresh_doc" in tools directory if it is not available)
rm -rf _media lib $lang/documentation
rm doc_$lang.pdf
cp -a ../../doc/wiki_doc/_media .
cp -a ../../doc/wiki_doc/lib .
mkdir -p $lang/documentation
cp ../../doc/wiki_doc/$lang/documentation/* $lang/documentation/

# get page order from the wiki index 
grep '<li class="level1"><div class="li"> <a href="' $lang/documentation/start.html \
     | sed 's/<li class="level1"><div class="li"> <a href="//'| cut -d\" -f1 \
     | awk '{n=n+1; printf ("'$lang'/documentation/%s '$lang'/documentation/%02i_%s\n", $1, n, $1)}'| xargs -l1 mv  
# order pages not in the main index
mv $lang/documentation/start.html $lang/documentation/01_start.html
mv $lang/documentation/13_quick_start_guide.html $lang/documentation/13_01_quick_start_guide.html
mv $lang/documentation/quick_start_chart.html $lang/documentation/13_02_quick_start_chart.html
mv $lang/documentation/quick_start_solar_system.html $lang/documentation/13_03_quick_start_solar_system.html
mv $lang/documentation/quick_start_deep_sky.html $lang/documentation/13_04_quick_start_deep_sky.html
mv $lang/documentation/quick_start_telescope.html $lang/documentation/13_05_quick_start_telescope.html
mv $lang/documentation/quick_start_server.html $lang/documentation/13_06_quick_start_server.html
mv $lang/documentation/projection_comparison.html $lang/documentation/44_projection_comparison.html
mv $lang/documentation/virtual_observatory_interface.html $lang/documentation/45_virtual_observatory_interface.html
mv $lang/documentation/telescope_ascom.html $lang/documentation/49_telescope_ascom.html
mv $lang/documentation/telescope_indi.html $lang/documentation/49_telescope_indi.html
mv $lang/documentation/telescope_lx200.html $lang/documentation/49_telescope_lx200.html
mv $lang/documentation/telescope_encoder.html $lang/documentation/49_telescope_encoder.html

# make a title page
dt=$(LC_ALL=C date '+%B %d %Y')
cat > $lang/documentation/00_title.html << EOF
<html>
<body>
<center>
<br/><br/><br/><br/><br/><br/><br/><br/>
<H1> Cartes du Ciel / Skychart</H1>
<br/><br/>
<b>User documentation</b>
<br/><br/>
Edited: $dt
<br/><br/>
Last version is available from the wiki at <br/>
<a href="http://www.ap-i.net/skychart/$lang/documentation/start">http://www.ap-i.net/skychart/$lang/documentation/start</a>
</center>
</body>
</html>
EOF

# make teh pdf
wkhtmltopdf --dpi 96 --enable-toc-back-links --header-center "- [section] -" --footer-center "Page [page]" $lang/documentation/*.html toc doc_$lang.pdf

# cleanup
rm -rf _media lib $lang/documentation

