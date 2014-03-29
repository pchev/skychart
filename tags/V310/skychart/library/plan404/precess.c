/* Precession of the equinox and ecliptic
 * from epoch Julian date J to or from J2000.0
 *
 * Program by Steve Moshier.  */
#include "plantbl.h"

#define WILLIAMS 1
/* James G. Williams, "Contributions to the Earth's obliquity rate,
   precession, and nutation,"  Astron. J. 108, 711-724 (1994)  */

#define SIMON 0
/* J. L. Simon, P. Bretagnon, J. Chapront, M. Chapront-Touze', G. Francou,
   and J. Laskar, "Numerical Expressions for precession formulae and
   mean elements for the Moon and the planets," Astronomy and Astrophysics
   282, 663-683 (1994)  */

#define IAU 0
/* IAU Coefficients are from:
 * J. H. Lieske, T. Lederle, W. Fricke, and B. Morando,
 * "Expressions for the Precession Quantities Based upon the IAU
 * (1976) System of Astronomical Constants,"  Astronomy and
 * Astrophysics 58, 1-16 (1977).
 */

#define LASKAR 0
/* Newer formulas that cover a much longer time span are from:
 * J. Laskar, "Secular terms of classical planetary theories
 * using the results of general theory," Astronomy and Astrophysics
 * 157, 59070 (1986).
 *
 * See also:
 * P. Bretagnon and G. Francou, "Planetary theories in rectangular
 * and spherical variables. VSOP87 solutions," Astronomy and
 * Astrophysics 202, 309-315 (1988).
 *
 * Laskar's expansions are said by Bretagnon and Francou
 * to have "a precision of about 1" over 10000 years before
 * and after J2000.0 in so far as the precession constants p^0_A
 * and epsilon^0_A are perfectly known."
 *
 * Bretagnon and Francou's expansions for the node and inclination
 * of the ecliptic were derived from Laskar's data but were truncated
 * after the term in T**6. I have recomputed these expansions from
 * Laskar's data, retaining powers up to T**10 in the result.
 *
 * The following table indicates the differences between the result
 * of the IAU formula and Laskar's formula using four different test
 * vectors, checking at J2000 plus and minus the indicated number
 * of years.
 *
 *   Years       Arc
 * from J2000  Seconds
 * ----------  -------
 *        0	  0
 *      100	.006	
 *      200     .006
 *      500     .015
 *     1000     .28
 *     2000    6.4
 *     3000   38.
 *    10000 9400.
 */

#define DOUBLE double
double cos(), sin();
#define COS cos
#define SIN sin
extern DOUBLE J2000; /* = 2451545.0, 2000 January 1.5 */
extern DOUBLE STR; /* = 4.8481368110953599359e-6 radians per arc second */
extern DOUBLE coseps, sineps; /* see epsiln.c */
extern int epsiln();

/* In WILLIAMS and SIMON, Laskar's terms of order higher than t^4
   have been retained, because Simon et al mention that the solution
   is the same except for the lower order terms.  */
#if WILLIAMS
static DOUBLE pAcof[] = {
 -8.66e-10, -4.759e-8, 2.424e-7, 1.3095e-5, 1.7451e-4, -1.8055e-3,
 -0.235316, 0.076, 110.5407, 50287.70000 };
#endif
#if SIMON
/* Precession coefficients from Simon et al: */
static DOUBLE pAcof[] = {
 -8.66e-10, -4.759e-8, 2.424e-7, 1.3095e-5, 1.7451e-4, -1.8055e-3,
 -0.235316, 0.07732, 111.2022, 50288.200 };
#endif
#if LASKAR
/* Precession coefficients taken from Laskar's paper: */
static DOUBLE pAcof[] = {
 -8.66e-10, -4.759e-8, 2.424e-7, 1.3095e-5, 1.7451e-4, -1.8055e-3,
 -0.235316, 0.07732, 111.1971, 50290.966 };
#endif
#if WILLIAMS
static DOUBLE nodecof[] = {
6.6402e-16, -2.69151e-15, -1.547021e-12, 7.521313e-12, 1.9e-10, 
-3.54e-9, -1.8103e-7,  1.26e-7,  7.436169e-5,
-0.04207794833,  3.052115282424};
static DOUBLE inclcof[] = {
1.2147e-16, 7.3759e-17, -8.26287e-14, 2.503410e-13, 2.4650839e-11, 
-5.4000441e-11, 1.32115526e-9, -6.012e-7, -1.62442e-5,
 0.00227850649, 0.0 };
#endif
#if SIMON
static DOUBLE nodecof[] = {
6.6402e-16, -2.69151e-15, -1.547021e-12, 7.521313e-12, 1.9e-10, 
-3.54e-9, -1.8103e-7, 2.579e-8, 7.4379679e-5,
-0.0420782900, 3.0521126906};

static DOUBLE inclcof[] = {
1.2147e-16, 7.3759e-17, -8.26287e-14, 2.503410e-13, 2.4650839e-11, 
-5.4000441e-11, 1.32115526e-9, -5.99908e-7, -1.624383e-5,
 0.002278492868, 0.0 };
#endif
#if LASKAR
/* Node and inclination of the earth's orbit computed from
 * Laskar's data as done in Bretagnon and Francou's paper.
 * Units are radians.
 */
static DOUBLE nodecof[] = {
6.6402e-16, -2.69151e-15, -1.547021e-12, 7.521313e-12, 6.3190131e-10, 
-3.48388152e-9, -1.813065896e-7, 2.75036225e-8, 7.4394531426e-5,
-0.042078604317, 3.052112654975 };

static DOUBLE inclcof[] = {
1.2147e-16, 7.3759e-17, -8.26287e-14, 2.503410e-13, 2.4650839e-11, 
-5.4000441e-11, 1.32115526e-9, -5.998737027e-7, -1.6242797091e-5,
 0.002278495537, 0.0 };
#endif


/* Subroutine arguments:
 *
 * R = rectangular equatorial coordinate vector to be precessed.
 *     The result is written back into the input vector.
 * J = Julian date
 * direction =
 *      Precess from J to J2000: direction = 1
 *      Precess from J2000 to J: direction = -1
 * Note that if you want to precess from J1 to J2, you would
 * first go from J1 to J2000, then call the program again
 * to go from J2000 to J2.
 */

int precess( R, J, direction )
DOUBLE R[], J;
int direction;
{
DOUBLE A, B, T, pA, W, z;
DOUBLE x[3];
DOUBLE *p;
int i;
#if IAU
DOUBLE sinth, costh, sinZ, cosZ, sinz, cosz, Z, TH;
#endif

if( J == J2000 )
	return(0);
/* Each precession angle is specified by a polynomial in
 * T = Julian centuries from J2000.0.  See AA page B18.
 */
T = (J - J2000)/36525.0;

#if IAU
/* Use IAU formula only for a few centuries, if at all.  */
if( FABS(T) > Two )
	goto laskar;

Z =  (( 0.017998*T + 0.30188)*T + 2306.2181)*T*STR;
z =  (( 0.018203*T + 1.09468)*T + 2306.2181)*T*STR;
TH = ((-0.041833*T - 0.42665)*T + 2004.3109)*T*STR;

sinth = SIN(TH);
costh = COS(TH);
sinZ = SIN(Z);
cosZ = COS(Z);
sinz = SIN(z);
cosz = COS(z);
A = cosZ*costh;
B = sinZ*costh;

if( direction < 0 )
	{ /* From J2000.0 to J */
	x[0] =    (A*cosz - sinZ*sinz)*R[0]
	        - (B*cosz + cosZ*sinz)*R[1]
	                  - sinth*cosz*R[2];

	x[1] =    (A*sinz + sinZ*cosz)*R[0]
	        - (B*sinz - cosZ*cosz)*R[1]
	                  - sinth*sinz*R[2];

	x[2] =              cosZ*sinth*R[0]
	                  - sinZ*sinth*R[1]
	                       + costh*R[2];
	}
else
	{ /* From J to J2000.0 */
	x[0] =    (A*cosz - sinZ*sinz)*R[0]
	        + (A*sinz + sinZ*cosz)*R[1]
	                  + cosZ*sinth*R[2];

	x[1] =   -(B*cosz + cosZ*sinz)*R[0]
	        - (B*sinz - cosZ*cosz)*R[1]
	                  - sinZ*sinth*R[2];

	x[2] =             -sinth*cosz*R[0]
	                  - sinth*sinz*R[1]
	                       + costh*R[2];
	}	
goto done;

laskar:
#endif /* IAU */

/* Implementation by elementary rotations using Laskar's expansions.
 * First rotate about the x axis from the initial equator
 * to the ecliptic. (The input is equatorial.)
 */
if( direction == 1 )
	epsiln( J ); /* To J2000 */
else
	epsiln( J2000 ); /* From J2000 */
x[0] = R[0];
z = coseps*R[1] + sineps*R[2];
x[2] = -sineps*R[1] + coseps*R[2];
x[1] = z;

/* Precession in longitude
 */
T /= 10.0; /* thousands of years */
p = pAcof;
pA = *p++;
for( i=0; i<9; i++ )
	pA = pA * T + *p++;
pA *= STR * T;

/* Node of the moving ecliptic on the J2000 ecliptic.
 */
p = nodecof;
W = *p++;
for( i=0; i<10; i++ )
	W = W * T + *p++;

/* Rotate about z axis to the node.
 */
if( direction == 1 )
	z = W + pA;
else
	z = W;
B = COS(z);
A = SIN(z);
z = B * x[0] + A * x[1];
x[1] = -A * x[0] + B * x[1];
x[0] = z;

/* Rotate about new x axis by the inclination of the moving
 * ecliptic on the J2000 ecliptic.
 */
p = inclcof;
z = *p++;
for( i=0; i<10; i++ )
	z = z * T + *p++;
if( direction == 1 )
	z = -z;
B = COS(z);
A = SIN(z);
z = B * x[1] + A * x[2];
x[2] = -A * x[1] + B * x[2];
x[1] = z;

/* Rotate about new z axis back from the node.
 */
if( direction == 1 )
	z = -W;
else
	z = -W - pA;
B = COS(z);
A = SIN(z);
z = B * x[0] + A * x[1];
x[1] = -A * x[0] + B * x[1];
x[0] = z;

/* Rotate about x axis to final equator.
 */
if( direction == 1 )
	epsiln( J2000 );
else
	epsiln( J );
z = coseps * x[1] - sineps * x[2];
x[2] = sineps * x[1] + coseps * x[2];
x[1] = z;

#if IAU
done:
#endif

for( i=0; i<3; i++ )
	R[i] = x[i];
return(0);
}
