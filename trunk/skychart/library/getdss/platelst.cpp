#include <stdio.h>
#ifdef  UNIX
      /* 10 Dec 2001:  Nozomu Muto:  supplied Unix #includes and added */
      /* the missing strlwr() function                                 */
#include <ctype.h>
/*
void    strlwr(char *str)
{       int     c;
        while(c = *str){
                *str++ = tolower(c);
        }
}
*/
#else   /*UNIX*/
#include <conio.h>
#endif  /*UNIX*/
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "dss.h"
#include "platelst.h"

#define PI 3.14159265358979323

int dss_debug_printf( const char *format, ...);        /* extr_fit.cpp */

/* GETIMAGE as distributed by STScI uses a more complicated form of       */
/* get_hhh_data( ).  It also assumes that you have stored a header file   */
/* for each RealSky/DSS plate on disk;  these are files of about 8K each, */
/* with extension .HHH.  Because you may need about a thousand of them,   */
/* and because minimum disk cluster sizes are often 64 KBytes,  one can   */
/* consume between 8 and 64 MBytes of hard drive space with the STScI     */
/* approach.  I did not consider that to be particularly practical,       */
/* so I worked out a way to compress all the .HHH files for RS North      */
/* into one 515720-byte file,  HHH.DAT,  distributed on the Guide 6.0 CDs */
/* in the REALSKY directory.  Later,  when I received RealSky South,  I   */
/* made a second file,  HH2.DAT,  of 455920 bytes,  containing all the    */
/* .HHH files for RealSky South.  These are also available from the Guide */
/* WWW site,  in the REALSKY.ZIP file.                                    */
/*    The compression scheme is quite primitive.  It relies on the fact   */
/* that,  in a RS North header file of 97 80-byte lines (7760 bytes),     */
/* all but 664 of the bytes are identical among all files.  So this       */
/* function can read a "full header",  then go back and patch those 664   */
/* bytes with the ones specific to that .HHH file.  A similar plan works  */
/* for RS South,  except that there are 99 lines (7920 bytes) of which    */
/* all but 494 are identical in all RS South .HHH files.                  */
/*    Added 23 Feb 1999:  Chris Marriott pointed out that plate XE524 has */
/* an extra line,  because of a 'HISTORY' statement.  To fix this,  we    */
/* just make sure the last line (the END line) gets added.                */

static int get_hhh_data( const char *szDataDir, const char *header_file_name,
                       char *hdr)
{
   char szPath[260];
   FILE *ifile;
   int i, nlines = 0;
   long offset;
   char lower_name[20], filename[20];

   strcpy( filename, "hhh.dat");
   strcpy( lower_name, header_file_name);
   strlwr( lower_name);
   if( (lower_name[0] == 's' || lower_name[1] == 'v') &&
                     strcmp( lower_name, "xx005") ||
                     !strcmp( lower_name, "xx001") ||
                     !strcmp( lower_name, "xx002"))
      {
      filename[2] = '2';                 /* RealSky South */
      nlines = 99;
      offset = 0L;
      }
   else
      {
      nlines = 97;
      offset = atol( header_file_name + 2);
      if( lower_name[1] == 'x')
         offset = 0;
      if( offset == 1001)
         offset = 722;
      offset = 7760L + offset * 664L;
      }

   dss_debug_printf( "   Looking for plate %s in file %s\n",
                  lower_name, filename);

   /* Get the full pathname of the data file. */

   strcpy( szPath, szDataDir );
   strcat( szPath, filename );

   ifile = fopen( szPath, "rb");

   if ( !ifile)
      {
      dss_debug_printf( "   COULDN'T OPEN %s\n", filename);
      return( -1);
      }

   fread( hdr, nlines, 80, ifile);

   if( nlines == 99)         /* for RealSky South,  gotta find hdr: */
      for( i = 0; i < 896 && !offset; i++)
         {
         char tbuff[6];

         fread( tbuff, 6, 1, ifile);
         if( !strcmp( tbuff, lower_name))
            offset = i * 494L + 7920L + 6L * 896L;
         }
   fseek( ifile, offset, SEEK_SET);
   for( i = 0; i < nlines * 80; i++)
      if( hdr[i] == '!')
         fread( hdr + i, 1, 1, ifile);

   if( !strcmp( lower_name, "xe524"))
      {
      strcpy( hdr + nlines * 80, "END");
      memset( hdr + nlines * 80 + 3, ' ', 77);
      nlines++;
      }

   hdr[nlines * 80] = '\0';         /* ensure null termination */

   fclose( ifile);
 
   return( nlines);
}

int setup_header_from_text( HEADER *h, const char *header)
{
   int i;

   memset( h, 0, sizeof( HEADER));
   h->x_pixel_size = h->y_pixel_size = 25.28445;
   for( i = 0; i < 200 && add_header_line( h, header + 80 * i) != -1; i++)
      ;
   h->n_lines = i + 1;
   return( h->n_lines);
}

#define POSSIBLE_PLATE_DIST (7. * PI / 180.)

/* I borrowed some strategy from the STScI GETIMAGE for this find_best_plate */
/* function.  It reads through the .LIS file (list of plates) and            */
/* immediately disregards all plates with centers more than 7 degrees from   */
/* (ra, dec).  If the plate is close enough to be worth consideration,  this */
/* function loads its header information and determines where on the plate   */
/* (in pixels) the point (ra, dec) falls.  It then finds out how close we    */
/* are to the edge of the plate,  taking the width and height of the image   */
/* (in pixels) into account.  (Usually,  you don't want to come too close to */
/* the edge of a plate;  often,  there is no actual data there.  This is     */
/* the default strategy of the STScI GETIMAGE.  That GETIMAGE also provides  */
/* ways to say,  "You _must_ use plate X",  or "Use the plate with a center  */
/* closest to (RA, dec)".  I didn't implement such options.)                 */
/*    Anyway,  the data from the best header is copied,  logically enough,   */
/* into the buffer best_header.  As described above,  this buffer is 97      */
/* lines of 80 characters for a RS North plate (7760 bytes),  or 99 lines    */
/* lines (7920 bytes) for a RS South plate.                                  */


PLATE_DATA * DLL_FUNC get_plate_list( const char *szDataDir,
          const double ra, const double dec,
          const int width, const int height,
          const char *lis_file_name, int *n_found)
{
   char buff[81], *header;
   FILE *ifile = fopen( lis_file_name, "rb");
   PLATE_DATA *rval = NULL;
   int i, j;

   *n_found = 0;
   dss_debug_printf( "Hunting plate: RA %lf, dec %lf\n",
                         ra * 180. / PI, dec * 180. / PI);
   if( !ifile)
      return( NULL);

   header = (char *)calloc( 100, 80);
   if( !header)
      {
      fclose( ifile);
      return( NULL);
      }

   buff[80] = '\0';
   while( fread( buff, 80, 1, ifile))
      if( *buff != '#')
         {
         double ra1, dec1, dist;
         char plate_name[10];

         ra1  = atof( buff + 12) + atof( buff + 15) / 60.
                                + atof( buff + 18) / 3600.;
         dec1 = atof( buff + 26) + atof( buff + 29) / 60.
                                + atof( buff + 32) / 3600.;
         if( buff[25] == '-')
            dec1 = -dec1;

         ra1 *= PI / 12.;
         dec1 *= PI / 180.;
         dist = sin( dec1) * sin( dec) +
                              cos( dec1) * cos( dec) * cos( ra1 - ra);
         dist = acos( dist);
         sscanf(buff,"%[^ ]", plate_name);
         strlwr( plate_name);                   /* 10 Dec 2001:  BJG */
         if( dist < POSSIBLE_PLATE_DIST)
            {
            dss_debug_printf( "Possible: %s: RA %lf, dec %lf; dist %lf;",
                         plate_name,
                         ra1 * 180. / PI, dec1 * 180. / PI, dist * 180. / PI);
            if( get_hhh_data( szDataDir, plate_name, header) > 0)
               {
               double x, y;
               int x1, y1, x2, y2;
               HEADER h;
               setup_header_from_text( &h, header);
               amdinv( &h, ra, dec, &x, &y);
               x1 = (int)( x - width / 2);
               y1 = (int)( y - height / 2);
               x2 = x1 + width;
               y2 = y1 + height;

               if( y2 > 0 && y1 < 14000 && x2 > 0 && x1 < 14000)
                  {
                  int min_dist, edge_dists[4];
                  PLATE_DATA *temp_pdata;

                  (*n_found)++;
                  temp_pdata = (PLATE_DATA *)calloc( *n_found,
                                    sizeof( PLATE_DATA));
                  if( rval)
                     {
                     memcpy( temp_pdata, rval, (*n_found - 1) *
                                    sizeof( PLATE_DATA));
                     free( rval);
                     }
                  rval = temp_pdata;
                  temp_pdata = rval + (*n_found) - 1;
                  strcpy( temp_pdata->header_text, header);
                  sscanf( buff, "%s %s", &temp_pdata->plate_name,
                                         &temp_pdata->gsc_plate_name);
                  strlwr( temp_pdata->plate_name);   /* 10 Dec 2001:  BJG */
                  edge_dists[0] = min_dist = x1;
                  edge_dists[1] = 14000 - x2;
                  edge_dists[2] = y1;
                  edge_dists[3] = 14000 - y2;
                  temp_pdata->real_width = width;
                  for( i = 0; i < 2; i++)
                     if( edge_dists[i] < 0)
                        temp_pdata->real_width += edge_dists[i];
                  temp_pdata->real_height = height;
                  for( i = 2; i < 4; i++)
                     if( edge_dists[i] < 0)
                        temp_pdata->real_height += edge_dists[i];
                  for( i = 1; i < 4; i++)
                     if( min_dist > edge_dists[i])
                        min_dist = edge_dists[i];
                  dss_debug_printf( "  x=%.1lf, y=%.1lf, dist=%d\n",
                              x, y, min_dist);
                  temp_pdata->dist_from_edge = min_dist;
                  temp_pdata->year_imaged = atof( buff + 38);
                  temp_pdata->is_uk_survey = (buff[47] == 'U');
                  temp_pdata->xpixel = (int)x;
                  temp_pdata->ypixel = (int)y;
                  for( i = 50; i < 77; i++)
                     if( buff[i] >= '0' && buff[i] <= '9')
                        {
                        temp_pdata->cd_number = atoi( buff + i);
                        i = 77;
                        }
                  }
               }
            }
         }

   free( header);
   fclose( ifile);
            /* Sort in descending order of distance from edge: */
   for( i = 0; i < *n_found; i++)
      for( j = 0; j < i; j++)
         if( rval[i].dist_from_edge > rval[j].dist_from_edge)
            {
            PLATE_DATA tval = rval[i];

            rval[i] = rval[j];
            rval[j] = tval;
            }
   return( rval);
}
