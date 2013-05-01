/* hinv.c   Inverse H-transform of NX x NY integer image
 *
 * Programmer: R. White         Date: 9 May 1991
 * Modified by J. Doggett, 7 December 1993
 *         to add <stdlib.h> include for standard function prototypes
 * Modified by R. White, 14 September 1994
 *         to make faster
 */

/******************************************************************************
* Copyright (c) 1993, 1994, Association of Universities for Research in
* Astronomy, Inc.  All Rights Reserved.
* Produced under National Aeronautics and Space Administration grant
* NAG W-2166.
******************************************************************************/

#include <stdlib.h>
#include <string.h>
#include "errcode.h"
#ifndef int32_t
   #define int32_t long
#endif


static void xunshuffle( int *tmp, int *a, const int nx, const int ny,
                                                        const int nydim);
static void yunshuffle( int *tmp, int *a, const int nx, const int ny,
                                                        const int nydim);

#ifdef __WATCOMC__
#define ZKEY_CLOCK  (*(long *)((long)0x46c))
#else
#define ZKEY_CLOCK  0
#endif

extern int32_t times[];

extern int hinv( int a[], const int nx, const int ny)
{
   int log2n, i, k;
   int nxtop,nytop,nxf,nyf,c;
   int h0, hx, hy, hc, sum1, sum2;
   int *p00, *p10, *pend, *shuffle_tmp;
   const int nmax = (nx>ny) ? nx : ny;

   /* log2n is log2 of max(nx,ny) rounded up to next power of 2    */
   log2n = 0;
   while( nmax > (1 << log2n))
      log2n++;

   /*
    * do log2n expansions
    *
    * We're indexing a as a 2-D array with dimensions (nx,ny).
    */
   nxtop = 1;
   nytop = 1;
   nxf = nx;
   nyf = ny;
   c = 1 << log2n;
   shuffle_tmp = (int *) malloc(2*ny*sizeof(int) + nx);
   if( !shuffle_tmp)
      return( DSS_IMG_ERR_XUNSHUFFLE);
   for( k = log2n-1; k > 0; k--)
      {
      /*
       * this somewhat cryptic code generates the sequence
       * ntop[k-1] = (ntop[k]+1)/2, where ntop[log2n] = n
       */
      c = c>>1;
      nxtop = nxtop<<1;
      nytop = nytop<<1;
      if (nxf <= c)
         nxtop--;
      else
         nxf -= c;
      if (nyf <= c)
         nytop --;
      else
         nyf -= c;
      /*
       * unshuffle in each dimension to interleave coefficients
       */
      xunshuffle( shuffle_tmp, a, nxtop, nytop, ny);
      yunshuffle( shuffle_tmp, a, nxtop, nytop, ny);
      for( i = 0; i<nxtop-1; i += 2)
         {
         pend = &a[ny*i+nytop-1];
         for (p00 = &a[ny*i], p10 = p00+ny;
                              p00 < pend; p00 += 2, p10 += 2)
            {
            h0 = *(p00  );
            hx = *(p10  );
            hy = *(p00+1);
            hc = *(p10+1);
            /*
             * Divide sums by 2
             */
            sum1 = h0+hx+1;
            sum2 = hy+hc;
            *(p10+1) = (sum1 + sum2) >> 1;
            *(p10  ) = (sum1 - sum2) >> 1;
            sum1 = h0-hx+1;
            sum2 = hy-hc;
            *(p00+1) = (sum1 + sum2) >> 1;
            *(p00  ) = (sum1 - sum2) >> 1;
            }
         if( p00==pend)
            {
            /*
             * do last element in row if row length is odd
             * p00+1, p10+1 are off edge
             */
            h0 = *(p00  );
            hx = *(p10  );
            *p10 = (h0 + hx + 1) >> 1;
            *p00 = (h0 - hx + 1) >> 1;
            }
         }
      if( i<nxtop)
         {
         /*
          * do last row if column length is odd
          * p10, p10+1 are off edge
          */
         pend = &a[ny*i+nytop-1];
         for (p00 = &a[ny*i]; p00 < pend; p00 += 2)
            {
            h0 = *(p00  );
            hy = *(p00+1);
            *(p00+1) = (h0 + hy + 1) >> 1;
            *(p00  ) = (h0 - hy + 1) >> 1;
            }
              /* do corner element if both row and column lengths
               * are odd p00+1, p10, p10+1 are off edge
               */
         if (p00==pend)
            *p00 = (*p00 + 1) >> 1;
         }
      }
   /*
    * Last      pass (k=0) has some differences:
    *
    * Shif     t by 2 instead of 1
    *
   * Use e     xplicit values for all variables to avoid unnecessary shifts etc:
    *
    *   N         bitN maskN prndN nrndN
    *   0          1    -1     0     0  (note nrnd0 != prnd0-1)
    *   1          2    -2     1     0
    *   2          4    -4     2     1
    */

   /*
    * Check nxtop=nx, nytop=ny
    */
   c = c>>1;
   nxtop = nxtop<<1;
   nytop = nytop<<1;
   if (nxf <= c)
      nxtop -= 1;
   else
      nxf -= c;
   if (nyf <= c)
      nytop -= 1;
   else
      nyf -= c;
   if (nxtop != nx || nytop != ny)
      {
      free( shuffle_tmp);
      return( DSS_IMG_ERR_HINV);
      }
   /*
    * unshuffle in each dimension to interleave coefficients
    */
   xunshuffle( shuffle_tmp, a, nx, ny, ny);
   yunshuffle( shuffle_tmp, a, nx, ny, ny);
   free( shuffle_tmp);
   for (i = 0; i<nx-1; i += 2)
      {
      pend = &a[ny*i+ny-1];
      for( p00 = &a[ny*i], p10 = p00+ny;
                   p00 < pend; p00 += 2, p10 += 2)
         {
         h0 = *(p00  );
         hx = *(p10  );
         hy = *(p00+1);
         hc = *(p10+1);
         /*
          * Divide sums by 4
          */
         sum1 = h0+hx+2;
         sum2 = hy+hc;
         *(p10+1) = (sum1 + sum2) >> 2;
         *(p10  ) = (sum1 - sum2) >> 2;
         sum1 = h0-hx+2;
         sum2 = hy-hc;
         *(p00+1) = (sum1 + sum2) >> 2;
         *(p00  ) = (sum1 - sum2) >> 2;
         }
      if (p00==pend)
         {
         /*
          * do last element in row if row length is odd
          * p00+1, p10+1 are off edge
          */
         h0 = *p00;
         hx = *p10;
         *p10 = (h0 + hx + 2) >> 2;
         *p00 = (h0 - hx + 2) >> 2;
         }
      }
   if( i<nx)
      {
      /*
       * do last row if column length is odd
       * p10, p10+1 are off edge
       */
      pend = &a[ny*i+ny-1];
      for (p00 = &a[ny*i]; p00 < pend; p00 += 2)
         {
         h0 = *(p00  );
         hy = *(p00+1);
         *(p00+1) = (h0 + hy + 2) >> 2;
         *(p00  ) = (h0 - hy + 2) >> 2;
         }
          /* do corner element if both row and column lengths are odd
               * p00+1, p10, p10+1 are off edge: */
      if (p00==pend)
         *p00 = (*p00 + 2) >> 2;
      }
   return( 0);
}

/* int *tmp;   temporary space for shuffling elements */
/* int a[];    array to unshuffle                   */
/* int nx;     number of elements in column         */
/* int ny;     number of elements in row            */
/* int nydim;  physical length of row in array      */
static void xunshuffle( int *tmp, int *a, const int nx, const int ny,
                                                        const int nydim)
{
   int j;
   int nhalf;
   int *p1, *p2, *pt, *pend;
   int32_t t0 = ZKEY_CLOCK;

   nhalf = (ny+1)>>1;
   for (j = 0; j<nx; j++)
      {
      /* unshuffle(&a[nydim*j],ny,1,tmp); */

      /*
       * copy 2nd half of array to tmp
       */
      memcpy(tmp, &a[j*nydim+nhalf], (ny-nhalf)*sizeof(int));
      /*
       * distribute 1st half of array to even elements
       */
      pend = &a[j*nydim];
      for (p2 = &a[j*nydim+nhalf-1], p1 = &a[j*nydim+((nhalf-1)<<1)];
                      p2 >= pend; p1 -= 2)
          *p1 = *p2--;
      /*
       * now distribute 2nd half of array (in tmp) to odd elements
       */
      pend = &a[j*nydim+ny];
      for (pt = tmp, p1 = &a[j*nydim+1]; p1<pend; p1 += 2)
          *p1 = *pt++;
      }
//   times[5] += ZKEY_CLOCK - t0;
}

/*
 * unshuffle in y direction: take even elements from beginning of
 * array, odd elements from end and interleave them.  This is done
 * using a somewhat complicated method for efficiency.  The straightforward
 * approach is slow because the scattered memory accesses don't
 * take advantage of the cache (I think.)  This version does
 * operations a row at a time so that consecutive memory locations
 * are accessed.
 */

/* int *tmp;   temporary space for shuffling elements */
/* int a[];    array to unshuffle                           */
/* int nx;     number of elements in column         */
/* int ny;     number of elements in row            */
/* int nydim;  actual length of row in array        */

static void yunshuffle( int *tmp, int *a, const int nx, const int ny,
                                                        const int nydim)
{
   int j, k, oddoffset, *swap;
   unsigned char *flag;
   int32_t t0 = ZKEY_CLOCK;

   swap = tmp + ny;
   flag = (unsigned char *)( swap + ny);
   /*
    * initialize flag array telling whether row is done
    */
   for (j=0; j<nx; j++) flag[j] = 1;
   oddoffset = (nx+1)/2;
   /*
    * shuffle each row to appropriate location
    * row 0 is already in right location
    */
   for (j=1; j<nx; j++)
      if (flag[j])
         {
         flag[j] = 0;
         /*
          * where does this row beint32_t?
          */
         if (j >= oddoffset)     /* odd row */
            k = ((j-oddoffset)<<1) + 1;
         else                   /* even row */
            k = j<<1;
         if (j != k)
            {
                 /* copy the row  */
            memcpy(tmp,&a[nydim*j],ny*sizeof(int));
            while (flag[k])
               {
               flag[k] = 0;
               /*
                * do the exchange
                */
               memcpy( swap, a+nydim*k, ny * sizeof( int));
               memcpy( a+nydim*k, tmp, ny * sizeof( int));
               memcpy( tmp, swap, ny * sizeof( int));
               if (k >= oddoffset)
                  k = ((k-oddoffset)<<1) + 1;
               else
                  k = k<<1;
               }
               /*
                * copy the last row into place
                * this should always end up with j=k
                */
            memcpy(&a[nydim*k],tmp,ny*sizeof(int));
/*          if (j != k)                */
/*             return( -2);            */
            }
         }
//   times[6] += ZKEY_CLOCK - t0;
}
