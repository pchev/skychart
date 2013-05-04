/*
** Image.h
** Header for the "GetImage" library to extract FITS files from RealSky.
**
** Created:   29-JUN-98
**
** $History: Image.h $
**
** ************* Cartes du Ciel *******************
** Adapted for "Cartes du Ciel" by Patrick Chevalley
** June 5 1999
** Add parameters for message prompt
**
** *****************  Version 2  *****************
** User: Chris        Date: 24/08/98   Time: 9:57
** Updated in $/SkyMap 4.0/get_dss
** Include the "Errcode.h" header in this file.
**
** *****************  Version 1  *****************
** User: Chris        Date: 21/08/98   Time: 17:18
** Created in $/SkyMap 4.0/get_dss
** Initial version.
**
** *****************  Version 2  *****************
** User: Chris        Date: 5/07/98    Time: 10:28p
** Updated in $/SkyMap 4.0/GetImage
** Initial version.
**
** *****************  Version 1  *****************
** User: Chris        Date: 2/07/98    Time: 7:06p
** Created in $/SkyMap 4.0/GetImage
** Initial version
*/

#ifdef __cplusplus
extern "C" {
#endif

#include "errcode.h"

/* comment the folowing line in case of compilation problem */
#ifdef  UNIX
 const int _MAX_PATH = 255;
#endif

/* Structure to pass configuration information between   */
/* SkyMap and the DLL:                                   */

struct SImageConfig
{
   const char *pDir;             /* RealSky data directory    */
   const char *pDrive;           /* RealSky CD drive string   */
   const char *pImageFile;       /* pathname of image file    */
   int nDataSource;              /* data source               */
   bool bPromptForDisk;          /* prompt for disk flag      */
   int nSubSample;               /* subsample size            */
   double dRA;                   /* centre RA, radians        */
   double dDec;                  /* centre dec, radians       */
   double dWidth;                /* image width, arcmin       */
   double dHeight;               /* image height, arcmin      */
   int  hWnd;                    /* application window handle */
   const char *pAppliName;       /* application name          */
   const char *pPrompt1;         /* message prompt for CD     */
   const char *pPrompt2;         /* message prompt for drive  */

};

#ifdef __cplusplus
const int MaxPlateList = 10;
#else    /* __cplusplus */
#define MaxPlateList 10
#endif   /* __cplusplus */

struct SPlateData
{
   int nplate;
   char *pName[MaxPlateList];
   char *pGSCName[MaxPlateList];
   int dist_from_edge[MaxPlateList], cd_number[MaxPlateList], is_uk_survey[MaxPlateList];
   double year_imaged[MaxPlateList];
   double exposure[MaxPlateList];
};


int ImageExtract( SImageConfig *pConfig );
int GetPlateList( SImageConfig *pConfig , SPlateData *pd);
int ImageExtractFromPlate( SImageConfig *pConfig ,char *ReqPlateName );


#ifdef __cplusplus
}
#endif

