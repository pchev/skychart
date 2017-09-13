confopt='fpc=/usr/local/lib/fpc/3.0.2 lazarus=/home/compiler/lazarus'

./configure $confopt
make clean all

./configure $confopt target=i386-win32
make clean all OS_TARGET=win32 CPU_TARGET=i386

