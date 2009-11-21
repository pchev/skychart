# Common flags
CC            = gcc
CFLAGS        = -O3 -fPIC
OSTYPE = $(shell uname)
ifneq ($(findstring Darwin,$(OSTYPE)),)
SO_Name       = libsqlite3.dylib
LIBFLAGS      = -Wl,-single_module -dynamiclib  -lc -lm
else
SO_Name       = libsqlite3.so
LIBFLAGS      = -shared -WL,-soname,$(SO_Name) -lc -lm
endif
ifneq ($(findstring W32,$(OSTYPE)),)
SO_Name       = sqlite3.dll
LIBFLAGS      = -shared -WL,-soname,$(SO_Name)  -lm
endif
ifneq ($(findstring MINGW,$(OSTYPE)),)
SO_Name       = sqlite3.dll
LIBFLAGS      = -shared -WL,-soname,$(SO_Name)  -lm
endif

.PHONY: clean

# Source files
SRC :=  sqlite3.c

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
                 