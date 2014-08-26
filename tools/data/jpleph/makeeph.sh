#!/bin/bash

# compile the version modified with T1 and T2 values
gfortran asc2eph2000-2050.f -o asc2eph

# get the ascii files
if [ ! -e header.430_572 ]; then
   wget ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/de430/header.430_572
fi
if [ ! -e ascp1950.430 ]; then
   wget ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/de430/ascp1950.430
fi
if [ ! -e ascp2050.430 ]; then
   wget ftp://ssd.jpl.nasa.gov/pub/eph/planets/ascii/de430/ascp2050.430
fi

# make the binary file
cat header.430_572 ascp1950.430 ascp2050.430 | ./asc2eph

mv JPLEPH lnxp2000p2050.430
rm asc2eph
