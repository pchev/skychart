# sort by maxmag | cut at mag 14 | sort by minmag | cut at 0.05 (assume amplitude) | remove JKLMN infrared var 

cat vsx.dat | sort -n --key=1.95,1.101 | sed '/^.\{95\}13.999/q' | sort -n -r --key=1.118,1.124 | sed '/^.\{118\} 0.049/q' | sed '/^.\{104\}J/d'  | sed '/^.\{104\}K/d' | sed '/^.\{104\}L/d' | sed '/^.\{104\}M/d' | sed '/^.\{104\}N/d' > vsxmag14-05.dat
