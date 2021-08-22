unit u_constant;

{
Copyright (C) 2002 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 Type and constant declaration
}
{$mode objfpc}{$H+}
interface

uses gcatunit,
  cu_tz, dynlibs, BGRABitmap, calceph,
  Classes, SysUtils, Controls, FPCanvas, Graphics;

const
  MaxColor = 35;
  crlf = chr(13) + chr(10);

type
  Starcolarray = array [0..Maxcolor] of Tcolor;
  // 0:sky, 1-10:object, 11:not sky, 12:AzGrid, 13:EqGrid, 14:orbit, 15:misc, 16:constl, 17:constb, 18:eyepiece, 19:horizon, 20:asteroid  23-35: dso
  TSkycolor = array[0..7] of Tcolor;
  Titt = (ittlinear, ittramp, ittlog, ittsqrt);

  TExecuteCmd = function(cname: string; arg: TStringList): string of object;
  TSendInfo = procedure(Sender: TObject; origin, str: string) of object;

  TServerCoordSys = (csJ2000, csChart);

{$i revision.inc}

{$i cdc_version.inc}

const
  cdccpy = 'Copyright (C) %s Patrick Chevalley';
  cdcauthors = 'Patrick Chevalley, pch@ap-i.net' + crlf + 'Peter Dean,' +
    crlf + 'John Sunderland' + crlf + 'Anat Ruangrassamee' + crlf + 'Sasa Zeman'+ crlf + 'Mattia Verga';
  MaxPlSim = 500;
  MaxAstSim = 100;
  MaxComet = 500;
  MaxAsteroid = 10000;
  NEO_dist = 0.1; // distance to always take account of NEO
  MaxPla = 69;
  MaxQuickSearch = 15;
  MaxWindow = 10;  // maximum number of chart window
  maxlabels = 3500; //maximum number of label to a chart
  maxmodlabels = 1000;
  //maximum number of modified labels before older one are replaced
  MaxUserObjects = 100;
  MaxCircle = 500;
  MaxDSSurl = 50;
  jd2000 = 2451545.0;
  jd1950 = 2433282.4235;
  jd1900 = 2415020.3135;
  minjd = -71328942; //-200000 years  // limit for precession calculation
  maxjd = 74769560;  //+200000 years
  // -15000 +18000    // limit for DeltaT calculation, include JPL DE431
  minjddt = -3757326.5;
  maxjddt = 8295424.5;
  minyeardt = -15000;
  maxyeardt = 18000;
  // 1800   //limit for abberation calculation using Meeus function
  minjdabe = 2378496.5;
  maxjdabe = 2524593.5; // 2200
  minjdnut = 2378496.5; // 1800   //limit for nutation calculation using Meeus function
  maxjdnut = 2524593.5; // 2200
  // julian - gregorian calendar switch
  DefaultGregorianStart = 15821015;
  DefaultGregorianStartJD = 2299161;
  MonthStart: array [1..13] of integer =
    (1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366);
  MonthName: array [1..12] of
    string = ('January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December');
  km_au = 149597870.691;
  clight = 299792.458;
  grsun = 1.974126e-8;  // twice the gravitational radius of the Sun
  tlight = km_au / clight / 3600 / 24;
  RefractionWavelength = 0.55;
  footpermeter = 0.3048;
  kmperdegree = 111.1111;
  secday = 3600 * 24;
  eps2000 = 23.43928111111111111111; // 23d 26m 21.412s
  sineps2k = 0.39777699580107953216;
  coseps2k = 0.917482131494378454;
  deg2rad = pi / 180;
  rad2deg = 180 / pi;
  siderealrate = 15.041067178669; // arcsec/second
  au2parsec = deg2rad / 3600;
  parsec2ly = 3.2615638;
  pi2 = 2 * pi;
  pi4 = 4 * pi;
  pid2 = pi / 2;
  pid4 = pi / 4;
  minarc = deg2rad / 60;
  secarc = deg2rad / 3600;
  musec = deg2rad / 3600 / 1000000; // 1 microarcsec for rounding test
  abek = secarc * 20.49552;  // aberration constant
  vfr = (365.25 * 86400.0 / km_au) * secarc;
  // Km/s to AU/year * arcsec to radiant. Used for proper motion.
  FovMin = 1 * secarc;  // 1 seconds
  FovMax = pi2;
  DefaultPrtRes = 300;
  encryptpwd = 'zh6Tiq4h;90uA3.ert';
  maxscriptsock = 10;
  MaxMenulevel = 10;
  //                          0         1                                       5                                                 10                                                15                                                20                            23        24        25        26        27        28        29        30        31        32        33        34        35
  //                          sky       -0.3      -0.1      0.2       0.5       0.8       1.3       1.3+      galaxy    cluster   neb       -white-   az grid   eq grid   orbit     const     boundary  eyepiece  misc      horizon   asteroid  comet     milkyway  ColorAst  ColorOCl  ColorGCl  ColorPNe  ColorDN   ColorEN   ColorRN   ColorSN   ColorGxy  ColorGxyCl ColorQ   ColorGL   ColorNE
  DfColor: Starcolarray =
    (clBlack, $00FF0000, $00FF8000, $00ffffff, $0080FFFF, $0000FFFF,
    $000080FF, $000000FF, $000000ff, $00ffff00, $0000ff00, clWhite,
    $00404040, $00404040, $00008080, clGray, $00008050, $00005080, clRed,
    $00202030, clYellow, $00FFC000, $00202020, $0000B0FF, $0000B0FF,
    $00FFFF80, $0080FF00, $00404040, $000000FF, $00FF8000, $00000000, $000000FF,
    $000000FF, $008080FF, $00FF0080, $00FFFFFF);
  DfPastelColor: Starcolarray =
    (clBlack, $00EF9883, $00EBDF74, $00ffffff, $00CAF9F9, $008AF2EB,
    $008EBBF2, $006271FB, $000000ff, $00ffff00, $0000ff00, clWhite,
    $00404040, $00404040, $00008080, clGray, $00008050, $00005080, clRed,
    $00202030, clYellow, $00FFC000, $00202020, $0080FFFF, $0080FFFF,
    $00FFFF80, $0080FF00, $00404040, $000000FF, $00FF8000, $00000000, $000000FF,
    $000000FF, $008080FF, $00FF0080, $00FFFFFF);
  DfGray: Starcolarray =
    (clBlack, clSilver, clSilver, clSilver, clSilver, clSilver,
    clSilver, clSilver, clSilver, clSilver, clSilver, clWhite, clSilver,
    clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver,
    clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver,
    clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver,
    clSilver, clSilver);
  DfBWColor: Starcolarray =
    (clBlack, clWhite, clWhite, clWhite, clWhite, clWhite, clWhite,
    clWhite, clWhite, clWhite, clWhite, clWhite, clWhite, clWhite,
    clWhite, clWhite, clWhite, clWhite, clWhite, clGray, clWhite,
    clWhite, clBlack, clWhite, clWhite, clWhite, clWhite, clWhite,
    clWhite, clWhite, clWhite, clWhite, clWhite, clWhite, clWhite, clWhite);
  DfRedColor: Starcolarray =
    (clBlack, $00ff00ff, $00a060ff, $008080ff, $0060a0ff, $004080ff, $006060ff,
    $000000ff, $000000ff, $00ff00ff, $008080ff, $000000ff, $00000040, $00000040,
    $00000080, $00000040, $00000040, $000000A0, $00000080, $00000040, clYellow,
    $000000A0, $00000020, $000000A0, $000000A0, $000000A0, $000000A0, $000000A0,
    $000000A0, $000000A0, $000000A0, $000000A0, $000000A0, $000000A0,
    $000000A0, $000000A0);
  DfOrangeColor: Starcolarray =
    (clBlack, $00A0C0FF, $0080C0FF, $0000C0FF, $0000B0FF, $0000A0FF, $000080FF,
    $000060FF, $000000FF, $0000FF00, $00FFFFFF, $000000FF, $00404080, $00404080,
    $000060B0, $00004080, $00002080, $00005080, $000040FF, $00001326, $000080FF,
    $000080FF, $00001728, $00002040, $0000B0FF, $000080FF, $0000A0FF, $00404040,
    $004060FF, $0000B0FF, $000040FF, $000040FF, $000040FF, $008080FF, $00FF0080,$00FFFFFF);
  DfWBColor: Starcolarray =
    (clWhite, clBlack, clBlack, clBlack, clBlack, clBlack, clBlack,
    clBlack, clBlack, clBlack, clBlack, clBlack, clBlack, clBlack,
    clBlack, clBlack, clBlack, clBlack, clBlack, clWhite, clBlack,
    clBlack, clWhite, clBlack, clBlack, clBlack, clBlack, clBlack,
    clBlack, clBlack, clBlack, clBlack, clBlack, clBlack, clBlack, clBlack);
  dfskycolor: Tskycolor =
    ($00200000, $00f03c3c, $00c83232, $00a02828, $00780000, $00640010,
    $003c0010, $00000000);

  //  End of deep-sky objects colour

  // Paper size
  PaperNumber = 9;
  PaperName: array[1..PaperNumber] of
    string = ('A5', 'A4', 'A3', 'A2', 'A1', 'A0', 'Letter', 'Legal', 'Tabloid');
  PaperWidth: array[1..PaperNumber] of
    single = (5.83, 8.27, 11.69, 16.54, 23.39, 33.11, 8.5, 8.5, 11.0);
  PaperHeight: array[1..PaperNumber] of
    single = (8.27, 11.69, 16.54, 23.39, 33.11, 46.81, 11.0, 14.0, 17.0);

  maxconst = 88;
  constel: array[1..maxconst, 1..3] of string = (
    ('AND', 'ANDROMEDA', 'ANDROMEDAE'),
    ('ANT', 'ANTLIA', 'ANTLIAE'),
    ('APS', 'APUS', 'APODIS'),
    ('AQR', 'AQUARIUS', 'AQUARII'),
    ('AQL', 'AQUILA', 'AQUILAE'),
    ('ARA', 'ARA', 'ARAE'),
    ('ARI', 'ARIES', 'ARIETIS'),
    ('AUR', 'AURIGA', 'AURIGAE'),
    ('BOO', 'BOOTES', 'BOOTIS'),
    ('CAE', 'CAELUM', 'CAELI'),
    ('CAM', 'CAMELOPARDALIS', 'CAMELOPARDALIS'),
    ('CNC', 'CANCER', 'CANCRI'),
    ('CVN', 'CANES VENATICI', 'CANUM VENATICORUM'),
    ('CMA', 'CANIS MAJOR', 'CANIS MAJORIS'),
    ('CMI', 'CANIS MINOR', 'CANIS MINORIS'),
    ('CAP', 'CAPRICORNUS', 'CAPRICORNI'),
    ('CAR', 'CARINA', 'CARINAE'),
    ('CAS', 'CASSIOPEIA', 'CASSIOPEIAE'),
    ('CEN', 'CENTAURUS', 'CENTAURI'),
    ('CEP', 'CEPHEUS', 'CEPHEI'),
    ('CET', 'CETUS', 'CETI'),
    ('CHA', 'CHAMAELEON', 'CHAMAELEONTIS'),
    ('CIR', 'CIRCINUS', 'CIRCINI'),
    ('COL', 'COLUMBA', 'COLUMBAE'),
    ('COM', 'COMA BERENICES', 'COMAE BERENICES'),
    ('CRA', 'CORONA AUSTRALIS', 'CORONAE AUSTRALIS'),
    ('CRB', 'CORONA BOREALIS', 'CORONAE BOREALIS'),
    ('CRV', 'CORVUS', 'CORVI'),
    ('CRT', 'CRATER', 'CRATERIS'),
    ('CRU', 'CRUX', 'CRUCIS'),
    ('CYG', 'CYGNUS', 'CYGNI'),
    ('DEL', 'DELPHINUS', 'DELPHINI'),
    ('DOR', 'DORADO', 'DORADUS'),
    ('DRA', 'DRACO', 'DRACONIS'),
    ('EQU', 'EQUULEUS', 'EQUULEI'),
    ('ERI', 'ERIDANUS', 'ERIDANI'),
    ('FOR', 'FORNAX', 'FORNACIS'),
    ('GEM', 'GEMINI', 'GEMINORUM'),
    ('GRU', 'GRUS', 'GRUIS'),
    ('HER', 'HERCULES', 'HERCULIS'),
    ('HOR', 'HOROLOGIUM', 'HOROLOGII'),
    ('HYA', 'HYDRA', 'HYDRAE'),
    ('HYI', 'HYDRUS', 'HYDRI'),
    ('IND', 'INDUS', 'INDI'),
    ('LAC', 'LACERTA', 'LACERTAE'),
    ('LEO', 'LEO', 'LEONIS'),
    ('LMI', 'LEO MINOR', 'LEONIS MINORIS'),
    ('LEP', 'LEPUS', 'LEPORIS'),
    ('LIB', 'LIBRA', 'LIBRAE'),
    ('LUP', 'LUPUS', 'LUPI'),
    ('LYN', 'LYNX', 'LYNCIS'),
    ('LYR', 'LYRA', 'LYRAE'),
    ('MEN', 'MENSA', 'MENSAE'),
    ('MIC', 'MICROSCOPIUM', 'MICROSCOPII'),
    ('MON', 'MONOCEROS', 'MONOCEROTIS'),
    ('MUS', 'MUSCA', 'MUSCAE'),
    ('NOR', 'NORMA', 'NORMAE'),
    ('OCT', 'OCTANS', 'OCTANTIS'),
    ('OPH', 'OPHIUCHUS', 'OPHIUCHI'),
    ('ORI', 'ORION', 'ORIONIS'),
    ('PAV', 'PAVO', 'PAVONI'),
    ('PEG', 'PEGASUS', 'PEGASI'),
    ('PER', 'PERSEUS', 'PERSEI'),
    ('PHE', 'PHOENIX', 'PHOENICIS'),
    ('PIC', 'PICTOR', 'PICTORIS'),
    ('PSC', 'PISCES', 'PISCIUM'),
    ('PSA', 'PISCIS AUSTRINUS', 'PISCIS AUSTRINI'),
    ('PUP', 'PUPPIS', 'PUPPIS'),
    ('PYX', 'PYXIS', 'PYXIDIS'),
    ('RET', 'RETICULUM', 'RETICULI'),
    ('SGE', 'SAGITTA', 'SAGITTAE'),
    ('SGR', 'SAGITTARIUS', 'SAGITTARII'),
    ('SCO', 'SCORPIUS', 'SCORPII'),
    ('SCL', 'SCULPTOR', 'SCULPTORIS'),
    ('SCT', 'SCUTUM', 'SCUTI'),
    ('SER', 'SERPENS', 'SERPENTIS'),
    ('SEX', 'SEXTANS', 'SEXTANTIS'),
    ('TAU', 'TAURUS', 'TAURI'),
    ('TEL', 'TELESCOPIUM', 'TELESCOPII'),
    ('TRI', 'TRIANGULUM', 'TRIANGULI'),
    ('TRA', 'TRIANGULUM AUSTRALE', 'TRIANGULI AUSTRALIS'),
    ('TUC', 'TUCANA', 'TUCANAE'),
    ('UMA', 'URSA MAJOR', 'URSAE MAJORIS'),
    ('UMI', 'URSA MINOR', 'URSAE MINORIS'),
    ('VEL', 'VELA', 'VELORUM'),
    ('VIR', 'VIRGO', 'VIRGINIS'),
    ('VOL', 'VOLANS', 'VOLANTIS'),
    ('VUL', 'VULPECULA', 'VULPECULAE')
    );

  maxgreek = 25;
  greek: array[1..2, 1..maxgreek] of
    string = (('Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta',
    'Theta', 'Iota', 'Kappa', 'Lambda', 'Mu', 'Nu', 'Xi', 'Omicron', 'Pi', 'Rho',
    'Sigma', 'Tau', 'Upsilon', 'Phi', 'Chi', 'Psi', 'Omega', 'Xi'),
    ('alp', 'bet', 'gam', 'del', 'eps', 'zet', 'eta', 'the', 'iot',
    'kap', 'lam', 'mu', 'nu', 'xi', 'omi', 'pi', 'rho', 'sig', 'tau',
    'ups', 'phi', 'chi', 'psi', 'ome', 'ksi'));
  greeksymbol: array[1..2, 1..maxgreek] of
    string = (('alp', 'bet', 'gam', 'del', 'eps', 'zet', 'eta', 'the', 'iot', 'kap',
    'lam', 'mu', 'nu', 'xi', 'omi', 'pi', 'rho', 'sig', 'tau', 'ups',
    'phi', 'chi', 'psi', 'ome', 'ksi'),
    ('a', 'b', 'g', 'd', 'e', 'z', 'h', 'q', 'i', 'k', 'l', 'm',
    'n', 'x', 'o', 'p', 'r', 's', 't', 'u', 'f', 'c', 'y', 'w', 'x'));
  greekUTF8: array[1..maxgreek] of
    word = ($CEB1, $CEB2, $CEB3, $CEB4, $CEB5, $CEB6, $CEB7, $CEB8, $CEB9, $CEBA,
    $CEBB, $CEBC, $CEBD, $CEBE, $CEBF, $CF80, $CF81, $CF83, $CF84,
    $CF85, $CF86, $CF87, $CF88, $CF89, $CEBE);
  pla: array[1..MaxPla] of string =
    ('Mercury ', 'Venus   ', '*       ', 'Mars    ', 'Jupiter ',
    'Saturn  ', 'Uranus  ', 'Neptune ', 'Pluto   ', 'Sun     ', 'Moon    ',
    'Io      ', 'Europa  ', 'Ganymede', 'Callisto', 'Mimas   ', 'Enceladus',
    'Tethys  ', 'Dione   ',
    'Rhea    ', 'Titan   ', 'Hyperion', 'Iapetus ', 'Miranda ', 'Ariel   ',
    'Umbriel ', 'Titania ',
    'Oberon  ', 'Phobos  ', 'Deimos  ', 'Sat.Ring', 'E.Shadow',
    'Phoebe  ', 'Triton  ', 'Nereid  ', 'Charon  ',
    'Amalthea', 'Thebe   ', 'Adrastea', 'Metis   ',
    'Janus   ', 'Epimetheus', 'Helene', 'Telesto', 'Calypso', 'Atlas',
    'Prometheus', 'Pandora', 'Pan', 'Daphnis',
    'Cordelia', 'Ophelia', 'Bianca', 'Cressida', 'Desdemona', 'Juliet',
    'Portia', 'Rosalind', 'Belinda', 'Puck', 'Perdita', 'Mab', 'Cupid',
    'Naiad', 'Thalassa', 'Despina', 'Galatea', 'Larissa', 'Proteus');


  // the same but always with English name
  epla: array[1..MaxPla] of string =
    ('Mercury ', 'Venus   ', '*       ', 'Mars    ', 'Jupiter ',
    'Saturn  ', 'Uranus  ', 'Neptune ', 'Pluto   ', 'Sun     ', 'Moon    ',
    'Io      ', 'Europa  ', 'Ganymede', 'Callisto', 'Mimas   ', 'Enceladus',
    'Tethys  ', 'Dione   ',
    'Rhea    ', 'Titan   ', 'Hyperion', 'Iapetus ', 'Miranda ', 'Ariel   ',
    'Umbriel ', 'Titania ',
    'Oberon  ', 'Phobos  ', 'Deimos  ', 'Sat.Ring', 'E.Shadow',
    'Phoebe  ', 'Triton  ', 'Nereid  ', 'Charon  ',
    'Amalthea', 'Thebe   ', 'Adrastea', 'Metis   ',
    'Janus   ', 'Epimetheus', 'Helene', 'Telesto', 'Calypso', 'Atlas',
    'Prometheus', 'Pandora', 'Pan', 'Daphnis',
    'Cordelia', 'Ophelia', 'Bianca', 'Cressida', 'Desdemona', 'Juliet',
    'Portia', 'Rosalind', 'Belinda', 'Puck', 'Perdita', 'Mab', 'Cupid',
    'Naiad', 'Thalassa', 'Despina', 'Galatea', 'Larissa', 'Proteus');

  naif: array[1..MaxPla] of integer =
    (199, 299, 399, 499, 599,
    699, 799, 899, 999, 10, 301,
    501, 502, 503, 504, 601, 602,
    603, 604,
    605, 606, 607, 608, 705, 701,
    702, 703,
    704, 401, 402, -1, -1,
    609, 801, 802, 901,
    505, 514, 515, 516,
    610, 611, 612, 613, 614, 615,
    616, 617, 618, 635,
    706, 707, 708, 709, 710, 711,
    712, 713, 714, 715, 725, 726, 727,
    803, 804, 805, 806, 807, 808);

  spicesegid: array[1..MaxPla] of string =
    ('', '', '', '', '',
    '', '', '', '', '', '',
    'JUP310', 'JUP310', 'JUP310', 'JUP310', 'SAT427', 'SAT427',
    'SAT427', 'SAT427',
    'SAT427', 'SAT427', 'SAT427', 'SAT427', 'URA111', 'URA111',
    'URA111', 'URA111',
    'URA111', 'MAR097', 'MAR097', '', '',
    'SAT427', 'NEP095', 'NEP095', 'PLU055',
    'JUP310', 'JUP310', 'JUP310', 'JUP310',
    'SAT393', 'SAT393', 'SAT427', 'SAT427', 'SAT427', 'SAT393',
    'SAT393', 'SAT393', 'SAT393-PAN', 'SAT393-DAPHNIS',
    'URA115', 'URA115', 'URA115', 'URA115', 'URA115', 'URA115',
    'URA115', 'URA115', 'URA115', 'URA115', 'URA115', 'URA115', 'URA115',
    'NEP095', 'NEP095', 'NEP095', 'NEP095', 'NEP095', 'NEP095');

  spicebody: array[1..9,1..20] of integer=(
    (-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ),
    (-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ),
    (301 ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ),
    (401 ,402 ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ),
    (501 ,502 ,503 ,504 ,505 ,514 ,515 ,516 ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ),
    (601 ,602 ,603 ,604 ,605 ,606 ,607 ,608 ,609 ,610 ,611 ,612 ,613 ,614 ,615 ,616 ,617 ,618 ,635 ,-1  ),
    (705 ,701 ,702 ,703 ,704 ,706 ,707 ,708 ,709 ,710 ,711 ,712 ,713 ,714 ,715 ,725 ,726 ,727 ,-1  ,-1  ),
    (801 ,802 ,803 ,804 ,805 ,806 ,807 ,808 ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ),
    (901 ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ,-1  ));

  TTNone = 0;
  TTplanet = 1;
  TTcomet = 2;
  TTasteroid = 3;
  TTaltaz = 4;
  TTimage = 5;
  TTequat = 6;
  TTbody = 7;

  CentralPlanet: array[1..36] of
    integer = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 4, 4, 6, 3, 6, 8, 8, 9);
  planetcolor: array[1..11] of double =
    (0.7, 0, 0, 1.5, 0.7, 0.7, -1.5, -1.5, 0, 0.7, 0);
  V0mar: array [1..2] of double = (11.80, 12.89);
  V0jup: array [1..8] of double = (-1.68, -1.41, -2.09, -1.05, 7.4, 9.0, 12.4, 10.8);
  V0sat: array [1..19] of double =
    (3.30, 2.10, 0.60, 0.80, 0.10, -1.28, 4.63, 1.50,
    6.7, 4.9, 6.1, 8.8, 9.1, 9.4, 9.5, 6.2, 6.9, 12, 13);
  V0ura: array [1..18] of double =
    (3.60, 1.45, 2.10, 1.02, 1.23, 11.4, 11.1, 10.3, 9.5, 9.8, 8.8, 8.3, 9.8, 9.4, 7.5, 15, 15, 15);
  V0nep: array [1..8] of double = (-1.22, 4.0, 10.0, 9.1, 7.9, 7.6, 7.3, 5.6);
  V0plu: array [1..1] of double = (1.0);
  D0mar: array [1..2] of double = (11, 6);
  D0jup: array [1..8] of double = (1821, 1565, 2634, 2403, 125, 58, 10, 20);
  D0sat: array [1..19] of double =
    (199, 249, 530, 560, 764, 2575, 143, 718, 110, 97, 69, 16, 15, 15, 18.5, 74, 55, 10, 4);
  D0ura: array [1..18] of double =
    (236, 581, 585, 789, 761, 13, 16, 22, 33, 29, 42, 55, 29, 34, 77, 5, 5, 5);
  D0nep: array [1..8] of double = (1350, 170, 29, 40, 74, 79, 104, 218);
  D0plu: array [1..1] of double = (605);
  DefaultnJPL_DE = 11;
  DefaultJPL_DE: array [1..DefaultnJPL_DE] of integer =
    (440, 441, 430, 431, 423, 421, 422, 405, 406, 403, 200);
  // JPL ephemeris to try, order by preference

  blank15 = '               ';
  blank = ' ';
  tab = #09;
  Ellipsis = '...';
  deftxt = '?';
  plusminus = '+/-'; // #$0b1;
  f0 = '0';
  f1 = '0.0';
  f1s = '0.#';
  f2 = '0.00';
  f2s = '0.##';
  f3 = '0.000';
  f4 = '0.0000';
  f4s = '0.####';
  f5 = '0.00000';
  f6 = '0.000000';
  f6s = '0.######';
  f9 = '0.000000000';
  f13 = '0.0000000000000';
  s6 = '+0.000000;-0.000000;+0.000000';
  dateiso = 'yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz';
  labspacing = 6;
  numlabtype = 11;
  numfont = 7;
  NumSimObject = 14;
  MaxField = 10;
  MaxArchiveDir = 10;
  Equat = 0;
  Altaz = 1;
  Gal = 2;
  Ecl = 3;
  ProjectionName = 'HAI MER CAR ARC TAN SIN';
  ftAll = 0;
  ftStar = 1;
  ftVar = 2;
  ftDbl = 3;
  ftNeb = 4;
  ftlin = 5;
  ftInv = 6;
  ftOnline = 7;
  ftLock = 8;
  ftCat = 99;
  ftPla = 100;
  ftCom = 101;
  ftAst = 102;
  ftBody = 103;
  BaseStar = 1000;
  MaxStarCatalog = 19;
  DefStar = 1001;
  sky2000 = 1002;
  tyc = 1003;
  tyc2 = 1004;
  tic = 1005;
  gscf = 1006;
  gscc = 1007;
  gsc = 1008;
  usnoa = 1009;
  microcat = 1010;
  dsbase = 1011;
  dstyc = 1012;
  dsgsc = 1013;
  gcstar = 1014;
  vostar = 1015;
  bsc = 1016;
  usnob = 1017;
  hn290 = 1018;
  gaia  = 1019;
  BaseVar = 2000;
  MaxVarStarCatalog = 2;
  gcvs = 2001;
  gcvar = 2002;
  BaseDbl = 3000;
  MaxDblStarCatalog = 2;
  wds = 3001;
  gcdbl = 3002;
  BaseNeb = 4000;
  MaxNebCatalog = 13;
  sac = 4001;
  ngc = 4002;
  lbn = 4003;
  rc3 = 4004;
  pgc = 4005;
  ocl = 4006;
  gcm = 4007;
  gpn = 4008;
  gcneb = 4009;
  voneb = 4010;
  uneb = 4011;
  sh2 = 4012;
  drk = 4013;
  BaseLin = 5000;
  MaxLinCatalog = 1;
  gclin = 5001;
  MaxSearchCatalog = 33;
  S_Messier = 1;
  S_NGC = 2;
  S_IC = 3;
  S_PGC = 4;
  S_GCVS = 5;
  S_GC = 6;
  S_GSC = 7;
  S_SAO = 8;
  S_HD = 9;
  S_BD = 10;
  S_CD = 11;
  S_CPD = 12;
  S_HR = 13;
  S_Comet = 14;
  S_Planet = 15;
  S_Asteroid = 16;
  S_Const = 17;
  S_Bayer = 18;
  S_Flam = 19;
  S_U2k = 20;
  S_Ext = 21;
  S_SAC = 22;
  S_SIMBAD = 23;
  S_NED = 24;
  S_WDS = 25;
  S_GCat = 26;
  S_TYC2 = 27;
  S_Common = 28;
  S_UNA = 29;
  S_UNB = 30;
  S_SH2 = 31;
  S_DRK = 32;
  S_GPN = 33;
  S_LBN = 34;
  StarLabel: Tlabellst = ('RA', 'DEC', 'Id', 'mV', 'b-v', 'mB', 'mR',
    'sp', 'pmRA', 'pmDE', 'date', 'px', 'desc', '', '', 'Str1', 'Str2', 'Str3',
    'Str4', 'Str5', 'Str6', 'Str7', 'Str8', 'Str9', 'Str10', 'Num1', 'Num2',
    'Num3', 'Num4', 'Num5', 'Num6', 'Num7', 'Num8', 'Num9', 'Num10');
  VarLabel: Tlabellst = ('RA', 'DEC', 'Id', 'mMax', 'mMin', 'Period',
    'Type', 'Mepoch', 'Rise', 'sp', 'mag. code', 'desc', '', '', '', 'Str1', 'Str2',
    'Str3', 'Str4', 'Str5', 'Str6', 'Str7', 'Str8', 'Str9', 'Str10', 'Num1',
    'Num2', 'Num3', 'Num4', 'Num5', 'Num6', 'Num7', 'Num8', 'Num9', 'Num10');
  DblLabel: Tlabellst = ('RA', 'DEC', 'Id', 'm1', 'm2', 'sep', 'pa',
    'date', 'Comp', 'sp', 'sp', 'desc', '', '', '', 'Str1', 'Str2', 'Str3', 'Str4',
    'Str5', 'Str6', 'Str7', 'Str8', 'Str9', 'Str10', 'Num1', 'Num2', 'Num3',
    'Num4', 'Num5', 'Num6', 'Num7', 'Num8', 'Num9', 'Num10');
  NebLabel: Tlabellst = ('RA', 'DEC', 'Id', 'NebTyp', 'm', 'sbr', 'Dim',
    'Dim', 'Unit', 'pa', 'rv', 'class', 'desc', '', '', 'Str1', 'Str2', 'Str3',
    'Str4', 'Str5', 'Str6', 'Str7', 'Str8', 'Str9', 'Str10', 'Num1', 'Num2',
    'Num3', 'Num4', 'Num5', 'Num6', 'Num7', 'Num8', 'Num9', 'Num10');
  nebtype: array[1..19] of
    string = (' - ', ' ? ', ' Gx', ' OC', ' Gb', ' Pl', ' Nb', 'C+N', '  *', ' D*',
    '***', 'Ast', ' Kt', 'Gcl', 'Drk', 'Cat', 'Cat', 'Cat', 'Dup');

  //Observatory database
  CdcMinLocid = '99999999';
  MaxCityList = 100;
  // Location database source url
  baseurl_us = 'https://www.ap-i.net/pub/skychart/gn/stategaz/';
  baseurl_world = 'https://www.ap-i.net/pub/skychart/gn/cntyfile/';
  location_url = 'https://ap-i.net/geoip/iploc.php';

  // Horizon Telnet
  Horizon_Telnet_Host = 'ssd.jpl.nasa.gov';
  Horizon_Telnet_Port = '6775';
  Horizon_Help = 'https://ssd.jpl.nasa.gov/?horizons_doc#intro';

  //Default URL
  URL_WebHome = 'https://www.ap-i.net/skychart';
  URL_Maillist = 'https://groups.io/g/skychart';
  URL_BugTracker = 'https://www.ap-i.net/mantis/';
  URL_DocPDF = 'https://www.ap-i.net/pub/skychart/doc/';

  URL_DELTAT     = 'https://www.ap-i.net/pub/skychart/deltat/deltat.txt';
  URL_LEAPSECOND = 'https://www.ap-i.net/pub/skychart/deltat/leap-seconds.list';


  URL_TLE = 'https://www.space-track.org';
  URL_QUICKSAT = 'https://www.prismnet.com/~mmccants/';
  URL_QSMAG = 'https://www.prismnet.com/~mmccants/programs/qsmag.zip';

  URL_TLEINFO1 = 'http://www.tle.info/data/visual.txt';
  URL_TLEINFO2 = 'http://www.tle.info/data/TLE.ZIP';

  URL_CELESTRAK1 = 'https://celestrak.com/NORAD/elements/visual.txt';


  URL_GRS = 'https://www.ap-i.net/pub/virtualplanet/grs.txt';
  URL_JUPOS = 'http://jupos.org';

  URL_IERSBulletins = 'https://www.iers.org/IERS/EN/Publications/Bulletins/bulletins.html';

  URL_HTTPCometElements1 = 'http://astro.vanbuitenen.nl/cometelements?format=mpc&mag=obs';
  URL_HTTPCometElements2 = 'https://www.minorplanetcenter.net/iau/MPCORB/CometEls.txt';

  URL_MPCORBAsteroidElements =
    'https://www.minorplanetcenter.net/iau/MPCORB/MPCORB.DAT.gz';
  URL_HTTPAsteroidElements1 = 'https://www.minorplanetcenter.net/iau/MPCORB/Unusual.txt';
  URL_HTTPAsteroidElements2 = 'https://www.minorplanetcenter.net/iau/MPCORB/NEA.txt';
  URL_HTTPAsteroidElements3 = 'https://www.minorplanetcenter.net/iau/MPCORB/Distant.txt';
  URL_CDCAsteroidElements = 'https://www.ap-i.net/pub/skychart/mpc/mpc5000.dat';

  URL_Asteroid_Lightcurve_Database_Info = 'https://minplanobs.org/MPInfo/php/lcdb.php';
  URL_Asteroid_Lightcurve_Date = 'https://www.ap-i.net/pub/skychart/asteroid/lc_summary_pub.DATE';
  URL_Asteroid_Lightcurve_Database = 'https://www.ap-i.net/pub/skychart/asteroid/lc_summary_pub.txt';
  URL_Asteroid_Lightcurve_Family = 'https://www.ap-i.net/pub/skychart/asteroid/lc_familylookup.txt';
  URL_IVOASAMP = 'http://www.ivoa.net/documents/SAMP/';

  URL_5MCSE = 'https://eclipse.gsfc.nasa.gov/5MCSE/plate%s.pdf';

  URL_DSS_NAME1 = 'DSS 1';
  URL_DSS1 =
    'http://archive.eso.org/dss/dss/image?ra=$RAH+$RAM+$RAS&dec=+$DED+$DEM+$DES&equinox=J2000&x=$XSZ&y=$YSZ&Sky-Survey=DSS1&mime-type=display/gz-fits';
  URL_DSS_NAME2 = 'DSS 2 Red';
  URL_DSS2 =
    'http://archive.eso.org/dss/dss/image?ra=$RAH+$RAM+$RAS&dec=+$DED+$DEM+$DES&equinox=J2000&x=$XSZ&y=$YSZ&Sky-Survey=DSS2-red&mime-type=display/gz-fits';
  URL_DSS_NAME3 = 'DSS 2 Blue';
  URL_DSS3 =
    'http://archive.eso.org/dss/dss/image?ra=$RAH+$RAM+$RAS&dec=+$DED+$DEM+$DES&equinox=J2000&x=$XSZ&y=$YSZ&Sky-Survey=DSS2-blue&mime-type=display/gz-fits';
  URL_DSS_NAME4 = 'DSS 2 Infrared';
  URL_DSS4 =
    'http://archive.eso.org/dss/dss/image?ra=$RAH+$RAM+$RAS&dec=+$DED+$DEM+$DES&equinox=J2000&x=$XSZ&y=$YSZ&Sky-Survey=DSS2-infrared&mime-type=display/gz-fits';
  URL_DSS_NAME5 = 'SkyView DSS';
  URL_DSS5 =
    'https://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=DSS&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';
  URL_DSS_NAME6 = 'H-alpha Full Sky Map';
  URL_DSS6 =
    'https://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=H-alpha&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';
  URL_DSS_NAME7 = '2MASS J';
  URL_DSS7 =
    'https://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=2MASS-J&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';
  URL_DSS_NAME8 = '2MASS H';
  URL_DSS8 =
    'https://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=2MASS-H&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';
  URL_DSS_NAME9 = 'IRAS 12 micron';
  URL_DSS9 =
    'https://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=IRAS12&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';
  URL_DSS_NAME10 = 'All (combined plates)';
  URL_DSS10 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=all&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_DSS_NAME11 = 'Quick-V Survey';
  URL_DSS11 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=quickv&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_DSS_NAME12 = 'DSS1 (POSS1 RED in North, POSS2/UKSTU Blue in south)';
  URL_DSS12 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=dss1&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_DSS_NAME13 = 'POSS2/UKSTU Infrared';
  URL_DSS13 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=poss2ukstu_ir&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_DSS_NAME14 = 'POSS2/UKSTU Red';
  URL_DSS14 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=poss2ukstu_red&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_DSS_NAME15 = 'POSS2/UKSTU Blue';
  URL_DSS15 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=poss2ukstu_blue&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_DSS_NAME16 = 'POSS1 Red (First Generation)';
  URL_DSS16 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=poss1_red&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_DSS_NAME17 = 'POSS1 Blue (First Generation)';
  URL_DSS17 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=poss1_blue&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_DSS_NAME18 = 'HST Phase2 (GSC1)';
  URL_DSS18 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=phase2_gsc1&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_DSS_NAME19 = 'HST Phase2 (GSC2)';
  URL_DSS19 =
    'https://archive.stsci.edu/cgi-bin/dss_search?v=phase2_gsc2&r=$RAH%3A$RAM%3A$RAS&d=$DED%3A$DEM%3A$DES&e=J2000&h=$XSZ&w=$YSZ&f=fits&c=none&fov=NONE&v3=';
  URL_SUN_NUMBER = 17;
  URL_SUN_NAME: array[1..URL_SUN_NUMBER] of string = ('SDO AIA 4500',
    'SDO AIA 304',
    'SDO AIA 193',
    'SDO AIA 171',
    'SDO AIA 211',
    'SDO AIA 131',
    'SDO AIA 335',
    'SDO AIA 094',
    'SDO AIA 1600',
    'SDO AIA 1700',
    'SOHO EIT 171',
    'SOHO EIT 195',
    'SOHO EIT 284',
    'SOHO EIT 304',
    'SOHO HMI Continuum',
    'SOHO HMI Magnetogram',
    'SOHO Sunspot');
  URL_SUN_SIZE: array[1..URL_SUN_NUMBER] of integer = (1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024,
    1024);
  URL_SUN_MARGIN: array[1..URL_SUN_NUMBER] of integer = (107,
    107,
    107,
    107,
    107,
    107,
    107,
    107,
    107,
    107,
    130,
    130,
    130,
    130,
    20,
    12,
    70);
  URL_SUN: array[1..URL_SUN_NUMBER] of
    string = ('https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_4500.jpg',
    'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_0304.jpg',
    'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_0193.jpg',
    'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_0171.jpg',
    'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_0211.jpg',
    'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_0131.jpg',
    'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_0335.jpg',
    'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_0094.jpg',
    'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_1600.jpg',
    'https://sdo.gsfc.nasa.gov/assets/img/latest/latest_1024_1700.jpg',
    'https://sohowww.nascom.nasa.gov/data/realtime/eit_171/1024/latest.jpg',
    'https://sohowww.nascom.nasa.gov/data/realtime/eit_195/1024/latest.jpg',
    'https://sohowww.nascom.nasa.gov/data/realtime/eit_284/1024/latest.jpg',
    'https://sohowww.nascom.nasa.gov/data/realtime/eit_304/1024/latest.jpg',
    'https://sohowww.nascom.nasa.gov/data/realtime/hmi_igr/1024/latest.jpg',
    'https://sohowww.nascom.nasa.gov/data/realtime/hmi_mag/1024/latest.jpg',
    'https://sohowww.nascom.nasa.gov/data/synoptic/sunspots/mdi_sunspots_1024.jpg');
  sesame_maxurl = 4;
  sesame_url: array [1..sesame_maxurl, 1..2] of string = (
    ('http://cds.u-strasbg.fr/cgi-bin/nph-sesame', 'CDS - Strasbourg, France'),
    ('http://vizier.cfa.harvard.edu/viz-bin/nph-sesame', 'CFA Harvard - USA'),
    ('http://vizier.hia.nrc.ca/viz-bin/nph-sesame', 'CADC - Canada'),
    ('http://vizier.u-strasbg.fr/cgi-bin/nph-sesame',
    'VizieR - Strasbourg, France'));
  infoname_maxurl = 4;
  infoname_url: array [1..infoname_maxurl, 1..2] of string = (
    ('http://simbad.u-strasbg.fr/simbad/sim-id?Ident=$ID', 'Simbad'),
    ('http://vizier.u-strasbg.fr/viz-bin/VizieR-S?$ID', 'Vizier'),
    ('http://ned.ipac.caltech.edu/cgi-bin/nph-objsearch?extend=no&out_csys=Equatorial&out_equinox=J2000.0&obj_sort=RA+or+Longitude&of=pre_text&zv_breaker=30000.0&list_limit=5&img_stamp=YES&objname=$ID', 'NED'),
    ('http://leda.univ-lyon1.fr/ledacat.cgi?o=$ID', 'HyperLeda'));
  infocoord_maxurl = 3;
  infocoord_url: array [1..infocoord_maxurl, 1..2] of string = (
    ('http://simbad.u-strasbg.fr/simbad/sim-coo?Radius=5&Radius.unit=arcmin&Coord=$RA%20$DE',
    'Simbad'),
    ('http://ned.ipac.caltech.edu/cgi-bin/nph-objsearch?search_type=Near+Position+Search&in_csys=Equatorial&out_csys=Equatorial&out_equinox=J2000.0&of=pre_text&zv_breaker=30000.0&list_limit=5&img_stamp=YES&in_equinox=J2000.0&radius=2.0&lon=$RA&lat=$DE', 'NED'),
    ('http://leda.univ-lyon1.fr/fG.cgi?n=a000&c=o&ob=ra&f=5&p=J$RA%20$DE',
    'HyperLeda'));

  DefaultffmpegOptions = '-b:v 18000k -bt 10000k';
{$ifdef linux}
  DefaultFontName = 'Helvetica';
  DefaultFontFixed = 'Courier';
  DefaultFontSymbol = 'adobe-symbol';
  // available in core XFree86 75 and 100 dpi fonts
  DefaultFontSize = 10;
  SysFontSize = 10;
  DefaultHomeDir = '~';
  DefaultPrivateDir = '~/.skychart';
  Defaultconfigfile = '~/.skychart/skychart.ini';
  SharedDir = '../share/skychart';
  DefaultPrintCmd1 = 'xdg-open';
  DefaultPrintCmd2 = 'xdg-open';
  DefaultTmpDir = 'tmp';
  Default_dssdrive = '/mnt/cdrom';
  DefaultVarObs = 'varobs';
  DefaultCdC = 'skychart';
  Defaultffmpeg = 'ffmpeg';
  DefaultSerialPort = '/dev/ttyUSB0';
  DefaultHnskyPath = '/opt/hnsky';
{$endif}
{$ifdef freebsd}
  DefaultFontName = 'Helvetica';
  DefaultFontFixed = 'Courier';
  DefaultFontSymbol = 'adobe-symbol';
  // available in core XFree86 75 and 100 dpi fonts
  DefaultFontSize = 10;
  SysFontSize = 10;
  DefaultHomeDir = '~';
  DefaultPrivateDir = '~/.skychart';
  Defaultconfigfile = '~/.skychart/skychart.ini';
  SharedDir = '../share/skychart';
  DefaultPrintCmd1 = 'xdg-open';
  DefaultPrintCmd2 = 'xdg-open';
  DefaultTmpDir = 'tmp';
  Default_dssdrive = '/mnt/cdrom';
  DefaultVarObs = 'varobs';
  DefaultCdC = 'skychart';
  Defaultffmpeg = 'ffmpeg';
  DefaultSerialPort = '/dev/cuaU0';
  DefaultHnskyPath = '/opt/hnsky';
{$endif}
{$ifdef darwin}
  DefaultFontName = 'Helvetica';
  DefaultFontFixed = 'Courier';
  DefaultFontSymbol = 'symbol';
  DefaultFontSize = 10;
  SysFontSize = 13;
  DefaultHomeDir = '~';
  DefaultPrivateDir = '~/Library/Application Support/skychart';
  Defaultconfigfile = '~/Library/Application Support/skychart/skychart.ini';
  SharedDir = '/usr/share/skychart';
  DefaultPrintCmd1 = 'open';
  DefaultPrintCmd2 = 'open';
  DefaultTmpDir = 'tmp';
  Default_dssdrive = '/Volumes';
  DefaultVarObs = 'varobs';
  DefaultCdC = 'skychart';
  Defaultffmpeg = 'ffmpeg';
  DefaultSerialPort = '/dev/tty.serial1';
  DefaultHnskyPath = '/opt/hnsky';
{$endif}
{$ifdef mswindows}
  DefaultFontName = 'Arial';
  DefaultFontFixed = 'Courier';
  DefaultFontSymbol = 'Symbol';
  DefaultFontSize = 10;
  SysFontSize = 8;
  DefaultHomeDir = '';
  DefaultPrivateDir = 'Skychart';
  Defaultconfigfile = 'skychart.ini';
  SharedDir = '.\';
  DefaultPrintCmd1 = 'gsview32.exe';
  DefaultPrintCmd2 = 'mspaint.exe';
  DefaultTmpDir = 'tmp';
  Default_dssdrive = 'D:\';
  DefaultVarObs = 'varobs.exe';
  DefaultCdC = 'skychart.exe';
  Defaultffmpeg = 'ffmpeg.exe';
  DefaultSerialPort = 'COM1';
  DefaultHnskyPath = 'C:\Program Files\hnsky';
{$endif}

type
  Tplanetlst = array[0..MaxPlSim, 1..MaxPla, 1..10] of double;  //ra,de,jd,diam,mag,dist,phase,ra2000,de2000,distgeocentric
  // 1..9 : planet ; 10 : soleil ; 11 : lune ; 12..15 : jup sat ; 16..23 : sat sat ;
  //24..28 : ura sat ; 29..30 : mar sat ; 31 : sat ring ; 32 : earth shadow ; 33:Phoebe; 34:Triton; 35: Nereid; 36: Charon
  //37:Amalthea, 38:Thebe, 39:Adrastea 40: Metis
  //41:Janus 42:Epimetheus 43:Helene 44:Telesto 45:Calypso 46:Atlas 47:Prometheus 48:Pandora 49:Pan 50:Daphnis
  //51:Cordelia 52:Ophelia 53:Bianca 54:Cressida 55:Desdemona 56:Juliet 57:Portia 58:Rosalind 59:Belinda 60:Puck 61:Perdita 62:Mab 63:Cupid
  //64:Naiad 65:Thalassa 66:Despina 67:Galatea 68:Larissa 69:Proteus
  Tcometlst = array of array[1..MaxComet, 1..10] of double;
  // ra, dec, magn, diam, tail_ra, tail_dec, jd, epoch, ra2000, dec2000
  TcometName = array of array[1..MaxComet, 1..2] of string[27];   // id, name
  Tasteroidlst = array of array[1..MaxAsteroid, 1..7] of double;
  // ra, dec, magn, jd, epoch, ra2000, dec2000
  TasteroidName = array of array[1..MaxAsteroid, 1..2] of string[27]; // id, name
  TBodieslst = array of array[1..MaxAsteroid, 1..7] of double;
  TBodiesName = array of array[1..MaxAsteroid, 1..2] of string[27]; // id, name
  double6 = array[1..6] of double;
  Pdouble6 = ^double6;
  doublearray = array of double;
  Pdoublearray = ^doublearray;
  coordvector = array[1..3] of double;
  rotmatrix = array[1..3, 1..3] of double;

  Tconstpos = record
    ra, de: single;
  end;

  Tconstb = record
    ra, de: single;
    newconst: boolean;
  end;

  Tconstl = record
    ra1, de1, ra2, de2: double;
    pmra1, pmde1, pmra2, pmde2, px1, rv1, px2, rv2: double;
    pm, pxrv1, pxrv2: boolean;
  end;

  TMilkywaydot = record
    ra, de: single;
    val: byte;
  end;

  TLabelAlign = (laNone, laTop, laBottom, laLeft, laRight, laCenter,
    laTopLeft, laBottomLeft, laTopRight, laBottomRight);
  Thorizonlist = array [0..361] of single;
  Phorizonlist = ^Thorizonlist;

  Tobjlabel = record
    id: integer;
    x, y, r, orientation, lsize: single;
    px, py: integer;
    labelnum, fontnum, priority: byte;
    optimizable, optimized: boolean;
    align: TLabelAlign;
    txt: string;  //txt:shortstring
  end;

  Tmodlabel = record
    id, dx, dy: integer;
    ra, Dec: double;
    orientation: single;
    labelnum, fontnum: byte;
    align: TLabelAlign;
    txt: string;
    useradec: boolean;
    hiden: boolean;
  end;

  Tcustomlabel = record
    ra, Dec: double;
    orientation: single;
    labelnum: byte;
    align: TLabelAlign;
    txt: string;
  end;

  TGCatLst = record
    min, max, magmax: single;
    cattype, col: integer;
    Actif, CatOn, ForceColor: boolean;
    shortname, Name, path, version: string;
    //shortname, name, path, version : shortstring;
  end;

  TUserObjects = record
    active: boolean;
    otype, color: integer;
    ra, Dec, mag, size: double;
    oname, comment: string;
  end;

  TAsteroidElement = packed record
    id: array[0..6] of char;
    ref: array[0..8]of char;
    name: array[0..28]of char;
    h,g,epoch,equinox: single;
    mean_anomaly,arg_perihelion,asc_node: single;
    inclination,eccentricity,semi_axis: single;
  end;
  TAsteroidElements = array of TAsteroidElement;
  TAsteroidMagnitudesJD = array of double;
  TAsteroidMagnitude = packed record
    elementidx: integer;
    magnitude: int16;
  end;
  TAsteroidMagnitudes = array of array of TAsteroidMagnitude;
  TAsteroidSearchName = record
    elementidx: integer;
    searchname: String;
  end;
  TAsteroidSearchNames = array of TAsteroidSearchName;


  Tconf_catalog = class(TObject)    // catalog setting
  public
    GCatLst: array of TGCatLst;
    GCatNum: integer;
    UserObjects: array of TUserObjects;
    StarmagMax, NebMagMax, NebSizeMin: double;
    SampSelectedTable, SampFindTable, SampFindUrl: string;
    SampSelectedNum, SampSelectX, SampSelectY, SampFindRec: integer;
    SampSelectedRec: array of integer;
    SampSelectFirst, SampSelectIdent: boolean;
    // limit to extract from catalog
    StarCatPath: array [1..MaxStarCatalog] of string;
    // path to each catalog
    StarCatDef: array [1..MaxStarCatalog] of boolean;
    // is the catalog defined
    StarCatOn: array [1..MaxStarCatalog] of boolean;
    // is the catalog used for current chart
    StarCatField: array [1..MaxStarCatalog, 1..2] of integer;
    // Field min and max the catalog is active
    VarStarCatPath: array [1..MaxVarStarCatalog] of string;   // path to each catalog
    VarStarCatDef: array [1..MaxVarStarCatalog] of boolean;
    // is the catalog defined
    VarStarCatOn: array [1..MaxVarStarCatalog] of boolean;
    // is the catalog used for current chart
    VarStarCatField: array [1..MaxVarStarCatalog, 1..2] of integer;
    // Field min and max the catalog is active
    DblStarCatPath: array [1..MaxDblStarCatalog] of string;   // path to each catalog
    DblStarCatDef: array [1..MaxDblStarCatalog] of boolean;
    // is the catalog defined
    DblStarCatOn: array [1..MaxDblStarCatalog] of boolean;
    // is the catalog used for current chart
    DblStarCatField: array [1..MaxDblStarCatalog, 1..2] of integer;
    // Field min and max the catalog is active
    NebCatPath: array [1..MaxNebCatalog] of string;
    // path to each catalog
    NebCatDef: array [1..MaxNebCatalog] of boolean;
    // is the catalog defined
    NebCatOn: array [1..MaxNebCatalog] of boolean;
    // is the catalog used for current chart
    NebCatField: array [1..MaxNebCatalog, 1..2] of integer;
    // Field min and max the catalog is active
    LinCatOn: array [1..MaxLinCatalog] of boolean;
    // is the catalog used for current chart
    UseUSNOBrightStars, UseGSVSIr, Quick: boolean;
    // filter specific catalog entry
    Name290: string; // the hnsky catalog to use
    GaiaLevel: integer; // the current Gaia level 1..3
    LimitGaiaCount: boolean; // apply the maximum number of star in level 3
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: Tconf_catalog);
  end;

  Tconf_shared = class(TObject)    // common setting
  public
    FieldNum: array [0..MaxField] of double;  // Field of vision limit
    StarFilter, NebFilter: boolean;  // filter by magnitude
    BigNebFilter: boolean;           // filter big nebulae
    NoFilterMessier: boolean;        // no filter for Messier
    NoFilterMagBright: boolean;      // no magnitude filter for bright nebula
    BigNebLimit: double;             // some catalog include very big objects that cover a quarter of the sky
    AutoStarFilter: boolean;         // automatic limit
    AutoStarFilterMag: double;       // automatic limit reference magnitude
    StarMagFilter: array [0..MaxField] of double;
    // Limiting mag. for each field
    NebMagFilter: array [0..MaxField] of double;
    // Limiting mag. for each field
    NebSizeFilter: array [0..MaxField] of double;
    // Limiting size for each field
    HourGridSpacing: array [0..MaxField] of double;
    DegreeGridSpacing: array [0..MaxField] of double;
    ShowCRose, SimplePointer: boolean; //  compass rose
    CRoseSz: integer;
    AzNorth, ListNeb, ListStar, ListVar, ListDbl, ListPla: boolean;
    VariableAlias: array of array[1..2] of string;
    VariableAliasNum: integer;
    ConstelName: array of array[1..2] of string;
    // constellation three letter abbrev and name.
    ConstLnum, ConstBnum, ConstelNum, StarNameNum: integer;
    ConstLepoch: double;
    ConstelPos: array of Tconstpos;
    ConstL: array of Tconstl;
    ConstB: array of Tconstb;
    Milkywaydotradius: single;
    MilkywaydotNum: integer;
    Milkywaydot: array of TMilkywaydot;
    StarName: array of string;
    StarNameHR: array of integer;
    ffove_tfl, ffove_efl, ffove_efv, ffovc_tfl, ffovc_px, ffovc_py,
    ffovc_cx, ffovc_cy: string;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: Tconf_shared);
  end;

  TProjOptions = record
      EquinoxType : integer;
      ApparentPos : boolean;
      PMon        : boolean;
      YPmon       : double;
      EquinoxChart   : string;
      DefaultJDChart : double;
      CoordExpertMode: boolean;
      CoordType  : integer;
  end;

  Tconf_skychart = class(TObject)    // chart setting
  public
    tz: TCdCTimeZone;
    racentre, decentre, fov, theta, acentre, hcentre, lcentre,
    bcentre, lecentre, becentre, ecl, eqeq, nutl, nuto, sunl, sunb,
    ab1, abe, abp, gr2e, raprev, deprev: double;
    EarthB, abv, ehn: coordvector;
    NutMAT, EqpMAT, EqtMAT: rotmatrix;
    ProjEquatorCentered: boolean;
    EquinoxType: integer;
    DefaultJDchart: double;
    EquinoxChart: string;
    ProjOptions: array[0..3] of TProjOptions;
    Force_DT_UT, horizonopaque, autorefresh, TrackOn, TargetOn, Quick,
    NP, SP, moved, abm, asl, ShowScale: boolean;
    projtype: char;
    projname: array [0..MaxField] of string[3];
    FlipX, FlipY, ProjPole, TrackType, TrackObj, AstSymbol, ComSymbol: integer;
    SimNb, SimD, SimH, SimM, SimS, SimLabel,SimAsteroid,SimBody: integer;
    SimComet, SimCometName, SimAsteroidName: string;
    SimObject: array[1..NumSimObject] of boolean; // 1-11=ipla, 12=ast, 13=com, 14=spk
    SimLine, SimMark, SimDateLabel, SimNameLabel, SimMagLabel,
    ShowPlanet, PlanetParalaxe, ShowEarthShadow, EarthShadowForceLine, ShowAsteroid, ShowComet,
    ShowArtSat, NewArtSat, ShowSmallsat: boolean;
    SimDateYear, SimDateMonth, SimDateDay, SimDateHour, SimDateMinute,
    SimDateSecond: boolean;
    ObsLatitude, ObsLongitude, ObsAltitude, ObsXP, ObsYP, ObsRH, ObsTlr: double;
    ObsTZ: string;
    ObsTemperature, ObsPressure: double;
    ObsName, ObsCountry, chartname, ast_day, ast_daypos, com_day,
    com_daypos, sunurlname, sunurl: string;
    CurYear, CurMonth, CurDay, DrawPMyear, sunurlsize, sunurlmargin,
    sunrefreshtime: integer;
    ShowPluto, ShowConstl, ShowConstB, ShowEqGrid, ShowGrid, ShowGridNum,
    ShowOnlyMeridian, ShowAlwaysMeridian, UseSystemTime, countrytz: boolean;
    StyleGrid, StyleEqGrid, StyleConstL, StyleConstB, StyleEcliptic, StyleGalEq: TFPPenStyle;
    LineWidthGrid, LineWidthEqGrid, LineWidthConstL, LineWidthConstB, LineWidthEcliptic, LineWidthGalEq: integer;
    ShowEcliptic, ShowGalactic, ShowEquator, ShowMilkyWay, FillMilkyWay, LinemodeMilkyway,
    ShowHorizon, ShowHorizonPicture, HorizonPictureLowQuality, FillHorizon,
    ShowHorizon0, ShowHorizonDepression: boolean;
    PrePointRA, PrePointDEC, PrePointTime, PrePointMarkRA, PrePointMarkDEC: double;
    PrePointLength: integer;
    DrawPrePoint, DarkenHorizonPicture: Boolean;
    CurTime, DT_UT_val, GRSlongitude, GRSjd, GRSdrift, TelescopeTurnsX,
    TelescopeTurnsY, TelescopeJD, HorizonPictureRotate, HorizonPictureElevation: double;
    TelLimitDecMax,TelLimitDecMin,TelLimitHaE,TelLimitHaW: double;
    TelLimitDecMaxActive,TelLimitDecMinActive,TelLimitHaEActive,TelLimitHaWActive:Boolean;
    PMon, DrawPMon, ApparentPos, CoordExpertMode, SunOnline, DSLforcecolor, DSLsurface, SurfaceBlure: boolean;
    ManualTelescopeType, CoordType, DSLcolor, SurfaceAlpha: integer;
    IndiServerHost, IndiServerPort, IndiDevice: string;
    IndiLeft, IndiTop: integer;
    IndiLoadConfig, ShowCircle, ShowCrosshair, IndiTelescope, ASCOMTelescope,
    ManualTelescope, ShowImages,
    EyepieceMask, ShowImageList, ShowImageLabel, ShowBackgroundImage,
    showstars, shownebulae, showline, showlabelall, Editlabels,
    OptimizeLabels, RotLabel: boolean;
    BackgroundImage: string;
    MaxArchiveImg: integer;
    ArchiveDir: array[1..MaxArchiveDir] of string;
    ArchiveDirActive: array[1..MaxArchiveDir] of boolean;
    HorizonRise: boolean;
    // working variable
    ephvalid, ShowPlanetValid, ShowCometValid, ShowAsteroidValid, ShowBodiesValid,
    CalcephActive, SpiceActive, SmallSatActive, ShowEarthShadowValid, ShowEclipticValid, PlotImageFirst: boolean;
    HorizonMax, HorizonMin, rap2000, dep2000, RefractionOffset, ObsRAU, ObsZAU, Diurab: double;
    racentre2000,decentre2000: double;
    haicx, haicy, ObsRefractionCor, ObsRefA, ObsRefB, ObsHorizonDepression,
    ObsELONG, ObsPHI, ObsDAZ: double;
    WindowRatio, BxGlb, ByGlb, AxGlb, AyGlb, sintheta, costheta, x2: double;
    Xwrldmin, Xwrldmax, Ywrldmin, Ywrldmax: double;
    xmin, xmax, ymin, ymax, xshift, yshift, FieldNum, winx, winy,
    wintop, winleft, FindType, FindIpla: integer;
    LeftMargin, RightMargin, TopMargin, BottomMargin, HeaderHeight, FooterHeight,
    Xcentre, Ycentre: integer;
    ObsRoSinPhi, ObsRoCosPhi, StarmagMax, NebMagMax, FindRA, FindDec,
    FindRA2000, FindDec2000, FindPX, FindSize, FindX, FindY, FindZ,
    FindSimjd, AstmagMax, AstMagDiff, CommagMax, Commagdiff: double;
    TimeZone, DT_UT, DT_UTerr, CurST, CurJDTT, CurJDUT, LastJD, jd0,
    JDChart, YPmon, LastJDChart, FindJD, CurSunH, CurMoonH, CurMoonIllum,
    ScopeRa, ScopeDec, TrackElemEpoch, TrackEpoch, TrackRA, TrackDec,
    TargetRA, TargetDec, FindPMra, FindPMde, FindPMEpoch, FindPMpx,
    FindPMrv, FindDist, FindBV, FindMag: double;
    Scope2Ra, Scope2Dec: double;
    DrawAllStarLabel, MovedLabelLine, MagNoDecimal, StarFilter, NebFilter, FindOK,
    WhiteBg, ShowLegend, MagLabel, NameLabel, DistLabel, ConstFullLabel,
    ConstLatinLabel, ScopeMark, Scope2Mark, ScopeLock, FindPM,
    FindStarPM, FindPMfullmotion, AstNEO, ChartLock, ONGCimg : boolean;
    EquinoxName, TargetName, TrackName, TrackId, FindName, FindDesc,
    FindDesc2, FindDesc2000, FindNote, FindCat, FindCatname, FindId: string;
    BGalpha: integer;
    BGitt: Titt;
    BGmin_sigma, BGmax_sigma, NEBmin_sigma, NEBmax_sigma: double;
    PlanetLst: Tplanetlst;
    AsteroidNb, CometNb, BodiesNb, AsteroidLstSize, CometLstSize, NumCircle: integer;
    AsteroidLst: Tasteroidlst;
    CometLst: Tcometlst;
    AsteroidName: TasteroidName;
    CometName: Tcometname;
    SPKBodies: TTargetArray;
    SPKNames: TBodyNameArray;
    BodiesLst: TBodieslst;
    BodiesName: TBodiesName;
    horizonlist: Thorizonlist;
    horizonpicture, horizonpicturedark: TBGRABitmap;
    HorizonFile, HorizonPictureFile: string;
    horizonlistname, horizonpicturename: string;
    horizonpicturevalid: boolean;
    horizondarken: integer;
    nummodlabels, posmodlabels, numcustomlabels, poscustomlabels: integer;
    modlabels: array[1..maxmodlabels] of Tmodlabel;
    customlabels: array[1..maxmodlabels] of Tcustomlabel;
    LabelMagDiff: array[1..numlabtype] of double;
    LabelOrient: array[1..numlabtype] of double;
    ShowLabel: array[1..numlabtype] of boolean;
    ObslistAlLabels: boolean;
    ncircle, nrectangle: integer;
    circle: array of array [1..4] of single; // radius, rotation, offset, mode
    circleok: array of boolean;
    circlelbl: array of string;
    rectangle: array of array [1..5] of single; // width, height, rotation, offset, mode
    rectangleok: array of boolean;
    rectanglelbl: array of string;
    CircleLst: array[0..MaxCircle, 1..2] of double;
    CircleLabel, RectangleLabel, marknumlabel: boolean;
    msg: string;
    CometMark, AsteroidMark: TStringList;
    SPKlist: TStringList;
    // Calendar
    CalGraphHeight: integer;
    // Planisphere
    PlanisphereDate, PlanisphereTime: boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: Tconf_skychart);
  end;

  Tconf_plot = class(TObject)    // plot setting
  public
    color: Starcolarray;
    skycolor: TSkycolor;
    backgroundcolor, bgcolor: Tcolor;
    stardyn, starsize, prtres, starplot, nebplot, plaplot: integer;
    Nebgray, NebBright, starshapesize, starshapew: integer;
    Invisible, AutoSkycolor, TransparentPlanet, UseBMP, AntiAlias: boolean;
    // 1=grid 2=label 3=legend 4=status 5=list 6=prt 7=symbol
    FontName: array [1..numfont] of string;
    FontSize: array [1..numfont] of integer;
    FontBold: array [1..numfont] of boolean;
    FontItalic: array [1..numfont] of boolean;
    // 1=star 2=var 3=mult 4=neb 5=planet 6=const 7=misc 8=chart info 9=obslist 10=asteroid 11=comet
    LabelColor: array[1..numlabtype] of Tcolor;
    LabelSize: array[1..numlabtype] of integer;
    outradius, contrast, saturation: integer;
    xmin, xmax, ymin, ymax: integer;
    partsize, magsize: single;
    red_move: boolean;
    autoskycolorValid: boolean;
    MinDsoSize: integer;
    //  deep-sky objects colour defaults filss are decalers as boolean - either fill or not
    DSOColorFillAst: boolean;
    DSOColorFillOCl: boolean;
    DSOColorFillGCl: boolean;
    DSOColorFillPNe: boolean;
    DSOColorFillDN: boolean;
    DSOColorFillEN: boolean;
    DSOColorFillRN: boolean;
    DSOColorFillSN: boolean;
    DSOColorFillGxy: boolean;
    DSOColorFillGxyCl: boolean;
    DSOColorFillQ: boolean;
    DSOColorFillGL: boolean;
    DSOColorFillNE: boolean;
    //  End of deep-sky objects colour

    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: Tconf_plot);
  end;

  Tconf_chart = class(TObject)    // chart window setting
  public
    onprinter: boolean;
    Width, Height, drawpen, drawsize, hw, hh, cliparea: integer;
    fontscale: single;
    min_ma, max_catalog_mag: double;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: Tconf_chart);
  end;

  TObsDetail = class(TObject)
  public
    country, tz, horizonfn, horizonpictfn: string;
    lat, lon, alt, pictureangleoffset,pictureelevation: double;
    countrytz, showhorizonline, showhorizonpicture: boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  TLabelCoord = class(TObject)
    ra, Dec: double;
  end;

  Tconf_main = class(TObject)    // main form setting
  public
    prtname, language, Constellationpath, ConstLfile, ConstBfile,
    EarthMapFile, Planetdir: string;
    db, ImagePath, persdir: string;
    starshape_file, KioskPass: string;
    Paper, PrinterResolution, PrintMethod, PrintColor, PrintBmpWidth,
    PrintBmpHeight, btnsize: integer;
    btncaption, ScreenScaling: boolean;
    configpage, configpage_i, configpage_j, autorefreshdelay, MaxChildID,
    PrtLeftMargin, PrtRightMargin, PrtTopMargin, PrtBottomMargin, PrintCopies: integer;
    savetop, saveleft, saveheight, savewidth: integer;
    AnimDelay, AnimSx, AnimSy, AnimSize,
    VOurl, VOmaxrecord: integer;
    VOforceactive, UOforceactive: boolean;
    PrintLandscape, ShowChartInfo, ShowTitlePos, SyncChart, AnimRec: boolean;
    maximized, updall, AutostartServer, keepalive, NewBackgroundImage: boolean;
    ServerCoordSys: integer;
    TextOnlyDetail, SimpleMove, SimpleDetail, KioskMode, KioskDebug,
    CenterAtNoon: boolean;
    PrintDesc, PrintCmd1, PrintCmd2: string;
    PrintTmpPath, ThemeName, IndiPanelCmd, AnimRecDir, AnimRecPrefix, AnimRecExt: string;
    NightColor: integer;
    PrintHeader, PrintFooter, InternalIndiPanel: boolean;
    AnimOpt, Animffmpeg: string;
    ServerIPaddr, ServerIPport: shortstring;
    AnimFps: double;
    ProxyHost, ProxyPort, ProxyUser, ProxyPass, AnonPass, SocksType: string;
    FtpPassive, HttpProxy, SocksProxy, ConfirmDownload: boolean;
    CometUrlList, AsteroidUrlList, TleUrlList: TStringList;
    ObsNameList: TStringList;
    SesameUrlNum, SesameCatNum: integer;
    ClockColor: TColor;
    SampAutoconnect, SampKeepTables, SampKeepImages: boolean;
    SampConfirmCoord, SampConfirmImage, SampConfirmTable: boolean;
    SampSubscribeCoord, SampSubscribeImage, SampSubscribeTable: boolean;
    ObsListLimitType, ObsListMeridianSide: integer;
    InitObsList, ObslistAirmass, ObslistHourAngle: string;
    ObslistAirmassLimit1, ObslistAirmassLimit2, ObslistHourAngleLimit1,
    ObslistHourAngleLimit2: boolean;
    tlelst: string;
    HorizonEmail:string;
    HorizonNumDay: integer;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: Tconf_main);
  end;

  Tconf_dss = class(TObject)    // DSS image setting
  public
    dssdir, dssdrive, dssfile, dssarchivedir: string;
    dss102, dssnorth, dsssouth, dsssampling,
    dssplateprompt, dssarchive, dssarchiveprompt: boolean;
    dssmaxsize: integer;
    OnlineDSS: boolean;
    OnlineDSSid: integer;
    DSSurl: array[1..MaxDSSurl, 0..1] of string;
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: Tconf_dss);
  end;


type
  TPrepareAsteroid = function(jd1, jd2, step: double; msg: TStrings): boolean of object;
  TGetTwilight = procedure(jd0: double; out ht: double) of object;

type
  TPlanData = record
    l: double;
    b: double;
    r: double;
    x: double;
    y: double;
    z: double;
  end;

// external library
const
  jdmin404 = 625673.5;
  jdmax404 = 2816787.5;
{$ifdef linux}
  lib404 = 'libpasplan404.so.1';
  libcdcwcs = 'libpaswcs.so.1';
  libz = 'libz.so.1';
  libspice = 'libpasspice.so.1';
{$endif}
{$ifdef freebsd}
  lib404 = 'libplan404.so';
  libcdcwcs = 'libcdcwcs.so';
  libz = 'libz.so.1';
  libspice = 'libpasspice.so.1';
{$endif}
{$ifdef darwin}
  lib404 = 'libplan404.dylib';
  libcdcwcs = 'libcdcwcs.dylib';
  libz = 'libz.dylib';
  libspice = 'libpasspice.dylib';
{$endif}
{$ifdef mswindows}
  lib404 = 'libplan404.dll';
  libcdcwcs = 'libcdcwcs.dll';
  libz = 'zlib1.dll';
  libspice = 'libpasspice.dll';
{$endif}

// libplan404
type
  TPlanetData = record
    JD: double;
    l: double;
    b: double;
    r: double;
    x: double;
    y: double;
    z: double;
    ipla: integer;
  end;
  PPlanetData = ^TPlanetData;
  TPlan404 = function(pla: PPlanetData): integer; cdecl;

var
  Plan404: TPlan404;
  Plan404lib: TLibHandle;

// libcdcwcs
type
  TcdcWCScoord = record
    ra, Dec, x, y: double;
    n: integer;
  end;
  PcdcWCScoord = ^TcdcWCScoord;

  TcdcWCSinfo = record
    cra, cdec, dra, ddec, secpix, eqout, rot: double;
    wp, hp, sysout: integer;
  end;
  PcdcWCSinfo = ^TcdcWCSinfo;
  Tcdcwcs_initfitsfile = function(fn: PChar; wcsnum: integer): integer; cdecl;
  Tcdcwcs_release = function(wcsnum: integer): integer; cdecl;
  Tcdcwcs_sky2xy = function(p: PcdcWCScoord; wcsnum: integer): integer; cdecl;
  Tcdcwcs_getinfo = function(p: PcdcWCSinfo; wcsnum: integer): integer; cdecl;

var
  cdcwcslib: TLibHandle;
  cdcwcs_initfitsfile: Tcdcwcs_initfitsfile;
  cdcwcs_release: Tcdcwcs_release;
  cdcwcs_getinfo: Tcdcwcs_getinfo;
  cdcwcs_sky2xy: Tcdcwcs_sky2xy;

const
  maxfitslist = 15;  // must corespond to value in cdcwcs.c

//  zlib
type
  Tgzopen = function(path, mode: PChar): pointer; cdecl;
  Tgzread = function(gzFile: pointer; buf: pointer; len: cardinal): longint; cdecl;
  Tgzeof = function(gzFile: pointer): longbool; cdecl;
  Tgzclose = function(gzFile: pointer): longint; cdecl;

var
  gzopen: Tgzopen;
  gzread: Tgzread;
  gzeof: Tgzeof;
  gzclose: Tgzclose;
  zlibok: boolean;
  zlib: TLibHandle;

//  libpasspice
const
  SpiceFirstYear = 2000;
  SpiceLastYear = 2049;
type
  TcdcSpice = record
    obs, target: integer;
    et: double;
    x,y,z: double;
    segid: array [0..79] of Char;
    err: integer;
  end;
  Tiniterr = procedure (); cdecl;
  Tloadspk = function (fn:PChar): integer; cdecl;
  Tcomputepos = procedure (var data:TcdcSpice); cdecl;
  Tgetlongerror= procedure (msg:PChar); cdecl;
  Tgetshorterror= procedure (msg:PChar); cdecl;
var
  SpiceFolder: string;
  SpiceBaseOk,SpiceExtOk: boolean;
  SpiceLib: TLibHandle;
  SpiceIniterr: Tiniterr;
  SpiceLoadspk: Tloadspk;
  SpiceComputepos: Tcomputepos;
  SpiceGetlongerror: Tgetlongerror;
  SpiceGetshorterror: Tgetshorterror;

// Encoders
type
  PInit_object = ^Tinit_object;
  // pointeur sur un element servant a l initialisation des codeurs

  Tinit_object = record
    Name: string;
    alpha: double;
    delta: double;
    alt: double;
    az: double;
    steps_x: integer;
    steps_y: integer;
    phi: double;
    theta: double;
    time: tdatetime;
    error: double;
  end;

// pseudo-constant only here
var
  ConfigAppdir, ConfigPrivateDir, Appdir, PrivateDir, SampleDir,
  SatDir, SatArchiveDir, ArchiveDir, TempDir, ZoneDir, HomeDir, VODir,
  ScriptDir, PrivateScriptDir: string;
  VarObs, CdC, MPCDir, DBDir, PictureDir, SPKdir: string;
  ForceConfig, ForceUserDir, Configfile, Lang: string;
  compile_time, compile_version, compile_system, compile_cpu, lclver, cpydate: string;
  ldeg, lmin, lsec: string;
  MaxThreadCount: integer;
  ImageListCount: integer;
  nightvision, DarkTheme: boolean;
  CurrentTheme: string;
  isWOW64: boolean;
  isAdmin, UacEnabled: boolean;
  isANSItmpdir: boolean;
  DisplayIs32bpp: boolean;
  ThemePath: string = 'data/Themes';
  LinuxDesktop: integer = 0;  // FreeDesktop=0, Other=1
  crRetic: TCursor = 5;
  Params: TStringList;
  de_folder, de_filename: string;
  de_type, de_jdcheck: integer;
  de_jdstart, de_jdend: double;
  VerboseMsg: boolean = False;
  WantUnique: boolean;
  WideLine: integer = 2;
  MarkWidth: integer = 1;
  MarkType: integer = 1;
  IndiGUIready: boolean;
  SampConnected: boolean;
  SampClientId, SampClientName, SampClientDesc: TStringList;
  SampClientCoordpointAtsky, SampClientImageLoadFits, SampClientTableLoadVotable:
  TStringList;
  Xplanetrender: boolean;
  Xplanetversion: string;
  nummainbar, numobjectbar, numleftbar, numrightbar: integer;
  configmainbar, configobjectbar, configleftbar, configrightbar: TStringList;
  CatAnimation, CatDirection, CatDrawing, CatEdit, CatFile, CatFilter,
  CatFOV, CatGrid, CatInformation, CatLabel, CatLines, CatLock, CatObject,
  CatOrientation, CatPictures, CatPrint, CatProjection, CatSearch, CatSetup,
  CatSetupOption, CatTelescope, CatTools, CatUndo, CatView, CatWindow, CatZoom: string;
  nJPL_DE: integer;
  JPL_DE: array of integer;
  GregorianStart, GregorianStartJD: integer;
  ServerCoordSystem: TServerCoordSys;
  deltat: array of array of single;   // date, deltat, error
  numdeltat: integer;
  leapseconds: array of array of double;   // date, delta_at
  numleapseconds: integer;
  leapsecondexpires: double;

{$ifdef darwin}
  OpenFileCMD: string = 'open';
{$else}
  OpenFileCMD: string = 'xdg-open';   // default FreeDesktop.org
{$endif}
{$ifdef linux}
  tracefile: string = ''; // to stdout
  dcd_cmd: string = 'cd /usr/local/dcd ; python3 ./dcd.py';
  use_xplanet: boolean = True;
  xplanet_dir: string = '';
{$endif}
{$ifdef freebsd}
  tracefile: string = ''; // to stdout
  dcd_cmd: string = 'cd /usr/local/dcd ; python3 ./dcd.py';
  use_xplanet: boolean = True;
  xplanet_dir: string = '';
{$endif}
{$ifdef darwin}
  tracefile: string = 'cdc_trace.txt';
  dcd_cmd: string = 'cd /usr/local/dcd ; python3 ./dcd.py';
  use_xplanet: boolean = True;
  xplanet_dir: string = 'data/planet';
{$endif}
{$ifdef mswindows}
  tracefile: string = 'cdc_trace.txt';
  dcd_cmd: string = 'cmd /c "C: && cd C:\Program Files\dcd && dcd.py"';
  use_xplanet: boolean = True;
  xplanet_dir: string = 'data\planet';
{$endif}

// Text formating constant
const
  html_h =
    '<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /></HEAD><body><div>';
  html_h_nv =
    '<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /></HEAD><body bgcolor="#000000" text="#C03030"><div>';
  html_h_drk =
    '<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /></HEAD><body bgcolor="#000000" text="#C0C0C0"><div>';
  html_h_b =
    '<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /></HEAD><body bgcolor="#000000" text="#FFFFFF"><div>';
  htms_h = '</div></body></HTML>';
  html_ffx = '<font face="fixed">';
  htms_f = '</font>';
  html_b = '<b>';
  htms_b = '</b>';
  html_h2 = '<font size="+2"><b>';
  htms_h2 = '</b></font><br>';
  html_p = '<p>';
  htms_p = '</p>';
  html_br = '<br>';
  html_sp = '&nbsp;';
  html_pre = '<pre>';
  htms_pre = '</pre>';

const
  msgTimeout = 'Timeout!';
  msgOK = 'OK!';
  msgFailed = 'Failed!';
  msgNotFound = 'Not found!';
  msgTrue = 'True!';
  msgFalse = 'False!';
  msgBye = 'Bye!';

const
  MaxCmdArg = 10;
  // Main Commands, excuted form main form
  numcmdmain = 19;
  maincmdlist: array[1..numcmdmain, 1..3] of string = (
    ('NEWCHART', '1', 'chart_name'),
    ('CLOSECHART', '2', 'chart_name'),
    ('SELECTCHART', '3', 'chart_name'),
    ('LISTCHART', '4', ''),
    ('SEARCH', '5', 'object_name'),
    ('GETMSGBOX', '6', ''),
    ('GETCOORBOX', '7', ''),
    ('GETINFOBOX', '8', ''),
    ('FIND', '9', 'object_class object_name'),
    //class: 0=neb, 1=na, 2=star, 3=star,4=var,5=dbl,6=comet,7=ast,8=planet,9=constellation,10=linecat,11=const.abrev.
    ('SAVE', '10', 'saved_file_name'),
    ('LOAD', '11', 'saved_file_name'),
    ('?', '12', ''),
    ('SHUTDOWN', '13', ''),
    ('RESET', '14', ''),
    ('LOADDEFAULT', '15', 'saved_file_name'),
    ('SETCAT', '16', 'path name active min max'),
    ('PLANETINFO', '17', 'page_num'),
    ('GETSELECTEDOBJECT', '18', ''),
    ('LOADMPCORB', '19', 'mpcorb_file_name')
    );

  // Chart Commands
  numcmd = 131;
  cmdlist: array[1..numcmd, 1..3] of string = (
    ('ZOOM+', '1', ''),
    ('ZOOM-', '2', ''),
    ('MOVEEAST', '3', ''),
    ('MOVEWEST', '4', ''),
    ('MOVENORTH', '5', ''),
    ('MOVESOUTH', '6', ''),
    ('MOVENORTHEAST', '7', ''),
    ('MOVENORTHWEST', '8', ''),
    ('MOVESOUTHEAST', '9', ''),
    ('MOVESOUTHWEST', '10', ''),
    ('FLIPX', '11', ''),
    ('FLIPY', '12', ''),
    ('SETCURSOR', '13', 'pixX pixY'),
    ('CENTRECURSOR', '14', ''),
    ('ZOOM+MOVE', '15', ''),
    ('ZOOM-MOVE', '16', ''),
    ('ROT+', '17', ''),
    ('ROT-', '18', ''),
    ('SETEQGRID', '19', 'ON/OFF'),
    ('SETGRID', '20', 'ON/OFF'),
    ('SETSTARMODE', '21', '0/1/2'),
    ('SETNEBMODE', '22', '0/1'),
    ('SETAUTOSKY', '23', 'ON/OFF'),
    ('UNDO', '24', ''),
    ('REDO', '25', ''),
    ('SETPROJ', '26', 'ALTAZ/EQUAT/GALACTIC/ECLIPTIC'),
    ('SETFOV', '27', '00d00m00s or 00.00'),
    ('SETRA', '28', 'RA:00h00m00s or 00.00'),
    ('SETDEC', '29', 'DEC:+00d00m00s or 00.00'),
    ('SETOBS', '30', 'LAT:+00d00m00sLON:+000d00m00sALT:000mOBS:name'),
    ('IDCURSOR', '31', ''),
    ('SAVEIMG', '32', 'PNG/JPEG/BMP filename quality'),
    ('SETNORTH', '33', ''),
    ('SETSOUTH', '34', ''),
    ('SETEAST', '35', ''),
    ('SETWEST', '36', ''),
    ('SETZENITH', '37', ''),
    ('ALLSKY', '38', ''),
    ('REDRAW', '39', ''),
    ('GETCURSOR', '40', ''),
    ('GETEQGRID', '41', ''),
    ('GETGRID', '42', ''),
    ('GETSTARMODE', '43', ''),
    ('GETNEBMODE', '44', ''),
    ('GETAUTOSKY', '45', ''),
    ('GETPROJ', '46', ''),
    ('GETFOV', '47', 'S/F'),
    ('GETRA', '48', 'S/F'),
    ('GETDEC', '49', 'S/F'),
    ('GETDATE', '50', ''),
    ('GETOBS', '51', ''),
    ('SETDATE', '52', 'yyyy-mm-ddThh:mm:ss or "yyyy-mm-dd hh:mm:ss"'),
    ('SETTZ', '53', 'UTC+2'),
    ('GETTZ', '54', ''),
    // V2.7 compatibility DDE command
    ('MOVE', '55', 'obsolete, RA: 00h00m00.00s DEC:+00d00m00.0s FOV:+00d00m00s'),
    ('DATE', '52', 'obsolete, same as SETDATE'),
    ('OBSL', '30', 'obsolete, same as SETOBS'),
    ('RFSH', '39', 'obsolete, same as REDRAW'),
    ('PDSS', '56', ''),
    ('SBMP', '57', 'obsolete, use SAVEIMG'),
    ('SGIF', '58', 'obsolete, use SAVEIMG'),
    ('SJPG', '59', 'obsolete, use SAVEIMG'),
    ('IDXY', '60', 'X:pixelx Y:pixely'),
    ('GOXY', '61', 'X:pixelx Y:pixely'),
    ('ZOM+', '1', 'obsolete, same as ZOOM+'),
    ('ZOM-', '2', 'obsolete, same as ZOOM-'),
    ('STA+', '62', ''),
    ('STA-', '63', ''),
    ('NEB+', '64', ''),
    ('NEB-', '65', ''),
    ('GREQ', '66', 'obsolete, use SETEQGRID'),
    ('GRAZ', '67', 'obsolete, use SETGRID'),
    ('GRNM', '68', 'obsolete, use SETGRIDNUM'),
    ('CONL', '69', 'obsolete, use SETCONSTLINE'),
    ('CONB', '70', 'obsolete, use SETCONSTBOUNDARY'),
    ('EQAZ', '71', 'obsolete, use SETPROJ'),
    // end V2.7 compatibility DDE command
    ('SETGRIDNUM', '77', 'ON/OFF'),
    ('SETCONSTLINE', '78', 'ON/OFF'),
    ('SETCONSTBOUNDARY', '79', 'ON/OFF'),
    ('RESIZE', '80', 'width height'),
    ('PRINT', '81', 'PRT/PS/BMP PORTRAIT/LANDSCAPE COLOR/BW filepath'),
    ('GETRISESET', '82', ''),
    ('MOVESCOPE', '83', 'RA Dec [00.00]'),
    ('MOVESCOPEH', '84', 'HourAngle Declination [00.00]'),
    ('IDCENTER', '85', ''),
    ('IDSCOPE', '86', ''),
    ('SHOWPICTURE', '87', 'ON/OFF'),
    ('SHOWBGIMAGE', '88', 'ON/OFF'),
    ('LOADBGIMAGE', '89', 'fits_filename'),
    ('GETOBJECTLIST', '90', ''),
    ('LOADCIRCLE', '91', 'file_name'),
    ('SETCIRCLE', '92', 'num diameter rotation offset'),
    ('SETRECTANGLE', '93', 'num width height rotation offset'),
    ('SHOWCIRCLE', '94', 'num_list'),
    ('SHOWRECTANGLE', '95', 'num_list'),
    ('MARKCENTER', '96', 'ON/OFF'),
    ('GETSCOPERADEC', '97', 'S/F'),
    ('CONNECTINDI', '98', ''),
    ('DISCONNECTINDI', '99', ''),
    ('SLEWINDI', '100', 'RAhr in decimal and Dec in decimal'),
    ('ABORTSLEWINDI', '101', ''),
    ('SYNCINDI', '102', 'RAhr in decimal and Dec in decimal'),
    ('TRACKTELESCOPE', '103', 'ON/OFF'),
    ('CONNECTTELESCOPE', '104', ''),
    ('DISCONNECTTELESCOPE', '105', ''),
    ('SYNC', '106', 'RAhr in decimal and Dec in decimal'),
    ('SLEW', '107', ''),
    ('ABORTSLEW', '108', ''),
    ('OBSLISTLOAD', '109', 'list_file_name'),
    ('OBSLISTFIRST', '110', ''),
    ('OBSLISTLAST', '111', ''),
    ('OBSLISTNEXT', '112', ''),
    ('OBSLISTPREV', '113', ''),
    ('OBSLISTLIMIT', '114', 'ON/OFF'),
    ('OBSLISTAIRMASSLIMIT', '115', 'num'),
    ('OBSLISTTRANSITLIMIT', '116', 'hours'),
    ('OBSLISTTRANSITSIDE', '117', 'EAST/WEST/BOTH'),
    ('GETSCOPERATES', '118', ''),
    ('SCOPEMOVEAXIS', '119', 'axis(0/1) rate'),
    ('SETSCOPEREFRESHRATE', '120', 'delay [ms]'),
    ('PLANISPHEREDATE', '121', 'ON/OFF'),
    ('PLANISPHERETIME', '122', 'ON/OFF'),
    ('SETFOVPROJECTION', '123', 'FOV_NUM HAI/MER/CAR/ARC/TAN/SIN'),
    ('SHOWONLYMERIDIAN', '124', 'ON/OFF'),
    ('SHOWALWAYSMERIDIAN', '125', 'ON/OFF'),
    ('CLEANUPMAP', '126', ''),
    ('GETCHARTEQSYS', '127', 'DATE/2000.0'),
    ('GETSCOPESLEWING', '128', 'True/False'),
    ('GETFRAMES', '129', ''),
    ('SETCHARTEQUINOX', '130', 'DATE/J2000'),
    ('SETFIELDNUMBER', '131', '1..10')
    );

// Database
const
  showtable: string = 'select name from sqlite_master where type="table" and name like';
  defaultSqliteDB = 'cdc.db';
// SQL Table structure
  create_table_ast_day =
    ' ( jd int NOT NULL default 0, limit_mag int NOT NULL default 0)';
  create_table_ast_day_pos =
    '( id text NOT NULL default "", epoch double NOT NULL default 0,' +
    'ra int NOT NULL default 0,  de int NOT NULL default 0,' +
    'mag int NOT NULL default 0, near_earth int NOT NULL default 0,'+
    'idx int NOT NULL default 0, PRIMARY KEY (ra,de,mag,id))';
  create_table_com_day =
    ' ( jd int(11) NOT NULL default "0", limit_mag smallint(6) NOT NULL default "0")';
  create_table_com_day_pos =
    '( id varchar(12) NOT NULL default "", epoch double NOT NULL default "0",' +
    'ra smallint(6) NOT NULL default "0", de smallint(6) NOT NULL default "0",' +
    'mag smallint(6) NOT NULL default "0", near_earth smallint(1) NOT NULL default "0", PRIMARY KEY (ra,de,mag))';
  numsqltable = 8;
  sqltable: array[1..numsqltable, 1..3] of string = (
     // sqlite tables
    ('cdc_com_name',
    ' ( id TEXT NOT NULL default "0", name TEXT NOT NULL default "",' +
    'PRIMARY KEY (id))', ''),
    ('cdc_com_elem_list',
    ' ( elem_id INTEGER NOT NULL default "0", filedesc TEXT NOT NULL default "",' +
    'PRIMARY KEY (elem_id))', ''),
    ('cdc_com_elem', ' ( id TEXT NOT NULL default "0",' +
    'peri_epoch NUMERIC NOT NULL default "0", peri_dist NUMERIC NOT NULL default "0",'
    +
    'eccentricity NUMERIC NOT NULL default "0",' +
    'arg_perihelion NUMERIC NOT NULL default "0", asc_node NUMERIC NOT NULL default "0",'
    +
    'inclination NUMERIC NOT NULL default "0",' +
    'epoch NUMERIC NOT NULL default "0",' +
    'h NUMERIC NOT NULL default "0", g NUMERIC NOT NULL default "0",' +
    'name TEXT NOT NULL default "", equinox INTEGER NOT NULL default "0",' +
    'elem_id INTEGER NOT NULL default "0", PRIMARY KEY (id,epoch))', ''),
    ('cdc_fits', ' (filename TEXT NOT NULL default "", ' +
    'catalogname TEXT  NOT NULL default "", ' +
    'objectname TEXT NOT NULL default "", ' + 'ra NUMERIC NOT NULL default "0",' +
    'de NUMERIC NOT NULL default "0", ' + 'width NUMERIC NOT NULL default "0", ' +
    'height NUMERIC NOT NULL default "0", ' +
    'rotation  NUMERIC NOT NULL default "0", ' +
    'PRIMARY KEY (catalogname,ra,de))', '1'),
    ('cdc_country', '(country TEXT NOT NULL default "",' +
    'isocode TEXT NOT NULL default "",' + 'name TEXT NOT NULL default "",' +
    'PRIMARY KEY (country))', ''),
    ('cdc_location', '(locid INTEGER NOT NULL ,' + 'country TEXT NOT NULL ,' +
    'location TEXT NOT NULL ,' + 'type TEXT NOT NULL ,' +
    'latitude NUMERIC NOT NULL ,' + 'longitude NUMERIC NOT NULL ,' +
    'elevation NUMERIC NOT NULL ,' + 'timezone NUMERIC NOT NULL ,' +
    'PRIMARY KEY (locid))', '2,3'),
    ('cdc_ast_ext', ' ( name TEXT NOT NULL default "", '+
     'number NUMERIC default "0", fam TEXT NOT NULL default "",' +
    'h NUMERIC NOT NULL default "0", g NUMERIC NOT NULL default "0", ' +
    'diam NUMERIC NOT NULL default "0", period NUMERIC NOT NULL default "0", ' +
    'amin NUMERIC NOT NULL default "0", amax NUMERIC NOT NULL default "0",  u TEXT NOT NULL default "", ' +
    'PRIMARY KEY (name))', '4'),
    ('cdc_ast_fam', ' ( number NUMERIC, parent NUMERIC, name TEXT, PRIMARY KEY (number))', '')
    );
  numsqlindex = 4;
  sqlindex: array[1..numsqlindex, 1..2] of string = (
    ('cdc_fits_objname', 'cdc_fits (catalogname,objectname)'),
    ('cdc_location_idx1', 'cdc_location(country,location)'),
    ('cdc_location_idx2', 'cdc_location(latitude,longitude)'),
    ('cdc_ast_ext_idx1', 'cdc_ast_ext(number)')
    );

const
  // Minimal main toolbar
  numminimalmainbar = 19;
  minimalmainbar: array[1..numminimalmainbar] of string = (
    ('38;toN'),
    ('37;toE'),
    ('39;toS'),
    ('40;toW'),
    ('41;toZenith'),
    ('100;Divider'),
    ('72;AltAzProjection'),
    ('71;EquatorialProjection'),
    ('92;rotate180'),
    ('102;quicksearch'),
    ('100;Divider'),
    ('6;zoomplus'),
    ('7;zoomminus'),
    ('100;Divider'),
    ('43;TimeDec'),
    ('84;TimeReset'),
    ('44;TimeInc'),
    ('103;TimeValPanel'),
    ('104;TimeU'));

  // Default main toolbar
  numdefaultmainbar=22;
  defaultmainbar: array[1..numdefaultmainbar] of string = (
  ('75;Calendar'),
  ('94;PlanetInfo'),
  ('98;Obslist'),
  ('76;Search1'),
  ('102;quicksearch'),
  ('100;Divider'),
  ('45;SetupTime'),
  ('43;TimeDec'),
  ('84;TimeReset'),
  ('44;TimeInc'),
  ('103;TimeValPanel'),
  ('104;TimeU'),
  ('100;Divider'),
  ('6;zoomplus'),
  ('7;zoomminus'),
  ('92;rotate180'),
  ('69;ShowMark'),
  ('100;Divider'),
  ('48;TelescopeConnect'),
  ('110;TrackTelescope'),
  ('50;TelescopeSlew'),
  ('95;TelescopeAbortSlew'));
  // no object and left bar
  numdefaultobjectbar = 0;
  defaultobjectbar: array[1..1] of string = ('');
  numdefaultleftbar = 0;
  defaultleftbar: array[1..1] of string = ('');
  // Default right toolbar
  numdefaultrightbar=10;
  defaultrightbar: array[1..numdefaultrightbar] of string = (
  ('32;ToolBarFOV'),
  ('100;Divider'),
  ('71;EquatorialProjection'),
  ('72;AltAzProjection'),
  ('100;Divider'),
  ('38;toN'),
  ('39;toS'),
  ('37;toE'),
  ('40;toW'),
  ('41;toZenith'));

  // Standard main toolbar
  numstandardmainbar = 35;
  standardmainbar: array[1..numstandardmainbar] of string = (
    ('0;FileNew1'),
    ('1;FileOpen1'),
    ('2;FileSaveAs1'),
    ('3;Print1'),
    ('82;ViewNightVision'),
    ('100;Divider'),
    ('4;Cascade1'),
    ('14;TileVertical1'),
    ('100;Divider'),
    ('19;Undo'),
    ('20;Redo'),
    ('6;zoomplus'),
    ('7;zoomminus'),
    ('8;ZoomBar'),
    ('99;MagPanel'),
    ('102;quicksearch'),
    ('100;Divider'),
    ('76;Search1'),
    ('78;Position'),
    ('46;listobj'),
    ('98;Obslist'),
    ('75;Calendar'),
    ('94;PlanetInfo'),
    ('100;Divider'),
    ('43;TimeDec'),
    ('84;TimeReset'),
    ('44;TimeInc'),
    ('88;Animation'),
    ('103;TimeValPanel'),
    ('104;TimeU'),
    ('100;Divider'),
    ('48;TelescopeConnect'),
    ('51;TelescopeSync'),
    ('50;TelescopeSlew'),
    ('95;TelescopeAbortSlew'));

  // Standard object toolbar
  numstandardobjectbar = 32;
  standardobjectbar: array[1..numstandardobjectbar] of string = (
    ('56;ShowStars'),
    ('57;ShowNebulae'),
    ('59;ShowLines'),
    ('58;ShowPictures'),
    ('89;ShowVO'),
    ('52;ShowUobj'),
    ('81;DSSImage'),
    ('77;SetPictures'),
    ('86;BlinkImage'),
    ('62;ShowPlanets'),
    ('60;ShowAsteroids'),
    ('61;ShowComets'),
    ('63;ShowMilkyWay'),
    ('25;Grid'),
    ('24;GridEQ'),
    ('91;ShowCompass'),
    ('65;ShowConstellationLine'),
    ('66;ShowConstellationLimit'),
    ('67;ShowGalacticEquator'),
    ('68;ShowEcliptic'),
    ('69;ShowMark'),
    ('90;ScaleMode'),
    ('64;ShowLabels'),
    ('83;EditLabels'),
    ('70;ShowObjectbelowHorizon'),
    ('35;switchbackground'),
    ('100;Divider'),
    ('97;MouseMode'),
    ('79;SyncChart'),
    ('80;Track'),
    ('100;Divider'),
    ('34;switchstars'));

  // Standard left toolbar
  numstandardleftbar = 12;
  standardleftbar: array[1..numstandardleftbar] of string = (
    ('85;SetupObservatory'),
    ('45;SetupTime'),
    ('10;ConfigPopup'),
    ('71;EquatorialProjection'),
    ('72;AltAzProjection'),
    ('73;EclipticProjection'),
    ('74;GalacticProjection'),
    ('15;FlipX'),
    ('17;FlipY'),
    ('21;rot_plus'),
    ('22;rot_minus'),
    ('92;rotate180'));

  // Standard right toolbar
  numstandardrightbar = 8;
  standardrightbar: array[1..numstandardrightbar] of string = (
    ('32;ToolBarFOV'),
    ('100;Divider'),
    ('42;allSky'),
    ('38;toN'),
    ('39;toS'),
    ('37;toE'),
    ('40;toW'),
    ('41;toZenith'));




implementation

{ Tconf_catalog }

constructor Tconf_catalog.Create;
begin
  inherited Create;
  SampSelectIdent := False;
  SampSelectedNum := 0;
end;

destructor Tconf_catalog.Destroy;
begin
  SetLength(GCatLst, 0);
  SetLength(UserObjects, 0);
  inherited Destroy;
end;

procedure Tconf_catalog.Assign(Source: Tconf_catalog);
var
  i, j: integer;
begin
  GCatNum := Source.GCatNum;
  SetLength(GCatLst, GCatNum);
  for i := 0 to GCatNum - 1 do
    GCatLst[i] := Source.GCatLst[i];
  SetLength(UserObjects, length(Source.UserObjects));
  for i := 0 to length(UserObjects) - 1 do
    UserObjects[i] := Source.UserObjects[i];
  StarmagMax := Source.StarmagMax;
  NebMagMax := Source.NebMagMax;
  NebSizeMin := Source.NebSizeMin;
  SampSelectedTable := Source.SampSelectedTable;
  SampSelectedNum := Source.SampSelectedNum;
  SetLength(SampSelectedRec, SampSelectedNum + 1);
  if SampSelectedNum > 0 then
    for i := 0 to SampSelectedNum do
      SampSelectedRec[i] := Source.SampSelectedRec[i];
  for i := 1 to MaxStarCatalog do
  begin
    StarCatPath[i] := Source.StarCatPath[i];
    StarCatDef[i] := Source.StarCatDef[i];
    StarCatOn[i] := Source.StarCatOn[i];
    for j := 1 to 2 do
      StarCatField[i, j] := Source.StarCatField[i, j];
  end;
  for i := 1 to MaxVarStarCatalog do
  begin
    VarStarCatPath[i] := Source.VarStarCatPath[i];
    VarStarCatDef[i] := Source.VarStarCatDef[i];
    VarStarCatOn[i] := Source.VarStarCatOn[i];
    for j := 1 to 2 do
      VarStarCatField[i, j] := Source.VarStarCatField[i, j];
  end;
  for i := 1 to MaxDblStarCatalog do
  begin
    DblStarCatPath[i] := Source.DblStarCatPath[i];
    DblStarCatDef[i] := Source.DblStarCatDef[i];
    DblStarCatOn[i] := Source.DblStarCatOn[i];
    for j := 1 to 2 do
      DblStarCatField[i, j] := Source.DblStarCatField[i, j];
  end;
  for i := 1 to MaxNebCatalog do
  begin
    NebCatPath[i] := Source.NebCatPath[i];
    NebCatDef[i] := Source.NebCatDef[i];
    NebCatOn[i] := Source.NebCatOn[i];
    for j := 1 to 2 do
      NebCatField[i, j] := Source.NebCatField[i, j];
  end;
  for i := 1 to MaxLinCatalog do
    LinCatOn[i] := Source.LinCatOn[i];
  UseUSNOBrightStars := Source.UseUSNOBrightStars;
  UseGSVSIr := Source.UseGSVSIr;
  Name290 := Source.Name290;
  GaiaLevel := Source.GaiaLevel;
  LimitGaiaCount := Source.LimitGaiaCount;
  Quick := Source.Quick;
end;

{ Tconf_shared }

constructor Tconf_shared.Create;
begin
  inherited Create;
end;

destructor Tconf_shared.Destroy;
begin
  Setlength(ConstelName, 0);
  Setlength(ConstelPos, 0);
  Setlength(ConstB, 0);
  Setlength(ConstL, 0);
  Setlength(Milkywaydot, 0);
  Setlength(StarName, 0);
  Setlength(StarNameHR, 0);
  inherited Destroy;
end;

procedure Tconf_shared.Assign(Source: Tconf_shared);
var
  i, j: integer;
begin
  for i := 0 to MaxField do
    FieldNum[i] := Source.FieldNum[i];
  StarFilter := Source.StarFilter;
  NebFilter := Source.NebFilter;
  BigNebFilter := Source.BigNebFilter;
  BigNebLimit := Source.BigNebLimit;
  NoFilterMessier := Source.NoFilterMessier;
  NoFilterMagBright := Source.NoFilterMagBright;
  AutoStarFilter := Source.AutoStarFilter;
  AutoStarFilterMag := Source.AutoStarFilterMag;
  for i := 0 to MaxField do
    StarMagFilter[i] := Source.StarMagFilter[i];
  for i := 0 to MaxField do
    NebMagFilter[i] := Source.NebMagFilter[i];
  for i := 0 to MaxField do
    NebSizeFilter[i] := Source.NebSizeFilter[i];
  for i := 0 to MaxField do
    HourGridSpacing[i] := Source.HourGridSpacing[i];
  for i := 0 to MaxField do
    DegreeGridSpacing[i] := Source.DegreeGridSpacing[i];
  ShowCRose := Source.ShowCRose;
  SimplePointer := Source.SimplePointer;
  CRoseSz := Source.CRoseSz;
  AzNorth := Source.AzNorth;
  ListNeb := Source.ListNeb;
  ListStar := Source.ListStar;
  ListVar := Source.ListVar;
  ListDbl := Source.ListDbl;
  ListPla := Source.ListPla;
  ConstelNum := Source.ConstelNum;
  ConstLepoch := Source.ConstLepoch;
  Setlength(ConstelName, ConstelNum);
  Setlength(ConstelPos, ConstelNum);
  for i := 0 to ConstelNum - 1 do
  begin
    for j := 1 to 2 do
      ConstelName[i, j] := Source.ConstelName[i, j];
    ConstelPos[i].ra := Source.ConstelPos[i].ra;
    ConstelPos[i].de := Source.ConstelPos[i].de;
  end;
  ConstBnum := Source.ConstBnum;
  Setlength(ConstB, ConstBnum);
  for i := 0 to ConstBnum - 1 do
  begin
    ConstB[i].ra := Source.ConstB[i].ra;
    ConstB[i].de := Source.ConstB[i].de;
    ConstB[i].newconst := Source.ConstB[i].newconst;
  end;
  ConstLnum := Source.ConstLnum;
  Setlength(ConstL, ConstLnum);
  for i := 0 to ConstLnum - 1 do
  begin
    ConstL[i].ra1 := Source.ConstL[i].ra1;
    ConstL[i].de1 := Source.ConstL[i].de1;
    ConstL[i].ra2 := Source.ConstL[i].ra2;
    ConstL[i].de2 := Source.ConstL[i].de2;
  end;
  Milkywaydotradius := Source.Milkywaydotradius;
  MilkywaydotNum := Source.MilkywaydotNum;
  Setlength(Milkywaydot, MilkywaydotNum);
  for i := 0 to MilkywaydotNum - 1 do
  begin
    Milkywaydot[i].ra := Source.Milkywaydot[i].ra;
    Milkywaydot[i].de := Source.Milkywaydot[i].de;
    Milkywaydot[i].val := Source.Milkywaydot[i].val;
  end;
  StarNameNum := Source.StarNameNum;
  Setlength(StarName, StarNameNum);
  Setlength(StarNameHR, StarNameNum);
  for i := 0 to StarNameNum - 1 do
  begin
    StarName[i] := Source.StarName[i];
    StarNameHR[i] := Source.StarNameHR[i];
  end;
  ffove_tfl := Source.ffove_tfl;
  ffove_efl := Source.ffove_efl;
  ffove_efv := Source.ffove_efv;
  ffovc_tfl := Source.ffovc_tfl;
  ffovc_px := Source.ffovc_px;
  ffovc_py := Source.ffovc_py;
  ffovc_cx := Source.ffovc_cx;
  ffovc_cy := Source.ffovc_cy;
end;

{ Tconf_skychart }

constructor Tconf_skychart.Create;
begin
  inherited Create;
  horizonpicture := TBGRABitmap.Create;
  horizonpicturedark := TBGRABitmap.Create;
  horizonpicturevalid := False;
  horizondarken := -1;
  horizonlistname := '';
  tz := TCdCTimeZone.Create;
  ncircle := 10;
  CurJDUT := 0;
  SetLength(circle, ncircle + 1);
  SetLength(circleok, ncircle + 1);
  SetLength(circlelbl, ncircle + 1);
  nrectangle := 10;
  SetLength(rectangle, nrectangle + 1);
  SetLength(rectangleok, nrectangle + 1);
  SetLength(rectanglelbl, nrectangle + 1);
  PlotImageFirst := False;
  HeaderHeight := 0;
  FooterHeight := 0;
  CometMark := TStringList.Create;
  AsteroidMark := TStringList.Create;
  SPKlist:=TStringList.Create;
end;

destructor Tconf_skychart.Destroy;
begin
  CometMark.Free;
  AsteroidMark.Free;
  SPKlist.Free;
  SetLength(circle, 0);
  SetLength(circleok, 0);
  SetLength(circlelbl, 0);
  SetLength(rectangle, 0);
  SetLength(rectangleok, 0);
  SetLength(rectanglelbl, 0);
  SetLength(AsteroidLst, 0);
  SetLength(CometLst, 0);
  SetLength(AsteroidName, 0);
  SetLength(CometName, 0);
  SetLength(SPKBodies,0);
  SetLength(SPKNames,0);
  SetLength(BodiesLst,0);
  SetLength(BodiesName,0);
  tz.Free;
  horizonpicture.Free;
  horizonpicturedark.Free;
  inherited Destroy;
end;

procedure Tconf_skychart.Assign(Source: Tconf_skychart);
var
  i, j, k: integer;
begin
  tz.Assign(Source.tz);
  racentre := Source.racentre;
  decentre := Source.decentre;
  fov := Source.fov;
  theta := Source.theta;
  acentre := Source.acentre;
  hcentre := Source.hcentre;
  lcentre := Source.lcentre;
  bcentre := Source.bcentre;
  lecentre := Source.lecentre;
  becentre := Source.becentre;
  ecl := Source.ecl;
  for i := 1 to 3 do
    abv[i] := Source.abv[i];
  for i := 1 to 3 do
    ehn[i] := Source.ehn[i];
  for i := 1 to 3 do
    EarthB[i] := Source.EarthB[i];
  for i := 1 to 3 do
    for j := 1 to 3 do
    begin
      NutMAT[i, j] := Source.NutMAT[i, j];
      EqpMAT[i, j] := Source.EqpMAT[i, j];
      EqtMAT[i, j] := Source.EqtMAT[i, j];
    end;
  ProjEquatorCentered := Source.ProjEquatorCentered;
  EquinoxType := Source.EquinoxType;
  DefaultJDchart := Source.DefaultJDchart;
  EquinoxChart := Source.EquinoxChart;
  haicx := Source.haicx;
  haicy := Source.haicy;
  eqeq := Source.eqeq;
  nutl := Source.nutl;
  nuto := Source.nuto;
  sunl := Source.sunl;
  sunb := Source.sunb;
  sunurlname := Source.sunurlname;
  sunurl := Source.sunurl;
  sunurlsize := Source.sunurlsize;
  sunurlmargin := Source.sunurlmargin;
  sunrefreshtime := Source.sunrefreshtime;
  SunOnline := Source.SunOnline;
  DSLcolor := Source.DSLcolor;
  DSLforcecolor := Source.DSLforcecolor;
  DSLsurface := Source.DSLsurface;
  SurfaceBlure := Source.SurfaceBlure;
  SurfaceAlpha := Source.SurfaceAlpha;
  ab1 := Source.ab1;
  abe := Source.abe;
  abp := Source.abp;
  abm := Source.abm;
  asl := Source.asl;
  gr2e := Source.gr2e;
  raprev := Source.raprev;
  deprev := Source.deprev;
  Force_DT_UT := Source.Force_DT_UT;
  horizonopaque := Source.horizonopaque;
  ShowScale := Source.ShowScale;
  autorefresh := Source.autorefresh;
  TrackOn := Source.TrackOn;
  TargetOn := Source.TargetOn;
  Quick := Source.Quick;
  NP := Source.NP;
  SP := Source.SP;
  moved := Source.moved;
  projtype := Source.projtype;
  FlipX := Source.FlipX;
  FlipY := Source.FlipY;
  ProjPole := Source.ProjPole;
  for i:=0 to 3 do begin
    ProjOptions[i].EquinoxType := Source.ProjOptions[i].EquinoxType;
    ProjOptions[i].ApparentPos := Source.ProjOptions[i].ApparentPos;
    ProjOptions[i].PMon := Source.ProjOptions[i].PMon;
    ProjOptions[i].YPmon := Source.ProjOptions[i].YPmon;
    ProjOptions[i].EquinoxChart := Source.ProjOptions[i].EquinoxChart;
    ProjOptions[i].DefaultJDChart := Source.ProjOptions[i].DefaultJDChart;
    ProjOptions[i].CoordExpertMode := Source.ProjOptions[i].CoordExpertMode;
    ProjOptions[i].CoordType := Source.ProjOptions[i].CoordType;
  end;
  TrackType := Source.TrackType;
  TrackObj := Source.TrackObj;
  AstSymbol := Source.AstSymbol;
  ComSymbol := Source.ComSymbol;
  SimNb := Source.SimNb;
  SimD := Source.SimD;
  SimH := Source.SimH;
  SimM := Source.SimM;
  SimS := Source.SimS;
  SimComet := Source.SimComet;
  SimCometName := Source.SimCometName;
  SimAsteroid := Source.SimAsteroid;
  SimAsteroidName := Source.SimAsteroidName;
  SimBody := Source.SimBody;
  SimLabel := Source.SimLabel;
  SimLine := Source.SimLine;
  SimMark := Source.SimMark;
  SimDateLabel := Source.SimDateLabel;
  SimDateYear := Source.SimDateYear;
  SimDateMonth := Source.SimDateMonth;
  SimDateDay := Source.SimDateDay;
  SimDateHour := Source.SimDateHour;
  SimDateMinute := Source.SimDateMinute;
  SimDateSecond := Source.SimDateSecond;
  SimNameLabel := Source.SimNameLabel;
  SimMagLabel := Source.SimMagLabel;
  ShowLegend := Source.ShowLegend;
  ShowPlanet := Source.ShowPlanet;
  PlanetParalaxe := Source.PlanetParalaxe;
  ShowEarthShadow := Source.ShowEarthShadow;
  EarthShadowForceLine := Source.EarthShadowForceLine;
  ShowAsteroid := Source.ShowAsteroid;
  ShowSmallsat := Source.ShowSmallsat;
  ShowComet := Source.ShowComet;
  ShowArtSat := Source.ShowArtSat;
  NewArtSat := Source.NewArtSat;
  ObsLatitude := Source.ObsLatitude;
  ObsLongitude := Source.ObsLongitude;
  ObsAltitude := Source.ObsAltitude;
  ObsXP := Source.ObsXP;
  ObsYP := Source.ObsYP;
  ObsRH := Source.ObsRH;
  ObsTlr := Source.ObsTlr;
  ObsTZ := Source.ObsTZ;
  countrytz := Source.countrytz;
  ObsTemperature := Source.ObsTemperature;
  ObsPressure := Source.ObsPressure;
  ObsRefractionCor := Source.ObsRefractionCor;
  ObsRefA := Source.ObsRefA;
  ObsRefB := Source.ObsRefB;
  ObsHorizonDepression := Source.ObsHorizonDepression;
  ObsName := Source.ObsName;
  ObsCountry := Source.ObsCountry;
  // chartname:=Source.chartname ; do not replace the initial chart name
  ast_day := Source.ast_day;
  ast_daypos := Source.ast_daypos;
  com_day := Source.com_day;
  com_daypos := Source.com_daypos;
  CurYear := Source.CurYear;
  CurMonth := Source.CurMonth;
  CurDay := Source.CurDay;
  DrawPMyear := Source.DrawPMyear;
  ShowPluto := Source.ShowPluto;
  ShowConstl := Source.ShowConstl;
  ShowConstB := Source.ShowConstB;
  ShowEqGrid := Source.ShowEqGrid;
  ShowGrid := Source.ShowGrid;
  ShowGridNum := Source.ShowGridNum;
  ShowOnlyMeridian := Source.ShowOnlyMeridian;
  ShowAlwaysMeridian := Source.ShowAlwaysMeridian;
  UseSystemTime := Source.UseSystemTime;
  StyleGrid := Source.StyleGrid;
  StyleEqGrid := Source.StyleEqGrid;
  StyleConstL := Source.StyleConstL;
  StyleConstB := Source.StyleConstB;
  StyleEcliptic := Source.StyleEcliptic;
  StyleGalEq := Source.StyleGalEq;
  LineWidthGrid := Source.LineWidthGrid;
  LineWidthEqGrid := Source.LineWidthEqGrid;
  LineWidthConstL := Source.LineWidthConstL;
  LineWidthConstB := Source.LineWidthConstB;
  LineWidthEcliptic := Source.LineWidthEcliptic;
  LineWidthGalEq := Source.LineWidthGalEq;
  ShowEcliptic := Source.ShowEcliptic;
  ShowGalactic := Source.ShowGalactic;
  ShowEquator := Source.ShowEquator;
  ShowMilkyWay := Source.ShowMilkyWay;
  FillMilkyWay := Source.FillMilkyWay;
  LinemodeMilkyway := Source.LinemodeMilkyway;
  ShowHorizon := Source.ShowHorizon;
  ShowHorizonPicture := Source.ShowHorizonPicture;
  HorizonPictureLowQuality := Source.HorizonPictureLowQuality;
  HorizonPictureRotate := Source.HorizonPictureRotate;
  HorizonPictureElevation := Source.HorizonPictureElevation;
  FillHorizon := Source.FillHorizon;
  ShowHorizonDepression := Source.ShowHorizonDepression;
  ShowHorizon0 := Source.ShowHorizon0;
  PrePointRA := Source.PrePointRA;
  PrePointDEC := Source.PrePointDEC;
  PrePointTime := Source.PrePointTime;
  PrePointLength := Source.PrePointLength;
  DrawPrePoint := Source.DrawPrePoint;
  CurTime := Source.CurTime;
  DT_UT_val := Source.DT_UT_val;
  GRSlongitude := Source.GRSlongitude;
  GRSjd := Source.GRSjd;
  GRSdrift := Source.GRSdrift;
  TelescopeTurnsX := Source.TelescopeTurnsX;
  TelescopeTurnsY := Source.TelescopeTurnsY;
  TelescopeJD := Source.TelescopeJD;
  TelLimitDecMax := Source.TelLimitDecMax;
  TelLimitDecMin := Source.TelLimitDecMin;
  TelLimitHaE := Source.TelLimitHaE;
  TelLimitHaW := Source.TelLimitHaW;
  TelLimitDecMaxActive := Source.TelLimitDecMaxActive;
  TelLimitDecMinActive := Source.TelLimitDecMinActive;
  TelLimitHaEActive := Source.TelLimitHaEActive;
  TelLimitHaWActive := Source.TelLimitHaWActive;
  PMon := Source.PMon;
  DrawPMon := Source.DrawPMon;
  ApparentPos := Source.ApparentPos;
  CoordExpertMode := Source.CoordExpertMode;
  CoordType := Source.CoordType;
  ManualTelescopeType := Source.ManualTelescopeType;
  IndiServerHost := Source.IndiServerHost;
  IndiServerPort := Source.IndiServerPort;
  IndiDevice := Source.IndiDevice;
  IndiLoadConfig := Source.IndiLoadConfig;
  IndiLeft := Source.IndiLeft;
  IndiTop := Source.IndiTop;
  ShowCircle := Source.ShowCircle;
  ShowCrosshair := Source.ShowCrosshair;
  EyepieceMask := Source.EyepieceMask;
  IndiTelescope := Source.IndiTelescope;
  ASCOMTelescope := Source.ASCOMTelescope;
  ManualTelescope := Source.ManualTelescope;
  ShowImages := Source.ShowImages;
  ShowBackgroundImage := Source.ShowBackgroundImage;
  ShowImageList := Source.ShowImageList;
  ShowImageLabel := Source.ShowImageLabel;
  showstars := Source.showstars;
  shownebulae := Source.shownebulae;
  showline := Source.showline;
  showlabelall := Source.showlabelall;
  Editlabels := Source.Editlabels;
  OptimizeLabels := Source.OptimizeLabels;
  RotLabel := Source.RotLabel;
  BackgroundImage := Source.BackgroundImage;
  HorizonMax := Source.HorizonMax;
  HorizonMin := Source.HorizonMin;
  HorizonRise :=Source.HorizonRise;
  rap2000 := Source.rap2000;
  dep2000 := Source.dep2000;
  racentre2000 := Source.racentre2000;
  decentre2000 := Source.decentre2000;
  RefractionOffset := Source.RefractionOffset;
  ObsRAU := Source.ObsRAU;
  ObsZAU := Source.ObsZAU;
  ObsELONG := Source.ObsELONG;
  ObsPHI := Source.ObsPHI;
  ObsDAZ := Source.ObsDAZ;
  Diurab := Source.Diurab;
  WindowRatio := Source.WindowRatio;
  BxGlb := Source.BxGlb;
  ByGlb := Source.ByGlb;
  AxGlb := Source.AxGlb;
  AyGlb := Source.AyGlb;
  sintheta := Source.sintheta;
  costheta := Source.costheta;
  x2 := Source.x2;
  Xwrldmin := Source.Xwrldmin;
  Xwrldmax := Source.Xwrldmax;
  Ywrldmin := Source.Ywrldmin;
  Ywrldmax := Source.Ywrldmax;
  xmin := Source.xmin;
  xmax := Source.xmax;
  ymin := Source.ymin;
  ymax := Source.ymax;
  xshift := Source.xshift;
  yshift := Source.yshift;
  FieldNum := Source.FieldNum;
  winx := Source.winx;
  winy := Source.winy;
  wintop := Source.wintop;
  winleft := Source.winleft;
  LeftMargin := Source.LeftMargin;
  RightMargin := Source.RightMargin;
  TopMargin := Source.TopMargin;
  BottomMargin := Source.BottomMargin;
  HeaderHeight := Source.HeaderHeight;
  FooterHeight := Source.FooterHeight;
  Xcentre := Source.Xcentre;
  Ycentre := Source.Ycentre;
  ObsRoSinPhi := Source.ObsRoSinPhi;
  ObsRoCosPhi := Source.ObsRoCosPhi;
  StarmagMax := Source.StarmagMax;
  NebMagMax := Source.NebMagMax;
  FindStarPM := Source.FindStarPM;
  FindPMfullmotion := Source.FindPMfullmotion;
  FindPMra := Source.FindPMra;
  FindPMde := Source.FindPMde;
  FindBV := Source.FindBV;
  FindMag := Source.FindMag;
  FindPMEpoch := Source.FindPMEpoch;
  FindPMpx := Source.FindPMpx;
  FindPMrv := Source.FindPMrv;
  FindDist := Source.FindDist;
  FindPM := Source.FindPM;
  FindRA := Source.FindRA;
  FindDec := Source.FindDec;
  FindRA2000 := Source.FindRA2000;
  FindDec2000 := Source.FindDec2000;
  FindSize := Source.FindSize;
  FindType := Source.FindType;
  FindIpla := Source.FindIpla;
  FindSimjd := Source.FindSimjd;
  FindPX := Source.FindPX;
  AstmagMax := Source.AstmagMax;
  AstMagDiff := Source.AstMagDiff;
  AstNEO := Source.AstNEO;
  CommagMax := Source.CommagMax;
  Commagdiff := Source.Commagdiff;
  TimeZone := Source.TimeZone;
  DT_UT := Source.DT_UT;
  DT_UTerr := Source.DT_UTerr;
  CurST := Source.CurST;
  CurJDTT := Source.CurJDTT;
  CurJDUT := Source.CurJDUT;
  LastJD := Source.LastJD;
  jd0 := Source.jd0;
  JDChart := Source.JDChart;
  YPmon := Source.YPmon;
  LastJDChart := Source.LastJDChart;
  FindJD := Source.FindJD;
  CurSunH := Source.CurSunH;
  CurMoonH := Source.CurMoonH;
  CurMoonIllum := Source.CurMoonIllum;
  ScopeRa := Source.ScopeRa;
  ScopeDec := Source.ScopeDec;
  Scope2Ra := Source.Scope2Ra;
  Scope2Dec := Source.Scope2Dec;
  TrackEpoch := Source.TrackEpoch;
  TrackElemEpoch := Source.TrackElemEpoch;
  TrackRA := Source.TrackRA;
  TrackDec := Source.TrackDec;
  StarFilter := Source.StarFilter;
  NebFilter := Source.NebFilter;
  FindOK := Source.FindOK;
  WhiteBg := Source.WhiteBg;
  MagLabel := Source.MagLabel;
  DistLabel := Source.DistLabel;
  NameLabel := Source.NameLabel;
  ConstFullLabel := Source.ConstFullLabel;
  DrawAllStarLabel := Source.DrawAllStarLabel;
  MovedLabelLine := Source.MovedLabelLine;
  MagNoDecimal := Source.MagNoDecimal;
  ConstLatinLabel := Source.ConstLatinLabel;
  ScopeMark := Source.ScopeMark;
  Scope2Mark := Source.Scope2Mark;
  ScopeLock := Source.ScopeLock;
  ChartLock := Source.ChartLock;
  EquinoxName := Source.EquinoxName;
  TrackName := Source.TrackName;
  TrackId := Source.TrackId;
  FindName := Source.FindName;
  FindId := Source.FindId;
  FindDesc := Source.FindDesc;
  FindDesc2 := Source.FindDesc2;
  FindDesc2000 := Source.FindDesc2000;
  FindNote := Source.FindNote;
  FindCat := Source.FindCat;
  FindCatname := Source.FindCatname;
  AsteroidNb := Source.AsteroidNb;
  CometNb := Source.CometNb;
  BodiesNb := Source.BodiesNb;
  AsteroidLstSize := Source.AsteroidLstSize;
  CometLstSize := Source.CometLstSize;
  NumCircle := Source.NumCircle;
  nummodlabels := Source.nummodlabels;
  posmodlabels := Source.posmodlabels;
  numcustomlabels := Source.numcustomlabels;
  poscustomlabels := Source.poscustomlabels;
  horizonlist := Source.horizonlist;
  ephvalid := Source.ephvalid;
  ShowPlanetValid := Source.ShowPlanetValid;
  ShowCometValid := Source.ShowCometValid;
  ShowAsteroidValid := Source.ShowAsteroidValid;
  ShowEarthShadowValid := Source.ShowEarthShadowValid;
  ShowEclipticValid := Source.ShowEclipticValid;
  PlotImageFirst := Source.PlotImageFirst;
  SmallSatActive := Source.SmallSatActive;
  SpiceActive := Source.SpiceActive;
  CalcephActive := Source.CalcephActive;
  BGalpha := Source.BGalpha;
  BGitt := Source.BGitt;
  BGmin_sigma := Source.BGmin_sigma;
  BGmax_sigma := Source.BGmax_sigma;
  NEBmin_sigma := Source.NEBmin_sigma;
  NEBmax_sigma := Source.NEBmax_sigma;
  for i := 0 to 10 do
    projname[i] := Source.projname[i];
  for i := 1 to numlabtype do
  begin
    ShowLabel[i] := Source.ShowLabel[i];
    LabelMagDiff[i] := Source.LabelMagDiff[i];
    LabelOrient[i] := Source.LabelOrient[i];
  end;
  ObslistAlLabels := Source.ObslistAlLabels;
  ncircle := Source.ncircle;
  SetLength(circle, ncircle + 1);
  SetLength(circleok, ncircle + 1);
  SetLength(circlelbl, ncircle + 1);
  for i := 1 to ncircle do
  begin
    circle[i, 1] := Source.circle[i, 1];
    circle[i, 2] := Source.circle[i, 2];
    circle[i, 3] := Source.circle[i, 3];
    circleok[i] := Source.circleok[i];
    circlelbl[i] := Source.circlelbl[i];
  end;
  nrectangle := Source.nrectangle;
  SetLength(rectangle, nrectangle + 1);
  SetLength(rectangleok, nrectangle + 1);
  SetLength(rectanglelbl, nrectangle + 1);
  for i := 1 to nrectangle do
  begin
    rectangle[i, 1] := Source.rectangle[i, 1];
    rectangle[i, 2] := Source.rectangle[i, 2];
    rectangle[i, 3] := Source.rectangle[i, 3];
    rectangle[i, 4] := Source.rectangle[i, 4];
    rectangleok[i] := Source.rectangleok[i];
    rectanglelbl[i] := Source.rectanglelbl[i];
  end;
  CircleLabel := Source.CircleLabel;
  CalGraphHeight := Source.CalGraphHeight;
  PlanisphereDate := Source.PlanisphereDate;
  PlanisphereTime := Source.PlanisphereTime;
  RectangleLabel := Source.RectangleLabel;
  CometMark.Clear;
  for i := 0 to Source.CometMark.Count - 1 do
    CometMark.Add(Source.CometMark.Strings[i]);
  AsteroidMark.Clear;
  for i := 0 to Source.AsteroidMark.Count - 1 do
    AsteroidMark.Add(Source.AsteroidMark.Strings[i]);
  marknumlabel := Source.marknumlabel;
  SPKlist.Clear;
  for i := 0 to Source.SPKlist.Count - 1 do
    SPKlist.Add(Source.SPKlist.Strings[i]);
  SetLength(SPKBodies,length(Source.SPKBodies));
  for i:=0 to length(Source.SPKBodies)-1 do
     SPKBodies[i]:=Source.SPKBodies[i];
  SetLength(SPKNames,length(Source.SPKNames));
  for i:=0 to length(Source.SPKNames)-1 do
     SPKNames[i]:=Source.SPKNames[i];
  SetLength(BodiesLst,length(Source.BodiesLst));
  for i:=0 to length(Source.BodiesLst)-1 do
     BodiesLst[i]:=Source.BodiesLst[i];
  SetLength(BodiesName,length(Source.BodiesName));
  for i:=0 to length(Source.BodiesName)-1 do
     BodiesName[i]:=Source.BodiesName[i];
  for i := 0 to Source.NumCircle do
    for j := 1 to 2 do
      CircleLst[i, j] := Source.CircleLst[i, j];
  for i := 1 to Source.nummodlabels do
  begin
    modlabels[i].id := Source.modlabels[i].id;
    modlabels[i].dx := Source.modlabels[i].dx;
    modlabels[i].dy := Source.modlabels[i].dy;
    modlabels[i].orientation := Source.modlabels[i].orientation;
    modlabels[i].ra := Source.modlabels[i].ra;
    modlabels[i].Dec := Source.modlabels[i].Dec;
    modlabels[i].labelnum := Source.modlabels[i].labelnum;
    modlabels[i].fontnum := Source.modlabels[i].fontnum;
    modlabels[i].txt := Source.modlabels[i].txt;
    modlabels[i].useradec := Source.modlabels[i].useradec;
    modlabels[i].hiden := Source.modlabels[i].hiden;
  end;
  for i := 1 to Source.numcustomlabels do
  begin
    customlabels[i].ra := Source.customlabels[i].ra;
    customlabels[i].Dec := Source.customlabels[i].Dec;
    customlabels[i].labelnum := Source.customlabels[i].labelnum;
    customlabels[i].txt := Source.customlabels[i].txt;
    customlabels[i].align := Source.customlabels[i].align;
  end;
  for i := 1 to NumSimObject do
    SimObject[i] := Source.SimObject[i];
  for i := 0 to Source.SimNb - 1 do
    for j := 1 to MaxPla do
      for k := 1 to 7 do
        PlanetLst[i, j, k] := Source.PlanetLst[i, j, k];
  if SimObject[12] then
  begin
    SetLength(AsteroidLst, Source.SimNb);
    for i := 0 to Source.SimNb - 1 do
      for j := 1 to Source.AsteroidNb do
        for k := 1 to 5 do
          AsteroidLst[i, j, k] := Source.AsteroidLst[i, j, k];
    SetLength(AsteroidName, Source.SimNb);
    for i := 0 to Source.SimNb - 1 do
      for j := 1 to Source.AsteroidNb do
        for k := 1 to 2 do
          AsteroidName[i, j, k] := Source.AsteroidName[i, j, k];
  end
  else
  begin
    Setlength(AsteroidLst, 1);
    for j := 1 to Source.AsteroidNb do
      for k := 1 to 5 do
        AsteroidLst[0, j, k] := Source.AsteroidLst[0, j, k];
    SetLength(AsteroidName, 1);
    for j := 1 to Source.AsteroidNb do
      for k := 1 to 2 do
        AsteroidName[0, j, k] := Source.AsteroidName[0, j, k];
  end;
  if SimObject[13] then
  begin
    SetLength(CometLst, Source.SimNb);
    for i := 0 to Source.SimNb - 1 do
      for j := 1 to Source.CometNb do
        for k := 1 to 8 do
          CometLst[i, j, k] := Source.CometLst[i, j, k];
    SetLength(CometName, Source.SimNb);
    for i := 0 to Source.SimNb - 1 do
      for j := 1 to Source.CometNb do
        for k := 1 to 2 do
          CometName[i, j, k] := Source.CometName[i, j, k];
  end
  else
  begin
    SetLength(CometLst, 1);
    for j := 1 to Source.CometNb do
      for k := 1 to 8 do
        CometLst[0, j, k] := Source.CometLst[0, j, k];
    SetLength(CometName, 1);
    for j := 1 to Source.CometNb do
      for k := 1 to 2 do
        CometName[0, j, k] := Source.CometName[0, j, k];
  end;
  if SimObject[14] then
  begin
    SetLength(BodiesLst, Source.SimNb);
    for i := 0 to Source.SimNb - 1 do
      for j := 1 to Source.BodiesNb do
        for k := 1 to 5 do
          BodiesLst[i, j, k] := Source.BodiesLst[i, j, k];
    SetLength(BodiesName, Source.SimNb);
    for i := 0 to Source.SimNb - 1 do
      for j := 1 to Source.BodiesNb do
        for k := 1 to 2 do
          BodiesName[i, j, k] := Source.BodiesName[i, j, k];
  end
  else
  begin
    Setlength(BodiesLst, 1);
    for j := 1 to Source.BodiesNb do
      for k := 1 to 5 do
        BodiesLst[0, j, k] := Source.BodiesLst[0, j, k];
    SetLength(BodiesName, 1);
    for j := 1 to Source.BodiesNb do
      for k := 1 to 2 do
        BodiesName[0, j, k] := Source.BodiesName[0, j, k];
  end;
  MaxArchiveImg := Source.MaxArchiveImg;
  for i := 1 to MaxArchiveDir do
    ArchiveDir[i] := Source.ArchiveDir[i];
  for i := 1 to MaxArchiveDir do
    ArchiveDirActive[i] := Source.ArchiveDirActive[i];
  HorizonFile := Source.HorizonFile;
  HorizonPictureFile := Source.HorizonPictureFile;
  DarkenHorizonPicture := Source.DarkenHorizonPicture;
  for i := 0 to 360 do
    horizonlist[i] := Source.horizonlist[i];
  horizonpicture.Assign(Source.horizonpicture);
  horizonpicturedark.Assign(Source.horizonpicturedark);
  horizonpicturevalid := Source.horizonpicturevalid;
  horizondarken := Source.horizondarken;
  horizonpicturename := Source.horizonpicturename;
  horizonlistname := Source.horizonlistname;
end;

{ Tconf_plot }

constructor Tconf_plot.Create;
begin
  inherited Create;
end;

destructor Tconf_plot.Destroy;
begin
  inherited Destroy;
end;

procedure Tconf_plot.Assign(Source: Tconf_plot);
var
  i: integer;
begin
  for i := 0 to Maxcolor do
    color[i] := Source.color[i];
  for i := 0 to 7 do
    skycolor[i] := Source.skycolor[i];
  backgroundcolor := Source.backgroundcolor;
  bgcolor := Source.bgcolor;
  stardyn := Source.stardyn;
  starsize := Source.starsize;
  prtres := Source.prtres;
  starplot := Source.starplot;
  nebplot := Source.nebplot;
  plaplot := Source.plaplot;
  Nebgray := Source.Nebgray;
  NebBright := Source.NebBright;
  MinDsoSize := Source.MinDsoSize;
  starshapesize := Source.starshapesize;
  starshapew := Source.starshapew;
  Invisible := Source.Invisible;
  AutoSkycolor := Source.AutoSkycolor;
  autoskycolorValid := Source.autoskycolorValid;
  TransparentPlanet := Source.TransparentPlanet;
  UseBMP := Source.UseBMP;
  AntiAlias := Source.AntiAlias;
  for i := 1 to numfont do
  begin
    FontName[i] := Source.FontName[i];
    FontSize[i] := Source.FontSize[i];
    FontBold[i] := Source.FontBold[i];
    FontItalic[i] := Source.FontItalic[i];
  end;
  for i := 1 to numlabtype do
  begin
    LabelColor[i] := Source.LabelColor[i];
    LabelSize[i] := Source.LabelSize[i];
  end;

  outradius := Source.outradius;
  contrast := Source.contrast;
  saturation := Source.saturation;
  xmin := Source.xmin;
  xmax := Source.xmax;
  ymin := Source.ymin;
  ymax := Source.ymax;
  red_move := Source.red_move;
  partsize := Source.partsize;
  magsize := Source.magsize;
  DSOColorFillAst := Source.DSOColorFillAst;
  DSOColorFillOCl := Source.DSOColorFillOCl;
  DSOColorFillGCl := Source.DSOColorFillGCl;
  DSOColorFillPNe := Source.DSOColorFillPNe;
  DSOColorFillDN := Source.DSOColorFillDN;
  DSOColorFillEN := Source.DSOColorFillEN;
  DSOColorFillRN := Source.DSOColorFillRN;
  DSOColorFillSN := Source.DSOColorFillSN;
  DSOColorFillGxy := Source.DSOColorFillGxy;
  DSOColorFillGxyCl := Source.DSOColorFillGxyCl;
  DSOColorFillQ := Source.DSOColorFillQ;
  DSOColorFillGL := Source.DSOColorFillGL;
  DSOColorFillNE := Source.DSOColorFillNE;
end;

{ Tconf_chart }

constructor Tconf_chart.Create;
begin
  inherited Create;
end;

destructor Tconf_chart.Destroy;
begin
  inherited Destroy;
end;

procedure Tconf_chart.Assign(Source: Tconf_chart);
begin
  onprinter := Source.onprinter;
  Width := Source.Width;
  Height := Source.Height;
  drawpen := Source.drawpen;
  drawsize := Source.drawsize;
  cliparea := Source.cliparea;
  fontscale := Source.fontscale;
  hw := Source.hw;
  hh := Source.hh;
  min_ma := Source.min_ma;
  max_catalog_mag := Source.max_catalog_mag;
end;

{ Tconf_main }

constructor TObsDetail.Create;
begin
  inherited Create;
end;

destructor TObsDetail.Destroy;
begin
  inherited Destroy;
end;

constructor Tconf_main.Create;
begin
  inherited Create;
  CometUrlList := TStringList.Create;
  AsteroidUrlList := TStringList.Create;
  TleUrlList := TStringList.Create;
  ObsNameList := TStringList.Create;
  ObsNameList.Sorted := True;
end;

destructor Tconf_main.Destroy;
begin
  try
    FreeAndNil(CometUrlList);
    FreeAndNil(AsteroidUrlList);
    FreeAndNil(TleUrlList);
    FreeAndNil(ObsNameList);
    inherited Destroy;
  except
  end;
end;

procedure Tconf_main.Assign(Source: Tconf_main);
var
  i: integer;
begin
  InitObsList := Source.InitObsList;
  ObsListLimitType := Source.ObsListLimitType;
  ObsListMeridianSide := Source.ObsListMeridianSide;
  ObslistAirmass := Source.ObslistAirmass;
  ObslistAirmassLimit1 := Source.ObslistAirmassLimit1;
  ObslistAirmassLimit2 := Source.ObslistAirmassLimit2;
  ObslistHourAngle := Source.ObslistHourAngle;
  ObslistHourAngleLimit1 := Source.ObslistHourAngleLimit1;
  ObslistHourAngleLimit2 := Source.ObslistHourAngleLimit2;
  SampAutoconnect := Source.SampAutoconnect;
  SampKeepTables := Source.SampKeepTables;
  SampKeepImages := Source.SampKeepImages;
  SampConfirmCoord := Source.SampConfirmCoord;
  SampConfirmImage := Source.SampConfirmImage;
  SampConfirmTable := Source.SampConfirmTable;
  SampSubscribeCoord := Source.SampSubscribeCoord;
  SampSubscribeImage := Source.SampSubscribeImage;
  SampSubscribeTable := Source.SampSubscribeTable;
  SimpleMove := Source.SimpleMove;
  SimpleDetail := Source.SimpleDetail;
  KioskPass := Source.KioskPass;
  KioskMode := Source.KioskMode;
  KioskDebug := Source.KioskDebug;
  CenterAtNoon := Source.CenterAtNoon;
  ClockColor := Source.ClockColor;
  SesameUrlNum := Source.SesameUrlNum;
  SesameCatNum := Source.SesameCatNum;
  prtname := Source.prtname;
  language := Source.language;
  Constellationpath := Source.Constellationpath;
  ConstLfile := Source.ConstLfile;
  ConstBfile := Source.ConstBfile;
  EarthMapFile := Source.EarthMapFile;
  Planetdir := Source.Planetdir;
  db := Source.db;
  ImagePath := Source.ImagePath;
  persdir := Source.persdir;
  Paper := Source.Paper;
  PrinterResolution := Source.PrinterResolution;
  PrintMethod := Source.PrintMethod;
  PrintColor := Source.PrintColor;
  PrintBmpWidth := Source.PrintBmpWidth;
  PrintBmpHeight := Source.PrintBmpHeight;
  btnsize := Source.btnsize;
  btncaption := Source.btncaption;
  ScreenScaling := Source.ScreenScaling;
  configpage := Source.configpage;
  configpage_i := Source.configpage_i;
  configpage_j := Source.configpage_j;
  autorefreshdelay := Source.autorefreshdelay;
  MaxChildID := Source.MaxChildID;
  PrtLeftMargin := Source.PrtLeftMargin;
  PrtRightMargin := Source.PrtRightMargin;
  PrtTopMargin := Source.PrtTopMargin;
  PrtBottomMargin := Source.PrtBottomMargin;
  savetop := Source.savetop;
  saveleft := Source.saveleft;
  saveheight := Source.saveheight;
  savewidth := Source.savewidth;
  VOurl := Source.VOurl;
  VOmaxrecord := Source.VOmaxrecord;
  VOforceactive := Source.VOforceactive;
  UOforceactive := Source.UOforceactive;
  AnimDelay := Source.AnimDelay;
  AnimOpt := Source.AnimOpt;
  Animffmpeg := Source.Animffmpeg;
  AnimFps := Source.AnimFps;
  AnimSx := Source.AnimSx;
  AnimSy := Source.AnimSy;
  AnimSize := Source.AnimSize;
  AnimRecPrefix := Source.AnimRecPrefix;
  AnimRecExt := Source.AnimRecExt;
  AnimRecDir := Source.AnimRecDir;
  AnimRec := Source.AnimRec;
  PrintLandscape := Source.PrintLandscape;
  ShowChartInfo := Source.ShowChartInfo;
  ShowTitlePos := Source.ShowTitlePos;
  SyncChart := Source.SyncChart;
  maximized := Source.maximized;
  updall := Source.updall;
  AutostartServer := Source.AutostartServer;
  ServerCoordSys := source.ServerCoordSys;
  keepalive := Source.keepalive;
  NewBackgroundImage := Source.NewBackgroundImage;
  TextOnlyDetail := Source.TextOnlyDetail;
  ServerIPaddr := Source.ServerIPaddr;
  ServerIPport := Source.ServerIPport;
  PrintCmd1 := Source.PrintCmd1;
  PrintCmd2 := Source.PrintCmd2;
  PrintTmpPath := Source.PrintTmpPath;
  PrintHeader := Source.PrintHeader;
  PrintFooter := Source.PrintFooter;
  PrintDesc := Source.PrintDesc;
  PrintCopies := Source.PrintCopies;
  ThemeName := Source.ThemeName;
  NightColor := Source.NightColor;
  IndiPanelCmd := Source.IndiPanelCmd;
  InternalIndiPanel := Source.InternalIndiPanel;
  ProxyHost := Source.ProxyHost;
  ProxyPort := Source.ProxyPort;
  ProxyUser := Source.ProxyUser;
  ProxyPass := Source.ProxyPass;
  AnonPass := Source.AnonPass;
  FtpPassive := Source.FtpPassive;
  HttpProxy := Source.HttpProxy;
  SocksProxy := Source.SocksProxy;
  SocksType := Source.SocksType;
  ConfirmDownload := Source.ConfirmDownload;
  starshape_file := Source.starshape_file;
  tlelst := Source.tlelst;
  HorizonEmail:=Source.HorizonEmail;
  HorizonNumDay:=Source.HorizonNumDay;
  CometUrlList.Clear;
  for i := 0 to Source.CometUrlList.Count - 1 do
    CometUrlList.Add(Source.CometUrlList.Strings[i]);
  AsteroidUrlList.Clear;
  for i := 0 to Source.AsteroidUrlList.Count - 1 do
    AsteroidUrlList.Add(Source.AsteroidUrlList.Strings[i]);
  TleUrlList.Clear;
  for i := 0 to Source.TleUrlList.Count - 1 do
    TleUrlList.Add(Source.TleUrlList.Strings[i]);
  ObsNameList.Clear;
  for i := 0 to Source.ObsNameList.Count - 1 do
    ObsNameList.AddObject(Source.ObsNameList.Strings[i], Source.ObsNameList.Objects[i]);
end;

{ Tconf_dss }

constructor Tconf_dss.Create;
begin
  inherited Create;
end;

destructor Tconf_dss.Destroy;
begin
  inherited Destroy;
end;

procedure Tconf_dss.Assign(Source: Tconf_dss);
var
  i, j: integer;
begin
  dssdir := Source.dssdir;
  dssdrive := Source.dssdrive;
  dssfile := Source.dssfile;
  dss102 := Source.dss102;
  dssnorth := Source.dssnorth;
  dsssouth := Source.dsssouth;
  dsssampling := Source.dsssampling;
  dssplateprompt := Source.dssplateprompt;
  dssmaxsize := Source.dssmaxsize;
  OnlineDSS := Source.OnlineDSS;
  OnlineDSSid := Source.OnlineDSSid;
  dssarchive := Source.dssarchive;
  dssarchiveprompt := Source.dssarchiveprompt;
  dssarchivedir := Source.dssarchivedir;
  for i := 1 to MaxDSSurl do
    for j := 0 to 1 do
      DSSurl[i, j] := Source.DSSurl[i, j];
end;


end.
