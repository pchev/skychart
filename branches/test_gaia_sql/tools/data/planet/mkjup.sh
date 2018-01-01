#!/bin/bash
#
# Get latest HST Jupiter color map from https://archive.stsci.edu/prepds/opal/
# Measure pixel position of GRS center.
# If required, adjust the color to fill the pole area.
#
# Syntax:
#
# ./mkjup.sh [image_file_name] [grs_pixel_position]
#
# Example for cycle 23 image (february 2016):
#
# wget https://archive.stsci.edu/missions/hlsp/opal/cycle23/jupiter/hlsp_opal_hst_wfc3-uvis_jupiter-2016a_f395n-f502n-f631n_v1_globalmap.tif
#
# ./mkjup.sh hlsp_opal_hst_wfc3-uvis_jupiter-2016a_f395n-f502n-f631n_v1_globalmap.tif 1130
#

polecolor="#9c865f"
jupimg=$1
grspos=$2

convert $jupimg -roll -$grspos+0 -resize 1024x512 -fill "$polecolor" -fuzz 25% -draw "color 1,1 floodfill" -draw "color 1,511 floodfill" jupiter-0.jpg

