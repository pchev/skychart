# Common flags
OSTYPE = $(shell uname)
ifneq ($(findstring BSD,$(OSTYPE)),)
CC            = cc
else
CC            = gcc
endif
#CFLAGS        = -O3 -ffast-math (fast-math removed for better compatibility )
CFLAGS        = -O3 -fPIC $(arch_flags)
ifneq ($(findstring Darwin,$(OSTYPE)),)
SO_Name       = libplan404.dylib
ifeq ($(CPU_TARGET),aarch64)
  CFLAGS        = -O3 -fPIC $(arch_flags) -arch arm64 -Wno-implicit-function-declaration -mmacos-version-min=11.0
  LIBFLAGS      = $(arch_flags) -arch arm64 -Wl,-single_module -dynamiclib  -lc -lm -mmacos-version-min=11.0
else
  CFLAGS        = -O3 -fPIC $(arch_flags) -arch x86_64 -Wno-implicit-function-declaration -mmacos-version-min=10.14
  LIBFLAGS      = $(arch_flags) -arch x86_64 -Wl,-single_module -dynamiclib  -lc -lm -mmacos-version-min=10.14
endif
else
SOName        = libpasplan404.so.1
SO_Name       = libpasplan404.so.1.1
LIBFLAGS      = -shared -Wl,-soname,$(SOName) -lc -lm
endif
ifneq ($(findstring W32,$(OSTYPE)),)
SO_Name       = libplan404.dll
LIBFLAGS      = -shared -Wl,-soname,$(SO_Name)  -lm
endif
ifneq ($(findstring MINGW,$(OSTYPE)),)
SO_Name       = libplan404.dll
LIBFLAGS      = -shared -Wl,-soname,$(SO_Name)  -lm
endif

.PHONY: clean

# Source files
SRC :=  plan404.c mer404.c ven404.c ear404.c mar404.c jup404.c sat404.c \
ura404.c nep404.c plu404.c gplan.c cmoon.c precess.c epsiln.c nutate.c

# Object files
OBJ_DIR = ./obj
OBJ := $(patsubst %.c,$(OBJ_DIR)/%.o,$(SRC))
LIBS = -lm

all: $(SO_Name)

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(SO_Name): $(OBJ)
	$(CC) $(CFLAGS) $(LIBFLAGS) -o $@ $(OBJ) $(LIBS)

clean:
	rm -f $(OBJ) $(SO_Name)
