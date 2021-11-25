#!/bin/bash

# Download leap seconds file

source="https://www.ietf.org/timezones/data/leap-seconds.list"
wget $source

## Create Delta T file for Cartes du Ciel 

source="ftps://gdc.cddis.eosdis.nasa.gov/products/iers"

# Get IERS
wget $source/finals.data

rm deltat.tmp deltat.txt 
rm historic_deltat.data deltat.data deltat.preds

# Get historic data
wget $source/historic_deltat.data
tail +3 historic_deltat.data | head -633 | awk '{printf $1 " " $2 " " $3 "\n"}' | while read dat del err
do 
 printf "%8.4f\t%8.4f\t%8.4f\n" "$dat" "$del" "$err" >> deltat.tmp
done 

# Get current data
wget $source/deltat.data
cat deltat.data | awk '{printf $1 " " $2 " " $3 " " $4 "\n"}' | while read y m d del
do 
 dat=$(echo 'scale=4;'"$y + ( $m -1 ) / 12"|bc -l)
 err=0 
 printf "%8.4f\t%8.4f\t%8.4f\n" "$dat" "$del" "$err" >> deltat.tmp
done 

# Get next years predictions
wget $source/deltat.preds
tail +2 deltat.preds | while read lin
do 
 dat=${lin:11:7}
 del=${lin:21:5}
 err=${lin:45:5}
 printf "%8.4f\t%8.4f\t%8.4f\n" "$dat" "$del" "$err" >> deltat.tmp
done 

# Sort and remove duplicate date
cat deltat.tmp | sort -u -k1.1,1.9 > deltat.txt

rm deltat.tmp
rm historic_deltat.data deltat.data deltat.preds
