# Common flags
OSTYPE = $(shell uname)
ifneq ($(findstring BSD,$(OSTYPE)),)
CC            = cc
else
CC            = gcc
endif

AR = ar
RANLIB = ranlib

ifneq ($(findstring Darwin,$(OSTYPE)),)
  CFLAGS        = -c -ansi -O2 -fPIC -DNON_UNIX_STDIO $(arch_flags) -Wno-implicit-function-declaration
else  
  CFLAGS        = -c -ansi -O2 -fPIC -DNON_UNIX_STDIO $(arch_flags)
endif

LIBNAME = libcspice.a

.PHONY: clean

# Source files
SRC=$(wildcard *.c)

OBJ=$(SRC:.c=.o)

all: $(OBJ)
	$(AR) cr $(LIBNAME) *.o
	$(RANLIB) $(LIBNAME)

clean:
	rm -f $(OBJ) $(LIBNAME)
