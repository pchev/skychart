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
OSARCH = $(shell uname -m)
ifneq ($(findstring arm64,$(OSARCH)),)
LDFLAGS = $(arch_flags) -Wl,-single_module -dynamiclib  -lc -mmacos-version-min=11.0
CPPFLAGS = -I. -O3 -fPIC $(arch_flags) -mmacos-version-min=11.0
else
LDFLAGS = $(arch_flags) -Wl,-single_module -dynamiclib  -lc -mmacosx-version-min=10.10
CPPFLAGS = -I. -O3 -fPIC $(arch_flags) -mmacosx-version-min=10.10
endif
else
SO_Name = libgetdss.so
LDFLAGS= -shared -lc -Wl,-soname,$(SO_Name) $(arch_flags)
endif

OBJS = getdss_lib.o dss.o extr_fit.o getpiece.o \
	hdcmprss.o bitinput.o decode.o dodecode.o hinv.o \
	platelst.o qtreedec.o
LIBS = -lm -lstdc++

all: $(SO_Name)

$(SO_Name):  $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
	
clean:
	rm -f $(OBJS) $(SO_Name)
