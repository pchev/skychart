#!/bin/bash

if [[ ! -e hip_main.dat ]]; then 
  wget ftp://cdsarc.u-strasbg.fr/pub/cats/I/239/hip_main.dat.gz 
  gunzip hip_main.dat.gz
fi

if [[ ! -e crossid_catalog.dat ]]; then 
  wget ftp://cdsarc.u-strasbg.fr/pub/cats/IV/27A/catalog.dat -O crossid_catalog.dat
fi

if [[ ! -e bsc_catalog.dat ]]; then 
  wget ftp://cdsarc.u-strasbg.fr/pub/cats/V/50/catalog.gz 
  gunzip catalog.gz
  mv catalog bsc_catalog.dat
fi

if [[ ! -e xhip_main.dat ]]; then 
  wget ftp://cdsarc.u-strasbg.fr/pub/cats/V/137/main.dat.gz
  gunzip main.dat.gz
  mv main.dat xhip_main.dat
fi

if [[ ! -e xhip_photo.dat ]]; then 
  wget ftp://cdsarc.u-strasbg.fr/pub/cats/V/137/photo.dat.gz
  gunzip photo.dat.gz
  mv photo.dat xhip_photo.dat
fi

if [[ ! -e xhip_biblio.dat ]]; then 
  wget ftp://cdsarc.u-strasbg.fr/pub/cats/V/137/biblio.dat.gz
  gunzip biblio.dat.gz
  mv biblio.dat xhip_biblio.dat
fi

fpc cdc_xhip.pp
./cdc_xhip

