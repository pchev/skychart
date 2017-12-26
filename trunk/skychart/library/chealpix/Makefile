##############################################################################
#
# Makefile
#
# This is a makefile for use with a 'c' version of the healpix toolkit. 
#
# Usage:
#
# To build the static library, type
#
# % make [static] [CC=<cc>] [OPT=<opt>] [AR=<ar>] [CFITSIO_INCDIR=<cfitsio_incdir>] [CFITSIO_LIBDIR=<cfitsio_libdir>]
#
# where
#  CC     is the C compiler you want to use (default: gcc)
#  OPT    compilation option
#  WITHOUT_CFITSIO=1: cfitsio integration will not be built
#  CFITSIO_INCDIR is where the header files for the 'cfitsio' library is kept
#  CFITSIO_LIBDIR is where the 'cfitsio' library archive is kept
#  AR is the command to create the archive with its index table
#      default = ar -rsv
#
# For example:
#  % make CFITSIO_INCDIR=/scr/kmg/include
#
# To build the shared(dynamical) library, type
#
# % make shared [CC=<cc>] [OPT=<opt>] [AR=<ar>] [CFITSIO_INCDIR=<cfitsio_incdir>] [CFITSIO_LIBDIR=<cfitsio_libdir>]
#
# For example:
#  % make shared CFITSIO_INCDIR=/scr/kmg/include
#
# To install the files, type
#
# % make install [INCDIR=<incdir>] [LIBDIR=<libdir>] [RANLIB=<ranlib>] 
#
# For example:
#  % make install LIBDIR=/home/kmg/lib INCDIR=/home/kmg/include RANLIB="ar -ts"
#
# where
#  INCDIR is the directory in which you want to install the header files
#  LIBDIR is the directory in which you want to install the library files
#  RANLIB is the 'ranlib' command to be used for the static library archive.
#         It defaults to 'ranlib', but if your
#         system does not have or need this, you should use something like
#         RANLIB="ar -ts" 
#
# You could also build the package by directly editing the Makefile
#  (not recommended unless you're going to do it a lot and don't think
#   you'll be keeping up with changes in the distribution).
# To build the library:
#  1) Edit the 'CC', 'LIBDIR' and 'INCDIR' lines in 'Makefile' to reflect your
#     system.
#  2) Type 'make'
#
# To install the library and header file:
#  1) Type 'make install'
#
##############################################################################
# You should not have to edit below this line ################################
#
#
OPT =
AR = ar -rsv
WITHOUT_CFITSIO = 0
WITH_HIGHRES = 0
FLAGS = $(OPT)

ifeq ($(WITHOUT_CFITSIO), 0)
  FLAGS += -DENABLE_FITSIO 
  ifdef CFITSIO_INCDIR
    FLAGS += -I$(CFITSIO_INCDIR)
  endif
  ifdef CFITSIO_LIBDIR
    CFITSIO_LIBS += -L$(CFITSIO_LIBDIR) 
  endif
  CFITSIO_LIBS += -lcfitsio
endif

PIC = -fPIC
#
SHLIB_LD =      $(CC) $(FLAGS) $(PIC) -shared
SHLIB_SUFFIX =  .so
#
DYLIB_LD =      $(CC) $(FLAGS) $(PIC) -dynamiclib
DYLIB_SUFFIX =  .dylib

# The sources in the package
MODS = chealpix

# static objects
OBJS = ${MODS:%=%.s.o}

# non-static objects
OBJD = ${MODS:%=%.d.o}


default: static
#
# Make the static library itself
static: libchealpix.a #tests

libchealpix.a : $(OBJS)
	$(AR) $@ $(OBJS)
#
#
# Make the shared library itself
shared: libchealpix$(SHLIB_SUFFIX) #tests

libchealpix$(SHLIB_SUFFIX) : $(OBJD)
	$(SHLIB_LD) -o $@ $(OBJD)

# Make the dynamic (Mac) library itself
dynamic: libchealpix$(DYLIB_SUFFIX) #tests

libchealpix$(DYLIB_SUFFIX) : $(OBJD)
	$(DYLIB_LD) -o $@ $(OBJD) $(CFITSIO_LIBS)
#
# Install the static library (and the dynamic one)
install :  chealpix.h
	@if [ -f libchealpix.a ]; then \
		cp libchealpix.a $(LIBDIR)/. ; \
	fi; \
	if [ -f libchealpix$(SHLIB_SUFFIX) ]; then \
		cp libchealpix$(SHLIB_SUFFIX) $(LIBDIR)/. ; \
	fi; \
	if [ -f libchealpix$(DYLIB_SUFFIX) ]; then \
		cp libchealpix$(DYLIB_SUFFIX) $(LIBDIR)/. ; \
	fi; \
	cp chealpix.h $(INCDIR)/.

# Make the programs to test the package.

test_chealpix : test_chealpix.c static
	$(CC) $(FLAGS) -c -o test_chealpix.o $<
	$(CC) $(FLAGS) -o $@ test_chealpix.o -L. -lchealpix $(CFITSIO_LIBS) -lm

tests : test_chealpix
	./test_chealpix

#
# General compilation rules
# static objects
%.s.o : %.c
	$(CC) $(FLAGS)        -c -o $@ $< 

# non-static objects
%.d.o : %.c
	$(CC) $(FLAGS) $(PIC) -c -o $@ $< 

# Clean: remove intermediate files
clean :
	$(RM) *~ *.o core  \
		test_chealpix.dat test_chealpix.out test_output.fits test_map.fits libchealpix.*  \
		test_chealpix

# Tidy: remove library and include files
tidy : clean
	$(RM) $(LIBDIR)/libchealpix.* $(INCDIR)/chealpix.h
	$(RM) $(LIBDIR)/chealpix.pc

# Distclean: remove directories
distclean: tidy
	$(RM) -r $(LIBDIR) $(INCDIR)
