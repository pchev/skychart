Rem Path to compiler and util (make, rm)
PATH=D:\Mingw-w64\bin;D:\Gnu\bin;%PATH%
set CC=x86_64-w64-mingw32-gcc.exe
set AR=x86_64-w64-mingw32-ar.exe
set RC=x86_64-w64-mingw32-windres.exe
set STRIP=x86_64-w64-mingw32-strip.exe
copy Makefile.win64 zlib-1.2.5\
cd zlib-1.2.5
make -f Makefile.win64 clean
make -f Makefile.win64 zlib1_x64.dll
pause