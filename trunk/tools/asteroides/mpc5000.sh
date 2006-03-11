date
wget  -O- ftp://anonymous:pch%40freesurf.ch@cfa-ftp.harvard.edu/pub/MPCORB/MPCORB.DAT | head -5039 - > mpc5000.dat
dos2unix -u mpc5000.dat
echo upload the file
date
# ftp -n www.ap-i.net
echo end
date
