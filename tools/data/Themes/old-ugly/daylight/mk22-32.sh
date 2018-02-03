# make 22 and 32 icons from old 16x16 bitmap
for f in $(ls 16x16/i*.png); do
  o=${f/16x16/22x22}
  convert $f -resize 22x22 $o
  o=${f/16x16/32x32}
  convert $f -resize 32x32 $o
done  
