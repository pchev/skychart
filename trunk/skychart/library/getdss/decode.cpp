#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "bitfile.h"
#include "errcode.h"

int dodecode( BITFILE *infile, int *a, const int nx, const int ny,
                                           const unsigned char *nbitplanes);
int dss_debug_printf( const char *format, ...);        /* extr_fit.cpp */

static int32_t readint32( BITFILE *bfile)
{
   uint8_t b[4];

#ifdef WRONG_WAY_BYTE_ORDER
               /* For Suns and similar wrong-endian computers */
    b[0] = *bfile->loc++;
    b[1] = *bfile->loc++;
    b[2] = *bfile->loc++;
    b[3] = *bfile->loc++;
#else
    b[3] = *bfile->loc++;
    b[2] = *bfile->loc++;
    b[1] = *bfile->loc++;
    b[0] = *bfile->loc++;
#endif
    return( *(int32_t *)b);
}

/* int **a;             address of output array [nx][ny]     */
/* int *nx,*ny;         size of output array                 */
/* int *scale;          scale factor for digitization        */
int decode( int filesize, char *file_buff,
                             int **a, int *nx, int *ny, int *scale)
{
   int sumall, errcode;
   unsigned char nbitplanes[3];
   BITFILE bfile;

   dss_debug_printf( "2, ");
   bfile.length = filesize;
   bfile.buff = (unsigned char *)file_buff;
        /*
         * check magic value in first two bytes
         */
   if( bfile.buff[0] != (unsigned char)0xdd ||
       bfile.buff[1] != (unsigned char)0x99)
      return( DSS_IMG_ERR_BAD_TILE);
   dss_debug_printf( "3, ");
   bfile.loc = bfile.buff + 2;
   bfile.endptr = bfile.buff + bfile.length;
   bfile.error_code = 0;

   *nx = readint32( &bfile);    /* x size of image               */
   *ny = readint32( &bfile);    /* y size of image               */
   *scale = readint32( &bfile); /* scale factor for digitization */
   dss_debug_printf( "getting a %dx%d block, ", *nx, *ny);
   /*
    * allocate memory for array
    */
   *a = (int *)malloc( (*nx) * (*ny + 1) * sizeof( int));
   if( !a)
      return( DSS_IMG_ERR_ALLOC_TILE);
   dss_debug_printf( "alloced, ");
   sumall = readint32( &bfile);                     /* sum of all pixels  */
   memcpy( nbitplanes, bfile.loc, sizeof(nbitplanes));
   bfile.loc += sizeof(nbitplanes);
   bfile.bit_loc = 0;
   bfile.loc--;
   dss_debug_printf( "dodecoding, ");
   errcode = dodecode( &bfile, *a, *nx, *ny, nbitplanes);
   /* put sum of all pixels back into pixel 0 */
   (*a)[0] = sumall;
   dss_debug_printf( "rval %d, ", errcode);
   return( errcode);
}
