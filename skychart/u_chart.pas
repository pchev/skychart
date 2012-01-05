unit u_chart;

interface

uses u_constant, Math,
     SysUtils, Classes, Types, QControls, QExtCtrls, QGraphics;

type

  TSchart = class(TComponent)
  private
    { Private declarations }
    Fconf : conf_chart;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
  published
    { Published declarations }
     function Init(canvas:Tcanvas; w,h : integer) : boolean;
     Procedure PlotStar(xx,yy: integer; ma,b_v : Double;labelstr : string; var canvas : Tcanvas);
     property conf: conf_chart read Fconf write Fconf;
  end;

Implementation

constructor TSchart.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 Fconf.invisible:=false;
 Fconf.color:=dfColor;
 Fconf.stardyn:=65;
 Fconf.starsize:=13;
 Fconf.drawpen:=1;
 Fconf.drawsize:=1;
 Fconf.min_ma:=6;
 Fconf.onprinter:=false;
end;

destructor TSchart.Destroy;
begin
 inherited destroy;
end;

function TSchart.Init(canvas:Tcanvas; w,h : integer) : boolean;
begin
Fconf.Width:=w;
Fconf.Height:=h;
with canvas do begin
 Brush.Color:=clBlack;
 Pen.Color:=clBlack;
 Rectangle(0,0,Fconf.Width,Fconf.Height);
end;
end;

Procedure TSchart.PlotStar(xx,yy: integer; ma,b_v : Double;labelstr : string; var canvas : Tcanvas);
var
  ds,ds2,Icol : Integer;
  co : Tcolor;
  labeltxt,sma : string;
  DestR,SrcR :Trect;
  ico,isz : integer;
begin
with canvas do begin
 if not Fconf.Invisible then begin
{   if starbmp and (not onprinter) then begin    ////// bitmap stars
   Icol:=Round(b_v*10);
   case Icol of
         -999..-3: ico := 0;
           -2..-1: ico := 1;
            0..2 : ico := 2;
            3..5 : ico := 3;
            6..8 : ico := 4;
            9..13: ico := 5;
          14..900: ico := 6;
          else ico:=2;
   end;
   ds := round(maxvalue([1,(starsize*(min_ma-ma*stardyn/80)/min_ma)]));
   case ds of
       1..2: isz:=10;
       3: isz:=9;
       4: isz:=8;
       5: isz:=7;
       6: isz:=6;
       7: isz:=5;
       8: isz:=4;
       9: isz:=3;
      10: isz:=2;
      11: isz:=1;
     else isz:=0;
   end;
   SrcR:=Rect(isz*starshapesize,ico*starshapesize,(isz+1)*starshapesize,(ico+1)*starshapesize);
   DestR:=Rect(xx-starshapew,yy-starshapew,xx+starshapew+1,yy+starshapew+1);
   copymode:=cmSrcPaint;
   CopyRect(DestR,form1.starshape.canvas,SrcR);
   end else} begin            /////////  circle stars
   Pen.Color := Fconf.Color[0];
   Pen.Width := Fconf.DrawPen;
   Pen.Mode := pmCopy;
   Icol:=Round(b_v*10);
   case Icol of
         -999..-3: co := Fconf.Color[1];
           -2..-1: co := Fconf.Color[2];
            0..2 : co := Fconf.Color[3];
            3..5 : co := Fconf.Color[4];
            6..8 : co := Fconf.Color[5];
            9..13: co := Fconf.Color[6];
          14..900: co := Fconf.Color[7];
          else co:=Fconf.Color[11];
     end;
     ds := round(maxvalue([3,(Fconf.starsize*(Fconf.min_ma-ma*Fconf.stardyn/80)/Fconf.min_ma)])*Fconf.drawsize);
     ds2:= round(ds/2);
     Brush.Color := co ;
     case ds of
       1..2: Ellipse(xx,yy,xx+ds,yy+ds);
       3: Ellipse(xx-1,yy-1,xx+2,yy+2);
       4: Ellipse(xx-2,yy-2,xx+2,yy+2);
       5: Ellipse(xx-2,yy-2,xx+3,yy+3);
       6: Ellipse(xx-3,yy-3,xx+3,yy+3);
       7: Ellipse(xx-3,yy-3,xx+4,yy+4);
       else Ellipse(xx-ds2,yy-ds2,xx+ds2,yy+ds2);
     end;
     end;
     end;
{if LabelOn and LabelObj[5] and ((LabelDMa[1]=0) or (ma<(Min_Ma-LabelDMa[1]))) then begin
   labeltxt:='';
   if LabelNom then labeltxt:=labeltxt+' '+trim(nom);
   if LabelMag then begin
      str(ma:5:2,sma);
      labeltxt:=labeltxt+' '+trim(sma);
      end;
   if LabelPos then labeltxt:=labeltxt+' '+trim(artostr(ar))+' '+trim(detostr(de));
   labeltxt:=trim(labeltxt);
   DrawLabelXY(xx,yy,Labeldir,Labelsize[5],LabelColor[5],labeltxt,greeklabel,out);
end;   }
end;
end;

end.
