unit u_catalog;

interface

uses u_constant, catalogues, u_util, u_projection,
     SysUtils, Classes;

type

  Tcatalog = class(TComponent)
  private
    { Private declarations }
    Fconf : conf_catalog;
    LockCat : boolean;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
  published
    { Published declarations }
     property conf: conf_catalog read Fconf write Fconf;
     function InitCat(c: conf_skychart):boolean;
     function OpenStar:boolean;
     function ReadStar(var rec:GcatRec):boolean;
     function CloseStar:boolean;
  end;

Implementation

constructor Tcatalog.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 Fconf.caton:=true;
 Fconf.StarLimit:=true;
 Fconf.StarmagMax:=12;
 Fconf.bscpath:=slash(appdir)+'cat'+PathDelim+'bsc5';
end;

destructor Tcatalog.Destroy;
begin
 inherited destroy;
end;

Function Tcatalog.InitCat(c: conf_skychart):boolean;
begin
  InitCatWin(c.axglb,c.ayglb,c.bxglb/rad2deg,c.byglb/rad2deg,c.sintheta,c.costheta,rad2deg*c.racentre/15,rad2deg*c.decentre,rad2deg*c.acentre,rad2deg*c.hcentre,c.CurrentJD,c.CurrentST,c.ObsLatitude,c.ProjPole,c.xshift,c.yshift,c.xmin,c.xmax,c.ymin,c.ymax,c.projtype,northpoleinmap(c),southpoleinmap(c));
end;

function Tcatalog.OpenStar:boolean;
begin
if Fconf.caton then begin // BSC
   SetBscPath(Fconf.bscpath);
   OpenBSCwin(result);
end;
end;

function Tcatalog.CloseStar:boolean;
begin
 CloseBSC;
 result:=true;
end;

function Tcatalog.ReadStar(var rec:GcatRec):boolean;
var lin : BSCrec;
     ok : boolean;
begin
ok:=false;
if Fconf.caton then begin // BSC
  ReadBSC(lin,ok);
  if ok then begin
   rec.star.magv:=lin.mv/100;
   if Fconf.StarLimit and (rec.star.magv>Fconf.StarMagMax) then begin
     NextBSC(ok);
     if ok then ReadBSC(lin,ok);
   end;
   rec.ra:=deg2rad*lin.ar/100000;
   rec.dec:=deg2rad*lin.de/100000;
   rec.star.b_v:=lin.b_v/100;
   rec.star.pmra:=lin.pmar/1000/15/3600;
   rec.star.pmdec:=lin.pmde/1000/3600;
   rec.star.comment:=lin.cons+lin.bayer;
   rec.star.id:=inttostr(lin.hd);
  end;
end;
result:=ok;
end;

end.
