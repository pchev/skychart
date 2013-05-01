#include <stdlib.h>
#include <stdio.h>

extern int hinv( int a[], const int nx, const int ny);
int dss_debug_printf( const char *format, ...);        /* extr_fit.cpp */
int decode( int filesize, char *file_buff,
                             int **a, int *nx, int *ny, int *scale);

#ifdef __WATCOMC__
#define ZKEY_CLOCK  (*(long *)((long)0x46c))
#else
#define ZKEY_CLOCK  0
#endif

extern int32_t times[];

        /* (*a)[nx][ny] is the image array  */
        /* Note that ny is the fast-varying dimension   */
        /* 'filename' is name of input file  */

extern int hdecompress( int **a, int *nx, int *ny, int filesize,
                            char *file_buff)
{
   int scale, rval;
   int32_t t0;

   t0 = ZKEY_CLOCK;
   dss_debug_printf( "decode, ");
   rval = decode( filesize, file_buff, a, nx, ny, &scale);
//   times[1] += ZKEY_CLOCK - t0;
   if( rval)
      return( rval);

   t0 = ZKEY_CLOCK;
   dss_debug_printf( "scale, ");
   if( scale > 1)
      {
      int *p = *a, *endptr = p + (*nx) * (*ny);

      while( p < endptr)
         *p++ *= scale;
      }
//   times[2] += ZKEY_CLOCK - t0;

   dss_debug_printf( "hinv, ");
   t0 = ZKEY_CLOCK;
   rval = hinv( *a,*nx,*ny);           /* Inverse H-transform  */
//   times[3] += ZKEY_CLOCK - t0;
   dss_debug_printf( "done. ");
   return( rval);
}

#ifdef EXAMPLE_OF_HDECOMPRESS_USE

#include <stdio.h>

void main( int argc, char **argv)
{
   int nx, ny, *data;

#ifdef __WATCOMC__
   setvbuf( stdout, NULL, _IONBF, 0);
#endif
   printf( "Starting\n");
   hdecompress( &data, &nx, &ny, argv[1]);
   printf( "All done...%d x %d\n", nx, ny);
   free( data);
}
#endif
