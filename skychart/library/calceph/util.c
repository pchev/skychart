/*-----------------------------------------------------------------*/
/*! 
  \file util.c 
  \brief supplementary tools.
  
   Implemenation of :
   - abort the program with message
   - string concatenation 
   - display debug information
   - multi-thread start job and wait job
   - swap byte order

  \author  M. Gastineau 
           Astronomie et Systemes Dynamiques, IMCCE, CNRS, Observatoire de Paris. 

   Copyright, 2008-2019, CNRS
   email of the author : Mickael.Gastineau@obspm.fr
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

/*! \def DECLARE_GLOBALVARUTIL
  global variable is declared in this file.
*/
#define DECLARE_GLOBALVARUTIL
#if HAVE_CONFIG_H
#include "calcephconfig.h"
#endif

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#ifdef HAVE_PTHREAD
#include <pthread.h>
#ifdef HAVE_SYS_RESOURCE_H
#include <sys/resource.h>
#endif/*! \def utilexit 
   macro to call pthread_exit or exit function depending on HAVE_PTHREAD and HAVE_MPI
*/
#define utilexit(x) pthread_exit((void*)x)
#else
/*! \def utilexit 
   macro to call pthread_exit or exit function depending on HAVE_PTHREAD and HAVE_MPI
*/
#define utilexit(x) exit(x)
#endif                          /*HAVE_PTHREAD */
#include <errno.h>
#ifndef __cplusplus
#if HAVE_STDBOOL_H
#include <stdbool.h>
#endif
#endif /*__cplusplus */
#if defined(HAVE_MATHIMF_H)
#include <mathimf.h>
#elif defined(HAVE_MATH_H)
#include <math.h>
#endif
#if defined(HAVE_SYS_TYPES_H)
#include <sys/types.h>
#endif
#if defined(HAVE_SYS_STAT_H)
#include <sys/stat.h>
#endif
#if defined(HAVE_UNISTD_H)
#include <unistd.h>
#endif
#if defined(HAVE_TIME_H)
#include <time.h>
#endif
#include "util.h"
#include "real.h"
#include "calceph.h"
#include "calcephinternal.h"

#if HAVE_MPI
#include "mpi.h"
#undef utilexit
/*! \def utilexit 
   macro to call MPI_abort or exit function depending on HAVE_PTHREAD and HAVE_MPI
*/
#define utilexit(x) { printf ("call MPI_abort on utilexit\n"); MPI_Abort(MPI_COMM_WORLD, x); }
#endif                          /*HAVE_MPI */

#ifdef HAVE_PTHREAD
/*! structure for parallel start function */
struct stparexecfunc
{
    void (*pfunc) (void *);     /*!< pointer to function  */
    void *args;                 /*!< pointer to arguments */
};

static void *parallelexecfunction(void *arg);

/*! structure for parallel start function which return a value */
struct stparexecfunc_and_return
{
    int (*pfunc) (void *);      /*!< pointer to function  */
    void *args;                 /*!< pointer to arguments */
};

static void *parallelexecfunction_and_return(void *arg);
#endif                          /*HAVE_PTHREAD */

/*!
   Concatenation of 2 strings.
   Allocate memory for the new string.
   e.g. : s3=strconcat("toto","titi");
   @param s1 (in) 1st string
   @param s2 (in) 2nd string
*/
char *strconcat(const char *s1, const char *s2)
{
    size_t len, len1;
    char *res;

    /* allocate memory for the new string */
    len1 = strlen(s1);
    len = len1 + strlen(s2) + 1;
    res = (char *) malloc(len * sizeof(char));
    if (res == NULL)
    {
        fatalerror("Can't allocate memory for %lu characters.\n", (unsigned long) len);
    }
    /* copy the 2 strings */
    strcpy(res, s1);
    strcpy(res + len1, s2);
    return res;
}

/*!
   Concatenation of 3 strings.
   Allocate memory for the new string.
   e.g. : s4=strconcat("toto","titi","tutu");
   @param s1 (in) 1st string
   @param s2 (in) 2nd string
   @param s3 (in) 3rd string
*/
char *strconcat3(const char *s1, const char *s2, const char *s3)
{
    size_t len, len1, len2;
    char *res;

    /* allocate memory for the new string */
    len1 = strlen(s1);
    len2 = len1 + strlen(s2);
    len = len2 + strlen(s3) + 1;
    res = (char *) malloc(len * sizeof(char));
    if (res == NULL)
    {
        fatalerror("Can't allocate memory for %lu characters.\n", (unsigned long) len);
    }
    /* copy the 2 strings */
    strcpy(res, s1);
    strcpy(res + len1, s2);
    strcpy(res + len2, s3);
    return res;
}

/*------------------------------------------------------------------*/
/*!
   Concatenation of n strings.
   Allocate memory for the new string. Last string must be NULL
   e.g. : s4=strconcatn("toto","titi","tutu", NULL);
   @param s (in)  string
*/
/*------------------------------------------------------------------*/
char *strconcatn(const char *s, ...)
{
    size_t len = 0;
    char *res;
    const char *sn;
    va_list args;

    /* compute memory for the new string */
    len = strlen(s) + 1;
    va_start(args, s);
    while ((sn = va_arg(args, const char *)) != NULL)
    {
        len += strlen(sn);
    }
    va_end(args);

    /* allocate memory for the new string */
    res = (char *) malloc(len * sizeof(char));
    if (res == NULL)
    {
        fatalerror("Can't allocate memory for %lu characters.\n", (unsigned long) len);
    }

    /* copy the 2 strings */
    strcpy(res, s);
    va_start(args, s);
    while ((sn = va_arg(args, const char *)) != NULL)
    {
        strcat(res, sn);
    }
    va_end(args);
    return res;
}

/*!
 Create a new thread and execute the function start_routine with arguments arg
 The thread exits with the return value 0.
 Returns as void * (not pthread_t) the id of the thread
 @param start_routine (in) function to be executed 
 @param arg (in) give arg to the function start_routine
*/
void *parallelstart(void (*start_routine) (void *), void *arg)
{
#ifdef HAVE_PTHREAD
    struct stparexecfunc *ptarg;
    pthread_attr_t pinit;
    pthread_t *threadid;
    size_t defaultstacksize;
#ifdef HAVE_SYS_RESOURCE_H
    struct rlimit curlimit;
#endif

    threadid = (pthread_t *) malloc(sizeof(pthread_t));
    if (threadid == NULL)
        fatalerror("Can't allocate memory for thread id.\n");

    pthread_attr_init(&pinit);
    pthread_attr_setdetachstate(&pinit, PTHREAD_CREATE_JOINABLE);
#ifdef HAVE_SYS_RESOURCE_H
    if (getrlimit(RLIMIT_STACK, &curlimit) == 0)
    {
        curlimit.rlim_cur = curlimit.rlim_max;
        setrlimit(RLIMIT_STACK, &curlimit);
    }
    if (pthread_attr_getstacksize(&pinit, &defaultstacksize) == 0)
    {
        printf("default stack size= %zu bytes\n", defaultstacksize);
    }
    else
        defaultstacksize = 1024 * 1024;

    if (pthread_attr_setstacksize(&pinit, 5 * defaultstacksize) != 0)
    {
        fatalerror("pthread_attr_setstacksize : failed! \n");
    }
#endif

    /* allocate memory that will be freed by parallelexecfunction */
    ptarg = (struct stparexecfunc *) malloc(sizeof(struct stparexecfunc));
    if (ptarg == NULL)
    {
        fatalerror("Can't allocate memory for %lu bytes\n", (unsigned long) sizeof(struct stparexecfunc));
    }
    ptarg->pfunc = start_routine;
    ptarg->args = arg;

    /*start the thread */
    if (pthread_create(threadid, &pinit, &parallelexecfunction, ptarg) != 0)
    {
        fatalerror("Can't create a thread \n System error: '%s'\n", strerror(errno));
    }
    pthread_attr_destroy(&pinit);
    return threadid;

#else                           /*HAVE_PTHREAD */

    start_routine(arg);
    return NULL;

#endif                          /*HAVE_PTHREAD */
}

#ifdef HAVE_PTHREAD
/*---------------------------------------------------------------------------*/
/*!
 Function called by parallelstart
 Delete arg and exit the thread with status 0 
 @param arg (in) give arg to the function start_routine
*/
/*---------------------------------------------------------------------------*/
static void *parallelexecfunction(void *arg)
{
    struct stparexecfunc *ptarg = (struct stparexecfunc *) arg;

    ptarg->pfunc(ptarg->args);
    free(ptarg);
    utilexit(0);
    return NULL;
}
#endif                          /*HAVE_PTHREAD */

/*---------------------------------------------------------------------------*/
/*!
 Wait for the end of the job.
 If the job returns an error, the function calls fatalerror.
 @param threadid (in) thread id (return value of parallelstart)
*/
/*---------------------------------------------------------------------------*/
void parallelwaitforend(void *PARAMETER_UNUSED(threadid))
{
#ifdef HAVE_PTHREAD
    int rc, thread_return;

    rc = pthread_join(*(pthread_t *) threadid, (void **) &thread_return);
    if (rc != 0 || thread_return != 0)
    {
        fatalerror("An internal job has return with error.\threadid=%p nrc=%d thread_return=%d.\n",
                   threadid, rc, thread_return);
    }
    free(threadid);
#else
#if HAVE_PRAGMA_UNUSED
#pragma unused(threadid)
#endif
#endif                          /*HAVE_PTHREAD */
}

/*---------------------------------------------------------------------------*/
/*!
 Create a new thread and execute the function start_routine with arguments arg
 The thread exits with the return value of start_routine.
 Returns as void * (not pthread_t) the id of the thread
 @param start_routine (in) function to be executed 
 @param arg (in) give arg to the function start_routine
*/
/*---------------------------------------------------------------------------*/
void *parallelstart_and_return(int (*start_routine) (void *), void *arg)
{
#ifdef HAVE_PTHREAD
    struct stparexecfunc_and_return *ptarg;
    pthread_attr_t pinit;
    pthread_t *threadid;
    size_t defaultstacksize;
#ifdef HAVE_SYS_RESOURCE_H
    struct rlimit curlimit;
#endif

    threadid = (pthread_t *) malloc(sizeof(pthread_t));
    if (threadid == NULL)
        fatalerror("Can't allocate memory for thread id.\n");

    pthread_attr_init(&pinit);
    pthread_attr_setdetachstate(&pinit, PTHREAD_CREATE_JOINABLE);
#ifdef HAVE_SYS_RESOURCE_H
    if (getrlimit(RLIMIT_STACK, &curlimit) == 0)
    {
        curlimit.rlim_cur = curlimit.rlim_max;
        setrlimit(RLIMIT_STACK, &curlimit);
    }
    if (pthread_attr_getstacksize(&pinit, &defaultstacksize) == 0)
    {
        printf("default stack size= %zu bytes\n", defaultstacksize);
    }
    else
        defaultstacksize = 1024 * 1024;

    if (pthread_attr_setstacksize(&pinit, 5 * defaultstacksize) != 0)
    {
        fatalerror("pthread_attr_setstacksize : failed! \n");
    }
#endif
    /* allocate memory that will be freed by parallelexecfunction */
    ptarg = (struct stparexecfunc_and_return *) malloc(sizeof(struct stparexecfunc_and_return));
    if (ptarg == NULL)
    {
        fatalerror("Can't allocate memory for %lu bytes\n", (unsigned long) sizeof(struct stparexecfunc_and_return));
    }
    ptarg->pfunc = start_routine;
    ptarg->args = arg;

    /*start the thread */
    if (pthread_create(threadid, &pinit, &parallelexecfunction_and_return, ptarg) != 0)
    {
        fatalerror("Can't create a thread \n System error: '%s'\n", strerror(errno));
    }
    pthread_attr_destroy(&pinit);
    return threadid;

#else                           /*HAVE_PTHREAD */

    start_routine(arg);
    return NULL;

#endif                          /*HAVE_PTHREAD */
}

#ifdef HAVE_PTHREAD
/*---------------------------------------------------------------------------*/
/*!
 Function called by parallelstart
 Delete arg and exit the thread with status which is the return value of pfunc
 @param arg (in) give arg to the function start_routine
*/
/*---------------------------------------------------------------------------*/
static void *parallelexecfunction_and_return(void *arg)
{
    struct stparexecfunc_and_return *ptarg = (struct stparexecfunc_and_return *) arg;
    /*int res =*/ (void) ptarg->pfunc(ptarg->args);

    free(ptarg);
    /*utilexit(res);*/
    return NULL;
}
#endif                          /*HAVE_PTHREAD */

/*---------------------------------------------------------------------------*/
/*!
 Wait for the end of the job and returns the return value.
 If pthread_join returns an error, the function calls fatalerror.
 @param threadid (in) thread id (return value of parallelstart)
*/
/*---------------------------------------------------------------------------*/
int parallelwaitforend_and_return(void *PARAMETER_UNUSED(threadid))
{
    int thread_return = 0;

#ifdef HAVE_PTHREAD
    int rc;

    rc = pthread_join(*(pthread_t *) threadid, (void **) &thread_return);
    if (rc != 0)
    {
        fatalerror("An internal job has return with error.\threadid=%p nrc=%d thread_return=%d.\n",
                   threadid, rc, thread_return);
    }
    free(threadid);
#else
#if HAVE_PRAGMA_UNUSED
#pragma unused(threadid)
#endif
#endif                          /*HAVE_PTHREAD */
    return thread_return;
}

#ifdef DEBUGLEVEL
/*!
  Structure to extract format in a string
*/
struct write_format
{
    char *nom;                  /*<! string */
    struct write_format *suivant;   /*<! next element */
};

static struct write_format *extract_format(const char *p_pszFormat);

/*!
 fonction d'extraction du format a partir d'une chaine.          
 Chaque element de la liste commence par un % excepte le premier 
 qui peut etre vide.                                             
 le contenu de la liste doit etre vide ainsi que son contenu.   
 @param p_pszFormat (in) string to be processed
*/
static struct write_format *extract_format(const char *p_pszFormat)
{
    struct write_format *pListHead = NULL, *pListTemp = NULL;
    char *pszNextPourCent = NULL;   /*position du prochain % */
    const char *pszStartFindPourCent = p_pszFormat;
    const char *pszStartCopyPourCent = p_pszFormat;

    while (pszStartFindPourCent != NULL)
    {
        pszNextPourCent = strchr(pszStartFindPourCent, '%');
        if (pszNextPourCent == NULL)
        {
            /*ajouter un nouvel element avec toute la chaine pszStartFindPourCent */
            if (pListHead == NULL)
            {
                pListHead = (struct write_format *) malloc(sizeof(struct write_format));
                pListTemp = pListHead;
            }
            else
            {
                pListTemp->suivant = (struct write_format *) malloc(sizeof(struct write_format));
                pListTemp = pListTemp->suivant;
            }
            if (pListTemp == NULL)
                fatalerror("Can't allocate memory for format (extract_format)\n");
            pListTemp->suivant = NULL;
            pListTemp->nom = STRDUP_NULL(pszStartCopyPourCent);
            pszStartFindPourCent = pszNextPourCent;
        }
        /*on a trouve un  '%' */
        else
        {
            /*verifier que le suivant n'est pas un '%' */
            if (*(pszNextPourCent + 1) == '%')
            {
                pszStartCopyPourCent = pszStartFindPourCent;
                pszStartFindPourCent = pszNextPourCent + 2;
                /*et refaire une recherche */
            }
            else
            {
                if (pListHead == NULL)
                {
                    pListHead = (struct write_format *) malloc(sizeof(struct write_format));
                    pListTemp = pListHead;
                }
                else
                {
                    pListTemp->suivant = (struct write_format *) malloc(sizeof(struct write_format));
                    pListTemp = pListTemp->suivant;
                }
                pListTemp->suivant = NULL;
                /* si le premier caractere du format est un %, creer un element vide */
                if (p_pszFormat == pszNextPourCent)
                {
                    pListTemp->nom = strdup("");
                }
                /*sinon creer un element jusqu'au caractere precedent le % */
                else
                {
                    pListTemp->nom = (char *) malloc(sizeof(char) * (pszNextPourCent - pszStartCopyPourCent + 1));
                    if (pListTemp->nom == NULL)
                        fatalerror("Can't allocate memory for duplicate string\n");
                    strncpy(pListTemp->nom, pszStartCopyPourCent, pszNextPourCent - pszStartCopyPourCent);
                    *(pListTemp->nom + (pszNextPourCent - pszStartCopyPourCent)) = '\0';
                }
                pszStartCopyPourCent = pszNextPourCent;
                pszStartFindPourCent = pszNextPourCent + 1;
            }
        }
    }
    /*dans chaque element, recherche des \\\n, \\\r,\\\t et \\\\ */
    for (pListTemp = pListHead; pListTemp != NULL; pListTemp = pListTemp->suivant)
    {
        pszStartCopyPourCent = pListTemp->nom;

        while (pszStartCopyPourCent != NULL)
        {
            pszNextPourCent = strchr(pszStartCopyPourCent, '\\');
            if (pszNextPourCent != NULL)
            {
                bool backreco = true;
                size_t iLen;

                switch (*(pszNextPourCent + 1))
                {
                    case '\0':
                        *pszNextPourCent = '\0';
                        break;
                    case 'n':
                        *pszNextPourCent = '\n';
                        break;
                    case 'r':
                        *pszNextPourCent = '\r';
                        break;
                    case 't':
                        *pszNextPourCent = '\t';
                        break;
                    case '\\':
                        *pszNextPourCent = '\\';
                        break;
                    default:
                        backreco = false;
                        pszStartCopyPourCent = pszNextPourCent + 2;
                        break;
                }
                if (backreco)
                {
                    iLen = strlen(pszNextPourCent + 1);
                    if (iLen > 0)
                    {
                        memmove(pszNextPourCent + 1, pszNextPourCent + 2, iLen);
                    }
                    pszStartCopyPourCent = pszNextPourCent + 1;
                }
            }
            else
            {
                pszStartCopyPourCent = NULL;
            }
        }
    }

    return pListHead;
}

/*!
   Display debug information only 
   when level is compatible with the variable debug_level
   level must be between 100 and 999 
   e.g. : DEBUGPRINT(112,"x=%rr j=%dd\n",x,j);
   
   compatible format :
   %rr : treal *
   %dd : int
   %lld : long long
   %ss : char *
   %cc : int display at as a char
   @param level (in) level of the function
   @param format (in) format the string
   @param ... (in) values
*/
void debugprint(int level, const char *format, ...)
{
    va_list args;
    int debug_levelmax;
    struct write_format *pListFormat = NULL;
    struct write_format *plisttemp, *pListFormatTemp;

    debug_levelmax = (debug_level / 100) * 100 + 99;
    if (!(debug_level <= level && level <= debug_levelmax))
        return;

    va_start(args, format);
    pListFormat = extract_format(format);

    for (pListFormatTemp = pListFormat; pListFormatTemp != NULL; pListFormatTemp = pListFormatTemp->suivant)
    {
        /* treal */
        if (strncmp(pListFormatTemp->nom, "%rr", 3) == 0)
        {
            treal *rval = va_arg(args, treal *);

            printf("%s%s", realprint(*rval), pListFormatTemp->nom + 3);
        }
        /* int */
        else if (strncmp(pListFormatTemp->nom, "%dd", 3) == 0)
        {
            int ival;
            ival = va_arg(args, int);

            printf("%d%s", ival, pListFormatTemp->nom + 3);
        }
        /* char* */
        else if (strncmp(pListFormatTemp->nom, "%ss", 3) == 0)
        {
            char *sval;
            sval = va_arg(args, char *);

            printf("%s%s", sval, pListFormatTemp->nom + 3);
        }
        /* void* */
        else if (strncmp(pListFormatTemp->nom, "%pp", 3) == 0)
        {
            char *sval;
            sval = va_arg(args, char *);

            printf("%p%s", sval, pListFormatTemp->nom + 3);
        }
        /* char */
        else if (strncmp(pListFormatTemp->nom, "%cc", 3) == 0)
        {
            int ival;
            ival = va_arg(args, int);

            printf("%c%s", (char) ival, pListFormatTemp->nom + 3);
        }
        /* long long */
        else if (strncmp(pListFormatTemp->nom, "%lld", 4) == 0)
        {
            long long ival;
            ival = va_arg(args, long long);

            printf("%lld%s", ival, pListFormatTemp->nom + 4);
        }
        else
        {
            fputs(pListFormatTemp->nom, stdout);
        }
        /*free the string */
        free(pListFormatTemp->nom);
    }

    /*free the list */
    pListFormatTemp = pListFormat;
    while (pListFormatTemp != NULL)
    {
        plisttemp = pListFormatTemp;
        pListFormatTemp = pListFormatTemp->suivant;
        free(plisttemp);
    }
    va_end(args);
}
#endif /*DEBUGLEVEL*/
/*--------------------------------------------------------------------------*/
/*! swap the byte order of the integer 
  @param x (in) integer
*/
/*--------------------------------------------------------------------------*/
int swapint(int x)
{
    int j;
    int res;
    char *src = (char *) &x;
    char *dst = (char *) &res;

    for (j = 0; j < (int) sizeof(int); j++)
    {
        dst[sizeof(int) - j - 1] = src[j];
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*! swap the byte order of the real 
  @param x (in) real
*/
/*--------------------------------------------------------------------------*/
double swapdbl(double x)
{
    double res;
    int j;
    char *src = (char *) &x;
    char *dst = (char *) &res;

    for (j = 0; j < (int) sizeof(double); j++)
    {
        dst[sizeof(double) - j - 1] = src[j];
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*! swap the byte order of the arrays of reals 
  @param x (inout) array of reals
  @param count (in) number of elements in the array
*/
/*--------------------------------------------------------------------------*/
void swapdblarray(double *x, size_t count)
{
    size_t j;

    for (j = 0; j < count; j++)
    {
        x[j] = swapdbl(x[j]);
    }
}

/*--------------------------------------------------------------------------*/
/*! swap the byte order of the arrays of integers 
  @param x (inout) array of integers
  @param count (in) number of elements in the array
*/
/*--------------------------------------------------------------------------*/
void swapintarray(int *x, int count)
{
    int j;

    for (j = 0; j < count; j++)
    {
        x[j] = swapint(x[j]);
    }
}

/*--------------------------------------------------------------------------*/
/*! return the greatest value of the arrays of integers 
   if count is 0  then it returns 0
  @param x (in) array of integers 
  @param count (in) number of elements in the array
*/
/*--------------------------------------------------------------------------*/
int getmax_integer(int *x, int count)
{
    int res = 0;
    int j;

    if (count > 0)
    {
        res = x[0];
        for (j = 1; j < count; j++)
        {
            if (res < x[j])
                res = x[j];
        }
    }
    return res;
}

#if defined(HAVE_STDBOOL_H)
/*--------------------------------------------------------------------------*/
/*! 
    Allocate a 1-dimensional array of booleansas  Treal[indice1:indice2] \n
    @param indice1 (in) first indice of array
    @param indice2 (in) last indice of array
*/
/*--------------------------------------------------------------------------*/
bool *boolarrayallocate(int indice1, int indice2)
{
    bool *res;

    res = (bool *) malloc((indice2 - indice1 + 1) * sizeof(bool));
    if (res == NULL)
        fatalerror("Can't allocate memory for %d booleans\n", indice2 - indice1 + 1);
    return res - indice1;
}

/*--------------------------------------------------------------------------*/
/*! 
    Duplicate a 1-dimensional array of booleans previously allocated 
    with realarrayallocate\n
    @param indice1 (in) first indice of array
    @param indice2 (in) last indice of array
    @param array (in) array to be duplicated
*/
/*--------------------------------------------------------------------------*/
bool *boolarrayduplicate(int indice1, int indice2, const bool * array)
{
    int j;
    bool *res;

    res = boolarrayallocate(indice1, indice2);
    for (j = indice1; j <= indice2; j++)
        res[j] = array[j];
    return res;
}

/*--------------------------------------------------------------------------*/
/*! 
    Free a 1-dimensional array of booleans which the first indice is indice1 
    Free memory previously allocated with realarrayallocate
    @param array (in) array to be freed
    @param indice1 (in) first indice of array
*/
/*--------------------------------------------------------------------------*/
void boolarrayfree(bool * array, int indice1)
{
    free(array + indice1);
}
#endif

#if !defined(HAVE_WIN32API)
/*------------------------------------------------------------------*/
/*!  cree un fichier temporaire dans le repertoire $TMPDIR 
 le resultat doit etre libere par free                         
  @param p_pFichier (inout) *p_pFichier contient le descripteur de
     fichier en sortie. 
    En entree, p_pFichier ne doit pas etre NULL.        
  @param p_szMode (in) mode d'ecriture/lecture du fichier
*/
/*------------------------------------------------------------------*/
char *create_tempfile(FILE ** p_pFichier, const char *p_szMode)
{
    char *restmp;
    char *res;
    char *restmp2 = NULL;
    int filetemp;
    static int icount = 0;

    *p_pFichier = NULL;

    restmp = getenv("TMPDIR");
    if (restmp == NULL)
    {
        restmp = (char *) malloc(sizeof(char) * 2000);
        if (restmp == NULL)
            fatalerror("create_tempfile : Can't allocate memory\n");
        restmp2 = restmp;
        strcpy(restmp, "/tmp/");
    }

    res = (char *) malloc(sizeof(char) * 2000);
    if (res == NULL)
        fatalerror("create_tempfile : Can't allocate memory\n");
    sprintf(res, "%sinpoptmpfile%02d.XXXXXX", restmp, icount);
    icount++;
    icount %= 100;
    filetemp = mkstemp(res);
    if (filetemp != -1)
    {
        *p_pFichier = fdopen(filetemp, p_szMode);
    }
    else
    {
        free(res);
        res = NULL;
    }
    if (restmp2 != NULL)
    {
        free(restmp2);
    }
    return res;
}
#endif                          /*defined(HAVE_WIN32API) */

/*------------------------------------------------------------------*/
/*!fonction rint
  @param x (in) reel
*/
/*------------------------------------------------------------------*/
#if !HAVE_RINT
double rint(double x)
{
    double a = floor(x);
    double b = ceil(x);

    return ((fabs(x - a) < fabs(x - b)) ? a : b);
}
#endif

/*------------------------------------------------------------------*/
/* vasprintf                                                        */
/*------------------------------------------------------------------*/
#if !defined(HAVE_VASPRINTF)
int vasprintf(char **retp, const char *format, va_list args)
{
#if defined(HAVE_VSCPRINTF)
    /* code for windows for vasprintf */
    int len;
    int res;
    char *buffer;

    len = _vscprintf(format, args) + 1; /* _vscprintf doesn't count terminating '\0' */
    buffer = (char *) malloc(len * sizeof(char));
    if (buffer != NULL)
    {
        res = vsprintf(buffer, format, args);
        *retp = buffer;
    }
    else
    {
        res = -1;
        *retp = NULL;
    }
    return res;
#elif HAVE_VSNPRINTF
    char buf1[1];
    int nrequired, oldnrequired;
    char *oldretp;

    *retp = NULL;

    nrequired = vsnprintf(buf1, 1, format, args);

    while (1)
    {
        oldnrequired = nrequired;
        if (*retp != NULL)
            free(*retp);
        *retp = NULL;
        if ((*retp = (char *) malloc(nrequired + 1)) == NULL)
        {
            return -1;
        }
        nrequired = vsnprintf(*retp, nrequired + 1, format, args);
        if (nrequired == oldnrequired)
            break;
    }
    return nrequired;
#else
#error  operating system  does not support vasprintf or vsnprintf
#endif
}
#endif

/*------------------------------------------------------------------*/
/*!  cree un fichier vide  avec le nom specifie                        
  @param filename (in) file name to be created
*/
/*------------------------------------------------------------------*/
void create_emptyfile(const char *filename)
{
    FILE *f = fopen(filename, "wt");

    if (f == NULL)
    {
        fatalerror("create_emptyfile a echoue pour creer le fichier '%s'.\nSystem Error : %s\n",
                   filename, strerror(errno));
    }
    else
    {
        fclose(f);
    }
}

/*------------------------------------------------------------------*/
/*!
  retourne 1 si le fichier existe
   @param filename (in) nom du fichier avec le chemin
*/
/*------------------------------------------------------------------*/
int trp_fileexists(const char *filename)
{
    /* we must use GetFileAttributes() instead of the ANSI C functions because
       it can cope with network (UNC) paths unlike them */
#if defined(HAVE_WIN32API)
    DWORD ret = GetFileAttributes(filename);

    return (ret != (DWORD) - 1) && !(ret & FILE_ATTRIBUTE_DIRECTORY);
#else                           /* !HAVE_WIN32API */
    struct stat st;

    return stat(filename, &st) == 0 && (st.st_mode & S_IFREG);
#endif                          /* HAVE_WIN32API */
}

#if defined(HAVE_STDBOOL_H)
/*------------------------------------------------------------------*/
/*!
  retourne 1 si le fichier filename1 est plus recent que filename2
   @param filename1 (in) 1er fichier
   @param filename2 (in) 2eme fichier
*/
/*------------------------------------------------------------------*/
int trp_fileisnewer(const char *filename1, const char *filename2)
{
    struct stat st1, st2;

    if (stat(filename1, &st1) != 0)
        return false;
    if (stat(filename2, &st2) != 0)
        return false;
    return (difftime(st1.st_mtime, st2.st_mtime) > 0);
}
#endif                          /*defined(HAVE_STDBOOL_H) */

/*------------------------------------------------------------------*/
/*!
  copie le contenu du fichier  pfichiersrc vers le descripteur pfichiersrc
  retourne 1  en cas de succes
  @param pfichiersrc (in) nom du fichier source
  @param pfichierdst (inout) descripteur du fichier de destination
*/
/*------------------------------------------------------------------*/
int copyfileptr(FILE * pfichierdst, const char *pfichiersrc)
{
    int bres = 1;
    FILE *file;

    file = fopen(pfichiersrc, "rb");
    if (file != NULL)
    {
        /*char c;
           while (!feof(file))
           {
           fread(&c,1,sizeof(char),file);
           fprintf(pfichierdst, "%c",c);
           } */
        int iferr;
        char *pcBuffer;
        size_t lsize;

        clearerr(file);
        fseek(file, 0L, SEEK_END);
        lsize = ftell(file);
        fseek(file, 0L, SEEK_SET);
        pcBuffer = (char *) malloc(sizeof(char) * lsize);
        if (pcBuffer == NULL)
        {
            fatalerror("Can't allocate memory for %lu bytes\n", (unsigned long) lsize);
        }
        if (fread(pcBuffer, sizeof(char), lsize, file) != lsize)
        {
            fatalerror("Can't read %lu bytes\n", (unsigned long) lsize);
        }
        iferr = ferror(file);
        if (!iferr)
            fwrite(pcBuffer, sizeof(char), lsize, pfichierdst);
        else
            bres = 0;
        iferr = ferror(pfichierdst);
        if (iferr)
            bres = 0;
        fclose(file);
    }
    else
    {
        fatalerror("copyfile failed to open file '%s'\nSystem Error : '%s'\n", pfichiersrc, strerror(errno));
        bres = 0;
    }

    return bres;
}

/*------------------------------------------------------------------*/
/*!
  copie le contenu du fichier  pfichiersrc vers le descripteur pfichiersrc
  retourne 1  en cas de succes
  @param pfichiersrc (in) nom du fichier source
  @param pfichierdst (in) nom du fichier de destination
*/
/*------------------------------------------------------------------*/
int copyfilename(const char *pfichierdst, const char *pfichiersrc)
{
    int bres;
    FILE *file;

    file = fopen(pfichierdst, "wb");
    if (file != NULL)
    {
        bres = copyfileptr(file, pfichiersrc);
        if (!bres)
            fatalerror("copyfilename failed to copy file '%s' to '%s'\nSystem Error : '%s'\n",
                       pfichiersrc, pfichierdst, strerror(errno));
        fclose(file);
    }
    else
    {
        fatalerror("copyfilename failed to create file '%s'\nSystem Error : '%s'\n", pfichierdst, strerror(errno));
        bres = 0;
    }

    return bres;
}

/*------------------------------------------------------------------*/
/*! ouverture du fichier m_filename avec le mode specifie
    @param filename (in) nom du fichier
    @param mode (in) mode d'ouverture (ex.: "wt", "rb", ...)
*/
/*------------------------------------------------------------------*/
FILE *file_open(const char *filename, const char *mode)
{
    FILE *file;

    /* Open the file */
    errno = 0;
    file = fopen(filename, mode);
    if (file == NULL)
    {
        fatalerror("Can't open file '%s'\nSystem error : '%s'\n", filename, strerror(errno));
    }
    return file;
}

/*------------------------------------------------------------------*/
/*! ecriture similaire au fwrite + verification (appel de fatalerror)
    @param file (inout) file
    @param data (in) pointer to the data
    @param size (in) number of bytes to write
*/
/*------------------------------------------------------------------*/
void file_write(FILE * file, const void *data, size_t size)
{
    errno = 0;
    if (fwrite(data, size, 1, file) <= 0 || ferror(file))
    {
        fatalerror("Can't write data to binary file\nSystem error : '%s'\n", strerror(errno));
    }
}

/*------------------------------------------------------------------*/
/*! lecture similaire au fread + verification (appel de fatalerror)
    @param file (inout) file
    @param data (out) pointer to the data
    @param size (in) number of bytes to read
*/
/*------------------------------------------------------------------*/
void file_read(FILE * file, void *data, size_t size)
{
    errno = 0;
    if (fread(data, size, 1, file) <= 0 || ferror(file))
    {
        fatalerror("Can't read data to binary file\nSystem error : '%s'\n", strerror(errno));
    }
}
