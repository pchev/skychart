 
tail -n+2 cdc_xhip.dat | sort -n -t\| -k1 > cdc_xhip_sorted
cat cdc_gaia_hipparcos.txt | sort -n -k11 > cdc_gaia_hipparcos_sorted
 
/home/compiler/lazarus/lazbuild --build-mode=Release mergegaiahip.lpi

./mergegaiahip
