/*
** getdss_dll.cpp
** Top-level function for the Linux library version of get_dss.
** Based on BJG's "get_dll" main program.
**
** $History: main_dll.cpp $
**
** ************* Cartes du Ciel *******************
** Adapted for "Cartes du Ciel" by Patrick Chevalley
** June 5 1999
** Add parameters for message prompt
**
** June 19 1999
** New function GetPlateList and ImageExtractFromPlate
** add DataSource=4 for both north and south RealSky
**
** *****************  Version 2  *****************
** User: Chris        Date: 24/08/98   Time: 10:12
** Updated in $/SkyMap 4.0/get_dss
** Moved error detection and handling from "extract_image_as_fits" into
** the top-level code; this results in a much better structure to the
** code.
*/

#include <stdio.h>
#include <ctype.h>
#define   getch()   getchar()
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "platelst.h"
#include "get_dss.h"

#include "getdss_lib.h"

#ifndef int32_t
   #define int32_t long
#endif

/* Global data: */

extern FILE *debug_file;               /* debug file handle       */

/* Added 6 Dec 2001:  Unix generally lacks the 'stricmp' command: */

#ifdef UNIX
int stricmp( const char *s1, const char *s2)
{
   int c1, c2;

   while( *s1 || *s2)
      {
      if( (c1 = tolower( *s1++)) != (c2 = tolower( *s2++)))
         return( c1 - c2);
      }
   return( 0);
}
#endif

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

/* Return value:                                                            */
/* 0   on success, otherwise one of the error codes in "Errcode.h".         */

{
   char buff[512];                     /* temp text buffer                  */
   char szRealSkyDir[_MAX_PATH];         /* path name of RealSky directory  */
   int i;                           /* loop counter                         */
   int rval = DSS_IMG_ERR_USER_CANCEL;      /* return value                 */
   PLATE_DATA *pdata;
   int n_plates, plate_to_use = 0;
   char override_plate_name[40];
   int debug_level = 0, select_plate = 0;
   time_t t;
   char szTemp[64];                  /* text buffer                         */
   ENVIRONMENT_DATA edata;               /* configuration psrameters        */

   /* Create a debugging file to log progress and errors to.                */

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

   /* Name of the image file to be created.                                 */

   strcpy( edata.output_file_name, pConfig->pImageFile );

   /* Plate list filename.                                                  */

   switch (pConfig->nDataSource)
   {
   case 1:
      strcpy( szTemp, "hi_comn.lis");         /* RealSky North              */
      break;

   case 2:
      strcpy( szTemp, "hi_coms.lis");         /* RealSky South              */
      break;

   case 3:
      strcpy( szTemp, "lo_comp.lis");         /* DSS                        */
      break;

   case 4:
      strcpy( szTemp, "hi_comp.lis");         /* RealSky North and South    */
      break;
   }

   strcpy( edata.plate_list_name, szRealSkyDir );
   strcat( edata.plate_list_name, szTemp );

   /* Subsample size.   */

   edata.subsamp = pConfig->nSubSample;

   /* Image centre coordinates.   */

   edata.image_ra = pConfig->dRA;
   edata.image_dec = pConfig->dDec;

   /* Image size, pixels. 1 pixel = 1.7 arcsec.                   */

   edata.pixels_wide = (int)(pConfig->dWidth*60/1.7);
   edata.pixels_high = (int)(pConfig->dHeight*60/1.7);

   /* Round off for subsampling.  In the normal case, where       */
   /* edata->subsamp = 1, this has no effect at all.              */

   edata.pixels_wide -= edata.pixels_wide % edata.subsamp;
   edata.pixels_high -= edata.pixels_high % edata.subsamp;

   /* Set the other data to default values.                       */

   edata.low_contrast = 1500;
   edata.high_contrast = 12000;
   edata.clip_image = 0;

   /* cartes du ciel         */
   edata.add_line_to_realsky_dot_dat = 0;

   override_plate_name[0] = '\0';

   /* Now we have all the data, the real work starts. The first task is to */
   /* create a sorted list of possible plates on which the image appears.  */
   /* We prioritize the list in terms of the distance of the image from    */
   /* the plate edge; ie, the closer the image is to the centre of the     */
   /* plate, the better.                                                   */

   pdata = get_plate_list( szRealSkyDir, edata.image_ra, edata.image_dec,
                        edata.pixels_wide, edata.pixels_high,
                        edata.plate_list_name, &n_plates);

   /* If we've found at least one plate...                                 */

   if (pdata!=NULL)
   {
      /* Output the list of potential plates to the debug file.            */

      for (i=0; i<n_plates; i++)
      {
         sprintf( buff, "%7s (%s): dist %d, loc (%d, %d), CD %d\n",
                pdata[i].plate_name, pdata[i].gsc_plate_name,
                pdata[i].dist_from_edge,
                pdata[i].xpixel, pdata[i].ypixel,
                pdata[i].cd_number);
         fprintf( debug_file, "%s", buff);
      }

      /* We always use the "best" plate; the original getimage code       */
      /* had the option of letting the user select the plate to be used.  */
      /* This would be a good thing to reintroduce at a later date.       */

      /* Attempt to extract the image. */


                       /* 1 Dec 2001:  modified so that this function */
                       /* only asks you to insert the right CD if the */
                       /* 'bPromptForDisk' boolean is TRUE.    -- BJG */
      if ((rval = extract_realsky_as_fits( pdata, &edata ))==DSS_IMG_ERR_WRONG_CD
                        && pConfig->bPromptForDisk)
      {
            fprintf( debug_file, "\nAsk for CD %d\n", pdata->cd_number);
	    // just return the cd number, 
	    // the main application will ask for the cd and retry
	    // other return code defined in errcode.h are all negative
	    rval = pdata->cd_number;
      }

      free(pdata);
   }
   
   /* Close the debug file and return the result code. */

   t = time( NULL);
   fprintf( debug_file, "\nEnding run at %s\n", ctime( &t));
   fclose(debug_file);

   return rval;
}

/*   GetPlateList                                                */
/*   List possible plate for an image from the RealSky CD-ROMs.  */

extern "C" int GetPlateList( SImageConfig *pConfig , SPlateData *pd)

/* Return value:                                                     */
/* 0   on success, otherwise one of the error codes in "Errcode.h".  */

{
   char buff[512];                     /* temp text buffer                 */
   char szRealSkyDir[_MAX_PATH];         /* path name of RealSky directory */
   int rval = DSS_IMG_ERR_USER_CANCEL;      /* return value                */
   int i,j;                           /* loop counter                      */
   PLATE_DATA *pdata;
   int n_plates, plate_to_use = 0;
   char override_plate_name[40];
   int debug_level = 0, select_plate = 0;
   time_t t;
   char szTemp[64];                  /* text buffer                      */
   ENVIRONMENT_DATA edata;               /* configuration psrameters     */
   char hdrl[81], value[21] ; /* pour lire le header                     */

   /* Create a debugging file to log progress and errors to. */

   debug_file = fopen( "debug.dat", "wt");
   setvbuf( debug_file, NULL, _IONBF, 0);

   t = time( NULL);
   fprintf( debug_file, "GETIMAGE:  compiled %s %s\n", __DATE__, __TIME__);
   fprintf( debug_file, "Starting run at %s\n", ctime( &t));

   /*
   ** Extract the data from the parameter block passed from
   ** the calling application.
   */

   /* Path of the directory containing RealSky auxiliary data files.  */

   strcpy( szRealSkyDir, pConfig->pDir );

   /* Root directory of the drive from which RealSky images are to be read. */

   strcpy( edata.szDrive, pConfig->pDrive );

   /* Name of the image file to be created.  */

   strcpy( edata.output_file_name, pConfig->pImageFile );

   /* Plate list filename.  */

   switch (pConfig->nDataSource)
   {
   case 1:
      strcpy( szTemp, "hi_comn.lis");         /* RealSky North */
      break;

   case 2:
      strcpy( szTemp, "hi_coms.lis");         /* RealSky South */
      break;

   case 3:
      strcpy( szTemp, "lo_comp.lis");         /* DSS                     */
      break;

   case 4:
      strcpy( szTemp, "hi_comp.lis");         /* RealSky North and South */
      break;
   }

   strcpy( edata.plate_list_name, szRealSkyDir );
   strcat( edata.plate_list_name, szTemp );

   /* Subsample size.    */

   edata.subsamp = pConfig->nSubSample;

   /* Image centre coordinates.  */

   edata.image_ra = pConfig->dRA;
   edata.image_dec = pConfig->dDec;

   /* Image size, pixels. 1 pixel = 1.7 arcsec. */

   edata.pixels_wide = (int)(pConfig->dWidth*60/1.7);
   edata.pixels_high = (int)(pConfig->dHeight*60/1.7);

   /* Round off for subsampling.  In the normal case, where */
   /* edata->subsamp = 1, this has no effect at all.        */

   edata.pixels_wide -= edata.pixels_wide % edata.subsamp;
   edata.pixels_high -= edata.pixels_high % edata.subsamp;

   /* Set the other data to default values.                 */

   edata.low_contrast = 1500;
   edata.high_contrast = 12000;
   edata.clip_image = 0;

   /* cartes du ciel                                        */
   edata.add_line_to_realsky_dot_dat = 0;

   override_plate_name[0] = '\0';

   /* Now we have all the data, the real work starts. The first task is to */
   /* create a sorted list of possible plates on which the image appears.  */
   /* We prioritize the list in terms of the distance of the image from    */
   /* the plate edge; ie, the closer the image is to the centre of the     */
   /* plate, the better.                                                   */

   pdata = get_plate_list( szRealSkyDir, edata.image_ra, edata.image_dec,
                        edata.pixels_wide, edata.pixels_high,
                        edata.plate_list_name, &n_plates);

   /* If we've found at least one plate...   */

   if (pdata!=NULL)
   {
      pd->nplate = n_plates;
      for (i=0; (i<n_plates)&(i<MaxPlateList); i++)
      {
         sprintf( buff, "list : %7s (%s): dist %d, loc (%d, %d), CD %d\n",
                pdata[i].plate_name, pdata[i].gsc_plate_name,
                pdata[i].dist_from_edge,
                pdata[i].xpixel, pdata[i].ypixel,
                pdata[i].cd_number);
         fprintf( debug_file, "%s", buff);
         pd->pName[i]         = pdata[i].plate_name;
         pd->pGSCName[i]         = pdata[i].gsc_plate_name;
         pd->dist_from_edge[i]   = pdata[i].dist_from_edge;
         pd->cd_number[i]      = pdata[i].cd_number;
         pd->is_uk_survey[i]      = pdata[i].is_uk_survey;
         pd->year_imaged[i]      = pdata[i].year_imaged;
         pd->exposure[i] = 0;
         hdrl[80] = '\0';
         value[20] = '\0';
         for (j=0; (j<50); j++)
         {
            strncpy(hdrl,pdata[i].header_text+j*80,80);
/*             fprintf( debug_file, "%s\n", hdrl);       */
            if (!strncmp(hdrl,"EXPOSURE=",8))
            {
               strncpy(value,hdrl+10,20);
                 fprintf( debug_file, "found exposure %s\n",value);
               pd->exposure[i] = atof(value);
            }
         }


      }
      rval = 0;
   }
   
   /* Close the debug file and return the result code.   */

   t = time( NULL);
   fprintf( debug_file, "\nEnding run at %s\n", ctime( &t));
   fclose(debug_file);

   return rval;
}

/*   ImageExtractFromPlate                        */
/*   Extract an image from the RealSky CD-ROMs.   */
/*  Plate_Data set by GetPlateList                */

extern "C" int ImageExtractFromPlate( SImageConfig *pConfig ,char *ReqPlateName )

/* Return value:                                                    */
/* 0   on success, otherwise one of the error codes in "Errcode.h". */

{
   char buff[512];                     /* temp text buffer                 */
   char szRealSkyDir[_MAX_PATH];         /* path name of RealSky directory */
   int i;                           /* loop counter                        */
   int rval = DSS_IMG_ERR_USER_CANCEL;      /* return value                */
   PLATE_DATA *pdata;
   int n_plates, plate_to_use = 0;
   char override_plate_name[40];
   int debug_level = 0, select_plate = 0;
   time_t t;
   char szTemp[64];                  /* text buffer */
   ENVIRONMENT_DATA edata;               /* configuration parameters */

   /* Create a debugging file to log progress and errors to.  */

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

   /* Name of the image file to be created.    */

   strcpy( edata.output_file_name, pConfig->pImageFile );

   /* Plate list filename.  */

   switch (pConfig->nDataSource)
   {
   case 1:
      strcpy( szTemp, "hi_comn.lis");         /* RealSky North */
      break;

   case 2:
      strcpy( szTemp, "hi_coms.lis");         /* RealSky South */
      break;

   case 3:
      strcpy( szTemp, "lo_comp.lis");         /* DSS           */
      break;

   case 4:
      strcpy( szTemp, "hi_comp.lis");         /* RealSky North and South  */
      break;
   }

   strcpy( edata.plate_list_name, szRealSkyDir );
   strcat( edata.plate_list_name, szTemp );

   /* Subsample size. */

   edata.subsamp = pConfig->nSubSample;

   /* Image centre coordinates.  */

   edata.image_ra = pConfig->dRA;
   edata.image_dec = pConfig->dDec;

   /* Image size, pixels. 1 pixel = 1.7 arcsec.  */

   edata.pixels_wide = (int)(pConfig->dWidth*60/1.7);
   edata.pixels_high = (int)(pConfig->dHeight*60/1.7);

   /* Round off for subsampling.  In the normal case, where  */
   /* edata->subsamp = 1, this has no effect at all.  */

   edata.pixels_wide -= edata.pixels_wide % edata.subsamp;
   edata.pixels_high -= edata.pixels_high % edata.subsamp;

   /* Set the other data to default values.   */

   edata.low_contrast = 1500;
   edata.high_contrast = 12000;
   edata.clip_image = 0;

   /* cartes du ciel  */
   edata.add_line_to_realsky_dot_dat = 0;

   override_plate_name[0] = '\0';
    strcpy( override_plate_name, ReqPlateName);
    fprintf( debug_file, "Override plate: %s\n",
             override_plate_name);


   /* Now we have all the data, the real work starts. The first task is to */
   /* create a sorted list of possible plates on which the image appears.  */
   /* We prioritize the list in terms of the distance of the image from    */
   /* the plate edge; ie, the closer the image is to the centre of the     */
   /* plate, the better.                                                   */

   pdata = get_plate_list( szRealSkyDir, edata.image_ra, edata.image_dec,
                        edata.pixels_wide, edata.pixels_high,
                        edata.plate_list_name, &n_plates);

   /* If we've found at least one plate... */

   if (pdata!=NULL)
   {
      /* Output the list of potential plates to the debug file. */

      for (i=0; i<n_plates; i++)
      {
         sprintf( buff, "%7s (%s): dist %d, loc (%d, %d), CD %d\n",
                pdata[i].plate_name, pdata[i].gsc_plate_name,
                pdata[i].dist_from_edge,
                pdata[i].xpixel, pdata[i].ypixel,
                pdata[i].cd_number);
         fprintf( debug_file, "%s", buff);

         /* compare plate name to use  */
            if( !stricmp( pdata[i].plate_name, override_plate_name))
                     plate_to_use = i;

      }

      /* Attempt to extract the image. */

                       /* 2 Dec 2001:  modified so that this function */
                       /* only asks you to insert the right CD if the */
                       /* 'bPromptForDisk' boolean is TRUE.    -- BJG */
      if ((rval = extract_realsky_as_fits( pdata + plate_to_use, &edata ))==DSS_IMG_ERR_WRONG_CD
                        && pConfig->bPromptForDisk)
      {     
            fprintf( debug_file, "\nAsk for CD %d\n", pdata->cd_number);
	    // just return the cd number, 
	    // the main application will ask for the cd and retry
	    // other return code defined in errcode.h are all negative
	    rval = pdata->cd_number;
      }

      free(pdata);
   }

   /* Close the debug file and return the result code.   */

   t = time( NULL);
   fprintf( debug_file, "\nEnding run at %s\n", ctime( &t));
   fclose(debug_file);

   return rval;
}
