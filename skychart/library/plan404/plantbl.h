// define "far" if require by your compiler
#ifdef _MSC_VER
#define FAR
#else
#define FAR
#endif

struct plantbl {
  char max_harmonic[9];
  char max_power_of_t;
  char FAR *arg_tbl;
  double FAR *lon_tbl;
  double FAR *lat_tbl;
  double FAR *rad_tbl;
  double distance;
};

static double J2000 = 2451545.0;
static double STR = 4.8481368110953599359e-6;	/* radians per arc second */

static double DTR = 1.7453292519943295769e-2;
static double RTD = 5.7295779513082320877e1;
static double RTS = 2.0626480624709635516e5;	/* arc seconds per radian */


