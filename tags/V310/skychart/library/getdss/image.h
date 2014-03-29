/*
** Image.h
** Header for the "GetImage" DLL to extract FITS files from RealSky.
**
** Created:   29-JUN-98
**
** $History: Image.h $
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

#include "Errcode.h"


/* Structure to pass configuration information between      */
/* SkyMap and the DLL:                                      */

struct SImageConfig
{
   const char *pDir;            /* RealSky data directory    */
   const char *pDrive;          /* RealSky CD drive string   */
   const char *pImageFile;      /* pathname of image file    */
   int nDataSource;             /* data source               */
   BOOL bPromptForDisk;         /* prompt for disk flag      */
   int nSubSample;              /* subsample size            */
   double dRA;                  /* centre RA, radians        */
   double dDec;                 /* centre dec, radians       */
   double dWidth;               /* image width, arcmin       */
   double dHeight;              /* image height, arcmin      */
   HWND hWnd;                   /* application window handle */
};


int ImageExtract( SImageConfig *pConfig );

#ifdef __cplusplus
}
#endif

