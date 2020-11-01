# Common flags
OSTYPE = $(shell uname)
ifneq ($(findstring BSD,$(OSTYPE)),)
CC            = cc
else
CC            = gcc
endif

CP = cp


ifneq ($(findstring Darwin,$(OSTYPE)),)
SO_Name       = libcalceph.dylib
CFLAGS        = -DHAVE_CONFIG_H -I. -O2 -fPIC $(arch_flags) -Wno-implicit-function-declaration
LIBFLAGS      = -Wl,-single_module -dynamiclib  -lc -lm -mmacosx-version-min=10.6
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
