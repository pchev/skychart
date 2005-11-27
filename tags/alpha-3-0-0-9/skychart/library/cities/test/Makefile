# Common flags
CC            = gcc
ExeName       = Cities_test
CFLAGS_COMMON = -Wall
CFLAGS        = -O3 -ffast-math -fomit-frame-pointer $(CFLAGS_COMMON)
CFLAGS_DEBUG  = -g $(CFLAGS_COMMON)
LIBS          = -lCities
.PHONY: clean

# set main file:
SRC := Cities_test.c

# Object files
OBJ_DIR = ./obj
OBJ := $(patsubst %.c,$(OBJ_DIR)/%.o,$(SRC))

all:
	@ make "CFLAGS=$(CFLAGS_DEBUG)" $(ExeName)

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(ExeName): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) $(LIBS)

opt:
	@ make "CFLAGS=$(CFLAGS)" $(ExeName)

clean:
	rm -f $(OBJ) $(ExeName)
