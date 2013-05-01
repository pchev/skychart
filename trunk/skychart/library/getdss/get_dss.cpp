#include <stdio.h>
#ifdef   UNIX
#include <ctype.h>
#define   getch()   getchar()
#else    /*UNIX*/
#include <conio.h>
#endif   /*UNIX*/
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "platelst.h"
#include "get_dss.h"
#include "errcode.h"


/*   The following main( ) code takes on a set of higher-level tasks.       */
/* The idea is that it should be able to handle RealSky extraction as       */
/* a set of OS-independent operating systems.  The underlying code has      */
/* been ported to Win32,  but can still be compiled for Watcom C/C++  =     */
/* under DOS.  It could all be made into a .DLL (this would make a bit      */
/* of sense,  I'll admit),  but I haven't done so yet.                      */
/*   It begins by ensuring that data sent to stdout is flushed;  otherwise, */
/* the "% complete" statements would never be seen until you reached 100%.  */
/* It opens up a DEBUG.DAT file that contains a running commentary on what  */
/* GET_DSS is doing,  makes sure it's always flushed,  and puts the         */
/* starting time into DEBUG.DAT.                                            */
/*    Next,  we use the get_environment_data( ) function in EXTR_FIT.CPP    */
/* to get all relevant data contained in the file ENVIRON.DAT.  (The        */
/* original STScI code used oodles of environment variables,  which is      */
/* acceptable under UNIX,  but could have led to troubles in the DOS and    */
/* Windows world.)  Then we check for a modest number of possible command   */
/* line arguments.   For example,  adding '-s4' to the command line forces  */
/* resampling to a 4x4 grid,  so GET_DSS only stores every fourth pixel of  */
/* every fourth line,  making the image 16 times smaller.  I played with    */
/* this as a means of decreasing image size.  I was not really impressed    */
/* with the results.  A better sampling system (say,  going after the       */
/* median value) might work better.  See GETPIECE.CPP for details.          */
/*    GET_DSS assumes that it will get data for each field from a file      */
/* called IFILE.  So it opens that file,  extracts fields line by line,     */
/* and hands them off to the extract_realsky_as_fits( ) function in         */
/* EXTR_FIT.CPP for handling.                                               */
/*   In some cases,  a given field may appear on multiple plates.  The      */
/* get_plate_list( ) function,  in PLATELST.CPP,  returns the plates in     */
/* order of preference (best plate first).  "Best" is defined as being      */
/* "farthest from a plate edge";  the edges are often a little dodgy,  so   */
/* this is a reasonable system.  In some cases,  the area you want may      */
/* extend right off the edge of the plate.  If this happens,  the           */
/* clip_image field of the ENVIRONMENT_DATA structure becomes important:    */
/* if set to zero,  the extra area is zero-padded;  otherwise,  a smaller   */
/* image is made,  clipped to the plate edge(s).                            */
/*   Once they've all been handled,  GET_DSS lists the number of clock      */
/* ticks spent in various activities in the DEBUG.DAT file;  I did that     */
/* when I was trying to figure out if there was some obvious performance    */
/* bottleneck hogging 90% of GET_DSS's time.  (I was able to use this       */
/* information to speed up the code a bit,  but not as much as I'd hoped.)  */
/* It then asks for the Guide CD (assuming you haven't turned off that      */
/* feature),  and shuts everything down.                                    */

#define MAX_CD 200

int main( int argc, char **argv)
{
   char buff[90], override_plate_name[40];
   FILE *ifile, *output_list_file = NULL;
   ENVIRONMENT_DATA edata;
   int i, debug_level = 0, err_code = 0, select_plate = 0;
   int prompt_for_correct_realsky_cd = 1, skip_if_output_file_exists = 0;
   int ask_for_guide_cd = 1, *cd_count = NULL;
   time_t t;

#ifdef __WATCOMC__
   setvbuf( stdout, NULL, _IONBF, 0);
#endif
   override_plate_name[0] = '\0';
   set_debug_file( "debug.dat");
   t = time( NULL);
   printf( "GET_DSS:  compiled %s %s\n", __DATE__, __TIME__);
   printf( "Starting run at %s\n", ctime( &t));
   err_code = get_environment_data( &edata, "environ.dat");
   if( err_code)
      {
      if( err_code == DSS_IMG_ERR_OPEN_EDATA)
         printf( "Couldn't open ENVIRON.DAT!\n");
      else                 /*2001-12-10mn*/
         printf( "Error in ENVIRON.DAT!  Code: %d\n", err_code);
      printf( "Hit any key:\n");
      getch( );
      return( -1);
      }

   edata.add_line_to_realsky_dot_dat = 1;
   printf( "Got the environment data\n");
   for( i = 0; i < argc; i++)
      if( argv[i][0] == '-')
         switch( argv[i][1])
            {
            case 'a':
               prompt_for_correct_realsky_cd = 0;
               printf( "Will not prompt for correct disk\n");
               break;
            case 'b':
               if( argv[i][2] == '1')
                  strcpy( edata.plate_list_name, "hi_comp.lis");
               else if( argv[i][2] == '2')
                  strcpy( edata.plate_list_name, "hi_coms.lis");
               else if( argv[i][2] == '3')
                  strcpy( edata.plate_list_name, "lo_comp.lis");
               else
                  printf( "Argument '%s' ignored\n", argv[i]);
               printf( "Plate list name set to '%s'\n",
                                 edata.plate_list_name);
               break;
            case 'c':
               sscanf( argv[i] + 2, "%d,%d", &edata.low_contrast,
                                             &edata.high_contrast);
               printf( "Contrast reset to %d %d\n",
                            edata.low_contrast, edata.high_contrast);
               break;
            case 'd':
               debug_level = atoi( argv[i] + 2);
               printf( "Set debug level %d\n", debug_level);
               break;
            case 'e':
               edata.add_line_to_realsky_dot_dat = 0;
               printf( "Will not add data to REALSKY.DAT\n");
               break;
            case 'g':
               ask_for_guide_cd = 0;
               printf( "Will not ask for Guide CD\n");
               break;
            case 'i':
               skip_if_output_file_exists = 1;
               break;
            case 'k':
               edata.clip_image = atoi( argv[i] + 2);
               printf( "Clip_image set to %d\n",
                                          edata.clip_image);
               break;
            case 'm':
               {
               extern int median_nth_pixel;

               median_nth_pixel = atoi( argv[i] + 2);
               printf( "Looking for %d-th value\n", median_nth_pixel);
               }
               break;
            case 'n':
               {
               char *output_filename = "ofile";

               cd_count = (int *)calloc( MAX_CD, sizeof( int));
               output_list_file = fopen( output_filename, "wb");
               printf( "Counting CDs\n");
               prompt_for_correct_realsky_cd = 0;
               }
               break;
            case 'p':
               strcpy( override_plate_name, argv[i] + 2);
               printf( "Override plate: %s\n",
                                    override_plate_name);
               break;
            case 's':
               edata.subsamp = atoi( argv[i] + 2);
               printf( "Set subsamp %d\n", edata.subsamp);
               break;
            case 't':
               select_plate = 1;
               printf( "Select_plate set\n");
               break;
            default:
               break;
            }

   ifile = fopen( "ifile", "rb");
   if( !ifile)
      {
      printf( "Couldn't open IFILE!\n");
      printf( "Hit any key:\n");
      getch( );
      return( -2);
      }
   printf( "IFILE opened\n");
   while( !err_code && fgets( buff, sizeof( buff), ifile))
      {
      printf( buff);
      if( !parse_image_line( &edata, buff))
         {
         PLATE_DATA *pdata = NULL;
         int n_plates, plate_to_use = 0;
         FILE *test_file = NULL;

         if( skip_if_output_file_exists)
            {
            test_file = fopen( edata.output_file_name, "rb");

            if( test_file)
               fclose( test_file);
            }
         if( !test_file)
            pdata = get_plate_list( "", edata.image_ra, edata.image_dec,
                        edata.pixels_wide, edata.pixels_high,
                        edata.plate_list_name, &n_plates);
         if( pdata)
            {
            printf( "%s\n", edata.output_file_name);
            for( i = 0; i < n_plates; i++)
               {
               char tbuff[100];

               sprintf( tbuff, "%7s (%s): dist %d, loc (%d, %d), CD %d\n",
                           pdata[i].plate_name, pdata[i].gsc_plate_name,
                           pdata[i].dist_from_edge,
                           pdata[i].xpixel, pdata[i].ypixel,
                           pdata[i].cd_number);
               printf( "%s", tbuff);
               if( select_plate)
                  printf( "(%d) %s", i + 1, tbuff);
               }
            if( override_plate_name[0])
               for( i = 0; i < n_plates; i++)
                  if( !strcmp( pdata[i].plate_name,
                                          override_plate_name))
                     plate_to_use = i;

            if( select_plate && n_plates > 1)
               {
               printf( "Which of the above plates (1-%d) \
do you wish to use?\n", n_plates);
               plate_to_use = getch( ) - '1';
               if( plate_to_use < 0 || plate_to_use >= n_plates)
                  plate_to_use = 0;
               }

            if( cd_count)
               {
               err_code = 0;
               if( pdata->cd_number > 0 && pdata->cd_number < MAX_CD)
                  cd_count[pdata->cd_number]++;
               else
                  cd_count[0]++;
               if( output_list_file)
                  {
                  for( i = 0; buff[i] >= ' '; i++)
                     ;
                  sprintf( buff + i, "%4d %s\n", pdata->cd_number,
                                                pdata->plate_name);
                  fprintf( output_list_file, buff);
                  }
               }
            else
               err_code = extract_realsky_as_fits( pdata + plate_to_use, &edata);
            while( err_code == DSS_IMG_ERR_WRONG_CD &&
                                 prompt_for_correct_realsky_cd)
               {
               printf( "Please insert disk %d into drive %s and hit a key:\n",
                           pdata->cd_number, edata.szDrive);
               if( getch( ) == 27)        /* Break out of loop */
                  err_code = -999;
               else
                  err_code = extract_realsky_as_fits( pdata + plate_to_use, &edata);
               }
            if( err_code == DSS_IMG_ERR_WRONG_CD &&
                                 !prompt_for_correct_realsky_cd)
               err_code = 0;        /* suppress the error */

            free( pdata);
            }
         else
            if( cd_count || skip_if_output_file_exists)
               {                                /* OK when this happens */
               if( cd_count)
                  cd_count[0]++;
               err_code = 0;
               }
            else
               err_code = -999;
         }
      }
   fclose( ifile);
   if( err_code)
      {
      printf( "Extract_realsky_as_fits: rval %d\n", err_code);
      printf( "Extract_realsky_as_fits: rval %d\n", err_code);
      }
   printf( "All done...\n");
   if( ask_for_guide_cd)
      {
      printf( "Please put the Guide CD back into the CD drive and hit a key:");
      getch( );
      printf( "\n");
      remount_drive( edata.szDrive);
      }

   if( cd_count)
      for( i = 0; i < MAX_CD; i++)
         if( cd_count[i])
            {
            if( i)
               sprintf( buff, "%d images would be found on CD #%d\n",
                                     cd_count[i], i);
            else
               sprintf( buff, "%d images fell on no plate\n", cd_count[0]);
            printf( buff);
            printf( buff);
            }

   t = time( NULL);
   printf( "GET_DSS done at %s\n", ctime( &t));
   set_debug_file( NULL);
   return( 0);
}
