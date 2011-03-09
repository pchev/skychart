Rem Path to compiler and util (make, rm)
PATH=D:\Mingw-w64\bin;D:\Gnu\bin;%PATH%
set CC=x86_64-w64-mingw32-gcc.exe
make -f Makefile.win64 clean
make -f Makefile.win64
pause