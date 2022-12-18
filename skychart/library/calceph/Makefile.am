#/*-----------------------------------------------------------------*/
#/*! 
#  \file Makefile.am
#  \brief Makefile for automake
#  \author  M. Gastineau 
#           Astronomie et Systemes Dynamiques, IMCCE, CNRS, Observatoire de Paris. 
#
#   Copyright, 2008-2022, CNRS
#   email of the author : Mickael.Gastineau@obspm.fr
#  
#*/
#/*-----------------------------------------------------------------*/
#
#/*-----------------------------------------------------------------*/
#/* License  of this file :
#  This file is "triple-licensed", you have to choose one  of the three licenses 
#  below to apply on this file.
#  
#     CeCILL-C
#     	The CeCILL-C license is close to the GNU LGPL.
#     	( http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.html )
#   
#  or CeCILL-B
#        The CeCILL-B license is close to the BSD.
#        (http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt)
#  
#  or CeCILL v2.1
#       The CeCILL license is compatible with the GNU GPL.
#       ( http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.html )
#  
# 
# This library is governed by the CeCILL-C, CeCILL-B or the CeCILL license under 
# French law and abiding by the rules of distribution of free software.  
# You can  use, modify and/ or redistribute the software under the terms 
# of the CeCILL-C,CeCILL-B or CeCILL license as circulated by CEA, CNRS and INRIA  
# at the following URL "http://www.cecill.info". 
#
# As a counterpart to the access to the source code and  rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty  and the software's author,  the holder of the
# economic rights,  and the successive licensors  have only  limited
# liability. 
#
# In this respect, the user's attention is drawn to the risks associated
# with loading,  using,  modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean  that it is complicated to manipulate,  and  that  also
# therefore means  that it is reserved for developers  and  experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or 
# data to be ensured and,  more generally, to use and operate it in the 
# same conditions as regards security. 
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL-C,CeCILL-B or CeCILL license and that you accept its terms.
# */
# /*-----------------------------------------------------------------*/

## Makefile.am -- Process this file with automake to produce Makefile.in
#
# skeleton for Makefile
#

lib_LTLIBRARIES = libcalceph.la
noinst_LTLIBRARIES = libcalcephnoinst.la

noinst_PROGRAMS = $(EXTRAFORTRAN2003FILES)

EXTRA_PROGRAMS = f2003main

###################################################################
# module fortran 2003 : calceph 
###################################################################

f2003main_SOURCES = f2003calceph.f f2003main.f
AM_FFLAGS =  $(AM_FCFLAGS) $(FCFLAGS)
F77 = $(FC)

###################################################################
# library libcalceph.la 
###################################################################

libcalceph_la_SOURCES = calceph.c util.c calcephio.c interfaces_C_F90.c calcephast.c calcephspkio.c \
 calcephinpopio.c calcephspice.c calcephtxtpckio.c  calcephbinpckio.c calcephtxtfkio.c  calcephtxtmkio.c \
 calcephlink.c calcephspkseg1.c calcephspkseg2.c calcephspkseg12.c calcephspkseg13.c calcephstatetype.c \
 calcephversion.c calcephchebyshev.c calcephpam.c calcephinpoptime.c calcephspicetime.c calcephtime.c \
 calcephinpoppositionrecord.c calcephspicepositionrecord.c calcephpositionrecord.c \
  calcephinpoporientrecord.c calcephspiceorientrecord.c calcephorientrecord.c \
  calcephinpopfileversion.c calcephspicefileversion.c calcephfileversion.c \
  calcephspkseg17.c  calcephspkseg21.c  calcephspkinterpolhermite.c calcephspkinterpollagrange.c \
  calcephspkseg5.c calcephspkseg18.c calcephtxtpckorient.c

 
libcalceph_la_LDFLAGS = @CALCEPHWIN32_LDFLAGS@ -version-info 13:1:12 

noinst_HEADERS= calcephinternal.h real.h  util.h calcephspice.h calcephinpop.h calcephstatetype.h calcephdebug.h \
 calcephchebyshev.h

include_HEADERS = calceph.h f90calceph.h

CLEANFILES = calceph.$(ax_cv_f90_modext)


EXTRA_DIST = Makefile.vc Makefile.mingw calcephconfig.vc f2003calceph.f

###################################################################
# installation fortran files
###################################################################

install-data-hook: $(EXTRAFORTRAN2003INSTALL)

$(DESTDIR)$(includedir)/calceph.$(ax_cv_f90_modext) : calceph.$(ax_cv_f90_modext) 
	$(INSTALL_DATA) $< $@

###################################################################
# uninstallation fortran files
###################################################################

uninstall-hook: $(EXTRAFORTRAN2003UNINSTALL)

uninstallf90mod  :
	rm -f $(DESTDIR)$(includedir)/calceph.$(ax_cv_f90_modext)


###################################################################
# avoid to install documentation
###################################################################
installnodoc : install

###################################################################
# not installable version of calceph (useful for the python library) 
###################################################################
libcalcephnoinst_la_SOURCES = $(libcalceph_la_SOURCES)


###################################################################
# disable parallel compilation
###################################################################
.NOTPARALLEL:
