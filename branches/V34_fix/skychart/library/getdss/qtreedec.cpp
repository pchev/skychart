/* qtree_decode.c     Read stream of codes from infile and construct bit planes
 *                        in quadrant of 2-D array using binary quadtree coding
 *
 * Programmer: R. White         Date: 7 May 1991
 *
 * Modified by R. White, 18 June 1992, to use better VMS I/O routines.
 *
 * Modified by J. Doggett 7 December 1993,
 *         to add <stdlib.h> library for standard function prototypes;
 *         to add prototype for input_bit function.
 *
 * Modified by R. White, 14 September 1994, to speed up using new algorithm
 */

/******************************************************************************
* Copyright (c) 1993, 1994, Association of Universities for Research in
* Astronomy, Inc.  All Rights Reserved.
* Produced under National Aeronautics and Space Administration grant
* NAG W-2166.
******************************************************************************/

#include <stdlib.h>
#include <string.h>
#include "bitfile.h"
#include "errcode.h"

/*
 * address buffer type (can be unsigned char because image size < 512 pixels)
 */
typedef unsigned char ADDRTYPE;

static int qaddr_expand( BITFILE *infile, ADDRTYPE *xthis, ADDRTYPE *ythis,
    int nt, ADDRTYPE *xnext, ADDRTYPE *ynext, ADDRTYPE *xscr, ADDRTYPE *yscr);
static void qaddr_bitins( BITFILE *infile,
                    const ADDRTYPE *xthis, const ADDRTYPE *ythis,
                    int nt, int a[], const int n, const int bit);
static void read_bdirect( BITFILE *infile, int b[],
                                   int n, int nx, const int ny, const int bit);
static int input_huffman( BITFILE *infile);

int qtree_decode( BITFILE *infile, int a[], const int n, const int nqx,
                             const int nqy, const int nbitplanes)
{
/*
 * address buffers
 */
   ADDRTYPE *xaddr1, *xaddr2, *yaddr1, *yaddr2, *xscr, *yscr;
   int log2n, k, bit;
   int err_code = 0;
   const int nqx2=(nqx+1)/2;
   const int nqy2=(nqy+1)/2;
   const int nqmax = (nqx>nqy) ? nqx : nqy;
   const int size_addr1 = nqx2 * nqy2;
   const int size_addr2 = ((nqx2 + 1) / 2) * ((nqy2 + 1) / 2);
   const int size_scr = nqmax;

      /* log2n is log2 of max(nqx,nqy) rounded up to next power of 2 */
   log2n = 0;
   while( nqmax > (1 << log2n))
      log2n++;

      /*  allocate buffers for addresses... there are six buffers involved, */
      /*  and the following code just allocates one "megabuffer" and splits */
      /*  it up.  This simplifies error handling and similar tasks:  we    */
      /*  only have to check that _one_ buffer is allocated and freed.     */

   xaddr1 = (ADDRTYPE *) malloc( 2 * (size_addr1 + size_addr2 + size_scr)
                                             * sizeof( ADDRTYPE));
   if( !xaddr1)
      return( DSS_IMG_ERR_QTREE_MEM);

   yaddr1 = xaddr1 + size_addr1;
   xaddr2 = yaddr1 + size_addr1;
   yaddr2 = xaddr2 + size_addr2;
   xscr   = yaddr2 + size_addr2;
   yscr   = xscr   + size_scr;

   /* now decode each bit plane, starting at the top  */
   /* A is assumed to be initialized to zero          */

   for( bit = nbitplanes-1; !err_code && bit >= 0; bit--)
      {
      int b = input_nybble( infile);

      if( !b)  /* bit map was written directly */
         read_bdirect( infile, a, n, nqx, nqy, bit);
      else if (b != 0xf)
         err_code = DSS_IMG_ERR_TILE_ERR;
      else
         {
         /* bitmap was quadtree-coded, do log2n expansions...
                             read first code: */
         b = input_huffman( infile);
              /* if code is zero, implying all bits are zero, just
                 skip the rest for this plane */
         if( b)
            {
            ADDRTYPE *xthis, *ythis, *xnext, *ynext;
            int nt = 0;

               /* initialize pointers to buffer pairs
                  want to end up writing to buffer 1 */
            if( !(log2n & 1))
               {
               xthis = xaddr1;
               ythis = yaddr1;
               xnext = xaddr2;
               ynext = yaddr2;
               }
            else
               {
               xthis = xaddr2;
               ythis = yaddr2;
               xnext = xaddr1;
               ynext = yaddr1;
               }
            nt = 0;
            if( b & 1) { xthis[nt] = 1; ythis[nt++] = 1; }
            if( b & 2) { xthis[nt] = 0; ythis[nt++] = 1; }
            if( b & 4) { xthis[nt] = 1; ythis[nt++] = 0; }
            if( b & 8) { xthis[nt] = 0; ythis[nt++] = 0; }

     /* now do log2n expansions, reading codes from file as necessary */
            for (k = 1; k<log2n-1; k++)
               {
               ADDRTYPE *ptmp;

               nt = qaddr_expand( infile, xthis, ythis, nt,
                       xnext, ynext, xscr, yscr);
               /* swap buffers */
               ptmp  = xthis; xthis = xnext; xnext = ptmp;
               ptmp  = ythis; ythis = ynext; ynext = ptmp;
               }

      /* now copy last set of 4-bit codes to bitplane bit of array a */
            qaddr_bitins( infile, xthis, ythis, nt, a, n, bit);
            }
         }
      if( !err_code && infile->error_code)
         err_code = DSS_IMG_ERR_READING_TILE;
      }
   free( xaddr1);
   return( err_code);
}


/*
 * do one quadtree address expansion step
 * current address list in xthis, ythis is expanded and put into xnext, ynext
 * return value is new number of elements
 */
static int qaddr_expand( BITFILE *infile, ADDRTYPE *xthis, ADDRTYPE *ythis,
    int nt, ADDRTYPE *xnext, ADDRTYPE *ynext, ADDRTYPE *xscr, ADDRTYPE *yscr)
{
   int b, i, j, k, m;
   ADDRTYPE ylast, xoff, yoff;

   /*
    * read 1 quad for each element of xthis,ythis
    * keep second row expansions in xscr,yscr and copy them to next buffer
    * after each row is finished.
    */
   ylast = ythis[0];
   k = 0;
   for (i = 0, j = 0; i < nt; i++)
      {
      if (ylast != ythis[i])
         {
         for (m = 0; m < k; m++, j++)
            {
            xnext[j] = xscr[m];
            ynext[j] = yscr[m];
            }
         k = 0;
         ylast = ythis[i];
         }
      b = input_huffman(infile);
      xoff = xthis[i] << 1;
      yoff = ythis[i] << 1;
      if( b & 1) { xnext[j] = xoff | 1; ynext[j++] = yoff | 1; }
      if( b & 2) { xnext[j] = xoff    ; ynext[j++] = yoff | 1; }
      if( b & 4) { xscr[k]  = xoff | 1; yscr[k++]  = yoff    ; }
      if( b & 8) { xscr[k]  = xoff    ; yscr[k++]  = yoff    ; }
      }
   memcpy( xnext + j, xscr, k);
   memcpy( ynext + j, yscr, k);
   return( j + k);
}

/*
 * Read quads and insert in address locations in bitplane BIT of array A.
 */
static void qaddr_bitins( BITFILE *infile,
                    const ADDRTYPE *xthis, const ADDRTYPE *ythis,
                    int nt, int a[], const int n, const int bit)
{
   const int bitval = 1 << bit;

   while( nt--)
      {
      int b = input_huffman( infile);
      int *p = a + 2 * (n * *ythis + *xthis);

      if( b & 8) p[0]   |= bitval;
      if( b & 4) p[1]   |= bitval;
      if( b & 2) p[n]   |= bitval;
      if( b & 1) p[n+1] |= bitval;
      xthis++;
      ythis++;
      }
}

/*
 * Read 4-bit codes from infile, expanding each value to 2x2 pixels and
 * inserting into bitplane BIT of B.
 */
static void read_bdirect( BITFILE *infile, int b[],
                                   int n, int nx, const int ny, const int bit)
{
   const int bitval = 1 << bit;

   while( nx > 0)
      {
      int *p00 = b;
      int *pend =p00 + ny;

      while( p00 < pend)
         {
         int tmp = input_nybble(infile);

         if( tmp & 8) p00[0]   |= bitval;
         if( tmp & 4) p00[1]   |= bitval;
         if( tmp & 2) p00[n]   |= bitval;
         if( tmp & 1) p00[n+1] |= bitval;
         p00 += 2;
         }
      b += n + n;
      nx -= 2;
      }
}

/*
 * Huffman decoding for fixed codes
 *
 * Coded values range from 0-15
 *
 * Huffman code values (hex):
 *
 *      3e, 00, 01, 08, 02, 09, 1a, 1b,
 *      03, 1c, 0a, 1d, 0b, 1e, 3f, 0c
 *
 * and number of bits in each code:
 *
 *      6,  3,  3,  4,  3,  4,  5,  5,
 *      3,  5,  4,  5,  4,  5,  6,  4
 *
 * In terms of six-bit codes:
 *
 *    111110 = 0    011xxx =  8       000xxx =  1    1100xx = 15
 *    000xxx = 1    11100x =  9       001xxx =  2    11010x =  6
 *    001xxx = 2    1010xx = 10       010xxx =  4    11011x =  7
 *    1000xx = 3    11101x = 11       011xxx =  8    11100x =  9
 *    010xxx = 4    1011xx = 12       1000xx =  3    11101x = 11
 *    1001xx = 5    11110x = 13       1001xx =  5    11110x = 13
 *    11010x = 6    111111 = 14       1010xx = 10    111110 =  0
 *    11011x = 7    1100xx = 15       1011xx = 12    111111 = 14
 */

/*
 * table of Huffman code translated values
 * -1 means no such code
 */
static const int tabhuff[31] =
        /* 00  01  02  03  04  05  06  07  08  09  0a  0b  0c  0d  0e  0f */
         {  1,  2,  4,  8, -1, -1, -1, -1,  3,  5, 10, 12, 15, -1, -1, -1,
           -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  6,  7,  9, 11, 13     };
        /* 10  11  12  13  14  15  16  17  18  19  1a  1b  1c  1d  1e     */

static int input_huffman( BITFILE *infile)
{
   int c;

   /*
    * get first 3 bits to start
    */
   c = input_nbits(infile,3);
   if (c < 4)
      return( tabhuff[c]);
   /*
    * get the next bit
    */
   c = input_bit( infile) | (c<<1);
   if( c < 13) return( tabhuff[c]);
   /*
    * get yet another bit
    */
   c = input_bit( infile) | (c<<1);
   if (c < 31)
      return( tabhuff[c]);

   /*
    * the 6th bit decides
    */
   if( input_bit( infile))  /* c = 63 */
      return( 14);
   else  /* c = 62 */
      return( 0);
}
