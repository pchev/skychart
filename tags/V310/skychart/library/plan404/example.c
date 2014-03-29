/* Example program showing how to use gplan.c to evaluate
   the trigonometric series for heliocentric ecliptic coordinates
   of the planets.  The tables give J2000 positions; the program
   precesses them to the equinox and ecliptic of date.  */

#include <stdio.h>
#include "plantbl.h"
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

/*  Cosine and sine of 84381.412" */
extern double sineps, coseps;
double STR = 4.8481368110953599359e-6;	/* radians per arc second */
double RTD = 5.7295779513082320877e1;   /* degrees per radian */
double DTR = 1.7453292519943295769e-2;	/* radians per degree */
double TPI = 6.28318530717958647693;
double J2000 = 2451545.0;

double cos (), sin (), atan2 (), asin ();
int gplan (), precess (), epsiln (), dms (), gmoon ();
void exit ();

void 
main (argc, argv)
     int argc;
     char **argv;
{
  double J, r;
  double rec[3], pol[3], req[3];
  int i;

  if (argc < 2)
    {
      printf ("Usage: example Julian_day_number\n");
      exit (1);
    }

  sscanf (argv[1], "%lf", &J);
  printf ("%.1f\n", J);
  printf ("        Longitude           Latitude      Distance\n");
  for (i = 0; i < 9; i++)
    {
      gplan (J, planets[i], pol);
      /* Convert ecliptic polar coordinates to ecliptic rectangular
	 coordinates.  */
      r = pol[2];
      rec[0] = cos (pol[0]) * r;
      rec[1] = sin (pol[0]) * r;
      rec[2] = sin (pol[1]) * r;
      /* Rotate coordinates from ecliptic to equatorial.  */
      epsiln (J2000);
      req[0] = rec[0];
      req[1] = coseps * rec[1] - sineps * rec[2];
      req[2] = sineps * rec[1] + coseps * rec[2];
      /* Precess from J2000 to date.  */
      precess (req, J, -1);
      /* Rotate equatorial coordinates to ecliptic of date.  */
      epsiln (J);
      rec[0] = req[0];
      rec[1] = coseps * req[1] + sineps * req[2];
      rec[2] = -sineps * req[1] + coseps * req[2];
      /* Convert to ecliptic polar coordinates.  */
      pol[0] = atan2 (rec[1], rec[0]);
      if (pol[0] < 0)
	pol[0] += TPI;
      pol[1] = asin (rec[2] / r);
      pol[2] = r;
      if (i == 2)
	printf ("EMB : ");
      else
	printf ("%4d: ", i + 1);
      dms (pol[0]);
      dms (pol[1]);
      printf ("%.6e\n", pol[2]);
    }
  gmoon (J, rec, pol);
  printf ("MOON: ");
  dms (pol[0]);
  dms (pol[1]);
  printf ("%.6e\n", pol[2]);
}


/* Radians to degrees, minutes, seconds.  */
int 
dms (x)
     double x;
{
  double s;
  int d, m, sign;

  s = x * RTD;
  if (s < 0.0)
    {
      printf (" -");
      sign = -1;
      s = -s;
    }
  else
    {
      printf ("  ");
      sign = 1;
    }
  d = s;
  s -= d;
  s *= 60;
  m = s;
  s -= m;
  s *= 60;
  printf ("%3dd %02d\' %04.1f\"  ", d, m, s);
  return (0);
}
