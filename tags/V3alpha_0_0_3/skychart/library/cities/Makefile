# Common flags
CC            = gcc
SO_Name       = libCities.so
CFLAGS_COMMON = -Wall
CFLAGS        = -O3 -ffast-math -fomit-frame-pointer $(CFLAGS_COMMON)
CFLAGS_DEBUG  = -g $(CFLAGS_COMMON)
LIBFLAGS      = -shared -WL,-soname,$(SO_Name)
.PHONY: clean

# Source files
SRC := Cities.c

# Object files
OBJ_DIR = ./obj
OBJ := $(patsubst %.c,$(OBJ_DIR)/%.o,$(SRC))

all:
	@ make "CFLAGS=$(CFLAGS_DEBUG)" $(SO_Name)

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(SO_Name): $(OBJ)
	$(CC) $(CFLAGS) $(LIBFLAGS) -o $@ $(OBJ)

opt:
	@ make "CFLAGS=$(CFLAGS)" $(SO_Name)

clean:
	rm -f $(OBJ) $(SO_Name)
