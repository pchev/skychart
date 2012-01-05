#define HEADER struct header

HEADER
   {
   double amd_x_coeff[20];
   double amd_y_coeff[20];
   double ppo_coeff[6];
   double x_pixel_size, y_pixel_size;
   double plt_center_ra, plt_center_dec;
   int xsize, ysize, x0, y0, n_lines, dec_sign;
   };

void amdpos( const HEADER *h, double x, double y,
                      double *ra, double *dec);
void amdinv( const HEADER *header, double ra, double dec,
/*                  double mag, double col,        */
                    double *x, double *y);
int add_header_line( HEADER *h, const char *buff);
