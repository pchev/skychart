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

uses cu_plot, cu_catalog, u_constant,
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
   public
    cfgsc : conf_skychart;
    constructor Create(AOwner:Tcomponent); override;
    destructor  Destroy; override;
   published
    property plot: TSplot read Fplot;
    property catalog: Tcatalog read Fcatalog write Fcatalog;
    function Refresh : boolean;
    function InitCatalog : boolean;
    function InitChart : boolean;
    function DrawStars :boolean;
    function DrawVarStars :boolean;
    function DrawDblStars :boolean;
    function DrawNebulae :boolean;
    procedure GetCoord(x,y: integer; var ra,dec:double);
    procedure MoveChart(ns,ew:integer; movefactor:double);
    procedure MovetoXY(X,Y : integer);
    procedure MovetoRaDec(ra,dec:double);
    procedure Zoom(zoomfactor:double);
    procedure SetFOV(f:double);
    function NormRA(ra : double):double;
    function FindatRaDec(ra,dec,dx: double; var desc,longdesc :string):boolean;
end;


implementation

uses libcatalog, u_projection, u_util;

constructor Tskychart.Create(AOwner:Tcomponent);
begin
 inherited Create(AOwner);
 // set safe value
 cfgsc.racentre:=0;
 cfgsc.decentre:=0;
 cfgsc.fov:=1;
 cfgsc.theta:=0;
 cfgsc.projtype:='A';
 cfgsc.ProjPole:=0;
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
 Fplot:=TSplot.Create(AOwner);
end;

destructor Tskychart.Destroy;
begin
 Fplot.free;
 inherited destroy;
end;

function Tskychart.Refresh :boolean;
begin
try
  chdir(appdir);
  InitChart;
  InitCatalog;
  catalog.OpenCat(cfgsc);
  DrawNebulae;
  DrawStars;
  DrawDblStars;
  DrawVarStars;
  result:=true;
finally
  catalog.CloseCat;
end;
end;

function Tskychart.InitCatalog:boolean;
var w,h : double;
    i : integer;
  procedure InitStarC(cat:integer;defaultmag:double);
  { determine if the star catalog is active at this scale }
  var mag:double;
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
w := cfgsc.fov;
h := cfgsc.fov/cfgsc.WindowRatio;
w := rad2deg*maxvalue([w,h]);
if w>360 then w:=360;
{ find the current field number}
cfgsc.FieldNum:=10;
for i:=0 to 10 do if Fcatalog.cfgshr.FieldNum[i]>=w then begin
       cfgsc.FieldNum:=i;
       break;
    end;
if Fcatalog.cfgshr.AutoStarFilter then Fcatalog.cfgcat.StarMagMax:=round(10*(Fcatalog.cfgshr.AutoStarFilterMag+2.4*log10(intpower(pid2/cfgsc.fov,2))))/10
   else Fcatalog.cfgcat.StarMagMax:=Fcatalog.cfgshr.StarMagFilter[cfgsc.FieldNum];
Fcatalog.cfgcat.NebMagMax:=Fcatalog.cfgshr.NebMagFilter[cfgsc.FieldNum];
Fcatalog.cfgcat.NebSizeMin:=Fcatalog.cfgshr.NebSizeFilter[cfgsc.FieldNum];
Fplot.cfgchart.min_ma:=1;
{ activate the star catalog in increasing magnitude order}
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
result:=true;
end;

function Tskychart.InitChart:boolean;
begin
cfgsc.xmin:=0;
cfgsc.ymin:=0;
cfgsc.xmax:=Fplot.cfgchart.width;
cfgsc.ymax:=Fplot.cfgchart.height;
ScaleWindow(cfgsc);
result:=true;
end;

function Tskychart.DrawStars :boolean;
var rec:GcatRec;
  x1,y1: Double;
  xx,yy: integer;
begin
fillchar(rec,sizeof(rec),0);
if Fcatalog.OpenStar then
 while Fcatalog.readstar(rec) do begin
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
    Fplot.PlotStar(xx,yy,rec.star.magv,rec.star.b_v);
 end;
end;
Fcatalog.CloseStar;
result:=true;
end;

function Tskychart.DrawVarStars :boolean;
var rec:GcatRec;
  x1,y1: Double;
  xx,yy: integer;
begin
fillchar(rec,sizeof(rec),0);
if Fcatalog.OpenVarStar then
 while Fcatalog.readvarstar(rec) do begin
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
    Fplot.PlotVarStar(xx,yy,rec.variable.magmax,rec.variable.magmin);
 end;
end;
Fcatalog.CloseVarStar;
result:=true;
end;

function Tskychart.DrawDblStars :boolean;
var rec:GcatRec;
  x1,y1,rot: Double;
  xx,yy,xxn,yyn: integer;
begin
fillchar(rec,sizeof(rec),0);
if Fcatalog.OpenDblStar then
 while Fcatalog.readdblstar(rec) do begin
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
    projection(rec.ra,rec.dec+1,x1,y1,false,cfgsc) ;
    windowxy(x1,y1,xxn,yyn,cfgsc);
    if rec.double.pa=-999 then rec.double.pa:=0;
    rec.double.pa:=rec.double.pa*cfgsc.FlipX;
    if cfgsc.FlipY<0 then rec.double.pa:=180-rec.double.pa;
    rot:=arctan2((xx-xxn),(yy-yyn));
    if cfgsc.FlipY<0 then rot:=rot-pi;
    rec.double.pa:=DegToRad(rec.double.pa)+rot;
    Fplot.PlotDblStar(xx,yy,rec.double.mag1,rec.double.sep,rec.double.pa,0);
 end;
end;
Fcatalog.CloseDblStar;
result:=true;
end;

function Tskychart.DrawNebulae :boolean;
var rec:GcatRec;
  x1,y1,rot: Double;
  xx,yy,xxn,yyn,nebunit: integer;
begin
fillchar(rec,sizeof(rec),0);
if Fcatalog.OpenNeb then
 while Fcatalog.readneb(rec) do begin
 projection(rec.ra,rec.dec,x1,y1,true,cfgsc) ;
 WindowXY(x1,y1,xx,yy,cfgsc);
 if (xx>cfgsc.Xmin) and (xx<cfgsc.Xmax) and (yy>cfgsc.Ymin) and (yy<cfgsc.Ymax) then begin
  if rec.neb.valid[vnNebunit] then nebunit:=rec.neb.nebunit
                              else nebunit:=rec.options.Units;
  if rec.neb.nebtype=1 then begin
      projection(rec.ra,rec.dec+1,x1,y1,false,cfgsc) ;
      windowxy(x1,y1,xxn,yyn,cfgsc);
      if rec.neb.pa=-999 then rec.neb.pa:=90;
      rec.neb.pa:=rec.neb.pa*cfgsc.FlipX;
      if cfgsc.FlipY<0 then rec.neb.pa:=180-rec.neb.pa;
      rot:=arctan2((xx-xxn),(yy-yyn));
      if cfgsc.FlipY<0 then rot:=rot-pi;
      rec.neb.pa:=DegToRad(rec.neb.pa)+rot;
      Fplot.PlotGalaxie(xx,yy,rec.neb.dim1,rec.neb.dim2,rec.neb.pa,0,100,100,rec.neb.mag,rec.neb.sbr,abs(cfgsc.BxGlb)*deg2rad/nebunit);
   end else
      Fplot.PlotNebula(xx,yy,rec.neb.dim1,rec.neb.mag,rec.neb.sbr,abs(cfgsc.BxGlb)*deg2rad/nebunit,rec.neb.nebtype);
 end;
end;
Fcatalog.CloseDblStar;
result:=true;
end;

procedure Tskychart.GetCoord(x,y: integer; var ra,dec:double);
begin
getadxy(x,y,ra,dec,cfgsc);
end;

procedure Tskychart.MoveChart(ns,ew:integer; movefactor:double);
begin
 if cfgsc.Projpole=1 then begin
    cfgsc.acentre:=rmod(cfgsc.acentre+ew*cfgsc.fov/movefactor/cos(cfgsc.hcentre)+pi2,pi2);
    cfgsc.hcentre:=cfgsc.hcentre+ns*cfgsc.fov/movefactor/cfgsc.windowratio;
    if cfgsc.hcentre>pid2 then cfgsc.hcentre:=pi-cfgsc.hcentre;
    Hz2Eq(cfgsc.acentre,cfgsc.hcentre,cfgsc.racentre,cfgsc.decentre,cfgsc);
    cfgsc.racentre:=cfgsc.CurrentST-cfgsc.racentre;
 end
 else begin
    cfgsc.racentre:=rmod(cfgsc.racentre+ew*cfgsc.fov/movefactor/cos(cfgsc.decentre)+pi2,pi2);
    cfgsc.decentre:=cfgsc.decentre+ns*cfgsc.fov/movefactor/cfgsc.windowratio;
    if cfgsc.decentre>pid2 then cfgsc.decentre:=pi-cfgsc.decentre;
end;
end;

procedure Tskychart.MovetoXY(X,Y : integer);
begin
   GetADxy(X,Y,cfgsc.racentre,cfgsc.decentre,cfgsc);
   cfgsc.racentre:=rmod(cfgsc.racentre+pi2,pi2);
   if cfgsc.projpole=1 then begin
      precession(jd2000,cfgsc.CurrentJD,cfgsc.racentre,cfgsc.decentre);
   end;
end;

procedure Tskychart.MovetoRaDec(ra,dec:double);
begin
   cfgsc.racentre:=rmod(ra+pi2,pi2);
   cfgsc.decentre:=dec;
   if cfgsc.projpole=1 then begin
      precession(jd2000,cfgsc.CurrentJD,cfgsc.racentre,cfgsc.decentre);
   end;
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

Function Tskychart.NormRA(ra : double):double;
begin
result:=rmod(ra+pi2,pi2);
//if (ar2<ar1)and(ra<=arm) then NormRA:=ra+pi2
//else NormRA:=ra;
end;

function Tskychart.FindatRaDec(ra,dec,dx: double; var desc, longdesc :string):boolean;
var x1,x2,y1,y2:double;
    i : integer;
    rec: Gcatrec;
    txt: string;
const b=' ';
      b5='     ';
      dp = ':';
begin
x1 := NormRA(ra-dx/cos(dec));
x2 := NormRA(ra+dx/cos(dec));
y1 := maxvalue([-pid2,dec-dx]);
y2 := minvalue([pid2,dec+dx]);
result:=catalog.Findobj(x1,y1,x2,y2,false,cfgsc,rec);
if result then begin
 desc:=''; longdesc:='';
 desc:= ARpToStr(rmod(rad2deg*rec.ra/15+24,24))+b+DEpToStr(rad2deg*rec.dec);
 case rec.options.rectype of
 rtStar: begin   // stars
         if rec.star.valid[vsId] then txt:=rec.star.id else txt:='';
         if trim(txt)='' then catalog.GetAltName(rec,txt);
         txt:=rec.options.ShortName+b+txt;
         Desc:=Desc+'   * '+txt;
         if rec.star.magv<90 then str(rec.star.magv:5:2,txt) else txt:=b5;
         Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsMagv])+dp+txt;
         if rec.star.valid[vsB_v] then begin
            if (rec.star.b_v<90) then str(rec.star.b_v:5:2,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsB_v])+dp+txt;
         end;
         if rec.star.valid[vsMagb] then begin
            if (rec.star.magb<90) then str(rec.star.magb:5:2,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsMagb])+dp+txt;
         end;
         if rec.star.valid[vsMagr] then begin
            if (rec.star.magr<90) then str(rec.star.magr:5:2,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsMagr])+dp+txt;
         end;
         if rec.star.valid[vsSp] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsSp])+dp+rec.star.sp;
         if rec.star.valid[vsPmra] then begin
            str(rad2deg*3600*rec.star.pmra:6:3,txt);
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsPmra])+dp+txt;
         end;
         if rec.star.valid[vsPmdec] then begin
            str(rad2deg*3600*rec.star.pmdec:6:3,txt);
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsPmdec])+dp+txt;
         end;
         if rec.star.valid[vsEpoch] then begin
            str(rec.star.epoch:8:2,txt);
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsEpoch])+dp+txt;
         end;
         if rec.star.valid[vsPx] then begin
            str(rec.star.px:6:4,txt);
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsPx])+dp+txt;
            if rec.star.px>0 then begin
               str(3.2616/rec.star.px:5:1,txt);
               Desc:=Desc+' Dist:'+txt+b+'ly';
            end;
         end;
         if rec.star.valid[vsComment] then
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vsComment])+dp+b+rec.star.comment;
         end;
 rtVar : begin   // variables stars
         if rec.variable.valid[vvId] then txt:=rec.variable.id else txt:='';
         if trim(txt)='' then catalog.GetAltName(rec,txt);
         txt:=rec.options.ShortName+b+txt;
         Desc:=Desc+'  V* '+txt;
         if rec.variable.valid[vvVartype] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vvVartype])+dp+rec.variable.vartype;
         if rec.variable.valid[vvMagcode] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vvMagcode])+dp+rec.variable.magcode;
         if rec.variable.valid[vvMagmax] then begin
            if (rec.variable.magmax<90) then str(rec.variable.magmax:5:2,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vvMagmax])+dp+txt;
         end;
         if rec.variable.valid[vvMagmin] then begin
            if (rec.variable.magmin<90) then str(rec.variable.magmin:5:2,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vvMagmin])+dp+txt;
         end;
         if rec.variable.valid[vvPeriod] then begin
            str(rec.variable.period:16:10,txt);
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vvPeriod])+dp+txt;
         end;
         if rec.variable.valid[vvMaxepoch] then begin
            str(rec.variable.Maxepoch:16:10,txt);
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vvMaxepoch])+dp+txt;
         end;
         if rec.variable.valid[vvRisetime] then begin
            str(rec.variable.risetime:5:2,txt);
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vvRisetime])+dp+txt;
         end;
         if rec.variable.valid[vvSp] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vvSp])+dp+rec.variable.sp;
         if rec.variable.valid[vvComment] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vvComment])+dp+rec.variable.comment;
         end;
 rtDbl : begin   // doubles stars
         if rec.double.valid[vdId] then txt:=rec.double.id else txt:='';
         if trim(txt)='' then catalog.GetAltName(rec,txt);
         txt:=rec.options.ShortName+b+txt;
         Desc:=Desc+'  D* '+txt;
         if rec.double.valid[vdCompname] then Desc:=Desc+b+rec.double.compname;
         if rec.double.valid[vdMag1] then begin
            if (rec.double.mag1<90) then str(rec.double.mag1:5:2,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vdMag1])+dp+txt;
         end;
         if rec.double.valid[vdMag2] then begin
            if (rec.double.mag2<90) then str(rec.double.mag2:5:2,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vdMag2])+dp+txt;
         end;
         if rec.double.valid[vdSep] then begin
            if (rec.double.sep>0) then str(rec.double.sep:5:1,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vdSep])+dp+txt;
         end;
         if rec.double.valid[vdPa] then begin
            if (rec.double.pa>0) then str(round(rec.double.pa):3,txt) else txt:='   ';
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vdPa])+dp+txt;
         end;
         if rec.double.valid[vdEpoch] then begin
            str(rec.double.epoch:4:2,txt);
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vdEpoch])+dp+txt;
         end;
         if rec.double.valid[vdSp1] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vdSp1])+dp+' 1 '+rec.double.sp1;
         if rec.double.valid[vdSp2] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vdSp2])+dp+' 2 '+rec.double.sp2;
         if rec.double.valid[vdComment] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vdComment])+dp+rec.double.comment;
         end;
 rtNeb : begin   // nebulae
         if rec.neb.valid[vnId] then txt:=rec.neb.id else txt:='';
         if trim(txt)='' then catalog.GetAltName(rec,txt);
         if rec.double.valid[vnNebtype] then i:=rec.neb.nebtype
                                        else i:=rec.options.ObjType;
         Desc:=Desc+' '+nebtype[i+2]+' '+txt;
         if rec.neb.valid[vnMag] then begin
            if (rec.neb.mag<90) then str(rec.neb.mag:5:2,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vnMag])+dp+txt;
         end;
         if rec.neb.valid[vnSbr] then begin
            if (rec.neb.sbr<90) then str(rec.neb.sbr:5:2,txt) else txt:=b5;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vnSbr])+dp+txt;
         end;
         if rec.options.LogSize=0 then begin
            if rec.neb.valid[vnDim1] then str(rec.neb.dim1:5:1,txt)
                                     else str(rec.options.Size:5,txt);
            Desc:=Desc+b+'Dim'+dp+txt;
            if rec.neb.valid[vnDim2] and (rec.neb.dim2>0) then str(rec.neb.dim2:5:1,txt);
            Desc:=Desc+' x'+txt+b;
            if rec.neb.valid[vnNebunit] then i:=rec.neb.nebunit
                                        else i:=rec.options.Units;
            case i of
            1    : Desc:=Desc+ldeg;
            60   : Desc:=Desc+lmin;
            3600 : Desc:=Desc+lsec;
            end;
         end else begin
            if rec.neb.valid[vnDim1] then str(rec.neb.dim1:5:1,txt)
                                     else txt:=b5;
            Desc:=Desc+' Flux:'+txt+b;
         end;
         if rec.neb.valid[vnPa] then begin
            if (rec.neb.pa>0) then str(rec.neb.pa:3:0,txt) else txt:='   ';
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vnPa])+dp+txt;
         end;
         if rec.neb.valid[vnRv] then begin
            str(rec.neb.rv:6,txt) ;
            Desc:=Desc+b+trim(rec.options.flabel[lOffset+vnRv])+dp+txt;
         end;
         if rec.neb.valid[vnMorph] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vnMorph])+dp+rec.neb.morph;
         if rec.neb.valid[vnComment] then Desc:=Desc+b+trim(rec.options.flabel[lOffset+vnComment])+dp+rec.neb.comment;
         end;
 end;
 for i:=1 to 10 do begin
   if rec.vstr[i] then Desc:=Desc+b+trim(rec.options.flabel[15+i])+dp+rec.str[i];
 end;
 for i:=1 to 10 do begin
   if rec.vnum[i] then Desc:=Desc+b+trim(rec.options.flabel[25+i])+dp+formatfloat('0.0####',rec.num[i]);
 end;
end;
end;

end.

