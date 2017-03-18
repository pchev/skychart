/* Obliquity of the ecliptic at Julian date J  */

#define SIMON 1
/* J. L. Simon, P. Bretagnon, J. Chapront, M. Chapront-Touze', G. Francou,
   and J. Laskar, "Numerical Expressions for precession formulae and
   mean elements for the Moon and the planets," Astronomy and Astrophysics
   282, 663-683 (1994)  */

/* IAU Coefficients are from:
 * J. H. Lieske, T. Lederle, W. Fricke, and B. Morando,
 * "Expressions for the Precession Quantities Based upon the IAU
 * (1976) System of Astronomical Constants,"  Astronomy and Astrophysics
 * 58, 1-16 (1977).
 *
 * Before or after 200 years from J2000, the formula used is from:
 * J. Laskar, "Secular terms of classical planetary theories
 * using the results of general theory," Astronomy and Astrophysics
 * 157, 59070 (1986).
 *
 *  See precess.c and page B18 of the Astronomical Almanac.
 * 
 */
 #include "plantbl.h"

/* The results of the program are returned in these
 * global variables:
 */
double jdeps = -1.0; /* Date for which obliquity was last computed */
double eps = 0.0; /* The computed obliquity in radians */
double coseps = 0.0; /* Cosine of the obliquity */
double sineps = 0.0; /* Sine of the obliquity */
extern double eps, coseps, sineps, STR;
double sin(), cos(), fabs();

int epsiln(J)
double J; /* Julian date input */
{
double T;

if( J == jdeps )
	return(0);
T = (J - 2451545.0)/36525.0;

/* This expansion is from the AA.
 * Note the official 1976 IAU number is 23d 26' 21.448", but
 * the JPL numerical integration found 21.4119".
 */
#if SIMON
	T /= 10.0;
	eps = ((((((((( 2.45e-10*T + 5.79e-9)*T + 2.787e-7)*T
        + 7.12e-7)*T - 3.905e-5)*T - 2.4967e-3)*T
	- 5.138e-3)*T + 1.9989)*T - 0.0152)*T - 468.0927)*T
	+ 84381.412;
#else
if( fabs(T) < 2.0 )
	eps = ((1.813e-3*T - 5.9e-4)*T - 46.8150)*T + 84381.448;

/* This expansion is from Laskar, cited above.
 * Bretagnon and Simon say, in Planetary Programs and Tables, that it
 * is accurate to 0.1" over a span of 6000 years. Laskar estimates the
 * precision to be 0.01" after 1000 years and a few seconds of arc
 * after 10000 years.
 */
else
	{
	eps = ((((((((( 2.45e-10*T + 5.79e-9)*T + 2.787e-7)*T
        + 7.12e-7)*T - 3.905e-5)*T - 2.4967e-3)*T
	- 5.138e-3)*T + 1.99925)*T - 0.0155)*T - 468.093)*T
	+ 84381.448;
	}
#endif
eps *= STR;
coseps = cos( eps );
sineps = sin( eps );
jdeps = J;
return(0);
}

