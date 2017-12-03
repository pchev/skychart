/* Example program showing how to use gplan.c to evaluate
   the trigonometric series for heliocentric ecliptic coordinates
   of the planets.  The tables give J2000 positions; the program
   precesses them to the equinox and ecliptic of date.  */

/* Converted to DLL for use with Cartes du Ciel 
   
   Compute heliocentric equatorial J2000 rectangular coordinates in AU
   and heliocentric ecliptic J2000 polar coordinates in radians.
   Refer to plan404.h for parameters.
   Planet number are :

                 1 : Mercury.
                 2 : Venus.
                 3 : Earth.
                 4 : Mars.
                 5 : Jupiter.
                 6 : Saturn.
                 7 : Uranus.
                 8 : Neptune.
                 9 : Pluto.
 
   Patrick Chevalley
   November 6 1999
*/
/* Small change for .so library

   Add Moon : planet number = 11

   BEWARE that all Moon coordinates are for the equinox of the date !

   Patrick Chevalley
   January 2 2003
*/

#include <stdio.h>
#include "plantbl.h"
#include "plan404.h"

extern struct plantbl mer404, ven404, ear404, mar404;
extern struct plantbl jup404, sat404, ura404, nep404, plu404;

struct plantbl *planets[] =
{
  &mer404,
  &ven404,
  &ear404,
  &mar404,
  &jup404,
  &sat404,
  &ura404,
  &nep404,
  &plu404
};

double sineps2k = 3.97777155754e-1; // ecliptic J2000
double coseps2k = 9.17482062146e-1;

double cos (), sin ();
int gplan (), gmoon ();

int Plan404 ( pla ) 
 struct PlanetData *pla;
{
  double J , r ;
  double rec[3], pol[3];
  int i;

      J = pla->JD;
      i = pla->ipla - 1;

      if ( i < 0 || i > 10)
        {
         return (1) ;
        }
      if ( i < 9 )
       {
        gplan (J, planets[i], pol);

        pla->L = pol[0];
        pla->B = pol[1];
        pla->R = pol[2];
        /* Convert ecliptic polar coordinates to ecliptic rectangular	 coordinates.  */
        r = pol[2];
        rec[0] = cos (pol[0]) * cos (pol[1]) * r;
        rec[1] = sin (pol[0]) * cos (pol[1]) * r;
        rec[2] = sin (pol[1]) * r;
        /* Rotate coordinates from ecliptic to equatorial.  */
        pla->X = rec[0];
        pla->Y = coseps2k * rec[1] - sineps2k * rec[2];
        pla->Z = sineps2k * rec[1] + coseps2k * rec[2];
       }
      if ( i == 10 )
       {
        gmoon (J, rec, pol);

        pla->X = rec[0];
        pla->Y = rec[1];
        pla->Z = rec[2];

	pla->L = pol[0];
        pla->B = pol[1];
        pla->R = pol[2];
       }
      return(0);
}
