langs='ca cs de el en es fa fr hr hu is it ja ml mr nb nl no oc pl pt_BR pt ru si sk sl sv th tr uk zh_CN zh zh_TW'

for lg in $langs; do
echo '======================================================================'
echo $lg
#### repeat this block for each text
txt="Plot the position of the moving object."
echo $txt
sed -n "/$txt/ {p;n;p} " skychart.$lg.po
echo
####
done
