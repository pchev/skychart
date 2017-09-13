rm timememo-2.0-windows.zip timememo.exe timememo-2.0-linux-x64.tgz timememo

confopt='fpc=/usr/local/lib/fpc/3.0.2 lazarus=/home/compiler/lazarus'

./configure $confopt
make clean all

rm -rf Timememo
mkdir Timememo
cp Readme.txt GPL.TXT timeserver.lst timememo Timememo/
tar cvzf timememo-2.0-linux-x64.tgz Timememo

./configure $confopt target=i386-win32
make clean all OS_TARGET=win32 CPU_TARGET=i386

rm -rf Timememo
mkdir Timememo
cp Readme.txt GPL.TXT timeserver.lst timememo.exe Timememo/
zip -r timememo-2.0-windows.zip Timememo
rm -rf Timememo

