unit cu_skychart;
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
 Skychart computation component
}
{$mode objfpc}{$H+}
interface

uses gcatunit, {libcatalog,} // libcatalog statically linked
     cu_plot, cu_catalog, cu_fits, u_constant, cu_planet, cu_database, u_projection, u_util,
     SysUtils, Classes, Math, Types, Buttons,
     Forms, StdCtrls, Controls, ExtCtrls, Graphics, FPImage, LCLType, IntfGraphics;
type
  Tint2func = procedure(i,j: integer) of object;

Tskychart = class (TComponent)
   private
    Fplot: TSplot;
    FFits: TFits;
    Fcatalog : Tcatalog;
    Fplanet : Tplanet;
    Fcdb: Tcdcdb;
    FShowDetailXY: Tint2func;
    Procedure DrawSatel(j,ipla:integer; ra,dec,ma,diam,pixscale : double; hidesat, showhide : boolean);
    Procedure InitLabels;
    procedure SetLabel(id:integer;xx,yy:single;radius,fontnum,labelnum:integer; txt:string);
    procedure EditLabelPos(lnum,x,y: integer);
    procedure EditLabelTxt(lnum,x,y: integer);
    procedure DefaultLabel(lnum: integer);
    procedure DeleteLabel(lnum: integer);
    procedure DeleteAllLabel;
    procedure LabelClick(lnum: integer);
    procedure SetImage(value:TCanvas);
   public
    cfgsc : Pconf_skychart;
    labels: array[1..maxlabels] of Tobjlabel;
    numlabels: integer;
    constructor Create(AOwner:Tcomponent); override;
    destructor  Destroy; override;
   published
    property plot: TSplot read Fplot;
    property catalog: Tcatalog read Fcatalog write Fcatalog;
    property planet: Tplanet read Fplanet write Fplanet;
    property cdb: Tcdcdb read Fcdb write Fcdb;
    property Fits: TFits read FFits write FFits;
    function Refresh : boolean;
    function InitCatalog : boolean;
    function InitTime : boolean;
    function InitChart : boolean;
    function InitColor : boolean;
    function GetFieldNum(fov:double):integer;
    function InitCoordinates : boolean;
    function InitObservatory : boolean;
    function DrawStars :boolean;
    function DrawVarStars :boolean;
    function DrawDblStars :boolean;
    function DrawDeepSkyObject :boolean;
    //function DrawNebulae :boolean;
    function DrawNebImages :boolean;
    function DrawOutline :boolean;
    function DrawMilkyWay :boolean;
    function DrawPlanet :boolean;
    procedure DrawEarthShadow(AR,DE,SunDist,MoonDist,MoonDistTopo : double);
    function DrawAsteroid :boolean;
    function DrawComet :boolean;
    function DrawOrbitPath:boolean;
    Procedure DrawGrid;
    procedure DrawEqGrid;
    procedure DrawAzGrid;
    procedure DrawGalGrid;
    procedure DrawEclGrid;
    Procedure DrawScale;
    function DrawConstL :boolean;
    function DrawConstB :boolean;
    function DrawHorizon:boolean;
    function DrawEcliptic:boolean;
    function DrawGalactic:boolean;
    function DrawLabels:boolean;
    procedure DrawFinderMark(ra,de :double; moving:boolean) ;
    procedure DrawCircle;
//  compass rose
    procedure DrawCRose;
//  end of compass rose
    function TelescopeMove(ra,dec:double):boolean;
    procedure GetCoord(x,y: integer; var ra,dec,a,h,l,b,le,be:double);
    procedure MoveChart(ns,ew:integer; movefactor:double);
    procedure MovetoXY(X,Y : integer);
    procedure MovetoRaDec(ra,dec:double);
    procedure Zoom(zoomfactor:double);
    procedure SetFOV(f:double);
    function PoleRot2000(ra,dec:double):double;
    procedure FormatCatRec(rec:Gcatrec; var desc:string);
    function FindatRaDec(ra,dec,dx: double;showall:boolean=false):boolean;
    Procedure GetLabPos(ra,dec,r:double; w,h: integer; var x,y: integer);
    Procedure LabelPos(xx,yy,w,h,marge: integer; var x,y: integer);
    procedure FindList(ra,dec,dx,dy: double;var text:widestring;showall,allobject,trunc:boolean);
    property OnShowDetailXY: Tint2func read FShowDetailXY write FShowDetailXY;
    function GetChartInfo(sep:string=blank):string;
    property Image: TCanvas write SetImage;
end;


implementation

constructor Tskychart.Create(AOwner:Tcomponent);
begin
 inherited Create(AOwner);
 // set safe value
 new(cfgsc);
 cfgsc^.quick:=false;
 cfgsc^.JDChart:=jd2000;
 cfgsc^.lastJDchart:=-1E25;
 cfgsc^.racentre:=0;
 cfgsc^.decentre:=0;
 cfgsc^.fov:=1;
 cfgsc^.theta:=0;
 cfgsc^.projtype:='A';
 cfgsc^.ProjPole:=Equat;
 cfgsc^.FlipX:=1;
 cfgsc^.FlipY:=1;
 cfgsc^.WindowRatio:=1;
 cfgsc^.BxGlb:=1;
 cfgsc^.ByGlb:=1;
 cfgsc^.AxGlb:=0;
 cfgsc^.AyGlb:=0;
 cfgsc^.xshift:=0;
 cfgsc^.yshift:=0;
 cfgsc^.xmin:=0;
 cfgsc^.xmax:=100;
 cfgsc^.ymin:=0;
 cfgsc^.ymax:=100;
 cfgsc^.RefractionOffset:=0;
 cfgsc^.AsteroidLstSize:=0;
 cfgsc^.CometLstSize:=0;
 cfgsc^.nummodlabels:=0;
 Fplot:=TSplot.Create(AOwner);
 Fplot.OnEditLabelPos:=@EditLabelPos;
 Fplot.OnEditLabelTxt:=@EditLabelTxt;
 Fplot.OnDefaultLabel:=@DefaultLabel;
 Fplot.OnDeleteLabel:=@DeleteLabel;
 Fplot.OnDeleteAllLabel:=@DeleteAllLabel;
 Fplot.OnLabelClick:=@LabelClick;
end;

destructor Tskychart.Destroy;
begin
try
 Fplot.free;
 dispose(cfgsc);
 inherited destroy;
except
writetrace('error destroy '+name);
end; 
end;

procedure Tskychart.SetImage(value:TCanvas);
begin
FPlot.Image:=value;
end;

function Tskychart.Refresh :boolean;
var savmag: double;
    savfilter,saveautofilter,savfillmw,scopemark:boolean;
begin
//writetrace('Refresh');
savmag:=Fcatalog.cfgshr.StarMagFilter[cfgsc^.FieldNum];
savfilter:=Fcatalog.cfgshr.StarFilter;
saveautofilter:=Fcatalog.cfgshr.AutoStarFilter;
savfillmw:=cfgsc^.FillMilkyWay;
scopemark:=cfgsc^.ScopeMark;
try
  chdir(appdir);
  // initialize chart value
  InitObservatory;
  InitTime;
  InitChart;
  InitCoordinates; // now include ComputePlanet
  if cfgsc^.quick then begin
     Fcatalog.cfgshr.StarFilter:=true;
  end else begin
     InitLabels;
  end;
  InitColor; // after ComputePlanet
  // draw objects
  Fcatalog.OpenCat(cfgsc);
  InitCatalog;
  //writetrace('Draw');
  // first the extended object
  if not cfgsc^.quick then begin
    DrawMilkyWay; // most extended first
    // then the horizon line if transparent
    if (not cfgsc^.horizonopaque) then DrawHorizon;
    DrawComet;
    if cfgsc^.shownebulae or cfgsc^.ShowImages then DrawDeepSkyObject;
    if cfgsc^.ShowBackgroundImage then DrawNebImages;
    if cfgsc^.showline then DrawOutline;
  end;
  // then the lines
  //writetrace('Draw grid');
  DrawGrid;
  if not cfgsc^.quick then begin
    DrawConstL;
    DrawConstB;
    DrawEcliptic;
    DrawGalactic;
  end;
  //writetrace('Draw circle');
  DrawCircle;
  // the stars
  //writetrace('Draw star');
  if cfgsc^.showstars then DrawStars;
  if not cfgsc^.quick then begin
    DrawDblStars;
    DrawVarStars;
  end;
  // finally the planets
  //writetrace('Draw planet');
  if not cfgsc^.quick then begin
    DrawAsteroid;
    if cfgsc^.SimLine then DrawOrbitPath;
  end;
  if cfgsc^.ShowPlanet then DrawPlanet;
  // and the horizon line if not transparent
  //writetrace('Draw horizon');
  if (not cfgsc^.quick)and cfgsc^.horizonopaque then DrawHorizon;
  // the labels
  //writetrace('Draw label');
  if (not cfgsc^.quick) and cfgsc^.showlabelall then DrawLabels;
  // refresh telescope mark
  if scopemark then begin
     //writetrace('Draw mark');
     DrawFinderMark(cfgsc^.ScopeRa,cfgsc^.ScopeDec,true);
     cfgsc^.ScopeMark:=true;
  end;
  result:=true;
  //writetrace('Draw end');
finally
  if cfgsc^.quick then begin
     Fcatalog.cfgshr.StarMagFilter[cfgsc^.FieldNum]:=savmag;
     Fcatalog.cfgshr.StarFilter:=savfilter;
     Fcatalog.cfgshr.AutoStarFilter:=saveautofilter;
  end;
  cfgsc^.FillMilkyWay:=savfillmw;
  cfgsc^.quick:=false;
  Fcatalog.CloseCat;
end;
end;

function Tskychart.InitCatalog:boolean;
var i:integer;
    mag,magmax:double;
  procedure InitStarC(cat:integer;defaultmag:double);
  { determine if the star catalog is active at this scale }
  begin
  if Fcatalog.cfgcat.starcatdef[cat-BaseStar] and
    (cfgsc^.FieldNum>=Fcatalog.cfgcat.starcatfield[cat-BaseStar,1]) and
    (cfgsc^.FieldNum<=Fcatalog.cfgcat.starcatfield[cat-BaseStar,2]) then begin
     Fcatalog.cfgcat.starcaton[cat-BaseStar]:=true;
     magmax:=max(magmax,defaultmag);
     if Fcatalog.cfgshr.StarFilter then mag:=minvalue([defaultmag,Fcatalog.cfgcat.StarMagMax])
        else mag:=defaultmag;
     Fplot.cfgchart^.min_ma:=maxvalue([Fplot.cfgchart^.min_ma,mag]);
  end
     else Fcatalog.cfgcat.starcaton[cat-BaseStar]:=false;
  end;
  procedure InitVarC(cat:integer);
  { determine if the variable star catalog is active at this scale }
  begin
  if Fcatalog.cfgcat.varstarcatdef[cat-BaseVar] and
    (cfgsc^.FieldNum>=Fcatalog.cfgcat.varstarcatfield[cat-BaseVar,1]) and
    (cfgsc^.FieldNum<=Fcatalog.cfgcat.varstarcatfield[cat-BaseVar,2]) then
          Fcatalog.cfgcat.varstarcaton[cat-BaseVar]:=true
     else Fcatalog.cfgcat.varstarcaton[cat-BaseVar]:=false;
  end;
  procedure InitDblC(cat:integer);
  { determine if the double star catalog is active at this scale }
  begin
  if Fcatalog.cfgcat.dblstarcatdef[cat-BaseDbl] and
    (cfgsc^.FieldNum>=Fcatalog.cfgcat.dblstarcatfield[cat-BaseDbl,1]) and
    (cfgsc^.FieldNum<=Fcatalog.cfgcat.dblstarcatfield[cat-BaseDbl,2]) then
          Fcatalog.cfgcat.dblstarcaton[cat-BaseDbl]:=true
     else Fcatalog.cfgcat.dblstarcaton[cat-BaseDbl]:=false;
  end;
  procedure InitNebC(cat:integer);
  { determine if the nebulae catalog is active at this scale }
  begin
  if Fcatalog.cfgcat.nebcatdef[cat-BaseNeb] and
    (cfgsc^.FieldNum>=Fcatalog.cfgcat.nebcatfield[cat-BaseNeb,1]) and
    (cfgsc^.FieldNum<=Fcatalog.cfgcat.nebcatfield[cat-BaseNeb,2]) then
          Fcatalog.cfgcat.nebcaton[cat-BaseNeb]:=true
     else Fcatalog.cfgcat.nebcaton[cat-BaseNeb]:=false;
  end;
begin
if Fcatalog.cfgshr.AutoStarFilter then Fcatalog.cfgcat.StarMagMax:=round(10*(Fcatalog.cfgshr.AutoStarFilterMag+2.4*log10(intpower(pid2/cfgsc^.fov,2))))/10
   else Fcatalog.cfgcat.StarMagMax:=Fcatalog.cfgshr.StarMagFilter[cfgsc^.FieldNum];
if cfgsc^.quick then Fcatalog.cfgcat.StarMagMax:=Fcatalog.cfgcat.StarMagMax-2;
Fcatalog.cfgcat.NebMagMax:=Fcatalog.cfgshr.NebMagFilter[cfgsc^.FieldNum];
Fcatalog.cfgcat.NebSizeMin:=Fcatalog.cfgshr.NebSizeFilter[cfgsc^.FieldNum];
Fplot.cfgchart^.min_ma:=1;
magmax:=1;
{ activate the star catalog}
InitStarC(dsbase,5.5);
InitStarC(bsc,6.5);
InitStarC(sky2000,9.5);
InitStarC(tyc,11);
InitStarC(tyc2,12);
InitStarC(dstyc,12);
InitStarC(tic,12);
InitStarC(gsc,14.5);
InitStarC(gscf,14.5);
InitStarC(gscc,14.5);
InitStarC(dsgsc,14.5);
InitStarC(microcat,16);
InitStarC(usnoa,18);
{ activate the other catalog }
InitVarC(gcvs);
InitDblC(wds);
InitNebC(sac);
InitNebC(ngc);
InitNebC(lbn);
InitNebC(rc3);
InitNebC(pgc);
InitNebC(ocl);
InitNebC(gcm);
InitNebC(gpn);
Fcatalog.cfgcat.starcaton[gcstar-BaseStar]:=false;
Fcatalog.cfgcat.varstarcaton[gcvar-Basevar]:=false;
Fcatalog.cfgcat.dblstarcaton[gcdbl-Basedbl]:=false;
Fcatalog.cfgcat.nebcaton[gcneb-Baseneb]:=false;
Fcatalog.cfgcat.lincaton[gclin-Baselin]:=false;
for i:=1 to Fcatalog.cfgcat.GCatNum do
  if Fcatalog.cfgcat.GCatLst[i-1].Actif and
     (cfgsc^.FieldNum>=Fcatalog.cfgcat.GCatLst[i-1].min) and
     (cfgsc^.FieldNum<=Fcatalog.cfgcat.GCatLst[i-1].max) then begin
         Fcatalog.cfgcat.GCatLst[i-1].CatOn:=true;
         case Fcatalog.cfgcat.GCatLst[i-1].cattype of
          rtstar: begin
                  magmax:=max(magmax,Fcatalog.cfgcat.GCatLst[i-1].magmax);
                  Fcatalog.cfgcat.starcaton[gcstar-BaseStar]:=true;
                  if Fcatalog.cfgshr.StarFilter then mag:=min(Fcatalog.cfgcat.GCatLst[i-1].magmax,Fcatalog.cfgcat.StarMagMax)
                                                else mag:=Fcatalog.cfgcat.GCatLst[i-1].magmax;
                  Fplot.cfgchart^.min_ma:=max(Fplot.cfgchart^.min_ma,mag);
                  end;
          rtvar : Fcatalog.cfgcat.varstarcaton[gcvar-Basevar]:=true;
          rtdbl : Fcatalog.cfgcat.dblstarcaton[gcdbl-Basedbl]:=true;
          rtneb : Fcatalog.cfgcat.nebcaton[gcneb-Baseneb]:=true;
          rtlin : Fcatalog.cfgcat.lincaton[gclin-Baselin]:=true;
         end;
  end else Fcatalog.cfgcat.GCatLst[i-1].CatOn:=false;
// Store mag limit for this chart
Fplot.cfgchart^.max_catalog_mag:=magmax;
cfgsc^.StarFilter:=Fcatalog.cfgshr.StarFilter;
cfgsc^.StarMagMax:=Fcatalog.cfgcat.StarMagMax;
cfgsc^.NebFilter:=Fcatalog.cfgshr.NebFilter;
cfgsc^.NebMagMax:=Fcatalog.cfgcat.NebMagMax;
result:=true;
end;

function Tskychart.InitTime:boolean;
var y,m,d:integer;
    t:double;
begin
if cfgsc^.UseSystemTime then begin
   SetCurrentTime(cfgsc);
   cfgsc^.TimeZone:=GetTimezone
end else begin
   cfgsc^.TimeZone:=cfgsc^.ObsTZ;
end;
cfgsc^.DT_UT:=DTminusUT(cfgsc^.CurYear,cfgsc);
cfgsc^.CurJD:=jd(cfgsc^.CurYear,cfgsc^.CurMonth,cfgsc^.CurDay,cfgsc^.CurTime-cfgsc^.TimeZone+cfgsc^.DT_UT);
cfgsc^.jd0:=jd(cfgsc^.CurYear,cfgsc^.CurMonth,cfgsc^.CurDay,0);
cfgsc^.CurST:=Sidtim(cfgsc^.jd0,cfgsc^.CurTime-cfgsc^.TimeZone,cfgsc^.ObsLongitude);
if cfgsc^.CurJD<>cfgsc^.LastJD then begin // thing to do when the date change
   cfgsc^.FindOk:=false;    // last search no longuer valid
end;
cfgsc^.LastJD:=cfgsc^.CurJD;
if (Fcatalog.cfgshr.Equinoxtype=2)or(cfgsc^.projpole=altaz) then begin  // use equinox of the date
   cfgsc^.JDChart:=cfgsc^.CurJD;
   cfgsc^.EquinoxName:='Date ';
end else begin
   cfgsc^.JDChart:=Fcatalog.cfgshr.DefaultJDChart;
   cfgsc^.EquinoxName:=fcatalog.cfgshr.EquinoxChart;
end;
djd(cfgsc^.JDChart,y,m,d,t);
cfgsc^.EquinoxDate:=Date2Str(y,m,d);
if (cfgsc^.lastJDchart<-1E20) then cfgsc^.lastJDchart:=cfgsc^.JDchart; // initial value
cfgsc^.rap2000:=0;       // position of J2000 pole in current coordinates
cfgsc^.dep2000:=pid2;
precession(jd2000,cfgsc^.JDChart,cfgsc^.rap2000,cfgsc^.dep2000);
result:=true;
end;

function Tskychart.InitObservatory:boolean;
var u,p : double;
const ratio = 0.99664719;
      H0 = 6378140.0 ;
begin
   p:=deg2rad*cfgsc^.ObsLatitude;
   u:=arctan(ratio*tan(p));
   cfgsc^.ObsRoSinPhi:=ratio*sin(u)+(cfgsc^.ObsAltitude/H0)*sin(p);
   cfgsc^.ObsRoCosPhi:=cos(u)+(cfgsc^.ObsAltitude/H0)*cos(p);
   cfgsc^.ObsRefractionCor:=(cfgsc^.ObsPressure/1010)*(283/(273+cfgsc^.ObsTemperature));
   cfgsc^.ObsHorizonDepression:=-deg2rad*sqrt(cfgsc^.ObsAltitude)*0.02931+deg2rad*0.64658062088;
   result:=true;
end;

function Tskychart.InitChart:boolean;
begin
// do not add more function here as this is also called at the chart create
cfgsc^.xmin:=0;
cfgsc^.ymin:=0;
cfgsc^.xmax:=Fplot.cfgchart^.width;
cfgsc^.ymax:=Fplot.cfgchart^.height;
ScaleWindow(cfgsc);
result:=true;
end;

function Tskychart.InitColor:boolean;
var i : integer;
begin
if Fplot.cfgplot^.color[0]>Fplot.cfgplot^.color[11] then begin // white background
   Fplot.cfgplot^.AutoSkyColor:=false;
   Fplot.cfgplot^.StarPlot:=0;
   Fplot.cfgplot^.NebPlot:=0;
   cfgsc^.FillMilkyWay:=false;
   cfgsc^.WhiteBg:=true;
end else cfgsc^.WhiteBg:=false;
if Fplot.cfgplot^.AutoSkyColor and (cfgsc^.Projpole=AltAz) then begin
 if (cfgsc^.fov>10*deg2rad) then begin
  if cfgsc^.CurSunH>0 then i:=1
  else if cfgsc^.CurSunH>-5*deg2rad then i:=2
  else if cfgsc^.CurSunH>-11*deg2rad then i:=3
  else if cfgsc^.CurSunH>-13*deg2rad then i:=4
  else if cfgsc^.CurSunH>-15*deg2rad then i:=5
  else if cfgsc^.CurSunH>-17*deg2rad then i:=6
  else i:=7;
 end else
  if cfgsc^.CurSunH>0 then i:=5
  else if cfgsc^.CurSunH>-5*deg2rad then i:=5
  else if cfgsc^.CurSunH>-11*deg2rad then i:=6
  else if cfgsc^.CurSunH>-13*deg2rad then i:=6
  else if cfgsc^.CurSunH>-15*deg2rad then i:=7
  else if cfgsc^.CurSunH>-17*deg2rad then i:=7
  else i:=7;
 if (i>=5)and(cfgsc^.CurMoonH>0) then begin
    if (cfgsc^.CurMoonIllum>0.1)and(cfgsc^.CurMoonIllum<0.5) then i:=i-1;
    if (cfgsc^.CurMoonIllum>=0.5) then i:=i-2;
    if i<5 then i:=5;
 end;
 Fplot.cfgplot^.color[0]:=Fplot.cfgplot^.SkyColor[i];
end else Fplot.cfgplot^.color[0]:=Fplot.cfgplot^.bgColor;
Fplot.cfgplot^.backgroundcolor:=Fplot.cfgplot^.color[0];
Fplot.init(Fplot.cfgchart^.width,Fplot.cfgchart^.height);
if Fplot.cfgchart^.onprinter and (Fplot.cfgplot^.starplot=0) then Fplot.cfgplot^.color[0]:=clBlack;
result:=true;
end;

function Tskychart.GetFieldNum(fov:double):integer;
var     i : integer;
begin
fov:=rad2deg*fov;
if fov>360 then fov:=360;
result:=MaxField;
for i:=0 to MaxField do if Fcatalog.cfgshr.FieldNum[i]>fov then begin
       result:=i;
       break;
    end;
end;

function Tskychart.InitCoordinates:boolean;
var w,h,a,d,dist,v1,v2,v3,v4,v5,v6,v7,v8,v9,saveaz : double;
    s1,s2,s3: string;
begin
cfgsc^.scopemark:=false;
cfgsc^.RefractionOffset:=0;
// clipping limit
Fplot.cfgplot^.outradius:=abs(round(min(50*cfgsc^.fov,0.98*pi2)*cfgsc^.BxGlb/2));
Fplot.cfgchart^.hw:=Fplot.cfgchart^.width div 2;
Fplot.cfgchart^.hh:=Fplot.cfgchart^.height div 2;
// nutation constant
cfgsc^.e:=ecliptic(cfgsc^.JDChart);
nutation(cfgsc^.CurJd,cfgsc^.nutl,cfgsc^.nuto);
// Sun geometric longitude
fplanet.sunecl(cfgsc^.CurJd,cfgsc^.sunl,cfgsc^.sunb);
PrecessionEcl(jd2000,cfgsc^.JdChart,cfgsc^.sunl,cfgsc^.sunb);
// aberration constant
aberration(cfgsc^.CurJd,cfgsc^.abe,cfgsc^.abp);
// Planet position
if not cfgsc^.quick then Fplanet.ComputePlanet(cfgsc);
// is the chart to be centered on an object ?
 if cfgsc^.TrackOn then begin
  case cfgsc^.TrackType of
     1 : begin
         // planet
         cfgsc^.racentre:=cfgsc^.PlanetLst[0,cfgsc^.Trackobj,1];
         cfgsc^.decentre:=cfgsc^.PlanetLst[0,cfgsc^.Trackobj,2];
         end;
     2 : begin
         // comet
         if cdb.GetComElem(cfgsc^.TrackId,cfgsc^.TrackEpoch,v1,v2,v3,v4,v5,v6,v7,v8,v9,s1,s2) then begin
            Fplanet.InitComet(v1,v2,v3,v4,v5,v6,v7,v8,v9,s1);
            Fplanet.Comet(cfgsc^.CurJd,true,a,d,dist,v1,v2,v3,v4,v5,v6,v7,v8,v9);
            precession(jd2000,cfgsc^.JDChart,a,d);
            cfgsc^.LastJDChart:=cfgsc^.JDChart;
            if cfgsc^.PlanetParalaxe then Paralaxe(cfgsc^.CurST,dist,a,d,a,d,v1,cfgsc);
            if cfgsc^.ApparentPos then apparent_equatorial(a,d,cfgsc);
            cfgsc^.racentre:=a;
            cfgsc^.decentre:=d;
          end
          else cfgsc^.TrackOn:=false;
         end;
     3 : begin
         // asteroid
         if cdb.GetAstElem(cfgsc^.TrackId,cfgsc^.TrackEpoch,v1,v2,v3,v4,v5,v6,v7,v8,v9,s1,s2,s3) then begin
            Fplanet.InitAsteroid(cfgsc^.TrackEpoch,v1,v2,v3,v4,v5,v6,v7,v8,v9,s2);
            Fplanet.Asteroid(cfgsc^.CurJd,true,a,d,dist,v1,v2,v3,v4);
            precession(jd2000,cfgsc^.JDChart,a,d);
            cfgsc^.LastJDChart:=cfgsc^.JDChart;
            if cfgsc^.PlanetParalaxe then Paralaxe(cfgsc^.CurST,dist,a,d,a,d,v1,cfgsc);
            if cfgsc^.ApparentPos then apparent_equatorial(a,d,cfgsc);
            cfgsc^.racentre:=a;
            cfgsc^.decentre:=d;
          end
          else cfgsc^.TrackOn:=false;
         end;
     4 : begin
         // azimuth - altitude
         if cfgsc^.Projpole=AltAz then begin
           Hz2Eq(cfgsc^.acentre,cfgsc^.hcentre,cfgsc^.racentre,cfgsc^.decentre,cfgsc);
           cfgsc^.racentre:=cfgsc^.CurST-cfgsc^.racentre;
          end;
         cfgsc^.TrackOn:=false;
         end;
     5 : begin
         // fits image
         cfgsc^.TrackOn:=false;
         if FFits.Header.valid then begin
            cfgsc^.Projpole:=Equat;
            cfgsc^.JDChart:=jd2000; //FFits.Header.equinox;
            cfgsc^.lastJDchart:=cfgsc^.JDChart;
            cfgsc^.racentre:=FFits.Center_RA;
            cfgsc^.decentre:=FFits.Center_DE;
            cfgsc^.fov:=FFits.Img_Width;
            cfgsc^.theta:=FFits.Rotation;
            ScaleWindow(cfgsc);
         end;
         end;
     6 : begin
         // ra - dec
//         cfgsc^.TrackOn:=false;
         cfgsc^.racentre:=cfgsc^.TrackRA;
         cfgsc^.decentre:=cfgsc^.TrackDec;
         end;
   end;
  end;
// find the current field number and projection
w := cfgsc^.fov;
h := cfgsc^.fov/cfgsc^.WindowRatio;
w := maxvalue([w,h]);
cfgsc^.FieldNum:=GetFieldNum(w);
cfgsc^.projtype:=(cfgsc^.projname[cfgsc^.fieldnum]+'A')[1];
// normalize the coordinates
if (cfgsc^.decentre>=(pid2-secarc)) then cfgsc^.decentre:=pid2-secarc;
if (cfgsc^.decentre<=(-pid2+secarc)) then cfgsc^.decentre:=-pid2+secarc;
cfgsc^.racentre:=rmod(cfgsc^.racentre+pi2,pi2);
// apply precession if the epoch change from previous chart
if cfgsc^.lastJDchart<>cfgsc^.JDchart then
   precession(cfgsc^.lastJDchart,cfgsc^.JDchart,cfgsc^.racentre,cfgsc^.decentre);
cfgsc^.lastJDchart:=cfgsc^.JDchart;
// get alt/az center
saveaz:= cfgsc^.acentre;
Eq2Hz(cfgsc^.CurST-cfgsc^.racentre,cfgsc^.decentre,cfgsc^.acentre,cfgsc^.hcentre,cfgsc) ;
if abs(cfgsc^.hcentre-pid2)<2*minarc then begin
   cfgsc^.acentre:=saveaz;
end;
// compute refraction error at the chart center
Hz2Eq(cfgsc^.acentre,cfgsc^.hcentre,a,d,cfgsc);
Eq2Hz(a,d,w,h,cfgsc) ;
cfgsc^.RefractionOffset:=h-cfgsc^.hcentre;
// get galactic center
Eq2Gal(cfgsc^.racentre,cfgsc^.decentre,cfgsc^.lcentre,cfgsc^.bcentre,cfgsc) ;
// get ecliptic center
Eq2Ecl(cfgsc^.racentre,cfgsc^.decentre,cfgsc^.e,cfgsc^.lecentre,cfgsc^.becentre) ;
// is the pole in the chart
cfgsc^.NP:=northpoleinmap(cfgsc);
cfgsc^.SP:=southpoleinmap(cfgsc);
// detect if the position change
if not cfgsc^.quick then begin
  cfgsc^.moved:=(cfgsc^.racentre<>cfgsc^.raprev)or(cfgsc^.decentre<>cfgsc^.deprev);
  cfgsc^.raprev:=cfgsc^.racentre;
  cfgsc^.deprev:=cfgsc^.decentre;
end;  
result:=true;
end;

function Tskychart.DrawStars :boolean;
var rec:GcatRec;
  x1,y1,cyear,dyear: Double;
  xx,yy,xxp,yyp : single;
  lid,saveplot : integer;
  first:boolean;
  firstcat:TSname;
begin
fillchar(rec,sizeof(rec),0);
cyear:=cfgsc^.CurYear+cfgsc^.CurMonth/12;
dyear:=0;
first:=true;
saveplot:=Fplot.cfgplot^.starplot;
try
Fplot.InitPixelImg;
if Fcatalog.OpenStar then
 while Fcatalog.readstar(rec) do begin
 if first then begin
    firstcat:=rec.options.ShortName;
    first:=false;
 end;
 lid:=trunc(1e5*rec.ra)+trunc(1e5*rec.dec);
 if cfgsc^.PMon or cfgsc^.DrawPMon then begin
    if rec.star.valid[vsEpoch] then dyear:=cyear-rec.star.epoch
                               else dyear:=cyear-rec.options.Epoch;
 end;
 if cfgsc^.PMon and rec.star.valid[vsPmra] and rec.star.valid[vsPmdec] then begin
    rec.ra:=rec.ra+(rec.star.pmra/cos(rec.dec))*dyear;
    rec.dec:=rec.dec+(rec.star.pmdec)*dyear;
 end;
 precession(rec.options.EquinoxJD,cfgsc^.JDChart,rec.ra,rec.dec);
 if cfgsc^.ApparentPos then apparent_equatorial(rec.ra,rec.dec,cfgsc);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc^.Xmin) and (xx<cfgsc^.Xmax) and (yy>cfgsc^.Ymin) and (yy<cfgsc^.Ymax) then begin
    if cfgsc^.DrawPMon then begin
       rec.ra:=rec.ra+(rec.star.pmra/cos(rec.dec))*cfgsc^.DrawPMyear;
       rec.dec:=rec.dec+(rec.star.pmdec)*cfgsc^.DrawPMyear;
       projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
       WindowXY(x1,y1,xxp,yyp,cfgsc);
       Fplot.PlotLine(xx,yy,xxp,yyp,Fplot.cfgplot^.Color[15],1);
       Fplot.cfgplot^.starplot:=1;
    end
    else
       Fplot.cfgplot^.starplot:=saveplot;
    Fplot.PlotStar(xx,yy,rec.star.magv,rec.star.b_v);
    if (rec.options.ShortName=firstcat)and(rec.star.magv<cfgsc^.StarmagMax-cfgsc^.LabelMagDiff[1]) then begin
       if cfgsc^.MagLabel then SetLabel(lid,xx,yy,0,2,1,formatfloat(f2,rec.star.magv))
       else if ((cfgsc^.NameLabel) and rec.vstr[3] and (rec.options.flabel[18]='Common Name')) then SetLabel(lid,xx,yy,0,2,1,rec.str[3])
       else if rec.star.valid[vsGreekSymbol] then SetLabel(lid,xx,yy,0,7,1,rec.star.greeksymbol)
          else SetLabel(lid,xx,yy,0,2,1,rec.star.id);
    end;
 end;
end;
result:=true;
finally
Fplot.cfgplot^.starplot:=saveplot;
Fcatalog.CloseStar;
Fplot.ClosePixelImg;
end;
end;

function Tskychart.DrawVarStars :boolean;
var rec:GcatRec;
  x1,y1: Double;
  xx,yy:single;
  lid: integer;
begin
fillchar(rec,sizeof(rec),0);
try
if Fcatalog.OpenVarStar then
 while Fcatalog.readvarstar(rec) do begin
 lid:=trunc(1e5*rec.ra)+trunc(1e5*rec.dec);
 precession(rec.options.EquinoxJD,cfgsc^.JDChart,rec.ra,rec.dec);
 if cfgsc^.ApparentPos then apparent_equatorial(rec.ra,rec.dec,cfgsc);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc^.Xmin) and (xx<cfgsc^.Xmax) and (yy>cfgsc^.Ymin) and (yy<cfgsc^.Ymax) then begin
    Fplot.PlotVarStar(xx,yy,rec.variable.magmax,rec.variable.magmin);
    if rec.variable.magmax<cfgsc^.StarmagMax-cfgsc^.LabelMagDiff[2] then
    if cfgsc^.MagLabel then SetLabel(lid,xx,yy,0,2,2,formatfloat(f2,rec.variable.magmax)+'-'+formatfloat(f2,rec.variable.magmin))
       else SetLabel(lid,xx,yy,0,2,2,rec.variable.id);
 end;
end;
result:=true;
finally
 Fcatalog.CloseVarStar;
end;
end;

function Tskychart.DrawDblStars :boolean;
var rec:GcatRec;
  x1,y1,x2,y2,rot: Double;
  xx,yy:single;
  lid: integer;
begin
fillchar(rec,sizeof(rec),0);
try
if Fcatalog.OpenDblStar then
 while Fcatalog.readdblstar(rec) do begin
 lid:=trunc(1e5*rec.ra)+trunc(1e5*rec.dec);
 precession(rec.options.EquinoxJD,cfgsc^.JDChart,rec.ra,rec.dec);
 if cfgsc^.ApparentPos then apparent_equatorial(rec.ra,rec.dec,cfgsc);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc^.Xmin) and (xx<cfgsc^.Xmax) and (yy>cfgsc^.Ymin) and (yy<cfgsc^.Ymax) then begin
    projection(rec.ra,rec.dec+0.001,x2,y2,false,cfgsc) ;
    rot:=RotationAngle(x1,y1,x2,y2,cfgsc);
    if (not rec.double.valid[vdPA])or(rec.double.pa=-999) then rec.double.pa:=0
        else rec.double.pa:=rec.double.pa-rad2deg*PoleRot2000(rec.ra,rec.dec);
    rec.double.pa:=rec.double.pa*cfgsc^.FlipX;
    if cfgsc^.FlipY<0 then rec.double.pa:=180-rec.double.pa;
    rec.double.pa:=Deg2Rad*rec.double.pa+rot;
    Fplot.PlotDblStar(xx,yy,abs(rec.double.sep*secarc*cfgsc^.BxGlb),rec.double.mag1,rec.double.sep,rec.double.pa,0);
    if rec.double.mag1<cfgsc^.StarmagMax-cfgsc^.LabelMagDiff[3] then
    if cfgsc^.MagLabel then SetLabel(lid,xx,yy,0,2,3,formatfloat(f2,rec.double.mag1))
       else SetLabel(lid,xx,yy,0,2,3,rec.double.id);
 end;
end;
result:=true;
finally
  Fcatalog.CloseDblStar;
end;
end;

function Tskychart.PoleRot2000(ra,dec:double):double;
var  x1,y1: Double;
begin
if cfgsc^.JDChart=jd2000 then result:=0
else begin
  Proj3(cfgsc^.rap2000,cfgsc^.dep2000,ra,dec,x1,y1,cfgsc);
  result:=arctan2(x1,y1);
end;
end;

function Tskychart.DrawDeepSkyObject :boolean;
var rec:GcatRec;
  x1,y1,x2,y2,rot,ra,de: Double;
  x,y,xx,yy,sz:single;
  lid, save_nebplot: integer;
  imgfile: string;
  bmp:Tbitmap;
  save_col: Starcolarray;

  Procedure Drawing;
    begin
      if rec.neb.nebtype<>1 then
        Fplot.PlotDeepSkyObject(xx,yy,rec.neb.dim1,rec.neb.mag,rec.neb.sbr,abs(cfgsc^.BxGlb)*deg2rad/rec.neb.nebunit,rec.neb.nebtype,rec.neb.morph)
      else
        begin;    //   galaxies are the only rotatable objects, so rotate them and then plot...
          projection(rec.ra,rec.dec+0.001,x2,y2,false,cfgsc) ;
          rot:=RotationAngle(x1,y1,x2,y2,cfgsc);
          if (not rec.neb.valid[vnPA])or(rec.neb.pa=-999)
            then rec.neb.pa:=90
            else rec.neb.pa:=rec.neb.pa-rad2deg*PoleRot2000(rec.ra,rec.dec);
          rec.neb.pa:=rec.neb.pa*cfgsc^.FlipX;
          if cfgsc^.FlipY<0 then rec.neb.pa:=180-rec.neb.pa;
          rec.neb.pa:=Deg2Rad*rec.neb.pa+rot;
          Fplot.PlotDSOGxy(xx,yy,rec.neb.dim1,rec.neb.dim2,rec.neb.pa,0,100,100,rec.neb.mag,rec.neb.sbr,abs(cfgsc^.BxGlb)*deg2rad/rec.neb.nebunit,rec.neb.morph);
        end;
      end;

  Procedure Drawing_Gray;
    begin
      save_nebplot:=Fplot.cfgplot^.nebplot;
      save_col:=Fplot.cfgplot^.color;
      Fplot.cfgplot^.nebplot:=1;
      Fplot.cfgplot^.color:=DfGray;
      Drawing;
      Fplot.cfgplot^.nebplot:=save_nebplot;
      Fplot.cfgplot^.color:=save_col;
    end;

  begin
    fillchar(rec,sizeof(rec),0);
    bmp:=Tbitmap.Create;
    try
    if Fcatalog.OpenNeb then
      while Fcatalog.readneb(rec) do
        begin
          lid:=trunc(1e5*rec.ra)+trunc(1e5*rec.dec);
          precession(rec.options.EquinoxJD,cfgsc^.JDChart,rec.ra,rec.dec);
          if cfgsc^.ApparentPos then apparent_equatorial(rec.ra,rec.dec,cfgsc);
          projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
          WindowXY(x1,y1,xx,yy,cfgsc);
          if not rec.neb.valid[vnNebtype] then rec.neb.nebtype:=rec.options.ObjType;
          if not rec.neb.valid[vnNebunit] then rec.neb.nebunit:=rec.options.Units;
          sz:=abs(cfgsc^.BxGlb)*deg2rad/rec.neb.nebunit*rec.neb.dim1/2;
          if ((xx+sz)>cfgsc^.Xmin) and
             ((xx-sz)<cfgsc^.Xmax) and
             ((yy+sz)>cfgsc^.Ymin) and
             ((yy-sz)<cfgsc^.Ymax) then
            begin
              if cfgsc^.ShowImages and
                 FFits.GetFileName(rec.options.ShortName,rec.neb.id,imgfile) then
                begin
                  if (sz>6) then
                    begin
                      FFits.FileName:=imgfile;
                      if FFits.Header.valid then
                        if ((FFits.Img_Width*cfgsc^.BxGlb/FFits.Header.naxis1)<10) then
                          begin
                            ra:=FFits.Center_RA;
                            de:=FFits.Center_DE;
                            precession(jd2000,cfgsc^.JDChart,ra,de);
                            if cfgsc^.ApparentPos then apparent_equatorial(ra,de,cfgsc);
                            projection(ra,de,x1,y1,true,cfgsc) ;
                            WindowXY(x1,y1,x,y,cfgsc);
                            FFits.GetBitmap(bmp);
                            projection(ra,de+0.001,x2,y2,false,cfgsc) ;
                            rot:=FFits.Rotation-arctan2((x2-x1),(y2-y1));
                            Fplot.plotimage(x,y,abs(FFits.Img_Width*cfgsc^.BxGlb),abs(FFits.Img_Height*cfgsc^.ByGlb),rot,cfgsc^.FlipX,cfgsc^.FlipY,cfgsc^.WhiteBg,true,bmp);
                          end
                        else Drawing_Gray;
                    end
                  else Drawing_Gray;
                end
              else
                if cfgsc^.shownebulae then
                  begin
                    Drawing;
                  end;
              if rec.neb.messierobject or (rec.neb.mag<cfgsc^.NebmagMax-cfgsc^.LabelMagDiff[4]) then
              SetLabel(lid,xx,yy,round(sz),2,4,rec.neb.id);
            end;
        end;
      result:=true;
    finally
      Fcatalog.CloseNeb;
      bmp.Free;
    end;
end;

{function Tskychart.DrawNebulae :boolean;
var rec:GcatRec;
  x1,y1,x2,y2,rot,ra,de: Double;
  x,y,xx,yy,sz:single;
  lid, save_nebplot: integer;
  imgfile: string;
  bmp:Tbitmap;
  save_col8,save_col9,save_col10,save_col11: TColor;
Procedure Drawing;
begin
   if rec.neb.nebtype=1 then begin
      projection(rec.ra,rec.dec+0.001,x2,y2,false,cfgsc) ;
      rot:=RotationAngle(x1,y1,x2,y2,cfgsc);
      if (not rec.neb.valid[vnPA])or(rec.neb.pa=-999) then rec.neb.pa:=90
          else rec.neb.pa:=rec.neb.pa-rad2deg*PoleRot2000(rec.ra,rec.dec);
      rec.neb.pa:=rec.neb.pa*cfgsc^.FlipX;
      if cfgsc^.FlipY<0 then rec.neb.pa:=180-rec.neb.pa;
      rec.neb.pa:=Deg2Rad*rec.neb.pa+rot;
      Fplot.PlotGalaxie(xx,yy,rec.neb.dim1,rec.neb.dim2,rec.neb.pa,0,100,100,rec.neb.mag,rec.neb.sbr,abs(cfgsc^.BxGlb)*deg2rad/rec.neb.nebunit);
    end else
      Fplot.PlotNebula(xx,yy,rec.neb.dim1,rec.neb.mag,rec.neb.sbr,abs(cfgsc^.BxGlb)*deg2rad/rec.neb.nebunit,rec.neb.nebtype);
end;
Procedure Drawing_Gray;
begin
   save_nebplot:=Fplot.cfgplot.nebplot;
   save_col8:=Fplot.cfgplot.color[8];
   save_col9:=Fplot.cfgplot.color[9];
   save_col10:=Fplot.cfgplot.color[10];
   save_col11:=Fplot.cfgplot.color[11];
   Fplot.cfgplot.nebplot:=1;
   Fplot.cfgplot.color[8]:=clSilver;
   Fplot.cfgplot.color[9]:=clSilver;
   Fplot.cfgplot.color[10]:=clSilver;
   Fplot.cfgplot.color[11]:=clSilver;
   Drawing;
   Fplot.cfgplot.nebplot:=save_nebplot;
   Fplot.cfgplot.color[8]:=save_col8;
   Fplot.cfgplot.color[9]:=save_col9;
   Fplot.cfgplot.color[10]:=save_col10;
   Fplot.cfgplot.color[11]:=save_col11;
end;

begin
fillchar(rec,sizeof(rec),0);
bmp:=Tbitmap.Create;
try
if Fcatalog.OpenNeb then
 while Fcatalog.readneb(rec) do begin
 lid:=trunc(1e5*rec.ra)+trunc(1e5*rec.dec);
 precession(rec.options.EquinoxJD,cfgsc^.JDChart,rec.ra,rec.dec);
 if cfgsc^.ApparentPos then apparent_equatorial(rec.ra,rec.dec,cfgsc);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if not rec.neb.valid[vnNebtype] then rec.neb.nebtype:=rec.options.ObjType;
 if not rec.neb.valid[vnNebunit] then rec.neb.nebunit:=rec.options.Units;
 sz:=abs(cfgsc^.BxGlb)*deg2rad/rec.neb.nebunit*rec.neb.dim1/2;
 if ((xx+sz)>cfgsc^.Xmin) and ((xx-sz)<cfgsc^.Xmax) and ((yy+sz)>cfgsc^.Ymin) and ((yy-sz)<cfgsc^.Ymax) then begin
  if cfgsc^.ShowImages and FFits.GetFileName(rec.options.ShortName,rec.neb.id,imgfile) then begin
     if (sz>6) then begin
       FFits.FileName:=imgfile;
       if FFits.Header.valid then
          if ((FFits.Img_Width*cfgsc^.BxGlb/FFits.Header.naxis1)<10) then begin
             ra:=FFits.Center_RA;
             de:=FFits.Center_DE;
             precession(jd2000,cfgsc^.JDChart,ra,de);
             if cfgsc^.ApparentPos then apparent_equatorial(ra,de,cfgsc);
             projection(ra,de,x1,y1,true,cfgsc) ;
             WindowXY(x1,y1,x,y,cfgsc);
             FFits.GetBitmap(bmp);
             projection(ra,de+0.001,x2,y2,false,cfgsc) ;
             rot:=FFits.Rotation-arctan2((x2-x1),(y2-y1));
             Fplot.plotimage(x,y,abs(FFits.Img_Width*cfgsc^.BxGlb),abs(FFits.Img_Height*cfgsc^.ByGlb),rot,cfgsc^.FlipX,cfgsc^.FlipY,cfgsc^.WhiteBg,true,bmp);
          end
          else Drawing_Gray;
     end
     else Drawing_Gray;
  end else if cfgsc^.shownebulae then begin
      Drawing;
   end;
   if rec.neb.messierobject or (rec.neb.mag<cfgsc^.NebmagMax-cfgsc^.LabelMagDiff[4]) then
      SetLabel(lid,xx,yy,round(sz),2,4,rec.neb.id);
 end;
end;
result:=true;
finally
 Fcatalog.CloseNeb;
 bmp.Free;
end;
end; }

function Tskychart.DrawNebImages :boolean;
var bmp:Tbitmap;
  filename,objname : string;
  ra,de,width,height,dw,dh: double;
  cosr,sinr: extended;
  x1,y1,x2,y2,rot: Double;
  xx,yy:single;
begin
result:=false;
bmp:=Tbitmap.Create;
try
if northpoleinmap(cfgsc) or southpoleinmap(cfgsc) then begin
  x1:=0;
  x2:=pi2;
end else begin
  x1 := NormRA(cfgsc^.racentre-cfgsc^.fov/cos(cfgsc^.decentre)-deg2rad);
  x2 := NormRA(cfgsc^.racentre+cfgsc^.fov/cos(cfgsc^.decentre)+deg2rad);
end;
y1 := maxvalue([-pid2,cfgsc^.decentre-cfgsc^.fov/cfgsc^.WindowRatio-deg2rad]);
y2 := minvalue([pid2,cfgsc^.decentre+cfgsc^.fov/cfgsc^.WindowRatio+deg2rad]);
if FFits.OpenDB('other',x1,x2,y1,y2) then
  while FFits.GetDB(filename,objname,ra,de,width,height,rot) do begin
    if (objname='BKG') and (not cfgsc^.ShowBackgroundImage) then continue;
    sincos(rot,sinr,cosr);
    precession(jd2000,cfgsc^.JDChart,ra,de);
    if cfgsc^.ApparentPos then apparent_equatorial(ra,de,cfgsc);
    projection(ra,de,x1,y1,true,cfgsc) ;
    WindowXY(x1,y1,xx,yy,cfgsc);
    dw:=(width*cosr+height*sinr)*abs(cfgsc^.BxGlb)/2;
    dh:=(height*cosr+width*sinr)*abs(cfgsc^.ByGlb)/2;
    if ((xx+dw)>cfgsc^.Xmin) and ((xx-dw)<cfgsc^.Xmax) and ((yy+dh)>cfgsc^.Ymin) and ((yy-dh)<cfgsc^.Ymax)
        and (abs(max(width,height)*cfgsc^.BxGlb)>10)
    then begin
       result:=true;
       FFits.FileName:=filename;
       if FFits.Header.valid then begin
          FFits.GetBitmap(bmp);
          projection(ra,de+0.001,x2,y2,false,cfgsc) ;
          rot:=FFits.Rotation-arctan2((x2-x1),(y2-y1));
          Fplot.plotimage(xx,yy,abs(FFits.Img_Width*cfgsc^.BxGlb),abs(FFits.Img_Height*cfgsc^.ByGlb),rot,cfgsc^.FlipX,cfgsc^.FlipY, cfgsc^.WhiteBg,(objname<>'BKG'), bmp);
       end;
    end;
  end;
finally
 bmp.Free;
end;
end;

function Tskychart.DrawOutline :boolean;
var rec:GcatRec;
  x1,y1: Double;
  xx,yy: single;
  op,lw,col,fs: integer;
begin
fillchar(rec,sizeof(rec),0);
try
if Fcatalog.OpenLin then
 while Fcatalog.readlin(rec) do begin
 precession(rec.options.EquinoxJD,cfgsc^.JDChart,rec.ra,rec.dec);
 if cfgsc^.ApparentPos then apparent_equatorial(rec.ra,rec.dec,cfgsc);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc,true) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 op:=rec.outlines.lineoperation;
 if rec.outlines.valid[vlLinewidth] then lw:=rec.outlines.linewidth else lw:=rec.options.Size;
 if rec.outlines.valid[vlLinetype] then fs:=rec.outlines.linetype else fs:=rec.options.LogSize;
 if cfgsc^.WhiteBg then col:=FPlot.cfgplot^.Color[11]
 else begin
    if rec.outlines.valid[vlLinecolor] then col:=rec.outlines.linecolor else col:=rec.options.Units;
//    col:=addcolor(col,FPlot.cfgplot.Color[0]);
 end;
 FPlot.PlotOutline(xx,yy,op,lw,fs,rec.options.ObjType,cfgsc^.x2,col);
end;
result:=true;
finally
 Fcatalog.CloseLin;
end;
end;

function Tskychart.DrawMilkyWay :boolean;
var rec:GcatRec;
  x1,y1: Double;
  xx,yy:single;
  op,lw,col,fs: integer;
  first:boolean;
begin
result:=false;
if not cfgsc^.ShowMilkyWay then exit;
if cfgsc^.fov<(deg2rad*2) then exit;
fillchar(rec,sizeof(rec),0);
first:=true;
lw:=1;fs:=1;
if cfgsc^.WhiteBg then col:=FPlot.cfgplot^.Color[11]
else begin
   col:=addcolor(FPlot.cfgplot^.Color[22],FPlot.cfgplot^.Color[0]);
end;
if col = FPlot.cfgplot^.bgcolor then cfgsc^.FillMilkyWay:=false;
try
if Fcatalog.OpenMilkyway(cfgsc^.FillMilkyWay) then
 while Fcatalog.readMilkyway(rec) do begin
 if first then begin
    // all the milkyway line use the same property
    if rec.outlines.valid[vlLinewidth] then lw:=rec.outlines.linewidth else lw:=rec.options.Size;
    if rec.outlines.valid[vlLinetype] then fs:=rec.outlines.linetype else fs:=rec.options.LogSize;
    first:=false;
 end;
 precession(rec.options.EquinoxJD,cfgsc^.JDChart,rec.ra,rec.dec);
 if cfgsc^.ApparentPos then apparent_equatorial(rec.ra,rec.dec,cfgsc);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc,true) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 op:=rec.outlines.lineoperation;
 FPlot.PlotOutline(xx,yy,op,lw,fs,rec.options.ObjType,cfgsc^.x2,col);
end;
result:=true;
finally
 Fcatalog.CloseMilkyway;
end;
end;

function Tskychart.DrawPlanet :boolean;
var
  x1,y1,x2,y2,pixscale,ra,dec,jdt,diam,magn,phase,fov,pa,rot,r1,r2,be,dist: Double;
  ppa,poleincl,sunincl,w1,w2,w3 : double;
  xx,yy:single;
  i,j,n,ipla: integer;
  draworder : array[1..11] of integer;
begin
fov:=rad2deg*cfgsc^.fov;
pixscale:=abs(cfgsc^.BxGlb)*deg2rad/3600;
for j:=0 to cfgsc^.SimNb-1 do begin
  draworder[1]:=1;
  for n:=2 to 11 do begin
    if cfgsc^.Planetlst[j,n,6]<cfgsc^.Planetlst[j,draworder[n-1],6] then
       draworder[n]:=n
    else begin
       i:=n;
       repeat
         i:=i-1;
         draworder[i+1]:=draworder[i];
       until (i=1)or(cfgsc^.Planetlst[j,n,6]<=cfgsc^.Planetlst[j,draworder[i-1],6]);
       draworder[i]:=n;
    end;
  end;
  for n:=1 to 11 do begin
    ipla:=draworder[n];
    if (j>0) and (not cfgsc^.SimObject[ipla]) then continue;
    if ipla=3 then continue;
    ra:=cfgsc^.Planetlst[j,ipla,1];
    dec:=cfgsc^.Planetlst[j,ipla,2];
    jdt:=cfgsc^.Planetlst[j,ipla,3];
    diam:=cfgsc^.Planetlst[j,ipla,4];
    magn:=cfgsc^.Planetlst[j,ipla,5];
    phase:=cfgsc^.Planetlst[j,ipla,7];
    projection(ra,dec,x1,y1,true,cfgsc) ;
    WindowXY(x1,y1,xx,yy,cfgsc);
    projection(ra,dec+0.001,x2,y2,false,cfgsc) ;
    rot:=RotationAngle(x1,y1,x2,y2,cfgsc);
    if (ipla<>3)and(ipla<=10) then Fplanet.PlanetOrientation(jdt,ipla,ppa,poleincl,sunincl,w1,w2,w3);
    if (j=0)and(ipla<=11) then SetLabel(1000000+ipla,xx,yy,round(pixscale*diam/2),2,5,pla[ipla]);
    case ipla of
      4 :  begin
            if (fov<=1.5) and (cfgsc^.Planetlst[j,29,6]<90) then for i:=1 to 2 do DrawSatel(j,i+28,cfgsc^.Planetlst[j,i+28,1],cfgsc^.Planetlst[j,i+28,2],cfgsc^.Planetlst[j,i+28,5],cfgsc^.Planetlst[j,i+28,4],pixscale,cfgsc^.Planetlst[j,i+28,6]>1.0,true);
            Fplot.PlotPlanet(xx,yy,cfgsc^.FlipX,cfgsc^.FlipY,ipla,jdt,pixscale,diam,magn,phase,ppa,rot,poleincl,sunincl,w1,0,0,0,cfgsc^.WhiteBg);
            if (fov<=1.5) and (cfgsc^.Planetlst[j,29,6]<90) then for i:=1 to 2 do DrawSatel(j,i+28,cfgsc^.Planetlst[j,i+28,1],cfgsc^.Planetlst[j,i+28,2],cfgsc^.Planetlst[j,i+28,5],cfgsc^.Planetlst[j,i+28,4],pixscale,cfgsc^.Planetlst[j,i+28,6]>1.0,false);
           end;
      5 :  begin
            if (fov<=5) and (cfgsc^.Planetlst[j,12,6]<90) then for i:=1 to 4 do DrawSatel(j,i+11,cfgsc^.Planetlst[j,i+11,1],cfgsc^.Planetlst[j,i+11,2],cfgsc^.Planetlst[j,i+11,5],cfgsc^.Planetlst[j,i+11,4],pixscale,cfgsc^.Planetlst[j,i+11,6]>1.0,true);
            Fplot.PlotPlanet(xx,yy,cfgsc^.FlipX,cfgsc^.FlipY,ipla,jdt,pixscale,diam,magn,phase,ppa,rot,poleincl,sunincl,w2,cfgsc^.GRSlongitude,0,0,cfgsc^.WhiteBg);
            if (fov<=5) and (cfgsc^.Planetlst[j,12,6]<90) then for i:=1 to 4 do DrawSatel(j,i+11,cfgsc^.Planetlst[j,i+11,1],cfgsc^.Planetlst[j,i+11,2],cfgsc^.Planetlst[j,i+11,5],cfgsc^.Planetlst[j,i+11,4],pixscale,cfgsc^.Planetlst[j,i+11,6]>1.0,false);
           end;
      6 :  begin
            if (fov<=2) and (cfgsc^.Planetlst[j,16,6]<90) then for i:=1 to 8 do DrawSatel(j,i+15,cfgsc^.Planetlst[j,i+15,1],cfgsc^.Planetlst[j,i+15,2],cfgsc^.Planetlst[j,i+15,5],cfgsc^.Planetlst[j,i+15,4],pixscale,cfgsc^.Planetlst[j,i+15,6]>1.0,true);
            r1:=cfgsc^.Planetlst[j,31,2];
            r2:=cfgsc^.Planetlst[j,31,3];
            be:=cfgsc^.Planetlst[j,31,4];
            Fplot.PlotPlanet(xx,yy,cfgsc^.FlipX,cfgsc^.FlipY,ipla,jdt,pixscale,diam,magn,phase,ppa,rot,poleincl,sunincl,w1,r1,r2,be,cfgsc^.WhiteBg);
            if (fov<=2) and (cfgsc^.Planetlst[j,16,6]<90) then for i:=1 to 8 do DrawSatel(j,i+15,cfgsc^.Planetlst[j,i+15,1],cfgsc^.Planetlst[j,i+15,2],cfgsc^.Planetlst[j,i+15,5],cfgsc^.Planetlst[j,i+15,4],pixscale,cfgsc^.Planetlst[j,i+15,6]>1.0,false);
           end;
      7 :  begin
            if (fov<=1.5) and (cfgsc^.Planetlst[j,24,6]<90) then for i:=1 to 5 do DrawSatel(j,i+23,cfgsc^.Planetlst[j,i+23,1],cfgsc^.Planetlst[j,i+23,2],cfgsc^.Planetlst[j,i+23,5],cfgsc^.Planetlst[j,i+23,4],pixscale,cfgsc^.Planetlst[j,i+23,6]>1.0,true);
            Fplot.PlotPlanet(xx,yy,cfgsc^.FlipX,cfgsc^.FlipY,ipla,jdt,pixscale,diam,magn,phase,ppa,rot,poleincl,sunincl,w1,0,0,0,cfgsc^.WhiteBg);
            if (fov<=1.5) and (cfgsc^.Planetlst[j,24,6]<90) then for i:=1 to 5 do DrawSatel(j,i+23,cfgsc^.Planetlst[j,i+23,1],cfgsc^.Planetlst[j,i+23,2],cfgsc^.Planetlst[j,i+23,5],cfgsc^.Planetlst[j,i+23,4],pixscale,cfgsc^.Planetlst[j,i+23,6]>1.0,false);
           end;
      11 : begin
            magn:=-10;  // better to alway show a bright dot for the Moon
            dist:=cfgsc^.Planetlst[j,ipla,6];
            fplanet.MoonOrientation(jdt,ra,dec,dist,pa,poleincl,sunincl,w1);
            Fplot.PlotPlanet(xx,yy,cfgsc^.FlipX,cfgsc^.FlipY,ipla,jdt,pixscale,diam,magn,phase,pa,rot,poleincl,sunincl,-w1,0,0,0,cfgsc^.WhiteBg);
           end;
      else begin
            Fplot.PlotPlanet(xx,yy,cfgsc^.FlipX,cfgsc^.FlipY,ipla,jdt,pixscale,diam,magn,phase,ppa,rot,poleincl,sunincl,w1,0,0,0,cfgsc^.WhiteBg);
           end;
    end;
  end;
  if cfgsc^.ShowEarthShadow then DrawEarthShadow(cfgsc^.Planetlst[j,32,1],cfgsc^.Planetlst[j,32,2],cfgsc^.Planetlst[j,32,3],cfgsc^.Planetlst[j,32,4],cfgsc^.Planetlst[j,32,5]);
end;
result:=true;
end;

Procedure Tskychart.DrawEarthShadow(AR,DE,SunDist,MoonDist,MoonDistTopo : double);
var x,y,cone,umbra,penumbra,pixscale : double;
    xx,yy: single;
begin
 projection(ar,de,x,y,true,cfgsc) ;
 windowxy(x,y,xx,yy,cfgsc);
 cone:=SunDist*12.78/(1392-12.78);  // earth diam = 12.78 (12776 incl atmophere) ; sun diam = 1392 (*1000 km)
 umbra:=12776*(cone-MoonDist)/cone;
 umbra:=arctan2(umbra,MoonDistTopo);
 penumbra:=umbra+1.07*deg2rad;  // + 2x sun diameter
 pixscale:=abs(cfgsc^.BxGlb);
 Fplot.PlotEarthShadow(xx,yy,umbra,penumbra,pixscale);
// SetLabel(1000032,xx,yy,round(pixscale*penumbra/2),2,5,'Earth Shadow');
end;

Procedure Tskychart.DrawSatel(j,ipla:integer; ra,dec,ma,diam,pixscale : double; hidesat, showhide : boolean);
var
  x1,y1 : double;
  xx,yy : single;
begin
projection(ra,dec,x1,y1,true,cfgsc) ;
WindowXY(x1,y1,xx,yy,cfgsc);
Fplot.PlotSatel(xx,yy,ipla,pixscale,ma,diam,hidesat,showhide);
if not(hidesat xor showhide)and(j=0) then SetLabel(1000000+ipla,xx,yy,round(pixscale*diam/2),2,5,pla[ipla]);
end;

function Tskychart.DrawAsteroid :boolean;
var
  x1,y1,ra,dec,magn: Double;
  xx,yy:single;
  i,j,lid: integer;
begin
if cfgsc^.ShowAsteroid then begin
  Fplanet.ComputeAsteroid(cfgsc);
  for j:=0 to cfgsc^.SimNb-1 do begin
    if (j>0) and (not cfgsc^.SimObject[12]) then break;
    for i:=1 to cfgsc^.AsteroidNb do begin
      ra:=cfgsc^.AsteroidLst[j,i,1];
      dec:=cfgsc^.AsteroidLst[j,i,2];
      magn:=cfgsc^.AsteroidLst[j,i,3];
      projection(ra,dec,x1,y1,true,cfgsc);
      WindowXY(x1,y1,xx,yy,cfgsc);
      Fplot.PlotAsteroid(xx,yy,cfgsc^.AstSymbol,magn);
      if (j=0)and(magn<cfgsc^.StarMagMax+cfgsc^.AstMagDiff-cfgsc^.LabelMagDiff[5]) then begin
         lid:=GetId(cfgsc^.AsteroidName[j,i,1]);
         SetLabel(lid,xx,yy,0,2,5,cfgsc^.AsteroidName[j,i,2]);
      end;
    end;
  end;
  result:=true;
end else begin
  cfgsc^.AsteroidNb:=0;
  result:=false;
end;
end;

function Tskychart.DrawComet :boolean;
var
  x1,y1: Double;
  xx,yy,cxx,cyy:single;
  i,j,lid,sz : integer;
begin
if cfgsc^.ShowComet then begin
  Fplanet.ComputeComet(cfgsc);
  for j:=0 to cfgsc^.SimNb-1 do begin
    if (j>0) and (not cfgsc^.SimObject[13]) then break;
    for i:=1 to cfgsc^.CometNb do begin
      projection(cfgsc^.CometLst[j,i,1],cfgsc^.CometLst[j,i,2],x1,y1,true,cfgsc);
      WindowXY(x1,y1,xx,yy,cfgsc);
      if (j=0)and(cfgsc^.CometLst[j,i,3]<cfgsc^.StarMagMax+cfgsc^.ComMagDiff-cfgsc^.LabelMagDiff[5]) then begin
         lid:=GetId(cfgsc^.CometName[j,i,1]);
         sz:=round(abs(cfgsc^.BxGlb)*deg2rad/60*cfgsc^.CometLst[j,i,4]/2);
         SetLabel(lid,xx,yy,sz,2,5,cfgsc^.CometName[j,i,2]);
      end;
      if projection(cfgsc^.CometLst[j,i,5],cfgsc^.CometLst[j,i,6],x1,y1,true,cfgsc) then
         WindowXY(x1,y1,cxx,cyy,cfgsc)
      else begin cxx:=xx; cyy:=yy; end;
      Fplot.PlotComet(xx,yy,cxx,cyy,cfgsc^.Comsymbol, cfgsc^.CometLst[j,i,3],cfgsc^.CometLst[j,i,4],abs(cfgsc^.BxGlb)*deg2rad/60);
    end;
  end;
  result:=true;
end else begin
  cfgsc^.CometNb:=0;
  result:=false;
end;
end;

function Tskychart.DrawOrbitPath:boolean;
var i,j,color : integer;
    x1,y1 : double;
    xx,yy,xp,yp:single;
begin
Color:=Fplot.cfgplot^.Color[14];
xp:=0;yp:=0;
if cfgsc^.ShowPlanet then for i:=1 to 11 do
  if (i<>3)and(cfgsc^.SimObject[i]) then for j:=0 to cfgsc^.SimNb-1 do begin
    projection(cfgsc^.Planetlst[j,i,1],cfgsc^.Planetlst[j,i,2],x1,y1,true,cfgsc) ;
    windowxy(x1,y1,xx,yy,cfgsc);
    if (j<>0)and((xx>-2*cfgsc^.xmax)and(yy>-2*cfgsc^.ymax)and(xx<3*cfgsc^.xmax)and(yy<3*cfgsc^.ymax))
       and ((xp>-2*cfgsc^.xmax)and(yp>-2*cfgsc^.ymax)and(xp<3*cfgsc^.xmax)and(yp<3*cfgsc^.ymax)) then
       Fplot.PlotLine(xp,yp,xx,yy,color,1);
    xp:=xx;
    yp:=yy;
end;
xp:=0;yp:=0;
if cfgsc^.SimObject[13] then for i:=1 to cfgsc^.CometNb do
  for j:=0 to cfgsc^.SimNb-1 do begin
    projection(cfgsc^.CometLst[j,i,1],cfgsc^.CometLst[j,i,2],x1,y1,true,cfgsc) ;
    windowxy(x1,y1,xx,yy,cfgsc);
    if (j<>0)and((xx>-2*cfgsc^.xmax)and(yy>-2*cfgsc^.ymax)and(xx<3*cfgsc^.xmax)and(yy<3*cfgsc^.ymax))
       and ((xp>-2*cfgsc^.xmax)and(yp>-2*cfgsc^.ymax)and(xp<3*cfgsc^.xmax)and(yp<3*cfgsc^.ymax)) then
       Fplot.PlotLine(xp,yp,xx,yy,color,1);
    xp:=xx;
    yp:=yy;
  end;
xp:=0;yp:=0;
if cfgsc^.SimObject[12] then for i:=1 to cfgsc^.AsteroidNb do
  for j:=0 to cfgsc^.SimNb-1 do begin
    projection(cfgsc^.AsteroidLst[j,i,1],cfgsc^.AsteroidLst[j,i,2],x1,y1,true,cfgsc) ;
    windowxy(x1,y1,xx,yy,cfgsc);
    if (j<>0)and((xx>-2*cfgsc^.xmax)and(yy>-2*cfgsc^.ymax)and(xx<3*cfgsc^.xmax)and(yy<3*cfgsc^.ymax))
       and ((xp>-2*cfgsc^.xmax)and(yp>-2*cfgsc^.ymax)and(xp<3*cfgsc^.xmax)and(yp<3*cfgsc^.ymax)) then
       Fplot.PlotLine(xp,yp,xx,yy,color,1);
    xp:=xx;
    yp:=yy;
  end;
result:=true;
end;

procedure Tskychart.GetCoord(x,y: integer; var ra,dec,a,h,l,b,le,be:double);
begin
getadxy(x,y,ra,dec,cfgsc);
GetAHxy(X,Y,a,h,cfgsc);
if Fcatalog.cfgshr.AzNorth then a:=rmod(a+pi,pi2);
GetLBxy(X,Y,l,b,cfgsc);
GetLBExy(X,Y,le,be,cfgsc);
ra:=rmod(ra+pi2,pi2);
a:=rmod(a+pi2,pi2);
l:=rmod(l+pi2,pi2);
le:=rmod(le+pi2,pi2);
end;

procedure Tskychart.MoveChart(ns,ew:integer; movefactor:double);
begin
 cfgsc^.TrackOn:=false;
 if cfgsc^.Projpole=AltAz then begin
    cfgsc^.acentre:=rmod(cfgsc^.acentre-ew*cfgsc^.fov/movefactor/cos(cfgsc^.hcentre)+pi2,pi2);
    cfgsc^.hcentre:=cfgsc^.hcentre+ns*cfgsc^.fov/movefactor/cfgsc^.windowratio;
    if cfgsc^.hcentre>pid2 then cfgsc^.hcentre:=pi-cfgsc^.hcentre;
    Hz2Eq(cfgsc^.acentre,cfgsc^.hcentre,cfgsc^.racentre,cfgsc^.decentre,cfgsc);
    cfgsc^.racentre:=cfgsc^.CurST-cfgsc^.racentre;
 end
 else if cfgsc^.Projpole=Gal then begin
    cfgsc^.lcentre:=rmod(cfgsc^.lcentre+ew*cfgsc^.fov/movefactor/cos(cfgsc^.bcentre)+pi2,pi2);
    cfgsc^.bcentre:=cfgsc^.bcentre+ns*cfgsc^.fov/movefactor/cfgsc^.windowratio;
    if cfgsc^.bcentre>pid2 then cfgsc^.bcentre:=pi-cfgsc^.bcentre;
    Gal2Eq(cfgsc^.lcentre,cfgsc^.bcentre,cfgsc^.racentre,cfgsc^.decentre,cfgsc);
 end
 else if cfgsc^.Projpole=Ecl then begin
    cfgsc^.lecentre:=rmod(cfgsc^.lecentre+ew*cfgsc^.fov/movefactor/cos(cfgsc^.becentre)+pi2,pi2);
    cfgsc^.becentre:=cfgsc^.becentre+ns*cfgsc^.fov/movefactor/cfgsc^.windowratio;
    if cfgsc^.becentre>pid2 then cfgsc^.becentre:=pi-cfgsc^.becentre;
    Ecl2Eq(cfgsc^.lecentre,cfgsc^.becentre,cfgsc^.e,cfgsc^.racentre,cfgsc^.decentre);
 end
 else begin // Equ
    cfgsc^.racentre:=rmod(cfgsc^.racentre+ew*cfgsc^.fov/movefactor/cos(cfgsc^.decentre)+pi2,pi2);
    cfgsc^.decentre:=cfgsc^.decentre+ns*cfgsc^.fov/movefactor/cfgsc^.windowratio;
    if cfgsc^.decentre>pid2 then cfgsc^.decentre:=pi-cfgsc^.decentre;
end;
end;

procedure Tskychart.MovetoXY(X,Y : integer);
begin
   GetADxy(X,Y,cfgsc^.racentre,cfgsc^.decentre,cfgsc);
   cfgsc^.racentre:=rmod(cfgsc^.racentre+pi2,pi2);
end;

procedure Tskychart.MovetoRaDec(ra,dec:double);
begin
   cfgsc^.racentre:=rmod(ra+pi2,pi2);
   cfgsc^.decentre:=dec;
end;

procedure Tskychart.Zoom(zoomfactor:double);
begin
 SetFOV(cfgsc^.fov/zoomfactor);
end;

procedure Tskychart.SetFOV(f:double);
begin
 cfgsc^.fov := f;
 if cfgsc^.fov<FovMin then cfgsc^.fov:=FovMin;
 if cfgsc^.fov>FovMax then cfgsc^.fov:=FovMax;
end;

Procedure Tskychart.FormatCatRec(rec:Gcatrec; var desc:string);
var txt: string;
    i : integer;
const b=' ';
      b5='     ';
      dp = ':';
begin
 cfgsc^.FindRA:=rec.ra;
 cfgsc^.FindDec:=rec.dec;
 cfgsc^.FindSize:=0;
 desc:= ARpToStr(rmod(rad2deg*rec.ra/15+24,24))+tab+DEpToStr(rad2deg*rec.dec)+tab;
 case rec.options.rectype of
 rtStar: begin   // stars
         if rec.star.valid[vsId] then txt:=rec.star.id else txt:='';
         if trim(txt)='' then Fcatalog.GetAltName(rec,txt);
         txt:=rec.options.ShortName+b+txt;
         cfgsc^.FindName:=txt;
         Desc:=Desc+'  *'+tab+txt+tab;
         if rec.star.magv<90 then str(rec.star.magv:5:2,txt) else txt:=b5;
         Desc:=Desc+trim(rec.options.flabel[lOffset+vsMagv])+dp+txt+tab;
         if rec.star.valid[vsB_v] then begin
            if (rec.star.b_v<90) then str(rec.star.b_v:5:2,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vsB_v])+dp+txt+tab;
         end;
         if rec.star.valid[vsMagb] then begin
            if (rec.star.magb<90) then str(rec.star.magb:5:2,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vsMagb])+dp+txt+tab;
         end;
         if rec.star.valid[vsMagr] then begin
            if (rec.star.magr<90) then str(rec.star.magr:5:2,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vsMagr])+dp+txt+tab;
         end;
         if rec.star.valid[vsSp] then Desc:=Desc+trim(rec.options.flabel[lOffset+vsSp])+dp+rec.star.sp+tab;
         if rec.star.valid[vsPmra] then begin
            str(rad2deg*3600*rec.star.pmra:6:3,txt);
            Desc:=Desc+trim(rec.options.flabel[lOffset+vsPmra])+dp+txt+tab;
         end;
         if rec.star.valid[vsPmdec] then begin
            str(rad2deg*3600*rec.star.pmdec:6:3,txt);
            Desc:=Desc+trim(rec.options.flabel[lOffset+vsPmdec])+dp+txt+tab;
         end;
         if rec.star.valid[vsEpoch] then begin
            str(rec.star.epoch:8:2,txt);
            Desc:=Desc+trim(rec.options.flabel[lOffset+vsEpoch])+dp+txt+tab;
         end;
         if rec.star.valid[vsPx] then begin
            str(rec.star.px:6:4,txt);
            Desc:=Desc+trim(rec.options.flabel[lOffset+vsPx])+dp+txt+tab;
            if rec.star.px>0 then begin
               str(3.2616/rec.star.px:5:1,txt);
               Desc:=Desc+'Dist:'+txt+b+'ly'+tab;
            end;
         end;
         if rec.star.valid[vsComment] then
            Desc:=Desc+trim(rec.options.flabel[lOffset+vsComment])+dp+b+rec.star.comment+tab;
         end;
 rtVar : begin   // variables stars
         if rec.variable.valid[vvId] then txt:=rec.variable.id else txt:='';
         if trim(txt)='' then Fcatalog.GetAltName(rec,txt);
         txt:=rec.options.ShortName+b+txt;
         cfgsc^.FindName:=txt;
         Desc:=Desc+' V*'+tab+txt+tab;
         if rec.variable.valid[vvVartype] then Desc:=Desc+trim(rec.options.flabel[lOffset+vvVartype])+dp+rec.variable.vartype+tab;
         if rec.variable.valid[vvMagcode] then Desc:=Desc+trim(rec.options.flabel[lOffset+vvMagcode])+dp+rec.variable.magcode+tab;
         if rec.variable.valid[vvMagmax] then begin
            if (rec.variable.magmax<90) then str(rec.variable.magmax:5:2,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vvMagmax])+dp+txt+tab;
         end;
         if rec.variable.valid[vvMagmin] then begin
            if (rec.variable.magmin<90) then str(rec.variable.magmin:5:2,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vvMagmin])+dp+txt+tab;
         end;
         if rec.variable.valid[vvPeriod] then begin
            str(rec.variable.period:16:10,txt);
            Desc:=Desc+trim(rec.options.flabel[lOffset+vvPeriod])+dp+txt+tab;
         end;
         if rec.variable.valid[vvMaxepoch] then begin
            str(rec.variable.Maxepoch:16:10,txt);
            Desc:=Desc+trim(rec.options.flabel[lOffset+vvMaxepoch])+dp+txt+tab;
         end;
         if rec.variable.valid[vvRisetime] then begin
            str(rec.variable.risetime:5:2,txt);
            Desc:=Desc+trim(rec.options.flabel[lOffset+vvRisetime])+dp+txt+tab;
         end;
         if rec.variable.valid[vvSp] then Desc:=Desc+trim(rec.options.flabel[lOffset+vvSp])+dp+rec.variable.sp+tab;
         if rec.variable.valid[vvComment] then Desc:=Desc+trim(rec.options.flabel[lOffset+vvComment])+dp+rec.variable.comment+tab;
         end;
 rtDbl : begin   // doubles stars
         if rec.double.valid[vdId] then txt:=rec.double.id else txt:='';
         if trim(txt)='' then Fcatalog.GetAltName(rec,txt);
         txt:=rec.options.ShortName+b+txt;
         cfgsc^.FindName:=txt;
         Desc:=Desc+' D*'+tab+txt+tab;
         if rec.double.valid[vdCompname] then begin
            Desc:=Desc+rec.double.compname+tab;
            cfgsc^.FindName:=cfgsc^.FindName+blank+trim(rec.double.compname);
         end;
         if rec.double.valid[vdMag1] then begin
            if (rec.double.mag1<90) then str(rec.double.mag1:5:2,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vdMag1])+dp+txt+tab;
         end;
         if rec.double.valid[vdMag2] then begin
            if (rec.double.mag2<90) then str(rec.double.mag2:5:2,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vdMag2])+dp+txt+tab;
         end;
         if rec.double.valid[vdSep] then begin
            if (rec.double.sep>0) then str(rec.double.sep:5:1,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vdSep])+dp+txt+tab;
            // cfgsc^.FindSize:=rec.double.sep*secarc;
         end;
         if rec.double.valid[vdPa] then begin
            if (rec.double.pa>0) then str(round(rec.double.pa-rad2deg*PoleRot2000(rec.ra,rec.dec)):3,txt) else txt:='   ';
            Desc:=Desc+trim(rec.options.flabel[lOffset+vdPa])+dp+txt+tab;
         end;
         if rec.double.valid[vdEpoch] then begin
            str(rec.double.epoch:4:2,txt);
            Desc:=Desc+trim(rec.options.flabel[lOffset+vdEpoch])+dp+txt+tab;
         end;
         if rec.double.valid[vdSp1] then Desc:=Desc+trim(rec.options.flabel[lOffset+vdSp1])+dp+' 1 '+rec.double.sp1+tab;
         if rec.double.valid[vdSp2] then Desc:=Desc+trim(rec.options.flabel[lOffset+vdSp2])+dp+' 2 '+rec.double.sp2+tab;
         if rec.double.valid[vdComment] then Desc:=Desc+trim(rec.options.flabel[lOffset+vdComment])+dp+rec.double.comment+tab;
         end;
 rtNeb : begin   // nebulae
         if rec.neb.valid[vnId] then txt:=rec.neb.id else txt:='';
         if trim(txt)='' then Fcatalog.GetAltName(rec,txt);
         cfgsc^.FindName:=txt;
         if rec.neb.valid[vnNebtype] then i:=rec.neb.nebtype
                                        else i:=rec.options.ObjType;
         Desc:=Desc+nebtype[i+2]+tab+txt+tab;
         if rec.neb.valid[vnMag] then begin
            if (rec.neb.mag<90) then str(rec.neb.mag:5:2,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vnMag])+dp+txt+tab;
         end;
         if rec.neb.valid[vnSbr] then begin
            if (rec.neb.sbr<90) then str(rec.neb.sbr:5:2,txt) else txt:=b5;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vnSbr])+dp+txt+tab;
         end;
         if rec.options.LogSize=0 then begin
            if rec.neb.valid[vnDim1] then cfgsc^.FindSize:=rec.neb.dim1
                                     else cfgsc^.FindSize:=rec.options.Size;
            str(cfgsc^.FindSize:5:1,txt);
            Desc:=Desc+'Dim'+dp+txt;
            if rec.neb.valid[vnDim2] and (rec.neb.dim2>0) then str(rec.neb.dim2:5:1,txt);
            Desc:=Desc+' x'+txt+b;
            if rec.neb.valid[vnNebunit] then i:=rec.neb.nebunit
                                        else i:=rec.options.Units;
            if i=0 then i:=1;                            
            cfgsc^.FindSize:=deg2rad*cfgsc^.FindSize/i;
            case i of
            1    : Desc:=Desc+ldeg;
            60   : Desc:=Desc+lmin;
            3600 : Desc:=Desc+lsec;
            end;
            Desc:=Desc+tab;
         end else begin
            if rec.neb.valid[vnDim1] then str(rec.neb.dim1:5:1,txt)
                                     else txt:=b5;
            Desc:=Desc+'Flux:'+txt+tab;
         end;
         if rec.neb.valid[vnPa] then begin
            if (rec.neb.pa>0) then str(rec.neb.pa-rad2deg*PoleRot2000(rec.ra,rec.dec):3:0,txt) else txt:='   ';
            Desc:=Desc+trim(rec.options.flabel[lOffset+vnPa])+dp+txt+tab;
         end;
         if rec.neb.valid[vnRv] then begin
            str(rec.neb.rv:6:0,txt) ;
            Desc:=Desc+trim(rec.options.flabel[lOffset+vnRv])+dp+txt+tab;
         end;
         if rec.neb.valid[vnMorph] then Desc:=Desc+trim(rec.options.flabel[lOffset+vnMorph])+dp+rec.neb.morph+tab;
         if rec.neb.valid[vnComment] then Desc:=Desc+trim(rec.options.flabel[lOffset+vnComment])+dp+rec.neb.comment+tab;
         end;
 end;
 for i:=1 to 10 do begin
   if rec.vstr[i] then Desc:=Desc+trim(rec.options.flabel[15+i])+dp+rec.str[i]+tab;
 end;
 for i:=1 to 10 do begin
   if rec.vnum[i] then Desc:=Desc+trim(rec.options.flabel[25+i])+dp+formatfloat('0.0####',rec.num[i])+tab;
 end;
 cfgsc^.FindName:=wordspace(cfgsc^.FindName);
 cfgsc^.FindDesc:=Desc;
 cfgsc^.FindNote:='';
end;

function Tskychart.FindatRaDec(ra,dec,dx: double;showall:boolean=false):boolean;
var x1,x2,y1,y2:double;
    rec: Gcatrec;
    desc,n,m,d: string;
    saveStarFilter,saveNebFilter:boolean;
begin
x1 := NormRA(ra-dx/cos(dec));
x2 := NormRA(ra+dx/cos(dec));
if x2<x1 then x2:=x2+pi2;
y1 := max(-pid2,dec-dx);
y2 := min(pid2,dec+dx);
desc:='';
Fcatalog.OpenCat(cfgsc);
InitCatalog;
saveNebFilter:=Fcatalog.cfgshr.NebFilter;
saveStarFilter:=Fcatalog.cfgshr.StarFilter;
if showall then begin
  Fcatalog.cfgshr.NebFilter:=false;
  Fcatalog.cfgshr.StarFilter:=false;
end;
// search catalog object
try
  result:=fcatalog.Findobj(x1,y1,x2,y2,false,cfgsc,rec);
finally
  Fcatalog.CloseCat;
  if showall then begin
    Fcatalog.cfgshr.NebFilter:=saveNebFilter;
    Fcatalog.cfgshr.StarFilter:=saveStarFilter;
  end;
end;
if result then begin
   FormatCatRec(rec,desc);
   cfgsc^.TrackType:=6;
   cfgsc^.TrackName:=cfgsc^.FindName;
   cfgsc^.TrackRA:=rec.ra;
   cfgsc^.TrackDec:=rec.dec;
end else begin
// search solar system object
   result:=fplanet.findplanet(x1,y1,x2,y2,false,cfgsc,n,m,d,desc);
   if result then begin
      if cfgsc^.SimNb>1 then cfgsc^.FindName:=cfgsc^.FindName+blank+d; // add date to the name if simulation for more than one date
   end else begin
      result:=fplanet.findasteroid(x1,y1,x2,y2,false,cfgsc,n,m,d,desc);
      if result then begin
         if cfgsc^.SimNb>1 then cfgsc^.FindName:=cfgsc^.FindName+blank+d;
   end else begin
      result:=fplanet.findcomet(x1,y1,x2,y2,false,cfgsc,n,m,d,desc);
      if result then begin
         if cfgsc^.SimNb>1 then cfgsc^.FindName:=cfgsc^.FindName+blank+d;
      end;
   end;
end;
end;
end;

procedure Tskychart.FindList(ra,dec,dx,dy: double;var text:widestring;showall,allobject,trunc:boolean);
// todo: do not work if crossing 0h ra
var x1,x2,y1,y2,xx1,yy1:double;
    rec: Gcatrec;
    desc,n,m,d: string;
    saveStarFilter,saveNebFilter,ok:boolean;
    i:integer;
    xx,yy:single;
const maxln : integer = 2000;
Procedure FindatPosCat(cat:integer);
begin
 ok:=fcatalog.FindatPos(cat,x1,y1,x2,y2,false,trunc,cfgsc,rec);
 while ok do begin
   if i>maxln then break;
   projection(rec.ra,rec.dec,xx1,yy1,true,cfgsc) ;
   windowxy(xx1,yy1,xx,yy,cfgsc);
   if (xx>cfgsc^.Xmin) and (xx<cfgsc^.Xmax) and (yy>cfgsc^.Ymin) and (yy<cfgsc^.Ymax) then begin
      FormatCatRec(rec,desc);
      text:=text+desc+crlf;
      inc(i);
   end;   
   ok:=fcatalog.FindatPos(cat,x1,y1,x2,y2,true,trunc,cfgsc,rec);
 end;
 fcatalog.CloseCat;
end;
Procedure FindatPosPlanet;
begin
 ok:=fplanet.findplanet(x1,y1,x2,y2,false,cfgsc,n,m,d,desc);
 while ok do begin
   if i>maxln then break;
   projection(cfgsc^.findra,cfgsc^.finddec,xx1,yy1,true,cfgsc) ;
   windowxy(xx1,yy1,xx,yy,cfgsc);
   if (xx>cfgsc^.Xmin) and (xx<cfgsc^.Xmax) and (yy>cfgsc^.Ymin) and (yy<cfgsc^.Ymax) then begin
      text:=text+desc+crlf;
      inc(i);
   end;
   ok:=fplanet.findplanet(x1,y1,x2,y2,true,cfgsc,n,m,d,desc);
 end;
end;
Procedure FindatPosAsteroid;
begin
 ok:=fplanet.findasteroid(x1,y1,x2,y2,false,cfgsc,n,m,d,desc);
 while ok do begin
   if i>maxln then break;
   projection(cfgsc^.findra,cfgsc^.finddec,xx1,yy1,true,cfgsc) ;
   windowxy(xx1,yy1,xx,yy,cfgsc);
   if (xx>cfgsc^.Xmin) and (xx<cfgsc^.Xmax) and (yy>cfgsc^.Ymin) and (yy<cfgsc^.Ymax) then begin
      text:=text+desc+crlf;
      inc(i);
   end;
   ok:=fplanet.findasteroid(x1,y1,x2,y2,true,cfgsc,n,m,d,desc);
 end;
end;
Procedure FindatPosComet;
begin
 ok:=fplanet.findcomet(x1,y1,x2,y2,false,cfgsc,n,m,d,desc);
 while ok do begin
   if i>maxln then break;
   projection(cfgsc^.findra,cfgsc^.finddec,xx1,yy1,true,cfgsc) ;
   windowxy(xx1,yy1,xx,yy,cfgsc);
   if (xx>cfgsc^.Xmin) and (xx<cfgsc^.Xmax) and (yy>cfgsc^.Ymin) and (yy<cfgsc^.Ymax) then begin
      text:=text+desc+crlf;
      inc(i);
   end;
   ok:=fplanet.findcomet(x1,y1,x2,y2,true,cfgsc,n,m,d,desc);
 end;
end;
/////////////
begin
if northpoleinmap(cfgsc) or southpoleinmap(cfgsc) then begin
  x1:=0;
  x2:=pi2;
end else begin
  x1 := NormRA(ra-dx/cos(dec));
  x2 := NormRA(ra+dx/cos(dec));
  if x2<x1 then x2:=x2+pi2;
end;
y1 := max(-pid2,dec-dy);
y2 := min(pid2,dec+dy);
text:='';
Fcatalog.OpenCat(cfgsc);
InitCatalog;
saveNebFilter:=Fcatalog.cfgshr.NebFilter;
saveStarFilter:=Fcatalog.cfgshr.StarFilter;
if showall then begin
  Fcatalog.cfgshr.NebFilter:=false;
  Fcatalog.cfgshr.StarFilter:=false;
end;
// search catalog object
try
  i:=0;
  if allobject or Fcatalog.cfgshr.ListPla then FindatPosPlanet;
  if allobject or Fcatalog.cfgshr.ListPla then FindatPosComet;
  if allobject or Fcatalog.cfgshr.ListPla then FindatPosAsteroid;
  if allobject or Fcatalog.cfgshr.ListNeb then begin
     FindAtPosCat(gcneb);
     if Fcatalog.cfgcat.nebcaton[sac-BaseNeb] then FindAtPosCat(sac);
     if Fcatalog.cfgcat.nebcaton[ngc-BaseNeb] then FindAtPosCat(ngc);
     if Fcatalog.cfgcat.nebcaton[lbn-BaseNeb] then FindAtPosCat(lbn);
     if Fcatalog.cfgcat.nebcaton[rc3-BaseNeb] then FindAtPosCat(rc3);
     if Fcatalog.cfgcat.nebcaton[pgc-BaseNeb] then FindAtPosCat(pgc);
     if Fcatalog.cfgcat.nebcaton[ocl-BaseNeb] then FindAtPosCat(ocl);
     if Fcatalog.cfgcat.nebcaton[gcm-BaseNeb] then FindAtPosCat(gcm);
     if Fcatalog.cfgcat.nebcaton[gpn-BaseNeb] then FindAtPosCat(gpn);
  end;
  if allobject or Fcatalog.cfgshr.ListVar then begin
     FindAtPosCat(gcvar);
     if Fcatalog.cfgcat.varstarcaton[gcvs-BaseVar] then FindAtPosCat(gcvs);
  end;
  if allobject or Fcatalog.cfgshr.ListDbl then begin
     FindAtPosCat(gcdbl);
     if Fcatalog.cfgcat.dblstarcaton[wds-BaseDbl]  then FindAtPosCat(wds);
  end;
  if allobject or Fcatalog.cfgshr.ListStar then begin
     FindAtPosCat(gcstar);
     if Fcatalog.cfgcat.starcaton[bsc-BaseStar] then FindAtPosCat(bsc);
     if Fcatalog.cfgcat.starcaton[dsbase-BaseStar] then FindAtPosCat(dsbase);
     if Fcatalog.cfgcat.starcaton[sky2000-BaseStar] then FindAtPosCat(sky2000);
     if Fcatalog.cfgcat.starcaton[tyc-BaseStar] then FindAtPosCat(tyc);
     if Fcatalog.cfgcat.starcaton[tyc2-BaseStar] then FindAtPosCat(tyc2);
     if Fcatalog.cfgcat.starcaton[tic-BaseStar] then FindAtPosCat(tic);
     if Fcatalog.cfgcat.starcaton[dstyc-BaseStar] then FindAtPosCat(dstyc);
     if Fcatalog.cfgcat.starcaton[gsc-BaseStar] then FindAtPosCat(gsc);
     if Fcatalog.cfgcat.starcaton[gscf-BaseStar] then FindAtPosCat(gscf);
     if Fcatalog.cfgcat.starcaton[gscc-BaseStar] then FindAtPosCat(gscc);
     if Fcatalog.cfgcat.starcaton[dsgsc-BaseStar] then FindAtPosCat(dsgsc);
     if Fcatalog.cfgcat.starcaton[usnoa-BaseStar] then FindAtPosCat(usnoa);
     if Fcatalog.cfgcat.starcaton[microcat-BaseStar] then FindAtPosCat(microcat);
  end;
  if i>maxln then desc:='More than '+inttostr(maxln)+' objects, result truncated.'
             else desc:='There is '+inttostr(i)+' objects in this field.';
  text:=text+desc+crlf;
finally
  Fcatalog.CloseCat;
  if showall then begin
    Fcatalog.cfgshr.NebFilter:=saveNebFilter;
    Fcatalog.cfgshr.StarFilter:=saveStarFilter;
  end;
end;
end;

Procedure Tskychart.DrawGrid;
begin
if ((deg2rad*Fcatalog.cfgshr.DegreeGridSpacing[cfgsc^.FieldNum])<=cfgsc^.fov) then begin
    if cfgsc^.ShowGrid then
       case cfgsc^.ProjPole of
       Equat  :  DrawEqGrid;
       AltAz  :  begin DrawAzGrid; if cfgsc^.ShowEqGrid then DrawEqGrid; end;
       Gal    :  begin DrawGalGrid; if cfgsc^.ShowEqGrid then DrawEqGrid; end;
       Ecl    :  begin DrawEclGrid; if cfgsc^.ShowEqGrid then DrawEqGrid; end;
       end
    else if cfgsc^.ShowEqGrid then DrawEqGrid;
end else if cfgsc^.ShowGrid then DrawScale;
end;

Procedure Tskychart.DrawScale;
var fv,u:double;
    i,n,s,x,y,xp:integer;
    l1,l2:string;
const sticksize=10;
begin
fv:=rad2deg*cfgsc^.fov/3;
if trunc(fv)>5 then begin l1:='1'+ldeg; n:=trunc(fv); l2:=inttostr(n)+ldeg; s:=1; u:=deg2rad; end
else if trunc(fv)>0 then begin l1:='30'+lmin; n:=trunc(fv)*2; l2:=inttostr(n*30)+lmin; s:=30; u:=deg2rad/60; end
else if trunc(6*fv/2)>0 then begin l1:='10'+lmin; n:=trunc(6*fv); l2:=inttostr(n*10)+lmin; s:=10; u:=deg2rad/60; end
else if trunc(30*fv/2)>0 then begin l1:='2'+lmin; n:=trunc(30*fv); l2:=inttostr(n*2)+lmin; s:=2; u:=deg2rad/60; end
else if trunc(60*fv/2)>0 then begin l1:='1'+lmin; n:=trunc(60*fv); l2:=inttostr(n)+lmin; s:=1; u:=deg2rad/60; end
else if trunc(360*fv/2)>0 then begin l1:='10'+lsec; n:=trunc(360*fv); l2:=inttostr(n*10)+lsec; s:=10; u:=deg2rad/3600; end
else if trunc(1800*fv/2)>0 then begin l1:='2'+lsec; n:=trunc(1800*fv); l2:=inttostr(n*2)+lsec; s:=2; u:=deg2rad/3600; end
else begin l1:='1'+lsec; n:=trunc(3600*fv); l2:=inttostr(n)+lsec; s:=1; u:=deg2rad/3600; end;
if n<1 then n:=1;
xp:=cfgsc^.xmin+sticksize;
y:=cfgsc^.ymax-sticksize;
FPlot.PlotLine(xp,y,xp,y-sticksize,Fplot.cfgplot^.Color[12],1);
FPlot.PlotText(xp,y-sticksize,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,'0');
for i:=1 to n do begin
  x:=xp+round(s*u*cfgsc^.bxglb);
  FPlot.PlotLine(xp,y,x,y,Fplot.cfgplot^.Color[12],1);
  FPlot.PlotLine(x,y,x,y-sticksize,Fplot.cfgplot^.Color[12],1);
  if i=1 then FPlot.PlotText(x,y-sticksize,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,l1);
  xp:=x;
end;
if n>1 then FPlot.PlotText(xp,y-sticksize,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,l2);
end;

Procedure Tskychart.LabelPos(xx,yy,w,h,marge: integer; var x,y: integer);
begin
x:=xx;
y:=yy;
if yy<cfgsc^.ymin then y:=cfgsc^.ymin+marge;
if (yy+h+marge)>cfgsc^.ymax then y:=cfgsc^.ymax-h-marge;
if xx<cfgsc^.xmin then x:=cfgsc^.xmin+marge;
if (xx+w+marge)>cfgsc^.xmax then x:=cfgsc^.xmax-w-marge;
end;

procedure Tskychart.DrawEqGrid;
var ra1,de1,ac,dc,dra,dde:double;
    col,n,lw,lh,lx,ly:integer;
    ok,labelok:boolean;
function DrawRAline(ra,de,dd:double):boolean;
var x1,y1:double;
    n: integer;
    xx,yy,xxp,yyp:single;
    plotok:boolean;
begin
projection(ra,de,x1,y1,false,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 de:=de+dd/3;
 projection(ra,de,x1,y1,cfgsc^.horizonopaque,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc^.x2 then
 if (xx>-cfgsc^.Xmax)and(xx<2*cfgsc^.Xmax)and(yy>-cfgsc^.Ymax)and(yy<2*cfgsc^.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,0,cfgsc^.StyleGrid);
    if (xx>0)and(xx<cfgsc^.Xmax)and(yy>0)and(yy<cfgsc^.Ymax) then plotok:=true;
 end;
 if (cfgsc^.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc^.Xmax)or(yy<0)or(yy>cfgsc^.Ymax)) then begin
    LabelPos(round(xx),round(yy)+lh,lw,lh,5,lx,ly);
    if dra<=15*minarc then Fplot.cnv.TextOut(lx,ly,artostr3(rmod(ra+pi2,pi2)*rad2deg/15))
                      else Fplot.cnv.TextOut(lx,ly,armtostr(rmod(ra+pi2,pi2)*rad2deg/15));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc^.Xmax)or(xx>2*cfgsc^.Xmax)or
      (yy<-cfgsc^.Ymax)or(yy>2*cfgsc^.Ymax)or
      (de>(pid2-2*dd/3))or(de<(-pid2-2*dd/3));
result:=(n>1);
end;
function DrawDEline(ra,de,da:double):boolean;
var x1,y1:double;
    n: integer;
    xx,yy,xxp,yyp:single;
    plotok:boolean;
begin
projection(ra,de,x1,y1,false,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 ra:=ra+da/3;
 projection(ra,de,x1,y1,cfgsc^.horizonopaque,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc^.x2 then
 if (xx>-cfgsc^.Xmax)and(xx<2*cfgsc^.Xmax)and(yy>-cfgsc^.Ymax)and(yy<2*cfgsc^.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,0,cfgsc^.StyleGrid);
    if (xx>0)and(xx<cfgsc^.Xmax)and(yy>0)and(yy<cfgsc^.Ymax) then plotok:=true;
 end;
 if (cfgsc^.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc^.Xmax)or(yy<0)or(yy>cfgsc^.Ymax)) then begin
    LabelPos(round(xx),round(yy),lw,lh,5,lx,ly);
    if dde<=5*minarc then Fplot.cnv.TextOut(lx,ly,detostr(de*rad2deg))
                     else Fplot.cnv.TextOut(lx,ly,demtostr(de*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc^.Xmax)or(xx>2*cfgsc^.Xmax)or
      (yy<-cfgsc^.Ymax)or(yy>2*cfgsc^.Ymax)or
      (ra>ra1+pi)or(ra<ra1-pi);
result:=(n>1);
end;
begin
if (cfgsc^.projpole=Equat)and(not cfgsc^.ShowEqGrid) then col:=Fplot.cfgplot^.Color[12]
                  else col:=Fplot.cfgplot^.Color[13];
Fplot.cnv.Brush.Color:=Fplot.cfgplot^.backgroundcolor;
Fplot.cnv.Brush.Style:=bsSolid;
// todo: replace by plottext()
Fplot.cnv.Font.Name:=Fplot.cfgplot^.FontName[1];
Fplot.cnv.Font.Color:=Fplot.cfgplot^.LabelColor[7];
Fplot.cnv.Font.Size:=Fplot.cfgplot^.FontSize[1]*Fplot.cfgchart^.fontscale;
if Fplot.cfgplot^.FontBold[1] then Fplot.cnv.Font.Style:=[fsBold] else Fplot.cnv.Font.Style:=[];
if Fplot.cfgplot^.FontItalic[1] then Fplot.cnv.font.style:=Fplot.cnv.font.style+[fsItalic];
lh:=Fplot.cnv.TextHeight('22h22m');
lw:=Fplot.cnv.TextWidth('22h22m');
n:=GetFieldNum(cfgsc^.fov/cos(cfgsc^.decentre));
dra:=Fcatalog.cfgshr.HourGridSpacing[n];
dde:=Fcatalog.cfgshr.DegreeGridSpacing[cfgsc^.FieldNum];
ra1:=deg2rad*trunc(rad2deg*cfgsc^.racentre/15/dra)*dra*15;
de1:=deg2rad*trunc(rad2deg*cfgsc^.decentre/dde)*dde;
dra:=deg2rad*dra*15;
dde:=deg2rad*dde;
ac:=ra1; dc:=de1;
repeat
  labelok:=false;
  if cfgsc^.decentre>0 then begin
    ok:=DrawRAline(ac,dc,-dde);
    ok:=DrawRAline(ac,dc,dde) or ok;
  end else begin
    ok:=DrawRAline(ac,dc,dde);
    ok:=DrawRAline(ac,dc,-dde) or ok;
  end;
  ac:=ac+dra;
until (not ok)or(ac>ra1+pi+musec);
ac:=ra1; dc:=de1;
repeat
  labelok:=false;
  if cfgsc^.decentre>0 then begin
    ok:=DrawRAline(ac,dc,-dde);
    ok:=DrawRAline(ac,dc,dde) or ok;
  end else begin
    ok:=DrawRAline(ac,dc,dde);
    ok:=DrawRAline(ac,dc,-dde) or ok;
  end;
  ac:=ac-dra;
until (not ok)or(ac<ra1-pi-musec);
ac:=ra1; dc:=de1;
repeat
  labelok:=false;
  ok:=DrawDEline(ac,dc,dra);
  ok:=DrawDEline(ac,dc,-dra) or ok;
  dc:=dc+dde;
until (not ok)or(dc>pid2);
ac:=ra1; dc:=de1;
repeat
  labelok:=false;
  ok:=DrawDEline(ac,dc,dra);
  ok:=DrawDEline(ac,dc,-dra) or ok;
  dc:=dc-dde;
until (not ok)or(dc<-pid2);
end;

procedure Tskychart.DrawAzGrid;
var a1,h1,ac,hc,dda,ddh:double;
    col,n,lw,lh,lx,ly:integer;
    ok,labelok:boolean;
function DrawAline(a,h,dd:double):boolean;
var x1,y1,al:double;
    n,w: integer;
    xx,yy,xxp,yyp:single;
    plotok:boolean;
begin
if (abs(a)<musec)or(abs(a-pi2)<musec)or(abs(a-pi)<musec) then w:=2 else w:=0;
proj2(-a,h,-cfgsc^.acentre,cfgsc^.hcentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 h:=h+dd/3;
 if cfgsc^.horizonopaque and (h<-musec) then break;
 proj2(-a,h,-cfgsc^.acentre,cfgsc^.hcentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc^.x2 then
 if (xx>-cfgsc^.Xmax)and(xx<2*cfgsc^.Xmax)and(yy>-cfgsc^.Ymax)and(yy<2*cfgsc^.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,w,cfgsc^.StyleGrid);
    if (xx>0)and(xx<cfgsc^.Xmax)and(yy>0)and(yy<cfgsc^.Ymax) then plotok:=true;
 end;
 if (cfgsc^.ShowGridNum)and(plotok)and(not labelok)and((abs(h)<minarc)or(xx<0)or(xx>cfgsc^.Xmax)or(yy<0)or(yy>cfgsc^.Ymax)) then begin
    LabelPos(round(xx),round(yy)+lh,lw,lh,5,lx,ly);
    if Fcatalog.cfgshr.AzNorth then al:=rmod(a+pi+pi2,pi2) else al:=rmod(a+pi2,pi2);
    if dda<=15*minarc then Fplot.cnv.TextOut(lx,ly,lontostr(al*rad2deg))
                      else Fplot.cnv.TextOut(lx,ly,lonmtostr(al*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc^.Xmax)or(xx>2*cfgsc^.Xmax)or
      (yy<-cfgsc^.Ymax)or(yy>2*cfgsc^.Ymax)or
      (h>(pid2-2*dd/3))or(h<(-pid2-2*dd/3));
result:=(n>1);
end;
function DrawHline(a,h,da:double):boolean;
var x1,y1:double;
    n,w: integer;
    xx,yy,xxp,yyp:single;
    plotok:boolean;
begin
if h=0 then w:=2 else w:=0;
proj2(-a,h,-cfgsc^.acentre,cfgsc^.hcentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 a:=a+da/3;
 proj2(-a,h,-cfgsc^.acentre,cfgsc^.hcentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc^.x2 then
 if (xx>-cfgsc^.Xmax)and(xx<2*cfgsc^.Xmax)and(yy>-cfgsc^.Ymax)and(yy<2*cfgsc^.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,w,cfgsc^.StyleGrid);
    if (xx>0)and(xx<cfgsc^.Xmax)and(yy>0)and(yy<cfgsc^.Ymax) then plotok:=true;
 end;
 if (cfgsc^.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc^.Xmax)or(yy<0)or(yy>cfgsc^.Ymax)) then begin
    LabelPos(round(xx),round(yy),lw,lh,5,lx,ly);
    if ddh<=5*minarc then Fplot.cnv.TextOut(lx,ly,detostr(h*rad2deg))
                     else Fplot.cnv.TextOut(lx,ly,demtostr(h*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc^.Xmax)or(xx>2*cfgsc^.Xmax)or
      (yy<-cfgsc^.Ymax)or(yy>2*cfgsc^.Ymax)or
      (a>a1+pi)or(a<a1-pi);
result:=(n>1);
end;
begin
col:=Fplot.cfgplot^.Color[12];
Fplot.cnv.Brush.Color:=Fplot.cfgplot^.backgroundcolor;
Fplot.cnv.Brush.Style:=bsSolid;
// todo: replace by plottext()
Fplot.cnv.Font.Name:=Fplot.cfgplot^.FontName[1];
Fplot.cnv.Font.Color:=Fplot.cfgplot^.LabelColor[7];
Fplot.cnv.Font.Size:=Fplot.cfgplot^.FontSize[1]*Fplot.cfgchart^.fontscale;
if Fplot.cfgplot^.FontBold[1] then Fplot.cnv.Font.Style:=[fsBold] else Fplot.cnv.Font.Style:=[];
if Fplot.cfgplot^.FontItalic[1] then Fplot.cnv.font.style:=Fplot.cnv.font.style+[fsItalic];
lh:=Fplot.cnv.TextHeight('222h22m');
lw:=Fplot.cnv.TextWidth('222h22m');
n:=GetFieldNum(cfgsc^.fov/cos(cfgsc^.hcentre));
dda:=Fcatalog.cfgshr.DegreeGridSpacing[n];
ddh:=Fcatalog.cfgshr.DegreeGridSpacing[cfgsc^.FieldNum];
a1:=deg2rad*round(rad2deg*cfgsc^.acentre/dda)*dda;
h1:=deg2rad*round(rad2deg*cfgsc^.hcentre/ddh)*ddh;
dda:=deg2rad*dda;
ddh:=deg2rad*ddh;
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  ok:=DrawAline(ac,hc,-ddh);
  ok:=DrawAline(ac,hc,ddh) or ok;
  ac:=ac+dda;
until (not ok)or(ac>a1+pi);
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  ok:=DrawAline(ac,hc,-ddh);
  ok:=DrawAline(ac,hc,ddh) or ok;
  ac:=ac-dda;
until (not ok)or(ac<a1-pi);
ac:=a1; hc:=h1;
repeat
  if cfgsc^.horizonopaque and (hc<-musec) then break;
  labelok:=false;
  ok:=DrawHline(ac,hc,dda);
  ok:=DrawHline(ac,hc,-dda) or ok;
  hc:=hc+ddh;
until (not ok)or(hc>pid2);
ac:=a1; hc:=h1;
repeat
  if cfgsc^.horizonopaque and (hc<-musec) then break;
  labelok:=false;
  ok:=DrawHline(ac,hc,dda);
  ok:=DrawHline(ac,hc,-dda) or ok;
  hc:=hc-ddh;
until (not ok)or(hc<-pid2);
end;

function Tskychart.DrawHorizon:boolean;
var az,h,x1,y1 : double;
    i,xx,yy: integer;
    x,y,xh,yh,xp,yp,x0,y0,xph,yph,x0h,y0h :single;
    first:boolean;
begin
if cfgsc^.ProjPole=Altaz then begin
  if cfgsc^.hcentre<-(cfgsc^.fov/6) then
     Fplot.PlotText((cfgsc^.xmax-cfgsc^.xmin)div 2,(cfgsc^.ymax-cfgsc^.ymin)div 2,2,Fplot.cfgplot^.Color[12],laCenter,laCenter,' Below the horizon ');
  if cfgsc^.ShowHorizon and (cfgsc^.HorizonMax>0)and(cfgsc^.horizonlist<>nil) then begin
     first:=true; xp:=0;yp:=0;x0:=0;y0:=0; xph:=0;yph:=0;x0h:=0;y0h:=0;
     for i:=1 to 360 do begin
       h:=cfgsc^.horizonlist^[i];
       az:=deg2rad*rmod(360+i-1-180,360);
       proj2(-az,h,-cfgsc^.acentre,cfgsc^.hcentre,x1,y1,cfgsc) ;
       WindowXY(x1,y1,x,y,cfgsc);
       proj2(-az,0,-cfgsc^.acentre,cfgsc^.hcentre,x1,y1,cfgsc) ;
       WindowXY(x1,y1,xh,yh,cfgsc);
       if first then begin
          first:=false;
          x0:=x; x0h:=xh;
          y0:=y; y0h:=yh;
       end else begin
          Fplot.PlotOutline(xp,yp,0,1,2,1,cfgsc^.x2,Fplot.cfgplot^.Color[19]);
          Fplot.PlotOutline(x,y,2,1,2,1,cfgsc^.x2,Fplot.cfgplot^.Color[19]);
          Fplot.PlotOutline(xh,yh,2,1,2,1,cfgsc^.x2,Fplot.cfgplot^.Color[19]);
          Fplot.PlotOutline(xph,yph,1,1,2,1,cfgsc^.x2,Fplot.cfgplot^.Color[19]);
          Fplot.Plotline(xph,yph,xh,yh,Fplot.cfgplot^.Color[12],2);
       end;
       xp:=x; xph:=xh;
       yp:=y; yph:=yh;
     end;
     Fplot.PlotOutline(x,y,0,1,2,1,cfgsc^.x2,Fplot.cfgplot^.Color[19]);
     Fplot.PlotOutline(x0,y0,2,1,2,1,cfgsc^.x2,Fplot.cfgplot^.Color[19]);
     Fplot.PlotOutline(x0h,y0h,2,1,2,1,cfgsc^.x2,Fplot.cfgplot^.Color[19]);
     Fplot.PlotOutline(xh,yh,1,1,2,1,cfgsc^.x2,Fplot.cfgplot^.Color[19]);
     Fplot.Plotline(xh,yh,x0h,y0h,Fplot.cfgplot^.Color[12],2);
  end;
  if cfgsc^.ShowHorizonDepression then begin
     first:=true; xp:=0;yp:=0;
     h:=cfgsc^.ObsHorizonDepression;
     if h<0 then for i:=1 to 360 do begin
       az:=deg2rad*rmod(360+i-1-180,360);
       proj2(-az,h,-cfgsc^.acentre,cfgsc^.hcentre,x1,y1,cfgsc) ;
       WindowXY(x1,y1,x,y,cfgsc);
       if first then begin
          first:=false;
       end else begin
          Fplot.Plotline(xp,yp,x,y,Fplot.cfgplot^.Color[15],2);
       end;
       xp:=x;
       yp:=y;
     end;
  end;
  if (cfgsc^.ShowLabel[7]) then begin
    az:=0; h:=0;
    for i:=1 to 8 do begin
       proj2(-deg2rad*az,h,-cfgsc^.acentre,cfgsc^.hcentre,x1,y1,cfgsc) ;
       WindowXY(x1,y1,x,y,cfgsc);
       xx:=round(x); yy:=round(y);
       case round(az) of
         0  : FPlot.PlotText(xx,yy,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,'S');
         45 : FPlot.PlotText(xx,yy,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,'SW');
         90 : FPlot.PlotText(xx,yy,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,'W');
         135: FPlot.PlotText(xx,yy,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,'NW');
         180: FPlot.PlotText(xx,yy,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,'N');
         225: FPlot.PlotText(xx,yy,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,'NE');
         270: FPlot.PlotText(xx,yy,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,'E');
         315: FPlot.PlotText(xx,yy,1,Fplot.cfgplot^.LabelColor[7],laCenter,laBottom,'SE');
       end;
       az:=az+45;
    end;
  end;
end;
result:=true;
end;

procedure Tskychart.DrawGalGrid;
var a1,h1,ac,hc,dda,ddh:double;
    col,n,lw,lh,lx,ly:integer;
    ok,labelok:boolean;
function DrawAline(a,h,dd:double):boolean;
var x1,y1:double;
    n: integer;
    xx,yy,xxp,yyp:single;
    plotok:boolean;
begin
proj2(a,h,cfgsc^.lcentre,cfgsc^.bcentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 h:=h+dd/3;
 proj2(a,h,cfgsc^.lcentre,cfgsc^.bcentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc^.x2 then
 if (xx>-cfgsc^.Xmax)and(xx<2*cfgsc^.Xmax)and(yy>-cfgsc^.Ymax)and(yy<2*cfgsc^.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,0,cfgsc^.StyleGrid);
    if (xx>0)and(xx<cfgsc^.Xmax)and(yy>0)and(yy<cfgsc^.Ymax) then plotok:=true;
 end;
 if (cfgsc^.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc^.Xmax)or(yy<0)or(yy>cfgsc^.Ymax)) then begin
    LabelPos(round(xx),round(yy)+lh,lw,lh,5,lx,ly);
    if dda<=15*minarc then Fplot.cnv.TextOut(lx,ly,lontostr(rmod(a+pi2,pi2)*rad2deg))
                      else Fplot.cnv.TextOut(lx,ly,lonmtostr(rmod(a+pi2,pi2)*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc^.Xmax)or(xx>2*cfgsc^.Xmax)or
      (yy<-cfgsc^.Ymax)or(yy>2*cfgsc^.Ymax)or
      (h>(pid2-2*dd/3))or(h<(-pid2-2*dd/3));
result:=(n>1);
end;
function DrawHline(a,h,da:double):boolean;
var x1,y1:double;
    n,w: integer;
    xx,yy,xxp,yyp:single;
    plotok:boolean;
begin
w:=0;
proj2(a,h,cfgsc^.lcentre,cfgsc^.bcentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 a:=a+da/3;
 proj2(a,h,cfgsc^.lcentre,cfgsc^.bcentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc^.x2 then
 if (xx>-cfgsc^.Xmax)and(xx<2*cfgsc^.Xmax)and(yy>-cfgsc^.Ymax)and(yy<2*cfgsc^.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,w,cfgsc^.StyleGrid);
    if (xx>0)and(xx<cfgsc^.Xmax)and(yy>0)and(yy<cfgsc^.Ymax) then plotok:=true;
 end;
 if (cfgsc^.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc^.Xmax)or(yy<0)or(yy>cfgsc^.Ymax)) then begin
    LabelPos(round(xx),round(yy),lw,lh,5,lx,ly);
    if ddh<=5*minarc then Fplot.cnv.TextOut(lx,ly,detostr(h*rad2deg))
                     else Fplot.cnv.TextOut(lx,ly,demtostr(h*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc^.Xmax)or(xx>2*cfgsc^.Xmax)or
      (yy<-cfgsc^.Ymax)or(yy>2*cfgsc^.Ymax)or
      (a>a1+pi)or(a<a1-pi);
result:=(n>1);
end;
begin
col:=Fplot.cfgplot^.Color[12];
Fplot.cnv.Brush.Color:=Fplot.cfgplot^.backgroundcolor;
Fplot.cnv.Brush.Style:=bsSolid;
// todo: replace by plottext()
Fplot.cnv.Font.Name:=Fplot.cfgplot^.FontName[1];
Fplot.cnv.Font.Color:=Fplot.cfgplot^.LabelColor[7];
Fplot.cnv.Font.Size:=Fplot.cfgplot^.FontSize[1]*Fplot.cfgchart^.fontscale;
if Fplot.cfgplot^.FontBold[1] then Fplot.cnv.Font.Style:=[fsBold] else Fplot.cnv.Font.Style:=[];
if Fplot.cfgplot^.FontItalic[1] then Fplot.cnv.font.style:=Fplot.cnv.font.style+[fsItalic];
lh:=Fplot.cnv.TextHeight('222h22m');
lw:=Fplot.cnv.TextWidth('222h22m');
n:=GetFieldNum(cfgsc^.fov/cos(cfgsc^.bcentre));
dda:=Fcatalog.cfgshr.DegreeGridSpacing[n];
ddh:=Fcatalog.cfgshr.DegreeGridSpacing[cfgsc^.FieldNum];
a1:=deg2rad*trunc(rad2deg*cfgsc^.lcentre/dda)*dda;
h1:=deg2rad*trunc(rad2deg*cfgsc^.bcentre/ddh)*ddh;
dda:=deg2rad*dda;
ddh:=deg2rad*ddh;
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  if cfgsc^.bcentre>0 then begin
    ok:=DrawAline(ac,hc,-ddh);
    ok:=DrawAline(ac,hc,ddh) or ok;
  end else begin
    ok:=DrawAline(ac,hc,ddh);
    ok:=DrawAline(ac,hc,-ddh) or ok;
  end;
  ac:=ac+dda;
until (not ok)or(ac>a1+pi);
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  if cfgsc^.bcentre>0 then begin
    ok:=DrawAline(ac,hc,-ddh);
    ok:=DrawAline(ac,hc,ddh) or ok;
  end else begin
    ok:=DrawAline(ac,hc,ddh);
    ok:=DrawAline(ac,hc,-ddh) or ok;
  end;
  ac:=ac-dda;
until (not ok)or(ac<a1-pi);
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  ok:=DrawHline(ac,hc,-dda);
  ok:=DrawHline(ac,hc,dda) or ok;
  hc:=hc+ddh;
until (not ok)or(hc>pid2);
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  ok:=DrawHline(ac,hc,-dda);
  ok:=DrawHline(ac,hc,dda) or ok;
  hc:=hc-ddh;
until (not ok)or(hc<-pid2);
end;

procedure Tskychart.DrawEclGrid;
var a1,h1,ac,hc,dda,ddh:double;
    col,n,lw,lh,lx,ly:integer;
    ok,labelok:boolean;
function DrawAline(a,h,dd:double):boolean;
var x1,y1:double;
    n: integer;
    xx,yy,xxp,yyp:single;
    plotok:boolean;
begin
proj2(a,h,cfgsc^.lecentre,cfgsc^.becentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 h:=h+dd/3;
 proj2(a,h,cfgsc^.lecentre,cfgsc^.becentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc^.x2 then
 if (xx>-cfgsc^.Xmax)and(xx<2*cfgsc^.Xmax)and(yy>-cfgsc^.Ymax)and(yy<2*cfgsc^.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,0,cfgsc^.StyleGrid);
    if (xx>0)and(xx<cfgsc^.Xmax)and(yy>0)and(yy<cfgsc^.Ymax) then plotok:=true;
 end;
 if (cfgsc^.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc^.Xmax)or(yy<0)or(yy>cfgsc^.Ymax)) then begin
    LabelPos(round(xx),round(yy)+lh,lw,lh,5,lx,ly);
    if dda<=15*minarc then Fplot.cnv.TextOut(lx,ly,lontostr(rmod(a+pi2,pi2)*rad2deg))
                      else Fplot.cnv.TextOut(lx,ly,lonmtostr(rmod(a+pi2,pi2)*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc^.Xmax)or(xx>2*cfgsc^.Xmax)or
      (yy<-cfgsc^.Ymax)or(yy>2*cfgsc^.Ymax)or
      (h>(pid2-2*dd/3))or(h<(-pid2-2*dd/3));
result:=(n>1);
end;
function DrawHline(a,h,da:double):boolean;
var x1,y1:double;
    n,w: integer;
    xx,yy,xxp,yyp:single;
    plotok:boolean;
begin
w:=0;
proj2(a,h,cfgsc^.lecentre,cfgsc^.becentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 a:=a+da/3;
 proj2(a,h,cfgsc^.lecentre,cfgsc^.becentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc^.x2 then
 if (xx>-cfgsc^.Xmax)and(xx<2*cfgsc^.Xmax)and(yy>-cfgsc^.Ymax)and(yy<2*cfgsc^.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,w,cfgsc^.StyleGrid);
    if (xx>0)and(xx<cfgsc^.Xmax)and(yy>0)and(yy<cfgsc^.Ymax) then plotok:=true;
 end;
 if (cfgsc^.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc^.Xmax)or(yy<0)or(yy>cfgsc^.Ymax)) then begin
    LabelPos(round(xx),round(yy),lw,lh,5,lx,ly);
    if ddh<=5*minarc then Fplot.cnv.TextOut(lx,ly,detostr(h*rad2deg))
                     else Fplot.cnv.TextOut(lx,ly,demtostr(h*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc^.Xmax)or(xx>2*cfgsc^.Xmax)or
      (yy<-cfgsc^.Ymax)or(yy>2*cfgsc^.Ymax)or
      (a>a1+pi)or(a<a1-pi);
result:=(n>1);
end;
begin
col:=Fplot.cfgplot^.Color[12];
Fplot.cnv.Brush.Color:=Fplot.cfgplot^.backgroundcolor;
Fplot.cnv.Brush.Style:=bsSolid;
// todo: replace by plottext()
Fplot.cnv.Font.Name:=Fplot.cfgplot^.FontName[1];
Fplot.cnv.Font.Color:=Fplot.cfgplot^.LabelColor[7];
Fplot.cnv.Font.Size:=Fplot.cfgplot^.FontSize[1]*Fplot.cfgchart^.fontscale;
if Fplot.cfgplot^.FontBold[1] then Fplot.cnv.Font.Style:=[fsBold] else Fplot.cnv.Font.Style:=[];
if Fplot.cfgplot^.FontItalic[1] then Fplot.cnv.font.style:=Fplot.cnv.font.style+[fsItalic];
lh:=Fplot.cnv.TextHeight('222h22m');
lw:=Fplot.cnv.TextWidth('222h22m');
n:=GetFieldNum(cfgsc^.fov/cos(cfgsc^.becentre));
dda:=Fcatalog.cfgshr.DegreeGridSpacing[n];
ddh:=Fcatalog.cfgshr.DegreeGridSpacing[cfgsc^.FieldNum];
a1:=deg2rad*trunc(rad2deg*cfgsc^.lecentre/dda)*dda;
h1:=deg2rad*trunc(rad2deg*cfgsc^.becentre/ddh)*ddh;
dda:=deg2rad*dda;
ddh:=deg2rad*ddh;
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  if cfgsc^.becentre>0 then begin
    ok:=DrawAline(ac,hc,-ddh);
    ok:=DrawAline(ac,hc,ddh) or ok;
  end else begin
    ok:=DrawAline(ac,hc,ddh);
    ok:=DrawAline(ac,hc,-ddh) or ok;
  end;
  ac:=ac+dda;
until (not ok)or(ac>a1+pi);
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  if cfgsc^.becentre>0 then begin
    ok:=DrawAline(ac,hc,-ddh);
    ok:=DrawAline(ac,hc,ddh) or ok;
  end else begin
    ok:=DrawAline(ac,hc,ddh);
    ok:=DrawAline(ac,hc,-ddh) or ok;
  end;
  ac:=ac-dda;
until (not ok)or(ac<a1-pi);
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  ok:=DrawHline(ac,hc,-dda);
  ok:=DrawHline(ac,hc,dda) or ok;
  hc:=hc+ddh;
until (not ok)or(hc>pid2);
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  ok:=DrawHline(ac,hc,-dda);
  ok:=DrawHline(ac,hc,dda) or ok;
  hc:=hc-ddh;
until (not ok)or(hc<-pid2);
end;

Procedure Tskychart.GetLabPos(ra,dec,r:double; w,h: integer; var x,y: integer);
var x1,y1:double;
    xxx,yyy:single;
    rr,xx,yy:integer;
begin
 // no precession, the label position is already for the rigth equinox
 projection(ra,dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xxx,yyy,cfgsc);
 rr:=round(r*cfgsc^.BxGlb);
 xx:=round(xxx);
 yy:=round(yyy);
 x:=xx;
 y:=yy;
 if (xx>cfgsc^.Xmin) and (xx<cfgsc^.Xmax) and (yy>cfgsc^.Ymin) and (yy<cfgsc^.Ymax) then begin
    case cfgsc^.LabelOrientation of
    0 : begin                    // to the left
         x:=xx-rr-labspacing-w;
         y:=y-(h div 2);
        end;
    1 : begin                    // to the right
         x:=xx+rr+labspacing;
         y:=y-(h div 2);
        end;
    end;
 end;
end;

function Tskychart.DrawConstL:boolean;
var
  xx1,yy1,xx2,yy2,ra1,de1,ra2,de2 : Double;
  i,color : Integer;
  x1,y1,x2,y2:single;
begin
result:=false;
if not cfgsc^.ShowConstl then exit;
color := Fplot.cfgplot^.Color[16];
for i:=0 to Fcatalog.cfgshr.ConstLnum-1 do begin
  ra1:=Fcatalog.cfgshr.ConstL[i].ra1;
  de1:=Fcatalog.cfgshr.ConstL[i].de1;
  ra2:=Fcatalog.cfgshr.ConstL[i].ra2;
  de2:=Fcatalog.cfgshr.ConstL[i].de2;
  precession(jd2000,cfgsc^.JDChart,ra1,de1);
  if cfgsc^.ApparentPos then apparent_equatorial(ra1,de1,cfgsc);
  projection(ra1,de1,xx1,yy1,true,cfgsc) ;
  precession(jd2000,cfgsc^.JDChart,ra2,de2);
  if cfgsc^.ApparentPos then apparent_equatorial(ra2,de2,cfgsc);
  projection(ra2,de2,xx2,yy2,true,cfgsc) ;
  if (xx1<199)and(xx2<199) then begin
     WindowXY(xx1,yy1,x1,y1,cfgsc);
     WindowXY(xx2,yy2,x2,y2,cfgsc);
     if (intpower(x2-x1,2)+intpower(y2-y1,2))<cfgsc^.x2 then
        FPlot.PlotLine(x1,y1,x2,y2,color,1,cfgsc^.StyleConstL);
  end;
end;
result:=true;
end;

function Tskychart.DrawConstB:boolean;
var
  dm,xx,yy,ra,de : Double;
  i,color : Integer;
  x1,y1,x2,y2:single;
begin
result:=false;
if not cfgsc^.ShowConstB then exit;
dm:=max(cfgsc^.fov,0.1);
color := Fplot.cfgplot^.Color[17];
x1:=0; y1:=0;
for i:=0 to Fcatalog.cfgshr.ConstBnum-1 do begin
  ra:=Fcatalog.cfgshr.ConstB[i].ra;
  de:=Fcatalog.cfgshr.ConstB[i].de;
  if Fcatalog.cfgshr.ConstB[i].newconst then x1:=maxint;
  precession(jd2000,cfgsc^.JDChart,ra,de);
  if cfgsc^.ApparentPos then apparent_equatorial(ra,de,cfgsc);
  projection(ra,de,xx,yy,true,cfgsc) ;
  if (xx<199) then begin
    WindowXY(xx,yy,x2,y2,cfgsc);
    if (x1<maxint)and(abs(xx)<dm)and(abs(yy)<dm) and
       ((intpower(x2-x1,2)+intpower(y2-y1,2))<cfgsc^.x2) then
           FPlot.PlotLine(x1,y1,x2,y2,color,1,cfgsc^.StyleConstB);
    x1:=x2;
    y1:=y2;
  end else x1:=maxint;
end;
result:=true;
end;

function Tskychart.DrawEcliptic:boolean;
var l,b,e,ar,de,xx,yy : double;
    i,color : integer;
    x1,y1,x2,y2:single;
    first : boolean;
begin
result:=false;
if not cfgsc^.ShowEcliptic then exit;
e:=ecliptic(cfgsc^.JDChart);
b:=0;
first:=true;
color := Fplot.cfgplot^.Color[14];
x1:=0; y1:=0;
for i:=0 to 360 do begin
  l:=deg2rad*i;
  ecl2eq(l,b,e,ar,de);
  if cfgsc^.ApparentPos then apparent_equatorial(ar,de,cfgsc);
  projection(ar,de,xx,yy,true,cfgsc) ;
  WindowXY(xx,yy,x2,y2,cfgsc);
  if first then
     first:=false
  else
     FPlot.PlotLine(x1,y1,x2,y2,color,1);
  x1:=x2;
  y1:=y2;
end;
result:=true;
end;

function Tskychart.DrawGalactic:boolean;
var l,b,ar,de,xx,yy : double;
    i,color : integer;
    x1,y1,x2,y2:single;
    first : boolean;
begin
result:=false;
if not cfgsc^.ShowGalactic then exit;
b:=0;
first:=true;
color := Fplot.cfgplot^.Color[15];
x1:=0; y1:=0;
for i:=0 to 360 do begin
  l:=deg2rad*i;
  gal2eq(l,b,ar,de,cfgsc);
  if cfgsc^.ApparentPos then apparent_equatorial(ar,de,cfgsc);
  projection(ar,de,xx,yy,true,cfgsc) ;
  WindowXY(xx,yy,x2,y2,cfgsc);
  if first then begin
     first:=false;
  end else
     FPlot.PlotLine(x1,y1,x2,y2,color,1);
  x1:=x2;
  y1:=y2;
end;
result:=true;
end;

Procedure Tskychart.InitLabels;
var i,lid : integer;
    xx,yy:single;
    ra,de,x1,y1:double;
begin
  numlabels:=0;
  for i:=0 to Fcatalog.cfgshr.ConstelNum-1 do begin
      ra:=Fcatalog.cfgshr.ConstelPos[i].ra;
      de:=Fcatalog.cfgshr.ConstelPos[i].de;
      precession(jd2000,cfgsc^.JDChart,ra,de);
      projection(ra,de,x1,y1,true,cfgsc) ;
      WindowXY(x1,y1,xx,yy,cfgsc);
      lid:=GetId(Fcatalog.cfgshr.ConstelName[i,2]);
      if cfgsc^.ConstFullLabel then SetLabel(lid,xx,yy,0,2,6,Fcatalog.cfgshr.ConstelName[i,2])
                              else SetLabel(lid,xx,yy,0,2,6,Fcatalog.cfgshr.ConstelName[i,1]);
  end;
end;

procedure Tskychart.SetLabel(id:integer;xx,yy:single;radius,fontnum,labelnum:integer; txt:string);
begin
if (cfgsc^.ShowLabel[labelnum])and(numlabels<maxlabels)and(trim(txt)<>'')and(xx>=cfgsc^.xmin)and(xx<=cfgsc^.xmax)and(yy>=cfgsc^.ymin)and(yy<=cfgsc^.ymax) then begin
  inc(numlabels);
  try
  labels[numlabels].id:=id;
  labels[numlabels].x:=round(xx);
  labels[numlabels].y:=round(yy);
  labels[numlabels].r:=radius;
  labels[numlabels].labelnum:=labelnum;
  labels[numlabels].fontnum:=fontnum;
  labels[numlabels].txt:=wordspace(txt);
  except
   dec(numlabels);
  end;
end;
end;

procedure Tskychart.EditLabelPos(lnum,x,y: integer);
var
    i,j,id: integer;
    labelnum,fontnum:byte;
    txt: string;
begin
i:=-1;
txt:=labels[lnum].txt;
labelnum:=labels[lnum].labelnum;
fontnum:=labels[lnum].fontnum;
id:=labels[lnum].id;
for j:=1 to cfgsc^.nummodlabels do
    if id=cfgsc^.modlabels[j].id then begin
       i:=j;
       txt:=cfgsc^.modlabels[j].txt;
       labelnum:=cfgsc^.modlabels[j].labelnum;
       fontnum:=cfgsc^.modlabels[j].fontnum;
       break;
     end;
if i<0 then begin
  inc(cfgsc^.nummodlabels);
  if cfgsc^.nummodlabels>maxmodlabels then cfgsc^.nummodlabels:=1;
  i:=cfgsc^.nummodlabels;
end;
cfgsc^.modlabels[i].dx:=x-labels[lnum].x;
cfgsc^.modlabels[i].dy:=y-labels[lnum].y;
cfgsc^.modlabels[i].txt:=txt;
cfgsc^.modlabels[i].labelnum:=labelnum;
cfgsc^.modlabels[i].fontnum:=fontnum;
cfgsc^.modlabels[i].id:=id;
cfgsc^.modlabels[i].hiden:=false;
end;

procedure Tskychart.EditLabelTxt(lnum,x,y: integer);
var i,j,id: integer;
    labelnum,fontnum:byte;
    txt: string;
    f1:Tform;
    e1:Tedit;
    b1,b2:Tbutton;
begin
i:=-1;
txt:=labels[lnum].txt;
labelnum:=labels[lnum].labelnum;
fontnum:=labels[lnum].fontnum;
id:=labels[lnum].id;
for j:=1 to cfgsc^.nummodlabels do
    if id=cfgsc^.modlabels[j].id then begin
       i:=j;
       txt:=cfgsc^.modlabels[j].txt;
       labelnum:=cfgsc^.modlabels[j].labelnum;
       fontnum:=cfgsc^.modlabels[j].fontnum;
       break;
     end;
f1:=Tform.Create(self);
e1:=Tedit.Create(f1);
b1:=Tbutton.Create(f1);
b2:=Tbutton.Create(f1);
try
e1.Parent:=f1;
b1.Parent:=f1;
b2.Parent:=f1;
e1.Font.Name:=fplot.cfgplot^.FontName[fontnum];
e1.Top:=8;
e1.Left:=8;
e1.Width:=150;
b1.Width:=65;
b2.Width:=65;
b1.Top:=e1.Top+e1.Height+8;
b2.Top:=b1.Top;
b1.Left:=8;
b2.Left:=b1.Left+b2.Width+8;
b1.Caption:='Ok';
b2.Caption:='Cancel';
b1.ModalResult:=mrOk;
b2.ModalResult:=mrCancel;
f1.ClientWidth:=e1.Width+16;
f1.ClientHeight:=b1.top+b1.Height+8;
e1.Text:=txt;
f1.BorderStyle:=bsDialog;
f1.Caption:='Edit Label';
formpos(f1,x,y);
if f1.ShowModal=mrOK then begin
   txt:=e1.Text;
   if i<0 then begin
     inc(cfgsc^.nummodlabels);
     if cfgsc^.nummodlabels>maxmodlabels then cfgsc^.nummodlabels:=1;
     i:=cfgsc^.nummodlabels;
     cfgsc^.modlabels[i].dx:=0;
     cfgsc^.modlabels[i].dy:=0;
   end;
   cfgsc^.modlabels[i].txt:=txt;
   cfgsc^.modlabels[i].labelnum:=labelnum;
   cfgsc^.modlabels[i].fontnum:=fontnum;
   cfgsc^.modlabels[i].id:=id;
   cfgsc^.modlabels[i].hiden:=false;
   DrawLabels;
end;
finally
e1.Free;
b1.Free;
b2.Free;
f1.Free;
end;
end;

procedure Tskychart.DeleteLabel(lnum: integer);
var i,j,id: integer;
    labelnum,fontnum:byte;
    txt: string;
begin
i:=-1;
txt:=labels[lnum].txt;
labelnum:=labels[lnum].labelnum;
fontnum:=labels[lnum].fontnum;
id:=labels[lnum].id;
for j:=1 to cfgsc^.nummodlabels do
    if id=cfgsc^.modlabels[j].id then begin
       i:=j;
       txt:=cfgsc^.modlabels[j].txt;
       labelnum:=cfgsc^.modlabels[j].labelnum;
       fontnum:=cfgsc^.modlabels[j].fontnum;
       break;
     end;
if i<0 then begin
  inc(cfgsc^.nummodlabels);
  if cfgsc^.nummodlabels>maxmodlabels then cfgsc^.nummodlabels:=1;
  i:=cfgsc^.nummodlabels;
end;
cfgsc^.modlabels[i].dx:=0;
cfgsc^.modlabels[i].dy:=0;
cfgsc^.modlabels[i].txt:=txt;
cfgsc^.modlabels[i].labelnum:=labelnum;
cfgsc^.modlabels[i].fontnum:=fontnum;
cfgsc^.modlabels[i].id:=id;
cfgsc^.modlabels[i].hiden:=true;
DrawLabels;
end;

procedure Tskychart.DeleteAllLabel;
begin
cfgsc^.nummodlabels:=0;
DrawLabels;
end;

procedure Tskychart.DefaultLabel(lnum: integer);
var i,j,id: integer;
begin
i:=-1;
id:=labels[lnum].id;
for j:=1 to cfgsc^.nummodlabels do
    if id=cfgsc^.modlabels[j].id then begin
       i:=j;
       break;
     end;
if i<0 then exit;
for j:=i+1 to cfgsc^.nummodlabels do cfgsc^.modlabels[j-1]:=cfgsc^.modlabels[j];
dec(cfgsc^.nummodlabels);
DrawLabels;
end;

procedure Tskychart.LabelClick(lnum: integer);
var x,y: integer;
begin
x:=labels[lnum].x;
y:=labels[lnum].y;
if assigned(FShowDetailXY) then FShowDetailXY(x,y);
end;

function Tskychart.DrawLabels:boolean;
var i,j,x,y,r: integer;
    labelnum,fontnum:byte;
    txt:string;
    skiplabel:boolean;
begin
Fplot.InitLabel;
for i:=1 to numlabels do begin
  skiplabel:=false;
  x:=labels[i].x;
  y:=labels[i].y;
  r:=labels[i].r;
  txt:=labels[i].txt;
  labelnum:=labels[i].labelnum;
  fontnum:=labels[i].fontnum;
  for j:=1 to cfgsc^.nummodlabels do
     if labels[i].id=cfgsc^.modlabels[j].id then begin
        skiplabel:=cfgsc^.modlabels[j].hiden;
        txt:=cfgsc^.modlabels[j].txt;
        labelnum:=cfgsc^.modlabels[j].labelnum;
        fontnum:=cfgsc^.modlabels[j].fontnum;
        x:=x+cfgsc^.modlabels[j].dx*Fplot.cfgchart^.drawpen;
        y:=y+cfgsc^.modlabels[j].dy*Fplot.cfgchart^.drawpen;
        if (cfgsc^.modlabels[j].dx<>0)or(cfgsc^.modlabels[j].dy<>0) then r:=-1;
        break;
     end;
  if not skiplabel then Fplot.PlotLabel(i,x,y,r,labelnum,fontnum,laLeft,laCenter,cfgsc^.WhiteBg,(not cfgsc^.Editlabels),txt);
end;
if cfgsc^.showlabel[8] then plot.PlotTextCR(cfgsc^.xshift+5,cfgsc^.yshift+5,2,8,GetChartInfo(crlf));
result:=true;
end;

Procedure Tskychart.DrawFinderMark(ra,de :double; moving:boolean) ;
var x1,y1,x2,y2,r : double;
    i : integer;
    xa,ya,xb,yb:single;
    pa,xx1,xx2,yy1,yy2,rot,o : single;
    spa,cpa:extended;
    p : array [0..4] of Tpoint;
begin
projection(ra,de,x1,y1,false,cfgsc) ;
WindowXY(x1,y1,xa,ya,cfgsc);
projection(ra,de+0.001,x2,y2,false,cfgsc) ;
rot:=RotationAngle(x1,y1,x2,y2,cfgsc);
for i:=1 to 10 do if cfgsc^.circleok[i] then begin
    pa:=deg2rad*cfgsc^.circle[i,2]*cfgsc^.FlipX;
    if cfgsc^.FlipY<0 then pa:=pi-pa;
    sincos(pa+rot,spa,cpa);
    o:=abs(cfgsc^.circle[i,3]*deg2rad/60);
    x2:=x1-cfgsc^.flipx*o*spa;
    y2:=y1+cfgsc^.flipy*o*cpa;
    r:=deg2rad*cfgsc^.circle[i,1]/120;
    WindowXY(x2-r,y2-r,xa,ya,cfgsc);
    WindowXY(x2+r,y2+r,xb,yb,cfgsc);
    Fplot.PlotCircle(xa,ya,xb,yb,Fplot.cfgplot^.Color[18],moving);
end;
for i:=1 to 10 do if cfgsc^.rectangleok[i] and (deg2rad*cfgsc^.rectangle[i,2]/60<2*cfgsc^.fov) then begin
    pa:=deg2rad*cfgsc^.rectangle[i,3]*cfgsc^.FlipX;
    if cfgsc^.FlipY<0 then pa:=pi-pa;
    sincos(pa+rot,spa,cpa);
    o:=abs(cfgsc^.rectangle[i,4]*deg2rad/60);
    x2:=x1-cfgsc^.flipx*o*spa;
    y2:=y1+cfgsc^.flipy*o*cpa;
    xx1:=deg2rad*cfgsc^.flipx*(cfgsc^.rectangle[i,1]/120*cpa - cfgsc^.rectangle[i,2]/120*spa);
    yy1:=deg2rad*cfgsc^.flipy*(cfgsc^.rectangle[i,1]/120*spa + cfgsc^.rectangle[i,2]/120*cpa);
    xx2:=deg2rad*cfgsc^.flipx*(cfgsc^.rectangle[i,1]/120*cpa + cfgsc^.rectangle[i,2]/120*spa);
    yy2:=deg2rad*cfgsc^.flipy*(-cfgsc^.rectangle[i,1]/120*spa + cfgsc^.rectangle[i,2]/120*cpa);
    WindowXY(x2-xx1,y2-yy1,xa,ya,cfgsc);
    p[0]:=Point(round(xa),round(ya));
    WindowXY(x2+xx2,y2-yy2,xa,ya,cfgsc);
    p[1]:=Point(round(xa),round(ya));
    WindowXY(x2+xx1,y2+yy1,xa,ya,cfgsc);
    p[2]:=Point(round(xa),round(ya));
    WindowXY(x2-xx2,y2+yy2,xa,ya,cfgsc);
    p[3]:=Point(round(xa),round(ya));
    p[4]:=p[0];
    Fplot.PlotPolyline(p,Fplot.cfgplot^.Color[18],moving);
  end;
end;

Procedure Tskychart.DrawCircle;
var i : integer;
begin
//center mark
if cfgsc^.ShowCircle then begin
 DrawFinderMark(cfgsc^.racentre,cfgsc^.decentre,false);
end;
//listed mark
for i:=1 to cfgsc^.NumCircle do DrawFinderMark(cfgsc^.CircleLst[i,1],cfgsc^.CircleLst[i,2],false);
end;

//  compass rose
Procedure Tskychart.DrawCRose;
begin
//draw circle
if cfgsc^.ShowCRose then Fplot.PlotCircle(10,10,10,10,Fplot.cfgplot^.Color[18],false);

end;
//  end of compass rose

function Tskychart.TelescopeMove(ra,dec:double):boolean;
var dist:double;
begin
result:=false;
cfgsc^.moved:=false;
if (ra<>cfgsc^.ScopeRa)or(dec<>cfgsc^.ScopeDec) then begin
cfgsc^.TrackType:=6;
cfgsc^.TrackName:='Telescope';
cfgsc^.TrackRA:=ra;
cfgsc^.TrackDec:=dec;
if cfgsc^.scopemark then DrawFinderMark(cfgsc^.ScopeRa,cfgsc^.ScopeDec,true);
DrawFinderMark(ra,dec,true);
cfgsc^.ScopeRa:=ra;
cfgsc^.ScopeDec:=dec;
cfgsc^.scopemark:=true;
dist:=angulardistance(cfgsc^.racentre,cfgsc^.decentre,ra,dec);
if (dist>cfgsc^.fov/4)and(cfgsc^.TrackOn) then begin
   if not cfgsc^.scopelock then begin
      result:=true;
      cfgsc^.scopelock:=true;
      MovetoRaDec(cfgsc^.ScopeRa,cfgsc^.ScopeDec);
      Refresh;
      cfgsc^.scopelock:=false;
   end;
end;
end;
end;

function Tskychart.GetChartInfo(sep:string=blank):string;
var cep,dat:string;
begin
    cep:=trim(cfgsc^.EquinoxName);
    dat:=Date2Str(cfgsc^.CurYear,cfgsc^.curmonth,cfgsc^.curday)+sep+ArToStr3(cfgsc^.Curtime);
    if  cfgsc^.TimeZone>=0 then
       dat:=dat+' (+'+trim(ArmtoStr(cfgsc^.TimeZone))+')'
    else
       dat:=dat+' ('+trim(ArmtoStr(cfgsc^.TimeZone))+')';
    case cfgsc^.projpole of
    Equat : result:='Equatorial Coord. '+cep+sep+dat;
    AltAz : result:='Alt/AZ Coord.'+sep+trim(cfgsc^.ObsName)+sep+dat;
    Gal :   result:='Galactic Coord.'+sep+dat;
    Ecl :   result:='Ecliptic Coord. '+cep+sep+dat+sep+'Inclination='+detostr(cfgsc^.e*rad2deg);
    else result:='';
    end;
    result:=result+sep+'Mag:'+formatfloat(f1,plot.cfgchart^.min_ma)+sep+'FOV:'+detostr(cfgsc^.fov*rad2deg);
end;

end.
