Rem Path to compiler and util (make, rm)
PATH=D:\Mingw-w32\bin;D:\Gnu\bin;%PATH%
set CC=i686-w64-mingw32-gcc.exe
set AR=i686-w64-mingw32-ar.exe
set RC=i686-w64-mingw32-windres.exe
set STRIP=i686-w64-mingw32-strip.exe
copy Makefile.win32 zlib-1.2.5\
cd zlib-1.2.5
make -f Makefile.win32 clean
make -f Makefile.win32 zlib1.dll
pause