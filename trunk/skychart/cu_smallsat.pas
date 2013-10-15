unit cu_smallsat;

{ rocks.cpp: coordinates of inner moons of Mars through Pluto

Copyright (C) 2010, Project Pluto

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.    }

{ ROCKS.CPP

   This code generates positions for "rocks" (faint inner satellites
that can be modelled,  at least passably well,  as precessing ellipses).
The currently listed "rocks" are:

  505:         Amalthea     706: 1986U7 Cordelia   801: Triton (Neptune I)
  514: 1979J2  Thebe        707: 1986U8 Ophelia    803: 1989 N6 Naiad
  515: 1979J1  Adrastea     708: 1986U9 Bianca     804: 1989 N5 Thalassa
  516: 1979J3  Metis        709: 1986U3 Cressida   805: 1989 N3 Despina
                            710: 1986U6 Desdemona  806: 1989 N4 Galatea
  610: Janus      (+)       711: 1986U2 Juliet     807: 1989 N2 Larissa
  611: Epimetheus (+)       712: 1986U1 Portia     808: 1989 N1 Proteus
  612: Helene     (+)       713: 1986U4 Rosalind
  613: Telesto    (+)       714: 1986U5 Belinda
  614: Calypso    (+)       715: 1986U1 Puck
  615: 1980S28 Atlas        725: 1986U10 = Perdita       401: Phobos (+)
  616: 1980S27 Prometheus   726: Mab (+)                 402: Deimos (+)
  617: 1980S26 Pandora      727: Cupid (+)
  618: 1981S13 Pan
  635: Daphnis (+)

   The orbital elements were provided by Mark Showalter (some updates from
Bob Jacobson),  along with the following comments:

(1) The listing refers to JPL ephemeris IDs JUP120, SAT080, URA039, and
NEP022(*).  If you select the SPICE ephemerides of the same name in
Horizons, then you really should get almost identical results, because
the SPICE files were generated using these exact elements.

(2) Be aware that Saturn's moons Prometheus and Pandora are exhibiting
peculiar variations in longitude that are not currently understood,
probably related to interactions with the other nearby moons and rings.
So don't expect your results for these bodies to be particularly
accurate.

Regards, Mark Showalter

  -------------------------

(+) Data is provided for this object,  but I've not tried it out in Guide yet.

(*) replaced with JUP250 data 3 Nov 2007,  NEP050 data 8 Jan 2008
(and Triton added),  URA086X on 8 Jan 2008, MAR080 on 13 Feb 2009.
Some others updated as noted in comments.  All Uranians replaced
with URA091 on 22 Dec 2009.

2012 Mar 9:  updated Pan & Daphnis with SAT353.

2013 May 8:  updated Pan & Daphnis with SAT357eq.

}
{
 2013 October 15: Pascal version for Cartes du Ciel. P. Chevalley.

elements available from ftp://ssd.jpl.nasa.gov/pub/eph/satellites/rckin
}

{$mode objfpc}{$H+}

interface

uses math;

function evaluate_rock( jde: double; jpl_id: integer; var output_vect: array of double): boolean;

type
  //define ROCK struct rock
  Trock = record
    jpl_id: integer;
    epoch_jd, a, h, k, mean_lon0, p, q, apsis_rate, mean_motion: double;
    node_rate, laplacian_pole_ra, laplacian_pole_dec: double;
  end;


const
  N_ROCKS = 36;
  deg2rad = pi/180;

  rocks: array [1..N_ROCKS] of Trock = (
    (jpl_id: 401;             { Phobos: MAR080 data }
    epoch_jd: 2433282.50;                           { element epoch Julian date     }
    a: 9.376164153345777E+03;               { a = semi-major axis (km)      }
    h: -5.689907327111091E-04;               { h = e sin(periapsis longitude)}
    k: 1.508976478046249E-02;               { k = e cos(periapsis longitude)}
    mean_lon0: 8.889912565234037E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: -4.374861644190954E-03;               { p = tan(i/2) sin(node)        }
    q: -8.303312581096576E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: 5.037011787882128E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 1.306533283449532E-02 * deg2rad;   { mean motion (deg/sec)         }
    node_rate: -5.043841563630776E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 3.176707407767539E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 5.289299367003886E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 402;             { Deimos:  MAR080 data }
    epoch_jd: 2433282.50;                           { element epoch Julian date     }
    a: 2.345766038183417E+04;               { a = semi-major axis (km)      }
    h: -2.390285567613731E-04;               { h = e sin(periapsis longitude)}
    k: 6.518182753851608E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: 2.505824379527014E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 6.477849519349295E-03;               { p = tan(i/2) sin(node)        }
    q: 1.419810985499536E-02;               { q = tan(i/2) cos(node)        }
    apsis_rate: 2.076162603566793E-07 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 3.300484710930912E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -2.091750616728367E-07 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 3.166569791010836E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 5.352937471037383E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 505;            { Amalthea: JUP250 }
    epoch_jd: 2450000.500000000;                   { element epoch Julian date     }
    a: 1.813655512465877E+05;               { a = semi-major axis (km)      }
    h: 3.524243705442326E-04;               { h = e sin(periapsis longitude)}
    k: -3.060388597797567E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 3.088979995508090E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -8.524633361449484E-04;               { p = tan(i/2) sin(node)        }
    q: -3.277584681172060E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: 2.908651473226303E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 8.363792987058621E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -2.898772964219916E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.680573067077756E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 6.449433514883954E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 514;                { Thebe: JUP250 }
    epoch_jd: 2450000.500000000;                    { element epoch Julian date     }
    a: 2.218882574500956E+05;               { a = semi-major axis (km)      }
    h: -1.707742712451856E-02;               { h = e sin(periapsis longitude)}
    k: -4.631931271882844E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 2.889925861272768E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 9.336528660574965E-03;               { p = tan(i/2) sin(node)        }
    q: 7.503268096368817E-05;               { q = tan(i/2) cos(node)        }
    apsis_rate: 1.433399183927280E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 6.177086242379696E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -1.430832006152276E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.680573566856980E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 6.449436369487705E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 515;           { Adrastea: JUP250 }
    epoch_jd: 2450000.500000000;                    { element epoch Julian date     }
    a: 1.289847619277409E+05;               { a = semi-major axis (km)      }
    h: 7.733436951055491E-05;               { h = e sin(periapsis longitude)}
    k: -7.119915620542968E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 8.469076821476101E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: 7.291459020134167E-04;               { p = tan(i/2) sin(node)        }
    q: 2.676849686756846E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 9.721724518582802E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 1.396989430143032E-02 * deg2rad;     { mean motion (deg/sec)         }
    node_rate: -9.865593193437598E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.680565964128937E+02 * deg2rad;     { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 6.449530295172036E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 516;           { Metis: JUP250 }
    epoch_jd: 2450000.500000000;                    { element epoch Julian date     }
    a: 1.279996083074168E+05;               { a = semi-major axis (km)      }
    h: 4.232619343306958E-04;               { h = e sin(periapsis longitude)}
    k: -6.389823783865655E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 3.380483431923231E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 2.332741944310790E-04;               { p = tan(i/2) sin(node)        }
    q: 5.651570478951611E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 9.905391637419158E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 1.413489189624821E-02 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -9.817915317723091E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.680565964128937E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 6.449530295172036E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 610;      { Janus:  SAT080 data }
    epoch_jd: 2444786.5;                            { element epoch Julian date     }
    a: 1.514471646942220E+05;               { a = semi-major axis (km)      }
    h: -3.356112346396347E-03;               { h = e sin(periapsis longitude)}
    k: 5.663424289609894E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 1.993639755564592E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -1.210639146126198E-03;               { p = tan(i/2) sin(node)        }
    q: 8.350119519512047E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 2.378317712273239E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 5.998806000756397E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -2.367392401124433E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 4.057999864473820E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 8.353999955183330E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 611;      { Epimetheus:  SAT080 data }
    epoch_jd: 2444786.5;                            { element epoch Julian date     }
    a: 1.513991905498270E+05;               { a = semi-major axis (km)      }
    h: 1.244955044467311E-02;               { h = e sin(periapsis longitude)}
    k: 1.689723618147796E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 1.438890791888553E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -1.212371038828309E-03;               { p = tan(i/2) sin(node)        }
    q: 2.571443713031926E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: 2.379040740977320E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 6.001665785000491E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -2.367577385695356E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 4.057999864473820E+01 * deg2rad;     { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 8.353999955183330E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 612;      { Helene:  SAT080 data }
    epoch_jd: 2444786.5;                            { element epoch Julian date     }
    a: 3.774166381879790E+05;               { a = semi-major axis (km)      }
    h: -9.353516152747377E-05;               { h = e sin(periapsis longitude)}
    k: 1.583034918343283E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 1.006212707258068E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 3.230333151378729E-04;               { p = tan(i/2) sin(node)        }
    q: 1.710869900001995E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: -6.777890900303528E-07 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 1.522394989535369E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -9.680289928992843E-07 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 4.057615013244320E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 8.354534172579820E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 613;      { Telesto:  SAT080 data }
    epoch_jd: 2444786.5;                            { element epoch Julian date     }
    a: 2.946735826892260E+05;               { a = semi-major axis (km)      }
    h: -5.228888695475952E-04;               { h = e sin(periapsis longitude)}
    k: -6.853986134369704E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 2.150026475454563E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 8.124186851739944E-03;               { p = tan(i/2) sin(node)        }
    q: -5.785202572889351E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: 2.297061650453675E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 2.207149546064677E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -2.290176906415847E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 4.057999864473820E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 8.353999955183330E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 614;      { Calypso:  SAT080 data }
    epoch_jd: 2444786.5;                            { element epoch Julian date     }
    a: 2.946734418892560E+05;               { a = semi-major axis (km)      }
    h: 2.900726601141678E-05;               { h = e sin(periapsis longitude)}
    k: -1.805642558770706E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 9.486345898172432E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: -6.373255324934580E-03;               { p = tan(i/2) sin(node)        }
    q: -1.114711641632123E-02;               { q = tan(i/2) cos(node)        }
    apsis_rate: 2.297022164277979E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 2.207149553889344E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -2.289705897532556E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 4.057999864473820E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 8.353999955183330E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 615;           { Atlas: SAT080 data }
    epoch_jd: 2444786.50;                           { element epoch Julian date     }
    a: 1.376664620000000E+05;               { a = semi-major axis (km)      }
    h: 0.000000000000000E+00;               { h = e sin(periapsis longitude)}
    k: 0.000000000000000E+00;               { k = e cos(periapsis longitude)}
    mean_lon0: 1.865410967364615E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 0.000000000000000E+00;               { p = tan(i/2) sin(node)        }
    q: 0.000000000000000E+00;               { q = tan(i/2) cos(node)        }
    apsis_rate: 3.334584985561025E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 6.924845572071244E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -3.318681015315788E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 4.058861887893110E+01 * deg2rad;     { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 8.352533375484340E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 616;              { Prometheus: SAT127 data }
    epoch_jd: 2444940.;                       { element epoch Julian date     }
    a: 1.393776240E+5;                { a = semi-major axis (km)      }
    h: -1.870790E-3;                   { h = e sin(periapsis longitude)}
    k: -4.319060E-4;                   { k = e cos(periapsis longitude)}
    mean_lon0: 339.155 * deg2rad;           { l = mean longitude (deg)      }
    p: 0.0;                           { p = tan(i/2) sin(node)        }
    q: 0.0;                           { q = tan(i/2) cos(node)        }
    apsis_rate: 3.191398148E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 6.797308681E-03 * deg2rad;   { mean motion (deg/sec)         }
    node_rate: -3.191398148E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 40.5955 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 83.53812 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 617;              { Pandora: SAT127 data }
    epoch_jd: 2444940.0;                            { element epoch Julian date     }
    a: 1.417131075E+05;               { a = semi-major axis (km)      }
    h: -7.853582898E-05;               { h = e sin(periapsis longitude)}
    k: 4.499314628E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 96.023 * deg2rad;   { l = mean longitude (deg)      }
    p: 0.000000000E+00;               { p = tan(i/2) sin(node)        }
    q: 0.000000000E+00;               { q = tan(i/2) cos(node)        }
    apsis_rate: 3.008501157E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 6.629462963E-03 * deg2rad;   { mean motion (deg/sec)         }
    node_rate: -3.008501157E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 40.5955 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 83.53812 * deg2rad),     { Laplacian plane pole dec (deg)}

    (jpl_id: 618;             { Pan SAT357eq }
    epoch_jd: 2451545.000000000;                    { element epoch Julian date     }
    a: 1.335848403056548E+05;               { a = semi-major axis (km)      }
    h: 1.184137532026823E-06;               { h = e sin(periapsis longitude)}
    k: -3.795001338256199E-06;               { k = e cos(periapsis longitude)}
    mean_lon0: 1.465934643173052E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 3.485750239434890E-06;               { p = tan(i/2) sin(node)        }
    q: 1.868116711429591E-06;               { q = tan(i/2) cos(node)        }
    apsis_rate: 3.711667873563986E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 7.245737663080527E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -3.692848983924850E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 4.058266021370071E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 8.353762557532015E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 635;             { Daphnis SAT357eq }
    epoch_jd: 2451545.0;                            { element epoch Julian date     }
    a: 1.365034061742419E+05;               { a = semi-major axis (km)      }
    h: 7.953373144505403E-06;               { h = e sin(periapsis longitude)}
    k: 1.544106618779353E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: 1.535815515789244E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 1.989291987836432E-05;               { p = tan(i/2) sin(node)        }
    q: -1.400452041662295E-05;               { q = tan(i/2) cos(node)        }
    apsis_rate: 3.436678564527815E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 7.013647605763186E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -3.420001234488550E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 4.058266021370071E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 8.353762557532015E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 706;             { Cordelia URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 4.975278376008903E+04;               { a = semi-major axis (km)      }
    h: 3.397026389377096E-05;               { h = e sin(periapsis longitude)}
    k: -2.515254211787496E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 7.000215607027029E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: 3.704615503525648E-04;               { p = tan(i/2) sin(node)        }
    q: 5.853261080355042E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 1.738799696981362E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 1.243656183299048E-02 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -1.736377492435019E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 707;             { Ophelia URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 5.377236269476546E+04;               { a = semi-major axis (km)      }
    h: -2.150301507347647E-04;               { h = e sin(periapsis longitude)}
    k: -9.999740581692736E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 2.980775969867487E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -2.020628913672490E-05;               { p = tan(i/2) sin(node)        }
    q: -3.602825478615738E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 1.324712040631912E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 1.106966008118268E-02 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -1.323133607399601E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 708;             { Bianca URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 5.916601845295852E+04;               { a = semi-major axis (km)      }
    h: 8.477231065799786E-04;               { h = e sin(periapsis longitude)}
    k: -1.956287335001066E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 2.399994222705358E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 1.589300498661261E-03;               { p = tan(i/2) sin(node)        }
    q: 6.379647873951716E-05;               { q = tan(i/2) cos(node)        }
    apsis_rate: 9.467105548594393E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 9.587823207439880E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -9.457950543934906E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 709;             { Cressida URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 6.176701274125071E+04;               { a = semi-major axis (km)      }
    h: 1.280325717493410E-04;               { h = e sin(periapsis longitude)}
    k: -3.492016953899938E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 1.744231642592986E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: -8.721221306573636E-05;               { p = tan(i/2) sin(node)        }
    q: -5.691312570236423E-05;               { q = tan(i/2) cos(node)        }
    apsis_rate: 8.142357893631056E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 8.988222143978887E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -8.135007925901379E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 710;             { Desdemona URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 6.265802480732047E+04;               { a = semi-major axis (km)      }
    h: 6.122707189532604E-05;               { h = e sin(periapsis longitude)}
    k: -7.493551564088767E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: 3.140089739140928E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -8.205209935503686E-04;               { p = tan(i/2) sin(node)        }
    q: 2.858562925749050E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 7.743633229159851E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 8.796938545302438E-03 * deg2rad;     { mean motion (deg/sec)         }
    node_rate: -7.736867825787147E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 711;             { Juliet URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 6.435798256249492E+04;               { a = semi-major axis (km)      }
    h: 5.727123336968831E-04;               { h = e sin(periapsis longitude)}
    k: 2.769692434848892E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 3.086610831200759E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 1.979873455981514E-06;               { p = tan(i/2) sin(node)        }
    q: -3.519679830363237E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 7.050789555402506E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 8.450533525589351E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -7.044928085318312E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 712;             { Portia URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 6.609699016546280E+04;               { a = semi-major axis (km)      }
    h: -1.561120967532852E-05;               { h = e sin(periapsis longitude)}
    k: -1.037014963876101E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: 3.408196917514196E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -6.171045740059509E-04;               { p = tan(i/2) sin(node)        }
    q: -3.299300587868204E-05;               { q = tan(i/2) cos(node)        }
    apsis_rate: 6.422466432321616E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 8.119056168010097E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -6.417420983992342E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),     { Laplacian plane pole dec (deg)}

    (jpl_id: 713;             { Rosalind URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 6.992700696485957E+04;               { a = semi-major axis (km)      }
    h: -1.403276497951949E-06;               { h = e sin(periapsis longitude)}
    k: -2.648962937429079E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 2.895216219202660E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 1.425386769737830E-04;               { p = tan(i/2) sin(node)        }
    q: 1.380714624815777E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: 5.273919837749587E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 7.460999947254308E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -5.270264644406115E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),     { Laplacian plane pole dec (deg)}

    (jpl_id: 714;             { Belinda URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 7.525599298568144E+04;               { a = semi-major axis (km)      }
    h: -1.133077752423965E-04;               { h = e sin(periapsis longitude)}
    k: 9.095450345916166E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: 3.189638319876507E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -2.319689561589446E-04;               { p = tan(i/2) sin(node)        }
    q: 1.836879475556537E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 4.080592112111099E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 6.682410769071078E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -4.078118716334471E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 715;             { Puck URA091}
    epoch_jd: 2446450.0;                            { element epoch Julian date     }
    a: 8.600500570186481E+04;               { a = semi-major axis (km)      }
    h: 2.408105269975341E-05;               { h = e sin(periapsis longitude)}
    k: 4.402601703153761E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: 3.316332080099892E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -2.920341971029460E-03;               { p = tan(i/2) sin(node)        }
    q: -1.546045006884095E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 2.563927692592904E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 5.469265726829639E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -2.562898939602568E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 725;             { Perdita URA091}
    epoch_jd: 2453243.0;                            { element epoch Julian date     }
    a: 7.724773127464541E+04;               { a = semi-major axis (km)      }
    h: 1.390656943538988E-02;               { h = e sin(periapsis longitude)}
    k: 3.764212415028709E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 3.595150462692501E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: -3.980139862871680E-03;               { p = tan(i/2) sin(node)        }
    q: 2.570818282326076E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: 7.254635422562736E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 6.530622640638519E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -1.264570087799819E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 726;             { Mab URA091}
    epoch_jd: 2453243.0;                            { element epoch Julian date     }
    a: 9.775566743468499E+04;               { a = semi-major axis (km)      }
    h: -4.588659276539662E-03;               { h = e sin(periapsis longitude)}
    k: 1.692530123450800E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 1.541172205352909E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -6.759365158371933E-04;               { p = tan(i/2) sin(node)        }
    q: 1.062018029025279E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: 2.045092348282713E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 4.514456799305884E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -1.920887916143170E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 727;             { Cupid URA091}
    epoch_jd: 2453243.0;                            { element epoch Julian date     }
    a: 7.450315104822017E+04;               { a = semi-major axis (km)      }
    h: 1.837706282342717E-03;               { h = e sin(periapsis longitude)}
    k: 1.041837588715111E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 2.341997642137053E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: -2.742799982489807E-04;               { p = tan(i/2) sin(node)        }
    q: -1.085742482179855E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: 4.009533113969465E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 6.799110491893427E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -3.448340803322791E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 7.731359116506646E+01 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 1.517445781731228E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    { NOTE that the following elements for Triton DO NOT WORK. }
    { They lead to prograde motion.  No idea what's going on!  }
    { For the nonce;  use the code in 'triton.cpp' instead.    }
    (jpl_id: 801;  { Triton; aka Neptune I: NEP050 }
    epoch_jd: 2447763.5;                           { element epoch Julian date     }
    a: 3.547591460000000E+05;               { a = semi-major axis (km)      }
    h: 2.183485420000000E-06;               { h = e sin(periapsis longitude)}
    k: -1.543648510000000E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: -7.672436890000000E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: 2.818138250000000E-02;               { p = tan(i/2) sin(node)        }
    q: -2.030103396000000E-01;               { q = tan(i/2) cos(node)        }
    apsis_rate: 1.211953824000000E-08 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: -7.089961076000000E-04 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: 1.657793254000000E-08 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.989472940000000E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 4.331890600000000E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 803;  { Naiad; a.k.a. 1989N6: NEP050 }
    epoch_jd: 2447757.0;                           { element epoch Julian date     }
    a: 4.822701435905355E+04;               { a = semi-major axis (km)      }
    h: 3.620224770838396E-04;               { h = e sin(periapsis longitude)}
    k: 1.156185304588290E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: 6.810339767839658E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: 3.452822063733985E-02;               { p = tan(i/2) sin(node)        }
    q: 2.290770169216655E-02;               { q = tan(i/2) cos(node)        }
    apsis_rate: 1.964161049323076E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 1.415326558087714E-02 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -1.985180471594082E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.993634890000000E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 4.344909600000000E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 804;   { Thalassa; a.k.a. 1989N5: NEP050 }
    epoch_jd: 2447757.0;                            { element epoch Julian date     }
    a: 5.007495130640859E+04;               { a = semi-major axis (km)      }
    h: 1.881434320556790E-04;               { h = e sin(periapsis longitude)}
    k: 1.033517936279606E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 2.475810361721285E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 1.808988491806543E-03;               { p = tan(i/2) sin(node)        }
    q: -2.572520444193769E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 1.745544005794959E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 1.337678870805562E-02 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -1.746377282651943E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.993634890000000E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 4.344909600000000E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 805;   { Despina;  a.k.a. 1989N3: NEP050 }
    epoch_jd: 2447757.0;                            { element epoch Julian date     }
    a: 5.252607405757254E+04;               { a = semi-major axis (km)      }
    h: 2.232930551031250E-04;               { h = e sin(periapsis longitude)}
    k: -1.115774312255063E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: 9.311343295481528E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: 1.944862825322830E-04;               { p = tan(i/2) sin(node)        }
    q: -5.200679669272585E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 1.475565828888696E-05 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 1.245059755574818E-02 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -1.476785707594837E-05 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.993634890000000E+02 * deg2rad;     { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 4.344909600000000E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 806;   { Galatea; a.k.a. 1989N4: NEP050 }
    epoch_jd: 2447757.0;                            { element epoch Julian date     }
    a: 6.195297903638693E+04;               { a = semi-major axis (km)      }
    h: 1.674342888688514E-05;               { h = e sin(periapsis longitude)}
    k: -3.311081056771463E-05;               { k = e cos(periapsis longitude)}
    mean_lon0: 5.448813192644227E+01 * deg2rad;   { l = mean longitude (deg)      }
    p: 4.358773699437865E-04;               { p = tan(i/2) sin(node)        }
    q: -3.132950150251619E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 8.264989830842901E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 9.718285365249440E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -8.284262531923991E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.993634890000000E+02 * deg2rad;     { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 4.344909600000000E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 807;   { Larissa; a.k.a. 1989N2: NEP050 }
    epoch_jd: 2447757.0;                            { element epoch Julian date     }
    a: 7.354791709303492E+04;               { a = semi-major axis (km)      }
    h: 5.742600597431634E-04;               { h = e sin(periapsis longitude)}
    k: -1.269545891017604E-03;               { k = e cos(periapsis longitude)}
    mean_lon0: 1.926654222778896E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 5.395612235869184E-04;               { p = tan(i/2) sin(node)        }
    q: 1.702120710409934E-03;               { q = tan(i/2) cos(node)        }
    apsis_rate: 4.526939181068548E-06 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 7.512183377052987E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -4.555573945715664E-06 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.993634890000000E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 4.344909600000000E+01 * deg2rad),    { Laplacian plane pole dec (deg)}

    (jpl_id: 808;   { Proteus;  a.k.a. 1989N1: NEP050 }
    epoch_jd: 2447757.0;                            { element epoch Julian date     }
    a: 1.176468148802116E+05;               { a = semi-major axis (km)      }
    h: 5.138756385126203E-04;               { h = e sin(periapsis longitude)}
    k: -1.319038194876358E-04;               { k = e cos(periapsis longitude)}
    mean_lon0: 2.214459710358717E+02 * deg2rad;   { l = mean longitude (deg)      }
    p: 6.691721009767980E-05;               { p = tan(i/2) sin(node)        }
    q: -2.147144625701844E-04;               { q = tan(i/2) cos(node)        }
    apsis_rate: 8.764111065373391E-07 * deg2rad;   { apsis rate (deg/sec)          }
    mean_motion: 3.712548540365151E-03 * deg2rad;    { mean motion (deg/sec)         }
    node_rate: -9.086814828264133E-07 * deg2rad;   { node rate (deg/sec)           }
    laplacian_pole_ra: 2.993634890000000E+02 * deg2rad;    { Laplacian plane pole ra (deg) }
    laplacian_pole_dec: 4.344909600000000E+01 * deg2rad)    { Laplacian plane pole dec (deg)}
    );


implementation

function evaluate_rock( jde: double; jpl_id: integer; var output_vect: array of double): boolean;
{ Given a JDE and a JPL ID number (see list at the top of this file), }
{ evaluate_rock( ) will compute the J2000 equatorial Cartesian        }
{ position for that "rock" and will return 0.  Otherwise,  it returns }
{ -1 as an error condition.  No other errors are returned... though   }
{ hypothetically,  something indicating you're outside the valid time }
{ coverage for the orbit in question would be nice.}
const
   seconds_per_day = 86400.0;
var
   i,j : integer;
   rptr: Trock;
   dt_seconds,mean_lon,h, k, p, q, tsin, tcos, r, e, omega, true_lon : double;
   a_fraction, b_fraction, c_fraction, dot_prod : double;
   avect, bvect, cvect : array [0..2] of double;
begin
   result:=false;
   for i:=1 to N_ROCKS do begin
      if( rocks[i].jpl_id = jpl_id) then begin
         rptr := rocks[i];
         dt_seconds := (jde - rptr.epoch_jd) * seconds_per_day;
         mean_lon := rptr.mean_lon0 + dt_seconds * rptr.mean_motion;
                        { avect is at right angles to Laplacian pole, }
                        { but in plane of the J2000 equator:          }
         avect[0] := -sin( rptr.laplacian_pole_ra);
         avect[1] := cos( rptr.laplacian_pole_ra);
         avect[2] := 0.0;

                        { bvect is at right angles to Laplacian pole  }
                        { _and_ to avect:                             }
         tsin := sin( rptr.laplacian_pole_dec);
         tcos := cos( rptr.laplacian_pole_dec);
         bvect[0] := -avect[1] * tsin;
         bvect[1] := avect[0] * tsin;
         bvect[2] := tcos;

                        { cvect is the Laplacian pole vector:  }
         cvect[0] := avect[1] * tcos;
         cvect[1] := -avect[0] * tcos;
         cvect[2] := tsin;

                           { Rotate the (h, k) vector to account for }
                           { a constant apsidal motion:              }
         tsin := sin( dt_seconds * rptr.apsis_rate);
         tcos := cos( dt_seconds * rptr.apsis_rate);
         h := rptr.k * tsin + rptr.h * tcos;
         k := rptr.k * tcos - rptr.h * tsin;

                           { I'm sure there's a better way to do this...  }
                           { all I do here is to compute the eccentricity }
                           { and omega,  a.k.a. longitude of perihelion,  }
                           { and do a first-order correction to get the   }
                           { 'actual' r and true longitude values.        }
         e := sqrt( h * h + k * k);
         omega := arctan2( h, k);
         true_lon := mean_lon + 2. * e * sin( mean_lon - omega)
                          + 1.25 * e * e * sin( 2. * (mean_lon - omega));
         r := rptr.a * (1. - e * e) / (1 + e * cos( true_lon - omega));

                           { Just as we rotated (h,k),  we gotta rotate }
                           { the (p,q) vector to account for precession }
                           { in the Laplacian plane:                    }

         tsin := sin( dt_seconds * rptr.node_rate);
         tcos := cos( dt_seconds * rptr.node_rate);
         p := rptr.q * tsin + rptr.p * tcos;
         q := rptr.q * tcos - rptr.p * tsin;

                           { Now we evaluate the position in components }
                           { along avect, bvect, cvect.  I derived the  }
                           { formulae from scratch... sorry I can't     }
                           { give references:                           }
         tsin := sin( true_lon);
         tcos := cos( true_lon);
         dot_prod := 2. * (q * tsin - p * tcos) / (1. + p * p + q * q);
         a_fraction := tcos + p * dot_prod;
         b_fraction := tsin - q * dot_prod;
         c_fraction := dot_prod;

                           { Now that we've got components on each axis, }
                           { the remainder is trivial: }
         for j := 0 to 2 do begin
            output_vect[j] := r * (a_fraction * avect[j]
                                + b_fraction * bvect[j]
                                + c_fraction * cvect[j]);
         end;
         result:=true;
     end;
  end;
end;

end.
