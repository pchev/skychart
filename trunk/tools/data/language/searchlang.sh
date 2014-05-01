langs='ca cs de el en es fa fr hr hu is it ja ml nb nl no pl pt_BR pt ru si sl sv th tr uk zh_CN zh zh_TW'

for lg in $langs; do
echo '======================================================================'
echo $lg
#### repeat this block for each text
txt="Display the chart information in the menu bar"
echo $txt
sed -n "/$txt/ {p;n;p} " skychart.$lg.po
echo
####
done
