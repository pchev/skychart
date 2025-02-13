CPPFLAGS=-I. -O3 -fPIC $(arch_flags)
#### For Suns and similar wrong-endian computers, add -DWRONG_WAY_BYTE_ORDER.
OSTYPE = $(shell uname)
ifneq ($(findstring BSD,$(OSTYPE)),)
CC            = cc
else
CC            = gcc
endif
ifneq ($(findstring Darwin,$(OSTYPE)),)
  SO_Name = libgetdss.dylib
  ifeq ($(CPU_TARGET),aarch64)
    LDFLAGS = $(arch_flags) -arch arm64 -Wl,-single_module -dynamiclib  -lc -mmacos-version-min=11.0
    CPPFLAGS = -I. -O3 -fPIC $(arch_flags) -arch arm64 -mmacos-version-min=11.0
  else
    LDFLAGS = $(arch_flags) -arch x86_64 -Wl,-single_module -dynamiclib  -lc -mmacos-version-min=10.14
    CPPFLAGS = -I. -O3 -fPIC $(arch_flags) -arch x86_64 -mmacos-version-min=10.14
  endif
else
  ### Linux
  SO_Name = libgetdss.so
  LDFLAGS= -shared -lc -Wl,-soname,$(SO_Name) $(arch_flags)    
  ifeq ($(CPU_TARGET),aarch64)
    CC = aarch64-linux-gnu-g++
  endif
  ifeq ($(CPU_TARGET),arm)
    CC = arm-linux-gnueabihf-g++
  endif
endif

.cpp.o:
	$(CC) $(CPPFLAGS) -c $<

OBJS = getdss_lib.o dss.o extr_fit.o getpiece.o \
	hdcmprss.o bitinput.o decode.o dodecode.o hinv.o \
	platelst.o qtreedec.o
LIBS = -lm -lstdc++

all: $(SO_Name)

$(SO_Name):  $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
	
clean:
	rm -f $(OBJS) $(SO_Name)
