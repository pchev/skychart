#include "plantbl.h"
#define TIMESCALE 3652500.0
#define mods3600(x) ((x) - 1.296e6 * floor ((x)/1.296e6))

//static double J2000 = 2451545.0;
#if 0
/* Conversion factors between degrees and radians */
static double DTR = 1.7453292519943295769e-2;
static double RTD = 5.7295779513082320877e1;
static double RTS = 2.0626480624709635516e5;	/* arc seconds per radian */
#endif
//static double STR = 4.8481368110953599359e-6;	/* radians per arc second */

/* From Simon et al (1994)  */
static double freqs[] =
{
/* Arc sec per 10000 Julian years.  */
  53810162868.8982,
  21066413643.3548,
  12959774228.3429,
  6890507749.3988,
  1092566037.7991,
  439960985.5372,
  154248119.3933,
  78655032.0744,
  52272245.1795
};

static double phases[] =
{
/* Arc sec.  */
  252.25090552 * 3600.,
  181.97980085 * 3600.,
  100.46645683 * 3600.,
  355.43299958 * 3600.,
  34.35151874 * 3600.,
  50.07744430 * 3600.,
  314.05500511 * 3600.,
  304.34866548 * 3600.,
  860492.1546,
};

static double ss[9][24];
static double cc[9][24];

double cos (), sin (), floor (), fabs ();
static int sscc ();

int 
gplan (J, plan, pobj)
     double J;
     struct plantbl *plan;
     double pobj[];
{
  int i, j, k, m, k1, ip, np, nt;
  char *p;
  double *pl, *pb, *pr;
  register double su, cu, sv, cv, T;
  double t, sl, sb, sr;

  T = (J - J2000) / TIMESCALE;
  /* Calculate sin( i*MM ), etc. for needed multiple angles.  */
  for (i = 0; i < 9; i++)
    {
      if ((j = plan->max_harmonic[i]) > 0)
	{
	  sr = (mods3600 (freqs[i] * T) + phases[i]) * STR;
	  sscc (i, sr, j);
	}
    }

  /* Point to start of table of arguments. */
  p = plan->arg_tbl;
  /* Point to tabulated cosine and sine amplitudes.  */
  pl = plan->lon_tbl;
  pb = plan->lat_tbl;
  pr = plan->rad_tbl;
  sl = 0.0;
  sb = 0.0;
  sr = 0.0;

  for (;;)
    {
      /* argument of sine and cosine */
      /* Number of periodic arguments. */
      np = *p++;
      if (np < 0)
	break;
      if (np == 0)
	{			/* It is a polynomial term.  */
	  nt = *p++;
	  /* Longitude polynomial. */
	  cu = *pl++;
	  for (ip = 0; ip < nt; ip++)
	    {
	      cu = cu * T + *pl++;
	    }
	  sl +=  mods3600 (cu);
	  /* Latitude polynomial. */
	  cu = *pb++;
	  for (ip = 0; ip < nt; ip++)
	    {
	      cu = cu * T + *pb++;
	    }
	  sb += cu;
	  /* Radius polynomial. */
	  cu = *pr++;
	  for (ip = 0; ip < nt; ip++)
	    {
	      cu = cu * T + *pr++;
	    }
	  sr += cu;
	  continue;
	}
      k1 = 0;
      cv = 0.0;
      sv = 0.0;
      for (ip = 0; ip < np; ip++)
	{
	  /* What harmonic.  */
	  j = *p++;
	  /* Which planet.  */
	  m = *p++ - 1;
	  if (j)
	    {
	      k = j;
	      if (j < 0)
		k = -k;
	      k -= 1;
	      su = ss[m][k];	/* sin(k*angle) */
	      if (j < 0)
		su = -su;
	      cu = cc[m][k];
	      if (k1 == 0)
		{		/* set first angle */
		  sv = su;
		  cv = cu;
		  k1 = 1;
		}
	      else
		{		/* combine angles */
		  t = su * cv + cu * sv;
		  cv = cu * cv - su * sv;
		  sv = t;
		}
	    }
	}
      /* Highest power of T.  */
      nt = *p++;
      /* Longitude. */
      cu = *pl++;
      su = *pl++;
      for (ip = 0; ip < nt; ip++)
	{
	  cu = cu * T + *pl++;
	  su = su * T + *pl++;
	}
      sl += cu * cv + su * sv;
      /* Latitiude. */
      cu = *pb++;
      su = *pb++;
      for (ip = 0; ip < nt; ip++)
	{
	  cu = cu * T + *pb++;
	  su = su * T + *pb++;
	}
      sb += cu * cv + su * sv;
      /* Radius. */
      cu = *pr++;
      su = *pr++;
      for (ip = 0; ip < nt; ip++)
	{
	  cu = cu * T + *pr++;
	  su = su * T + *pr++;
	}
      sr += cu * cv + su * sv;
    }
  pobj[0] = STR * sl;
  pobj[1] = STR * sb;
  pobj[2] = STR * plan->distance * sr + plan->distance;
  return (0);
}


/* Prepare lookup table of sin and cos ( i*Lj )
 * for required multiple angles
 */
static int 
sscc (k, arg, n)
     int k;
     double arg;
     int n;
{
  double cu, su, cv, sv, s;
  int i;

  su = sin (arg);
  cu = cos (arg);
  ss[k][0] = su;		/* sin(L) */
  cc[k][0] = cu;		/* cos(L) */
  sv = 2.0 * su * cu;
  cv = cu * cu - su * su;
  ss[k][1] = sv;		/* sin(2L) */
  cc[k][1] = cv;
  for (i = 2; i < n; i++)
    {
      s = su * cv + cu * sv;
      cv = cu * cv - su * sv;
      sv = s;
      ss[k][i] = sv;		/* sin( i+1 L ) */
      cc[k][i] = cv;
    }
  return (0);
}
