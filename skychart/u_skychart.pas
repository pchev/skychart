unit u_skychart;

interface

uses u_chart, u_catalog, QGraphics, u_constant,
  SysUtils, Classes, QControls, QExtCtrls;

type

Tskychart = class (TComponent)
   private
    Fconf : conf_skychart;
    Fchart: TSchart;
    Fcatalog : Tcatalog;
   public
    constructor Create(AOwner:Tcomponent); override;
    destructor  Destroy; override;
   published
    property conf: conf_skychart read Fconf write Fconf;
    property chart: TSchart read Fchart;
    property catalog: Tcatalog read Fcatalog write Fcatalog;
    function Refresh(canvas:Tcanvas) : boolean;
    function InitChart : boolean;
    function DrawStars(canvas:Tcanvas):boolean;
end;


implementation

uses Catalogues, u_projection;

constructor Tskychart.Create(AOwner:Tcomponent);
begin
 inherited Create(AOwner);
 Fchart:=TSChart.Create(AOwner);
 Fconf.fov:=0;
end;

destructor Tskychart.Destroy;
begin
 Fchart.free;
 inherited destroy;
end;

function Tskychart.Refresh(canvas:Tcanvas):boolean;
begin
  InitChart;
  DrawStars(canvas);
  result:=true;
end;

function Tskychart.InitChart:boolean;
begin
Fconf.xmin:=0;
Fconf.ymin:=0;
Fconf.xmax:=Fchart.conf.width;
Fconf.ymax:=Fchart.conf.height;
ScaleWindow(Fconf);
catalog.InitCat(Fconf);
result:=true;
end;

function Tskychart.DrawStars(canvas:Tcanvas):boolean;
var rec:GcatRec;
  x1,y1: Double;
  xx,yy: integer;
begin
Fcatalog.OpenStar;
while Fcatalog.readstar(rec) do begin
 projection(rec.ra,rec.dec,x1,y1,true,Fconf) ;
 WindowXY(x1,y1,xx,yy,Fconf);
 if (xx>Fconf.Xmin) and (xx<Fconf.Xmax) and (yy>Fconf.Ymin) and (yy<Fconf.Ymax) then begin
    Fchart.PlotStar(xx,yy,rec.star.magv,rec.star.b_v,rec.star.id,canvas);
 end;
end;
Fcatalog.CloseStar;
result:=true;
end;

end.
