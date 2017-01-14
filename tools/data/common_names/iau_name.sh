#!/bin/bash
#
#  convert IAU star name file to CdC format
#
#  see also https://www.iau.org/science/scientific_bodies/working_groups/280/
#
#  wget http://www.pas.rochester.edu/~emamajek/WGSN/IAU-CSN.txt
#
#  then replace few tabulation by corresponding space in file IAU-CSN.txt
#


cat IAU-CSN.txt |grep -v \# | grep  HR | cut -c 19-28,1-18 | sed 's/^\(.*\)HR\(.*\)$/\2 \1/'> StarsNames.txt

