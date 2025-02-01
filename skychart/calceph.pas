unit calceph;

interface
  {$mode objfpc}{$H+}
{
  Converted to Pascal from calceph.h
}
  {----------------------------------------------------------------- }
  {!
    \file calceph.h
    \brief public API for calceph library
          access and interpolate INPOP and JPL Ephemeris data.

    \author  M. Gastineau
             Astronomie et Systemes Dynamiques, IMCCE, CNRS, Observatoire de Paris.

     Copyright, 2008-2022, CNRS
     email of the author : Mickael.Gastineau@obspm.fr
   }
  {----------------------------------------------------------------- }
  {----------------------------------------------------------------- }
  { License  of this file :
   This file is "triple-licensed", you have to choose one  of the three licenses
   below to apply on this file.

      CeCILL-C
          The CeCILL-C license is close to the GNU LGPL.
          ( http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.html )

   or CeCILL-B
          The CeCILL-B license is close to the BSD.
          (http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt)

   or CeCILL v2.1
        The CeCILL license is compatible with the GNU GPL.
        ( http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.html )

  This library is governed by the CeCILL-C, CeCILL-B or the CeCILL license under
  French law and abiding by the rules of distribution of free software.
  You can  use, modify and/ or redistribute the software under the terms
  of the CeCILL-C,CeCILL-B or CeCILL license as circulated by CEA, CNRS and INRIA
  at the following URL "http://www.cecill.info".

  As a counterpart to the access to the source code and  rights to copy,
  modify and redistribute granted by the license, users are provided only
  with a limited warranty  and the software's author,  the holder of the
  economic rights,  and the successive licensors  have only  limited
  liability.

  In this respect, the user's attention is drawn to the risks associated
  with loading,  using,  modifying and/or developing or reproducing the
  software by the user in light of its specific status of free software,
  that may mean  that it is complicated to manipulate,  and  that  also
  therefore means  that it is reserved for developers  and  experienced
  professionals having in-depth computer knowledge. Users are therefore
  encouraged to load and test the software's suitability as regards their
  requirements in conditions enabling the security of their systems and/or
  data to be ensured and,  more generally, to use and operate it in the
  same conditions as regards security.

  The fact that you are presently reading this means that you have had
  knowledge of the CeCILL-C,CeCILL-B or CeCILL license and that you accept its
  terms.
   }

  {$IFDEF FPC}
  {$PACKRECORDS C}
  {$ENDIF}

  {---------------------------------------------------------------------------------------------- }
  { definition of the CALCEPH library version  }
  {---------------------------------------------------------------------------------------------- }
  {! version : major number of CALCEPH library  }

  const
    CALCEPH_VERSION_MAJOR = 3;    
  {! version : minor number of CALCEPH library  }
    CALCEPH_VERSION_MINOR = 5;
  {! version : patch number of CALCEPH library  }
    CALCEPH_VERSION_PATCH = 1;
    CALCEPH_VERSION_STRING = '3.5.1';

  {! define the maximum number of characters (including the trailing '\0')
   that the name of a constant could contain.  }
    CALCEPH_MAX_CONSTANTNAME = 33;    
  {! define the maximum number of characters (including the trailing '\0')
   that the value of a constant could contain.  }
    CALCEPH_MAX_CONSTANTVALUE = 1024;

  {! define the offset value for asteroid for calceph_?compute  }
    CALCEPH_ASTEROID = 2000000;    
  { unit for the output  }
  {! outputs are in Astronomical Unit  }
    CALCEPH_UNIT_AU = 1;    
  {! outputs are in kilometers  }
    CALCEPH_UNIT_KM = 2;    
  {! outputs are in day  }
    CALCEPH_UNIT_DAY = 4;    
  {! outputs are in seconds  }
    CALCEPH_UNIT_SEC = 8;    
  {! outputs are in radians  }
    CALCEPH_UNIT_RAD = 16;    
  {! use the NAIF body identification numbers for target and center integers  }
    CALCEPH_USE_NAIFID = 32;    
  { kind of output  }
  {! outputs are the euler angles  }
    CALCEPH_OUTPUT_EULERANGLES = 64;    
  {! outputs are the nutation angles  }
    CALCEPH_OUTPUT_NUTATIONANGLES = 128;

  { list of the known segment type for spice kernels and inpop/jpl original file format  }
  { segment of the original DE/INPOP file format }
    CALCEPH_SEGTYPE_ORIG_0 = 0;    {!< segment type for the original DE/INPOP file format }
  { segment of the spice kernels }
    CALCEPH_SEGTYPE_SPK_1  = 1;   {!< Modified Difference Arrays. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_2  = 2;   {!< Chebyshev polynomials for position. fixed length time intervals.The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_3  = 3;   {!< Chebyshev polynomials for position and velocity. fixed length time intervals. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_5  = 5;   {!< Discrete states (two body propagation).  The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_8  = 8;   {!< Lagrange Interpolation - Equal Time Steps. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_9  = 9;   {!< Lagrange Interpolation - Unequal Time Steps. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_12 = 12;  {!< Hermite Interpolation - Equal Time Steps. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_13 = 13;  {!< Hermite Interpolation - Unequal Time Steps. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_17 = 17;  {!< Equinoctial Elements. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_18 = 18;  {!< ESOC/DDID Hermite/Lagrange Interpolation.  The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_19 = 19;  {!< ESOC/DDID Piecewise Interpolation. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_20 = 20;  {!< Chebyshev polynomials for velocity. fixed length time intervals. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_21 = 21;  {!< Extended Modified Difference Arrays. The time argument for these ephemerides is TDB }
    CALCEPH_SEGTYPE_SPK_102 = 102; {!< Chebyshev polynomials for position. fixed length time intervals.  The time argument for these ephemerides is TCB }
    CALCEPH_SEGTYPE_SPK_103 = 103; {!< Chebyshev polynomials for position and velocity. fixed length time intervals. The time argument for these ephemerides is TCB }
    CALCEPH_SEGTYPE_SPK_120 = 120; {!< Chebyshev polynomials for velocity. fixed length time intervals.  The time argument for these ephemerides is TCB }

  {! NAIF identification numbers for the Sun and planetary barycenters (table 2
   * of reference 1)  }
    NAIFID_SOLAR_SYSTEM_BARYCENTER = 0;    
    NAIFID_MERCURY_BARYCENTER = 1;    
    NAIFID_VENUS_BARYCENTER = 2;    
    NAIFID_EARTH_MOON_BARYCENTER = 3;    
    NAIFID_MARS_BARYCENTER = 4;    
    NAIFID_JUPITER_BARYCENTER = 5;    
    NAIFID_SATURN_BARYCENTER = 6;    
    NAIFID_URANUS_BARYCENTER = 7;    
    NAIFID_NEPTUNE_BARYCENTER = 8;    
    NAIFID_PLUTO_BARYCENTER = 9;    
    NAIFID_SUN = 10;    
  {! NAIF identification numbers for the Coordinate Time ephemerides  }
  {! value to set as the center to get any Coordinate Time  }
    NAIFID_TIME_CENTER = 1000000000;    
  {! value to set as the target to get the Coordinate Time TT-TDB  }
    NAIFID_TIME_TTMTDB = 1000000001;    
  {! value to set as the target to get the Coordinate Time TCG-TCB  }
    NAIFID_TIME_TCGMTCB = 1000000002;    
  {! NAIF identification numbers for the planet centers and satellites (table 3
   * of reference 1)   }
    NAIFID_MERCURY = 199;    
    NAIFID_VENUS = 299;    
    NAIFID_EARTH = 399;    
    NAIFID_MOON = 301;    
    NAIFID_MARS = 499;    
    NAIFID_PHOBOS = 401;    
    NAIFID_DEIMOS = 402;    
    NAIFID_JUPITER = 599;    
    NAIFID_IO = 501;    
    NAIFID_EUROPA = 502;    
    NAIFID_GANYMEDE = 503;    
    NAIFID_CALLISTO = 504;    
    NAIFID_AMALTHEA = 505;    
    NAIFID_HIMALIA = 506;    
    NAIFID_ELARA = 507;    
    NAIFID_PASIPHAE = 508;    
    NAIFID_SINOPE = 509;    
    NAIFID_LYSITHEA = 510;    
    NAIFID_CARME = 511;    
    NAIFID_ANANKE = 512;    
    NAIFID_LEDA = 513;    
    NAIFID_THEBE = 514;    
    NAIFID_ADRASTEA = 515;    
    NAIFID_METIS = 516;    
    NAIFID_CALLIRRHOE = 517;    
    NAIFID_THEMISTO = 518;    
    NAIFID_MEGACLITE = 519;
    NAIFID_TAYGETE = 520;    
    NAIFID_CHALDENE = 521;    
    NAIFID_HARPALYKE = 522;    
    NAIFID_KALYKE = 523;    
    NAIFID_IOCASTE = 524;    
    NAIFID_ERINOME = 525;    
    NAIFID_ISONOE = 526;    
    NAIFID_PRAXIDIKE = 527;    
    NAIFID_AUTONOE = 528;    
    NAIFID_THYONE = 529;    
    NAIFID_HERMIPPE = 530;    
    NAIFID_AITNE = 531;    
    NAIFID_EURYDOME = 532;    
    NAIFID_EUANTHE = 533;    
    NAIFID_EUPORIE = 534;    
    NAIFID_ORTHOSIE = 535;    
    NAIFID_SPONDE = 536;    
    NAIFID_KALE = 537;    
    NAIFID_PASITHEE = 538;    
    NAIFID_HEGEMONE = 539;    
    NAIFID_MNEME = 540;    
    NAIFID_AOEDE = 541;    
    NAIFID_THELXINOE = 542;    
    NAIFID_ARCHE = 543;    
    NAIFID_KALLICHORE = 544;    
    NAIFID_HELIKE = 545;    
    NAIFID_CARPO = 546;    
    NAIFID_EUKELADE = 547;    
    NAIFID_CYLLENE = 548;    
    NAIFID_KORE = 549;    
    NAIFID_HERSE = 550;    
    NAIFID_DIA = 553;    
    NAIFID_SATURN = 699;    
    NAIFID_MIMAS = 601;    
    NAIFID_ENCELADUS = 602;    
    NAIFID_TETHYS = 603;    
    NAIFID_DIONE = 604;    
    NAIFID_RHEA = 605;    
    NAIFID_TITAN = 606;    
    NAIFID_HYPERION = 607;    
    NAIFID_IAPETUS = 608;    
    NAIFID_PHOEBE = 609;    
    NAIFID_JANUS = 610;    
    NAIFID_EPIMETHEUS = 611;    
    NAIFID_HELENE = 612;    
    NAIFID_TELESTO = 613;    
    NAIFID_CALYPSO = 614;    
    NAIFID_ATLAS = 615;    
    NAIFID_PROMETHEUS = 616;    
    NAIFID_PANDORA = 617;    
    NAIFID_PAN = 618;    
    NAIFID_YMIR = 619;    
    NAIFID_PAALIAQ = 620;    
    NAIFID_TARVOS = 621;    
    NAIFID_IJIRAQ = 622;    
    NAIFID_SUTTUNGR = 623;    
    NAIFID_KIVIUQ = 624;    
    NAIFID_MUNDILFARI = 625;    
    NAIFID_ALBIORIX = 626;    
    NAIFID_SKATHI = 627;    
    NAIFID_ERRIAPUS = 628;    
    NAIFID_SIARNAQ = 629;    
    NAIFID_THRYMR = 630;    
    NAIFID_NARVI = 631;    
    NAIFID_METHONE = 632;    
    NAIFID_PALLENE = 633;    
    NAIFID_POLYDEUCES = 634;    
    NAIFID_DAPHNIS = 635;    
    NAIFID_AEGIR = 636;    
    NAIFID_BEBHIONN = 637;    
    NAIFID_BERGELMIR = 638;    
    NAIFID_BESTLA = 639;    
    NAIFID_FARBAUTI = 640;    
    NAIFID_FENRIR = 641;    
    NAIFID_FORNJOT = 642;    
    NAIFID_HATI = 643;    
    NAIFID_HYROKKIN = 644;    
    NAIFID_KARI = 645;    
    NAIFID_LOGE = 646;    
    NAIFID_SKOLL = 647;    
    NAIFID_SURTUR = 648;    
    NAIFID_ANTHE = 649;    
    NAIFID_JARNSAXA = 650;    
    NAIFID_GREIP = 651;    
    NAIFID_TARQEQ = 652;    
    NAIFID_AEGAEON = 653;    
    NAIFID_URANUS = 799;    
    NAIFID_ARIEL = 701;    
    NAIFID_UMBRIEL = 702;    
    NAIFID_TITANIA = 703;    
    NAIFID_OBERON = 704;    
    NAIFID_MIRANDA = 705;    
    NAIFID_CORDELIA = 706;    
    NAIFID_OPHELIA = 707;    
    NAIFID_BIANCA = 708;    
    NAIFID_CRESSIDA = 709;    
    NAIFID_DESDEMONA = 710;    
    NAIFID_JULIET = 711;    
    NAIFID_PORTIA = 712;    
    NAIFID_ROSALIND = 713;    
    NAIFID_BELINDA = 714;    
    NAIFID_PUCK = 715;    
    NAIFID_CALIBAN = 716;    
    NAIFID_SYCORAX = 717;    
    NAIFID_PROSPERO = 718;    
    NAIFID_SETEBOS = 719;    
    NAIFID_STEPHANO = 720;    
    NAIFID_TRINCULO = 721;    
    NAIFID_FRANCISCO = 722;    
    NAIFID_MARGARET = 723;    
    NAIFID_FERDINAND = 724;    
    NAIFID_PERDITA = 725;    
    NAIFID_MAB = 726;    
    NAIFID_CUPID = 727;    
    NAIFID_NEPTUNE = 899;    
    NAIFID_TRITON = 801;    
    NAIFID_NEREID = 802;    
    NAIFID_NAIAD = 803;    
    NAIFID_THALASSA = 804;    
    NAIFID_DESPINA = 805;    
    NAIFID_GALATEA = 806;    
    NAIFID_LARISSA = 807;    
    NAIFID_PROTEUS = 808;    
    NAIFID_HALIMEDE = 809;    
    NAIFID_PSAMATHE = 810;    
    NAIFID_SAO = 811;    
    NAIFID_LAOMEDEIA = 812;    
    NAIFID_NESO = 813;    
    NAIFID_PLUTO = 999;    
    NAIFID_CHARON = 901;    
    NAIFID_NIX = 902;    
    NAIFID_HYDRA = 903;    
    NAIFID_KERBEROS = 904;    
    NAIFID_STYX = 905;    
  {! NAIF identification numbers for the comets (table 4 of reference 1)   }
    NAIFID_AREND = 1000001;    
    NAIFID_AREND_RIGAUX = 1000002;    
    NAIFID_ASHBROOK_JACKSON = 1000003;    
    NAIFID_BOETHIN = 1000004;    
    NAIFID_BORRELLY = 1000005;    
    NAIFID_BOWELL_SKIFF = 1000006;    
    NAIFID_BRADFIELD = 1000007;    
    NAIFID_BROOKS_2 = 1000008;    
    NAIFID_BRORSEN_METCALF = 1000009;    
    NAIFID_BUS = 1000010;    
    NAIFID_CHERNYKH = 1000011;    
    NAIFID_CHURYUMOV_GERASIMENKO = 1000012;    
    NAIFID_CIFFREO = 1000013;    
    NAIFID_CLARK = 1000014;    
    NAIFID_COMAS_SOLA = 1000015;    
    NAIFID_CROMMELIN = 1000016;    
    NAIFID_D__ARREST = 1000017;    
    NAIFID_DANIEL = 1000018;    
    NAIFID_DE_VICO_SWIFT = 1000019;    
    NAIFID_DENNING_FUJIKAWA = 1000020;    
    NAIFID_DU_TOIT_1 = 1000021;    
    NAIFID_DU_TOIT_HARTLEY = 1000022;    
    NAIFID_DUTOIT_NEUJMIN_DELPORTE = 1000023;    
    NAIFID_DUBIAGO = 1000024;    
    NAIFID_ENCKE = 1000025;    
    NAIFID_FAYE = 1000026;    
    NAIFID_FINLAY = 1000027;    
    NAIFID_FORBES = 1000028;    
    NAIFID_GEHRELS_1 = 1000029;    
    NAIFID_GEHRELS_2 = 1000030;    
    NAIFID_GEHRELS_3 = 1000031;    
    NAIFID_GIACOBINI_ZINNER = 1000032;    
    NAIFID_GICLAS = 1000033;    
    NAIFID_GRIGG_SKJELLERUP = 1000034;    
    NAIFID_GUNN = 1000035;    
    NAIFID_HALLEY = 1000036;    
    NAIFID_HANEDA_CAMPOS = 1000037;    
    NAIFID_HARRINGTON = 1000038;    
    NAIFID_HARRINGTON_ABELL = 1000039;    
    NAIFID_HARTLEY_1 = 1000040;    
    NAIFID_HARTLEY_2 = 1000041;    
    NAIFID_HARTLEY_IRAS = 1000042;    
    NAIFID_HERSCHEL_RIGOLLET = 1000043;    
    NAIFID_HOLMES = 1000044;    
    NAIFID_HONDA_MRKOS_PAJDUSAKOVA = 1000045;    
    NAIFID_HOWELL = 1000046;    
    NAIFID_IRAS = 1000047;    
    NAIFID_JACKSON_NEUJMIN = 1000048;    
    NAIFID_JOHNSON = 1000049;    
    NAIFID_KEARNS_KWEE = 1000050;    
    NAIFID_KLEMOLA = 1000051;    
    NAIFID_KOHOUTEK = 1000052;    
    NAIFID_KOJIMA = 1000053;    
    NAIFID_KOPFF = 1000054;    
    NAIFID_KOWAL_1 = 1000055;    
    NAIFID_KOWAL_2 = 1000056;    
    NAIFID_KOWAL_MRKOS = 1000057;    
    NAIFID_KOWAL_VAVROVA = 1000058;    
    NAIFID_LONGMORE = 1000059;    
    NAIFID_LOVAS_1 = 1000060;    
    NAIFID_MACHHOLZ = 1000061;    
    NAIFID_MAURY = 1000062;    
    NAIFID_NEUJMIN_1 = 1000063;    
    NAIFID_NEUJMIN_2 = 1000064;    
    NAIFID_NEUJMIN_3 = 1000065;    
    NAIFID_OLBERS = 1000066;    
    NAIFID_PETERS_HARTLEY = 1000067;    
    NAIFID_PONS_BROOKS = 1000068;    
    NAIFID_PONS_WINNECKE = 1000069;    
    NAIFID_REINMUTH_1 = 1000070;    
    NAIFID_REINMUTH_2 = 1000071;    
    NAIFID_RUSSELL_1 = 1000072;    
    NAIFID_RUSSELL_2 = 1000073;    
    NAIFID_RUSSELL_3 = 1000074;    
    NAIFID_RUSSELL_4 = 1000075;    
    NAIFID_SANGUIN = 1000076;    
    NAIFID_SCHAUMASSE = 1000077;    
    NAIFID_SCHUSTER = 1000078;    
    NAIFID_SCHWASSMANN_WACHMANN_1 = 1000079;    
    NAIFID_SCHWASSMANN_WACHMANN_2 = 1000080;    
    NAIFID_SCHWASSMANN_WACHMANN_3 = 1000081;    
    NAIFID_SHAJN_SCHALDACH = 1000082;    
    NAIFID_SHOEMAKER_1 = 1000083;    
    NAIFID_SHOEMAKER_2 = 1000084;    
    NAIFID_SHOEMAKER_3 = 1000085;    
    NAIFID_SINGER_BREWSTER = 1000086;    
    NAIFID_SLAUGHTER_BURNHAM = 1000087;    
    NAIFID_SMIRNOVA_CHERNYKH = 1000088;    
    NAIFID_STEPHAN_OTERMA = 1000089;    
    NAIFID_SWIFT_GEHRELS = 1000090;    
    NAIFID_TAKAMIZAWA = 1000091;    
    NAIFID_TAYLOR = 1000092;    
    NAIFID_TEMPEL_1 = 1000093;    
    NAIFID_TEMPEL_2 = 1000094;    
    NAIFID_TEMPEL_TUTTLE = 1000095;    
    NAIFID_TRITTON = 1000096;    
    NAIFID_TSUCHINSHAN_1 = 1000097;    
    NAIFID_TSUCHINSHAN_2 = 1000098;    
    NAIFID_TUTTLE = 1000099;    
    NAIFID_TUTTLE_GIACOBINI_KRESAK = 1000100;    
    NAIFID_VAISALA_1 = 1000101;    
    NAIFID_VAN_BIESBROECK = 1000102;    
    NAIFID_VAN_HOUTEN = 1000103;    
    NAIFID_WEST_KOHOUTEK_IKEMURA = 1000104;    
    NAIFID_WHIPPLE = 1000105;    
    NAIFID_WILD_1 = 1000106;    
    NAIFID_WILD_2 = 1000107;    
    NAIFID_WILD_3 = 1000108;    
    NAIFID_WIRTANEN = 1000109;    
    NAIFID_WOLF = 1000110;    
    NAIFID_WOLF_HARRINGTON = 1000111;    
    NAIFID_LOVAS_2 = 1000112;    
    NAIFID_URATA_NIIJIMA = 1000113;    
    NAIFID_WISEMAN_SKIFF = 1000114;    
    NAIFID_HELIN = 1000115;    
    NAIFID_MUELLER = 1000116;    
    NAIFID_SHOEMAKER_HOLT_1 = 1000117;    
    NAIFID_HELIN_ROMAN_CROCKETT = 1000118;    
    NAIFID_HARTLEY_3 = 1000119;    
    NAIFID_PARKER_HARTLEY = 1000120;    
    NAIFID_HELIN_ROMAN_ALU_1 = 1000121;    
    NAIFID_WILD_4 = 1000122;    
    NAIFID_MUELLER_2 = 1000123;    
    NAIFID_MUELLER_3 = 1000124;    
    NAIFID_SHOEMAKER_LEVY_1 = 1000125;    
    NAIFID_SHOEMAKER_LEVY_2 = 1000126;    
    NAIFID_HOLT_OLMSTEAD = 1000127;    
    NAIFID_METCALF_BREWINGTON = 1000128;    
    NAIFID_LEVY = 1000129;    
    NAIFID_SHOEMAKER_LEVY_9 = 1000130;    
    NAIFID_HYAKUTAKE = 1000131;    
    NAIFID_HALE_BOPP = 1000132;    
    NAIFID_SIDING_SPRING = 1003228;

type
  Tcalcstr = array[0..CALCEPH_MAX_CONSTANTVALUE] of char;
  Terrproc = procedure (_para1:Pchar);
  TDoubleArray = array[0..11] of double;
  TTargetArray = array of integer;
  TBodyNameArray = array of string;

  {----------------------------------------------------------------- }
  { error handler  }
  {----------------------------------------------------------------- }
  {! set the error handler  }
  Tcalceph_seterrorhandler = procedure (typehandler:longint; userfunc:Terrproc);cdecl;

  {----------------------------------------------------------------- }
  { single access API per thread/process  }
  {----------------------------------------------------------------- }

  {! open an ephemeris data file  }
  Tcalceph_sopen = function (filename:Pchar):longint;cdecl;

  {! return the version of the ephemeris data file as a null-terminated string  }
  Tcalceph_sgetfileversion = function (var szversion: Tcalcstr):longint;cdecl;

  {! compute the position <x,y,z> and velocity <xdot,ydot,zdot>
     for a given target and center  }
  Tcalceph_scompute = function (JD0:double; time:double; target:longint; center:longint; var PV:TDoubleArray):longint;cdecl;

  {! get the first value from the specified name constant in the ephemeris file
      }
  Tcalceph_sgetconstant = function (name:Pchar; var value:double):longint;cdecl;

  {! return the number of constants available in the ephemeris file  }
  Tcalceph_sgetconstantcount = function :longint;cdecl;

  {! return the name and the associated value of the constant available at some
     * index in the ephemeris file  }
  Tcalceph_sgetconstantindex = function (index:longint; name: Pchar; var value:double):longint;cdecl;

  {! return the time scale in the ephemeris file  }
  Tcalceph_sgettimescale = function :longint;cdecl;

  {! return the first and last time available in the ephemeris file  }
  Tcalceph_sgettimespan = function (var firsttime:double; var lasttime:double; var continuous:longint):longint;cdecl;

  {! close an ephemeris data file  }
  Tcalceph_sclose = procedure ;cdecl;

  {----------------------------------------------------------------- }
  { multiple access API per thread/process  }
  {----------------------------------------------------------------- }
  type
    {! ephemeris descriptor  }
    t_calcephbin = record end;
    Pt_calcephbin = ^t_calcephbin;

    {! fixed length string value of a constant  }
    t_calcephcharvalue = array[0..(CALCEPH_MAX_CONSTANTVALUE)-1] of char;
    Pt_calcephcharvalue = ^t_calcephcharvalue;

  {! open an ephemeris data file  }
  Tcalceph_open = function (filename:Pchar):Pt_calcephbin;cdecl;

  {! open a list of ephemeris data file  }
  {n  }(* Const before declarator ignored *)
  Tcalceph_open_array = function (n:longint; filename:PPchar):Pt_calcephbin;cdecl;

  {! return the version of the ephemeris data file as a null-terminated string  }
  Tcalceph_getfileversion = function (eph: Pt_calcephbin; var szversion:Tcalcstr):longint;cdecl;

  {! prefetch all data to memory  }
  Tcalceph_prefetch = function (eph: Pt_calcephbin):longint;cdecl;

  {! return non-zero value if eph could be accessed by multiple threads  }
  Tcalceph_isthreadsafe = function (eph: Pt_calcephbin):longint;cdecl;

  {! compute the position <x,y,z> and velocity <xdot,ydot,zdot>
     for a given target and center at a single time. The output is in UA, UA/day,
     radians  }
  Tcalceph_compute = function (eph: Pt_calcephbin; JD0:double; time:double; target:longint; center:longint;
             var PV:TDoubleArray):longint;cdecl;

  {! compute the position <x,y,z> and velocity <xdot,ydot,zdot>
     for a given target and center at a single time. The output is expressed
     according to unit  }
  Tcalceph_compute_unit = function (eph: Pt_calcephbin; JD0:double; time:double; target:longint; center:longint;
             eunit:longint; var PV:TDoubleArray):longint;cdecl;

  {! compute the orientation <euler angles> and their derivatives for a given
     target  at a single time. The output is expressed according to unit  }
  Tcalceph_orient_unit = function (var eph:t_calcephbin; JD0:double; time:double; target:longint; eunit:longint;
             var PV:TDoubleArray):longint;cdecl;

  {! compute the rotational angular momentum G/(mR^2) and their derivatives for a
     given target  at a single time. The output is expressed according to unit  }
  Tcalceph_rotangmom_unit = function (eph: Pt_calcephbin; JD0:double; time:double; target:longint; eunit:longint;
             var PV:TDoubleArray):longint;cdecl;

  {! According to the value of order, compute the position <x,y,z>
     and their first, second and third derivatives (velocity, acceleration, jerk)
     for a given target and center at a single time. The output is expressed
     according to unit  }
  Tcalceph_compute_order = function (eph:Pt_calcephbin; JD0:double; time:double; target:longint; center:longint;
             eunit:longint; order:longint; var PVAJ:TDoubleArray):longint;cdecl;

  {! According to the value of order,  compute the orientation <euler angles> and
     their first, second and third derivatives for a given target  at a single time.
     The output is expressed according to unit  }
  Tcalceph_orient_order = function (eph: Pt_calcephbin; JD0:double; time:double; target:longint; eunit:longint;
             order:longint; var PVAJ:double):longint;cdecl;

  {! compute the rotational angular momentum G/(mR^2) and their first, second and
     third derivatives for
     a given target at a single time. The output is expressed according to unit  }
  Tcalceph_rotangmom_order = function (var eph:t_calcephbin; JD0:double; time:double; target:longint; eunit:longint;
             order:longint; var PVAJ:double):longint;cdecl;

  {! get the first value from the specified name constant in the ephemeris file
      }
  Tcalceph_getconstant = function (eph: Pt_calcephbin; name:Pchar; var value:double):longint;cdecl;

  {! get the first value from the specified name constant in the ephemeris file
      }
  Tcalceph_getconstantsd = function (eph: Pt_calcephbin; name:Pchar; var value:double):longint;cdecl;

  {! get the nvalue values from the specified name constant in the ephemeris file
      }
  Tcalceph_getconstantvd = function (eph: Pt_calcephbin; name:Pchar; var arrayvalue:double; nvalue:longint):longint;cdecl;

  {! get the first value from the specified name constant in the ephemeris file
      }
  Tcalceph_getconstantss = function (eph: Pt_calcephbin; name:Pchar; var value:t_calcephcharvalue):longint;cdecl;

  {! get the nvalue values from the specified name constant in the ephemeris file
      }
  Tcalceph_getconstantvs = function (eph: Pt_calcephbin; name:Pchar; var arrayvalue:Pt_calcephcharvalue; nvalue:longint):longint;cdecl;

  {! return the number of constants available in the ephemeris file  }
  Tcalceph_getconstantcount = function (eph: Pt_calcephbin):longint;cdecl;

  {! return the name and the associated first value of the constant available at
     * some index in the ephemeris file  }
  Tcalceph_getconstantindex = function (eph: Pt_calcephbin; index:longint; var name:Tcalcstr; var value:double):longint;cdecl;

  {! return the time scale in the ephemeris file  }
  Tcalceph_gettimescale = function (eph: Pt_calcephbin):longint;cdecl;

  {! return the first and last time available in the ephemeris file  }
  Tcalceph_gettimespan = function (var eph:t_calcephbin; var firsttime:double; var lasttime:double; var continuous:longint):longint;cdecl;

  {! return the number of position’s records available in the ephemeris file  }
  Tcalceph_getpositionrecordcount = function (eph: Pt_calcephbin):longint;cdecl;

  {! return the target and origin bodies, the first and last time, and the
     reference frame available at the specified position’s records' index of the
     ephemeris file  }
  Tcalceph_getpositionrecordindex = function (eph: Pt_calcephbin; index:longint; var target:longint; var center:longint; var firsttime:double;
             var lasttime:double; var frame:longint):longint;cdecl;

  {! return the target and origin bodies, the first and last time, the reference frame
   and the segment type available at the specified position’s records' index of the
   ephemeris file }
  Tcalceph_getpositionrecordindex2 = function (eph: Pt_calcephbin; index:longint; var target:longint; var center:longint; var firsttime:double;
              var lasttime:double; var frame:longint; var segtype:longint):longint;cdecl;

  {! return the number of orientation’s records available in the ephemeris file
      }
  Tcalceph_getorientrecordcount = function (eph: Pt_calcephbin):longint;cdecl;

  {! return the target body, the first and last time, and the reference frame
     available at the specified orientation’s records' index of the ephemeris file
      }
  Tcalceph_getorientrecordindex = function (eph: Pt_calcephbin; index:longint; var target:longint; var firsttime:double; var lasttime:double;
             var frame:longint):longint;cdecl;

  {! return the target body, the first and last time, the reference frame and the segment type
   available at the specified orientation’s records' index of the ephemeris file
   }
   Tcalceph_getorientrecordindex2 = function (eph: Pt_calcephbin; index:longint; var target:longint; var firsttime:double; var lasttime:double;
              var frame:longint; var segtype:longint):longint;cdecl;

  {! close an ephemeris data file and destroy the ephemeris descriptor  }
  Tcalceph_close = procedure (eph: Pt_calcephbin);cdecl;

  {! return the maximal order of the derivatives for a segment type }
  Tcalceph_getmaxsupportedorder = function (idseg: longint): longint;

  {! return the version of the library as a null-terminated string  }
  Tcalceph_getversion_str = procedure (var szversion:Tcalcstr);cdecl;

  {---------------------------------------------------------------------------------------------- }

implementation

end.
