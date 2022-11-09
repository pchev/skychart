 
Extract Gaia DR3 data for use as CdC catalog.

Adjust Lazarus path in the script to compile the required program.
Execute the script in order:
1-download.sh
2-extractgaia.sh
3-extractgaiahip.sh
4-mergegaiahip.sh

This produce the files used as input by Catgen to produce the four part to 
magnitude 12,15,18 and the remain to 21. 
Files for magnitude 12 and 15 do not include cross-matched Hipparcos stars 
that are written in file catgen_gaiahip.dat to be processed in ../xhip/
