/* dodecode.c   Decode stream of characters on infile and return array
 *
 * This version encodes the different quadrants separately
 *
 * Programmer: R. White         Date: 9 May 1991
 *
 * Modified by R. White, 18 June 1992, to use better VMS I/O routines.
 *
 * Modified by J. Doggett, 7 December 1993,
 *         to add <stdlib.h> include for standard function prototypes.
 *         to add input_nbits prototype.
 */

/******************************************************************************
* Copyright (c) 1993, 1994, Association of Universities for Research in
* Astronomy, Inc.  All Rights Reserved.
* Produced under National Aeronautics and Space Administration grant
* NAG W-2166.
******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "bitfile.h"
#include "errcode.h"

int dss_debug_printf( const char *format, ...);        /* extr_fit.cpp */

int qtree_decode( BITFILE *infile, int a[], int n,
                                         int nqx, int nqy, int nbitplanes);

/* int a[];                     Array of values to decode            */
/* int nx,ny;                   Array dimensions are [nx][ny]        */
/* unsigned char nbitplanes[3]; Number of bit planes in quadrants    */

int dodecode( BITFILE *infile, int *a, const int nx, const int ny,
                                           const unsigned char *nbitplanes)
{
   int i, nel, nx2, ny2, rval;

   nel = nx*ny;
   nx2 = (nx+1)/2;
   ny2 = (ny+1)/2;

   /* initialize a to zero */
   memset( a, 0, nel * sizeof( int));

   /* Initialize bit input */
   infile->bit_loc = 0;

   /* read bit planes for each quadrant */
   dss_debug_printf( "qtree_decoding ");
   rval = qtree_decode(infile, a,         ny, nx2,  ny2,  nbitplanes[0]);
   dss_debug_printf( "1 ");
   if( !rval)
      rval = qtree_decode(infile, a + ny2,    ny, nx2,  ny/2, nbitplanes[1]);
   dss_debug_printf( "2 ");
   if( !rval)
      rval = qtree_decode(infile, a + ny*nx2, ny, nx/2, ny2,  nbitplanes[1]);
   dss_debug_printf( "3 ");
   if( !rval)
      rval = qtree_decode(infile, a + ny*nx2 +ny2,
                                              ny, nx/2, ny/2, nbitplanes[2]);
   dss_debug_printf( "rval %d, ", rval);
   if( rval)
      return( rval);
   /* make sure there is an EOF symbol (nybble=0) at end    */
   if( input_nybble(infile))
      rval = DSS_IMG_ERR_NO_EOF;
   else
      {
               /*
                * now get the sign bits
                * Re-initialize bit input
                */
      dss_debug_printf( "getting ");
      infile->bit_loc = 0;
      for( i = 0; i < nel; i++)
         if( a[i])
            if( input_bit( infile))
               a[i] = -a[i];
      if( infile->error_code)
         rval = DSS_IMG_ERR_READING_SIGN_BITS;
      dss_debug_printf( "sign bits, ");
      }
   return( rval);
}
