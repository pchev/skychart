#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "dss.h"

#define PI 3.14159265358979323846264338327950288419716939937510582097494
#define ARCSECONDS_PER_RADIAN (3600. * 180. / PI)

static double compute_plate_poly( double ox, double oy, const double *poly);

/******************************************************************************
*    transtdeq                                                                *
* Module:                                                                     *
*                                                                             *
* File:                                                                       *
*    astronmy.c                                                               *
*                                                                             *
* Description:                                                                *
*     Routine to convert standard coordinates on a plate to RA and Dec in     *
*     radians.                                                                *
*                                                                             *
* Return Value:                                                               *
*    none                                                                     *
*                                                                             *
* Arguments:                                                                  *
*                                                                             *
*    Input Arguments:                                                         *
*       plt_center_ra                                                         *
*          double, Value                                                      *
*             Plate center right ascension in radians                         *
*       plt_center_dec                                                        *
*          double, Value                                                      *
*             Plate center declination in radians                             *
*      xi                                                                     *
*          double, Value                                                      *
*             Input xi standard coordinate in arcseconds.                     *
*      eta                                                                    *
*          double, Value                                                      *
*             Input eta standard coordinate in arcseconds.                    *
*    Input/Output Arguments:                                                  *
*       none                                                                  *
*    Output Arguments:                                                        *
*       ra                                                                    *
*          double, Reference                                                  *
*             Resulting right ascension in radians.                           *
*       dec                                                                   *
*          double, Reference                                                  *
*             Resulting declination in radians.                               *
*                                                                             *
* History:                                                                    *
*    Created    : 07-DEC-90 by R. White,                                      *
*       Converted to Fortran from IDL routine.                                *
*    Delivered  : 31-JUL-91 by R. White,                                      *
*       Convert from Fortran to C.                                            *
*                                                                             *
*    Updated    : 31-JAN-94 by J. Doggett,                                    *
*       Adopted into software used to facilitate the accessing of data from   *
*          the CD-ROM set of the Digitized Sky Survey.                        *
*    Redelivered: 01-MAR-94 by J. Doggett,                                    *
*       GetImage Version 1.0.                                                 *
******************************************************************************/
static inline void transtdeq( const double plt_center_ra,
            const double plt_center_dec,
            const double xi, const double eta, double *ra, double *dec)
{
double object_xi,object_eta,numerator,denominator;
const double cos_plt_center_dec = cos( plt_center_dec);
const double tan_plt_center_dec = sin( plt_center_dec) / cos_plt_center_dec;

    /*
     *  Convert to radians
     */
    object_xi = xi/ARCSECONDS_PER_RADIAN;
    object_eta = eta/ARCSECONDS_PER_RADIAN;

    /*
     *  Convert to RA and Dec
     */
    numerator = object_xi / cos_plt_center_dec;
    denominator = 1 - object_eta * tan_plt_center_dec;
    *ra = atan2( numerator, denominator) + plt_center_ra;
    if (*ra < 0.0) *ra += 2. * PI;

    numerator = cos((*ra) - plt_center_ra);
    denominator /= (object_eta + tan_plt_center_dec);
    *dec = atan( numerator / denominator);
}

static double compute_plate_poly( const double ox, const double oy,
                     const double *poly)
{
   const double ox2 = ox*ox;
   const double oy2 = oy*oy;
   const double ox3 = ox*ox2;
   const double oy3 = oy*oy2;

   return(  poly[ 0]*ox             + poly[ 1]*oy     +
            poly[ 2]                + poly[ 3]*ox2    +
            poly[ 4]*ox*oy          + poly[ 5]*oy2    +
            poly[ 6]*(ox2+oy2)      + poly[ 7]*ox3    +
            poly[ 8]*ox2*oy         + poly[ 9]*ox*oy2 +
            poly[10]*oy3            + poly[11]*ox*(ox2+oy2)   +
            poly[12]*ox*(ox2+oy2)*(ox2*oy2));
}

/******************************************************************************
* Module:                                                                     *
*    amdpos                                                                   *
*                                                                             *
* File:                                                                       *
*    astrmcal.c                                                               *
*                                                                             *
* Description:                                                                *
*       Routine to convert x,y to RA,Dec using the CALOBCC solution.          *
*                                                                             *
* Return Value:                                                               *
*    none                                                                     *
*                                                                             *
* Arguments:                                                                  *
*                                                                             *
*    Input Arguments:                                                         *
*       h                                                                     *
*          HEADER, Reference                                                  *
*             Structure with header information.                              *
*       x                                                                     *
*          double, Value                                                      *
*             Input x position.                                               *
*       y                                                                     *
*          double, Value                                                      *
*             Input y position.                                               *
*       mag                                                                   *
*          double, Value                                                      *
*             Magnitude for the calibration solution.                         *
*       col                                                                   *
*          double, Value                                                      *
*             Color for the calibration solution.                             *
*    Input/Output Arguments:                                                  *
*       none                                                                  *
*    Output Arguments:                                                        *
*       ra                                                                    *
*          double, Reference.                                                 *
*             The resulting right asension.                                   *
*       dec                                                                   *
*          double, Reference                                                  *
*             The resulting declination.                                      *
*                                                                             *
* History:                                                                    *
*    Created    : 21-SEP-90 by R. White,                                      *
*       Converted from IDL routine to Fortran.                                *
*    Delivered  : 31-JUL-91 by R. White,                                      *
*       Converted from Fortran to C.                                          *
*                                                                             *
*    Updated    : 31-JAN-94 by J. Doggett,                                    *
*       Adopted into software used to facilitate the accessing of data from   *
*          the CD-ROM set of the Digitized Sky Survey.                        *
*    Redelivered: 01-MAR-94 by J. Doggett,                                    *
*       GetImage Version 1.0.                                                 *
******************************************************************************/
void amdpos( const HEADER *h, const double x, const double y,
                      double *ra, double *dec)
{
    /*
     *  Convert x,y from pixels to mm measured from plate center
     */

   const double ox = (h->ppo_coeff[2]   - x*h->x_pixel_size)/1000.0;
   const double oy = (y*h->y_pixel_size - h->ppo_coeff[5]  )/1000.0;
    /*
     *  Compute standard coordinates from x,y and plate model
     */
   const double object_xi  = compute_plate_poly( ox, oy, h->amd_x_coeff);

   const double object_eta = compute_plate_poly( oy, ox, h->amd_y_coeff);

    /*
     *  Convert to RA and Dec
     *  Note that ra and dec are already pointers, so we don't need
     *  to pass by address
     */
   transtdeq( h->plt_center_ra, h->plt_center_dec,
                                    object_xi, object_eta, ra, dec);
}

static inline void traneqstd(
                const double plt_center_ra, const double plt_center_dec,
                const double object_ra, const double object_dec,
                double *object_xi, double *object_eta)
{
   const double divisor = sin( object_dec) * sin( plt_center_dec)+
          cos( object_dec) * cos( plt_center_dec) *
          cos( object_ra - plt_center_ra);
                 /* divisor = cos( dist between center and object) */
    /*
     *  Compute standard coords and convert to arcsec
     */
    *object_xi = cos( object_dec) * sin( object_ra - plt_center_ra);

    *object_eta = sin(object_dec)*cos( plt_center_dec)-
        cos(object_dec)*sin(plt_center_dec)*
        cos(object_ra - plt_center_ra);

    *object_xi *= ARCSECONDS_PER_RADIAN / divisor;
    *object_eta *= ARCSECONDS_PER_RADIAN / divisor;
}

void amdinv( const HEADER *header, const double ra, const double dec,
/*                  double mag, double col,        */
                    double *x, double *y)
{
   int max_iterations = 50, convergence_achieved = 0;
   const double tolerance = 0.0000005;
   double xi, eta, object_x, object_y;
   const double fx = header->amd_x_coeff[0];
   const double fy = header->amd_x_coeff[1];
   const double gx = header->amd_y_coeff[1];
   const double gy = header->amd_y_coeff[0];
   const double divisor = (fx * gy - fy * gx);

   traneqstd( header->plt_center_ra, header->plt_center_dec,
                                  ra, dec, &xi, &eta);
   object_x = object_y = 0;
    /*
     *  Iterate by Newtons method
     */
   while( max_iterations-- && !convergence_achieved)
      {
      double delta_xi, delta_eta;
      double delta_x, delta_y;

      delta_xi  = compute_plate_poly( object_x, object_y, header->amd_x_coeff);
      delta_eta = compute_plate_poly( object_y, object_x, header->amd_y_coeff);
      delta_xi  -= xi;
      delta_eta -= eta;

      delta_x = (-delta_xi * gy + delta_eta * fy) / divisor;
      delta_y = (-delta_eta * fx + delta_xi * gx) / divisor;
      object_x += delta_x;
      object_y += delta_y;
      if ((fabs(delta_x) < tolerance) && (fabs(delta_y) < tolerance))
         convergence_achieved = 1;
      }
    /*
     *  Convert mm from plate center to pixels
     */
    *x = (header->ppo_coeff[2]-object_x*1000.0)/header->x_pixel_size;
    *y = (header->ppo_coeff[5]+object_y*1000.0)/header->y_pixel_size;

} /* amdinv */

int add_header_line( HEADER *h, const char *buff)
{
   double ival;
   int int_val, rval = 0;

   if( !memcmp( buff, "END     ", 8))
      return( -1);
   ival = atof( buff + 9);
   int_val = atoi( buff + 9);
   if( !memcmp( buff, "PLTRA", 5))
      {
      switch( buff[5])
         {
         case 'H':
            h->dss_keywords_found |= DSS_IMG_FOUND_DSS_PLATE_RA_H;
            break;
         case 'M':
            h->dss_keywords_found |= DSS_IMG_FOUND_DSS_PLATE_RA_M;
            ival /= 60.;
            break;
         case 'S':
            h->dss_keywords_found |= DSS_IMG_FOUND_DSS_PLATE_RA_S;
            ival /= 3600.;
            break;
         }
      h->plt_center_ra += ival * PI / 12.;
      rval = 1;
      }
   else if( !memcmp( buff, "PLTDEC", 6))
      {
      if( !h->dec_sign)
         h->dec_sign = 1;
      switch( buff[6])
         {
         case 'D':
            h->dss_keywords_found |= DSS_IMG_FOUND_DSS_PLATE_DEC_D;
            break;
         case 'M':
            h->dss_keywords_found |= DSS_IMG_FOUND_DSS_PLATE_DEC_M;
            ival /= 60.;
            break;
         case 'S':
            if( buff[7] == 'N')        /* setting the declination sign */
               {
               ival = 0.;
               if( buff[11] == '-')
                  h->dec_sign = -1;
               h->dss_keywords_found |= DSS_IMG_FOUND_DSS_PLATE_DEC_SIGN;
               }
            else
               {
               h->dss_keywords_found |= DSS_IMG_FOUND_DSS_PLATE_DEC_S;
               ival /= 3600.;
               }
            break;
         }
      h->plt_center_dec += ival * (double)h->dec_sign * PI / 180.;
      rval = 1;
      }
   else if( !memcmp( buff + 1, "PIXELSZ", 7))
      {
      if( *buff == 'X')
         {
         h->dss_keywords_found |= DSS_IMG_FOUND_DSS_XPIXELSZ;
         h->x_pixel_size = ival;
         }
      else if( *buff == 'Y')
         {
         h->dss_keywords_found |= DSS_IMG_FOUND_DSS_YPIXELSZ;
         h->y_pixel_size = ival;
         }
      rval = 1;
      }
   else if( !memcmp( buff, "PPO", 3))
      {
      h->dss_keywords_found |= DSS_IMG_FOUND_DSS_PPO;
      h->ppo_coeff[ atoi( buff + 3) - 1] = ival;
      rval = 1;
      }
   else if( !memcmp( buff, "AMDX", 4))
      {
      h->dss_keywords_found |= DSS_IMG_FOUND_DSS_AMDX;
      h->amd_x_coeff[ atoi( buff + 4) - 1] = ival;
      rval = 1;
      }
   else if( !memcmp( buff, "AMDY", 4))
      {
      h->dss_keywords_found |= DSS_IMG_FOUND_DSS_AMDY;
      h->amd_y_coeff[ atoi( buff + 4) - 1] = ival;
      rval = 1;
      }
   else if( !memcmp( buff, "NAXIS", 5))
      {
      rval = 1;
      if( buff[5] == '1')
         h->xsize = int_val;
      else if( buff[5] == '2')
         h->ysize = int_val;
      else
         rval = 0;
      }
   else if( !memcmp( buff, "CNPIX", 5))
      {
      rval = 1;
      if( buff[5] == '1')
         h->x0 = int_val;
      else if( buff[5] == '2')
         h->y0 = int_val;
      else
         rval = 0;
      }                       /* Following keywords added 23 Feb 2005: */
   else if( !memcmp( buff, "EPOCH ", 6))
      h->epoch = ival;
   else if( !memcmp( buff, "EQUINOX ", 8))
      h->equinox = ival;
   else if( !memcmp( buff, "BZERO ", 6))
      h->bzero = (int)( ival + .5);
   else if( !memcmp( buff, "BITPIX", 6))
      {
      rval = 1;
      h->bits_per_pixel = int_val;
      }

   if( !rval)           /* check out WCS possibilities: */
      if( buff[5] == '1' || buff[5] == '2')
         {
         const int idx = buff[5] - '1';

         rval = 1;
         if( !memcmp( buff, "CRVAL", 5))
            {
            h->wcs_center[idx] = ival * PI / 180.;
            h->wcs_keywords_found |= DSS_IMG_FOUND_WCS_CENTER;
            }
         else if( !memcmp( buff, "CRPIX", 5))
            {
            h->wcs_reference_pixel[idx] = ival;
            h->wcs_keywords_found |= DSS_IMG_FOUND_WCS_REF_PIXEL;
            }
         else if( !memcmp( buff, "CDELT", 5))
            {
            h->wcs_delta[idx] = ival;
            h->wcs_keywords_found |= DSS_IMG_FOUND_WCS_DELTA;
            }
         else if( !memcmp( buff, "CROTA", 5))
            {
            h->wcs_rota[idx] = ival * PI / 180.;
            h->wcs_keywords_found |= DSS_IMG_FOUND_WCS_ROTA;
            }
         else
            rval = 0;
         }

   if( !rval && buff[0] == 'C' && buff[1] == 'D'
                           && buff[3] == '_' && buff[5] == ' ')
      {
      const int idx1 = buff[2] - '1';
      const int idx2 = buff[4] - '1';

      if( idx1 == 0 || idx1 == 1)
         if( idx2 == 0 || idx2 == 1)
            {
            h->wcs_cd_matrix[idx1][idx2] = ival;
            h->wcs_keywords_found |= DSS_IMG_FOUND_WCS_MATRIX;
            rval = 1;
            }
      }
   return( rval);
}
