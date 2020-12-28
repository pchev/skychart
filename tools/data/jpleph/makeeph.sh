#!/bin/bash

# compile the version modified with T1 and T2 values
gfortran asc2eph2000-2050.f -o asc2eph

# get the ascii files
if [ ! -e header.440 ]; then
   wget ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/de440/header.440
fi
if [ ! -e ascp01950.440 ]; then
   wget ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/de440/ascp01950.440
fi
if [ ! -e ascp02050.440 ]; then
   wget ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/de440/ascp02050.440
fi

# make the binary file
cat header.440 ascp01950.440 ascp02050.440 | ./asc2eph

mv JPLEPH lnxp2000p2050.440
rm asc2eph
