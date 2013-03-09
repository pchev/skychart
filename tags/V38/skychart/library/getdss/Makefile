CPPFLAGS=-I. -DUNIX -D_CONSOLE -fPIC $(arch_flags)
#### For Suns and similar wrong-endian computers, add -DWRONG_WAY_BYTE_ORDER.
CC            = gcc
OSTYPE = $(shell uname)
ifneq ($(findstring Darwin,$(OSTYPE)),)
SO_Name = libgetdss.dylib
LDFLAGS=  -Wl,-single_module -dynamiclib  -lc -lm -lstdc++
else
SO_Name = libgetdss.so
LDFLAGS= -shared -Wl,-soname,$(SO_Name) $(arch_flags)
endif
ifneq ($(findstring W32,$(OSTYPE)),)
SO_Name = libgetdss.dll
LDFLAGS= -shared -Wl,-soname,$(SO_Name)
endif
ifneq ($(findstring MINGW,$(OSTYPE)),)
SO_Name = libgetdss.dll
LDFLAGS= -shared -Wl,-soname,$(SO_Name)
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
