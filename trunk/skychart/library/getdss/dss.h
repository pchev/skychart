
#define HEADER struct header

HEADER
   {
   double amd_x_coeff[20];
   double amd_y_coeff[20];
   double ppo_coeff[6];
   double x_pixel_size, y_pixel_size;
   double plt_center_ra, plt_center_dec;
   double wcs_center[2], wcs_reference_pixel[2], wcs_delta[2], wcs_rota[2];
   double wcs_cd_matrix[2][2];
   double epoch, equinox;
   int xsize, ysize, x0, y0, n_lines, dec_sign, bits_per_pixel, bzero;
   int wcs_keywords_found, dss_keywords_found;
   };

void amdpos( const HEADER *h, const double x, const double y,
                      double *ra, double *dec);
void amdinv( const HEADER *header, const double ra, const double dec,
/*                  double mag, double col,        */
                    double *x, double *y);
int add_header_line( HEADER *h, const char *buff);

#define DSS_IMG_FOUND_WCS_ROTA            1
#define DSS_IMG_FOUND_WCS_CENTER          2
#define DSS_IMG_FOUND_WCS_REF_PIXEL       4
#define DSS_IMG_FOUND_WCS_DELTA           8
#define DSS_IMG_FOUND_WCS_MATRIX         16

#define DSS_IMG_FOUND_OLD_WCS_KEYWORDS       15
         /* above is sum of 'rota', 'center', 'ref pixel', 'delta' */
#define DSS_IMG_FOUND_NEW_WCS_KEYWORDS       22
         /* above is sum of 'center', 'ref pixel', 'matrix' */
#define DSS_IMG_FOUND_BOTH_WCS_KEYWORDS      31

#define DSS_IMG_FOUND_DSS_PLATE_RA_H          0x0001
#define DSS_IMG_FOUND_DSS_PLATE_RA_M          0x0002
#define DSS_IMG_FOUND_DSS_PLATE_RA_S          0x0004
#define DSS_IMG_FOUND_DSS_PLATE_DEC_D         0x0008
#define DSS_IMG_FOUND_DSS_PLATE_DEC_M         0x0010
#define DSS_IMG_FOUND_DSS_PLATE_DEC_S         0x0020
#define DSS_IMG_FOUND_DSS_PLATE_DEC_SIGN      0x0040
#define DSS_IMG_FOUND_DSS_XPIXELSZ            0x0080
#define DSS_IMG_FOUND_DSS_YPIXELSZ            0x0100
#define DSS_IMG_FOUND_DSS_PPO                 0x0200
#define DSS_IMG_FOUND_DSS_AMDX                0x0400
#define DSS_IMG_FOUND_DSS_AMDY                0x0800

#define DSS_IMG_FOUND_DSS_ALL_KEYWORDS        0x0fff
