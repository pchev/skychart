# Extract part of tzdata package for use on Windows systems.
rm -rf zoneinfo
rm zoneinfo.zip
mkdir zoneinfo
cd zoneinfo
cp -rL /usr/share/zoneinfo/America .
cp -rL /usr/share/zoneinfo/Asia .
cp -rL /usr/share/zoneinfo/Europe .
cp -rL /usr/share/zoneinfo/Africa .
cp -rL /usr/share/zoneinfo/Pacific .
cp -rL /usr/share/zoneinfo/Etc .
cp -rL /usr/share/zoneinfo/Australia .
cp -rL /usr/share/zoneinfo/Indian .
cp -rL /usr/share/zoneinfo/Atlantic .
cp -rL /usr/share/zoneinfo/Antarctica .
cp -rL /usr/share/zoneinfo/Arctic .
cp /usr/share/zoneinfo/zone.tab . 
cd ..
zip -r zoneinfo.zip zoneinfo
rm -rf zoneinfo
