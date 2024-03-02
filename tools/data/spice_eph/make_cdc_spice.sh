#!/bin/bash

# script to build the satellite kernel for Skychart
# detail of the merge operation is in file cdc_merge.txt

# get the SPICE toolkit
# Linux:
wget -nc https://naif.jpl.nasa.gov/pub/naif/toolkit//C/PC_Linux_GCC_64bit/packages/cspice.tar.Z
tar xf cspice.tar.Z
# Windows:
#wget https://naif.jpl.nasa.gov/pub/naif/toolkit//C/PC_Windows_VisualC_32bit/packages/cspice.zip
#unzip cspice.zip

# get the leap seconds file
wget https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/latest_leapseconds.tls

# get the SPICE satellites data ~ 6.5 GB
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/mar097.bsp
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/jup365.bsp
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/sat441.bsp
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/ura111.bsp
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/nep095.bsp
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/plu058.bsp
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/jup344.bsp
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/sat415.bsp
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/sat393_daphnis.bsp
wget -nc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/satellites/ura115.bsp

# merge the cdc files
rm cdcbase.bsp cdcext.bsp cdcsun.bsp
cspice/exe/spkmerge cdc_merge.txt

# check the result
cspice/exe/brief cdcbase.bsp cdcext.bsp cdcsun.bsp

