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

interface

uses cu_plot, cu_catalog, u_constant, libcatalog, cu_planet,
     SysUtils, Classes, Math,
{$ifdef linux}
   QControls, QExtCtrls, QGraphics;
{$endif}
{$ifdef mswindows}
   Controls, ExtCtrls, Graphics;
{$endif}
type

Tskychart = class (TComponent)
   private
    Fplot: TSplot;
    Fcatalog : Tcatalog;
    Fplanet : Tplanet;
    Procedure DrawSatel(ipla:integer; ra,dec,ma,diam : double; hidesat, showhide : boolean);
   public
    cfgsc : conf_skychart;
    constructor Create(AOwner:Tcomponent); override;
    destructor  Destroy; override;
   published
    property plot: TSplot read Fplot;
    property catalog: Tcatalog read Fcatalog write Fcatalog;
    property planet: Tplanet read Fplanet write Fplanet;
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
    function DrawNebulae :boolean;
    function DrawOutline :boolean;
    function DrawMilkyWay :boolean;
    function DrawPlanet :boolean;
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
end;


implementation

uses u_projection, u_util;

constructor Tskychart.Create(AOwner:Tcomponent);
begin
 inherited Create(AOwner);
 // set safe value
 cfgsc.quick:=false;
 cfgsc.JDChart:=jd2000;
 cfgsc.lastJDchart:=-1E25;
 cfgsc.racentre:=0;
 cfgsc.decentre:=0;
 cfgsc.fov:=1;
 cfgsc.theta:=0;
 cfgsc.projtype:='A';
 cfgsc.ProjPole:=Equat;
 cfgsc.FlipX:=1;
 cfgsc.FlipY:=1;
 cfgsc.WindowRatio:=1;
 cfgsc.BxGlb:=1;
 cfgsc.ByGlb:=1;
 cfgsc.AxGlb:=0;
 cfgsc.AyGlb:=0;
 cfgsc.xmin:=0;
 cfgsc.xmax:=100;
 cfgsc.ymin:=0;
 cfgsc.ymax:=100;
 cfgsc.RefractionOffset:=0;
 Fplot:=TSplot.Create(AOwner);
end;

destructor Tskychart.Destroy;
begin
 Fplot.free;
 inherited destroy;
end;

function Tskychart.Refresh :boolean;
var savmag: double;
    savfilter,saveautofilter,savfillmw:boolean;
begin
savmag:=Fcatalog.cfgshr.StarMagFilter[cfgsc.FieldNum];
savfilter:=Fcatalog.cfgshr.StarFilter;
saveautofilter:=Fcatalog.cfgshr.AutoStarFilter;
savfillmw:=cfgsc.FillMilkyWay;
try
  chdir(appdir);
  // initialize chart value
  InitObservatory;
  InitTime;
  InitChart;
  InitCoordinates;
  if cfgsc.quick then begin
     Fcatalog.cfgshr.StarMagFilter[cfgsc.FieldNum]:=Fcatalog.cfgshr.StarMagFilter[cfgsc.FieldNum]-3;
     Fcatalog.cfgshr.StarFilter:=true;
     Fcatalog.cfgshr.AutoStarFilter:=false;
  end else begin
     Fplanet.ComputePlanet(cfgsc);
  end;
  InitColor; // after ComputePlanet
  InitCatalog;
  // draw objects
  Fcatalog.OpenCat(cfgsc);
  // first the extended object
  if not cfgsc.quick then begin
    DrawMilkyWay; // most extended first
    // then the horizon line if transparent
    if (not cfgsc.horizonopaque) then DrawHorizon;
    DrawNebulae;
    DrawOutline;
  end;
  // then the lines
  DrawGrid;
  if not cfgsc.quick then begin
    DrawConstL;
    DrawConstB;
    DrawEcliptic;
    DrawGalactic;
  end;
  // the stars
  DrawStars;
  if not cfgsc.quick then begin
    DrawDblStars;
    DrawVarStars;
  end;
  // finally the planets
  if not cfgsc.quick then begin
    DrawOrbitPath;
  end;
  DrawPlanet;
  // and the horizon line if not transparent
  if (not cfgsc.quick)and cfgsc.horizonopaque then DrawHorizon;
  result:=true;
finally
  if cfgsc.quick then begin
     Fcatalog.cfgshr.StarMagFilter[cfgsc.FieldNum]:=savmag;
     Fcatalog.cfgshr.StarFilter:=savfilter;
     Fcatalog.cfgshr.AutoStarFilter:=saveautofilter;
  end;
  cfgsc.FillMilkyWay:=savfillmw;
  cfgsc.quick:=false;
  Fcatalog.CloseCat;
end;
end;

function Tskychart.InitCatalog:boolean;
var i:integer;
    mag:double;
  procedure InitStarC(cat:integer;defaultmag:double);
  { determine if the star catalog is active at this scale }
  begin
  if Fcatalog.cfgcat.starcatdef[cat-BaseStar] and
    (cfgsc.FieldNum>=Fcatalog.cfgcat.starcatfield[cat-BaseStar,1]) and
    (cfgsc.FieldNum<=Fcatalog.cfgcat.starcatfield[cat-BaseStar,2]) then begin
     Fcatalog.cfgcat.starcaton[cat-BaseStar]:=true;
     if Fcatalog.cfgshr.StarFilter then mag:=minvalue([defaultmag,Fcatalog.cfgcat.StarMagMax])
        else mag:=defaultmag;
     Fplot.cfgchart.min_ma:=maxvalue([Fplot.cfgchart.min_ma,mag]);
  end
     else Fcatalog.cfgcat.starcaton[cat-BaseStar]:=false;
  end;
  procedure InitVarC(cat:integer);
  { determine if the variable star catalog is active at this scale }
  begin
  if Fcatalog.cfgcat.varstarcatdef[cat-BaseVar] and
    (cfgsc.FieldNum>=Fcatalog.cfgcat.varstarcatfield[cat-BaseVar,1]) and
    (cfgsc.FieldNum<=Fcatalog.cfgcat.varstarcatfield[cat-BaseVar,2]) then
          Fcatalog.cfgcat.varstarcaton[cat-BaseVar]:=true
     else Fcatalog.cfgcat.varstarcaton[cat-BaseVar]:=false;
  end;
  procedure InitDblC(cat:integer);
  { determine if the double star catalog is active at this scale }
  begin
  if Fcatalog.cfgcat.dblstarcatdef[cat-BaseDbl] and
    (cfgsc.FieldNum>=Fcatalog.cfgcat.dblstarcatfield[cat-BaseDbl,1]) and
    (cfgsc.FieldNum<=Fcatalog.cfgcat.dblstarcatfield[cat-BaseDbl,2]) then
          Fcatalog.cfgcat.dblstarcaton[cat-BaseDbl]:=true
     else Fcatalog.cfgcat.dblstarcaton[cat-BaseDbl]:=false;
  end;
  procedure InitNebC(cat:integer);
  { determine if the nebulae catalog is active at this scale }
  begin
  if Fcatalog.cfgcat.nebcatdef[cat-BaseNeb] and
    (cfgsc.FieldNum>=Fcatalog.cfgcat.nebcatfield[cat-BaseNeb,1]) and
    (cfgsc.FieldNum<=Fcatalog.cfgcat.nebcatfield[cat-BaseNeb,2]) then
          Fcatalog.cfgcat.nebcaton[cat-BaseNeb]:=true
     else Fcatalog.cfgcat.nebcaton[cat-BaseNeb]:=false;
  end;
begin
if Fcatalog.cfgshr.AutoStarFilter then Fcatalog.cfgcat.StarMagMax:=round(10*(Fcatalog.cfgshr.AutoStarFilterMag+2.4*log10(intpower(pid2/cfgsc.fov,2))))/10
   else Fcatalog.cfgcat.StarMagMax:=Fcatalog.cfgshr.StarMagFilter[cfgsc.FieldNum];
Fcatalog.cfgcat.NebMagMax:=Fcatalog.cfgshr.NebMagFilter[cfgsc.FieldNum];
Fcatalog.cfgcat.NebSizeMin:=Fcatalog.cfgshr.NebSizeFilter[cfgsc.FieldNum];
Fplot.cfgchart.min_ma:=1;
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
     (cfgsc.FieldNum>=Fcatalog.cfgcat.GCatLst[i-1].min) and
     (cfgsc.FieldNum<=Fcatalog.cfgcat.GCatLst[i-1].max) then begin
         Fcatalog.cfgcat.GCatLst[i-1].CatOn:=true;
         case Fcatalog.cfgcat.GCatLst[i-1].cattype of
          rtstar: begin
                  Fcatalog.cfgcat.starcaton[gcstar-BaseStar]:=true;
                  if Fcatalog.cfgshr.StarFilter then mag:=minvalue([Fcatalog.cfgcat.GCatLst[i-1].magmax,Fcatalog.cfgcat.StarMagMax])
                                                else mag:=Fcatalog.cfgcat.GCatLst[i-1].magmax;
                  Fplot.cfgchart.min_ma:=maxvalue([Fplot.cfgchart.min_ma,mag]);
                  end;
          rtvar : Fcatalog.cfgcat.varstarcaton[gcvar-Basevar]:=true;
          rtdbl : Fcatalog.cfgcat.dblstarcaton[gcdbl-Basedbl]:=true;
          rtneb : Fcatalog.cfgcat.nebcaton[gcneb-Baseneb]:=true;
          rtlin : Fcatalog.cfgcat.lincaton[gclin-Baselin]:=true;
         end;
  end else Fcatalog.cfgcat.GCatLst[i-1].CatOn:=false;
// give mag. limit result to other functions
cfgsc.StarFilter:=Fcatalog.cfgshr.StarFilter;
cfgsc.StarMagMax:=Fcatalog.cfgcat.StarMagMax;
result:=true;
end;

function Tskychart.InitTime:boolean;
var y,m,d:integer;
    t:double;
begin
if cfgsc.UseSystemTime then begin
   SetCurrentTime(cfgsc);
   cfgsc.TimeZone:=GetTimezone
end else begin
   cfgsc.TimeZone:=cfgsc.ObsTZ;
end;
cfgsc.DT_UT:=DTminusUT(cfgsc.CurYear,cfgsc);
cfgsc.CurJD:=jd(cfgsc.CurYear,cfgsc.CurMonth,cfgsc.CurDay,cfgsc.CurTime-cfgsc.TimeZone+cfgsc.DT_UT);
cfgsc.jd0:=jd(cfgsc.CurYear,cfgsc.CurMonth,cfgsc.CurDay,0);
cfgsc.CurST:=Sidtim(cfgsc.jd0,cfgsc.CurTime-cfgsc.TimeZone,cfgsc.ObsLongitude);
if cfgsc.CurJD<>cfgsc.LastJD then begin // thing to do when the date change
   cfgsc.FindOk:=false;    // last search no longuer valid
end;
cfgsc.LastJD:=cfgsc.CurJD;
if (Fcatalog.cfgshr.Equinoxtype=2)or(cfgsc.projpole=altaz) then begin  // use equinox of the date
   cfgsc.JDChart:=cfgsc.CurJD;
   cfgsc.EquinoxName:='Date ';
end else begin
   cfgsc.JDChart:=Fcatalog.cfgshr.DefaultJDChart;
   cfgsc.EquinoxName:=fcatalog.cfgshr.EquinoxChart;
end;
djd(cfgsc.JDChart,y,m,d,t);
cfgsc.EquinoxDate:=YearADBC(y)+'-'+inttostr(m)+'-'+inttostr(d);
if (cfgsc.lastJDchart<-1E20) then cfgsc.lastJDchart:=cfgsc.JDchart; // initial value
cfgsc.rap2000:=0;       // position of J2000 pole in current coordinates
cfgsc.dep2000:=pid2;
precession(jd2000,cfgsc.JDChart,cfgsc.rap2000,cfgsc.dep2000);
result:=true;
end;

function Tskychart.InitObservatory:boolean;
var u,p : double;
const ratio = 0.99664719;
      H0 = 6378140.0 ;
begin
   p:=deg2rad*cfgsc.ObsLatitude;
   u:=arctan(ratio*tan(p));
   cfgsc.ObsRoSinPhi:=ratio*sin(u)+(cfgsc.ObsAltitude/H0)*sin(p);
   cfgsc.ObsRoCosPhi:=cos(u)+(cfgsc.ObsAltitude/H0)*cos(p);
   cfgsc.ObsRefractionCor:=(cfgsc.ObsPressure/1010)*(283/(273+cfgsc.ObsTemperature));
   result:=true;
end;

function Tskychart.InitChart:boolean;
begin
// do not add more function here as this is also called at the chart create
cfgsc.xmin:=0;
cfgsc.ymin:=0;
cfgsc.xmax:=Fplot.cfgchart.width;
cfgsc.ymax:=Fplot.cfgchart.height;
ScaleWindow(cfgsc);
result:=true;
end;

function Tskychart.InitColor:boolean;
var i : integer;
begin
if Fplot.cfgplot.color[0]>Fplot.cfgplot.color[11] then begin // white background
   Fplot.cfgplot.AutoSkyColor:=false;
   Fplot.cfgplot.StarPlot:=0;
   Fplot.cfgplot.NebPlot:=0;
   cfgsc.FillMilkyWay:=false;
   cfgsc.WhiteBg:=true;
end else cfgsc.WhiteBg:=false;
if Fplot.cfgplot.AutoSkyColor and (cfgsc.Projpole=AltAz) then begin
 if (cfgsc.fov>10*deg2rad) then begin
  if cfgsc.CurSunH>0 then i:=1
  else if cfgsc.CurSunH>-5*deg2rad then i:=2
  else if cfgsc.CurSunH>-11*deg2rad then i:=3
  else if cfgsc.CurSunH>-13*deg2rad then i:=4
  else if cfgsc.CurSunH>-15*deg2rad then i:=5
  else if cfgsc.CurSunH>-17*deg2rad then i:=6
  else i:=7;
 end else
  if cfgsc.CurSunH>0 then i:=5
  else if cfgsc.CurSunH>-5*deg2rad then i:=5
  else if cfgsc.CurSunH>-11*deg2rad then i:=6
  else if cfgsc.CurSunH>-13*deg2rad then i:=6
  else if cfgsc.CurSunH>-15*deg2rad then i:=7
  else if cfgsc.CurSunH>-17*deg2rad then i:=7
  else i:=7;
 if (i>=5)and(cfgsc.CurMoonH>0) then begin
    if (cfgsc.CurMoonIllum>0.1)and(cfgsc.CurMoonIllum<0.5) then i:=i-1;
    if (cfgsc.CurMoonIllum>=0.5) then i:=i-2;
    if i<5 then i:=5;
 end;
 Fplot.cfgplot.color[0]:=Fplot.cfgplot.SkyColor[i];
end else Fplot.cfgplot.color[0]:=Fplot.cfgplot.bgColor;
Fplot.cfgplot.backgroundcolor:=Fplot.cfgplot.color[0];
Fplot.init(Fplot.cfgchart.width,Fplot.cfgchart.height);
result:=true;
end;

function Tskychart.GetFieldNum(fov:double):integer;
var     i : integer;
begin
fov:=rad2deg*fov;
if fov>360 then fov:=360;
result:=MaxField;
for i:=0 to MaxField do if Fcatalog.cfgshr.FieldNum[i]>=fov then begin
       result:=i;
       break;
    end;
end;

function Tskychart.InitCoordinates:boolean;
var w,h,a,d,dist,v1,v2,v3,v4,v5,v6 : double;
begin
cfgsc.RefractionOffset:=0;
// clipping limit
Fplot.cfgplot.outradius:=abs(round(minvalue([50*cfgsc.fov,0.98*pi2])*cfgsc.BxGlb/2));
Fplot.cfgchart.hw:=Fplot.cfgchart.width div 2;
Fplot.cfgchart.hh:=Fplot.cfgchart.height div 2;
// find the current field number and projection
w := cfgsc.fov;
h := cfgsc.fov/cfgsc.WindowRatio;
w := maxvalue([w,h]);
cfgsc.FieldNum:=GetFieldNum(w);
cfgsc.projtype:=(cfgsc.projname[cfgsc.fieldnum]+'A')[1];
// is the chart to be centered on an object ?
 if cfgsc.TrackOn then begin
  case cfgsc.TrackType of
     1 : begin
         case cfgsc.Trackobj of
         1..9 : fplanet.Planet(cfgsc.TrackObj,cfgsc.CurJd,a,d,dist,v1,v2,v3,v4,v5);
         10   : fplanet.Sun(cfgsc.CurJd,a,d,dist,v1);
         11   : fplanet.Moon(cfgsc.CurJd,a,d,dist,v1,v2,v3,v4);
         32   : begin
                fplanet.Sun(cfgsc.CurJd,a,d,v1,v2);
                fplanet.Moon(cfgsc.CurJd,v1,v2,dist,v3,v4,v5,v6);
                a:=rmod(a+pi,pi2);
                d:=-d;
                end;
         end;
         if cfgsc.PlanetParalaxe then Paralaxe(cfgsc.CurST,dist,a,d,a,d,v1,cfgsc);
         cfgsc.racentre:=a;
         cfgsc.decentre:=d;
         end;
{     2 : begin
         InitComete(CometNum[FollowObj],buf);
         Comete(jdt,ar,de,dist,v1,v2,v3,v4,v5,v6,v7,v8);
         if PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,v1);
         arcentre:=ar;
         decentre:=de;
         end;
     3 : begin
         InitAsteroide(AsteroidNum[FollowObj],buf);
         Asteroide(jdt,ar,de,dist,v1,v2,v3,v4);
         if PlanetParalaxe then Paralaxe(st0,dist,ar,de,ar,de,v1);
         arcentre:=ar;
         decentre:=de;
         end;    }
     4 : begin
         if cfgsc.Projpole=AltAz then begin
           Hz2Eq(cfgsc.acentre,cfgsc.hcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
           cfgsc.racentre:=cfgsc.CurST-cfgsc.racentre;
         end;
         cfgsc.TrackOn:=false;
         end;
   end;
  end;
// normalize the coordinates
if (cfgsc.decentre>=(pid2-secarc)) then cfgsc.decentre:=pid2-secarc;
if (cfgsc.decentre<=(-pid2+secarc)) then cfgsc.decentre:=-pid2+secarc;
cfgsc.racentre:=rmod(cfgsc.racentre+pi2,pi2);
// apply precession if the epoch change from previous chart
if cfgsc.lastJDchart<>cfgsc.JDchart then
   precession(cfgsc.lastJDchart,cfgsc.JDchart,cfgsc.racentre,cfgsc.decentre);
cfgsc.lastJDchart:=cfgsc.JDchart;
// get alt/az center
Eq2Hz(cfgsc.CurST-cfgsc.racentre,cfgsc.decentre,cfgsc.acentre,cfgsc.hcentre,cfgsc) ;
// compute refraction error at the chart center
Hz2Eq(cfgsc.acentre,cfgsc.hcentre,a,d,cfgsc);
Eq2Hz(a,d,w,h,cfgsc) ;
cfgsc.RefractionOffset:=h-cfgsc.hcentre;
// get galactic center
Eq2Gal(cfgsc.racentre,cfgsc.decentre,cfgsc.lcentre,cfgsc.bcentre,cfgsc) ;
// get ecliptic center
cfgsc.e:=ecliptic(cfgsc.JDChart);
Eq2Ecl(cfgsc.racentre,cfgsc.decentre,cfgsc.e,cfgsc.lecentre,cfgsc.becentre) ;
result:=true;
end;

function Tskychart.DrawStars :boolean;
var rec:GcatRec;
  x1,y1,cyear,dyear: Double;
  xx,yy,xxp,yyp: integer;
begin
fillchar(rec,sizeof(rec),0);
cyear:=cfgsc.CurYear+cfgsc.CurMonth/12;
dyear:=0;
try
if Fcatalog.OpenStar then
 while Fcatalog.readstar(rec) do begin
 if cfgsc.PMon or cfgsc.DrawPMon then begin
    if rec.star.valid[vsEpoch] then dyear:=cyear-rec.star.epoch
                               else dyear:=cyear-rec.options.Epoch;
 end;
 if cfgsc.PMon and rec.star.valid[vsPmra] and rec.star.valid[vsPmdec] then begin
    rec.ra:=rec.ra+(rec.star.pmra/cos(rec.dec))*dyear;
    rec.dec:=rec.dec+(rec.star.pmdec)*dyear;
 end;
 precession(rec.options.EquinoxJD,cfgsc.JDChart,rec.ra,rec.dec);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
    Fplot.PlotStar(xx,yy,rec.star.magv,rec.star.b_v);
    if cfgsc.DrawPMon then begin
       rec.ra:=rec.ra+(rec.star.pmra/cos(rec.dec))*cfgsc.DrawPMyear;
       rec.dec:=rec.dec+(rec.star.pmdec)*cfgsc.DrawPMyear;
       projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
       WindowXY(x1,y1,xxp,yyp,cfgsc);
       Fplot.PlotLine(xx,yy,xxp,yyp,Fplot.cfgplot.Color[15],1);
    end;
 end;
end;
result:=true;
finally
Fcatalog.CloseStar;
end;
end;

function Tskychart.DrawVarStars :boolean;
var rec:GcatRec;
  x1,y1: Double;
  xx,yy: integer;
begin
fillchar(rec,sizeof(rec),0);
try
if Fcatalog.OpenVarStar then
 while Fcatalog.readvarstar(rec) do begin
 precession(rec.options.EquinoxJD,cfgsc.JDChart,rec.ra,rec.dec);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
    Fplot.PlotVarStar(xx,yy,rec.variable.magmax,rec.variable.magmin);
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
  xx,yy: integer;
begin
fillchar(rec,sizeof(rec),0);
try
if Fcatalog.OpenDblStar then
 while Fcatalog.readdblstar(rec) do begin
 precession(rec.options.EquinoxJD,cfgsc.JDChart,rec.ra,rec.dec);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
    projection(rec.ra,rec.dec+0.001,x2,y2,false,cfgsc) ;
    rot:=arctan2((x1-x2),(y1-y2));
    if (not rec.double.valid[vdPA])or(rec.double.pa=-999) then rec.double.pa:=0
        else rec.double.pa:=rec.double.pa-rad2deg*PoleRot2000(rec.ra,rec.dec);
    rec.double.pa:=rec.double.pa*cfgsc.FlipX;
    if cfgsc.FlipY<0 then rec.double.pa:=180-rec.double.pa;
    if cfgsc.FlipY<0 then rot:=rot-pi;
    rec.double.pa:=DegToRad(rec.double.pa)-rot;
    Fplot.PlotDblStar(xx,yy,rec.double.mag1,rec.double.sep,rec.double.pa,0);
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
if cfgsc.JDChart=jd2000 then result:=0
else begin
  Proj2(cfgsc.rap2000,cfgsc.dep2000,ra,dec,x1,y1,cfgsc);
  result:=arctan2(x1,y1);
end;
end;

function Tskychart.DrawNebulae :boolean;
var rec:GcatRec;
  x1,y1,x2,y2,rot: Double;
  xx,yy: integer;
begin
fillchar(rec,sizeof(rec),0);
try
if Fcatalog.OpenNeb then
 while Fcatalog.readneb(rec) do begin
 precession(rec.options.EquinoxJD,cfgsc.JDChart,rec.ra,rec.dec);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
  if not rec.neb.valid[vnNebtype] then rec.neb.nebtype:=rec.options.ObjType;
  if not rec.neb.valid[vnNebunit] then rec.neb.nebunit:=rec.options.Units;
  if rec.neb.nebtype=1 then begin
      projection(rec.ra,rec.dec+0.001,x2,y2,false,cfgsc) ;
      rot:=arctan2((x1-x2),(y1-y2));
      if (not rec.neb.valid[vnPA])or(rec.neb.pa=-999) then rec.neb.pa:=90
          else rec.neb.pa:=rec.neb.pa-rad2deg*PoleRot2000(rec.ra,rec.dec);
      rec.neb.pa:=rec.neb.pa*cfgsc.FlipX;
      if cfgsc.FlipY<0 then rec.neb.pa:=180-rec.neb.pa;
      if cfgsc.FlipY<0 then rot:=rot-pi;
      rec.neb.pa:=DegToRad(rec.neb.pa)-rot;
      Fplot.PlotGalaxie(xx,yy,rec.neb.dim1,rec.neb.dim2,rec.neb.pa,0,100,100,rec.neb.mag,rec.neb.sbr,abs(cfgsc.BxGlb)*deg2rad/rec.neb.nebunit);
   end else
      Fplot.PlotNebula(xx,yy,rec.neb.dim1,rec.neb.mag,rec.neb.sbr,abs(cfgsc.BxGlb)*deg2rad/rec.neb.nebunit,rec.neb.nebtype);
 end;
end;
result:=true;
finally
 Fcatalog.CloseNeb;
end;
end;

function Tskychart.DrawOutline :boolean;
var rec:GcatRec;
  x1,y1: Double;
  xx,yy,op,lw,col,fs: integer;
begin
fillchar(rec,sizeof(rec),0);
try
if Fcatalog.OpenLin then
 while Fcatalog.readlin(rec) do begin
 precession(rec.options.EquinoxJD,cfgsc.JDChart,rec.ra,rec.dec);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc,true) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 op:=rec.outlines.lineoperation;
 if rec.outlines.valid[vlLinewidth] then lw:=rec.outlines.linewidth else lw:=rec.options.Size;
 if rec.outlines.valid[vlLinetype] then fs:=rec.outlines.linetype else fs:=rec.options.LogSize;
 if cfgsc.WhiteBg then col:=FPlot.cfgplot.Color[11]
 else begin
    if rec.outlines.valid[vlLinecolor] then col:=rec.outlines.linecolor else col:=rec.options.Units;
//    col:=addcolor(col,FPlot.cfgplot.Color[0]);
 end;
 FPlot.PlotOutline(xx,yy,op,lw,fs,rec.options.ObjType,cfgsc.x2,col);
end;
result:=true;
finally
 Fcatalog.CloseLin;
end;
end;

function Tskychart.DrawMilkyWay :boolean;
var rec:GcatRec;
  x1,y1: Double;
  xx,yy,op,lw,col,fs: integer;
  first:boolean;
begin
result:=false;
if not cfgsc.ShowMilkyWay then exit;
if cfgsc.fov<(deg2rad*2) then exit;
fillchar(rec,sizeof(rec),0);
first:=true;
col:=0;lw:=1;fs:=1;
try
if Fcatalog.OpenMilkyway(cfgsc.FillMilkyWay) then
 while Fcatalog.readMilkyway(rec) do begin
 if first then begin
    // all the milkyway line use the same property
    if rec.outlines.valid[vlLinewidth] then lw:=rec.outlines.linewidth else lw:=rec.options.Size;
    if cfgsc.WhiteBg then col:=FPlot.cfgplot.Color[11]
    else begin
      if rec.outlines.valid[vlLinecolor] then col:=rec.outlines.linecolor else col:=rec.options.Units;
      col:=addcolor(col,FPlot.cfgplot.Color[0]);
    end;  
    if rec.outlines.valid[vlLinetype] then fs:=rec.outlines.linetype else fs:=rec.options.LogSize;
    first:=false;
 end;
 precession(rec.options.EquinoxJD,cfgsc.JDChart,rec.ra,rec.dec);
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc,true) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 op:=rec.outlines.lineoperation;
 FPlot.PlotOutline(xx,yy,op,lw,fs,rec.options.ObjType,cfgsc.x2,col);
end;
result:=true;
finally
 Fcatalog.CloseMilkyway;
end;
end;

function Tskychart.DrawPlanet :boolean;
var
  x1,y1,x2,y2,pixscale,ra,dec,jdt,diam,magn,phase,fov,illum,pa,rot,r1,r2,be,dist: Double;
  xx,yy,xxp,yyp,i,j,n,ipla: integer;
  draworder : array[1..11] of integer;
begin
if not cfgsc.ShowPlanet then exit;
fov:=rad2deg*cfgsc.fov;
pixscale:=abs(cfgsc.BxGlb)*deg2rad/3600;
for j:=0 to cfgsc.SimNb-1 do begin
  draworder[1]:=1;
  for n:=2 to 11 do begin
    if cfgsc.Planetlst[j,n,6]<cfgsc.Planetlst[j,draworder[n-1],6] then
       draworder[n]:=n
    else begin
       i:=n;
       repeat
         i:=i-1;
         draworder[i+1]:=draworder[i];
       until (i=1)or(cfgsc.Planetlst[j,n,6]<=cfgsc.Planetlst[j,draworder[i-1],6]);
       draworder[i]:=n;
    end;
  end;
  for n:=1 to 11 do begin
    ipla:=draworder[n];
    if (j>0) and (not cfgsc.SimObject[ipla]) then continue;
    if ipla=3 then continue;
    ra:=cfgsc.Planetlst[j,ipla,1];
    dec:=cfgsc.Planetlst[j,ipla,2];
    jdt:=cfgsc.Planetlst[j,ipla,3];
    diam:=cfgsc.Planetlst[j,ipla,4];
    magn:=cfgsc.Planetlst[j,ipla,5];
    phase:=cfgsc.Planetlst[j,ipla,7];
    projection(ra,dec,x1,y1,true,cfgsc) ;
    WindowXY(x1,y1,xx,yy,cfgsc);
    projection(ra,dec+0.001,x2,y2,false,cfgsc) ;
    rot:=arctan2((x1-x2),(y1-y2));
    if cfgsc.FlipY<0 then rot:=rot-pi;
    case ipla of
    4 :  begin
         if (xx>-cfgsc.Xmax) and (xx<2*cfgsc.Xmax) and (yy>-cfgsc.Ymax) and (yy<2*cfgsc.Ymax) then begin
            if (fov<=1.5) and (cfgsc.Planetlst[j,29,6]<90) then for i:=1 to 2 do DrawSatel(i+28,cfgsc.Planetlst[j,i+28,1],cfgsc.Planetlst[j,i+28,2],cfgsc.Planetlst[j,i+28,5],cfgsc.Planetlst[j,i+28,4],cfgsc.Planetlst[j,i+28,6]>1.0,true);
            Fplot.PlotPlanet(xx,yy,ipla,pixscale,jdt,diam,magn,phase,0,0,0,0,0,0,0);
            if (fov<=1.5) and (cfgsc.Planetlst[j,29,6]<90) then for i:=1 to 2 do DrawSatel(i+28,cfgsc.Planetlst[j,i+28,1],cfgsc.Planetlst[j,i+28,2],cfgsc.Planetlst[j,i+28,5],cfgsc.Planetlst[j,i+28,4],cfgsc.Planetlst[j,i+28,6]>1.0,false);
         end;
         end;
    5 :  begin
         if (xx>-cfgsc.Xmax) and (xx<2*cfgsc.Xmax) and (yy>-cfgsc.Ymax) and (yy<2*cfgsc.Ymax) then begin
            if (fov<=1.5) and (cfgsc.Planetlst[j,12,6]<90) then for i:=1 to 4 do DrawSatel(i+11,cfgsc.Planetlst[j,i+11,1],cfgsc.Planetlst[j,i+11,2],cfgsc.Planetlst[j,i+11,5],cfgsc.Planetlst[j,i+11,4],cfgsc.Planetlst[j,i+11,6]>1.0,true);
            Fplot.PlotPlanet(xx,yy,ipla,pixscale,jdt,diam,magn,phase,0,0,0,0,0,0,0);
            if (fov<=1.5) and (cfgsc.Planetlst[j,12,6]<90) then for i:=1 to 4 do DrawSatel(i+11,cfgsc.Planetlst[j,i+11,1],cfgsc.Planetlst[j,i+11,2],cfgsc.Planetlst[j,i+11,5],cfgsc.Planetlst[j,i+11,4],cfgsc.Planetlst[j,i+11,6]>1.0,false);
         end;
         end;
    6 :  begin
         if (xx>-cfgsc.Xmax) and (xx<2*cfgsc.Xmax) and (yy>-cfgsc.Ymax) and (yy<2*cfgsc.Ymax) then begin
            if (fov<=1.5) and (cfgsc.Planetlst[j,16,6]<90) then for i:=1 to 8 do DrawSatel(i+15,cfgsc.Planetlst[j,i+15,1],cfgsc.Planetlst[j,i+15,2],cfgsc.Planetlst[j,i+15,5],cfgsc.Planetlst[j,i+15,4],cfgsc.Planetlst[j,i+15,6]>1.0,true);
            pa:=cfgsc.Planetlst[j,31,1]*cfgsc.FlipX;
            r1:=cfgsc.Planetlst[j,31,2];
            r2:=cfgsc.Planetlst[j,31,3];
            be:=cfgsc.Planetlst[j,31,4];
            if cfgsc.FlipY<0 then pa:=180-pa;
            Fplot.PlotPlanet(xx,yy,ipla,pixscale,jdt,diam,magn,phase,0,pa,rot,r1,r2,be,0);
            if (fov<=1.5) and (cfgsc.Planetlst[j,16,6]<90) then for i:=1 to 8 do DrawSatel(i+15,cfgsc.Planetlst[j,i+15,1],cfgsc.Planetlst[j,i+15,2],cfgsc.Planetlst[j,i+15,5],cfgsc.Planetlst[j,i+15,4],cfgsc.Planetlst[j,i+15,6]>1.0,false);
         end;
         end;
    7 :  begin
         if (xx>-cfgsc.Xmax) and (xx<2*cfgsc.Xmax) and (yy>-cfgsc.Ymax) and (yy<2*cfgsc.Ymax) then begin
            if (fov<=1.5) and (cfgsc.Planetlst[j,24,6]<90) then for i:=1 to 5 do DrawSatel(i+23,cfgsc.Planetlst[j,i+23,1],cfgsc.Planetlst[j,i+23,2],cfgsc.Planetlst[j,i+23,5],cfgsc.Planetlst[j,i+23,4],cfgsc.Planetlst[j,i+23,6]>1.0,true);
            Fplot.PlotPlanet(xx,yy,ipla,pixscale,jdt,diam,magn,phase,0,0,0,0,0,0,0);
            if (fov<=1.5) and (cfgsc.Planetlst[j,24,6]<90) then for i:=1 to 5 do DrawSatel(i+23,cfgsc.Planetlst[j,i+23,1],cfgsc.Planetlst[j,i+23,2],cfgsc.Planetlst[j,i+23,5],cfgsc.Planetlst[j,i+23,4],cfgsc.Planetlst[j,i+23,6]>1.0,false);
         end;
         end;
    11 : begin
         if (xx>-cfgsc.Xmax) and (xx<2*cfgsc.Xmax) and (yy>-cfgsc.Ymax) and (yy<2*cfgsc.Ymax) then begin
            illum:=magn;
            magn:=-10;  // better to alway show a bright dot for the Moon
            dist:=cfgsc.Planetlst[j,ipla,6];
            fplanet.MoonIncl(ra,dec,cfgsc.PlanetLst[j,10,1],cfgsc.PlanetLst[j,10,2],pa);
            pa:=pa*cfgsc.FlipX;
            if cfgsc.FlipY<0 then pa:=180-pa;
            Fplot.PlotPlanet(xx,yy,ipla,pixscale,jdt,diam,magn,phase,illum,pa,rot,0,0,0,dist);
         end;
         end;
    else begin
         if (xx>-cfgsc.Xmax) and (xx<2*cfgsc.Xmax) and (yy>-cfgsc.Ymax) and (yy<2*cfgsc.Ymax) then
            Fplot.PlotPlanet(xx,yy,ipla,pixscale,jdt,diam,magn,phase,0,0,0,0,0,0,0);
         end;
    end;
//  end;
  //if ShowEarthUmbra then DrawEarthUmbra(cfgsc.Planetlst[j,32,1],cfgsc.Planetlst[j,32,2],cfgsc.Planetlst[j,32,3],cfgsc.Planetlst[j,32,4],cfgsc.Planetlst[j,32,5],onprinter,out);
  end;
end;
result:=true;
end;

Procedure Tskychart.DrawSatel(ipla:integer; ra,dec,ma,diam : double; hidesat, showhide : boolean);
var
  x1,y1 : double;
  xx,yy : Integer;
begin
projection(ra,dec,x1,y1,true,cfgsc) ;
WindowXY(x1,y1,xx,yy,cfgsc);
Fplot.PlotSatel(xx,yy,ipla,abs(cfgsc.BxGlb)*deg2rad/3600,ma,diam,hidesat,showhide);
end;

function Tskychart.DrawOrbitPath:boolean;
var i,j,xx,yy,xp,yp,color : integer;
    x1,y1 : double;
begin
Color:=Fplot.cfgplot.Color[14];
xp:=0;yp:=0;
if cfgsc.ShowPlanet then for i:=1 to 11 do
  if (i<>3)and(cfgsc.SimObject[i]) then for j:=0 to cfgsc.SimNb-1 do begin
    projection(cfgsc.Planetlst[j,i,1],cfgsc.Planetlst[j,i,2],x1,y1,true,cfgsc) ;
    windowxy(x1,y1,xx,yy,cfgsc);
    if (j<>0)and((xx>-2*cfgsc.xmax)and(yy>-2*cfgsc.ymax)and(xx<3*cfgsc.xmax)and(yy<3*cfgsc.ymax))
       and ((xp>-2*cfgsc.xmax)and(yp>-2*cfgsc.ymax)and(xp<3*cfgsc.xmax)and(yp<3*cfgsc.ymax)) then 
       Fplot.PlotLine(xp,yp,xx,yy,color,1);
    xp:=xx;
    yp:=yy;
end;
{for i:=1 to CometNb do
  for j:=0 to SimNb-1 do begin
    projection(CometPlst[j,i,1]*15,CometPlst[j,i,2],x1,y1,true) ;
    windowxy(x1,y1,xx,yy);
    if (j=0)or((xx<-xmax)or(yy<-ymax)or(xx>2*xmax)or(yy>2*ymax)) then Moveto(xx,yy)
       else Lineto(xx,yy);
  end;
for i:=1 to AsteroidNb do
  for j:=0 to SimNb-1 do begin
    projection(AsteroidPlst[j,i,1]*15,AsteroidPlst[j,i,2],x1,y1,true) ;
    windowxy(x1,y1,xx,yy);
    if (j=0)or((xx<-xmax)or(yy<-ymax)or(xx>2*xmax)or(yy>2*ymax)) then Moveto(xx,yy)
       else Lineto(xx,yy);
  end;}
result:=true;  
end;

procedure Tskychart.GetCoord(x,y: integer; var ra,dec,a,h,l,b,le,be:double);
begin
getadxy(x,y,ra,dec,cfgsc);
GetAHxy(X,Y,a,h,cfgsc);
if Fcatalog.cfgshr.AzNorth then a:=rmod(a+pi,pi2);
GetLBxy(X,Y,l,b,cfgsc);
GetLBExy(X,Y,le,be,cfgsc);
end;

procedure Tskychart.MoveChart(ns,ew:integer; movefactor:double);
begin
 if cfgsc.Projpole=AltAz then begin
    cfgsc.acentre:=rmod(cfgsc.acentre-ew*cfgsc.fov/movefactor/cos(cfgsc.hcentre)+pi2,pi2);
    cfgsc.hcentre:=cfgsc.hcentre+ns*cfgsc.fov/movefactor/cfgsc.windowratio;
    if cfgsc.hcentre>pid2 then cfgsc.hcentre:=pi-cfgsc.hcentre;
    Hz2Eq(cfgsc.acentre,cfgsc.hcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
    cfgsc.racentre:=cfgsc.CurST-cfgsc.racentre;
 end
 else if cfgsc.Projpole=Gal then begin
    cfgsc.lcentre:=rmod(cfgsc.lcentre+ew*cfgsc.fov/movefactor/cos(cfgsc.bcentre)+pi2,pi2);
    cfgsc.bcentre:=cfgsc.bcentre+ns*cfgsc.fov/movefactor/cfgsc.windowratio;
    if cfgsc.bcentre>pid2 then cfgsc.bcentre:=pi-cfgsc.bcentre;
    Gal2Eq(cfgsc.lcentre,cfgsc.bcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
 end
 else if cfgsc.Projpole=Ecl then begin
    cfgsc.lecentre:=rmod(cfgsc.lecentre+ew*cfgsc.fov/movefactor/cos(cfgsc.becentre)+pi2,pi2);
    cfgsc.becentre:=cfgsc.becentre+ns*cfgsc.fov/movefactor/cfgsc.windowratio;
    if cfgsc.becentre>pid2 then cfgsc.becentre:=pi-cfgsc.becentre;
    Ecl2Eq(cfgsc.lecentre,cfgsc.becentre,cfgsc.e,cfgsc.racentre,cfgsc.decentre);
 end
 else begin // Equ
    cfgsc.racentre:=rmod(cfgsc.racentre+ew*cfgsc.fov/movefactor/cos(cfgsc.decentre)+pi2,pi2);
    cfgsc.decentre:=cfgsc.decentre+ns*cfgsc.fov/movefactor/cfgsc.windowratio;
    if cfgsc.decentre>pid2 then cfgsc.decentre:=pi-cfgsc.decentre;
end;
end;

procedure Tskychart.MovetoXY(X,Y : integer);
begin
   GetADxy(X,Y,cfgsc.racentre,cfgsc.decentre,cfgsc);
   cfgsc.racentre:=rmod(cfgsc.racentre+pi2,pi2);
end;

procedure Tskychart.MovetoRaDec(ra,dec:double);
begin
   cfgsc.racentre:=rmod(ra+pi2,pi2);
   cfgsc.decentre:=dec;
end;

procedure Tskychart.Zoom(zoomfactor:double);
begin
 SetFOV(cfgsc.fov/zoomfactor);
end;

procedure Tskychart.SetFOV(f:double);
begin
 cfgsc.fov := f;
 if cfgsc.fov<FovMin then cfgsc.fov:=FovMin;
 if cfgsc.fov>FovMax then cfgsc.fov:=FovMax;
end;

Procedure Tskychart.FormatCatRec(rec:Gcatrec; var desc:string);
var txt: string;
    i : integer;
const b=' ';
      b5='     ';
      dp = ':';
begin
 cfgsc.FindRA:=rec.ra;
 cfgsc.FindDec:=rec.dec;
 cfgsc.FindSize:=0;
 desc:= ARpToStr(rmod(rad2deg*rec.ra/15+24,24))+tab+DEpToStr(rad2deg*rec.dec)+tab;
 case rec.options.rectype of
 rtStar: begin   // stars
         if rec.star.valid[vsId] then txt:=rec.star.id else txt:='';
         if trim(txt)='' then Fcatalog.GetAltName(rec,txt);
         txt:=rec.options.ShortName+b+txt;
         cfgsc.FindName:=txt;
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
         cfgsc.FindName:=txt;
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
         cfgsc.FindName:=txt;
         Desc:=Desc+' D*'+tab+txt+tab;
         if rec.double.valid[vdCompname] then Desc:=Desc+rec.double.compname+tab;
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
            cfgsc.FindSize:=rec.double.sep*secarc;
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
         cfgsc.FindName:=txt;
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
            if rec.neb.valid[vnDim1] then cfgsc.FindSize:=rec.neb.dim1
                                     else cfgsc.FindSize:=rec.options.Size;
            str(cfgsc.FindSize:5:1,txt);
            Desc:=Desc+'Dim'+dp+txt;
            if rec.neb.valid[vnDim2] and (rec.neb.dim2>0) then str(rec.neb.dim2:5:1,txt);
            Desc:=Desc+' x'+txt+b;
            if rec.neb.valid[vnNebunit] then i:=rec.neb.nebunit
                                        else i:=rec.options.Units;
            if i=0 then i:=1;                            
            cfgsc.FindSize:=deg2rad*cfgsc.FindSize/i;
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
 cfgsc.FindDesc:=Desc;
 cfgsc.FindNote:='';
end;

function Tskychart.FindatRaDec(ra,dec,dx: double;showall:boolean=false):boolean;
var x1,x2,y1,y2:double;
    rec: Gcatrec;
    desc,n,m,d: string;
    saveStarFilter,saveNebFilter:boolean;
begin
x1 := NormRA(ra-dx/cos(dec));
x2 := NormRA(ra+dx/cos(dec));
y1 := maxvalue([-pid2,dec-dx]);
y2 := minvalue([pid2,dec+dx]);
desc:='';
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
  if showall then begin
    Fcatalog.cfgshr.NebFilter:=saveNebFilter;
    Fcatalog.cfgshr.StarFilter:=saveStarFilter;
  end;
end;
if result then begin
   FormatCatRec(rec,desc);
end else begin
// search solar system object
   result:=fplanet.findplanet(x1,y1,x2,y2,false,cfgsc,n,m,d,desc);
   if cfgsc.SimNb>1 then cfgsc.FindName:=cfgsc.FindName+' '+d; // add date to the name if simulation for more than one date
end;
end;

procedure Tskychart.FindList(ra,dec,dx,dy: double;var text:widestring;showall,allobject,trunc:boolean);
var x1,x2,y1,y2,xx1,yy1:double;
    rec: Gcatrec;
    desc,n,m,d: string;
    saveStarFilter,saveNebFilter,ok:boolean;
    i,xx,yy:integer;
const maxln : integer = 2000;
Procedure FindatPosCat(cat:integer);
begin
 ok:=fcatalog.FindatPos(cat,x1,y1,x2,y2,false,trunc,cfgsc,rec);
 while ok do begin
   if i>maxln then break;
   projection(rec.ra,rec.dec,xx1,yy1,true,cfgsc) ;
   windowxy(xx1,yy1,xx,yy,cfgsc);
   if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
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
   projection(cfgsc.findra,cfgsc.finddec,xx1,yy1,true,cfgsc) ;
   windowxy(xx1,yy1,xx,yy,cfgsc);
   if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
      text:=text+desc+crlf;
      inc(i);
   end;   
   ok:=fplanet.findplanet(x1,y1,x2,y2,true,cfgsc,n,m,d,desc);
 end;
end;
begin
if northpoleinmap(cfgsc) or southpoleinmap(cfgsc) then begin
  x1:=0;
  x2:=pi2;
end else begin
  x1 := NormRA(ra-dx/cos(dec));
  x2 := NormRA(ra+dx/cos(dec));
  if x2<x1 then x2:=x2+pi2;
end;
y1 := maxvalue([-pid2,dec-dy]);
y2 := minvalue([pid2,dec+dy]);
text:='';
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
  if showall then begin
    Fcatalog.cfgshr.NebFilter:=saveNebFilter;
    Fcatalog.cfgshr.StarFilter:=saveStarFilter;
  end;
end;
end;

Procedure Tskychart.DrawGrid;
begin
if ((deg2rad*Fcatalog.cfgshr.DegreeGridSpacing[cfgsc.FieldNum])<=cfgsc.fov) then begin
    if cfgsc.ShowGrid then
       case cfgsc.ProjPole of
       Equat  :  DrawEqGrid;
       AltAz  :  begin DrawAzGrid; if cfgsc.ShowEqGrid then DrawEqGrid; end;
       Gal    :  begin DrawGalGrid; if cfgsc.ShowEqGrid then DrawEqGrid; end;
       Ecl    :  begin DrawEclGrid; if cfgsc.ShowEqGrid then DrawEqGrid; end;
       end
    else if cfgsc.ShowEqGrid then DrawEqGrid;
end else if cfgsc.ShowGrid then DrawScale;
end;

Procedure Tskychart.DrawScale;
var fv,u:double;
    i,n,s,x,y,xp:integer;
    l1,l2:string;
const sticksize=10;
begin
fv:=rad2deg*cfgsc.fov/3;
if trunc(fv)>5 then begin l1:='1'+ldeg; n:=trunc(fv); l2:=inttostr(n)+ldeg; s:=1; u:=deg2rad; end
else if trunc(fv)>0 then begin l1:='30'+lmin; n:=trunc(fv)*2; l2:=inttostr(n*30)+lmin; s:=30; u:=deg2rad/60; end
else if trunc(6*fv/2)>0 then begin l1:='10'+lmin; n:=trunc(6*fv); l2:=inttostr(n*10)+lmin; s:=10; u:=deg2rad/60; end
else if trunc(30*fv/2)>0 then begin l1:='2'+lmin; n:=trunc(30*fv); l2:=inttostr(n*2)+lmin; s:=2; u:=deg2rad/60; end
else if trunc(60*fv/2)>0 then begin l1:='1'+lmin; n:=trunc(60*fv); l2:=inttostr(n)+lmin; s:=1; u:=deg2rad/60; end
else if trunc(360*fv/2)>0 then begin l1:='10'+lsec; n:=trunc(360*fv); l2:=inttostr(n*10)+lsec; s:=10; u:=deg2rad/3600; end
else if trunc(1800*fv/2)>0 then begin l1:='2'+lsec; n:=trunc(1800*fv); l2:=inttostr(n*2)+lsec; s:=2; u:=deg2rad/3600; end
else begin l1:='1'+lsec; n:=trunc(3600*fv); l2:=inttostr(n)+lsec; s:=1; u:=deg2rad/3600; end;
if n<1 then n:=1;
xp:=cfgsc.xmin+sticksize;
y:=cfgsc.ymax-sticksize;
FPlot.PlotLine(xp,y,xp,y-sticksize,Fplot.cfgplot.Color[12],1);
FPlot.PlotText(xp,y-sticksize,1,Fplot.cfgplot.Color[12],laCenter,laBottom,'0');
for i:=1 to n do begin
  x:=xp+round(s*u*cfgsc.bxglb);
  FPlot.PlotLine(xp,y,x,y,Fplot.cfgplot.Color[12],1);
  FPlot.PlotLine(x,y,x,y-sticksize,Fplot.cfgplot.Color[12],1);
  if i=1 then FPlot.PlotText(x,y-sticksize,1,Fplot.cfgplot.Color[12],laCenter,laBottom,l1);
  xp:=x;
end;
if n>1 then FPlot.PlotText(xp,y-sticksize,1,Fplot.cfgplot.Color[12],laCenter,laBottom,l2);
end;

Procedure Tskychart.LabelPos(xx,yy,w,h,marge: integer; var x,y: integer);
begin
x:=xx;
y:=yy;
if yy<cfgsc.ymin then y:=cfgsc.ymin+marge;
if (yy+h+marge)>cfgsc.ymax then y:=cfgsc.ymax-h-marge;
if xx<cfgsc.xmin then x:=cfgsc.xmin+marge;
if (xx+w+marge)>cfgsc.xmax then x:=cfgsc.xmax-w-marge;
end;

procedure Tskychart.DrawEqGrid;
var ra1,de1,ac,dc,dra,dde:double;
    col,n,lw,lh,lx,ly:integer;
    ok,labelok:boolean;
function DrawRAline(ra,de,dd:double):boolean;
var x1,y1:double;
    n,xx,yy,xxp,yyp: integer;
    plotok:boolean;
begin
projection(ra,de,x1,y1,false,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 de:=de+dd/3;
 projection(ra,de,x1,y1,cfgsc.horizonopaque,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc.x2 then
 if (xx>-cfgsc.Xmax)and(xx<2*cfgsc.Xmax)and(yy>-cfgsc.Ymax)and(yy<2*cfgsc.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,1);
    if (xx>0)and(xx<cfgsc.Xmax)and(yy>0)and(yy<cfgsc.Ymax) then plotok:=true;
 end;
 if (cfgsc.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc.Xmax)or(yy<0)or(yy>cfgsc.Ymax)) then begin
    LabelPos(xx,yy+lh,lw,lh,5,lx,ly);
    if dra<=15*minarc then Fplot.cnv.TextOut(lx,ly,artostr3(rmod(ra+pi2,pi2)*rad2deg/15))
                      else Fplot.cnv.TextOut(lx,ly,armtostr(rmod(ra+pi2,pi2)*rad2deg/15));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc.Xmax)or(xx>2*cfgsc.Xmax)or
      (yy<-cfgsc.Ymax)or(yy>2*cfgsc.Ymax)or
      (de>(pid2-2*dd/3))or(de<(-pid2-2*dd/3));
result:=(n>1);
end;
function DrawDEline(ra,de,da:double):boolean;
var x1,y1:double;
    n,xx,yy,xxp,yyp: integer;
    plotok:boolean;
begin
projection(ra,de,x1,y1,false,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 ra:=ra+da/3;
 projection(ra,de,x1,y1,cfgsc.horizonopaque,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc.x2 then
 if (xx>-cfgsc.Xmax)and(xx<2*cfgsc.Xmax)and(yy>-cfgsc.Ymax)and(yy<2*cfgsc.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,1);
    if (xx>0)and(xx<cfgsc.Xmax)and(yy>0)and(yy<cfgsc.Ymax) then plotok:=true;
 end;
 if (cfgsc.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc.Xmax)or(yy<0)or(yy>cfgsc.Ymax)) then begin
    LabelPos(xx,yy,lw,lh,5,lx,ly);
    if dde<=5*minarc then Fplot.cnv.TextOut(lx,ly,detostr(de*rad2deg))
                     else Fplot.cnv.TextOut(lx,ly,demtostr(de*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc.Xmax)or(xx>2*cfgsc.Xmax)or
      (yy<-cfgsc.Ymax)or(yy>2*cfgsc.Ymax)or
      (ra>ra1+pi)or(ra<ra1-pi);
result:=(n>1);
end;
begin
if (cfgsc.projpole=Equat)and(not cfgsc.ShowEqGrid) then col:=Fplot.cfgplot.Color[12]
                  else col:=Fplot.cfgplot.Color[13];
Fplot.cnv.Brush.Color:=Fplot.cfgplot.Color[0];
Fplot.cnv.Brush.Style:=bsClear;
Fplot.cnv.Font.Name:=Fplot.cfgplot.FontName[2];
Fplot.cnv.Font.Color:=col;
Fplot.cnv.Font.Size:=Fplot.cfgplot.LabelSize[2];
if Fplot.cfgplot.FontBold[2] then Fplot.cnv.Font.Style:=[fsBold] else Fplot.cnv.Font.Style:=[];
if Fplot.cfgplot.FontItalic[2] then Fplot.cnv.font.style:=Fplot.cnv.font.style+[fsItalic];
lh:=Fplot.cnv.TextHeight('22h22m');
lw:=Fplot.cnv.TextWidth('22h22m');
n:=GetFieldNum(cfgsc.fov/cos(cfgsc.decentre));
dra:=Fcatalog.cfgshr.HourGridSpacing[n];
dde:=Fcatalog.cfgshr.DegreeGridSpacing[cfgsc.FieldNum];
ra1:=deg2rad*trunc(rad2deg*cfgsc.racentre/15/dra)*dra*15;
de1:=deg2rad*trunc(rad2deg*cfgsc.decentre/dde)*dde;
dra:=deg2rad*dra*15;
dde:=deg2rad*dde;
ac:=ra1; dc:=de1;
repeat
  labelok:=false;
  if cfgsc.decentre>0 then begin
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
  if cfgsc.decentre>0 then begin
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
    n,xx,yy,xxp,yyp: integer;
    plotok:boolean;
begin
proj2(-a,h,-cfgsc.acentre,cfgsc.hcentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 h:=h+dd/3;
 if cfgsc.horizonopaque and (h<-musec) then break;
 proj2(-a,h,-cfgsc.acentre,cfgsc.hcentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc.x2 then
 if (xx>-cfgsc.Xmax)and(xx<2*cfgsc.Xmax)and(yy>-cfgsc.Ymax)and(yy<2*cfgsc.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,1);
    if (xx>0)and(xx<cfgsc.Xmax)and(yy>0)and(yy<cfgsc.Ymax) then plotok:=true;
 end;
 if (cfgsc.ShowGridNum)and(plotok)and(not labelok)and((abs(h)<minarc)or(xx<0)or(xx>cfgsc.Xmax)or(yy<0)or(yy>cfgsc.Ymax)) then begin
    LabelPos(xx,yy+lh,lw,lh,5,lx,ly);
    if Fcatalog.cfgshr.AzNorth then al:=rmod(a+pi+pi2,pi2) else al:=rmod(a+pi2,pi2);
    if dda<=15*minarc then Fplot.cnv.TextOut(lx,ly,lontostr(al*rad2deg))
                      else Fplot.cnv.TextOut(lx,ly,lonmtostr(al*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc.Xmax)or(xx>2*cfgsc.Xmax)or
      (yy<-cfgsc.Ymax)or(yy>2*cfgsc.Ymax)or
      (h>(pid2-2*dd/3))or(h<(-pid2-2*dd/3));
result:=(n>1);
end;
function DrawHline(a,h,da:double):boolean;
var x1,y1:double;
    n,xx,yy,xxp,yyp,w: integer;
    plotok:boolean;
begin
if h=0 then w:=2 else w:=1;
proj2(-a,h,-cfgsc.acentre,cfgsc.hcentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 a:=a+da/3;
 proj2(-a,h,-cfgsc.acentre,cfgsc.hcentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc.x2 then
 if (xx>-cfgsc.Xmax)and(xx<2*cfgsc.Xmax)and(yy>-cfgsc.Ymax)and(yy<2*cfgsc.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,w);
    if (xx>0)and(xx<cfgsc.Xmax)and(yy>0)and(yy<cfgsc.Ymax) then plotok:=true;
 end;
 if (cfgsc.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc.Xmax)or(yy<0)or(yy>cfgsc.Ymax)) then begin
    LabelPos(xx,yy,lw,lh,5,lx,ly);
    if ddh<=5*minarc then Fplot.cnv.TextOut(lx,ly,detostr(h*rad2deg))
                     else Fplot.cnv.TextOut(lx,ly,demtostr(h*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc.Xmax)or(xx>2*cfgsc.Xmax)or
      (yy<-cfgsc.Ymax)or(yy>2*cfgsc.Ymax)or
      (a>a1+pi)or(a<a1-pi);
result:=(n>1);
end;
begin
col:=Fplot.cfgplot.Color[12];
Fplot.cnv.Brush.Color:=Fplot.cfgplot.Color[0];
Fplot.cnv.Brush.Style:=bsClear;
Fplot.cnv.Font.Name:=Fplot.cfgplot.FontName[2];
Fplot.cnv.Font.Color:=col;
Fplot.cnv.Font.Size:=Fplot.cfgplot.LabelSize[2];
if Fplot.cfgplot.FontBold[2] then Fplot.cnv.Font.Style:=[fsBold] else Fplot.cnv.Font.Style:=[];
if Fplot.cfgplot.FontItalic[2] then Fplot.cnv.font.style:=Fplot.cnv.font.style+[fsItalic];
lh:=Fplot.cnv.TextHeight('222h22m');
lw:=Fplot.cnv.TextWidth('222h22m');
n:=GetFieldNum(cfgsc.fov/cos(cfgsc.hcentre));
dda:=Fcatalog.cfgshr.DegreeGridSpacing[n];
ddh:=Fcatalog.cfgshr.DegreeGridSpacing[cfgsc.FieldNum];
a1:=deg2rad*round(rad2deg*cfgsc.acentre/dda)*dda;
h1:=deg2rad*round(rad2deg*cfgsc.hcentre/ddh)*ddh;
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
  if cfgsc.horizonopaque and (hc<-musec) then break;
  labelok:=false;
  ok:=DrawHline(ac,hc,dda);
  ok:=DrawHline(ac,hc,-dda) or ok;
  hc:=hc+ddh;
until (not ok)or(hc>pid2);
ac:=a1; hc:=h1;
repeat
  if cfgsc.horizonopaque and (hc<-musec) then break;
  labelok:=false;
  ok:=DrawHline(ac,hc,dda);
  ok:=DrawHline(ac,hc,-dda) or ok;
  hc:=hc-ddh;
until (not ok)or(hc<-pid2);
end;

{function Tskychart.DrawHorizon:boolean;
var az,h,x1,y1 : double;
    i,x,y,xp,yp,x0,y0: integer;
    first:boolean;
begin
if cfgsc.ProjPole=Altaz then begin
  if cfgsc.hcentre<-(cfgsc.fov/6) then
     Fplot.PlotLabel((cfgsc.xmax-cfgsc.xmin)div 2,(cfgsc.ymax-cfgsc.ymin)div 2,1,2,laCenter,laCenter,' Below the horizon ');
  if (cfgsc.HorizonMax>0)and(cfgsc.horizonlist<>nil) then begin
     first:=true; xp:=0;yp:=0;x0:=0;y0:=0;
     for i:=1 to 360 do begin
       h:=cfgsc.horizonlist^[i];
       az:=deg2rad*rmod(360+i-1-180,360);
       proj2(-az,h,-cfgsc.acentre,cfgsc.hcentre,x1,y1,cfgsc) ;
       WindowXY(x1,y1,x,y,cfgsc);
       if first then begin
                first:=false;
                x0:=x;
                y0:=y;
          end else Fplot.Plotline(xp,yp,x,y,Fplot.cfgplot.Color[12],1);
       xp:=x;
       yp:=y;
     end;
     Fplot.Plotline(x,y,x0,y0,Fplot.cfgplot.Color[12],1);
  end;
end;
result:=true;
end;     }

function Tskychart.DrawHorizon:boolean;
var az,h,x1,y1 : double;
    i,x,y,xp,yp,x0,y0,xh,yh,xph,yph,x0h,y0h: integer;
    first:boolean;
begin
if cfgsc.ProjPole=Altaz then begin
  if cfgsc.hcentre<-(cfgsc.fov/6) then
     Fplot.PlotLabel((cfgsc.xmax-cfgsc.xmin)div 2,(cfgsc.ymax-cfgsc.ymin)div 2,1,2,laCenter,laCenter,' Below the horizon ');
  if (cfgsc.HorizonMax>0)and(cfgsc.horizonlist<>nil) then begin
     first:=true; xp:=0;yp:=0;x0:=0;y0:=0; xph:=0;yph:=0;x0h:=0;y0h:=0;
     for i:=1 to 360 do begin
       h:=cfgsc.horizonlist^[i];
       az:=deg2rad*rmod(360+i-1-180,360);
       proj2(-az,h,-cfgsc.acentre,cfgsc.hcentre,x1,y1,cfgsc) ;
       WindowXY(x1,y1,x,y,cfgsc);
       proj2(-az,0,-cfgsc.acentre,cfgsc.hcentre,x1,y1,cfgsc) ;
       WindowXY(x1,y1,xh,yh,cfgsc);
       if first then begin
          first:=false;
          x0:=x; x0h:=xh;
          y0:=y; y0h:=yh;
       end else begin
          Fplot.PlotOutline(xp,yp,0,1,2,1,cfgsc.x2,Fplot.cfgplot.Color[19]);
          Fplot.PlotOutline(x,y,2,1,2,1,cfgsc.x2,Fplot.cfgplot.Color[19]);
          Fplot.PlotOutline(xh,yh,2,1,2,1,cfgsc.x2,Fplot.cfgplot.Color[19]);
          Fplot.PlotOutline(xph,yph,1,1,2,1,cfgsc.x2,Fplot.cfgplot.Color[19]);
          Fplot.Plotline(xph,yph,xh,yh,Fplot.cfgplot.Color[12],2);
       end;
       xp:=x; xph:=xh;
       yp:=y; yph:=yh;
     end;
     Fplot.PlotOutline(x,y,0,1,2,1,cfgsc.x2,Fplot.cfgplot.Color[19]);
     Fplot.PlotOutline(x0,y0,2,1,2,1,cfgsc.x2,Fplot.cfgplot.Color[19]);
     Fplot.PlotOutline(x0h,y0h,2,1,2,1,cfgsc.x2,Fplot.cfgplot.Color[19]);
     Fplot.PlotOutline(xh,yh,1,1,2,1,cfgsc.x2,Fplot.cfgplot.Color[19]);
     Fplot.Plotline(xh,yh,x0h,y0h,Fplot.cfgplot.Color[12],2);
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
    n,xx,yy,xxp,yyp: integer;
    plotok:boolean;
begin
proj2(a,h,cfgsc.lcentre,cfgsc.bcentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 h:=h+dd/3;
 proj2(a,h,cfgsc.lcentre,cfgsc.bcentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc.x2 then
 if (xx>-cfgsc.Xmax)and(xx<2*cfgsc.Xmax)and(yy>-cfgsc.Ymax)and(yy<2*cfgsc.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,1);
    if (xx>0)and(xx<cfgsc.Xmax)and(yy>0)and(yy<cfgsc.Ymax) then plotok:=true;
 end;
 if (cfgsc.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc.Xmax)or(yy<0)or(yy>cfgsc.Ymax)) then begin
    LabelPos(xx,yy+lh,lw,lh,5,lx,ly);
    if dda<=15*minarc then Fplot.cnv.TextOut(lx,ly,lontostr(rmod(a+pi2,pi2)*rad2deg))
                      else Fplot.cnv.TextOut(lx,ly,lonmtostr(rmod(a+pi2,pi2)*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc.Xmax)or(xx>2*cfgsc.Xmax)or
      (yy<-cfgsc.Ymax)or(yy>2*cfgsc.Ymax)or
      (h>(pid2-2*dd/3))or(h<(-pid2-2*dd/3));
result:=(n>1);
end;
function DrawHline(a,h,da:double):boolean;
var x1,y1:double;
    n,xx,yy,xxp,yyp,w: integer;
    plotok:boolean;
begin
w:=1;
proj2(a,h,cfgsc.lcentre,cfgsc.bcentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 a:=a+da/3;
 proj2(a,h,cfgsc.lcentre,cfgsc.bcentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc.x2 then
 if (xx>-cfgsc.Xmax)and(xx<2*cfgsc.Xmax)and(yy>-cfgsc.Ymax)and(yy<2*cfgsc.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,w);
    if (xx>0)and(xx<cfgsc.Xmax)and(yy>0)and(yy<cfgsc.Ymax) then plotok:=true;
 end;
 if (cfgsc.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc.Xmax)or(yy<0)or(yy>cfgsc.Ymax)) then begin
    LabelPos(xx,yy,lw,lh,5,lx,ly);
    if ddh<=5*minarc then Fplot.cnv.TextOut(lx,ly,detostr(h*rad2deg))
                     else Fplot.cnv.TextOut(lx,ly,demtostr(h*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc.Xmax)or(xx>2*cfgsc.Xmax)or
      (yy<-cfgsc.Ymax)or(yy>2*cfgsc.Ymax)or
      (a>a1+pi)or(a<a1-pi);
result:=(n>1);
end;
begin
col:=Fplot.cfgplot.Color[12];
Fplot.cnv.Brush.Color:=Fplot.cfgplot.Color[0];
Fplot.cnv.Brush.Style:=bsClear;
Fplot.cnv.Font.Name:=Fplot.cfgplot.FontName[2];
Fplot.cnv.Font.Color:=col;
Fplot.cnv.Font.Size:=Fplot.cfgplot.LabelSize[2];
if Fplot.cfgplot.FontBold[2] then Fplot.cnv.Font.Style:=[fsBold] else Fplot.cnv.Font.Style:=[];
if Fplot.cfgplot.FontItalic[2] then Fplot.cnv.font.style:=Fplot.cnv.font.style+[fsItalic];
lh:=Fplot.cnv.TextHeight('222h22m');
lw:=Fplot.cnv.TextWidth('222h22m');
n:=GetFieldNum(cfgsc.fov/cos(cfgsc.bcentre));
dda:=Fcatalog.cfgshr.DegreeGridSpacing[n];
ddh:=Fcatalog.cfgshr.DegreeGridSpacing[cfgsc.FieldNum];
a1:=deg2rad*trunc(rad2deg*cfgsc.lcentre/dda)*dda;
h1:=deg2rad*trunc(rad2deg*cfgsc.bcentre/ddh)*ddh;
dda:=deg2rad*dda;
ddh:=deg2rad*ddh;
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  if cfgsc.bcentre>0 then begin
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
  if cfgsc.bcentre>0 then begin
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
    n,xx,yy,xxp,yyp: integer;
    plotok:boolean;
begin
proj2(a,h,cfgsc.lecentre,cfgsc.becentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 h:=h+dd/3;
 proj2(a,h,cfgsc.lecentre,cfgsc.becentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc.x2 then
 if (xx>-cfgsc.Xmax)and(xx<2*cfgsc.Xmax)and(yy>-cfgsc.Ymax)and(yy<2*cfgsc.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,1);
    if (xx>0)and(xx<cfgsc.Xmax)and(yy>0)and(yy<cfgsc.Ymax) then plotok:=true;
 end;
 if (cfgsc.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc.Xmax)or(yy<0)or(yy>cfgsc.Ymax)) then begin
    LabelPos(xx,yy+lh,lw,lh,5,lx,ly);
    if dda<=15*minarc then Fplot.cnv.TextOut(lx,ly,lontostr(rmod(a+pi2,pi2)*rad2deg))
                      else Fplot.cnv.TextOut(lx,ly,lonmtostr(rmod(a+pi2,pi2)*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc.Xmax)or(xx>2*cfgsc.Xmax)or
      (yy<-cfgsc.Ymax)or(yy>2*cfgsc.Ymax)or
      (h>(pid2-2*dd/3))or(h<(-pid2-2*dd/3));
result:=(n>1);
end;
function DrawHline(a,h,da:double):boolean;
var x1,y1:double;
    n,xx,yy,xxp,yyp,w: integer;
    plotok:boolean;
begin
w:=1;
proj2(a,h,cfgsc.lecentre,cfgsc.becentre,x1,y1,cfgsc) ;
WindowXY(x1,y1,xxp,yyp,cfgsc);
n:=0;
plotok:=false;
repeat
 inc(n);
 a:=a+da/3;
 proj2(a,h,cfgsc.lecentre,cfgsc.becentre,x1,y1,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (intpower(xxp-xx,2)+intpower(yyp-yy,2))<cfgsc.x2 then
 if (xx>-cfgsc.Xmax)and(xx<2*cfgsc.Xmax)and(yy>-cfgsc.Ymax)and(yy<2*cfgsc.Ymax) then begin
    Fplot.Plotline(xxp,yyp,xx,yy,col,w);
    if (xx>0)and(xx<cfgsc.Xmax)and(yy>0)and(yy<cfgsc.Ymax) then plotok:=true;
 end;
 if (cfgsc.ShowGridNum)and(plotok)and(not labelok)and((xx<0)or(xx>cfgsc.Xmax)or(yy<0)or(yy>cfgsc.Ymax)) then begin
    LabelPos(xx,yy,lw,lh,5,lx,ly);
    if ddh<=5*minarc then Fplot.cnv.TextOut(lx,ly,detostr(h*rad2deg))
                     else Fplot.cnv.TextOut(lx,ly,demtostr(h*rad2deg));
    labelok:=true;
 end;
 xxp:=xx;
 yyp:=yy;
until (xx<-cfgsc.Xmax)or(xx>2*cfgsc.Xmax)or
      (yy<-cfgsc.Ymax)or(yy>2*cfgsc.Ymax)or
      (a>a1+pi)or(a<a1-pi);
result:=(n>1);
end;
begin
col:=Fplot.cfgplot.Color[12];
Fplot.cnv.Brush.Color:=Fplot.cfgplot.Color[0];
Fplot.cnv.Brush.Style:=bsClear;
Fplot.cnv.Font.Name:=Fplot.cfgplot.FontName[2];
Fplot.cnv.Font.Color:=col;
Fplot.cnv.Font.Size:=Fplot.cfgplot.LabelSize[2];
if Fplot.cfgplot.FontBold[2] then Fplot.cnv.Font.Style:=[fsBold] else Fplot.cnv.Font.Style:=[];
if Fplot.cfgplot.FontItalic[2] then Fplot.cnv.font.style:=Fplot.cnv.font.style+[fsItalic];
lh:=Fplot.cnv.TextHeight('222h22m');
lw:=Fplot.cnv.TextWidth('222h22m');
n:=GetFieldNum(cfgsc.fov/cos(cfgsc.becentre));
dda:=Fcatalog.cfgshr.DegreeGridSpacing[n];
ddh:=Fcatalog.cfgshr.DegreeGridSpacing[cfgsc.FieldNum];
a1:=deg2rad*trunc(rad2deg*cfgsc.lecentre/dda)*dda;
h1:=deg2rad*trunc(rad2deg*cfgsc.becentre/ddh)*ddh;
dda:=deg2rad*dda;
ddh:=deg2rad*ddh;
ac:=a1; hc:=h1;
repeat
  labelok:=false;
  if cfgsc.becentre>0 then begin
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
  if cfgsc.becentre>0 then begin
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
    xx,yy,rr:integer;
const spacing=10;
begin
 // no precession, the label position is already for the rigth equinox
 projection(ra,dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 rr:=round(r*cfgsc.BxGlb);
 x:=xx;
 y:=yy;
 if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
    case cfgsc.LabelOrientation of
    0 : begin                    // to the left
         x:=xx-rr-spacing-w;
         y:=y-(h div 2);
        end;
    1 : begin                    // to the right
         x:=xx+rr+spacing;
         y:=y-(h div 2);
        end;
    end;
 end;
end;

function Tskychart.DrawConstL:boolean;
var
  xx1,yy1,xx2,yy2,ra1,de1,ra2,de2 : Double;
  x1,y1,x2,y2,i,color : Integer;
begin
result:=false;
if not cfgsc.ShowConstl then exit;
color := Fplot.cfgplot.Color[16];
for i:=0 to Fcatalog.cfgshr.ConstLnum-1 do begin
  ra1:=Fcatalog.cfgshr.ConstL[i].ra1;
  de1:=Fcatalog.cfgshr.ConstL[i].de1;
  ra2:=Fcatalog.cfgshr.ConstL[i].ra2;
  de2:=Fcatalog.cfgshr.ConstL[i].de2;
  precession(jd2000,cfgsc.JDChart,ra1,de1);
  projection(ra1,de1,xx1,yy1,true,cfgsc) ;
  precession(jd2000,cfgsc.JDChart,ra2,de2);
  projection(ra2,de2,xx2,yy2,true,cfgsc) ;
  if (xx1<199)and(xx2<199) then begin
     WindowXY(xx1,yy1,x1,y1,cfgsc);
     WindowXY(xx2,yy2,x2,y2,cfgsc);
     if (intpower(x2-x1,2)+intpower(y2-y1,2))<cfgsc.x2 then
        FPlot.PlotLine(x1,y1,x2,y2,color,1);
  end;
end;
result:=true;
end;

function Tskychart.DrawConstB:boolean;
var
  dm,xx,yy,ra,de : Double;
  x1,y1,x2,y2,i,color : Integer;
begin
result:=false;
if not cfgsc.ShowConstB then exit;
dm:=maxvalue([cfgsc.fov,0.1]);
color := Fplot.cfgplot.Color[17];
x1:=0; y1:=0;
for i:=0 to Fcatalog.cfgshr.ConstBnum-1 do begin
  ra:=Fcatalog.cfgshr.ConstB[i].ra;
  de:=Fcatalog.cfgshr.ConstB[i].de;
  if Fcatalog.cfgshr.ConstB[i].newconst then x1:=maxint;
  precession(jd2000,cfgsc.JDChart,ra,de);
  projection(ra,de,xx,yy,true,cfgsc) ;
  if (xx<199)and(xx<199) then begin
    WindowXY(xx,yy,x2,y2,cfgsc);
    if (intpower(x2-x1,2)+intpower(y2-y1,2))<cfgsc.x2 then
    if (x1<maxint)and(abs(xx)<dm)and(abs(yy)<dm) then begin
       FPlot.PlotLine(x1,y1,x2,y2,color,1);
    end;
    x1:=x2;
    y1:=y2;
  end else x1:=maxint;
end;
result:=true;
end;

function Tskychart.DrawEcliptic:boolean;
var l,b,e,ar,de,xx,yy : double;
    i,x1,y1,x2,y2,color : integer;
    first : boolean;
begin
result:=false;
if not cfgsc.ShowEcliptic then exit;
e:=ecliptic(cfgsc.JDChart);
b:=0;
first:=true;
color := Fplot.cfgplot.Color[14];
x1:=0; y1:=0;
for i:=0 to 360 do begin
  l:=deg2rad*i;
  ecl2eq(l,b,e,ar,de);
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
    i,x1,y1,x2,y2,color : integer;
    first : boolean;
begin
result:=false;
if not cfgsc.ShowGalactic then exit;
b:=0;
first:=true;
color := Fplot.cfgplot.Color[15];
x1:=0; y1:=0;
for i:=0 to 360 do begin
  l:=deg2rad*i;
  gal2eq(l,b,ar,de,cfgsc);
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


end.