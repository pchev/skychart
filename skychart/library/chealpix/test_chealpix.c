/* -----------------------------------------------------------------------------
 *
 *  Copyright (C) 1997-2016 Krzysztof M. Gorski, Eric Hivon, Martin Reinecke,
 *                          Benjamin D. Wandelt, Anthony J. Banday,
 *                          Matthias Bartelmann,
 *                          Reza Ansari & Kenneth M. Ganga
 *
 *
 *  This file is part of HEALPix.
 *
 *  HEALPix is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  HEALPix is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with HEALPix; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 *  For more information about HEALPix see http://healpix.sourceforge.net
 *
 *--------------------------------------------------------------------------- */

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#include "chealpix.h"

static void test1_helper1 (long nside, long dpix)
  {
  double theta, phi;
  double vec[3];
  long  ipix, npix, ip2, ip1;

  /* Find the number of pixels in the full map */
  npix = nside2npix(nside);

  for (ipix = 0; ipix < npix; ipix +=dpix) {
    nest2ring(nside, ipix, &ip2);
    ring2nest(nside,ip2,&ip1);
    if (ip1 != ipix) {
      printf("Error0: %ld %ld %ld %ld\n",nside,ipix,ip2,ip1);
      abort();
    }
  }
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2ang_nest(nside, ipix, &theta, &phi);
    ang2pix_nest(nside, theta, phi, &ip1);
    if (ip1 != ipix) {
      printf("Error1: %ld %ld %ld\n",nside,ipix,ip1);
      abort();
    }
  }
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2vec_nest(nside, ipix, vec);
    vec2pix_nest(nside, vec, &ip1);
    if (ip1 != ipix) {
      printf("Error1: %ld %ld %ld\n",nside,ipix,ip1);
      abort();
    }
  }
  }

static void test1_helper2 (long nside, long dpix)
  {
  double theta, phi;
  double vec[3];
  long  ipix, npix, ip1;

  /* Find the number of pixels in the full map */
  npix = nside2npix(nside);
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2ang_ring(nside, ipix, &theta, &phi);
    ang2pix_ring(nside, theta, phi, &ip1);
    if (ip1 != ipix) {
      printf("Error1: %ld %ld %ld\n",nside,ipix,ip1);
      abort();
    }
  }
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2vec_ring(nside, ipix, vec);
    vec2pix_ring(nside, vec, &ip1);
    if (ip1 != ipix) {
      printf("Error1: %ld %ld %ld\n",nside,ipix,ip1);
      abort();
    }
  }
  }

static void test1(void) {

  int64_t  nside;
  int i;

  printf("Starting C Healpix pixel routines test for normal nsides\n");

  for (i=0; i<=13; ++i)
    {
    nside = 1LL<<i;
    printf("Nside: %" PRId64 "\n",nside);
    test1_helper1(nside,nside*nside/123456+1);
    test1_helper2(nside,nside*nside/123456+1);
    }

  for (i=0; i<=12; ++i)
    {
    nside = (1LL<<i)+5;
    printf("Nside: %" PRId64 "\n",nside);
    test1_helper2(nside,nside*nside/123456+1);
    }

  printf("test completed\n\n");
}

static void test2_helper1 (int64_t nside, int64_t dpix)
  {
  double theta, phi;
  double vec[3];
  int64_t  ipix, npix, ip2, ip1;

  /* Find the number of pixels in the full map */
  npix = nside2npix64(nside);

  for (ipix = 0; ipix < npix; ipix +=dpix) {
    nest2ring64(nside, ipix, &ip2);
    ring2nest64(nside,ip2,&ip1);
    if (ip1 != ipix) {
      printf("Error0: %" PRId64 " %" PRId64 " %" PRId64 " %" PRId64 "\n",nside,ipix,ip2,ip1);
      abort();
    }
  }
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2ang_nest64(nside, ipix, &theta, &phi);
    ang2pix_nest64(nside, theta, phi, &ip1);
    if (ip1 != ipix) {
      printf("Error1: %" PRId64 " %" PRId64 " %" PRId64 "\n",nside,ipix,ip1);
      abort();
    }
  }
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2vec_nest64(nside, ipix, vec);
    vec2pix_nest64(nside, vec, &ip1);
    if (ip1 != ipix) {
      printf("Error1: %" PRId64 " %" PRId64 " %" PRId64 "\n",nside,ipix,ip1);
      abort();
    }
  }
  }

static void test2_helper2 (int64_t nside, int64_t dpix)
  {
  double theta, phi;
  double vec[3];
  int64_t  ipix, npix, ip1;

  /* Find the number of pixels in the full map */
  npix = nside2npix64(nside);
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2ang_ring64(nside, ipix, &theta, &phi);
    ang2pix_ring64(nside, theta, phi, &ip1);
    if (ip1 != ipix) {
      printf("Error1: %" PRId64 " %" PRId64 " %" PRId64 "\n",nside,ipix,ip1);
      abort();
    }
  }
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2vec_ring64(nside, ipix, vec);
    vec2pix_ring64(nside, vec, &ip1);
    if (ip1 != ipix) {
      printf("Error1: %" PRId64 " %" PRId64 " %" PRId64 "\n",nside,ipix,ip1);
      abort();
    }
  }
  }

static void test2(void) {

  int64_t  nside;
  int i;

  printf("Starting C Healpix pixel routines test for high nsides\n");

  for (i=0; i<=29; ++i)
    {
    nside = 1LL<<i;
    printf("Nside: %" PRId64 "\n",nside);
    test2_helper1(nside,nside*nside/123456+1);
    test2_helper2(nside,nside*nside/123456+1);
    }

  for (i=0; i<=28; ++i)
    {
    nside = (1LL<<i)+5;
    printf("Nside: %" PRId64 "\n",nside);
    test2_helper2(nside,nside*nside/123456+1);
    }

  printf("test completed\n\n");
}

static void test3(void) {

  double theta, phi;
  double vec[3];
  long   nside;
  long  ipix, npix, dpix, ip2, ip1;

  printf("Starting C Healpix pixel routines test\n");

  nside = 1024;
  dpix = 23;

  /* Find the number of pixels in the full map */
  npix = nside2npix(nside);
  printf("Number of pixels in full map: %ld\n", npix);

  printf("dpix: %ld\n", dpix);
  printf("Nest -> ang -> vec -> ang -> Ring -> Nest\n");
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2ang_nest(nside, ipix, &theta, &phi);
    ang2vec(theta, phi, vec);
    vec2ang(vec, &theta, &phi);
    ang2pix_ring(nside, theta, phi, &ip2);
    ring2nest(nside,ip2,&ip1);
    if (ip1 != ipix) {
      printf("Error: %ld %ld %ld %ld\n",nside,ipix,ip2,ip1);
      abort();
    }
  }
  printf("Ring -> ang -> Nest -> Ring\n");
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2ang_ring(nside, ipix, &theta, &phi);
    ang2pix_nest(nside, theta, phi, &ip2);
    nest2ring(nside,ip2,&ip1);
    if (ip1 != ipix) {printf("Error: %ld %ld %ld %ld\n",nside,ipix,ip2,ip1);}
  }

  printf("Nest -> vec -> Ring -> Nest\n");
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2vec_nest(nside, ipix, vec);
    vec2pix_ring(nside, vec, &ip2);
    ring2nest(nside,ip2,&ip1);
    if (ip1 != ipix) {printf("Error: %ld %ld %ld %ld\n",nside,ipix,ip2,ip1);}
  }
  printf("Ring -> vec -> Nest -> Ring\n");
  for (ipix = 0; ipix < npix; ipix +=dpix) {
    pix2vec_ring(nside, ipix, vec);
    vec2pix_nest(nside, vec, &ip2);
    nest2ring(nside,ip2,&ip1);
    if (ip1 != ipix) {printf("Error: %ld %ld %ld %ld\n",nside,ipix,ip2,ip1);}
  }

  printf("%ld\n", nside);
  printf("test completed\n\n");
}

#ifdef ENABLE_FITSIO
static void test4 (void) {
  float *map;
  long nside, npix, np, ns;
  int i;
  char file[180] = "test_output.fits" ;
  char fileforce[180] ;
  char order1[10] ;
  char order2[10] ;
  char coord[10] ;


  printf("Starting C Healpix IO test\n");

  nside = 1;
  npix = nside2npix(nside);

  map = (float *)malloc(npix*sizeof(float));

  for (i=0; i<npix; i++){
    map[i] = 2.*i;
  }

  sprintf(fileforce, "!%s",file); /* leading ! to allow overwrite */
  write_healpix_map( map, nside, fileforce, 1, "C");
  fprintf(stdout,"file written\n");
  free(map);

  np = get_fits_size(file, &ns, order1);
  fprintf(stdout,"%s %ld %ld %s\n", file, ns, np, order1);

  map = read_healpix_map(file, &ns, coord, order2);
  if (strcmp(coord,"C")!=0) {printf("Error: Bad coordinate system\n");}
  if (strcmp(order1,order2)!=0) {printf("Error: Bad ordering\n");}
  for (i=0; i<npix; i++){
    if (map[i]!=2.*i) {printf("Error: Bad pixel value\n");}
  }

  free(map);

  printf("test completed\n\n");
}
#endif

int main(void) {
  test1();
  test2();
  test3();
#ifdef ENABLE_FITSIO
  test4();
#endif
  return 0;
}
