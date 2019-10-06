langs='br ca cs de el en_GB en es fa fr hr hu is it ja ku ml mr nb nl no oc pl pt_BR pt ru si sk sl sv th tr uk zh_CN zh_HK zh zh_TW'

for lg in $langs; do
echo '======================================================================'
echo $lg
#### repeat this block for each text
txt="Orient to the pole"
echo $txt
sed -n "/$txt/ {p;n;p} " skychart.$lg.po
echo
####
done
