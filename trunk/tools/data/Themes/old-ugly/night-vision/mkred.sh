# use imagemagick to convert the daylight icon to red

cp -f ../daylight/16x16/*.png 16x16/
cp -f ../daylight/22x22/*.png 22x22/
cp -f ../daylight/32x32/*.png 32x32/

cd 16x16
convert -size 10x100  gradient:\#FF8080-\#600000 -depth 8 color.png
ls i*.png | xargs -i+ -n1 convert + -grayscale Rec709Luminance  -normalize -depth 8 +
ls i*.png | xargs -i+ -n1 convert + color.png -fx 'v.p{0,u*v.h}' -depth 8 +
rm color.png
cd ..

cd 22x22
convert -size 10x100  gradient:\#FF8080-\#600000 -depth 8 color.png
ls i*.png | xargs -i+ -n1 convert + -grayscale Rec709Luminance  -normalize -depth 8 +
ls i*.png | xargs -i+ -n1 convert + color.png -fx 'v.p{0,u*v.h}' -depth 8 +
rm color.png
cd ..

cd 32x32
convert -size 10x100  gradient:\#FF8080-\#600000 -depth 8 color.png
ls i*.png | xargs -i+ -n1 convert + -grayscale Rec709Luminance  -normalize -depth 8 +
ls i*.png | xargs -i+ -n1 convert + color.png -fx 'v.p{0,u*v.h}' -depth 8 +
rm color.png
cd ..
