#!/bin/bash

# get source code
wget http://zlib.net/zlib-1.2.11.tar.gz
if [[ $? != 0 ]]; then echo error ; exit 1; fi
tar xf zlib-1.2.11.tar.gz
if [[ $? != 0 ]]; then echo error ; exit 1; fi
cd zlib-1.2.11
if [[ $? != 0 ]]; then echo error ; exit 1; fi

# win32
cp win32/Makefile.gcc Makefile.win32
if [[ $? != 0 ]]; then echo error ; exit 1; fi
sed -i 's/CC = $(PREFIX)gcc/CC = i686-w64-mingw32-gcc/' Makefile.win32
if [[ $? != 0 ]]; then echo error ; exit 1; fi
sed -i 's/RC = $(PREFIX)windres/RC = i686-w64-mingw32-windres/' Makefile.win32
if [[ $? != 0 ]]; then echo error ; exit 1; fi
sed -i 's/AR = $(PREFIX)ar/AR = i686-w64-mingw32-ar/' Makefile.win32
if [[ $? != 0 ]]; then echo error ; exit 1; fi
sed -i 's/CFLAGS = $(LOC) -O3 -Wall/CFLAGS = $(LOC) -O3 -Wall -m32/' Makefile.win32
if [[ $? != 0 ]]; then echo error ; exit 1; fi
make -f Makefile.win32
if [[ $? != 0 ]]; then echo error ; exit 1; fi
zip ../zlib.zip zlib1.dll
if [[ $? != 0 ]]; then echo error ; exit 1; fi
make -f Makefile.win32 clean
if [[ $? != 0 ]]; then echo error ; exit 1; fi

# win64
cp win32/Makefile.gcc Makefile.win64
if [[ $? != 0 ]]; then echo error ; exit 1; fi
sed -i 's/CC = $(PREFIX)gcc/CC = x86_64-w64-mingw32-gcc/' Makefile.win64
if [[ $? != 0 ]]; then echo error ; exit 1; fi
sed -i 's/RC = $(PREFIX)windres/RC = x86_64-w64-mingw32-windres/' Makefile.win64
if [[ $? != 0 ]]; then echo error ; exit 1; fi
sed -i 's/AR = $(PREFIX)ar/AR = x86_64-w64-mingw32-ar/' Makefile.win64
if [[ $? != 0 ]]; then echo error ; exit 1; fi
sed -i 's/CFLAGS = $(LOC) -O3 -Wall/CFLAGS = $(LOC) -O3 -Wall -m64/' Makefile.win64
if [[ $? != 0 ]]; then echo error ; exit 1; fi
make -f Makefile.win64
if [[ $? != 0 ]]; then echo error ; exit 1; fi
zip ../zlib_x64.zip zlib1.dll
if [[ $? != 0 ]]; then echo error ; exit 1; fi
make -f Makefile.win64 clean
if [[ $? != 0 ]]; then echo error ; exit 1; fi
