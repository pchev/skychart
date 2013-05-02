#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include <time.h>

#if defined( __linux__) || defined( __unix__) || defined( __APPLE__)
#define UNIX
#define _CONSOLE
#include <unistd.h>            /* for unlink( ) prototype */
#endif

#include "dss.h"
#include "platelst.h"
#include "get_dss.h"
#include "errcode.h"

#ifdef __WATCOMC__
#include <dos.h>
#include <io.h>
#define _CONSOLE
#endif

#ifndef _CONSOLE
#include <windows.h>
#include "new.h"
#endif

#define PI 3.14159265358979323

FILE *debug_file;

int setup_header_from_text( HEADER *h, const char *header); /* platelst.c */

#ifndef _CONSOLE
int my_new_handler( size_t size)
{
   return( 0);
}
#endif

int dss_debug_printf( const char *format, ...)
{
   if( debug_file)
      {
      va_list argptr;

      va_start( argptr, format);
      vfprintf( debug_file, format, argptr);
      va_end( argptr);
      }
   return( 0);
}

int DLL_FUNC set_debug_file( const char *path)
{
   if( !path && debug_file)
      {
      fclose( debug_file);
      debug_file = NULL;
      }
   if( path && !debug_file)
      {
      debug_file = fopen( path, "ab");
      if( debug_file)
         setvbuf( debug_file, NULL, _IONBF, 0);
      }
   return( debug_file ? 1 : 0);
}

/* remount_drive
   Read the volume information. This forces the file system
   to update the volume information if the disk has been changed.

   Note:
   The previous version of this function was just passed a drive letter.
   We now pass a STRING containing the root directory of the drive. This
   can be either a drive letter (eg "d:\") or a network UNC name
   (eg "\\server_name\share_name\").         */

void DLL_FUNC remount_drive( const char *pDrive )
{
#ifdef _CONSOLE
   char buff[256];
#ifdef __WATCOMC__
   struct _find_t c_file;
#endif

   strcpy( buff, pDrive );
   strcat( buff, "*.*");

   dss_debug_printf( "Remount_drive: %s\n", buff);
#ifdef __WATCOMC__
   _dos_findfirst( buff, _A_VOLID, &c_file);
   dss_debug_printf( "Drive remounted: %s\n", c_file.name);
   printf( "Volume name: %s\n", c_file.name);
#endif
#else
 char szVolumeName[_MAX_PATH];   /* volume name buffer */
 char szFileSystemName[_MAX_PATH];  /* name of file system */
 DWORD dwMaxFilename;     /* max filename length */
 DWORD dwFlags;       /* file system flags */

 /* Read volume info. */

 GetVolumeInformation( pDrive,
                    szVolumeName,
        _MAX_PATH,
        NULL,
        &dwMaxFilename,
        &dwFlags,
        szFileSystemName,
        _MAX_PATH );
#endif
}


/* The original STScI GETIMAGE used environment variables almost        */
/* everywhere.  I didn't really like this (and DOS and Windows can      */
/* like it even less),  so I put all of them into the file ENVIRON.DAT. */
/* The following get_environment_data( ) function loads it all up into  */
/* a convenient structure.                                              */
/*    21 Aug 98:  BJG:  Altered to have DSS_DIR go into the (new) szDrive */
/* field,  instead of the (old) cd_drive_letter field.                    */

int DLL_FUNC get_environment_data( ENVIRONMENT_DATA *edata, const char *filename)
{
   FILE *ifile = fopen( filename, "rb");
   char buff[80];
   int i;

   if( !ifile)
      return( DSS_IMG_ERR_OPEN_EDATA);
   strcpy( edata->plate_list_name, "Hi_comp.lis");
   edata->subsamp = 1;
   edata->low_contrast = 1500;
   edata->high_contrast = 12000;
   edata->szDrive[0] = '\0';            /*fix2001-12-06mn*/
   while( fgets( buff, sizeof( buff), ifile)){
      int       eolpos;                 /*vvv,mod2001-12-10mn*/
      if( buff[0] == '#' ){     /* this is a comment-line */
         continue;
      }
                  /* Ensure line is less than 80 bytes... */
      if( buff[eolpos = strlen(buff)-1] != '\n' ){
         fclose(ifile);
         return ( DSS_IMG_ERR_EDATA_LINETOOLONG);
      }
      buff[eolpos] = '\0';              /*^^^mod,2001-12-10mn*/
      if( !memcmp( buff, "DSS_PLTL2=", 10))
         {
         strcpy( edata->plate_list_name, buff + 10);
         for( i = 0; edata->plate_list_name[i] > ' '; i++)
            ;
         edata->plate_list_name[i] = '\0';
         }
      else if( !memcmp( buff, "DSS_DIR=", 8))
         {
         strcpy( edata->szDrive, buff + 8);
         for( i = 0; edata->szDrive[i] > ' '; i++)
            ;
         edata->szDrive[i] = '\0';
         }
      else if( !memcmp( buff, "CLIP_IMAGE=", 7))
         edata->clip_image = 1;
      else if( !memcmp( buff, "CONTRAST=", 9))
         sscanf( buff + 9, "%d,%d", &edata->low_contrast,
                                        &edata->high_contrast);
      }
   fclose( ifile);
   dss_debug_printf( "Plate list name: %s\n", edata->plate_list_name);
   dss_debug_printf( "Drive letter: %s\n", edata->szDrive);
   dss_debug_printf( "Default contrast: %d to %d\n", edata->low_contrast,
                              edata->high_contrast);
   return( 0);
}

/*    This function follows the format used by the STScI GETIMAGE,  and     */
/* parses the line to extract the output file name and field size.          */

int DLL_FUNC create_image_line( char *oline, ENVIRONMENT_DATA *edata)
{
   char dec_sign = '+';
   long ra = (long)( edata->image_ra * (12. / PI) * 3600. * 100.);
   long dec = (long)( edata->image_dec * (180. / PI) * 3600. * 10.);

   if( dec < 0L)
      {
      dec = -dec;
      dec_sign = '-';
      }
   sprintf( oline,
       "     %02ld %02ld %02ld.%02ld  %c%02ld %02ld  %02ld.%ld%8.2lf%8.2lf",
                  ra / 360000L, (ra / 6000L) % 60L, (ra / 100L) % 60L,
                  ra % 100L, dec_sign,
                  dec / 36000L, (dec / 600L) % 60L, (dec / 10L) % 60L,
                  dec % 10L,
                  (double)edata->pixels_wide * 1.7 / 60. + .005,
                  (double)edata->pixels_high * 1.7 / 60. + .005);
   memcpy( oline, edata->output_file_name, 4);
   return( 0);
}

int DLL_FUNC parse_image_line( ENVIRONMENT_DATA *edata, const char *iline)
{
   double ra, ra_min, ra_sec, dec, dec_min, dec_sec, xpixel, ypixel;
   int n_bytes;
   char dec_sign = '+';

   sscanf( iline, "%s %lf %lf %lf %n",
            edata->output_file_name, &ra, &ra_min, &ra_sec, &n_bytes);
   iline += n_bytes;
   while( *iline == ' ')
      iline++;
   if( *iline == '-')
      {
      dec_sign = '-';
      iline++;
      }
   if( sscanf( iline, "%lf %lf %lf %lf %lf", &dec, &dec_min, &dec_sec,
                                          &xpixel, &ypixel) != 5)
      return( DSS_IMG_ERR_PARSE_ILINE);      /* didn't get all fields */
   if( !strchr( edata->output_file_name, '.'))
      strcat( edata->output_file_name, ".fit");
   edata->image_ra = (ra + ra_min / 60. + ra_sec / 3600.) * (PI / 12.);
   edata->image_dec = (dec + dec_min / 60. + dec_sec / 3600.) * (PI / 180.);
   if( dec_sign == '-')
      edata->image_dec = -edata->image_dec;
                     /* xpixel & ypixel are in arcminutes.  There are */
                     /* 1.7 arcsecs to a pixel.  So: */
   edata->pixels_wide = (int)( xpixel * 60. / 1.7);
   edata->pixels_high = (int)( ypixel * 60. / 1.7);
            /* Round off for subsampling.  In the normal case,  where */
            /* edata->subsamp = 1,  this has no effect at all.        */
   edata->pixels_wide -= edata->pixels_wide % edata->subsamp;
   edata->pixels_high -= edata->pixels_high % edata->subsamp;
   return( 0);
}

/*   The following image extraction process is somewhat different from that */
/* followed by the STScI GETIMAGE.  In part,  that is because it is limited */
/* to one purpose:  extracting a FITS file from RealSky or DSS data (the    */
/* STScI GETIMAGE can make other formats,  or just extract headers,  and    */
/* can accept input from the keyboard or from input files.) It assumes that */
/* you've already gotten a line from the IFILE file to specify the field of */
/* view and part of the sky for which you wish an image.                    */
/*    It also does some GUIDE-specific tasks,  such as writing out data     */
/* concerning the image to the REALSKY.DAT file (used by Guide in drawing   */
/* images),  putting a coarse histogram into the FITS header,  and so on.   */
/* You may wish to eliminate such things.                                   */
/*    First,  we call find_best_plate( ) to determine which plate in the    */
/* .LIS file best covers the area we want.  This function also returns the  */
/* FITS header for that plate,  which will comprise a large part of the     */
/* header we write out for our image.  It also can be parsed by             */
/* setup_header_from_ text( ) to give us plate constants and such.  Once we */
/* have _that_ data, we can figure out where our image fits on the          */
/* RealSky/DSS plate (from xpixel_int,  ypixel_int to xpixel_int +          */
/* pixels_wide,  ypixel_int + pixels_high).  We can also figure out which   */
/* CD we'll need to get data for that plate.                                */
/*                                                                          */
/*    Next,  we check for the necessary CD;  if it's not in the drive,  we  */
/* ask the user to provide it.  (You _can_ shut this behavior off,  with    */
/* the '-a' switch.  I added this for people who want to put a few hundred  */
/* fields in IFILE.  If you do that and then use the '-a' switch,  GET_DSS  */
/* won't pester you to swap the CD each time.  You can just extract all     */
/* fields on disk N,  then repeat for disk N+1,  and so on.)                */
/*    Four fields in the original FITS header for the plate (NAXIS1,        */
/* NAXIS2, CNPIX1,  and CNPIX2) are modified to match the header we'll      */
/* need for our image.  Some lines must be added,  so the 'END' (last line  */
/* of the FITS header) is pushed down to account for them.                  */
/*    The number of lines written is computed (this is the nearest          */
/* multiple of 36,  rounded up... because for historical reasons,  FITS     */
/* headers have to be a multiple of 36*80 = 2880 bytes in size.)  The       */
/* file is opened, and the header is written out.                           */
/*    grab_realsky_chunk( ) is called,  and actually reads in RealSky       */
/* data from the CD and writes out the FITS image data.  This function      */
/* is described in GETPIECE.CPP.                                            */
/*    grab_realsky_chunk( ) generates an image histogram while building     */
/* the the image;  that histogram is used to find the maximum and           */
/* minimum value in the image,  and this information is added to the        */
/* FITS header.  Also, the RA/dec of each corner of the image is            */
/* computed;  this is added to both the header and to REALSKY.DAT.          */
/*    Next,  we use the histogram to compute a rougher,  100-point          */
/* histogram that could be used for adjusting contrast without having to    */
/* re-read the entire image (I expect to add such a feature to Guide.)      */
/* If one then wants to have,  say,  the contrast adjusted to show 30%      */
/* of the image in black and 1% in white,  with the remainder linearly      */
/* stretched,  this rough histogram will tell you how to do so.             */
/*    Finally,  we fseek( ) back to the start of the FITS file and write    */
/* out the final,  corrected FITS header,  close up files and free          */
/* buffers, and go home.                                                    */
/**
** ************* Cartes du Ciel *******************
** Adapted for "Cartes du Ciel" by Patrick Chevalley
** June 5 1999
** Add WCS keywords
**/
/*
 * Changed the datatype of crpix1 and crpix2 to float to agree with
 * getImage 3.0 software, and fixed calculations for image center
 * to be the center of the middle pixel for odd numbers of pixels,
 * and to be the boundary separating the two middle pixels for even rows.
 * 30-April-2013
 * Skip Gaede
**/
/* 28 Aug 2006:  Wouter van Reeven pointed out that the output isn't    */
/* necessarily a multiple of 2880 bytes long,  and that it ought to be  */
/* padded to bring it up to size.  He's right,  of course,  though few  */
/* programs are insistent on this point,  and plenty of FITS files just */
/* stop when the data's done... still,  it's easy enough to do this     */
/* correctly;  see code beginning at ' const short pad_word'.           */

#define N_ADDED_LINES 20
#ifdef __WATCOMC__
#define ZKEY_CLOCK  (*(long *)((long)0x46c))
#else
#define ZKEY_CLOCK  0
#endif

long times[20];

int DLL_FUNC extract_realsky_as_fits( const PLATE_DATA *pdata,
                                          const ENVIRONMENT_DATA *edata)
{
   char szPath[256];
   char *header = (char *)calloc( 190, 80);
   char *tptr;
   HEADER h;
   int i, n_lines, xpixel_int, ypixel_int, curr_bin;
   int n_added_lines = N_ADDED_LINES;
   int min_pixel_value, max_pixel_value, n_lines_written;
   int xsize_out = edata->pixels_wide;
   int ysize_out = edata->pixels_high;
   FILE *ofile, *ifile, *img_data_file;
   long *histogram, total_pixels;
   unsigned bins[100];
   int rval;
   long t0;
   double ra_center, dec_center, new_wcs_matrix[4] ;
   /* 30-Apr-2013 Changed datatype from int to float match getImage 3.0 code: SG   */
   double crpix1, crpix2 ;
   time_t curr_t = time( NULL);

#ifdef _WIN32
#ifndef _CONSOLE
   _PNH old_handler;

   old_handler = _set_new_handler( my_new_handler);
#endif
#endif

   dss_debug_printf( "Field is %d x %d pixels\n",
                           xsize_out, ysize_out);

   strcpy( header, pdata->header_text);

   setup_header_from_text( &h, header);
   dss_debug_printf( "Header set up from text\n");
   xpixel_int = pdata->xpixel - xsize_out / 2;
   ypixel_int = pdata->ypixel - ysize_out / 2;

            /* Round off for subsampling: */
   xpixel_int -= xpixel_int % edata->subsamp;
   ypixel_int -= ypixel_int % edata->subsamp;
   if( edata->clip_image)
      {
      if( xpixel_int < 0)
         {
         xsize_out += xpixel_int;
         xpixel_int = 0;
         }
      if( ypixel_int < 0)
         {
         ysize_out += ypixel_int;
         ypixel_int = 0;
         }
      if( xpixel_int + xsize_out > 14000)
         xsize_out = 14000 - xpixel_int;
      if( ypixel_int + ysize_out > 14000)
         ysize_out = 14000 - ypixel_int;
      }

   n_lines = strlen( header) / 80;

   if( *edata->szDrive)
      {
      dss_debug_printf( "Gonna use plate %s on disk %d\n",
                                      pdata->plate_name, pdata->cd_number);
      sprintf( szPath, "%s.rsl", pdata->plate_name);
      dss_debug_printf( "Hunting for file %s\n", szPath);
      ifile = fopen( szPath, "rb");
      if( ifile)
         {
         dss_debug_printf( "Using the .RSL file\n");
         fclose( ifile);
         }
      else
         {
         /* try to find the .RSL at the szDrive location */
         sprintf( szPath, "%s%s.rsl",edata->szDrive,pdata->plate_name);
         dss_debug_printf( "Hunting for file %s\n", szPath);
         ifile = fopen( szPath, "rb");
         if( ifile)
            {
            dss_debug_printf( "Using .RSL file from path\n");
            fclose( ifile);
            }
         else
            {
            remount_drive( edata->szDrive);
               /* test to see if you can get the desired plate... */
#ifdef  UNIX
            sprintf( szPath, "%s/%s/%s.00", edata->szDrive,
                                pdata->plate_name, pdata->plate_name);
#else   /*UNIX*/
            sprintf( szPath, "%s%s\\%s.00", edata->szDrive,
                                pdata->plate_name, pdata->plate_name);
#endif  /*UNIX*/
            dss_debug_printf( "Hunting for file %s\n", szPath);
            ifile = fopen( szPath, "rb");
            if( ifile)
               fclose( ifile);         /* already found the right one... */
            else
               {
               free( header);
#ifdef _WIN32
#ifndef _CONSOLE
               _set_new_handler( old_handler);
#endif
#endif
               return( DSS_IMG_ERR_WRONG_CD);
               }
            }
         }
      }
   dss_debug_printf( "Initializing the output FITS header\n");
   tptr = strstr( header, "NAXIS1");
   sprintf( tptr + 25, "%5d", xsize_out / edata->subsamp);
   tptr[30] = ' ';
   tptr = strstr( header, "NAXIS2");
   sprintf( tptr + 25, "%5d", ysize_out / edata->subsamp);
   tptr[30] = ' ';
   tptr = strstr( header, "CNPIX1");
   sprintf( tptr + 25, "%5d", xpixel_int);
   tptr[30] = ' ';
   tptr = strstr( header, "CNPIX2");
   sprintf( tptr + 25, "%5d", ypixel_int);
   tptr[30] = ' ';

   tptr = header + (n_lines - 1) * 80;
   if( edata->subsamp != 1)
      n_added_lines++;
   n_added_lines += 12;  /* add space for WCS keywords... */
   n_added_lines += 2;   /* ...and (after 19 Dec 2001) date/time/version */
   n_added_lines += 5;   /* ...and (after 22 Dec 2001) CROTA2 & Ci,j matrix */
   memcpy( tptr + n_added_lines * 80, tptr, 80);     /* move the 'end' line */
   n_lines += n_added_lines;            /* allow for two 'max/min' and ten  */
                                /* contrast lines and eight 'corners' lines */
   n_lines_written = ((n_lines + 35) / 36) * 36;
   if( *edata->output_file_name && *edata->szDrive)
      {
      ofile = fopen( edata->output_file_name, "wb");
      if( !ofile)
         {
         dss_debug_printf( "Couldn't open '%s'\n", edata->output_file_name);
#ifdef _WIN32
#ifndef _CONSOLE
         _set_new_handler( old_handler);
#endif
#endif
         return( DSS_IMG_ERR_OPEN_OUTPUT);
         }
      fwrite( header, n_lines_written, 80, ofile);
      dss_debug_printf( "%d lines written to output file '%s'\n",
                     n_lines_written, edata->output_file_name);
      t0 = ZKEY_CLOCK;
      histogram = (long *)calloc( 65536, sizeof( long));
      if( !histogram)
         {
         dss_debug_printf( "Couldn't allocate histogram data\n");
#ifdef _CONSOLE
         printf( "Not enough memory to process this image!\n");
#endif
         fclose( ofile);
         free( header);
         unlink( edata->output_file_name);
#ifdef _WIN32
#ifndef _CONSOLE
         _set_new_handler( old_handler);
#endif
#endif
         return( DSS_IMG_ERR_ALLOC_HISTOGRAM);
         }
      else
         dss_debug_printf( "Histogram allocated\n");
      rval = grab_realsky_chunk( edata->szDrive, pdata->plate_name,
               xpixel_int, ypixel_int,
               xpixel_int + xsize_out,
               ypixel_int + ysize_out, ofile,
               edata->subsamp, histogram);
//      times[4] += ZKEY_CLOCK - t0;
      if( rval)
         {
         dss_debug_printf( "Error code %d returned!\n", rval);
#ifdef _CONSOLE
         printf( "Error code %d returned!\n", rval);
#endif
         fclose( ofile);
         free( header);
         free( histogram);
         unlink( edata->output_file_name);
#ifdef _WIN32
#ifndef _CONSOLE
         _set_new_handler( old_handler);
#endif
#endif
         return( rval);
         }

      dss_debug_printf( "Image successfully extracted\n");
      for( min_pixel_value = 0; !histogram[min_pixel_value]; min_pixel_value++)
         ;
      for( max_pixel_value = 65535; !histogram[max_pixel_value]; max_pixel_value--)
         ;
      curr_bin = 0;
      total_pixels = (long)xsize_out * (long)ysize_out;
      total_pixels /= (long)( edata->subsamp * edata->subsamp);
      for( i = 1; i < 65536; i++)
         {
         int new_bin;

         histogram[i] += histogram[i - 1];
         new_bin = (int)( histogram[i] * 100L / total_pixels);
         while( curr_bin < new_bin)
            bins[curr_bin++] = i;
         }
      free( histogram);

      sprintf( tptr, "DATAMAX =                %5d /Maximum data value",
            max_pixel_value);
      tptr += 80;
      sprintf( tptr, "DATAMIN =                %5d /Minimum data value",
               min_pixel_value);
      tptr += 80;
      }
   else
      ofile = NULL;

   if( edata->add_line_to_realsky_dot_dat)
      {
      img_data_file = fopen( "realsky.dat", "a");  /* ...in TEXT mode.. */
      fprintf( img_data_file, " ");
      }
   else
      img_data_file = NULL;

   for( i = 0; i < 4; i++)
      {
      double ra_corner, dec_corner;

      amdpos( &h, (double)( xpixel_int + ((i & 1) ? xsize_out : 0)),
                  (double)( ypixel_int + ((i < 2) ? ysize_out : 0)),
                  &ra_corner, &dec_corner);
      sprintf( tptr, "CORN%dRA = %11.9lf", i + 1, ra_corner * 180 / PI);
      tptr += 80;
      sprintf( tptr, "CORN%dDEC= %11.9lf", i + 1, dec_corner * 180 / PI);
      tptr += 80;
      if( img_data_file)
         fprintf( img_data_file, "%8.4lf %8.4lf  ",
                  ra_corner * 180. / PI, dec_corner * 180 / PI);
      }
   if( img_data_file)
      {
      int is_gif = (strstr( edata->output_file_name, ".gif") != NULL);

      if( is_gif)
         n_lines_written = 0;
      else if( !*edata->szDrive)       /* read the FITS file to find out */
         {                             /* the real header size */
         ifile = fopen( edata->output_file_name, "rb");
         if( ifile)
            {
            char buff[80];

            n_lines_written = 0;
            while( fread( buff, 80, 1, ifile) &&
                         n_lines_written < 300 && memcmp( buff, "END ", 4))
               n_lines_written++;
            fclose( ifile);
            n_lines_written = ((n_lines_written + 35) / 36) * 36;
            }
         }

      fprintf( img_data_file, "%5u %5u  %5d %5d %9ld 1 %s\n",
               edata->low_contrast, edata->high_contrast,
               xsize_out / edata->subsamp,
               ysize_out / edata->subsamp,
               (long)n_lines_written * 80L, edata->output_file_name);
      fclose( img_data_file);
      }

   for( i = 0; i < 10; i++, tptr += 80)
      {
      int j;

      sprintf( tptr, "CONTRAS%d =", i);
      for( j = 0; j < 10; j++)
         sprintf( tptr + 10 + j * 6, "%6u", bins[j + i * 10]);
      }
   if( edata->subsamp != 1)
      {
      sprintf( tptr, "SUBSAMP = %11d", edata->subsamp);
      tptr += 80;
      }

   /* "AIPS like" WCS keywords ( first approximation ) */
   sprintf( tptr, "COMMENT   Simplified WCS added for use with standard image processing system");
   tptr += 80;
   sprintf( tptr, "RADESYS = 'FK5 '");
   tptr += 80;
   sprintf( tptr, "EQUINOX = 2000.0");
   tptr += 80;
   /* 30-Apr-2013 Converted to floating point: SG     reference pixel at center */
   crpix1 = (double)( xsize_out + 1) / (double)( edata->subsamp * 2);
   crpix2 = (double)( ysize_out + 1) / (double)( edata->subsamp * 2);
   sprintf( tptr, "CTYPE1  = 'RA---TAN'");
   tptr += 80;
   sprintf( tptr, "CTYPE2  = 'DEC--TAN'");
   tptr += 80;
                        /* true pixel center if subsampling: */
   amdpos( &h, (double)xpixel_int + crpix1 * (double) edata->subsamp,
               (double)ypixel_int + crpix2 * (double) edata->subsamp,
               &ra_center, &dec_center);
   sprintf( tptr, "CRVAL1  = %11.9lf", ra_center * 180 / PI);
   tptr += 80;
   sprintf( tptr, "CRVAL2  = %11.9lf", dec_center * 180 / PI);
   tptr += 80;
               /* 20 Dec 2001:  added .5 to x, 1 to y:  BJG */
              /* 30 Apr 2013:  use floating point solution: SG */

   sprintf( tptr, "CRPIX1  = %12.6f", crpix1);
   tptr += 80;
   sprintf( tptr, "CRPIX2  = %12.6f", crpix2);
   tptr += 80;
   /* hard to convert polynomial plate solution directly to rotation.
      use very simple but efficient method to find rotation at image center.
      1 pixel -> 1.7 arcseconds we can ignore safely spherical effects.
      Check out one pixel just to the left and one just above the crpix: */
   for( i = 0; i < 2; i++)
      {
      double ra_2, dec_2, crota, delta_ra, delta_dec, dist;

      amdpos( &h, (double)( xpixel_int + crpix1 * edata->subsamp + 1 - i),
                  (double)( ypixel_int + crpix2 * edata->subsamp + i),
                  &ra_2, &dec_2);
      delta_ra  = (ra_2 - ra_center) * cos( dec_center);
      delta_dec = dec_2 - dec_center;
      dist = sqrt( delta_ra * delta_ra + delta_dec * delta_dec);
      if( !i)     /* CDELT1 is negative... don't really understand why */
         dist = -dist;
      sprintf( tptr, "CDELT%d  = %21.13E", i + 1, (180. / PI) * dist);
      tptr += 80;
      crota = -atan2( delta_ra, delta_dec);
      if( !i)
         crota -= PI / 2.;
      sprintf( tptr, "CROTA%d  = %11.9lf", i + 1, crota * 180 / PI);
      tptr += 80;
      new_wcs_matrix[i * 2    ] = delta_ra * 180. / PI;
      new_wcs_matrix[i * 2 + 1] = delta_dec * 180. / PI;
      }
   /* end old-style WCS keywords */
   /* begin new-style WCS keywords: */
   for( i = 0; i < 4; i++)
      {
      sprintf( tptr, "CD%d_%d   = %21.13E", (i / 2) + 1, (i % 2) + 1,
                             new_wcs_matrix[i]);
      tptr += 80;
      }

         /* 19 Dec 2001:  added two header lines for date/time and version. */
   sprintf( tptr, "COMMENT   Extracted with Get_DSS library %s %s",
                                       __DATE__, __TIME__);
   tptr += 80;

   sprintf( tptr, "COMMENT   File created %s", ctime( &curr_t));
   sprintf( tptr + 47, " = JD %.5lf", (double)curr_t / 86400. + 2440587.5);
   tptr += 80;

   for( i = 0; i < n_lines_written * 80; i++)
      if( !header[i])
         header[i] = ' ';
   if( ofile)
      {
      const short pad_word = 0;
      long n_pad_bytes = 2880 - ftell( ofile) % 2880;

      if( n_pad_bytes == 2880)      /* we came out even after all */
         n_pad_bytes = 0;
      while( n_pad_bytes)
         {
         fwrite( &pad_word, 1, sizeof( pad_word), ofile);
         n_pad_bytes -= sizeof( pad_word);      /* i.e,  two bytes */
         }
      fseek( ofile, 0L, SEEK_SET);        /* go back to redo the header */
      fwrite( header, n_lines_written, 80, ofile);
      fclose( ofile);
      }
   free( header);
#ifdef _WIN32
#ifndef _CONSOLE
   _set_new_handler( old_handler);
#endif
#endif
   return( 0);
}
