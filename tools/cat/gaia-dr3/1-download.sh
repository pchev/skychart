mkdir csv
cd csv
# !! 757 GB
wget -r -nH -nd -l1 http://cdn.gea.esac.esa.int/Gaia/gdr3/gaia_source/

cd ..
wget http://cdn.gea.esac.esa.int/Gaia/gedr3/cross_match/hipparcos2_best_neighbour/Hipparcos2BestNeighbour.csv.gz

gunzip Hipparcos2BestNeighbour.csv.gz
tail -n+2 Hipparcos2BestNeighbour.csv | sort -n -t, -k1 | cut -d, -f1,2 > HipparcosByGaia
tail -n+2 Hipparcos2BestNeighbour.csv | sort -n -t, -k2 | cut -d, -f1,2 > HipparcosByHip

wget https://github.com/pchev/skychart/raw/master/tools/cat/xhip/src/cdc_xhip.dat
