/*-----------------------------------------------------------------*/
/*! 
  \file util.h 
  \brief supplementary tools.

  \author  M. Gastineau 
           Astronomie et Systemes Dynamiques, IMCCE, CNRS, Observatoire de Paris. 

   Copyright, 2008, 2009, 2010, 2011, 2012,2013,2014, 2015, 2016, 2017, CNRS
   email of the author : Mickael.Gastineau@obspm.fr

  History:                                                                
    \bug M. Gastineau 25/11/10 : fix the missing  include  of stdarg.h 
         if VASPRINTF is not defined 
*/
/*-----------------------------------------------------------------*/

/*-----------------------------------------------------------------*/
/* License  of this file :
 This file is "triple-licensed", you have to choose one  of the three licenses 
 below to apply on this file.
 
    CeCILL-C
    	The CeCILL-C license is close to the GNU LGPL.
    	( http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.html )
   
 or CeCILL-B
        The CeCILL-B license is close to the BSD.
        (http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt)
  
 or CeCILL v2.1
      The CeCILL license is compatible with the GNU GPL.
      ( http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.html )
 

This library is governed by the CeCILL-C, CeCILL-B or the CeCILL license under 
French law and abiding by the rules of distribution of free software.  
You can  use, modify and/ or redistribute the software under the terms 
of the CeCILL-C,CeCILL-B or CeCILL license as circulated by CEA, CNRS and INRIA  
at the following URL "http://www.cecill.info". 

As a counterpart to the access to the source code and  rights to copy,
modify and redistribute granted by the license, users are provided only
with a limited warranty  and the software's author,  the holder of the
economic rights,  and the successive licensors  have only  limited
liability. 

In this respect, the user's attention is drawn to the risks associated
with loading,  using,  modifying and/or developing or reproducing the
software by the user in light of its specific status of free software,
that may mean  that it is complicated to manipulate,  and  that  also
therefore means  that it is reserved for developers  and  experienced
professionals having in-depth computer knowledge. Users are therefore
encouraged to load and test the software's suitability as regards their
requirements in conditions enabling the security of their systems and/or 
data to be ensured and,  more generally, to use and operate it in the 
same conditions as regards security. 

The fact that you are presently reading this means that you have had
knowledge of the CeCILL-C,CeCILL-B or CeCILL license and that you accept its terms.
*/
/*-----------------------------------------------------------------*/

#ifndef __UTIL_H__
#define __UTIL_H__

/*enable unused pragma for : clang, intel   */
#if defined(__clang__) || defined(__INTEL_COMPILER)
#ifndef HAVE_PRAGMA_UNUSED
#define HAVE_PRAGMA_UNUSED 1
#endif
#else
/*disable unknown pragma for pragma unused if not available  */
#ifndef HAVE_PRAGMA_UNUSED
#define HAVE_PRAGMA_UNUSED 0
#endif
#endif

/*disable warning for intel compilers : warning #161: unrecognized #pragma  */
#ifdef __INTEL_COMPILER
#pragma warning(disable:161)
#endif

#if HAVE_PRAGMA_UNUSED

/*disable warning for gcc compilers : unrecognized #pragma  */
#pragma GCC diagnostic ignored "-Wunknown-pragmas"

/* disable warning : warning "operands are evaluated in unspecified order" */
#pragma warning(disable:981)

#endif

/* set the unused attribute for the parameters */
#ifdef HAVE_VAR_ATTRIBUTE_UNUSED
#  define PARAMETER_UNUSED(x)  x __attribute__((__unused__))
#else
#  define PARAMETER_UNUSED(x)  x
#endif


#if defined(__cplusplus)
extern "C" {
#endif /*defined(__cplusplus)*/

/*! \def PRAGMA_IVDEP
   Define pragma(ivdep) in order to optimize for-loops
*/
#if defined(HAVE_PRAGMA_IVDEP) && !defined(__cplusplus) 
#define PRAGMA_IVDEP _Pragma("ivdep")
#else
#define PRAGMA_IVDEP 
#endif /*HAVE_PRAGMA_IVDEP*/

/*! \def F77_FUNC 
   define the name of fortran suffixes
*/
#ifndef F77_FUNC
#define F77_FUNC(x,X) x##_
#endif /*F77_FUNC*/

/*! \def F77_FUNC_
   define the name of fortran suffixes with name with underscore
*/
#ifndef F77_FUNC_
#define F77_FUNC_(x,X) x##_
#endif /*F77_FUNC*/

/*! \def FC_FUNC 
   define the name of fortran suffixes
*/
#ifndef FC_FUNC
#define FC_FUNC(x,X) x##_
#endif /*FC_FUNC*/

/*! \def FC_FUNC_
   define the name of fortran suffixes with name with underscore
*/
#ifndef FC_FUNC_
#define FC_FUNC_(x,X) x##_
#endif /*FC_FUNC_*/

/*! \def MIN(a,b)
   Return the minima of a and b
*/
#ifndef MIN
#define MIN(a,b) ((a)<(b)?(a):(b))
#endif 

/*! \def MAX(a,b)
   Return the maxima of a and b
*/
#ifndef MAX
#define MAX(a,b) ((a)>(b)?(a):(b))
#endif


/*! \def intdecl1(y,n) 
    Define for the function a 1-dimensional array of integer numbers as  y[n] 
    e.g. : intdecl1(y,n) // => y[0] to y[n-1] 
*/
#if defined(__cplusplus) 
#define intdecl1(y,n) int *y = (int *)alloca((n)*sizeof(int)); 
#else  /* __cplusplus */
#define intdecl1(y,n) int y[n]; 
#endif /* __cplusplus */

void calceph_fatalerror(const char *format, ...);
#define fatalerror calceph_fatalerror

char *strconcat(const char *s1, const char *s2);
char *strconcat3(const char *s1, const char *s2, const char *s3);
char *strconcatn(const char *s1, ...);


void *parallelstart(void (*start_routine)(void *), void * arg);
void parallelwaitforend(void *threadid);

void *parallelstart_and_return(int (*start_routine)(void *), void * arg);
int parallelwaitforend_and_return(void *threadid);


int swapint(int x);
double swapdbl(double x);
void swapintarray(int *x, int count);
void swapdblarray(double *x, size_t count);
int getmax_integer(int *array, int count);


#if defined(HAVE_STDBOOL_H) || defined(__cplusplus)
#ifndef __cplusplus
#if HAVE_STDBOOL_H
#include <stdbool.h>
#endif
#endif /*__cplusplus */
bool *boolarrayallocate(int indice1, int indice2);
bool *boolarrayduplicate(int indice1, int indice2, const bool *array);
void boolarrayfree(bool *array,int indice1);
#endif

char* create_tempfile(FILE** p_pFichier, const char *p_szMode);
void create_emptyfile(const char *filename);
int trp_fileexists(const char * filename);
int trp_fileisnewer(const char * filename1, const char * filename2);
int copyfileptr(FILE* pfichierdst, const char*pfichiersrc);
int copyfilename(const char*pfichierdst, const char*pfichiersrc);
FILE *file_open(const char *filename, const char *mode);
void file_write(FILE *file, const void *data, size_t size);
void file_read(FILE *file, void *data, size_t size);



/*! \def STRDUP_NULL
  if (str==NULL) return NULL else return strdup(str)
*/
#ifndef STRDUP_NULL
#define STRDUP_NULL(str) (str ? strdup(str) : NULL)
#endif




/*! \def DEBUGPRINT
  if DEBUGLEVEL is defined, then DEBUGPRINT is equal to debugprint else it's empty
*/
#ifdef __cplusplus
#ifdef DEBUGLEVEL
void debugprint(int level, const char *format, ...);
#define DEBUGPRINT debugprint
#else
#define DEBUGPRINT 
#endif
#else
#ifdef DEBUGLEVEL
void debugprint(int level, const char *format, ...);
#define DEBUGPRINT debugprint
#else
#define DEBUGPRINT(level, ...)
#endif
#endif /*__cplusplus*/


/*! \def DECLARE_VARUTIL
  if DECLARE_GLOBALVARUTIL isn't defined, then global variable is declared with extern storage.
*/
/* define extern if necessary global variables */
#ifdef DECLARE_GLOBALVARUTIL
#define DECLARE_VARUTIL(type, x) type x;
#else /*DECLARE_GLOBALVARUTIL*/
#define  DECLARE_VARUTIL(type, x) extern type x;
#endif/*DECLARE_GLOBALVARUTIL*/

/* list of global variables */
DECLARE_VARUTIL(int,debug_level)

#if !defined(HAVE_RINT)
double rint(double x);
#endif
#if !defined(HAVE_VASPRINTF)
#ifdef STDC_HEADERS
#include <stdarg.h>
#endif
int vasprintf(char **ret, const char *format, va_list args);
#endif

#if defined(__cplusplus)
}
#endif /*defined(__cplusplus)*/

#endif /*__UTIL_H__*/

