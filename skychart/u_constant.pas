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

uses libcatalog,
{$ifdef linux}
    QGraphics;
{$endif}
{$ifdef mswindows}
    Graphics;
{$endif}

type Starcolarray =  Array [0..11] of Tcolor;
     TSkycolor = array[1..7]of Tcolor;

const version = 'Version 3 alpha 0.0.2';
      MaxSim = 100 ;
      MaxComet = 500;
      MaxAsteroid = 500;
      MaxPla = 32;
      MaxQuickSearch = 15;
      FovMin = 9.6963E-6;  // 2"
      FovMax = 2*pi;
      jd2000 : double =2451545.0 ;
      jd1950 : double =2433282.4235;
      deg2rad = pi/180;
      rad2deg = 180/pi;
      crlf=chr(10)+chr(13);
      greek : array[1..2,1..24]of string=(('Alpha','Beta','Gamma','Delta','Epsilon','Zeta','Eta','Theta','Iota','Kappa','Lambda','Mu','Nu','Xi','Omicron','Pi','Rho','Sigma','Tau','Upsilon','Phi','Chi','Psi','Omega'),
              ('alp','bet','gam','del','eps','zet','eta','the','iot','kap','lam','mu','nu','xi','omi','pi','rho','sig','tau','ups','phi','chi','psi','ome'));
      greeksymbol : array[1..2,1..24]of string=(('alp','bet','gam','del','eps','zet','eta','the','iot','kap','lam','mu','nu','xi','omi','pi','rho','sig','tau','ups','phi','chi','psi','ome'),
                  ('a','b','g','d','e','z','h','q','i','k','l','m','n','x','o','p','r','s','t','u','f','c','y','w'));
      pi2: double = 2*pi;
      pi4: double = 4*pi;
      pid2: double = pi/2;
      DefaultPrtRes = 300;
      DfColor : Starcolarray = (clBlack,$00EF9883,$00EBDF74,$00ffffff,$00CAF9F9,$008AF2EB,$008EBBF2,$006271FB,$000000ff,$00ffff00,$0000ff00,clWhite);
      MaxField = 10;
      Equat = 0;
      Altaz = 1;
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
      DefaultFontName='Sans';
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
      DefaultFontName='Default';
      DefaultFontSize=8;
      Defaultconfigfile='cartesduciel.ini';      // to user profile directory
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
                end;
     conf_skychart = record
                racentre,decentre,fov,theta,acentre,hcentre : double;
                Force_DT_UT,horizonopaque,autorefresh,FollowOn : Boolean;
                projtype : char;
                projname : array [0..10] of string[3];
                FlipX, FlipY, ProjPole, FollowType,FollowObj : integer;
                ObsLatitude,ObsLongitude,ObsAltitude,ObsTZ : double;
                ObsTemperature,ObsPressure,ObsRefractionCor : Double;
                ObsName : string;
                CurYear,CurMonth,CurDay,DrawPMyear : integer;
                ShowConstl,ShowConstB,ShowEqGrid,ShowAzGrid,UseSystemTime : boolean;
                CurTime,DT_UT_val: double;
                PMon,DrawPMon : boolean; // use proper motion

                HorizonMax,rap2000,dep2000 : Double;
                WindowRatio,BxGlb,ByGlb,AxGlb,AyGlb,sintheta,costheta: Double;
                Xwrldmin,Xwrldmax,Ywrldmin,Ywrldmax: Double;
                xmin,xmax,ymin,ymax,xshift,yshift,FieldNum,winx,winy : integer;
                LeftMargin,RightMargin,TopMargin,BottomMargin,Xcentre,Ycentre: Integer;
                ObsRoSinPhi,ObsRoCosPhi : double;
                TimeZone,DT_UT,CurST,CurJD,jd0,JDChart,CurSunH,CurMoonH,CurMoonIllum : Double;
                horizonlist : array [0..360] of single;
                end;
     conf_plot = record
                color : Starcolarray;
                backgroundcolor : Tcolor;
                stardyn,starsize,prtres,starplot,nebplot : integer;
                Nebgray,NebBright,starshapesize,starshapew : integer;
                Invisible : boolean;
                end;
     conf_chart = record
                onprinter : boolean;
                width,height,drawpen,drawsize : integer;
                min_ma : double;
                end;
     conf_main = record
                prtname,language : string;
                PrinterResolution,configpage,autorefreshdelay : integer;
                FontName : array [1..6] of string;
                FontSize : array [1..6] of integer;
                FontBold : array [1..6] of boolean;
                FontItalic : array [1..6] of boolean;
                maximized,updall : boolean;
                end;
     Tplanetlst = array[0..MaxSim,1..MaxPla,1..7] of double; // 1..9 : planet ; 10 : soleil ; 11 : lune ; 12..15 : jup sat ; 16..23 : sat sat ; 24..28 : ura sat ; 29..30 : mar sat ; 31 : sat ring ; 32 : earth umbra ;
     Tcometlst = array[0..MaxSim,1..MaxComet,1..7] of double;
     Tasteroidlst = array[0..MaxSim,1..MaxAsteroid,1..4] of double;

Var  Appdir, Configfile: string;         // pseudo-constant only here

implementation

end.
