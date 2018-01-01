Rem Path to compiler and util (make, rm)
PATH=D:\Mingw-w32\bin;D:\Gnu\bin;%PATH%
set CC=i686-w64-mingw32-gcc.exe
make -f Makefile.win clean
make -f Makefile.win
i686-w64-mingw32-strip.exe sqlite3.dll
pause