#
CFLAGS= -w -fPIC $(arch_flags) -std=c99 -D_XOPEN_SOURCE=500
OSTYPE = $(shell uname)
ifneq ($(findstring BSD,$(OSTYPE)),)
CC            = cc
else
CC            = gcc
endif
ifneq ($(findstring Darwin,$(OSTYPE)),)
  SO_Name       = libcdcwcs.dylib
  ifeq ($(CPU_TARGET),aarch64)
    CFLAGS= -w -fPIC $(arch_flags) -arch arm64 -std=c99 -D_XOPEN_SOURCE=500 -mmacos-version-min=11.0
    LIBFLAGS      = $(arch_flags) -arch arm64 -Wl,-single_module -dynamiclib  -lc -lm -mmacos-version-min=11.0
  else
    CFLAGS= -w -fPIC $(arch_flags) -arch x86_64 -std=c99 -D_XOPEN_SOURCE=500 -mmacos-version-min=10.14
    LIBFLAGS      = $(arch_flags) -arch x86_64 -Wl,-single_module -dynamiclib  -lc -lm -mmacos-version-min=10.14
  endif
else
  # linux
  SOName        = libpaswcs.so.1
  SO_Name       = libpaswcs.so.1.1
  LIBFLAGS      = -shared -Wl,-soname,$(SOName) -lc -lm
  ifeq ($(CPU_TARGET),aarch64)
    CC = aarch64-linux-gnu-gcc
  endif
  ifeq ($(CPU_TARGET),arm)
    CC = arm-linux-gnueabihf-gcc
  endif
endif
ifneq ($(findstring W32,$(OSTYPE)),)
  SO_Name       = libcdcwcs.dll
  LIBFLAGS      = -shared -Wl,-soname,$(SO_Name)  -lm
endif
ifneq ($(findstring MINGW,$(OSTYPE)),)
  SO_Name       = libcdcwcs.dll
  LIBFLAGS      = -shared -Wl,-soname,$(SO_Name)  -lm
endif

OBJS =	cdcwcs.o imgetwcs.o daoread.o wcscon.o \
	fitswcs.o wcsinit.o wcs.o  \
	imrotate.o fitsfile.o imhfile.o \
	hget.o hput.o imio.o dateutil.o imutil.o \
	worldpos.o tnxpos.o zpxpos.o dsspos.o platepos.o \
	sortstar.o iget.o fileutil.o \
	wcslib.o lin.o cel.o proj.o sph.o wcstrig.o distort.o poly.o
LIBS = -lm

all: $(SO_Name)

$(SO_Name): $(OBJS)
	$(CC) $(CFLAGS) $(LIBFLAGS) -o $@ $(OBJS) $(LIBS)

cdcwcs.o:	fitsfile.h wcs.h
actread.o:	fitsfile.h wcscat.h wcs.h fitshead.h wcslib.h
binread.o:	wcscat.h wcs.h fitshead.h wcslib.h
ctgread.o:	wcscat.h wcs.h fitshead.h wcslib.h
catutil.o:	wcscat.h wcs.h fitshead.h wcslib.h
cel.o:		wcslib.h
daoread.o:	wcscat.h
dateutil.o:	fitsfile.h fitshead.h
distort.o:	wcs.h fitshead.h wcslib.h
dsspos.o:	wcs.h fitshead.h wcslib.h
fileutil.o:	fitsfile.h fitshead.h
imutil.o:	fitsfile.h fitshead.h
findstar.o:	fitshead.h lwcs.h wcscat.h
fitsfile.o:	fitsfile.h fitshead.h
fitswcs.o:	fitsfile.h wcs.h fitshead.h wcslib.h
gscread.o:	fitsfile.h wcs.h wcscat.h fitshead.h wcslib.h
gsc2read.o:	fitsfile.h wcs.h wcscat.h fitshead.h wcslib.h
hget.o:		fitshead.h
hput.o:		fitshead.h
iget.o:		fitshead.h
imgetwcs.o:	fitshead.h wcs.h lwcs.h wcslib.h
imhfile.o:	fitsfile.h fitshead.h
imio.o:		fitsfile.h
imsetwcs.o:	fitshead.h wcs.h lwcs.h wcscat.h wcslib.h
imrotate.o:	fitsfile.h
lin.o:		wcslib.h
matchstar.o:	fitshead.h wcs.h lwcs.h wcslib.h wcscat.h
platefit.o:	wcs.h fitshead.h wcslib.h
platepos.o:	wcs.h fitshead.h wcslib.h
poly.o:		wcslib.h
proj.o:		wcslib.h
sdssread.o:	fitsfile.h wcs.h wcscat.h fitshead.h wcslib.h
skybotread.o:	fitsfile.h wcs.h wcscat.h fitshead.h wcslib.h
sortstar.o:	wcscat.h
sph.o:		wcslib.h
tabread.o:	fitshead.h wcs.h wcslib.h wcscat.h
tmcread.o:	fitsfile.h wcs.h wcscat.h fitshead.h wcslib.h
tnxpos.o:	wcs.h fitshead.h wcslib.h
zpxpos.o:	wcs.h fitshead.h wcslib.h
ty2read.o:	fitsfile.h wcs.h wcscat.h fitshead.h wcslib.h
uacread.o:	fitshead.h wcs.h wcscat.h wcslib.h
ubcread.o:	fitshead.h wcs.h wcscat.h wcslib.h
ucacread.o:	fitshead.h wcs.h wcscat.h wcslib.h
ujcread.o:	fitshead.h wcs.h wcscat.h wcslib.h
wcs.o:		fitshead.h wcs.h wcslib.h
wcsinit.o:	fitshead.h wcs.h wcslib.h
wcscon.o:	wcs.h fitshead.h wcslib.h
wcslib.o:	wcslib.h
wcstrig.o:	wcslib.h
webread.o:	wcscat.h
worldpos.o:	wcs.h fitshead.h wcslib.h

clean:
	rm -f *.a *.o $(SO_Name)
