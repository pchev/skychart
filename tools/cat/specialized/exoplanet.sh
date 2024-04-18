#!/bin/bash
#
# Update the exoplanet catalog file 
# from http://www.openexoplanetcatalogue.com
# and expand to fixed column file.

rm open_exoplanet_catalogue.txt
rm exoplanet.txt

wget https://raw.githubusercontent.com/OpenExoplanetCatalogue/oec_tables/master/tab_separated/open_exoplanet_catalogue.txt

expand -t 40 open_exoplanet_catalogue.txt > exoplanet.txt
