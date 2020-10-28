#!/bin/bash

# script to build the satellite kernel for Skychart
# detail of the merge operation is in file cdc_merge.txt

# get the SPICE toolkit
wget http://naif.jpl.nasa.gov/pub/naif/toolkit//C/PC_Linux_GCC_64bit/packages/cspice.tar.Z
tar xf cspice.tar.Z

# get the leap seconds file
wget ftp://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/latest_leapseconds.tls

# get the SPICE satellites data ~ 6.5 GB
wget ftp://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/*

# merge the cdc files
rm cdcbase.bsp cdcext.bsp
cspice/exe/spkmerge cdc_merge.txt

# check the result
cspice/exe/brief cdcbase.bsp cdcext.bsp

