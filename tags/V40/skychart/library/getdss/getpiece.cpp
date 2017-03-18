#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <stdint.h>
#include "platelst.h"
#include "get_dss.h"
#include "errcode.h"

#if defined( __linux__) || defined( __unix__) || defined( __APPLE__)
#define _CONSOLE
#endif

extern int hdecompress( int **a, int *nx, int *ny, int filesize,
                            char *file_buff);
int dss_debug_printf( const char *format, ...);        /* extr_fit.cpp */

   /* The following two globals are for use in providing a 'status' */
   /* indicator for the Windows version. */
int get_dss_tiles_done, get_dss_tiles_total;
int median_nth_pixel = -1;

#define PIXEL uint16_t

static PIXEL find_nth_pixel( PIXEL *pixels, int n_pixels, int nth)
{
   while( n_pixels > 1)
      {
      int i, j = n_pixels - 1, tval;

      if( n_pixels > 10)
         {
         const int mid = n_pixels / 2, end = j;
         int pivot = 0;

         if( pixels[0] > pixels[mid])
            {
            if( pixels[mid] > pixels[end])
               pivot = mid;
            else if( pixels[end] < pixels[0])
               pivot = end;
            }
         else
            {
            if( pixels[mid] < pixels[end])
               pivot = mid;
            else if( pixels[end] > pixels[0])
               pivot = end;
            }
         if( pivot)
            {
            tval = pixels[pivot];
            pixels[pivot] = pixels[0];
            pixels[0] = tval;
            }
         if( pixels[0] == pixels[j] && pixels[0] == pixels[mid])
            {
            for( i = 1; i < n_pixels && pixels[i] == pixels[0]; i++)
               ;
            if( i == n_pixels)      /* they're all the same! */
               return( pixels[0]);
            }
         }
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

/* Normally,  with subsamp=1 (every pixel used),  this function isn't    */
/* called.  When it _is_ called,  it currently takes the median value    */
/* from three pixels in each subsamp x subsamp-sized block.  As you can  */
/* see,  an 'averaging' option was also tried,  which just averages all  */
/* pixels in the block.  I tried this,  and was not very happy with the  */
/* results.  (In fact,  I'm not overjoyed with the median approach,      */
/* either... some more experimenting with subsampling methods might be a */
/* good idea,  maybe throwing in some code so that the user can specify  */
/* the method to be used.)                                               */

static void subsamp_row( PIXEL *tbuff, PIXEL *curr,
                                        const int xsize, const int subsamp)
{
   int k;
   const int subsamp2 = subsamp * subsamp;
   const int offset1 = subsamp / 2;
   const int offset2 = offset1 * xsize;
   const int offset3 = offset2 + offset1;
   PIXEL *iloc = curr;

   for( k = xsize / subsamp; k; k--, iloc += subsamp)
      {
      if( median_nth_pixel == -1)         /* averaging */
         {
         int oval = 0, i, j;
         PIXEL *tptr = iloc;

         for( i = subsamp; i; i--, tptr += xsize - subsamp)
            for( j = subsamp; j; j--)
               oval += (int)*tptr++;
         *curr++ = (PIXEL)( oval / subsamp2);
         }
      else if( median_nth_pixel == -2)    /* quick & dirty lowest value */
         {
         PIXEL oval = *iloc;

         if( oval > iloc[offset1])
            oval = iloc[offset1];
         if( oval > iloc[offset2])
            oval = iloc[offset2];
         if( oval > iloc[offset3])
            oval = iloc[offset3];
         *curr++ = oval;
         }
      else        /* a "true" median search */
         {
         int i;
         PIXEL *tptr = iloc, *median_ptr = tbuff;

         for( i = subsamp; i; i--)
            {
            memcpy( median_ptr, tptr, subsamp * sizeof( PIXEL));
            tptr += xsize;
            median_ptr += subsamp;
            }
         *curr++ = find_nth_pixel( tbuff, subsamp2, median_nth_pixel);
         }
      }
}

/* grab_realsky_chunk( ) is,  in some ways,  the heart of this version of */
/* GET_DSS.  It assumes you've figured out the plate you want to extract  */
/* from,  and that you want a region running from (x1, y1) to (x2, y2),   */
/* for a total of (x2 - x1) * (y2 - y1) pixels;  and that you want the    */
/* resulting pixels to be written to ofile.  If you wish,  you can also   */
/* 'subsample';  by default,  subsamp = 1 (use every pixel),  but you can */
/* set subsamp = 2 (for example) and skip every other pixel,  to reduce   */
/* the file size fourfold.  subsamp must be an even divisor of 500;  that */
/* is to say,  subsamp = 1, 2, 4, 5, 10, 20, 25, 50, 100, 125, 250, 500.  */
/* If histogram != NULL,  this function checks the image as it's created  */
/* and builds a 65536-entry histogram for it.                             */
/*    One minor complication in the code is that it builds the image in   */
/* bands of 500 pixels (corresponding to the 500x500 tiles of which       */
/* RealSky and DSS are made).  GETIMAGE as distributed by STScI takes a   */
/* simpler approach,  in which the whole image is loaded into memory.     */
/* The benefit of this more complex approach is that memory usage is much */
/* less.  A full plate,  14000x14000 pixels,  consumes a mere 14000 x 500  */
/* pixels of two bytes each,  or 14 MBytes.  Under the STScI approach,     */
/* 14000 * 14000 * 2 bytes,  or 392 MBytes,  are required.  I suspect      */
/* STScI uses sufficiently powerful machines that memory was not an issue. */
/* But we lowly PC users must be more cautious.                            */

int DLL_FUNC grab_realsky_chunk( const char *szDrive, const char *plate,
                               const int x1, const int y1,
                               const int x2, const int y2,
                               FILE *ofile, int subsamp, long *histogram)
{
   int xsize = x2 - x1, ytile, xtile, x, y, err_code = 0;
   PIXEL *tbuff = (PIXEL *)calloc( xsize, 500 * sizeof( PIXEL));
   FILE *lump_file;
   int xtile_start = x1 / 500;
   int ytile_start = y1 / 500;
   int xtile_end = (x2 + 499) / 500;
   int ytile_end = (y2 + 499) / 500;
   int n_tiles = (xtile_end - xtile_start) * (ytile_end - ytile_start);
   int counter = 0;
   char filename[256];   /*2001-12-10mn*/
   PIXEL *median_buff = NULL;
#ifdef _CONSOLE
   clock_t t0 = clock( );
   double t_elapsed, prev_t_elapsed = -100;
#endif

   get_dss_tiles_done = 0;            /* This is a global! */
   get_dss_tiles_total = n_tiles;     /* So is this        */
   dss_debug_printf( "In grab_realsky_chunk( )\n");
   if( !tbuff)       /* The above is apt to be an ENORMOUS buffer,  and */
      return( DSS_IMG_ERR_BIG_BUFFER);   /* can easily trip out memory */
   dss_debug_printf( "Buffer allocated; %d tiles needed\n", n_tiles);
   if( subsamp > 1 && median_nth_pixel)
      median_buff = (PIXEL *)calloc( subsamp * subsamp, sizeof( PIXEL));
   if( y1 < 0)                   /* Some blank lines at the top: */
      for( y = y1 / subsamp; y; y++)
         fwrite( tbuff, xsize / subsamp, sizeof( PIXEL), ofile);

               /* Try getting data from a .RSL ("RealSky Lump") file: */
   sprintf( filename, "%s.rsl", plate);
   lump_file = fopen( filename, "rb");
   /* also try to find the .RSL to the szDrive path */
   if( !lump_file)
     {
     sprintf( filename, "%s%s.rsl", szDrive, plate);
     lump_file = fopen( filename, "rb");
     }

   for( ytile = ytile_start; !err_code && ytile < ytile_end; ytile++)
      {
      int ypixel = ytile * 500;

      for( xtile = xtile_start; !err_code && xtile < xtile_end; xtile++)
         {
         int *data = NULL;
         int nx = 500, ny = 500, offset = 0, line_len, tbuff_start;

         if( xtile >= 0 && ytile >= 0 && xtile < 28 && ytile < 28)
            {
            FILE *ifile = NULL;
            size_t filesize = 0;

            if( lump_file)
               {
               uint32_t loc[2];
               size_t n_read;

               fseek( lump_file, 4L * (xtile + ytile * 28L), SEEK_SET);
               n_read = fread( loc, sizeof( uint32_t), 2, lump_file);
               assert( n_read == 2);
               filesize = loc[1] - loc[0];
               fseek( lump_file, loc[0], SEEK_SET);
               }
            else
               {       /* 12 Dec 2001: BJG: changed "ABC.." to "abc.." */
               const char *letters = "0123456789abcdefghijklmnopqrstuvwxyz";
               int iter;

#if defined( __linux__) || defined( __unix__) || defined( __APPLE__)
               sprintf( filename, "%s/%s/%s.%c%c", szDrive, plate, plate,
                                 letters[ytile], letters[xtile]);
#else   /* DOS/Windows version: */
               sprintf( filename, "%s%s\\%s.%c%c", szDrive, plate, plate,
                                 letters[ytile], letters[xtile]);
#endif
               ifile = fopen( filename, "rb");
               assert( ifile);
               for( iter = 3; iter && !ifile; iter--)
                  {
                  time_t t = time( NULL);

                  printf( "Failed on %s...\n", filename);
                  while( time( NULL) < t + 5L)
                     ;
                  ifile = fopen( filename, "rb");
                  }
               if( !ifile)
                  err_code = DSS_IMG_ERR_OPEN_TILE;
               else
                  {
                  fseek( ifile, 0L, SEEK_END);
                  filesize = ftell( ifile);
                  fseek( ifile, 0L, SEEK_SET);
                  }
               }
            if( !err_code && filesize)
               {
               char *buff;

               buff = (char *)malloc( filesize);
               if( !buff)
                  err_code = DSS_IMG_ERR_TILE_MEM;
               else
                  {
                  const size_t n_read = fread( buff, 1, filesize,
                                                   lump_file ? lump_file : ifile);

                  assert( n_read == filesize);
                    /* The definition of hdecompress( ) is a little    */
                    /* confusing,  since ny and nx are 'reversed' from */
                    /* the form most people would expect! */
                  dss_debug_printf( "Decompressing '%s' (%d %d)...",
                                      filename, xtile, ytile);
                  err_code = hdecompress( &data, &ny, &nx, filesize, buff);
                  dss_debug_printf( "done: %d\n", err_code);
                  free( buff);
                  }
               if( ifile)
                  fclose( ifile);
               }
            }
         tbuff_start = xtile * 500 - x1;
         line_len = nx;
         if( line_len > xsize - tbuff_start)      /* clip on right edge */
            line_len = xsize - tbuff_start;
         if( tbuff_start < 0)      /* clip on left edge */
            {
            offset = -tbuff_start;
            line_len += tbuff_start;
            tbuff_start = 0;
            }

                     /* 2 Jul 98:  Fix added to handle the last row of */
                     /* tiles,  where ny = 499,  after Chris Marriott */
                     /* pointed out a bug here */
         for( y = 0; !err_code && y < 500; y++)
//          if( y + ypixel >= y1 && y + ypixel < y2 && !(y % subsamp))
            if( y + ypixel >= y1 && y + ypixel < y2)
               {
               PIXEL *tptr = tbuff + y * xsize + tbuff_start;
               const PIXEL off_plate_pixel = 0;

               if( !data || y >= ny)     /* off the plate,  for example */
                  for( x = line_len; x; x--, tptr++)
                     *tptr = off_plate_pixel;
               else
                  {
                  int *data_ptr = data + y * nx + offset;

                  for( x = line_len; x; x--, data_ptr++)
                     {
                     if( *data_ptr < 0)
                        *tptr++ = 0;
                     else if( *data_ptr > (int)0xffff)
                        *tptr++ = (int)0xffff;
                     else
                        *tptr++ = (PIXEL)*data_ptr;
                     }
                  }
               }
         if( data)
            free( data);
         counter++;
#ifdef _CONSOLE
         t_elapsed = (double)( clock( ) - t0) / (double)CLOCKS_PER_SEC;
         if( t_elapsed > prev_t_elapsed + 1.)
            {
            prev_t_elapsed = t_elapsed;
            printf( "%2d%% completed; %d seconds elapsed, %d remain; tile %d  \r",
              counter * 100 / n_tiles, (int)t_elapsed,
              (int)(t_elapsed * (double)( n_tiles - counter) / (double)counter),
              counter);
            }
#endif
         get_dss_tiles_done++;
         }
      for( y = 0; !err_code && y < 500; y++)
         if( y + ypixel >= y1 && y + ypixel < y2 && !(y % subsamp))
            {
            PIXEL *curr = tbuff + y * xsize, *tptr;
            int out_xsize = xsize / subsamp;
#ifndef WRONG_WAY_BYTE_ORDER
            char *swap_ptr;
#endif

            if( subsamp != 1)
               subsamp_row( median_buff, curr, xsize, subsamp);
            if( histogram)
               for( tptr = curr, x = out_xsize; x; x--, tptr++)
                  histogram[*tptr]++;
//          for( tptr = curr, x = out_xsize; x; x--, tptr++)
//             *tptr = ((*tptr << 8) | (*tptr >> 8));
#ifndef WRONG_WAY_BYTE_ORDER
            for( swap_ptr = (char *)curr, x = out_xsize; x; x--)
               {
               char temp = swap_ptr[0];
               swap_ptr[0] = swap_ptr[1];
               swap_ptr[1] = temp;
               swap_ptr += 2;
               }
#endif
            if( fwrite( curr, sizeof( PIXEL), out_xsize, ofile) !=
                                    (size_t)out_xsize)
               err_code = DSS_IMG_ERR_WRITING;
            }
      }
   get_dss_tiles_total = 0;     /*  Reset global to indicate 'job done' */
   free( tbuff);
   if( lump_file)
      fclose( lump_file);
   if( median_buff)
      free( median_buff);
   return( err_code);          /* success */
}
