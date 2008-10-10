# Common flags
CC            = gcc
CFLAGS        = -O3 -ffast-math
OSTYPE = $(shell uname)
ifneq ($(findstring darwin,$(OSTYPE)),)
SO_Name       = libplan404.dylib
LIBFLAGS      = -Wl,-single_module -dynamiclib  -lc -lm
else
SO_Name       = libplan404.so
LIBFLAGS      = -shared -WL,-soname,$(SO_Name) -lc -lm
endif

.PHONY: clean

# Source files
SRC :=  plan404.c mer404.c ven404.c ear404.c mar404.c jup404.c sat404.c \
ura404.c nep404.c plu404.c gplan.c cmoon.c precess.c epsiln.c nutate.c

# Object files
OBJ_DIR = ./obj
OBJ := $(patsubst %.c,$(OBJ_DIR)/%.o,$(SRC))

all: $(SO_Name)

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(SO_Name): $(OBJ)
	$(CC) $(CFLAGS) $(LIBFLAGS) -o $@ $(OBJ)

clean:
	rm -f $(OBJ) $(SO_Name)
