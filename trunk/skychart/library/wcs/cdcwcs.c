/* File cdcwcs.c
   
   Shared library for using WCSTools from Skychart
   
   It include code from the following WCSTools program:
      sky2xy.c

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <math.h>
#include <locale.h>
#include "wcs.h"
#include "fitsfile.h"

struct cdcCoord
{
   double ra;		/* input RA degree */
   double de;		/* input DEC degree */
   double x;		/* output pixel X */
   double y;		/* output pixel Y */
   int n;		/* error code */
};
struct cdcWCSinfo
{
 double	cra;		/* Center right ascension in degrees */
 double	cdec;		/* Center declination in degrees */
 double	dra;		/* Right ascension half-width in degrees */
 double	ddec;		/* Declination half-width in degrees */
 double	secpix;		/* Arcseconds per pixel */
 double	eqout;		/* Equinox */
 double	rot;		/* rotation around axis (deg) (N through E) */
 int	wp;		/* Image width in pixels */
 int	hp;		/* Image height in pixels */
 int	sysout;		/* Coordinate system */
};

extern void setrot(),setsys(),setcenter(),setsecpix(),setrefpix(),setdateobs();
extern void setnpix();
extern struct WorldCoor *GetFITSWCS ();	/* Read WCS from FITS or IRAF header */
extern struct WorldCoor *GetWCSFITS ();	/* Read WCS from FITS or IRAF file */
extern char *GetFITShead();

#define maxfitslist 15		/* must correspond to skychart value */
    int verbose = 0;		/* verbose/debugging flag */
    char csys[16];
    struct WorldCoor *wcs[maxfitslist+1];
    char *header[maxfitslist+1];
    double cra, cdec, dra, ddec, secpix;
    double eqout = 0.0;
//    double eqin = 0.0;
//    int sysin;
    int sysout = 0;
    int syscoor = 0;
    int wp, hp;
//    char coorsys[16];

int cdcwcs_initfitsfile (fn, wcsnum)
char *fn;
int wcsnum;
{
  /* ensure decimal dot */
  setlocale(LC_NUMERIC,"C");
  wcs[wcsnum] = NULL;
  //*coorsys = 0;
  header[wcsnum] = GetFITShead (fn, verbose);
  if (header[wcsnum] == NULL) {
    fprintf (stderr, "Invalid header in image file %s\n", fn);
    return (1);
  }
  wcs[wcsnum] = GetFITSWCS (fn,header[wcsnum],verbose,&cra,&cdec,&dra,&ddec,&secpix,&wp, &hp, &sysout, &eqout); 
  if (nowcs (wcs[wcsnum])) {
    fprintf (stderr, "No WCS in image file %s\n", fn);
    wcsfree (wcs[wcsnum]);
    free (header[wcsnum]);
    return (1);
    }
/* Precession is done in skychart.    
  strcpy (coorsys,"J2000");    
  wcsininit (wcs[wcsnum], coorsys);
  strcpy (csys, coorsys);
  sysin = wcscsys (csys);
  eqin = wcsceq (csys);
*/  
  return(0);    
}  

int cdcwcs_release (wcsnum)
int wcsnum;
{
    wcsfree (wcs[wcsnum]);
    free (header[wcsnum]);
    wcs[wcsnum] = NULL;
    return(0);
}  

int cdcwcs_getinfo( p ,  wcsnum)
struct cdcWCSinfo *p;
int wcsnum;
{
  int r;
  r = -1;
  if (wcs[wcsnum] != NULL ) {
    p->cra = cra;
    p->cdec = cdec;
    p->dra = dra;
    p->ddec = ddec;
    p->secpix = secpix;
    p->wp = wp;
    p->hp = hp;
    p->sysout = sysout;
    p->eqout = eqout;
    if ( wcs[wcsnum]->imflip )
         p->rot = wcs[wcsnum]->rot;
    else
         p->rot = -wcs[wcsnum]->rot;
    r = 0;
  }  
  return(r);
}  

int cdcwcs_sky2xy ( p,  wcsnum )
struct cdcCoord *p;
{
double ra, dec, x, y;
int offscale;  
offscale = -1;
if (wcs[wcsnum] != NULL ) {
  ra = p->ra;
  dec = p->de;

  /* Precession is done in skychart.  
  if (wcs[wcsnum]->syswcs > 0 && wcs[wcsnum]->syswcs != 6 && wcs[wcsnum]->syswcs != 10)
      wcscon (sysin, wcs[wcsnum]->syswcs, eqin, eqout, &ra, &dec, wcs[wcsnum]->epoch); */

  wcsc2pix (wcs[wcsnum], ra, dec, csys, &x, &y, &offscale); 
  p->x = x;
  p->y = y;
}
p->n = offscale;
return(offscale);
}

