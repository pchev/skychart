/*
** main_dll.cpp
** Top-level function for the Win32 DLL version of get_dss.
** Based on BJG's "get_dll" main program.
**
** $History: main_dll.cpp $
**
** *****************  Version 2  *****************
** User: Chris        Date: 24/08/98   Time: 10:12
** Updated in $/SkyMap 4.0/get_dss
** Moved error detection and handling from "extract_image_as_fits" into
** the top-level code; this results in a much better structure to the
** code.
*/

#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "platelst.h"
#include "get_dss.h"

#include <windows.h>

#include "image.h"

/* Global data:      */

extern FILE *debug_file;               /* debug file handle       */
HCURSOR hWait;                         /* hourglass cursor handle */
HCURSOR hOldCursor;                    /* previous cursor handle  */


/* The following ImageExtract( ) code takes on a set of higher-level tasks. */
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

/*   ImageExtract                               */
/*   Extract an image from the RealSky CD-ROMs. */

extern "C" int ImageExtract( SImageConfig *pConfig )

/* Return value:                                                    */
/* 0   on success, otherwise one of the error codes in "Errcode.h". */

{
   char buff[512];                     /* temp text buffer                */
   char szRealSkyDir[_MAX_PATH];       /* path name of RealSky directory  */
   int i;                              /* loop counter                    */
   int rval = DSS_IMG_ERR_USER_CANCEL;      /* return value               */
   PLATE_DATA *pdata;
   int n_plates, plate_to_use = 0;
   char override_plate_name[40];
   int debug_level = 0, select_plate = 0;
   time_t t;
   char szTemp[64];                  /* text buffer               */
   ENVIRONMENT_DATA edata;           /* configuration parameters  */

   /* Create a debugging file to log progress and errors to.      */

   debug_file = fopen( "debug.dat", "wt");
   setvbuf( debug_file, NULL, _IONBF, 0);

   t = time( NULL);
   fprintf( debug_file, "GETIMAGE:  compiled %s %s\n", __DATE__, __TIME__);
   fprintf( debug_file, "Starting run at %s\n", ctime( &t));

   /*
   ** Extract the data from the parameter block passed from
   ** the calling application.
   */

   /* Path of the directory containing RealSky auxiliary data files. */

   strcpy( szRealSkyDir, pConfig->pDir );

   /* Root directory of the drive from which RealSky images are to be read. */

   strcpy( edata.szDrive, pConfig->pDrive );

   /* Name of the image file to be created.  */

   strcpy( edata.output_file_name, pConfig->pImageFile );

   /* Plate list filename.  */

   switch (pConfig->nDataSource)
   {
   case 1:
      strcpy( szTemp, "hi_comp.lis");         /* RealSky North  */
      break;

   case 2:
      strcpy( szTemp, "hi_coms.lis");         /* RealSky South  */
      break;

   case 3:
      strcpy( szTemp, "lo_comp.lis");         /* DSS            */
      break;
   }

   strcpy( edata.plate_list_name, szRealSkyDir );
   strcat( edata.plate_list_name, szTemp );

   /* Subsample size.  */

   edata.subsamp = pConfig->nSubSample;

   /* Image centre coordinates. */

   edata.image_ra = pConfig->dRA;
   edata.image_dec = pConfig->dDec;

   /* Image size, pixels. 1 pixel = 1.7 arcsec.  */

   edata.pixels_wide = (int)(pConfig->dWidth*60/1.7);
   edata.pixels_high = (int)(pConfig->dHeight*60/1.7);

   /* Round off for subsampling.  In the normal case, where      */
   /* edata->subsamp = 1, this has no effect at all.             */

   edata.pixels_wide -= edata.pixels_wide % edata.subsamp;
   edata.pixels_high -= edata.pixels_high % edata.subsamp;

   /* Set the other data to default values.                      */

   edata.low_contrast = 1500;
   edata.high_contrast = 12000;
   edata.clip_image = 1;

   override_plate_name[0] = '\0';

   /* Now we have all the data, the real work starts. The first task is to  */
   /* create a sorted list of possible plates on which the image appears.   */
   /* We prioritize the list in terms of the distance of the image from     */
   /* the plate edge; ie, the closer the image is to the centre of the      */
   /* plate, the better.                                                    */

   pdata = get_plate_list( szRealSkyDir, edata.image_ra, edata.image_dec,
                        edata.pixels_wide, edata.pixels_high,
                        edata.plate_list_name, &n_plates);

   /* If we've found at least one plate...  */

   if (pdata!=NULL)
   {
      /* Output the list of potential plates to the debug file.  */

      for (i=0; i<n_plates; i++)
      {
         sprintf( buff, "%7s (%s): dist %d, loc (%d, %d), CD %d\n",
                pdata[i].plate_name, pdata[i].gsc_plate_name,
                pdata[i].dist_from_edge,
                pdata[i].xpixel, pdata[i].ypixel,
                pdata[i].cd_number);
         fprintf( debug_file, "%s", buff);
      }

      /* We always use the "best" plate; the original getimage code      */
      /* had the option of letting the user select the plate to be used. */
      /* This would be a good thing to reintroduce at a later date.      */

      /* Attempt to extract the image.                                   */

      hWait = LoadCursor( NULL, IDC_WAIT );
      hOldCursor = SetCursor(hWait);

      while ((rval = extract_realsky_as_fits( pdata, &edata ))==DSS_IMG_ERR_WRONG_CD)
      {
         sprintf( buff, "Please insert RealSky® CD %d\nin drive %s",
                pdata->cd_number, edata.szDrive);
         if (MessageBox( pConfig->hWnd, buff, "SkyMap Pro", MB_ICONEXCLAMATION|MB_OKCANCEL )==IDCANCEL)
         {
            rval = DSS_IMG_ERR_USER_CANCEL;
            break;
         }

         SetCursor(hWait);
      }

      free(pdata);
      SetCursor(hOldCursor);
   }

   /* Close the debug file and return the result code.  */

   t = time( NULL);
   fprintf( debug_file, "\nEnding run at %s\n", ctime( &t));
   fclose(debug_file);

   return rval;
}
