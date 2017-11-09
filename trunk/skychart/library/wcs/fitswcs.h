/*** File fitswcs.h  FITS header WCS access subroutines
 *** September 24, 2013
 *** By Jessica Mink, jmink@cfa.harvard.edu
 *** Harvard-Smithsonian Center for Astrophysics
 *** Copyright (C) 1996-2013
 *** Smithsonian Astrophysical Observatory, Cambridge, MA, USA

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.
    
    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

    Correspondence concerning WCSTools should be addressed as follows:
           Internet email: jmink@cfa.harvard.edu
           Postal address: Jessica Mink
                           Smithsonian Astrophysical Observatory
                           60 Garden St.
                           Cambridge, MA 02138 USA
 */

#ifndef fitswcs_h_
#define fitswcs_h_
#include "fitsfile.h"
#include "wcs.h"

#ifdef __cplusplus /* C++ prototypes */
extern "C" {
#endif


#ifdef __STDC__   /* Full ANSI prototypes */

/* Subroutines in fitswcs.c */

    /* Open a FITS or IRAF image file and return its WCS structure */
    struct WorldCoor *GetWCSFITS (
	char *filename,	/* FITS or IRAF file filename */
	int verbose);	/* Print extra information if nonzero */

    /* Open a FITS or IRAF image file and return a FITS header */
    char *GetFITShead (
	char *filename,	/* FITS or IRAF file filename */
	int verbose);	/* Print error messages if nonzero */

    /* Delete all standard WCS keywords from a FITS header */
    /* and return the number of header keywords deleted */
    int DelWCSFITS (
	char *header,	/* FITS header to edit */
	int verbose);	/* Print error messages if nonzero */

    /* Check the WCS fields, print any that are found if verbose > 0, */
    /* and return 0 if all are found, else -1 */
    int PrintWCS (
	char *header,	/* FITS header to read */
	int verbose);	/* Print WCS keyword values if nonzero */

    /* Set FITS C* fields, assuming RA/DEC refers to the reference pixel, CRPIX1/CRPIX2 */
    void SetFITSWCS (
	char *header,	/* FITS header to edit */
	struct WorldCoor *wcs);  /* WCS structure */

#else /* K&R prototypes */

/* Subroutines in fitswcs.c */
/* Open a FITS or IRAF image file and return its WCS structure */
extern struct WorldCoor *GetWCSFITS();
/* Open a FITS or IRAF image file and return a FITS header */
extern char *GetFITShead();
/* Delete all standard WCS keywords from a FITS header */
extern int DelWCSFITS();
/* Check the WCS fields and print any that are found if verbose */
extern int PrintWCS();
/* Set FITS C* fields, assuming RA/DEC is at the reference pixel, CRPIX1/CRPIX2 */
extern void SetFITSWCS();


#endif  /* __STDC__ */

#ifdef __cplusplus
}
#endif  /* __cplusplus */

#endif /* fitswcs_h_ */

/* Sep 24 2013	New header file for access to middleman subroutines
 */
