# Extract part of tzdata package for use on Windows systems.
rm -rf zoneinfo
rm zoneinfo.zip
mkdir zoneinfo
cd zoneinfo
cp -a /usr/share/zoneinfo/America .
cp -a /usr/share/zoneinfo/Asia .
cp -a /usr/share/zoneinfo/Europe .
cp -a /usr/share/zoneinfo/Africa .
cp -a /usr/share/zoneinfo/Pacific .
cp -a /usr/share/zoneinfo/Etc .
cp -a /usr/share/zoneinfo/Australia .
cp -a /usr/share/zoneinfo/Indian .
cp -a /usr/share/zoneinfo/Atlantic .
cp -a /usr/share/zoneinfo/Antarctica .
cp -a /usr/share/zoneinfo/Arctic .
cp /usr/share/zoneinfo/zone.tab . 
cd ..
zip -r zoneinfo.zip zoneinfo
rm -rf zoneinfo
