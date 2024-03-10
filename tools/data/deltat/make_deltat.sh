#!/bin/bash

# ensure decimal dot
export LC_ALL=C

# Download leap seconds file

source="ftp://hpiers.obspm.fr/iers/bul/bulc/ntp/leap-seconds.list"
rm leap-seconds.list
wget $source

## Create Delta T file for Cartes du Ciel 

# available again but stay with cddis for now
#source="https://maia.usno.navy.mil/ser7"

source="ftps://gdc.cddis.eosdis.nasa.gov/products/iers"

# Get IERS
rm finals.data
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
tail +2 deltat.preds | awk '{ ER = ($5 == "") ? $4 : $5 ; printf $2 " " $3 " " ER "\n"}' | while read dat del err 
do 
 printf "%8.4f\t%8.4f\t%8.4f\n" "$dat" "$del" "$err" >> deltat.tmp
done 

# Sort and remove duplicate date
cat deltat.tmp | sort -u -k1.1,1.9 > deltat.txt

rm deltat.tmp
rm historic_deltat.data deltat.data deltat.preds
