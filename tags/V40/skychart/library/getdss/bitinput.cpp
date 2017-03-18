#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "bitfile.h"

/* INPUT A BIT */

int dss_debug_printf( const char *format, ...);        /* extr_fit.cpp */

int input_bit( BITFILE *infile)
{
   int rval;

   if( !infile->bit_loc)      /* gotta read the next byte */
      {
      if( infile->loc == infile->endptr - 1)
                           /* attempt to read past EOF */
         infile->error_code = -1;
      else
         {
         infile->bit_loc = 8;
         infile->loc++;
         }
      }
   if( infile->error_code)
      {
      dss_debug_printf( "DANGER! (1)\n");
      exit( -1);
      }
   infile->bit_loc--;
   rval = (infile->loc[0] >> infile->bit_loc) & 1;
   return( rval);
}

int input_nbits( BITFILE *infile, const int n)
{
   int rval;

   if( (int)infile->bit_loc >= n)
      rval = infile->loc[0];
   else
      if( infile->loc == infile->endptr - 1)
         {                 /* attempt to read past EOF */
         infile->error_code = -1;
         dss_debug_printf(  "DANGER! (2)\n");
         exit( -2);
         rval = 0;
         }
      else          /* crosses an 8-bit boundary */
         {
         rval = (infile->loc[0] << 8) | infile->loc[1];
         infile->loc++;
         infile->bit_loc += 8;
         }
   infile->bit_loc -= n;
   /* clear higher bits    */
   return( (rval >> infile->bit_loc) & ((1<<n)-1) );
}
