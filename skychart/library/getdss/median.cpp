#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#define PIXEL unsigned short

/* A little test program I wrote before implementing the following
function in 'getpiece.cpp',  just to make sure the algorithm was
really okay.   */

static PIXEL find_nth_pixel( PIXEL *pixels, int n_pixels, int nth)
{
   while( n_pixels > 1)
      {
      int i = 1, j = n_pixels - 1, tval;

      printf( "Before sorting: %d pixels,  looking for %d\n", n_pixels, nth);
      for( i = 0; i < n_pixels; i++)
         printf( "%6u", pixels[i]);
      i = 1;

      while( i <= j)
         {
         while( i <= j && pixels[i] <= pixels[0])
            i++;
         while( i <= j && pixels[j] > pixels[0])
            j--;
         if( i < j)
            {
            tval = pixels[i];
            pixels[i] = pixels[j];
            pixels[j] = tval;
            }
         }
      printf( "\nAfter sorting: i = %d\n", i);
      for( j = 0; j < n_pixels; j++)
         printf( "%6u", pixels[j]);
      printf( "\n");
      if( i == nth + 1)
         return( pixels[0]);
      else if( i > nth + 1)
         {
         pixels++;
         n_pixels = i - 1;
         }
      else
         {
         pixels += i;
         n_pixels -= i;
         nth -= i;
         }
      }
   return( pixels[0]);
}

void main( int argc, char **argv)
{
   int n_pixels = atoi( argv[1]), nth = atoi( argv[2]), i;
   PIXEL arr[20];

   srand( (unsigned)atoi( argv[3]));
   for( i = 0; i < n_pixels; i++)
      arr[i] = (PIXEL)rand( );
   printf( "Result: %u\n", find_nth_pixel( arr, n_pixels, nth));
}
