
/* Local Apparent Sidereal Time with equation of the equinoxes
 * AA page B6
 *
 * The siderial time coefficients are from Williams (1994).
 *
 * Caution. At epoch J2000.0, the 16 decimal precision
 * of IEEE double precision numbers
 * limits time resolution measured by Julian date
 * to approximately 24 microseconds.
 */

#include "plantbl.h"

extern double J2000, TDT, RTD, nutl, coseps;
double floor();
int nutlo(), epsiln();

/* program returns sidereal seconds since sidereal midnight */
double sidrlt( j, tlong )
double j;	/* Julian date and fraction */
double tlong;	/* East longitude of observer, degrees */
{
double jd0;     /* Julian day at midnight Universal Time */
double secs;   /* Time of day, UT seconds since UT midnight */
double eqeq, gmst, jd, T0, T, msday;
/*long il;*/

  /* Julian day at given UT */
jd = j;
jd0 = floor(jd);
secs = j - jd0;
if( secs < 0.5 )
	{
	jd0 -= 0.5;
	secs += 0.5;
	}
else
	{
	jd0 += 0.5;
	secs -= 0.5;
	}
secs *= 86400.0;

  /* Julian centuries from standard epoch J2000.0 */
T = (jd - J2000)/36525.0;
  /* Same but at 0h Universal Time of date */
T0 = (jd0 - J2000)/36525.0;

/* The equation of the equinoxes is the nutation in longitude
 * times the cosine of the obliquity of the ecliptic.
 * We already have routines for these.
 */
nutlo(TDT);
epsiln(TDT);
/* nutl is in radians; convert to seconds of time
 * at 240 seconds per degree
 */
eqeq = 240.0 * RTD * nutl * coseps;
  /* Greenwich Mean Sidereal Time at 0h UT of date */
#if 1
  /* J. G. Williams, "Contributions to the Earth's obliquity rate, precession,
     and nutation,"  Astronomical Journal 108, p. 711 (1994)  */
gmst = (((-2.0e-6*T0 - 3.e-7)*T0 + 9.27695e-2)*T0 + 8640184.7928613)*T0
       + 24110.54841;
/* mean solar (er, UT) days per sidereal day at date T0  */
msday = (((-(4. * 2.0e-6)*T0 - (3. * 3.e-7))*T0 + (2. * 9.27695e-2))*T0
          + 8640184.7928613)/(86400.*36525.) + 1.0;
#else
/* This is the 1976 IAU formula. */
gmst = (( -6.2e-6*T0 + 9.3104e-2)*T0 + 8640184.812866)*T0 + 24110.54841;
/* mean solar days per sidereal day at date T0  */
msday = 1.0 + ((-1.86e-5*T0 + 0.186208)*T0 + 8640184.812866)/(86400.*36525.);
#endif
  /* Local apparent sidereal time at given UT */
gmst = gmst + msday*secs + eqeq + 240.0*tlong;
  /* Sidereal seconds modulo 1 sidereal day */
gmst = gmst - 86400.0 * floor( gmst/86400.0 );
/*
 * il = gmst/86400.0;
 * gmst = gmst - 86400.0 * il;
 * if( gmst < 0.0 )
 *	gmst += 86400.0;
 */
return( gmst );
}
