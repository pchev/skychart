/*-----------------------------------------------------------------*/
/*!
  \file calcephspice.c
  \brief perform general operations on SPICE KERNEL ephemeris data file
         interpolate SPICE KERNEL Ephemeris data.
         compute position and velocity from SPICE KERNEL ephemeris file.

  \author  M. Gastineau
           Astronomie et Systemes Dynamiques, IMCCE, CNRS, Observatoire de Paris.

   Copyright, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019,  CNRS
   email of the author : Mickael.Gastineau@obspm.fr

  History:
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

#include "calcephconfig.h"
#if HAVE_STDIO_H
#include <stdio.h>
#endif
#if HAVE_STDLIB_H
#include <stdlib.h>
#endif
#if HAVE_STRING_H
#include <string.h>
#endif
#if HAVE_ERRNO_H
#include <errno.h>
#endif
#if HAVE_MATH_H
/* enable M_PI with windows sdk */
#define _USE_MATH_DEFINES
#include <math.h>
#endif
#if HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#include "calcephdebug.h"
#include "real.h"
#define __CALCEPH_WITHIN_CALCEPH 1
#include "calceph.h"
#include "calcephinternal.h"
#include "util.h"

static void calceph_spicekernel_close(struct SPICEkernel *eph);

static double calceph_spicekernel_getEMRAT(struct SPICEkernel *p_pbinfile);

static int calceph_spicekernel_getconstant_vd(const struct SPICEkernel *eph, const char *name,
                                              double *arrayvalue, int nvalue);

static int calceph_spicekernel_getconstantcount(struct SPICEkernel *eph);

static int calceph_spicekernel_getconstantindex(struct SPICEkernel *eph, int *index,
                                                char name[CALCEPH_MAX_CONSTANTNAME], double *value);
static int calceph_spice_findlibration(const struct calcephbin_spice *eph);

static const struct TXTFKframe *calceph_spicekernel_findframe(const struct SPICEkernel *eph,
                                                              const struct TXTPCKconstant *cst);

static const struct TXTFKframe *calceph_spicekernel_findframe2(const struct SPICEkernel *eph,
                                                               struct TXTPCKvalue *value);

static const struct TXTFKframe *calceph_spicekernel_findframe_id(const struct SPICEkernel *eph, int id);

static const struct TXTFKframe *calceph_spice_findframe(const struct calcephbin_spice *eph,
                                                        const struct TXTPCKconstant *cst);

static const struct TXTFKframe *calceph_spice_findframe2(const struct calcephbin_spice *eph, struct TXTPCKvalue *value);

static const struct TXTFKframe *calceph_spice_findframe_id(const struct calcephbin_spice *eph, int id);

static int calceph_spicekernel_isthreadsafe(const struct SPICEkernel *eph);

/*--------------------------------------------------------------------------*/
/*! add a file to the list of kernel.
    allocate memory for it

  @return  pointer to the new slot

  @param eph (inout) descriptor of the ephemeris.
*/
/*--------------------------------------------------------------------------*/
struct SPICEkernel *calceph_spice_addfile(struct calcephbin_spice *eph)
{
    struct SPICEkernel *prec = NULL, *pnew;

    if (eph->list == NULL)
    {
        eph->AU = 0.E0;
        eph->EMRAT = 0.E0;
        calceph_spice_tablelinkbody_init(&eph->tablelink);
    }
    /* go to the tail of the list of file */
    prec = eph->list;
    if (prec != NULL)
    {
        while (prec->next != NULL)
            prec = prec->next;
    }
    /* allocate memory */
    pnew = (struct SPICEkernel *) malloc(sizeof(struct SPICEkernel));
    if (pnew == NULL)
    {
        fatalerror("Can't allocate memory for SPICEkernel\nSystem error : '%s'\n", strerror(errno));
        return NULL;
    }
    /* add it to the tail */
    pnew->next = NULL;
    if (prec == NULL)
    {
        eph->list = pnew;
    }
    else
    {
        prec->next = pnew;
    }
    return pnew;
}

/*--------------------------------------------------------------------------*/
/*! Close the SPICE ephemeris file.

  @return  1 on sucess and 0 on failure

  @param eph (inout) descriptor of the ephemeris.
*/
/*--------------------------------------------------------------------------*/
static void calceph_spicekernel_close(struct SPICEkernel *eph)
{
    switch (eph->filetype)
    {
        case DAF_SPK:
            calceph_spk_close(&eph->filedata.spk);
            break;

        case TXT_PCK:
            calceph_txtpck_close(&eph->filedata.txtpck);
            break;

        case DAF_PCK:
            calceph_binpck_close(&eph->filedata.spk);
            break;

        case TXT_FK:
            calceph_txtfk_close(&eph->filedata.txtfk);
            break;

        default:
            fatalerror("Unknown SPICE type in %d\n", (int) eph->filetype);
            break;
    }
}

/*--------------------------------------------------------------------------*/
/*! Close the SPICE ephemeris file.

  @return  1 on sucess and 0 on failure

  @param eph (inout) descriptor of the ephemeris.
*/
/*--------------------------------------------------------------------------*/
void calceph_spice_close(struct calcephbin_spice *eph)
{
    struct SPICEkernel *list = eph->list;

    while (list != NULL)
    {
        struct SPICEkernel *clist = list;

        calceph_spicekernel_close(list);
        list = list->next;
        free(clist);
    }
    calceph_spice_tablelinkbody_close(&eph->tablelink);
}

/*--------------------------------------------------------------------------*/
/*! Prefetch the SPICE ephemeris file.

  @return  1 on sucess and 0 on failure

  @param eph (inout) descriptor of the ephemeris.
*/
/*--------------------------------------------------------------------------*/
static int calceph_spicekernel_prefetch(struct SPICEkernel *eph)
{
    int res = 1;

    switch (eph->filetype)
    {
        case DAF_SPK:
            res = calceph_spk_prefetch(&eph->filedata.spk);
            break;

        case TXT_PCK:
            break;

        case DAF_PCK:
            res = calceph_spk_prefetch(&eph->filedata.spk);
            break;

        case TXT_FK:
            break;

        default:
            fatalerror("Unknown SPICE type in %d\n", (int) eph->filetype);
            break;
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*! Prefetch for reading any SPICE file

  @return  1 on sucess and 0 on failure

  @param eph (inout) descriptor of the ephemeris.
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_prefetch(struct calcephbin_spice *eph)
{
    int res = 1;

    struct SPICEkernel *list = eph->list;

    while (list != NULL && res)
    {
        res = calceph_spicekernel_prefetch(list);
        list = list->next;
    }

    /* compute AU for later computation and thread-safe */
    if (res)
    {
        calceph_spice_getAU(eph);
        /* initialize the cache for later computation and thread-safe */
        res = calceph_spice_cache_init(&(eph->tablelink.array_cache), eph->tablelink.count_body);
    }

    return res;
}

/*--------------------------------------------------------------------------*/
/*! Return a non-zero value if eph could be accessed by multiple threads
  @param eph (in) descriptor of the ephemeris.
*/
/*--------------------------------------------------------------------------*/
static int calceph_spicekernel_isthreadsafe(const struct SPICEkernel *eph)
{
    int res = 1;

    switch (eph->filetype)
    {
        case DAF_SPK:
            res = (eph->filedata.spk.prefetch != 0) ? 1 : 0;
            break;

        case TXT_PCK:
            break;

        case DAF_PCK:
            res = (eph->filedata.spk.prefetch != 0) ? 1 : 0;
            break;

        case TXT_FK:
            break;

        default:
            fatalerror("Unknown SPICE type in %d\n", (int) eph->filetype);
            res = 0;
            break;
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*! Return a non-zero value if eph could be accessed by multiple threads

  @param eph (in) descriptor of the ephemeris.
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_isthreadsafe(const struct calcephbin_spice *eph)
{
    int res = 1;

    struct SPICEkernel *list = eph->list;

    while (list != NULL && res)
    {
        res = calceph_spicekernel_isthreadsafe(list);
        list = list->next;
    }

    return res;
}

/*--------------------------------------------------------------------------*/
/*! convert an internal id from calceph to SPICE id
   e.g., calceph_spice_convertid(eph, 10) return 301
    return -1 if not supported.
   @param target (in) id to be converted
   @param eph (in) ephemeris file
*/
/*--------------------------------------------------------------------------*/
static int calceph_spice_convertid_old2spiceid_id(const struct calcephbin_spice *eph, int target)
{
    int res = -1;

    switch (target)
    {
        case MERCURY + 1:
            res = NAIFID_MERCURY_BARYCENTER;
            break;
        case VENUS + 1:
            res = NAIFID_VENUS_BARYCENTER;
            break;
        case EARTH + 1:
            res = NAIFID_EARTH;
            break;
        case MARS + 1:
            res = NAIFID_MARS_BARYCENTER;
            break;
        case JUPITER + 1:
            res = NAIFID_JUPITER_BARYCENTER;
            break;
        case SATURN + 1:
            res = NAIFID_SATURN_BARYCENTER;
            break;
        case URANUS + 1:
            res = NAIFID_URANUS_BARYCENTER;
            break;
        case NEPTUNE + 1:
            res = NAIFID_NEPTUNE_BARYCENTER;
            break;
        case PLUTO + 1:
            res = NAIFID_PLUTO_BARYCENTER;
            break;
        case MOON + 1:
            res = NAIFID_MOON;
            break;
        case SUN + 1:
            res = NAIFID_SUN;
            break;
        case SS_BARY + 1:
            res = NAIFID_SOLAR_SYSTEM_BARYCENTER;
            break;
        case EM_BARY + 1:
            res = NAIFID_EARTH_MOON_BARYCENTER;
            break;
        case NUTATIONS + 1:
            res = -1;
            break;
        case TTMTDB + 1:
            res = NAIFID_TIME_TTMTDB;
            break;
        case TCGMTCB + 1:
            res = NAIFID_TIME_TCGMTCB;
            break;

        case LIBRATIONS + 1:
            res = calceph_spice_findlibration(eph);
            break;

        default:
            if (target > CALCEPH_ASTEROID)
            {
                res = target;
            }
            break;
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*! return EMRAT from file
  @param p_pbinfile (in) ephemeris file
*/
/*--------------------------------------------------------------------------*/
static double calceph_spicekernel_getEMRAT(struct SPICEkernel *p_pbinfile)
{
    double EMRAT = 0.E0, GMEARTH, GMEMB, GMMOON;

    if (calceph_spicekernel_getconstant_vd(p_pbinfile, "BODY301_GM", &GMMOON, 1))
    {
        if (calceph_spicekernel_getconstant_vd(p_pbinfile, "BODY399_GM", &GMEARTH, 1))
        {
            EMRAT = GMEARTH / GMMOON;
        }
        else if (calceph_spicekernel_getconstant_vd(p_pbinfile, "BODY3_GM", &GMEMB, 1))
        {
            EMRAT = GMEMB / GMMOON - 1.E0;
        }
    }
    return EMRAT;
}

/*--------------------------------------------------------------------------*/
/*! return EMRAT from file
  @param p_pbinfile (in) ephemeris file
*/
/*--------------------------------------------------------------------------*/
double calceph_spice_getEMRAT(struct calcephbin_spice *p_pbinfile)
{
    if (p_pbinfile->EMRAT == 0.E0)
    {
        /* first call : try to find EMRAT */
        struct SPICEkernel *list = p_pbinfile->list;

        while (list != NULL && p_pbinfile->EMRAT == 0.E0)
        {
            p_pbinfile->EMRAT = calceph_spicekernel_getEMRAT(list);
            list = list->next;
        }
    }
    return p_pbinfile->EMRAT;
}

/*--------------------------------------------------------------------------*/
/*! return AU from file
  @param p_pbinfile (inout) ephemeris file
*/
/*--------------------------------------------------------------------------*/
double calceph_spice_getAU(struct calcephbin_spice *p_pbinfile)
{
    if (p_pbinfile->AU == 0.E0)
    {
        calceph_spice_getconstant_vd(p_pbinfile, "AU", &p_pbinfile->AU, 1);
    }
    return p_pbinfile->AU;
}

/*--------------------------------------------------------------------------*/
/*! fill the array arrayvalue with the nvalue first values of the specified constant from file
  return 0 if constant is not found
  return the number of values associated to the constant (this value may be larger than nvalue),
  if constant is  found
  @param eph (in) ephemeris file
  @param name (in) constant name
  @param name (in) constant name
  @param arrayvalue (out) array of values of the constant.
    On input, the size of the array is nvalue elements.
    On exit, the min(returned value, nvalue) elements are filled.
  @param nvalue (in) number of elements in the array arrayvalue.
*/
/*--------------------------------------------------------------------------*/
static int calceph_spicekernel_getconstant_vd(const struct SPICEkernel *eph, const char *name,
                                              double *arrayvalue, int nvalue)
{
    int found = 0;

    switch (eph->filetype)
    {
        case TXT_PCK:
            found = calceph_txtpck_getconstant_vd(&eph->filedata.txtpck, name, arrayvalue, nvalue);
            break;

        case TXT_FK:
            found = calceph_txtpck_getconstant_vd(&eph->filedata.txtfk.txtpckfile, name, arrayvalue, nvalue);
            break;

        default:
            break;
    }
    return found;
}

/*--------------------------------------------------------------------------*/
/*! fill the array arrayvalue with the nvalue first values of the specified constant from file
  return 0 if constant is not found
  return the number of values associated to the constant (this value may be larger than nvalue),
  if constant is  found
  @param eph (in) ephemeris file
  @param name (in) constant name
  @param name (in) constant name
  @param arrayvalue (out) array of values of the constant.
    On input, the size of the array is nvalue elements.
    On exit, the min(returned value, nvalue) elements are filled.
  @param nvalue (in) number of elements in the array arrayvalue.
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_getconstant_vd(const struct calcephbin_spice *eph, const char *name, double *arrayvalue, int nvalue)
{
    int found = 0;

    struct SPICEkernel *list = eph->list;

    while (list != NULL && found == 0)
    {
        found = calceph_spicekernel_getconstant_vd(list, name, arrayvalue, nvalue);
        list = list->next;
    }
    return found;
}

/*--------------------------------------------------------------------------*/
/*! return the specified constant from file
  return NULL if constant is not found
  @param eph (in) ephemeris file
  @param name (in) constant name
*/
/*--------------------------------------------------------------------------*/
static struct TXTPCKconstant *calceph_spicekernel_getptrconstant(struct SPICEkernel *eph, const char *name)
{
    struct TXTPCKconstant *found = NULL;

    switch (eph->filetype)
    {
        case TXT_PCK:
            found = calceph_txtpck_getptrconstant(&eph->filedata.txtpck, name);
            break;

        case TXT_FK:
            found = calceph_txtpck_getptrconstant(&eph->filedata.txtfk.txtpckfile, name);
            break;

        default:
            break;
    }
    return found;
}

/*--------------------------------------------------------------------------*/
/*! return the specified constant from file
   return NULL if constant is not found
   @param eph (in) ephemeris file
   @param name (in) constant name
*/
/*--------------------------------------------------------------------------*/
static const struct TXTPCKconstant *calceph_spice_getptrconstant(const struct calcephbin_spice *eph, const char *name)
{
    struct TXTPCKconstant *found = NULL;

    struct SPICEkernel *list = eph->list;

    while (list != NULL && found == NULL)
    {
        found = calceph_spicekernel_getptrconstant(list, name);
        list = list->next;
    }
    return found;
}

/*--------------------------------------------------------------------------*/
/*! fill the array arrayvalue with the nvalue first values of the specified constant from file
  return 0 if constant is not found
  return the number of values associated to the constant (this value may be larger than nvalue),
  if constant is  found
  @param eph (in) ephemeris file
  @param name (in) constant name
  @param name (in) constant name
  @param arrayvalue (out) array of values of the constant.
    On input, the size of the array is nvalue elements.
    On exit, the min(returned value, nvalue) elements are filled.
  @param nvalue (in) number of elements in the array arrayvalue.
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_getconstant_vs(struct calcephbin_spice *eph, const char *name,
                                 t_calcephcharvalue * arrayvalue, int nvalue)
{
    int found = 0;

    const struct TXTPCKconstant *ptr = calceph_spice_getptrconstant(eph, name);

    if (ptr)
    {
        struct TXTPCKvalue *listvalue;

        for (listvalue = ptr->value; listvalue != NULL; listvalue = listvalue->next)
        {
            if (listvalue->buffer[listvalue->locfirst] == '\'')
            {
                if (found < nvalue)
                {
                    int k;

                    int j = listvalue->loclast;

                    while (j > listvalue->locfirst && listvalue->buffer[j] != '\'')
                        j--;
                    if (j > listvalue->locfirst)
                    {
                        int curpos = 0;

                        for (k = listvalue->locfirst + 1; k < j && k < CALCEPH_MAX_CONSTANTVALUE; k++)
                        {
                            if (listvalue->buffer[k] == '\'')
                                k++;
                            arrayvalue[found][curpos++] = listvalue->buffer[k];
                        }
                        arrayvalue[found][curpos++] = '\0';
                        for (; curpos < CALCEPH_MAX_CONSTANTVALUE; curpos++)
                            arrayvalue[found][curpos] = ' ';
                        found++;
                    }
                }
                else
                {
                    found++;
                }
            }
        }
    }

    return found;
}

/*--------------------------------------------------------------------------*/
/*! return the number of constants available in the ephemeris file

  @param eph (inout) ephemeris descriptor
*/
/*--------------------------------------------------------------------------*/
static int calceph_spicekernel_getconstantcount(struct SPICEkernel *eph)
{
    int res = 0;

    switch (eph->filetype)
    {
        case TXT_PCK:
            res = calceph_txtpck_getconstantcount(&eph->filedata.txtpck);
            break;

        case TXT_FK:
            res = calceph_txtpck_getconstantcount(&eph->filedata.txtfk.txtpckfile);
            break;

        default:
            break;
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*! return the number of constants available in the ephemeris file

  @param eph (inout) ephemeris descriptor
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_getconstantcount(struct calcephbin_spice *eph)
{
    int res = 0;

    struct SPICEkernel *list = eph->list;

    while (list != NULL)
    {
        res += calceph_spicekernel_getconstantcount(list);
        list = list->next;
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*! get the name and its first value of the constant available
    at some index from the ephemeris file
   return the number of values associated to the constant if index is valid.
   return 0 if index isn't valid

  @param eph (inout) ephemeris descriptor
  @param index (inout) index of the constant (must be between 1 and calceph_getconstantcount() )
            if index > number of constant in this kernel, decrement it
  @param name (out) name of the constant
  @param value (out) first value of the constant
*/
/*--------------------------------------------------------------------------*/
static int calceph_spicekernel_getconstantindex(struct SPICEkernel *eph, int *index,
                                                char name[CALCEPH_MAX_CONSTANTNAME], double *value)
{
    int res = 0;

    switch (eph->filetype)
    {
        case TXT_PCK:
            res = calceph_txtpck_getconstantindex(&eph->filedata.txtpck, index, name, value);
            break;

        case TXT_FK:
            res = calceph_txtpck_getconstantindex(&eph->filedata.txtfk.txtpckfile, index, name, value);
            break;

        default:
            break;
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*! get the name and its first value of the constant available
    at some index from the ephemeris file
   return the number of values associated to the constant if index is valid.
   return 0 if index isn't valid

  @param eph (inout) ephemeris descriptor
  @param index (in) index of the constant (must be between 1 and calceph_getconstantcount() )
  @param name (out) name of the constant
  @param value (out) first value of the constant
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_getconstantindex(struct calcephbin_spice *eph, int index,
                                   char name[CALCEPH_MAX_CONSTANTNAME], double *value)
{
    int res = 0;

    struct SPICEkernel *list = eph->list;

    while (list != NULL && index > 0 && res == 0)
    {
        res = calceph_spicekernel_getconstantindex(list, &index, name, value);
        list = list->next;
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*!
     This function changes the state vector, which is expressed in InputUnit units as input,
       to the OutputUnit as output.

     This function is for SPK ephemeris format.

  it returns 0 if the function fails to convert.

  @param pephbin (inout) ephemeris descriptor
  @param Target   (in) Solar system body for which position is desired.
   or a time. NAIF ID
  @param InputUnit  (in) output unit of the statetype
  @param OutputUnit  (in) output unit of the statetype
  @param Planet (inout) position and velocity
          Input : expressed in InputUnit units.
          Output : expressed in OutputUnit units.
*/
/*--------------------------------------------------------------------------*/
static int calceph_spice_unit_convert_distanceortime(struct calcephbin_spice *pephbin, stateType * Planet,
                                                     int Target, int InputUnit, int OutputUnit)
{
    int res = 1;

    /* if same unit in input and output => do nothing */
    if (InputUnit == OutputUnit)
        return res;
    /* some checks */

    switch (Target)
    {
            /* time */
        case NAIFID_TIME_TTMTDB:
        case NAIFID_TIME_TCGMTCB:
            if ((OutputUnit & CALCEPH_UNIT_DAY) == CALCEPH_UNIT_DAY
                && (InputUnit & CALCEPH_UNIT_SEC) == CALCEPH_UNIT_SEC)
            {
                Planet->Position[0] /= 86400E0;
            }
            if ((InputUnit & CALCEPH_UNIT_DAY) == CALCEPH_UNIT_DAY
                && (OutputUnit & CALCEPH_UNIT_SEC) == CALCEPH_UNIT_SEC)
            {
                Planet->Position[0] *= 86400E0;
            }
            if ((OutputUnit & (CALCEPH_UNIT_DAY + CALCEPH_UNIT_SEC)) == 0)
            {
                res = 0;
                fatalerror("Units must include CALCEPH_UNIT_DAY or CALCEPH_UNIT_SEC \n");
            }
            if ((OutputUnit & (CALCEPH_UNIT_DAY + CALCEPH_UNIT_SEC)) == CALCEPH_UNIT_DAY + CALCEPH_UNIT_SEC)
            {
                res = 0;
                fatalerror("Units must include only one value : CALCEPH_UNIT_DAY or CALCEPH_UNIT_SEC \n");
            }
            break;

            /*distance */
        default:
            if ((OutputUnit & (CALCEPH_UNIT_AU + CALCEPH_UNIT_KM)) == 0)
            {
                res = 0;
                fatalerror("Units must include CALCEPH_UNIT_AU or CALCEPH_UNIT_KM \n");
            }
            if ((OutputUnit & (CALCEPH_UNIT_AU + CALCEPH_UNIT_KM)) == CALCEPH_UNIT_AU + CALCEPH_UNIT_KM)
            {
                res = 0;
                fatalerror("Units must include only one value : CALCEPH_UNIT_AU or CALCEPH_UNIT_KM \n");
            }

            if ((OutputUnit & CALCEPH_UNIT_KM) == CALCEPH_UNIT_KM && (InputUnit & CALCEPH_UNIT_AU) == CALCEPH_UNIT_AU)
            {
                treal rau = calceph_spice_getAU(pephbin);

                if (rau == 0.E0)
                {
                    res = 0;
                    fatalerror("Astronomical unit is not available in the ephemeris file\n");
                }
                calceph_stateType_mul_scale(Planet, rau);
            }
            if ((InputUnit & CALCEPH_UNIT_KM) == CALCEPH_UNIT_KM && (OutputUnit & CALCEPH_UNIT_AU) == CALCEPH_UNIT_AU)
            {
                treal rau = calceph_spice_getAU(pephbin);

                if (rau == 0.E0)
                {
                    res = 0;
                    fatalerror("Astronomical unit is not available in the ephemeris file\n");
                }
                calceph_stateType_div_scale(Planet, rau);
            }
            if (res)
                res = calceph_unit_convert_quantities_time(Planet, InputUnit, OutputUnit);
            break;
    }
    return res;
}

/*--------------------------------------------------------------------------*/
/*! compute the position <x,y,z> and velocity <xdot,ydot,zdot>
    for a given target and center  at the specified time
  (time elapsed from JD0).
  The output is expressed according to unit.

  return 0 on error.
  return 1 on success.

   @param eph (inout) ephemeris file descriptor
   @param JD0 (in) reference time (could be 0)
   @param time (in) time elapsed from JD0
   @param spicetarget (in) "target" object (NAIF ID number)
   @param spicecenter (in) "center" object  (NAIF ID number)
   @param unit (in) sum of CALCEPH_UNIT_???
   @param order (in) order of the computation
   =0 : Positions are  computed
   =1 : Position+Velocity  are computed
   =2 : Position+Velocity+Acceleration  are computed
   =3 : Position+Velocity+Acceleration+Jerk  are computed
   @param PV (out) quantities of the "target" object
     PV[0:3*(order+1)-1] are valid
*/
/*--------------------------------------------------------------------------*/
static int calceph_spice_compute_unit_spiceid(struct calcephbin_spice *eph, double JD0, double time,
                                              int spicetarget, int spicecenter, int unit, int order,
                                              double PV[ /*<=12 */ ])
{
    stateType statetarget;

    int res;

    if (spicetarget == spicecenter)
    {
        calceph_PV_set_0(PV, order);
        return 1;
    }

    statetarget.order = order;
    res = calceph_spice_tablelinkbody_compute(eph, JD0, time, spicetarget, spicecenter, &statetarget);
    if (res)
    {
        int ephunit = CALCEPH_UNIT_KM + CALCEPH_UNIT_SEC + CALCEPH_UNIT_RAD;

        res = calceph_spice_unit_convert_distanceortime(eph, &statetarget, spicetarget, ephunit, unit);
        calceph_PV_set_stateType(PV, statetarget);
    }

    return res;
}

/*--------------------------------------------------------------------------*/
/*!
     This function changes the state vector for an orientation, which is expressed in InputUnit units as
  input, to the OutputUnit as output.

     This function is for SPK ephemeris format.

  it returns 0 if the function fails to convert.

  @param InputUnit  (in) output unit of the statetype
  @param OutputUnit  (in) output unit of the statetype
  @param Planet (inout) angles and derivatives of angles
          Input : expressed in InputUnit units.
          Output : expressed in OutputUnit units.
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_unit_convert_orient(stateType * Planet, int InputUnit, int OutputUnit)
{
    int res = 1;

    /* if same unit in input and output => do nothing */
    if (InputUnit == OutputUnit)
        return res;
    /* some checks */

    if ((OutputUnit & CALCEPH_UNIT_RAD) == 0)
    {
        fatalerror("Units for libration must be in radians\n");
        res = 0;
    }
    if ((InputUnit & CALCEPH_UNIT_RAD) == 0)
    {
        fatalerror("Input units for libration must be in radians\n");
        res = 0;
    }
    if (res)
        res = calceph_unit_convert_quantities_time(Planet, InputUnit, OutputUnit);
    return res;
}

/*--------------------------------------------------------------------------*/
/*! return the object id of the euler angles of the moon (libration)
    try to to find the frame with the specified radical
    return -1 if not supported.
  @param eph (in) ephemeris descriptor
  @param name (in) name to find
  @param target (in) spice id of the object
*/
/*--------------------------------------------------------------------------*/
static int calceph_spice_findlibration2(const struct calcephbin_spice *eph, const char *name, int target)
{
    const struct TXTPCKconstant *pcstOBJECT_MOON_FRAME;

    const struct TXTFKframe *frame;

    pcstOBJECT_MOON_FRAME = calceph_spice_getptrconstant(eph, name);
    if (pcstOBJECT_MOON_FRAME == NULL)
    {
#if DEBUG
        printf("'%s' not found in the kernels\n", name);
#endif
        return -1;
    }
    frame = calceph_spice_findframe(eph, pcstOBJECT_MOON_FRAME);
    if (frame == NULL)
    {
#if DEBUG
        printf("frame not found in the kernels\n");
#endif
        return -1;
    }
    if (frame->center != target)
    {
#if DEBUG
        printf("center is not the %d\n", target);
#endif
        return -1;
    }
    if (frame->tkframe_relative != NULL)
    {
        if (frame->tkframe_spec != NULL && calceph_txtpck_cmpszvalue(frame->tkframe_spec, "'MATRIX'") == 0)
        {
            int j, k;

#if DEBUG
            printf("if the frame uses a matrix, check that the matrix is identity\n");
#endif
            for (j = 0; j < 3; j++)
            {
                for (k = 0; k < 3; k++)
                {
                    if (j == k && frame->tkframe_matrix[j * 3 + k] != 1.0E0)
                    {
#if DEBUG
                        printf("matrix is not identity (diagonal is not 1)\n");
#endif
                        return -1;
                    }
                    if (j != k && frame->tkframe_matrix[j * 3 + k] != 0.0E0)
                    {
#if DEBUG
                        printf("matrix is not identity (other elements are not 0)\n");
#endif
                        return -1;
                    }
                }
            }
        }

        frame = calceph_spice_findframe2(eph, frame->tkframe_relative);
        if (frame == NULL)
        {
#if DEBUG
            printf("frame not found in the kernels\n");
#endif
            return -1;
        }
        if (frame->center != target)
        {
#if DEBUG
            printf("center is not the %d\n", target);
#endif
            return -1;
        }
    }
#if DEBUG
    printf("class_id for the libration of the moon : %d\n", frame->class_id);
#endif
    return frame->class_id;
}

/*--------------------------------------------------------------------------*/
/*! return the object id of the euler angles of the moon (libration)
    return -1 if not supported.
  @param eph (in) ephemeris descriptor
*/
/*--------------------------------------------------------------------------*/
static int calceph_spice_findlibration(const struct calcephbin_spice *eph)
{
    int res;

    res = calceph_spice_findlibration2(eph, "OBJECT_MOON_FRAME", 301);
    if (res == -1)
        res = calceph_spice_findlibration2(eph, "FRAME_MOON_PA", 301);
    return res;
}

/*--------------------------------------------------------------------------*/
/*! return the frame associated to the specified value from this kernel
    return NULL if not found.
  @param eph (in) kernel
  @param cst (in) constant to find
*/
/*--------------------------------------------------------------------------*/
static const struct TXTFKframe *calceph_spicekernel_findframe(const struct SPICEkernel *eph,
                                                              const struct TXTPCKconstant *cst)
{
    const struct TXTFKframe *frame = NULL;

    switch (eph->filetype)
    {
        case TXT_FK:
            frame = calceph_txtfk_findframe(&eph->filedata.txtfk, cst);
            break;

        default:
            break;
    }
    return frame;
}

/*--------------------------------------------------------------------------*/
/*! return the frame associated to the specified value from this kernel
    return NULL if not found.
  @param eph (in) kernel
  @param value (in) value to find
*/
/*--------------------------------------------------------------------------*/
static const struct TXTFKframe *calceph_spicekernel_findframe2(const struct SPICEkernel *eph, struct TXTPCKvalue *value)
{
    const struct TXTFKframe *frame = NULL;

    switch (eph->filetype)
    {
        case TXT_FK:
            frame = calceph_txtfk_findframe2(&eph->filedata.txtfk, value);
            break;

        default:
            break;
    }
    return frame;
}

/*--------------------------------------------------------------------------*/
/*! return the frame associated to the specified value from this kernel
    return NULL if not found.
  @param eph (in) kernel
  @param id (in) value to find
*/
/*--------------------------------------------------------------------------*/
static const struct TXTFKframe *calceph_spicekernel_findframe_id(const struct SPICEkernel *eph, int id)
{
    const struct TXTFKframe *frame = NULL;

    switch (eph->filetype)
    {
        case TXT_FK:
            frame = calceph_txtfk_findframe_id(&eph->filedata.txtfk, id);
            break;

        default:
            break;
    }
    return frame;
}

/*--------------------------------------------------------------------------*/
/*! return the frame associated to the specified value from a list of kernel
    return NULL if not found.
  @param eph (in) ephemeris descriptor
  @param cst (in) constant to find
*/
/*--------------------------------------------------------------------------*/
static const struct TXTFKframe *calceph_spice_findframe(const struct calcephbin_spice *eph,
                                                        const struct TXTPCKconstant *cst)
{
    const struct TXTFKframe *frame = NULL;

    struct SPICEkernel *list = eph->list;

    while (list != NULL && frame == NULL)
    {
        frame = calceph_spicekernel_findframe(list, cst);
        list = list->next;
    }
    return frame;
}

/*--------------------------------------------------------------------------*/
/*! return the frame associated to the specified value from a list of kernel
    return NULL if not found.
  @param eph (in) ephemeris descriptor
  @param value (in) value to find
*/
/*--------------------------------------------------------------------------*/
static const struct TXTFKframe *calceph_spice_findframe2(const struct calcephbin_spice *eph, struct TXTPCKvalue *value)
{
    const struct TXTFKframe *frame = NULL;

    struct SPICEkernel *list = eph->list;

    while (list != NULL && frame == NULL)
    {
        frame = calceph_spicekernel_findframe2(list, value);
        list = list->next;
    }
    return frame;
}

/*--------------------------------------------------------------------------*/
/*! return the frame associated to the specified value from a list of kernel
    return NULL if not found.
  @param eph (in) ephemeris descriptor
  @param id (in) constant to find
*/
/*--------------------------------------------------------------------------*/
static const struct TXTFKframe *calceph_spice_findframe_id(const struct calcephbin_spice *eph, int id)
{
    const struct TXTFKframe *frame = NULL;

    struct SPICEkernel *list = eph->list;

    while (list != NULL && frame == NULL)
    {
        frame = calceph_spicekernel_findframe_id(list, id);
        list = list->next;
    }
    return frame;
}

/*--------------------------------------------------------------------------*/
/*! return the rotation matrix of the frame  associated to the specified value from a list of kernel

  return 0 on error.
  return 1 on success.

  @param eph (in) ephemeris descriptor
  @param id (in) constant to find
  @param JD0 (in) reference time (could be 0)
  @param time (in) time elapsed from JD0
  @param matrix (out) rotation matrix 3x3
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_findframe_matrix(const struct calcephbin_spice *eph, int id, double PARAMETER_UNUSED(JD0), double PARAMETER_UNUSED(time),
                                   double matrix[3][3])
{
#if HAVE_PRAGMA_UNUSED
#pragma unused(JD0, time)
#endif
    int j, k;

    const struct TXTFKframe *frame = calceph_spice_findframe_id(eph, id);

    if (frame == NULL)
    {
        int builtin = 0;
        double epsJ2000;

        switch (id)
        {
            case 17:           /*ECLIPJ2000  Ecliptic coordinates based upon the J2000 frame. equation 3.222-1 from extra
                                   supp. astro. almanach at J2000.0 */
                epsJ2000 = 84381.448/3600;
                calceph_txtfk_creatematrix_axes1(matrix, epsJ2000 * M_PI / 180.E0);
                return 1;
                /*break; */
            default:
                break;
        }

        if (builtin == 0)
        {
            fatalerror("Can't find the definition of the frame '%d'\n", id);
            return 0;
        }
    }
    for (j = 0; j < 3; j++)
    {
        for (k = 0; k < 3; k++)
        {
            matrix[j][k] = frame->tkframe_matrix[3 * j + k];
        }
    }

    if (frame->tkframe_relative_id != 1)
    {
        fatalerror("The  frame '%d' is not relative to ICRF or J2000 reference frame \n", id);
        return 0;
    }
    return (frame->tkframe_relative_id == 1);
}

/*--------------------------------------------------------------------------*/
/*! Return the orientation of the object
    for a given target at the specified time
  (time elapsed from JD0).
  The output is expressed according to unit.

  return 0 on error.
  return 1 on success.

   @param eph (inout) ephemeris file descriptor
   @param JD0 (in) reference time (could be 0)
   @param time (in) time elapsed from JD0
   @param target (in) "target" object (NAIF ID number)
   @param unit (in) sum of CALCEPH_UNIT_???
   @param order (in) order of the computation
   =0 : Positions are  computed
   =1 : Position+Velocity  are computed
   =2 : Position+Velocity+Acceleration  are computed
   =3 : Position+Velocity+Acceleration+Jerk  are computed
   @param PV (out) quantities of the "target" object
   PV[0:3*(order+1)-1] are valid
*/
/*--------------------------------------------------------------------------*/
static int calceph_spice_orient_unit_spiceid(struct calcephbin_spice *eph, double JD0, double time,
                                             int spicetarget, int unit, int order, double PV[ /*<=12 */ ])
{
    stateType statetarget;

    int res;

    statetarget.order = order;
    res = calceph_spice_tablelinkbody_compute(eph, JD0, time, spicetarget, -1, &statetarget);
    if (res)
    {
        int ephunit = CALCEPH_UNIT_SEC + CALCEPH_UNIT_RAD;

        res = calceph_spice_unit_convert_orient(&statetarget, ephunit, unit);
        calceph_PV_set_stateType(PV, statetarget);
    }

    return res;
}

/*--------------------------------------------------------------------------*/
/*! Return the orientation of the object
    for a given target at the specified time
  (time elapsed from JD0).
  The output is expressed according to unit.
  The target  is expressed in the old or NAIF ID numbering system defined on unit.

  return 0 on error.
  return 1 on success.

   @param eph (inout) ephemeris file descriptor
   @param JD0 (in) reference time (could be 0)
   @param time (in) time elapsed from JD0
   @param target (in) "target" object (NAIF or old numbering system)
   @param unit (in) sum of CALCEPH_UNIT_??? and /or CALCEPH_USE_NAIFID
   If unit& CALCEPH_USE_NAIFID !=0 then NAIF identification numbers are used
   If unit& CALCEPH_USE_NAIFID ==0 then old identification numbers are used
   @param order (in) order of the computation
   =0 : Positions are  computed
   =1 : Position+Velocity  are computed
   =2 : Position+Velocity+Acceleration  are computed
   =3 : Position+Velocity+Acceleration+Jerk  are computed
   @param PV (out) quantities of the "target" object
   PV[0:3*(order+1)-1] are valid
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_orient_unit(struct calcephbin_spice *eph, double JD0, double time, int target,
                              int unit, int order, double PV[ /*<=12 */ ])
{
    int target_spiceid = -1;

    int newunit;

    if ((unit & CALCEPH_USE_NAIFID) != 0)
    {
        newunit = unit - CALCEPH_USE_NAIFID;
        if (target != NAIFID_MOON)
        {
            /* try to locate in a binary pck */
            int *countlisttime;

            struct SPICElinktime **loclink;

            char frameid[256];
            int targetframe;

            sprintf(frameid, "OBJECT_%d_FRAME", target);
            targetframe = calceph_spice_findlibration2(eph, frameid, target);
            if (targetframe != -1)
            {
#if DEBUG
                printf("found orientation for %d : %d\n", target, targetframe);
#endif
                if (calceph_spice_tablelinkbody_locatelinktime_complex(&eph->tablelink, targetframe, -1,
                                                                       &loclink, &countlisttime) == 1)
                {
                    if (*countlisttime > 0)
                        target_spiceid = targetframe;
                }
            }
            else
            {
                if (calceph_spice_tablelinkbody_locatelinktime_complex(&eph->tablelink, target, -1, &loclink,
                                                                       &countlisttime) == 1)
                {
                    if (*countlisttime > 0)
                        target_spiceid = target;
                }
            }
        }
        else
        {
            target_spiceid = calceph_spice_findlibration(eph);
        }

        /* try to locate using POLE_RA/DE/PM */
        if (target_spiceid == -1)
        {
            return calceph_txtpck_orient_unit(eph, JD0, time, target, newunit, order, PV);
        }
    }
    else
    {
        if (target != LIBRATIONS + 1)
        {
            fatalerror("Orientation for the target object %d is not supported.\n", target);
            return 0;
        }
        target_spiceid = calceph_spice_convertid_old2spiceid_id(eph, target);
        newunit = unit;
    }
    if (target_spiceid == -1)
    {
        fatalerror("Orientation for the target object %d is not available in the ephemeris file.\n", target);
        return 0;
    }
    return calceph_spice_orient_unit_spiceid(eph, JD0, time, target_spiceid, newunit, order, PV);
}

/*--------------------------------------------------------------------------*/
/*! compute the position <x,y,z> and velocity <xdot,ydot,zdot>
    for a given target and center  at the specified time
  (time elapsed from JD0).
  The output is expressed according to unit.
  The target and center are expressed in the old or NAIF ID numbering system defined on unit.

  return 0 on error.
  return 1 on success.

   @param eph (inout) ephemeris file descriptor
   @param JD0 (in) reference time (could be 0)
   @param time (in) time elapsed from JD0
   @param target (in) "target" object (NAIF or old numbering system)
   @param center (in) "center" object (NAIF or old numbering system)
   @param unit (in) sum of CALCEPH_UNIT_??? and /or CALCEPH_USE_NAIFID
   If unit& CALCEPH_USE_NAIFID !=0 then NAIF identification numbers are used
   If unit& CALCEPH_USE_NAIFID ==0 then old identification numbers are used
   @param order (in) order of the computation
   =0 : Positions are  computed
   =1 : Position+Velocity  are computed
   =2 : Position+Velocity+Acceleration  are computed
   =3 : Position+Velocity+Acceleration+Jerk  are computed
   @param PV (out) quantities of the "target" object
   PV[0:3*(order+1)-1] are valid
*/
/*--------------------------------------------------------------------------*/
int calceph_spice_compute_unit(struct calcephbin_spice *eph, double JD0, double time, int target,
                               int center, int unit, int order, double PV[ /*<=12 */ ])
{
    int target_spiceid;

    int center_spiceid;

    int newunit;

    int res;

    if ((unit & CALCEPH_USE_NAIFID) == 0)
    {
        newunit = unit;
        target_spiceid = calceph_spice_convertid_old2spiceid_id(eph, target);
        if (target_spiceid == -1)
        {
            fatalerror("Target object %d is not supported or is not available in the file.\n", target);
            return 0;
        }
        if (target == LIBRATIONS + 1)
        {
            return calceph_spice_orient_unit_spiceid(eph, JD0, time, target_spiceid, newunit, order, PV);
        }
        else
        {
            center_spiceid = calceph_spice_convertid_old2spiceid_id(eph, center);
            if (target == TTMTDB + 1 || target == TCGMTCB + 1)
                center_spiceid = NAIFID_TIME_CENTER;
            else if (center_spiceid == -1)
            {
                fatalerror("Center object %d is not supported  or is not available in the file.\n", center);
                return 0;
            }
        }
    }
    else
    {
        target_spiceid = target;
        center_spiceid = center;
        newunit = unit - CALCEPH_USE_NAIFID;
    }
    res = calceph_spice_compute_unit_spiceid(eph, JD0, time, target_spiceid, center_spiceid, newunit, order, PV);
#if DEBUG
    if (res <= 0)
        printf("spicetarget=%d %d spicecenter=%d %d\n", target_spiceid, target, center_spiceid, center);
#endif
    return res;
}
