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

interface

uses Types, libcatalog,
{$ifdef linux}
    QGraphics;
{$endif}
{$ifdef mswindows}
    Graphics;
{$endif}

const MaxColor = 32;

type Starcolarray =  Array [0..Maxcolor] of Tcolor; // 0:sky, 1-10:object, 11:not sky, 12:AzGrid, 13:EqGrid, 14:orbit, 15:misc, 16:constl, 17:constb, 18:eyepiece, 19:horizon, 20:asteroid
     TSkycolor = array[1..7]of Tcolor;

const version = 'Version 3 alpha 0.0.4';
      ver     = '3.0.0.4';
      MaxSim = 100 ;
      MaxComet = 1000;
      MaxAsteroid = 1000;
      MaxPla = 32;
      MaxQuickSearch = 15;
      MaxWindow = 10;  // maximum number of chart window 
      crRetic = 5;
      jd2000 =2451545.0 ;
      jd1950 =2433282.4235;
      jd1900 =2415020.3135;
      km_au = 149597870.691 ;
      clight = 299792.458 ;
      tlight = km_au/clight/3600/24;
      eps2000 = 23.439291111;
      deg2rad = pi/180;
      rad2deg = 180/pi;
      pi2 = 2*pi;
      pi4 = 4*pi;
      pid2 = pi/2;
      minarc = deg2rad/60;
      secarc = deg2rad/3600;
      musec  = deg2rad/3600/1000000; // 1 microarcsec for rounding test
      FovMin = 5*secarc;  // 5"
      FovMax = pi2;
      DefaultPrtRes = 300;
      DfColor : Starcolarray = (clBlack,$00EF9883,$00EBDF74,$00ffffff,$00CAF9F9,$008AF2EB,$008EBBF2,$006271FB,$000000ff,$00ffff00,$0000ff00,clWhite,clGray,clGray,clYellow,clGray,clSilver,clBlue,clRed,clGreen,clYellow,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite);
      DfBWColor : Starcolarray = (clBlack,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clBlack,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite,clWhite);
      DfRedColor : Starcolarray = (clBlack,$00ff00ff,$00a060ff,$008080ff,$0060a0ff,$004080ff,$006060ff,$000000ff,$000000ff,$00ff00ff,$008080ff,$000000ff,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,clYellow,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0,$000000A0);
      DfWBColor : Starcolarray = (clWhite,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clWhite,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack,clBlack);
      dfskycolor : Tskycolor = ($00f03c3c,$00c83232,$00a02828,$00780000,$00640010,$003c0010,$00000000);
      crlf = chr(13)+chr(10);
      greek : array[1..2,1..24]of string=(('Alpha','Beta','Gamma','Delta','Epsilon','Zeta','Eta','Theta','Iota','Kappa','Lambda','Mu','Nu','Xi','Omicron','Pi','Rho','Sigma','Tau','Upsilon','Phi','Chi','Psi','Omega'),
              ('alp','bet','gam','del','eps','zet','eta','the','iot','kap','lam','mu','nu','xi','omi','pi','rho','sig','tau','ups','phi','chi','psi','ome'));
      greeksymbol : array[1..2,1..24]of string=(('alp','bet','gam','del','eps','zet','eta','the','iot','kap','lam','mu','nu','xi','omi','pi','rho','sig','tau','ups','phi','chi','psi','ome'),
                  ('a','b','g','d','e','z','h','q','i','k','l','m','n','x','o','p','r','s','t','u','f','c','y','w'));
      pla : array[1..32] of string[8] = ('Mercury ','Venus   ','*       ','Mars    ','Jupiter ',
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
      f2='0.00';
      f5='0.00000';
      ConstelNum = 88;
      NumLlabel = 100;
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

{$ifdef linux}
      DefaultFontName='Helvetica';
      DefaultFontSize=10;
      Defaultconfigfile='~/.cartesduciel.ini';     // to user home directory
      key_cr = 4100;
      key_plus =43;
      key_minus=45;
      key_left =4114;
      key_right=4116;
      key_up   =4115;
      key_down =4117;
      key_upleft =4112;
      key_upright=4118;
      key_downleft=4113;
      key_downright =4119;
{$endif}
{$ifdef mswindows}
      DefaultFontName='MS Sans Serif';
      DefaultFontSize=8;
      Defaultconfigfile='cartesduciel.ini';      // to user profile directory or C:\windows
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
{$endif}

type
     Tplanetlst = array[0..MaxSim,1..MaxPla,1..7] of double; // 1..9 : planet ; 10 : soleil ; 11 : lune ; 12..15 : jup sat ; 16..23 : sat sat ; 24..28 : ura sat ; 29..30 : mar sat ; 31 : sat ring ; 32 : earth umbra ;
     Tcometlst = array[0..MaxSim,1..MaxComet,1..7] of double;
     Tasteroidlst = array[0..MaxSim,1..MaxAsteroid] of record
                    ra,dec,jd,magn,epoch: double;
                    id: string;
                    end;
     double6 = array[1..6] of double;
     Pdouble6 = ^double6;
     Tconstb = record ra,de : single; newconst:boolean; end;
     Tconstl = record ra1,de1,ra2,de2 : single; end;
     TLabelAlign = (laNone,laTop,laBottom,laLeft,laRight,laCenter);
     Thorizonlist = array [0..360] of single;
     Phorizonlist = ^Thorizonlist;

     TGCatLst =  record
                    min, max, magmax : single;
                    cattype:integer;
                    Actif,CatOn : boolean;
                    shortname, name, path, version : string;
                 end;
     conf_catalog = record
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
     conf_shared = record
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
                EquinoxType : integer;
                DefaultJDchart : double;
                EquinoxChart : string;
                AzNorth : Boolean;
                llabel: array[1..NumLlabel] of string;
                ConstelName: array[1..ConstelNum,1..2] of string; // constellation name and three letter abbrev.
                ConstLnum,ConstBnum:integer;
                ConstL: array of Tconstl;
                ConstB : array of Tconstb;
                horizonlist : Thorizonlist;
                ListNeb,ListStar,ListVar,ListDbl,ListPla : boolean;
                end;
     conf_skychart = record
                // chart setting
                racentre,decentre,fov,theta,acentre,hcentre,lcentre,bcentre,lecentre,becentre,e : double;
                Force_DT_UT,horizonopaque,autorefresh,TrackOn,Quick,NP,SP : Boolean;
                projtype : char;
                projname : array [0..MaxField] of string[3];
                FlipX, FlipY, ProjPole, TrackType,TrackObj, AstSymbol : integer;
                SimNb,SimD,SimH,SimM,SimS : Integer;
                SimObject: array[1..NumSimObject] of boolean;
                SimLine,ShowPlanet,PlanetParalaxe,ShowEarthShadow,ShowAsteroid,ShowComet : Boolean;
                ObsLatitude,ObsLongitude,ObsAltitude,ObsTZ : double;
                ObsTemperature,ObsPressure,ObsRefractionCor : Double;
                ObsName,ObsCountry,chartname,table_day,table_daypos : string;
                CurYear,CurMonth,CurDay,DrawPMyear : integer;
                ShowConstl,ShowConstB,ShowEqGrid,ShowGrid,ShowGridNum,UseSystemTime : boolean;
                ShowEcliptic,ShowGalactic,ShowMilkyWay,FillMilkyWay : boolean;
                CurTime,DT_UT_val,GRSlongitude: double;
                PMon,DrawPMon : boolean; // use proper motion
                LabelOrientation: integer;
                // working variable
                HorizonMax,rap2000,dep2000,RefractionOffset : Double;
                WindowRatio,BxGlb,ByGlb,AxGlb,AyGlb,sintheta,costheta,x2: Double;
                Xwrldmin,Xwrldmax,Ywrldmin,Ywrldmax: Double;
                xmin,xmax,ymin,ymax,xshift,yshift,FieldNum,winx,winy : integer;
                LeftMargin,RightMargin,TopMargin,BottomMargin,Xcentre,Ycentre: Integer;
                ObsRoSinPhi,ObsRoCosPhi,StarmagMax,NebMagMax,FindRA,FindDec,FindSize,AstmagMax,AstMagDiff : double;
                TimeZone,DT_UT,CurST,CurJD,LastJD,jd0,JDChart,LastJDChart,CurSunH,CurMoonH,CurMoonIllum : Double;
                StarFilter,NebFilter,FindOK,WhiteBg : boolean;
                EquinoxName,EquinoxDate,TrackName,FindName,FindDesc,FindNote : string;
                PlanetLst : Tplanetlst;
                AsteroidNb: integer;
                AsteroidLst: Tasteroidlst;
                horizonlist : Phorizonlist;
                end;
     conf_plot = record
                color : Starcolarray;
                skycolor : TSkycolor;
                backgroundcolor,bgcolor : Tcolor;
                stardyn,starsize,prtres,starplot,nebplot,plaplot : integer;
                Nebgray,NebBright,starshapesize,starshapew : integer;
                Invisible,PlanetTransparent,AutoSkycolor : boolean;
                FontName : array [1..6] of string;
                FontSize : array [1..6] of integer;
                FontBold : array [1..6] of boolean;
                FontItalic : array [1..6] of boolean;
                LabelColor : array[1..9] of Tcolor;
                LabelSize : array[1..9] of integer;
                outlineclosed,outlineinscreen: boolean;
                outlinetype,outlinemax,outlinenum,outlinelw: integer;
                outlinecol: Tcolor;
                outlinepts: array of TPoint;
                outradius:integer;
                end;
     conf_chart = record
                onprinter : boolean;
                width,height,drawpen,hw,hh : integer;
                min_ma : double;
                end;
     conf_main = record
                prtname,language,ConstLfile, ConstBfile, EarthMapFile, HorizonFile : string;
                db,dbhost,dbuser,dbpass : string;
                PrinterResolution,configpage,autorefreshdelay,MaxChildID,dbport : integer;
                PrintColor,PrintLandscape :boolean;
                maximized,updall,AutostartServer,keepalive,locked : boolean;
                ServerIPaddr,ServerIPport : string;
                end;

// external library
const
{$ifdef linux}
      lib404   = 'libplan404.so';
      libsatxy = 'libsatxy.so';
      libsatxyfm='Satxyfm';
{$endif}
{$ifdef mswindows}
      lib404 = 'libplan404.dll';
      libsatxy = 'libsatxy.dll';
      libsatxyfm='Satxyfm';
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
Function Plan404( pla : PPlanetData):integer; cdecl; external lib404;

// libsatxy
type double8 = array[1..8] of double;
     Pdouble8 = ^double8;
     TSatxyfm = Function(djc : double; ipla : integer; Pxx,Pyy : Pdouble8):integer; stdcall;


Var  Appdir, Configfile: string;         // pseudo-constant only here
     ldeg,lmin,lsec : string;
{$ifdef linux}
     tracefile:string ='~/cdc_trace.txt';
{$endif}
{$ifdef mswindows}
     tracefile:string ='cdc_trace.txt';
{$endif}

// Text formating constant
const
{$ifdef linux}
     html_h        = '<HTML>';
     htms_h        = '</HTML>';
     html_ffx      = '<font face="fixed">';
     htms_f        = '</font>';
     html_b        = '<b>';
     htms_b        = '</b>';
     html_h2       = '<h2>';
     htms_h2       = '</h2>';
     html_p        = '<p>';
     htms_p        = '</p>';
     html_br       = '<br>';
     html_sp       = '&nbsp;';
{$endif}
{$ifdef mswindows}
// D6 Personal as no html viewer, so using RTF instead
     html_h        = '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 MS Sans Serif;}{\f1\fnil MS Sans Serif;}{\f2\fmodern\fprq1\fcharset0 Courier New;}{\f3\fmodern\fprq1 Courier New;}}\f0\fs18';
     htms_h        = '}';
     html_ffx      = '\pard\f2\fs18 ';
     htms_f        = '\pard\f0\fs18 ';
     html_b        = '\b ';
     htms_b        = '\b0 ';
     html_h2       = '\pard\f0\fs24\b ';
     htms_h2       = '\pard\f0\fs18\b0\par ';
     html_p        = '\par ';
     htms_p        = '';
     html_br       = '\line ';
     html_sp       = ' ';
{$endif}

const msgTimeout='Timeout!';
      msgOK='OK!';
      msgFailed='Failed!';
      msgNotFound='Not found!';

      msgBye='Bye!';

// Main Commands
const
     MaxCmdArg = 10;
     numcmdmain = 8;
     maincmdlist: array[1..numcmdmain,1..2] of string=(
     ('NEWCHART','1'),
     ('CLOSECHART','2'),
     ('SELECTCHART','3'),
     ('LISTCHART','4'),
     ('SEARCH','5'),
     ('GETMSGBOX','6'),
     ('GETCOORBOX','7'),
     ('GETINFOBOX','8')
     );

// Chart Commands
const
     numcmd = 54;
     cmdlist: array[1..numcmd,1..2] of string=(
     ('ZOOM+','1'),
     ('ZOOM-','2'),
     ('MOVEEAST','3'),
     ('MOVEWEST','4'),
     ('MOVENORTH','5'),
     ('MOVESOUTH','6'),
     ('MOVENORTHEAST','7'),
     ('MOVENORTHWEST','8'),
     ('MOVESOUTHEAST','9'),
     ('MOVESOUTHWEST','10'),
     ('FLIPX','11'),
     ('FLIPY','12'),
     ('SETCURSOR','13'),     // pixX pixY
     ('CENTRECURSOR','14'),
     ('ZOOM+MOVE','15'),
     ('ZOOM-MOVE','16'),
     ('ROT+','17'),
     ('ROT-','18'),
     ('SETEQGRID','19'),       // ON/OFF
     ('SETGRID','20'),         // ON/OFF
     ('SETSTARMODE','21'),     // 0/1
     ('SETNEBMODE','22'),      // 0/1
     ('SETAUTOSKY','23'),      // ON/OFF
     ('UNDO','24'),
     ('REDO','25'),
     ('SETPROJ','26'),         // ALTAZ/EQUAT/GALACTIC/ECLIPTIC
     ('SETFOV','27'),          // 00d00m00s/00.00
     ('SETRA','28'),           // RA:00h00m00s/00.00
     ('SETDEC','29'),          // DEC:+00d00m00s/00.00
     ('SETOBS','30'),          // LAT:+00d00m00sLON:+000d00m00sALT:000mOBS:name
     ('IDCURSOR','31'),
     ('SAVEIMG','32'),         // PNG/JPEG/BMP filename quality
     ('SETNORTH','33'),
     ('SETSOUTH','34'),
     ('SETEAST','35'),
     ('SETWEST','36'),
     ('SETZENITH','37'),
     ('ALLSKY','38'),
     ('REDRAW','39'),
     ('GETCURSOR','40'),
     ('GETEQGRID','41'),
     ('GETGRID','42'),
     ('GETSTARMODE','43'),
     ('GETNEBMODE','44'),
     ('GETAUTOSKY','45'),
     ('GETPROJ','46'),
     ('GETFOV','47'),          // S/F
     ('GETRA','48'),           // S/F
     ('GETDEC','49'),          // S/F
     ('GETDATE','50'),
     ('GETOBS','51'),
     ('SETDATE','52'),         // yyyy-mm-ddThh:mm:ss
     ('SETTZ','53'),           // 0.0
     ('GETTZ','54')
     );

// MySQL Table structure
const
create_table_ast_day=' ( jd int(11) NOT NULL default "0", limit_mag smallint(6) NOT NULL default "0") TYPE=MyISAM';
create_table_ast_day_pos='( id varchar(7) NOT NULL default "", epoch double NOT NULL default "0",'+
                         'ra smallint(6) NOT NULL default "0",  de smallint(6) NOT NULL default "0",'+
                         'mag smallint(6) NOT NULL default "0",  PRIMARY KEY  (ra,de,mag),'+
                         'UNIQUE KEY name (id,epoch)) TYPE=MyISAM';
numsqltable=4;
sqltable : array[1..numsqltable,1..2] of string =(
           ('cdc_ast_name',' ( id varchar(7) binary NOT NULL default "0", name varchar(27) NOT NULL default "",'+
                           'PRIMARY KEY (id)) TYPE=MyISAM'),
           ('cdc_ast_elem_list',' ( elem_id smallint(6) NOT NULL default "0", filedesc varchar(80) NOT NULL default "",'+
                           'PRIMARY KEY (elem_id)) TYPE=MyISAM'),
           ('cdc_ast_elem',' ( id varchar(7) binary NOT NULL default "0",'+
                           'h double NOT NULL default "0", g double NOT NULL default "0",'+
                           'epoch double NOT NULL default "0", mean_anomaly double NOT NULL default "0",'+
                           'arg_perihelion double NOT NULL default "0", asc_node double NOT NULL default "0",'+
                           'inclination double NOT NULL default "0", eccentricity double NOT NULL default "0",'+
                           'semi_axis double NOT NULL default "0", ref varchar(10) binary NOT NULL default "",'+
                           'name varchar(27) NOT NULL default "", equinox smallint(4) NOT NULL default "0",'+
                           'elem_id smallint(6) NOT NULL default "0", PRIMARY KEY (id,epoch)) TYPE=MyISAM'),
           ('cdc_ast_mag',' ( id varchar(7) binary NOT NULL default "",'+
                          'jd double NOT NULL default "0", epoch double NOT NULL default "0",'+
                          'mag smallint(6) NOT NULL default "0", elem_id smallint(6) NOT NULL default "0",'+
                          'PRIMARY KEY (jd,id), KEY ast_mag_idx  (mag)) TYPE=MyISAM'));

// World cities
// must equate cities.h
const
   COUNTRIES      = 234;  // number of countries
   MAX_CITY_LENGTH= 120;  // length of longest city name (including '\0')
   {$ifdef linux}
   citylib = 'libCities.so';
   {$endif}
   {$ifdef mswindows}
   citylib = 'Cities.dll';
   {$endif}

type
   City = record
          m_Name: array[0..MAX_CITY_LENGTH-1] of char;  // city name
	  m_Coord: array[0..1] of integer;              // geogr. latitude and longitude
          end;
   Cities = array[0..999999] of City; // never allocate!
   PCity = ^City;
   PCities = ^Cities;

const Country: array[0..COUNTRIES-1] of string =(
	'Afghanistan',
	'Albania',
	'Algeria',
	'Andorra',
	'Angola',
	'Anguilla',
	'Antigua and Barbuda',
	'Argentina',
	'Armenia',
	'Aruba',
	'Australia',
	'Austria',
	'Azerbaijan',
	'Bahamas, The',
	'Bahrain',
	'Bangladesh',
	'Barbados',
	'Belarus',
	'Belgium',
	'Belize',
	'Benin',
	'Bermuda',
	'Bhutan',
	'Bolivia',
	'Bosnia and Herzegovina',
	'Botswana',
	'Brazil',
	'British Virgin Islands',
	'Brunei',
	'Bulgaria',
	'Burkina Faso',
	'Burma',
	'Burundi',
	'Cambodia',
	'Cameroon',
	'Canada',
	'Cap Verde',
	'Cayman Islands',
	'Central African Republic',
	'Chad',
	'Chile',
	'China',
	'Chistmas Island',
	'Cocos (Keeling) Islands',
	'Colombia',
	'Comoros',
	'Congo',
	'Congo, Democratic Republic of The',
	'Cook Islands',
	'Costa Rica',
	'Cote d''Ivoire',
	'Croatia',
	'Cuba',
	'Cyprus',
	'Czech Republic',
	'Denmark',
	'Djibouti',
	'Dominica',
	'Dominican Republic',
	'East Timor',
	'Ecuador',
	'Egypt',
	'El Salvador',
	'Equatorial Guinea',
	'Eritrea',
	'Estonia',
	'Ethiopia',
	'Falkland Islands',
	'Faroe Islands',
	'Fiji',
	'Finland',
	'France',
	'French Guiana',
	'French Polynesia',
	'French Southern and Antarctic Lands',
	'Gabon',
	'Gambia, The',
	'Gaza Strip',
	'Georgia',
	'Germany',
	'Ghana',
	'Gibraltar',
	'Greece',
	'Greenland',
	'Grenada',
	'Guadeloupe',
	'Guatemala',
	'Guernsey',
	'Guinea',
	'Guinea-Bisseau',
	'Guyana',
	'Haiti',
	'Honduras',
	'Hong Kong',
	'Hungary',
	'Iceland',
	'India',
	'Indonesia',
	'Iran',
	'Iraq',
	'Ireland',
	'Isle of Man',
	'Israel',
	'Italy',
	'Jamaica',
	'Japan',
	'Jersey',
	'Jordan',
	'Kazakhstan',
	'Kenya',
	'Kiribati',
	'Kuwait',
	'Kyrgyzstan',
	'Laos',
	'Latvia',
	'Lebanon',
	'Lesotho',
	'Liberia',
	'Libya',
	'Liechtenstein',
	'Lithuania',
	'Luxembourg',
	'Macau',
	'Macedonia, The Former Yugoslav Republic of',
	'Madagascar',
	'Malawi',
	'Malaysia',
	'Maldives',
	'Mali',
	'Malta',
	'Marshall Islands',
	'Martinique',
	'Mauritania',
	'Mauritius',
	'Mayotte',
	'Mexico',
	'Micronesia, Federated States of',
	'Moldova',
	'Monaco',
	'Mongolia',
	'Montserrat',
	'Morocco',
	'Mozambique',
	'Namibia',
	'Nauru',
	'Nepal',
	'Netherlands',
	'Netherlands Antilles',
	'New Caledonia',
	'New Zealand',
	'Nicaragua',
	'Niger',
	'Nigeria',
	'Niue',
	'No Man''s Land',
	'Norfolk Island',
	'North Korea',
	'Norway',
	'Oman',
	'Pakistan',
	'Palau',
	'Panama',
	'Papua New Guinea',
	'Paraguay',
	'Peru',
	'Philippines',
	'Pitcairn Islands',
	'Poland',
	'Portugal',
	'Qatar',
	'Reunion',
	'Romania',
	'Russia',
	'Rwanda',
	'Saint Helena',
	'Saint Kitts and Nevis',
	'Saint Lucia',
	'Saint Pierre and Miquelon',
	'Saint Vincent and the Grenadines',
	'Samoa',
	'San Marino',
	'Sao Tome and Principe',
	'Saudi Arabia',
	'Senegal',
	'Seychelles',
	'Sierra Leone',
	'Singapore',
	'Slovakia',
	'Slovenia',
	'Solomon Islands',
	'Somalia',
	'South Africa',
	'South Georgia and The South Sandwich Islands',
	'South Korea',
	'Spain',
	'Spratly Islands',
	'Sri Lanka',
	'Sudan',
	'Suriname',
	'Svalbard',
	'Swaziland',
	'Sweden',
	'Switzerland',
	'Syria',
	'Taiwan',
	'Tajikistan',
	'Tanzania',
	'Thailand',
	'Togo',
	'Tokelau',
	'Tonga',
	'Trinidad and Tobago',
	'Tunisia',
	'Turkey',
	'Turkmenistan',
	'Turks and Caicos Islands',
	'Tuvalu',
	'Uganda',
	'Ukraine',
	'United Arab Emirates',
	'United Kingdom',
	'United States of America',
	'Uruguay',
	'Uzbekistan',
	'Vanuatu',
	'Venezuela',
	'Vietnam',
	'Wallis and Futuna',
	'West Bank',
	'Western Sahara',
	'Yemen',
	'Yugoslavia',
	'Zambia',
	'Zimbabwe');


implementation

end.

