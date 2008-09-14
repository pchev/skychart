unit u_constant;
{
Copyright (C) 2002 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
 Type and constant declaration
}
{$mode objfpc}{$H+}
interface

uses gcatunit, {libcatalog,} // libcatalog statically linked
     cu_tz, dynlibs,
     Classes, Controls, FPCanvas, Graphics;

const MaxColor = 35;
      crlf = chr(13)+chr(10);

type Starcolarray =  Array [0..Maxcolor] of Tcolor; // 0:sky, 1-10:object, 11:not sky, 12:AzGrid, 13:EqGrid, 14:orbit, 15:misc, 16:constl, 17:constb, 18:eyepiece, 19:horizon, 20:asteroid  23-35: dso
     TSkycolor = array[0..7]of Tcolor;

const cdcversion = 'Version 3 beta 0.1.5 svn';
      cdcver     = '3.0.1.5';
      cdccpy = 'Copyright (C) 2002-2006 Patrick Chevalley';
      cdcauthors = 'Patrick Chevalley, pch@freesurf.ch'+crlf+
                   'Peter Dean,' ;
      MaxSim = 100 ;
      MaxComet = 200;
      MaxAsteroid = 1000;
      MaxPla = 32;
      MaxQuickSearch = 15;
      MaxWindow = 10;  // maximum number of chart window
      maxlabels = 1000; //maximum number of label to a chart
      maxmodlabels = 1000; //maximum number of modified labels before older one are replaced
      MaxCircle = 100;
      MaxDSSurl = 20;
      jd2000 =2451545.0 ;
      jd1950 =2433282.4235;
      jd1900 =2415020.3135;
      km_au = 149597870.691 ;
      clight = 299792.458 ;
      tlight = km_au/clight/3600/24;
      footpermeter = 0.3048;
      kmperdegree=111.1111;
      secday=3600*24;
      eps2000 = 23.439291111;
      deg2rad = pi/180;
      rad2deg = 180/pi;
      pi2 = 2*pi;
      pi4 = 4*pi;
      pid2 = pi/2;
      minarc = deg2rad/60;
      secarc = deg2rad/3600;
      musec  = deg2rad/3600/1000000; // 1 microarcsec for rounding test
      abek = secarc*20.49552;  // aberration constant
      FovMin = 2*secarc;  // 2"
      FovMax = pi2;
      DefaultPrtRes = 300;
      encryptpwd = 'zh6Tiq4h;90uA3.ert';
      //                          0         1                                       5                                                 10                                                15                                                20                            23        24        25        26        27        28        29        30        31        32        33        34        35
      //                          sky       -0.3      -0.1      0.2       0.5       0.8       1.3       1.3+      galaxy    cluster   neb       -white-   az grid   eq grid   orbit     const     boundary  eyepiece  misc      horizon   asteroid  comet     milkyway  ColorAst  ColorOCl  ColorGCl  ColorPNe  ColorDN   ColorEN   ColorRN   ColorSN   ColorGxy  ColorGxyCl ColorQ   ColorGL   ColorNE
      DfColor : Starcolarray =   (clBlack,  $00EF9883,$00EBDF74,$00ffffff,$00CAF9F9,$008AF2EB,$008EBBF2,$006271FB,$000000ff,$00ffff00,$0000ff00,clWhite,  $00404040,$00404040,$00008080,clGray,   $00800000,$00800080,clRed,    $00202030,clYellow, $00FFC000,$00202020,$0080FFFF,$0080FFFF,$00FFFF80,$0080FF00,$00C0C0C0,$000000FF,$00FF8000,$00000000,$000000FF,$000000FF,$008080FF,$00FF0080,$00FFFFFF);
      DfGray : Starcolarray =    (clBlack,  clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clWhite,  clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver, clSilver);
      DfBWColor : Starcolarray = (clBlack,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clBlack,  clWhite,  clWhite,  clBlack,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite,  clWhite);
      DfRedColor : Starcolarray =(clBlack,  $00ff00ff,$00a060ff,$008080ff,$0060a0ff,$004080ff,$006060ff,$000000ff,$000000ff,$00ff00ff,$008080ff,$000000ff,$00000040,$00000040,$00000080,$00000040,$00000040,$000000A0,$00000080,$00000040,clYellow, $000000A0,$00000020,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0);
      DfWBColor : Starcolarray = (clWhite,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clWhite,  clBlack,  clBlack,  clWhite,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack,  clBlack);
      dfskycolor : Tskycolor =   ($00200000,  $00f03c3c,$00c83232,$00a02828,$00780000,$00640010,$003c0010,$00000000);
      nv_light  = $004040ff;
      nv_middle = $003030c0;
      nv_dim    = $00000060;
      nv_dark   = $00000040;
      nv_black  = $00000000;


//  End of deep-sky objects colour

      greek : array[1..2,1..24]of string=(('Alpha','Beta','Gamma','Delta','Epsilon','Zeta','Eta','Theta','Iota','Kappa','Lambda','Mu','Nu','Xi','Omicron','Pi','Rho','Sigma','Tau','Upsilon','Phi','Chi','Psi','Omega'),
              ('alp','bet','gam','del','eps','zet','eta','the','iot','kap','lam','mu','nu','xi','omi','pi','rho','sig','tau','ups','phi','chi','psi','ome'));
      greeksymbol : array[1..2,1..24]of string=(('alp','bet','gam','del','eps','zet','eta','the','iot','kap','lam','mu','nu','xi','omi','pi','rho','sig','tau','ups','phi','chi','psi','ome'),
                  ('a','b','g','d','e','z','h','q','i','k','l','m','n','x','o','p','r','s','t','u','f','c','y','w'));
      greekUTF8 : array[1..24] of word =($CEB1,$CEB2,$CEB3,$CEB4,$CEB5,$CEB6,$CEB7,$CEB8,$CEB9,$CEBA,$CEBB,$CEBC,$CEBD,$CEBE,$CEBF,$CF80,$CF81,$CF83,$CF84,$CF85,$CF86,$CF87,$CF88,$CF89);
      pla : array[1..32] of string[10] = ('Mercury ','Venus   ','*       ','Mars    ','Jupiter ',
      'Saturn  ','Uranus  ','Neptune ','Pluto   ','Sun     ','Moon    ',
      'Io      ','Europa  ','Ganymede','Callisto','Mimas   ','Encelade','Tethys  ','Dione   ',
      'Rhea    ','Titan   ','Hyperion','Iapetus ','Miranda ','Ariel   ','Umbriel ','Titania ',
      'Oberon  ','Phobos  ','Deimos  ','Sat.Ring','E.Shadow');
      // the same but always with English name
      epla : array[1..32] of string[8] = ('Mercury ','Venus   ','*       ','Mars    ','Jupiter ',
      'Saturn  ','Uranus  ','Neptune ','Pluto   ','Sun     ','Moon    ',
      'Io      ','Europa  ','Ganymede','Callisto','Mimas   ','Encelade','Tethys  ','Dione   ',
      'Rhea    ','Titan   ','Hyperion','Iapetus ','Miranda ','Ariel   ','Umbriel ','Titania ',
      'Oberon  ','Phobos  ','Deimos  ','Sat.Ring','E.Shadow');
      planetcolor: array[1..11]of double=(0.7,0,0,1.5,0.7,0.7,-1.5,-1.5,0,0.7,0);
      V0mar : array [1..2] of double = (11.80,12.89);
      V0jup : array [1..4] of double = (-1.68,-1.41,-2.09,-1.05);
      V0sat : array [1..8] of double = (3.30,2.10,0.60,0.80,0.10,-1.28,4.63,1.50);
      V0ura : array [1..5] of double = (3.60,1.45,2.10,1.02,1.23);
      D0mar : array [1..2] of double = (11,6);
      D0jup : array [1..4] of double = (1821,1565,2634,2403);
      D0sat : array [1..8] of double = (199,249,530,560,764,2575,143,718);
      D0ura : array [1..5] of double = (236,581,585,789,761);
      blank15='               ';
      blank=' ';
      tab=#09;
      deftxt = '?';
      f0='0';
      f1='0.0';
      f1s='0.#';
      f2='0.00';
      f5='0.00000';
      f6='0.000000';
      dateiso='yyyy"-"mm"-"dd"T"hh":"nn":"ss.zzz';
      labspacing=10;
      numlabtype=8;
      numfont=7;
      NumSimObject = 13;
      MaxField = 10;
      Equat = 0;
      Altaz = 1;
      Gal = 2;
      Ecl = 3;
      BaseStar = 1000;
      MaxStarCatalog = 14;
      bsc     = 1001;
      sky2000 = 1002;
      tyc     = 1003;
      tyc2    = 1004;
      tic     = 1005;
      gscf    = 1006;
      gscc    = 1007;
      gsc     = 1008;
      usnoa   = 1009;
      microcat= 1010;
      dsbase  = 1011;
      dstyc   = 1012;
      dsgsc   = 1013;
      gcstar  = 1014;
      BaseVar = 2000;
      MaxVarStarCatalog = 2;
      gcvs    = 2001;
      gcvar   = 2002;
      BaseDbl = 3000;
      MaxDblStarCatalog = 2;
      wds     = 3001;
      gcdbl   = 3002;
      BaseNeb = 4000;
      MaxNebCatalog = 9;
      sac     = 4001;
      ngc     = 4002;
      lbn     = 4003;
      rc3     = 4004;
      pgc     = 4005;
      ocl     = 4006;
      gcm     = 4007;
      gpn     = 4008;
      gcneb   = 4009;
      BaseLin = 5000;
      MaxLinCatalog = 1;
      gclin   = 5001;
      MaxSearchCatalog=29;
      S_Messier = 1;
      S_NGC     = 2;
      S_IC      = 3;
      S_PGC     = 4;
      S_GCVS    = 5;
      S_GC      = 6;
      S_GSC     = 7;
      S_SAO     = 8;
      S_HD      = 9;
      S_BD      =10;
      S_CD      =11;
      S_CPD     =12;
      S_HR      =13;
      S_Comet   =14;
      S_Planet  =15;
      S_Asteroid=16;
      S_Const   =17;
      S_Bayer   =18;
      S_Flam    =19;
      S_U2k     =20;
      S_Ext     =21;
      S_SAC     =22;
      S_SIMBAD  =23;
      S_NED     =24;
      S_WDS     =25;
      S_GCat    =26;
      S_TYC2    =27;
      S_Common  =28;
      StarLabel : Tlabellst =('RA','DEC','Id','mV','b-v','mB','mR','sp','pmRA','pmDE','date','px','desc','','','Str1','Str2','Str3','Str4','Str5','Str6','Str7','Str8','Str9','Str10','Num1','Num2','Num3','Num4','Num5','Num6','Num7','Num8','Num9','Num10');
      VarLabel : Tlabellst =('RA','DEC','Id','mMax','mMin','Period','Type','Mepoch','Rise','sp','mag. code','desc','','','','Str1','Str2','Str3','Str4','Str5','Str6','Str7','Str8','Str9','Str10','Num1','Num2','Num3','Num4','Num5','Num6','Num7','Num8','Num9','Num10');
      DblLabel : Tlabellst =('RA','DEC','Id','m1','m2','sep','pa','date','Comp','sp','sp','desc','','','','Str1','Str2','Str3','Str4','Str5','Str6','Str7','Str8','Str9','Str10','Num1','Num2','Num3','Num4','Num5','Num6','Num7','Num8','Num9','Num10');
      NebLabel : Tlabellst =('RA','DEC','Id','NebTyp','m','sbr','D','D','Unit','pa','rv','class','desc','','','Str1','Str2','Str3','Str4','Str5','Str6','Str7','Str8','Str9','Str10','Num1','Num2','Num3','Num4','Num5','Num6','Num7','Num8','Num9','Num10');
      nebtype: array[1..18] of string=(' - ',' ? ',' Gx',' OC',' Gb',' Pl',' Nb','C+N','  *',' D*','***','Ast',' Kt','Gcl','Drk','Cat','Cat','Cat');
      key_cr   =13;
      key_plus =107;
      key_minus=109;
      key_left =37;
      key_right=39;
      key_up   =38;
      key_down =40;
      key_upleft =36;
      key_upright=33;
      key_downleft=35;
      key_downright =34;

      //Observatory database
      CdcMinLocid='99999999';
      MaxCityList=100;
      // Location database source url
      baseurl_us = 'http://www.ap-i.net/pub/skychart/gn/stategaz/';
      baseurl_world = 'http://www.ap-i.net/pub/skychart/gn/cntyfile/';
      
      //Default URL
      URL_WebHome = 'http://www.ap-i.net/skychart';
      URL_Maillist = 'http://groups.yahoo.com/group/skychart-discussion/';
      URL_BugTracker = 'http://www.ap-i.net/mantis/';
      
      URL_HTTPCometElements = 'http://cfa-www.harvard.edu/iau/Ephemerides/Comets/Soft00Cmt.txt';
      URL_FTPCometElements = 'ftp://cfa-ftp.harvard.edu/pub/MPCORB/COMET.DAT';
      URL_HTTPAsteroidElements1 = 'http://cfa-www.harvard.edu/iau/Ephemerides/Bright/$YYYY/Soft00Bright.txt';
      URL_HTTPAsteroidElements2 = 'http://cfa-www.harvard.edu/iau/Ephemerides/Unusual/Soft00Unusual.txt';
      URL_HTTPAsteroidElements3 = 'http://cfa-www.harvard.edu/iau/Ephemerides/Distant/Soft00Distant.txt';
      URL_MPCORBAsteroidElements = 'ftp://cfa-ftp.harvard.edu/pub/MPCORB/MPCORB.DAT';
      URL_CDCAsteroidElements = 'http://www.ap-i.net/skychart/data/mpc5000.dat';
      
      URL_DSS_NAME1 = 'DSS 1';
      URL_DSS1 = 'http://archive.eso.org/dss/dss/image?ra=$RAH+$RAM+$RAS&dec=+$DED+$DEM+$DES&equinox=J2000&x=$XSZ&y=$YSZ&Sky-Survey=DSS1&mime-type=display/gz-fits';
      URL_DSS_NAME2 = 'DSS 2 Red';
      URL_DSS2 = 'http://archive.eso.org/dss/dss/image?ra=$RAH+$RAM+$RAS&dec=+$DED+$DEM+$DES&equinox=J2000&x=$XSZ&y=$YSZ&Sky-Survey=DSS2-red&mime-type=display/gz-fits';
      URL_DSS_NAME3 = 'DSS 2 Blue';
      URL_DSS3 = 'http://archive.eso.org/dss/dss/image?ra=$RAH+$RAM+$RAS&dec=+$DED+$DEM+$DES&equinox=J2000&x=$XSZ&y=$YSZ&Sky-Survey=DSS2-blue&mime-type=display/gz-fits';
      URL_DSS_NAME4 = 'DSS 2 Infrared';
      URL_DSS4 = 'http://archive.eso.org/dss/dss/image?ra=$RAH+$RAM+$RAS&dec=+$DED+$DEM+$DES&equinox=J2000&x=$XSZ&y=$YSZ&Sky-Survey=DSS2-infrared&mime-type=display/gz-fits';
      URL_DSS_NAME5 = 'SkyView DSS';
      URL_DSS5 = 'http://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=DSS&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';
      URL_DSS_NAME6 = 'H-alpha Full Sky Map';
      URL_DSS6 = 'http://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=H-alpha&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';
      URL_DSS_NAME7 = '2MASS J';
      URL_DSS7 = 'http://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=2MASS-J&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';
      URL_DSS_NAME8 = '2MASS H';
      URL_DSS8 = 'http://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=2MASS-H&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';
      URL_DSS_NAME9 = 'IRAS 12 micron';
      URL_DSS9 = 'http://skyview.gsfc.nasa.gov/cgi-bin/images?Survey=IRAS12&position=$RAF,$DEF&Size=$FOVX,$FOVY&Pixels=$PIXX,$PIXY&Projection=Tan&Equinox=2000&Return=FITS';

{$ifdef linux}
      DefaultFontName='Helvetica';
      DefaultFontFixed='Courier';
      DefaultFontSymbol='adobe-symbol';   // available in core XFree86 75 and 100 dpi fonts
      DefaultFontSize=10;
      DefaultPrivateDir='~/cartes_du_ciel';
      Defaultconfigfile='~/.cartesduciel.ini';
      SharedDir='/usr/share/apps/skychart';
      DefaultPrintCmd1='kghostview';
      DefaultPrintCmd2='gimp';
      DefaultTmpDir='tmp';
      Default_dssdrive='/mnt/cdrom';
      DefaultVarObs='varobs';
{$endif}
{$ifdef darwin}
      DefaultFontName='Helvetica';
      DefaultFontFixed='Courier';
      DefaultFontSymbol='symbol';
      DefaultFontSize=10;
      DefaultPrivateDir='~/cartes_du_ciel';
      Defaultconfigfile='~/.cartesduciel.ini';
      SharedDir='/usr/share/skychart';
      DefaultPrintCmd1='kghostview';
      DefaultPrintCmd2='gimp';
      DefaultTmpDir='tmp';
      Default_dssdrive='/Volumes';
      DefaultVarObs='varobs';
{$endif}
{$ifdef win32}
      DefaultFontName='Arial';
      DefaultFontFixed='Courier';
      DefaultFontSymbol='Symbol';
      DefaultFontSize=8;
      DefaultPrivateDir='Cartes du Ciel';
      Defaultconfigfile='cartesduciel.ini';
      DefaultPrintCmd1='gsview32.exe';
      DefaultPrintCmd2='mspaint.exe';
      DefaultTmpDir='tmp';
      Default_dssdrive='D:\';
      DefaultVarObs='varobs.exe';
{$endif}

type
     Tplanetlst = array[0..MaxSim,1..MaxPla,1..7] of double; // 1..9 : planet ; 10 : soleil ; 11 : lune ; 12..15 : jup sat ; 16..23 : sat sat ; 24..28 : ura sat ; 29..30 : mar sat ; 31 : sat ring ; 32 : earth shadow ;
     Tcometlst = array of array[1..MaxComet,1..8] of double;       // ra, dec, magn, diam, tail_ra, tail_dec, jd, epoch
     TcometName= array of array[1..MaxComet,1..2] of string[27];   // id, name
     Tasteroidlst = array of array[1..MaxAsteroid,1..5] of double;  // ra, dec, magn, jd, epoch
     TasteroidName = array of array[1..MaxAsteroid,1..2] of string[27]; // id, name
     double6 = array[1..6] of double;
     Pdouble6 = ^double6;
     Tconstpos  = record ra,de : single; end;
     Tconstb = record ra,de : single; newconst:boolean; end;
     Tconstl = record ra1,de1,ra2,de2 : single; end;
     TLabelAlign = (laNone,laTop,laBottom,laLeft,laRight,laCenter);
     Thorizonlist = array [0..360] of single;
     Phorizonlist = ^Thorizonlist;

     Tobjlabel = record
            id:integer;
            x,y,r:smallint;
            labelnum,fontnum:byte;
            align: TLabelAlign;
            txt:string;  //txt:shortstring
            end;
     Tmodlabel = record
            id,dx,dy:integer;
            labelnum,fontnum:byte;
            align: TLabelAlign;
            txt: string;
            hiden: boolean;
            end;
     Tcustomlabel = record
            ra,dec: double;
            labelnum: byte;
            align: TLabelAlign;
            txt: string;
            end;

     TGCatLst =  record
                    min, max, magmax : single;
                    cattype:integer;
                    Actif,CatOn : boolean;
                    shortname, name, path, version : string;  //shortname, name, path, version : shortstring;
                 end;
     Tconf_catalog = class(TObject)    // catalog setting
                public
                constructor Create;
                destructor Destroy; override;
                procedure Assign(Source: Tconf_catalog);
                GCatLst : array of TGCatLst;
                GCatNum  : Integer;
                StarmagMax,NebMagMax,NebSizeMin : double;            // limit to extract from catalog
                StarCatPath : array [1..MaxStarCatalog] of string;   // path to each catalog
                StarCatDef : array [1..MaxStarCatalog] of boolean;   // is the catalog defined
                StarCatOn : array [1..MaxStarCatalog] of boolean;    // is the catalog used for current chart
                StarCatField : array [1..MaxStarCatalog,1..2] of integer; // Field min and max the catalog is active
                VarStarCatPath : array [1..MaxVarStarCatalog] of string;   // path to each catalog
                VarStarCatDef : array [1..MaxVarStarCatalog] of boolean;   // is the catalog defined
                VarStarCatOn : array [1..MaxVarStarCatalog] of boolean;    // is the catalog used for current chart
                VarStarCatField : array [1..MaxVarStarCatalog,1..2] of integer; // Field min and max the catalog is active
                DblStarCatPath : array [1..MaxDblStarCatalog] of string;   // path to each catalog
                DblStarCatDef : array [1..MaxDblStarCatalog] of boolean;   // is the catalog defined
                DblStarCatOn : array [1..MaxDblStarCatalog] of boolean;    // is the catalog used for current chart
                DblStarCatField : array [1..MaxDblStarCatalog,1..2] of integer; // Field min and max the catalog is active
                NebCatPath : array [1..MaxNebCatalog] of string;   // path to each catalog
                NebCatDef : array [1..MaxNebCatalog] of boolean;   // is the catalog defined
                NebCatOn : array [1..MaxNebCatalog] of boolean;    // is the catalog used for current chart
                NebCatField : array [1..MaxNebCatalog,1..2] of integer; // Field min and max the catalog is active
                LinCatOn : array [1..MaxLinCatalog] of boolean;    // is the catalog used for current chart
                UseUSNOBrightStars, UseGSVSIr : Boolean;  // filter specific catalog entry
                end;
     Tconf_shared = class(TObject)    // common setting
                public
                constructor Create;
                destructor Destroy; override;
                procedure Assign(Source: Tconf_shared);
                FieldNum : array [0..MaxField] of double;  // Field of vision limit
                StarFilter,NebFilter : boolean;   // filter by magnitude
                BigNebFilter : boolean;           // filter big nebulae
                BigNebLimit : double;
                AutoStarFilter : boolean;         // automatic limit
                AutoStarFilterMag : double;       // automatic limit reference magnitude
                StarMagFilter : array [0..MaxField] of double;  // Limiting mag. for each field
                NebMagFilter : array [0..MaxField] of double;   // Limiting mag. for each field
                NebSizeFilter : array [0..MaxField] of double;  // Limiting size for each field
                HourGridSpacing : array [0..MaxField] of double;
                DegreeGridSpacing : array [0..MaxField] of double;
                ShowCRose : Boolean; //  compass rose
                CRoseSz : Integer;
                EquinoxType : integer;
                DefaultJDchart : double;
                EquinoxChart : string;
                AzNorth,ListNeb,ListStar,ListVar,ListDbl,ListPla : boolean;
                ConstelName: array of array[1..2] of string; // constellation three letter abbrev and name.
                ConstLnum,ConstBnum,ConstelNum,StarNameNum:integer;
                ConstelPos:  array of Tconstpos;
                ConstL: array of Tconstl;
                ConstB : array of Tconstb;
                horizonlist : Thorizonlist;
                StarName: array of string;
                StarNameHR: array of integer;
                end;
     Tconf_skychart = class(TObject)    // chart setting
                public
                constructor Create;
                destructor Destroy; override;
                procedure Assign(Source: Tconf_skychart);
                tz: TCdCTimeZone;
                racentre,decentre,fov,theta,acentre,hcentre,lcentre,bcentre,lecentre,becentre,e,nutl,nuto,sunl,sunb,abe,abp,raprev,deprev : double;
                Force_DT_UT,horizonopaque,autorefresh,TrackOn,Quick,NP,SP,moved : Boolean;
                projtype : char;
                projname : array [0..MaxField] of string[3];
                FlipX, FlipY, ProjPole, TrackType,TrackObj, AstSymbol, ComSymbol : integer;
                SimNb,SimD,SimH,SimM,SimS,SimLabel : Integer;
                SimObject: array[1..NumSimObject] of boolean;
                SimLine,SimDateLabel,SimNameLabel,SimMagLabel,ShowPlanet,PlanetParalaxe,ShowEarthShadow,ShowAsteroid,ShowComet : Boolean;
                SimDateYear,SimDateMonth,SimDateDay,SimDateHour,SimDateMinute,SimDateSecond: Boolean;
                ObsLatitude,ObsLongitude,ObsAltitude : double; ObsTZ: string;
                ObsTemperature,ObsPressure,ObsRefractionCor,ObsHorizonDepression : Double;
                ObsName,ObsCountry,chartname,ast_day,ast_daypos,com_day,com_daypos : string;
                CurYear,CurMonth,CurDay,DrawPMyear : integer;
                ShowPluto, ShowConstl,ShowConstB,ShowEqGrid,ShowGrid,ShowGridNum,UseSystemTime,countrytz : boolean;
                StyleGrid,StyleEqGrid,StyleConstL,StyleConstB,StyleEcliptic,StyleGalEq:TFPPenStyle;
                ShowEcliptic,ShowGalactic,ShowMilkyWay,FillMilkyWay,ShowHorizon,FillHorizon,ShowHorizonDepression : boolean;
                CurTime,DT_UT_val,GRSlongitude,TelescopeTurnsX,TelescopeTurnsY: double;
                PMon,DrawPMon,ApparentPos,CoordExpertMode : boolean;
                LabelOrientation, ManualTelescopeType, CoordType : integer;
                IndiServerHost, IndiServerPort, IndiServerCmd, IndiDriver, IndiPort, IndiDevice, ScopePlugin : string;
                IndiAutostart,ShowCircle,IndiTelescope, PluginTelescope, ManualTelescope, ShowImages, ShowBackgroundImage, showstars, shownebulae, showline, showlabelall,Editlabels : boolean;
                BackgroundImage: string;
                // working variable
                HorizonMax,rap2000,dep2000,RefractionOffset : Double;
                WindowRatio,BxGlb,ByGlb,AxGlb,AyGlb,sintheta,costheta,x2: Double;
                Xwrldmin,Xwrldmax,Ywrldmin,Ywrldmax: Double;
                xmin,xmax,ymin,ymax,xshift,yshift,FieldNum,winx,winy,wintop,winleft : integer;
                LeftMargin,RightMargin,TopMargin,BottomMargin,Xcentre,Ycentre: Integer;
                ObsRoSinPhi,ObsRoCosPhi,StarmagMax,NebMagMax,FindRA,FindDec,FindSize,AstmagMax,AstMagDiff,CommagMax,Commagdiff : double;
                TimeZone,DT_UT,CurST,CurJD,LastJD,jd0,JDChart,YPmon,LastJDChart,CurSunH,CurMoonH,CurMoonIllum,ScopeRa,ScopeDec,TrackEpoch,TrackRA,TrackDec : Double;
                StarFilter,NebFilter,FindOK,WhiteBg,MagLabel,NameLabel,ConstFullLabel,ConstLatinLabel,ScopeMark,ScopeLock,FindPM : boolean;
                EquinoxName,TrackName,TrackId,FindName,FindDesc,FindNote : string;
                PlanetLst : Tplanetlst;
                AsteroidNb,CometNb,AsteroidLstSize,CometLstSize,NumCircle: integer;
                AsteroidLst: Tasteroidlst;
                CometLst: Tcometlst;
                AsteroidName: TasteroidName;
                CometName: Tcometname;
                horizonlist : Phorizonlist;
                nummodlabels, posmodlabels, numcustomlabels, poscustomlabels: integer;
                modlabels: array[1..maxmodlabels] of Tmodlabel;
                customlabels: array[1..maxmodlabels] of Tcustomlabel;
                LabelMagDiff : array[1..numlabtype] of double;
                ShowLabel : array[1..numlabtype] of boolean;
                circle : array [1..10,1..3] of single; // radius, rotation, offset
                circleok : array [1..10] of boolean; circlelbl : array [1..10] of string;
                rectangle : array [1..10,1..4] of single; // width, height, rotation, offset
                rectangleok : array [1..10] of boolean; rectanglelbl : array [1..10] of string;
                CircleLst : array[0..MaxCircle,1..2] of double;
                end;
     Tconf_plot = class(TObject)    // plot setting
                public
                constructor Create;
                destructor Destroy; override;
                procedure Assign(Source: Tconf_plot);
                color : Starcolarray;
                skycolor : TSkycolor;
                backgroundcolor,bgcolor : Tcolor;
                stardyn,starsize,prtres,starplot,nebplot,plaplot : integer;
                Nebgray,NebBright,starshapesize,starshapew : integer;
                Invisible,AutoSkycolor,TransparentPlanet : boolean;
                FontName : array [1..numfont] of string;    // 1=grid 2=label 3=legend 4=status 5=list 6=prt 7=symbol
                FontSize : array [1..numfont] of integer;
                FontBold : array [1..numfont] of boolean;
                FontItalic : array [1..numfont] of boolean;
                LabelColor : array[1..numlabtype] of Tcolor;   // 1=star 2=var 3=mult 4=neb 5=solsys 6=const 7=misc 8=chart info 
                LabelSize : array[1..numlabtype] of integer;
                outradius,contrast,saturation:integer;
                xmin,xmax,ymin,ymax: integer;
                partsize,magsize:single;
                red_move:boolean;

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

                end;
     Tconf_chart = class(TObject)    // chart window setting
                public
                constructor Create;
                destructor Destroy; override;
                procedure Assign(Source: Tconf_chart);
                onprinter : boolean;
                width,height,drawpen,drawsize,fontscale,hw,hh : integer;
                min_ma, max_catalog_mag : double;
                end;
     Tconf_main = class(TObject)    // main form setting
                public
                constructor Create;
                destructor Destroy; override;
                procedure Assign(Source: Tconf_main);
                prtname,language,Constellationpath, ConstLfile, ConstBfile, EarthMapFile, HorizonFile, Planetdir : string;
                db,dbhost,dbuser,dbpass, ImagePath, persdir, prgdir : string;
                PrinterResolution,PrintMethod,PrintColor,configpage,configpage_i,configpage_j,autorefreshdelay,MaxChildID,dbport : integer;
                PrtLeftMargin,PrtRightMargin,PrtTopMargin,PrtBottomMargin: integer;
                savetop,saveleft,saveheight,savewidth: integer;
                ButtonStandard,ButtonNight: integer;
                PrintLandscape, ShowChartInfo, SyncChart :boolean;
                maximized,updall,AutostartServer,keepalive, NewBackgroundImage : boolean;
                ServerIPaddr,ServerIPport,PrintCmd1,PrintCmd2,PrintTmpPath,ThemeName,IndiPanelCmd : string;
                ImageLuminosity, ImageContrast : double;
                ProxyHost, ProxyPort, ProxyUser, ProxyPass, AnonPass: string;
                FtpPassive, HttpProxy : Boolean;
                CometUrlList, AsteroidUrlList : TStringList;
                end;
     Tconf_dss  = class(TObject)    // DSS image setting
                public
                constructor Create;
                destructor Destroy; override;
                procedure Assign(Source: Tconf_dss);
                dssdir,dssdrive,dssfile : string;
                dss102,dssnorth,dsssouth,dsssampling,dssplateprompt : boolean;
                dssmaxsize : integer;
                OnlineDSS : Boolean;
                OnlineDSSid: integer;
                DSSurl: array[1..MaxDSSurl,0..1] of String;
                end;
                

type
  TPrepareAsteroid = function (jdt:double; msg:Tstrings):boolean of object;
                  
// external library
const
{$ifdef linux}
      lib404   = 'libplan404.so';
      libz = 'libz.so';
//      libsatxy = 'libsatxy.so';
//      libsatxyfm='Satxyfm';
{$endif}
{$ifdef darwin}
      lib404   = 'libplan404.dylib';
      libz = 'libz.dylib';
{$endif}
{$ifdef win32}
      lib404 = 'libplan404.dll';
      libz = 'zlib1.dll';
//      libsatxy = 'libsatxy.dll';
//      libsatxyfm='Satxyfm';
{$endif}

// libplan404
type
     TPlanetData = record
        JD : double;
         l : double ;
         b : double ;
         r : double ;
         x : double ;
         y : double ;
         z : double ;
         ipla : integer;
     end;
     PPlanetData = ^TPlanetData;
     TPlan404=Function( pla : PPlanetData):integer; cdecl;
var Plan404 : TPlan404;
    Plan404lib: TLibHandle;

//  zlib
type
 Tgzopen =Function(path,mode :pchar): pointer ; cdecl;
 Tgzread =Function(gzFile: pointer; buf : pointer; len:cardinal): longint; cdecl;
 Tgzeof =Function(gzFile: pointer): longbool; cdecl;
 Tgzclose =Function(gzFile: pointer): longint; cdecl;
var gzopen : Tgzopen;
    gzread : Tgzread;
    gzeof : Tgzeof;
    gzclose : Tgzclose;
    zlibok: boolean;
    zlib: longword;

// libsatxy
{type double8 = array[1..8] of double;
     Pdouble8 = ^double8;
     TSatxyfm = Function(djc : double; ipla : integer; Pxx,Pyy : Pdouble8):integer; stdcall;
}

// pseudo-constant only here
Var  Appdir, PrivateDir, SampleDir, TempDir, HelpDir, ZoneDir : string;
     VarObs : String;
     ForceConfig, Configfile, SysDecimalSeparator, Lang : string;
     compile_time:string;
     ldeg,lmin,lsec : string;
     ImageListCount: integer;
     nightvision : Boolean;
     isWin98: Boolean;
     DisplayIs32bpp: Boolean;
     ThemePath:string ='data/Themes';
     LinuxDesktop: integer = 0;  // KDE=0, GNOME=1, Other=2
     crRetic: TCursor = 5;
     Params : TStringList;
{$ifdef darwin}
     OpenFileCMD:string = 'open';   //
{$else}
     OpenFileCMD:string = 'kfmclient exec';   // default KDE
{$endif}
{$ifdef unix}
     tracefile:string =''; // to stdout
     dcd_cmd: string = 'cd /usr/local/dcd ; python ./dcd.py';
     use_xplanet: boolean = true;
     xplanet_dir: string = '';
{$endif}
{$ifdef win32}
     tracefile:string = 'cdc_trace.txt';
     xplanet_dir: string = 'C:\Program Files\xplanet';
     dcd_cmd: string = 'cmd /c "C: && cd C:\Program Files\dcd && dcd.py"';
     use_xplanet: boolean = false;
{$endif}

// Text formating constant
const
     html_h        = '<HTML><body bgcolor="#FFFFFF" text="#000000">';
     html_h_nv     = '<HTML><body bgcolor="#000000" text="#C03030">';
     htms_h        = '</body></HTML>';
     html_ffx      = '<font face="fixed">';
     htms_f        = '</font>';
     html_b        = '<b>';
     htms_b        = '</b>';
     html_h2       = '<font size="+2"><b>';
     htms_h2       = '</b></font><br>';
     html_p        = '<p>';
     htms_p        = '</p>';
     html_br       = '<br>';
     html_sp       = '&nbsp;';
     html_pre      = '<pre>';
     htms_pre      = '</pre>';

const msgTimeout='Timeout!';
      msgOK='OK!';
      msgFailed='Failed!';
      msgNotFound='Not found!';

      msgBye='Bye!';

const
     MaxCmdArg = 10;
// Main Commands, excuted form main form
     numcmdmain = 12;
     maincmdlist: array[1..numcmdmain,1..3] of string=(
     ('NEWCHART','1','chart_name'),
     ('CLOSECHART','2','chart_name'),
     ('SELECTCHART','3','chart_name'),
     ('LISTCHART','4',''),
     ('SEARCH','5','object_name'),
     ('GETMSGBOX','6',''),
     ('GETCOORBOX','7',''),
     ('GETINFOBOX','8',''),
     ('FIND' ,'9','! not implemented'),
     ('SAVE' ,'10','! not implemented'),
     ('LOAD' ,'11','! not implemented'),
     ('?' ,'12','')
     );

// Chart Commands
     numcmd = 79;
     cmdlist: array[1..numcmd,1..3] of string=(
     ('ZOOM+','1',''),
     ('ZOOM-','2',''),
     ('MOVEEAST','3',''),
     ('MOVEWEST','4',''),
     ('MOVENORTH','5',''),
     ('MOVESOUTH','6',''),
     ('MOVENORTHEAST','7',''),
     ('MOVENORTHWEST','8',''),
     ('MOVESOUTHEAST','9',''),
     ('MOVESOUTHWEST','10',''),
     ('FLIPX','11',''),
     ('FLIPY','12',''),
     ('SETCURSOR','13','pixX pixY'),
     ('CENTRECURSOR','14',''),
     ('ZOOM+MOVE','15',''),
     ('ZOOM-MOVE','16',''),
     ('ROT+','17',''),
     ('ROT-','18',''),
     ('SETEQGRID','19','ON/OFF'),
     ('SETGRID','20','ON/OFF'),
     ('SETSTARMODE','21','0/1/2'),
     ('SETNEBMODE','22','0/1'),
     ('SETAUTOSKY','23','ON/OFF'),
     ('UNDO','24',''),
     ('REDO','25',''),
     ('SETPROJ','26','ALTAZ/EQUAT/GALACTIC/ECLIPTIC'),
     ('SETFOV','27','00d00m00s or 00.00'),
     ('SETRA','28','RA:00h00m00s or RA:00.00'),
     ('SETDEC','29','DEC:+00d00m00s or DEC:00.00'),
     ('SETOBS','30','LAT:+00d00m00sLON:+000d00m00sALT:000mOBS:name'),
     ('IDCURSOR','31',''),
     ('SAVEIMG','32','PNG/JPEG/BMP filename quality'),
     ('SETNORTH','33',''),
     ('SETSOUTH','34',''),
     ('SETEAST','35',''),
     ('SETWEST','36',''),
     ('SETZENITH','37',''),
     ('ALLSKY','38',''),
     ('REDRAW','39',''),
     ('GETCURSOR','40',''),
     ('GETEQGRID','41',''),
     ('GETGRID','42',''),
     ('GETSTARMODE','43',''),
     ('GETNEBMODE','44',''),
     ('GETAUTOSKY','45',''),
     ('GETPROJ','46',''),
     ('GETFOV','47','S/F'),
     ('GETRA','48','S/F'),
     ('GETDEC','49','S/F'),
     ('GETDATE','50',''),
     ('GETOBS','51',''),
     ('SETDATE','52','yyyy-mm-ddThh:mm:ss or "yyyy-mm-dd hh:mm:ss"'),
     ('SETTZ','53','Etc/GTM'),
     ('GETTZ','54',''),
     // V2.7 compatibility DDE command
     ('MOVE' ,'55','obsolete, RA: 00h00m00.00s DEC:+00d00m00.0s FOV:+00d00m00s'),
     ('DATE' ,'52','obsolete, same as SETDATE'),
     ('OBSL' ,'30','obsolete, same as SETOBS'),
     ('RFSH' ,'39','obsolete, same as REDRAW'),
     ('PDSS' ,'56',''),
     ('SBMP' ,'57','obsolete, use SAVEIMG'),
     ('SGIF' ,'58','obsolete, use SAVEIMG'),
     ('SJPG' ,'59','obsolete, use SAVEIMG'),
     ('IDXY' ,'60','X:pixelx Y:pixely'),
     ('GOXY' ,'61','X:pixelx Y:pixely'),
     ('ZOM+' ,'1','obsolete, same as ZOOM+'),
     ('ZOM-' ,'2','obsolete, same as ZOOM-'),
     ('STA+' ,'62',''),
     ('STA-' ,'63',''),
     ('NEB+' ,'64',''),
     ('NEB-' ,'65',''),
     ('GREQ' ,'66','obsolete, use SETEQGRID'),
     ('GRAZ' ,'67','obsolete, use SETGRID'),
     ('GRNM' ,'68','obsolete, use SETGRIDNUM'),
     ('CONL' ,'69','obsolete, use SETCONSTLINE'),
     ('CONB' ,'70','obsolete, use SETCONSTBOUNDARY'),
     ('EQAZ' ,'71','obsolete, use SETPROJ'),
     // end V2.7 compatibility DDE command
     ('SETGRIDNUM','77','ON/OFF'),
     ('SETCONSTLINE','78','ON/OFF'),
     ('SETCONSTBOUNDARY','79','ON/OFF')
     );

// INDI Telescope driver
const
      NumIndiDriver=10;
      IndiDriverLst: array[0..NumIndiDriver,1..2] of string =(('Other',''),
                  ('AstroPhysic','apmount'),
                  ('Celestron GPS','celestrongps'),
                  ('LX200 Basic','lx200basic'),
                  ('LX200 Generic','lx200generic'),
                  ('LX200 Classic','lx200classic'),
                  ('LX200 GPS','lx200gps'),
                  ('LX200 Autostar','lx200autostar'),
                  ('LX200 16','lx200_16'),
                  ('SkyCommander','skycommander'),
                  ('Takahashi Temma','temma'));

// Database
type TDBtype = (mysql,sqlite);
const
    showtable : array[mysql..sqlite] of string =(
                'show tables like',
                'select name from sqlite_master where type="table" and name like'
                );
    defaultSqliteDB='database/cdc.db';
    defaultMysqlDB='cdc';            
var DBtype: TDBtype = sqlite;

// SQL Table structure
const
create_table_ast_day=' ( jd int(11) NOT NULL default "0", limit_mag smallint(6) NOT NULL default "0")';
create_table_ast_day_pos='( id varchar(7) NOT NULL default "", epoch double NOT NULL default "0",'+
                         'ra smallint(6) NOT NULL default "0",  de smallint(6) NOT NULL default "0",'+
                         'mag smallint(6) NOT NULL default "0",  PRIMARY KEY  (ra,de,mag))';
create_table_com_day=' ( jd int(11) NOT NULL default "0", limit_mag smallint(6) NOT NULL default "0")';
create_table_com_day_pos='( id varchar(12) NOT NULL default "", epoch double NOT NULL default "0",'+
                         'ra smallint(6) NOT NULL default "0",  de smallint(6) NOT NULL default "0",'+
                         'mag smallint(6) NOT NULL default "0",  PRIMARY KEY  (ra,de,mag))';
numsqltable=10;
sqltable : array[mysql..sqlite,1..numsqltable,1..3] of string =(
           (  // mysql tables
           ('cdc_ast_name',' ( id varchar(7) binary NOT NULL default "0", name varchar(27) NOT NULL default "",'+
                           'PRIMARY KEY (id))',''),
           ('cdc_ast_elem_list',' ( elem_id smallint(6) NOT NULL default "0", filedesc varchar(80) NOT NULL default "",'+
                           'PRIMARY KEY (elem_id))',''),
           ('cdc_ast_elem',' ( id varchar(7) binary NOT NULL default "0",'+
                           'h double NOT NULL default "0", g double NOT NULL default "0",'+
                           'epoch double NOT NULL default "0", mean_anomaly double NOT NULL default "0",'+
                           'arg_perihelion double NOT NULL default "0", asc_node double NOT NULL default "0",'+
                           'inclination double NOT NULL default "0", eccentricity double NOT NULL default "0",'+
                           'semi_axis double NOT NULL default "0", ref varchar(10) binary NOT NULL default "",'+
                           'name varchar(27) NOT NULL default "", equinox smallint(4) NOT NULL default "0",'+
                           'elem_id smallint(6) NOT NULL default "0", PRIMARY KEY (id,epoch))',''),
           ('cdc_ast_mag',' ( id varchar(7) binary NOT NULL default "",'+
                          'jd double NOT NULL default "0", epoch double NOT NULL default "0",'+
                          'mag smallint(6) NOT NULL default "0", elem_id smallint(6) NOT NULL default "0",'+
                          'PRIMARY KEY (jd,id))','1'),
           ('cdc_com_name',' ( id varchar(12) binary NOT NULL default "0", name varchar(27) NOT NULL default "",'+
                           'PRIMARY KEY (id))',''),
           ('cdc_com_elem_list',' ( elem_id smallint(6) NOT NULL default "0", filedesc varchar(80) NOT NULL default "",'+
                           'PRIMARY KEY (elem_id))',''),
           ('cdc_com_elem',' ( id varchar(12) binary NOT NULL default "0",'+
                           'peri_epoch double NOT NULL default "0", peri_dist double NOT NULL default "0",'+
                           'eccentricity double NOT NULL default "0",'+
                           'arg_perihelion double NOT NULL default "0", asc_node double NOT NULL default "0",'+
                           'inclination double NOT NULL default "0",'+
                           'epoch double NOT NULL default "0",'+
                           'h double NOT NULL default "0", g double NOT NULL default "0",'+
                           'name varchar(27) NOT NULL default "", equinox smallint(4) NOT NULL default "0",'+
                           'elem_id smallint(6) NOT NULL default "0", PRIMARY KEY (id,epoch))',''),
           ('cdc_fits',' (filename varchar(255) NOT NULL default "", '+
                           'catalogname varchar(5)  NOT NULL default "", '+
                           'objectname varchar(25) NOT NULL default "", '+
                           'ra double NOT NULL default "0",'+
                           'de double NOT NULL default "0", '+
                           'width double NOT NULL default "0", '+
                           'height double NOT NULL default "0", '+
                           'rotation  double NOT NULL default "0", '+
                           'PRIMARY KEY (ra,de))','2'),
           ('cdc_country','(country varchar(5) NOT NULL default "",'+
                           'isocode varchar(5) NOT NULL default "",'+
                           'name varchar(50) NOT NULL default "",'+
                           'PRIMARY KEY (country))',''),
           ('cdc_location','(locid integer NOT NULL ,'+
                           'country varchar(5) NOT NULL ,'+
                           'location varchar(50) NOT NULL ,'+
                           'type varchar(5) NOT NULL ,'+
                           'latitude double NOT NULL ,'+
                           'longitude double NOT NULL ,'+
                           'elevation double NOT NULL ,'+
                           'timezone double NOT NULL ,'+
                           'PRIMARY KEY (locid))','3,4')
           ),
           (   // sqlite tables

           ('cdc_ast_name',' ( id TEXT NOT NULL default "0", name TEXT NOT NULL default "",'+
                           'PRIMARY KEY (id))',''),
           ('cdc_ast_elem_list',' ( elem_id INTEGER NOT NULL default "0", filedesc TEXT NOT NULL default "",'+
                           'PRIMARY KEY (elem_id))',''),
           ('cdc_ast_elem',' ( id TEXT NOT NULL default "0",'+
                           'h NUMERIC NOT NULL default "0", g NUMERIC NOT NULL default "0",'+
                           'epoch NUMERIC NOT NULL default "0", mean_anomaly NUMERIC NOT NULL default "0",'+
                           'arg_perihelion NUMERIC NOT NULL default "0", asc_node NUMERIC NOT NULL default "0",'+
                           'inclination NUMERIC NOT NULL default "0", eccentricity NUMERIC NOT NULL default "0",'+
                           'semi_axis NUMERIC NOT NULL default "0", ref TEXT NOT NULL default "",'+
                           'name TEXT NOT NULL default "", equinox INTEGER NOT NULL default "0",'+
                           'elem_id INTEGER NOT NULL default "0", PRIMARY KEY (id,epoch))',''),
           ('cdc_ast_mag',' ( id TEXT NOT NULL default "",'+
                          'jd NUMERIC NOT NULL default "0", epoch NUMERIC NOT NULL default "0",'+
                          'mag INTEGER NOT NULL default "0", elem_id INTEGER NOT NULL default "0",'+
                          'PRIMARY KEY (jd,id))','1'),
           ('cdc_com_name',' ( id TEXT NOT NULL default "0", name TEXT NOT NULL default "",'+
                           'PRIMARY KEY (id))',''),
           ('cdc_com_elem_list',' ( elem_id INTEGER NOT NULL default "0", filedesc TEXT NOT NULL default "",'+
                           'PRIMARY KEY (elem_id))',''),
           ('cdc_com_elem',' ( id TEXT NOT NULL default "0",'+
                           'peri_epoch NUMERIC NOT NULL default "0", peri_dist NUMERIC NOT NULL default "0",'+
                           'eccentricity NUMERIC NOT NULL default "0",'+
                           'arg_perihelion NUMERIC NOT NULL default "0", asc_node NUMERIC NOT NULL default "0",'+
                           'inclination NUMERIC NOT NULL default "0",'+
                           'epoch NUMERIC NOT NULL default "0",'+
                           'h NUMERIC NOT NULL default "0", g NUMERIC NOT NULL default "0",'+
                           'name TEXT NOT NULL default "", equinox INTEGER NOT NULL default "0",'+
                           'elem_id INTEGER NOT NULL default "0", PRIMARY KEY (id,epoch))',''),
           ('cdc_fits',' (filename TEXT NOT NULL default "", '+
                           'catalogname TEXT  NOT NULL default "", '+
                           'objectname TEXT NOT NULL default "", '+
                           'ra NUMERIC NOT NULL default "0",'+
                           'de NUMERIC NOT NULL default "0", '+
                           'width NUMERIC NOT NULL default "0", '+
                           'height NUMERIC NOT NULL default "0", '+
                           'rotation  NUMERIC NOT NULL default "0", '+
                           'PRIMARY KEY (ra,de))','2'),
           ('cdc_country','(country TEXT NOT NULL default "",'+
                           'isocode TEXT NOT NULL default "",'+
                           'name TEXT NOT NULL default "",'+
                           'PRIMARY KEY (country))',''),
           ('cdc_location','(locid INTEGER NOT NULL ,'+
                           'country TEXT NOT NULL ,'+
                           'location TEXT NOT NULL ,'+
                           'type TEXT NOT NULL ,'+
                           'latitude NUMERIC NOT NULL ,'+
                           'longitude NUMERIC NOT NULL ,'+
                           'elevation NUMERIC NOT NULL ,'+
                           'timezone NUMERIC NOT NULL ,'+
                           'PRIMARY KEY (locid))','3,4')
           ));
numsqlindex=4;
sqlindex : array[mysql..sqlite,1..numsqlindex,1..2] of string =(
           (
           ('ast_mag_idx','cdc_ast_mag (mag)'),
           ('cdc_fits_objname','cdc_fits (objectname)'),
           ('cdc_location_idx1','cdc_location(country,location)'),
           ('cdc_location_idx2','cdc_location(latitude,longitude)')
           ),(
           ('ast_mag_idx','cdc_ast_mag (mag)'),
           ('cdc_fits_objname','cdc_fits (objectname)'),
           ('cdc_location_idx1','cdc_location(country,location)'),
           ('cdc_location_idx2','cdc_location(latitude,longitude)')
           ));

implementation

{ Tconf_catalog }

constructor Tconf_catalog.Create;
begin
  Inherited Create;
end;

destructor Tconf_catalog.Destroy;
begin
  SetLength(GCatLst,0);
  Inherited Destroy;
end;

procedure Tconf_catalog.Assign(Source: Tconf_catalog);
var i,j : integer;
begin
GCatNum:=Source.GCatNum;
SetLength(GCatLst,GCatNum);
for i:=0 to GCatNum-1 do GCatLst[i]:=Source.GCatLst[i];
StarmagMax:=Source.StarmagMax;
NebMagMax:=Source.NebMagMax;
NebSizeMin:=Source.NebSizeMin;
for i:=1 to MaxStarCatalog do begin
  StarCatPath[i]:=Source.StarCatPath[i];
  StarCatDef[i]:=Source.StarCatDef[i];
  StarCatOn[i]:=Source.StarCatOn[i];
  for j:=1 to 2 do StarCatField[i,j]:=Source.StarCatField[i,j];
end;
for i:=1 to MaxVarStarCatalog do begin
  VarStarCatPath[i]:=Source.VarStarCatPath[i];
  VarStarCatDef[i]:=Source.VarStarCatDef[i];
  VarStarCatOn[i]:=Source.VarStarCatOn[i];
  for j:=1 to 2 do VarStarCatField[i,j]:=Source.VarStarCatField[i,j];
end;
for i:=1 to MaxDblStarCatalog do begin
  DblStarCatPath[i]:=Source.DblStarCatPath[i];
  DblStarCatDef[i]:=Source.DblStarCatDef[i];
  DblStarCatOn[i]:=Source.DblStarCatOn[i];
  for j:=1 to 2 do DblStarCatField[i,j]:=Source.DblStarCatField[i,j];
end;
for i:=1 to MaxNebCatalog do begin
  NebCatPath[i]:=Source.NebCatPath[i];
  NebCatDef[i]:=Source.NebCatDef[i];
  NebCatOn[i]:=Source.NebCatOn[i];
  for j:=1 to 2 do NebCatField[i,j]:=Source.NebCatField[i,j];
end;
for i:=1 to MaxLinCatalog do LinCatOn[i]:=Source.LinCatOn[i];
UseUSNOBrightStars:=Source.UseUSNOBrightStars;
UseGSVSIr:=Source.UseGSVSIr;
end;

{ Tconf_shared }

constructor Tconf_shared.Create;
begin
  Inherited Create;
end;

destructor Tconf_shared.Destroy;
begin
  Setlength(ConstelName,0);
  Setlength(ConstelPos,0);
  Setlength(ConstB,0);
  Setlength(ConstL,0);
  Setlength(StarName,0);
  Setlength(StarNameHR,0);
  Inherited Destroy;
end;

procedure Tconf_shared.Assign(Source: Tconf_shared);
var i,j : integer;
begin
for i:=0 to MaxField do FieldNum[i]:=Source.FieldNum[i];
StarFilter:=Source.StarFilter;
NebFilter:=Source.NebFilter;
BigNebFilter:=Source.BigNebFilter;
BigNebLimit:=Source.BigNebLimit;
AutoStarFilter:=Source.AutoStarFilter;
AutoStarFilterMag:=Source.AutoStarFilterMag;
for i:=0 to MaxField do StarMagFilter[i]:=Source.StarMagFilter[i];
for i:=0 to MaxField do NebMagFilter[i]:=Source.NebMagFilter[i];
for i:=0 to MaxField do NebSizeFilter[i]:=Source.NebSizeFilter[i];
for i:=0 to MaxField do HourGridSpacing[i]:=Source.HourGridSpacing[i];
for i:=0 to MaxField do DegreeGridSpacing[i]:=Source.DegreeGridSpacing[i];
ShowCRose:=Source.ShowCRose ;
CRoseSz:=Source.CRoseSz ;
EquinoxType:=Source.EquinoxType;
DefaultJDchart:=Source.DefaultJDchart;
EquinoxChart:=Source.EquinoxChart;
AzNorth:=Source.AzNorth;
ListNeb:=Source.ListNeb;
ListStar:=Source.ListStar;
ListVar:=Source.ListVar;
ListDbl:=Source.ListDbl;
ListPla:=Source.ListPla;
ConstelNum:=Source.ConstelNum;
Setlength(ConstelName,ConstelNum);
Setlength(ConstelPos,ConstelNum);
for i:=0 to ConstelNum-1 do begin
  for j:=1 to 2 do ConstelName[i,j]:=Source.ConstelName[i,j];
  ConstelPos[i].ra:=Source.ConstelPos[i].ra;
  ConstelPos[i].de:=Source.ConstelPos[i].de;
end;
ConstBnum:=Source.ConstBnum;
Setlength(ConstB,ConstBnum);
for i:=0 to ConstBnum-1 do begin
  ConstB[i].ra:=Source.ConstB[i].ra;
  ConstB[i].de:=Source.ConstB[i].de;
  ConstB[i].newconst:=Source.ConstB[i].newconst;
end;
ConstLnum:=Source.ConstLnum;
Setlength(ConstL,ConstLnum);
for i:=0 to ConstLnum-1 do begin
  ConstL[i].ra1:=Source.ConstL[i].ra1;
  ConstL[i].de1:=Source.ConstL[i].de1;
  ConstL[i].ra2:=Source.ConstL[i].ra2;
  ConstL[i].de2:=Source.ConstL[i].de2;
end;
StarNameNum:=Source.StarNameNum;
Setlength(StarName,StarNameNum);
Setlength(StarNameHR,StarNameNum);
for i:=0 to StarNameNum-1 do begin
  StarName[i]:=Source.StarName[i];
  StarNameHR[i]:=Source.StarNameHR[i];
end;
for i:=0 to 360 do horizonlist[i]:=Source.horizonlist[i];
end;

{ Tconf_skychart }

constructor Tconf_skychart.Create;
begin
  Inherited Create;
  tz:=TCdCTimeZone.Create;
end;

destructor Tconf_skychart.Destroy;
begin
  SetLength(AsteroidLst,0);
  SetLength(CometLst,0);
  SetLength(AsteroidName,0);
  SetLength(CometName,0);
  tz.Free;
  Inherited Destroy;
end;

procedure Tconf_skychart.Assign(Source: Tconf_skychart);
var i,j,k : integer;
begin
tz.Assign(Source.tz);
racentre:=Source.racentre ;
decentre:=Source.decentre ;
fov:=Source.fov ;
theta:=Source.theta ;
acentre:=Source.acentre ;
hcentre:=Source.hcentre ;
lcentre:=Source.lcentre ;
bcentre:=Source.bcentre ;
lecentre:=Source.lecentre ;
becentre:=Source.becentre ;
e:=Source.e ;
nutl:=Source.nutl ;
nuto:=Source.nuto ;
sunl:=Source.sunl ;
sunb:=Source.sunb ;
abe:=Source.abe ;
abp:=Source.abp ;
raprev:=Source.raprev ;
deprev:=Source.deprev ;
Force_DT_UT:=Source.Force_DT_UT ;
horizonopaque:=Source.horizonopaque ;
autorefresh:=Source.autorefresh ;
TrackOn:=Source.TrackOn ;
Quick:=Source.Quick ;
NP:=Source.NP ;
SP:=Source.SP ;
moved:=Source.moved ;
projtype:=Source.projtype ;
FlipX:=Source.FlipX ;
FlipY:=Source. FlipY;
ProjPole:=Source.ProjPole ;
TrackType:=Source.TrackType ;
TrackObj:=Source.TrackObj ;
AstSymbol:=Source.AstSymbol ;
ComSymbol:=Source.ComSymbol ;
SimNb:=Source.SimNb ;
SimD:=Source.SimD ;
SimH:=Source.SimH ;
SimM:=Source.SimM ;
SimS:=Source.SimS ;
SimLabel:=Source.SimLabel ;
SimLine:=Source.SimLine ;
SimDateLabel:=Source.SimDateLabel ;
SimDateYear:=Source.SimDateYear;
SimDateMonth:=Source.SimDateMonth;
SimDateDay:=Source.SimDateDay;
SimDateHour:=Source.SimDateHour;
SimDateMinute:=Source.SimDateMinute;
SimDateSecond:=Source.SimDateSecond;
SimNameLabel:=Source.SimNameLabel ;
SimMagLabel:=Source.SimMagLabel ;
ShowPlanet:=Source.ShowPlanet ;
PlanetParalaxe:=Source.PlanetParalaxe ;
ShowEarthShadow:=Source.ShowEarthShadow ;
ShowAsteroid:=Source.ShowAsteroid ;
ShowComet:=Source.ShowComet ;
ObsLatitude:=Source.ObsLatitude;
ObsLongitude:=Source.ObsLongitude ;
ObsAltitude:=Source.ObsAltitude ;
ObsTZ:=Source.ObsTZ ;
countrytz:=Source.countrytz;
ObsTemperature:=Source.ObsTemperature ;
ObsPressure:=Source.ObsPressure ;
ObsRefractionCor:=Source.ObsRefractionCor ;
ObsHorizonDepression:=Source.ObsHorizonDepression ;
ObsName:=Source.ObsName ;
ObsCountry:=Source.ObsCountry ;
chartname:=Source.chartname ;
ast_day:=Source.ast_day ;
ast_daypos:=Source.ast_daypos ;
com_day:=Source.com_day ;
com_daypos:=Source.com_daypos ;
CurYear:=Source.CurYear ;
CurMonth:=Source.CurMonth ;
CurDay:=Source.CurDay ;
DrawPMyear:=Source.DrawPMyear ;
ShowPluto:=Source.ShowPluto ;
ShowConstl:=Source.ShowConstl ;
ShowConstB:=Source.ShowConstB ;
ShowEqGrid:=Source.ShowEqGrid ;
ShowGrid:=Source.ShowGrid ;
ShowGridNum:=Source.ShowGridNum ;
UseSystemTime:=Source.UseSystemTime ;
StyleGrid:=Source.StyleGrid ;
StyleEqGrid:=Source.StyleEqGrid ;
StyleConstL:=Source.StyleConstL ;
StyleConstB:=Source.StyleConstB ;
StyleEcliptic:=Source.StyleEcliptic ;
StyleGalEq:=Source.StyleGalEq ;
ShowEcliptic:=Source.ShowEcliptic ;
ShowGalactic:=Source.ShowGalactic ;
ShowMilkyWay:=Source.ShowMilkyWay;
FillMilkyWay:=Source.FillMilkyWay ;
ShowHorizon:=Source.ShowHorizon ;
FillHorizon:=Source.FillHorizon ;
ShowHorizonDepression:=Source.ShowHorizonDepression ;
CurTime:=Source.CurTime ;
DT_UT_val:=Source.DT_UT_val ;
GRSlongitude:=Source.GRSlongitude ;
TelescopeTurnsX:=Source.TelescopeTurnsX ;
TelescopeTurnsY:=Source.TelescopeTurnsY ;
PMon:=Source.PMon ;
DrawPMon:=Source.DrawPMon ;
ApparentPos:=Source.ApparentPos ;
CoordExpertMode:=Source.CoordExpertMode;
CoordType:=Source.CoordType;
LabelOrientation:=Source.LabelOrientation ;
ManualTelescopeType:=Source.ManualTelescopeType ;
IndiServerHost:=Source.IndiServerHost ;
IndiServerPort:=Source.IndiServerPort ;
IndiServerCmd:=Source.IndiServerCmd ;
IndiDriver:=Source.IndiDriver ;
IndiPort:=Source.IndiPort ;
IndiDevice:=Source.IndiDevice ;
ScopePlugin:=Source.ScopePlugin ;
IndiAutostart:=Source.IndiAutostart ;
ShowCircle:=Source.ShowCircle ;
IndiTelescope:=Source.IndiTelescope ;
PluginTelescope:=Source.PluginTelescope ;
ManualTelescope:=Source.ManualTelescope ;
ShowImages:=Source.ShowImages ;
ShowBackgroundImage:=Source.ShowBackgroundImage ;
showstars:=Source.showstars ;
shownebulae:=Source.shownebulae ;
showline:=Source.showline ;
showlabelall:=Source.showlabelall ;
Editlabels:=Source.Editlabels ;
BackgroundImage:=Source.BackgroundImage ;
HorizonMax:=Source.HorizonMax ;
rap2000:=Source.rap2000 ;
dep2000:=Source.dep2000 ;
RefractionOffset:=Source.RefractionOffset ;
WindowRatio:=Source.WindowRatio ;
BxGlb:=Source.BxGlb ;
ByGlb:=Source.ByGlb ;
AxGlb:=Source.AxGlb ;
AyGlb:=Source.AyGlb ;
sintheta:=Source.sintheta ;
costheta:=Source.costheta ;
x2:=Source.x2 ;
Xwrldmin:=Source.Xwrldmin ;
Xwrldmax:=Source.Xwrldmax ;
Ywrldmin:=Source.Ywrldmin ;
Ywrldmax:=Source.Ywrldmax ;
xmin:=Source.xmin ;
xmax:=Source.xmax ;
ymin:=Source.ymin ;
ymax:=Source.ymax ;
xshift:=Source.xshift ;
yshift:=Source.yshift ;
FieldNum:=Source.FieldNum ;
winx:=Source.winx ;
winy:=Source.winy ;
wintop:=Source.wintop ;
winleft:=Source.winleft ;
LeftMargin:=Source.LeftMargin ;
RightMargin:=Source.RightMargin ;
TopMargin:=Source.TopMargin ;
BottomMargin:=Source.BottomMargin ;
Xcentre:=Source.Xcentre ;
Ycentre:=Source.Ycentre ;
ObsRoSinPhi:=Source.ObsRoSinPhi ;
ObsRoCosPhi:=Source.ObsRoCosPhi ;
StarmagMax:=Source.StarmagMax;
NebMagMax:=Source.NebMagMax ;
FindPM:=Source.FindPM ;
FindRA:=Source.FindRA ;
FindDec:=Source.FindDec ;
FindSize:=Source.FindSize ;
AstmagMax:=Source.AstmagMax ;
AstMagDiff:=Source.AstMagDiff ;
CommagMax:=Source.CommagMax ;
Commagdiff:=Source.Commagdiff ;
TimeZone:=Source.TimeZone ;
DT_UT:=Source.DT_UT ;
CurST:=Source.CurST ;
CurJD:=Source.CurJD ;
LastJD:=Source.LastJD ;
jd0:=Source.jd0 ;
JDChart:=Source.JDChart ;
YPmon:=Source.YPmon;
LastJDChart:=Source.LastJDChart ;
CurSunH:=Source.CurSunH ;
CurMoonH:=Source.CurMoonH ;
CurMoonIllum:=Source.CurMoonIllum ;
ScopeRa:=Source.ScopeRa ;
ScopeDec:=Source.ScopeDec ;
TrackEpoch:=Source.TrackEpoch ;
TrackRA:=Source.TrackRA ;
TrackDec:=Source.TrackDec ;
StarFilter:=Source.StarFilter ;
NebFilter:=Source.NebFilter ;
FindOK:=Source.FindOK ;
WhiteBg:=Source.WhiteBg ;
MagLabel:=Source.MagLabel ;
NameLabel:=Source.NameLabel ;
ConstFullLabel:=Source.ConstFullLabel ;
ConstLatinLabel:=Source.ConstLatinLabel;
ScopeMark:=Source.ScopeMark ;
ScopeLock:=Source.ScopeLock ;
EquinoxName:=Source.EquinoxName ;
TrackName:=Source.TrackName ;
TrackId:=Source.TrackId ;
FindName:=Source.FindName ;
FindDesc:=Source.FindDesc ;
FindNote:=Source.FindNote ;
AsteroidNb:=Source.AsteroidNb ;
CometNb:=Source.CometNb ;
AsteroidLstSize:=Source.AsteroidLstSize ;
CometLstSize:=Source.CometLstSize ;
NumCircle:=Source.NumCircle ;
nummodlabels:=Source.nummodlabels ;
posmodlabels:=Source.posmodlabels ;
numcustomlabels:=Source.numcustomlabels ;
poscustomlabels:=Source.poscustomlabels ;
horizonlist:=Source.horizonlist ;

for i:=0 to 10 do projname[i] := Source.projname[i];
for i:=1 to numlabtype do begin
   ShowLabel[i]:=Source.ShowLabel[i];
   LabelMagDiff[i]:=Source.LabelMagDiff[i];
end;
for i:=1 to 10 do circle[i,1]:=Source.circle[i,1];
for i:=1 to 10 do circle[i,2]:=Source.circle[i,2];
for i:=1 to 10 do circle[i,3]:=Source.circle[i,3];
for i:=1 to 10 do circleok[i]:=Source.circleok[i];
for i:=1 to 10 do circlelbl[i]:=Source.circlelbl[i];
for i:=1 to 10 do rectangle[i,1]:=Source.rectangle[i,1];
for i:=1 to 10 do rectangle[i,2]:=Source.rectangle[i,2];
for i:=1 to 10 do rectangle[i,3]:=Source.rectangle[i,3];
for i:=1 to 10 do rectangle[i,4]:=Source.rectangle[i,4];
for i:=1 to 10 do rectangleok[i]:=Source.rectangleok[i];
for i:=1 to 10 do rectanglelbl[i]:=Source.rectanglelbl[i];
for i:=0 to Source.NumCircle-1 do
  for j:=1 to 2 do
    CircleLst[i,j]:=Source.CircleLst[i,j];
for i:=1 to Source.nummodlabels do begin
   modlabels[i].id:=Source.modlabels[i].id;
   modlabels[i].dx:=Source.modlabels[i].dx;
   modlabels[i].dy:=Source.modlabels[i].dy;
   modlabels[i].labelnum:=Source.modlabels[i].labelnum;
   modlabels[i].fontnum:=Source.modlabels[i].fontnum;
   modlabels[i].txt:=Source.modlabels[i].txt;
   modlabels[i].hiden:=Source.modlabels[i].hiden;
end;
for i:=1 to Source.numcustomlabels do begin
   customlabels[i].ra:=Source.customlabels[i].ra;
   customlabels[i].dec:=Source.customlabels[i].dec;
   customlabels[i].labelnum:=Source.customlabels[i].labelnum;
   customlabels[i].txt:=Source.customlabels[i].txt;
   customlabels[i].align:=Source.customlabels[i].align;
end;
for i:=1 to NumSimObject do SimObject[i]:=Source.SimObject[i];
for i:=0 to Source.SimNb-1 do
  for j:=1 to MaxPla do
    for k:=1 to 7 do
      PlanetLst[i,j,k]:=Source.PlanetLst[i,j,k];
SetLength(AsteroidLst,Source.SimNb);
for i:=0 to Source.SimNb-1 do
  for j:=1 to Source.AsteroidNb do
    for k:=1 to 5 do
      AsteroidLst[i,j,k]:=Source.AsteroidLst[i,j,k];
SetLength(CometLst,Source.SimNb);
for i:=0 to Source.SimNb-1 do
  for j:=1 to Source.CometNb do
    for k:=1 to 8 do
      CometLst[i,j,k]:=Source.CometLst[i,j,k];
SetLength(AsteroidName,Source.SimNb);
for i:=0 to Source.SimNb-1 do
  for j:=1 to Source.AsteroidNb do
    for k:=1 to 2 do
      AsteroidName[i,j,k]:=Source.AsteroidName[i,j,k];
SetLength(CometName,Source.SimNb);
for i:=0 to Source.SimNb-1 do
  for j:=1 to Source.CometNb do
    for k:=1 to 2 do
      CometName[i,j,k]:=Source.CometName[i,j,k];
end;

{ Tconf_plot }

constructor Tconf_plot.Create;
begin
  Inherited Create;
end;

destructor Tconf_plot.Destroy;
begin
  Inherited Destroy;
end;

procedure Tconf_plot.Assign(Source: Tconf_plot);
var i : integer;
begin
for i:=0 to Maxcolor do color[i]:=Source.color[i];
for i:=0 to 7 do skycolor[i]:=Source.skycolor[i];
backgroundcolor:=Source.backgroundcolor;
bgcolor:=Source.bgcolor;
stardyn:=Source.stardyn;
starsize:=Source.starsize;
prtres:=Source.prtres;
starplot:=Source.starplot;
nebplot:=Source.nebplot;
plaplot:=Source.plaplot;
Nebgray:=Source.Nebgray;
NebBright:=Source.NebBright;
starshapesize:=Source.starshapesize;
starshapew:=Source.starshapew;
Invisible:=Source.Invisible;
AutoSkycolor:=Source.AutoSkycolor;
TransparentPlanet:=Source.TransparentPlanet;
for i:=1 to numfont do begin
  FontName[i]:=Source.FontName[i];
  FontSize[i]:=Source.FontSize[i];
  FontBold[i]:=Source.FontBold[i];
  FontItalic[i]:=Source.FontItalic[i];
end;
for i:=1 to numlabtype do begin
  LabelColor[i]:=Source.LabelColor[i];
  LabelSize[i]:=Source.LabelSize[i];
end;

outradius:=Source.outradius;
contrast:=Source.contrast;
saturation:=Source.saturation;
xmin:=Source.xmin;
xmax:=Source.xmax;
ymin:=Source.ymin;
ymax:=Source.ymax;
red_move:=Source.red_move;
partsize:=Source.partsize;
magsize:=Source.magsize;
DSOColorFillAst:=Source.DSOColorFillAst;
DSOColorFillOCl:=Source.DSOColorFillOCl;
DSOColorFillGCl:=Source.DSOColorFillGCl;
DSOColorFillPNe:=Source.DSOColorFillPNe;
DSOColorFillDN:=Source.DSOColorFillDN;
DSOColorFillEN:=Source.DSOColorFillEN;
DSOColorFillRN:=Source.DSOColorFillRN;
DSOColorFillSN:=Source.DSOColorFillSN;
DSOColorFillGxy:=Source.DSOColorFillGxy;
DSOColorFillGxyCl:=Source.DSOColorFillGxyCl;
DSOColorFillQ:=Source.DSOColorFillQ;
DSOColorFillGL:=Source.DSOColorFillGL;
DSOColorFillNE:=Source.DSOColorFillNE;
end;

{ Tconf_chart }

constructor Tconf_chart.Create;
begin
  Inherited Create;
end;

destructor Tconf_chart.Destroy;
begin
  Inherited Destroy;
end;

procedure Tconf_chart.Assign(Source: Tconf_chart);
begin
onprinter:=Source.onprinter;
width:=Source.width;
height:=Source.height;
drawpen:=Source.drawpen;
drawsize:=Source.drawsize;
fontscale:=Source.fontscale;
hw:=Source.hw;
hh:=Source.hh;
min_ma:=Source.min_ma;
max_catalog_mag:=Source.max_catalog_mag;
end;

{ Tconf_main }

constructor Tconf_main.Create;
begin
  Inherited Create;
end;

destructor Tconf_main.Destroy;
begin
  if CometUrlList<>nil then CometUrlList.Free;
  if AsteroidUrlList<>nil then AsteroidUrlList.Free;
  Inherited Destroy;
end;

procedure Tconf_main.Assign(Source: Tconf_main);
var
  i: Integer;
begin
prtname:=Source.prtname;
language:=Source.language;
Constellationpath:=Source.Constellationpath;
ConstLfile:=Source.ConstLfile;
ConstBfile:=Source.ConstBfile;
EarthMapFile:=Source.EarthMapFile;
HorizonFile:=Source.HorizonFile;
Planetdir:=Source.Planetdir;
db:=Source.db;
dbhost:=Source.dbhost;
dbport:=Source.dbport;
dbuser:=Source.dbuser;
dbpass:=Source.dbpass;
ImagePath:=Source.ImagePath;
persdir:=Source.persdir;
prgdir:=Source.prgdir;
PrinterResolution:=Source.PrinterResolution;
PrintMethod:=Source.PrintMethod;
PrintColor:=Source.PrintColor;
configpage:=Source.configpage;
configpage_i:=Source.configpage_i;
configpage_j:=Source.configpage_j;
autorefreshdelay:=Source.autorefreshdelay;
MaxChildID:=Source.MaxChildID;
PrtLeftMargin:=Source.PrtLeftMargin;
PrtRightMargin:=Source.PrtRightMargin;
PrtTopMargin:=Source.PrtTopMargin;
PrtBottomMargin:=Source.PrtBottomMargin;
savetop:=Source.savetop;
saveleft:=Source.saveleft;
saveheight:=Source.saveheight;
savewidth:=Source.savewidth;
ButtonStandard:=Source.ButtonStandard;
ButtonNight:=Source.ButtonNight;
PrintLandscape:=Source.PrintLandscape;
ShowChartInfo:=Source.ShowChartInfo;
SyncChart:=Source.SyncChart;
maximized:=Source.maximized;
updall:=Source.updall;
AutostartServer:=Source.AutostartServer;
keepalive:=Source.keepalive;
NewBackgroundImage:=Source.NewBackgroundImage;
ServerIPaddr:=Source.ServerIPaddr;
ServerIPport:=Source.ServerIPport;
PrintCmd1:=Source.PrintCmd1;
PrintCmd2:=Source.PrintCmd2;
PrintTmpPath:=Source.PrintTmpPath;
ThemeName:=Source.ThemeName;
IndiPanelCmd:=Source.IndiPanelCmd;
ImageLuminosity:=Source.ImageLuminosity;
ImageContrast:=Source.ImageContrast;
ProxyHost:=Source.ProxyHost;
ProxyPort:=Source.ProxyPort;
ProxyUser:=Source.ProxyUser;
ProxyPass:=Source.ProxyPass;
AnonPass:=Source.AnonPass;
FtpPassive:=Source.FtpPassive;
HttpProxy:=Source.HttpProxy;
if CometUrlList=nil then CometUrlList:=TStringList.Create;
CometUrlList.Clear;
for i:=0 to Source.CometUrlList.Count-1 do CometUrlList.Add(Source.CometUrlList.Strings[i]);
if AsteroidUrlList=nil then AsteroidUrlList:=TStringList.Create;
AsteroidUrlList.Clear;
for i:=0 to Source.AsteroidUrlList.Count-1 do AsteroidUrlList.Add(Source.AsteroidUrlList.Strings[i]);
end;

{ Tconf_dss }

constructor Tconf_dss.Create;
begin
  Inherited Create;
end;

destructor Tconf_dss.Destroy;
begin
  Inherited Destroy;
end;

procedure Tconf_dss.Assign(Source: Tconf_dss);
var i,j: integer;
begin
dssdir:=Source.dssdir;
dssdrive:=Source.dssdrive;
dssfile:=Source.dssfile;
dss102:=Source.dss102;
dssnorth:=Source.dssnorth;
dsssouth:=Source.dsssouth;
dsssampling:=Source.dsssampling;
dssplateprompt:=Source.dssplateprompt;
dssmaxsize:=Source.dssmaxsize;
OnlineDSS:=Source.OnlineDSS;
OnlineDSSid:=Source.OnlineDSSid;
for i:=1 to MaxDSSurl do
  for j:=0 to 1 do
    DSSurl[i,j]:=Source.DSSurl[i,j];
end;

end.

