# Common flags
OSTYPE = $(shell uname)
ifneq ($(findstring BSD,$(OSTYPE)),)
CC            = cc
else
CC            = gcc
endif

CP = cp

LIBS = -lc -lm

ifneq ($(findstring Darwin,$(OSTYPE)),)
SO_Name       = libcalceph.dylib
ifeq ($(CPU_TARGET),aarch64)
  CFLAGS        = -DHAVE_CONFIG_H -I. -O2 -fPIC $(arch_flags) -arch arm64 -Wno-implicit-function-declaration -mmacos-version-min=11.0
  LIBFLAGS      = -arch arm64 -Wl,-single_module -dynamiclib -mmacos-version-min=11.0
else
  CFLAGS        = -DHAVE_CONFIG_H -I. -O2 -fPIC $(arch_flags) -arch x86_64 -Wno-implicit-function-declaration -mmacos-version-min=10.14
  LIBFLAGS      = -arch x86_64 -Wl,-single_module -dynamiclib -mmacos-version-min=10.14
endif
else
SOName        = libcalceph.so.1
SO_Name       = libcalceph.so.1.1
CFLAGS        = -DHAVE_CONFIG_H -I. -O2 -fPIC 
LIBFLAGS      = -shared -Wl,-soname,$(SOName)
endif

.PHONY: all clean

SRC=$(wildcard *.c)

OBJ=$(SRC:.c=.o)

all: $(SO_Name)

$(SO_Name): calcephconfig.h $(OBJS)
	$(CC) $(CFLAGS) $(LIBFLAGS) -o $@ $(SRC) $(LIBS)

calcephconfig.h : 
	$(CP) calcephconfig.std calcephconfig.h

clean:
	rm -f calcephconfig.h *.a *.o $(SO_Name)
