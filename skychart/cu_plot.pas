unit cu_plot;
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
 Bitmap skychart drawing component
}

interface

uses u_constant, u_util,
     Math, SysUtils, Classes, Types,
{$ifdef linux}
   QControls, QExtCtrls, QGraphics;
{$endif}
{$ifdef mswindows}
   Controls, ExtCtrls, Graphics;
{$endif}

type

  TSplot = class(TComponent)
  private
    { Private declarations }
     Procedure PlotStar0(xx,yy: integer; ma,b_v : Double);
     Procedure PlotStar1(xx,yy: integer; ma,b_v : Double);
     Procedure PlotNebula0(xx,yy: integer; dim,ma,sbr,pixscale : Double ; typ : Integer);
     Procedure PlotNebula1(xx,yy: integer; dim,ma,sbr,pixscale : Double ; typ : Integer);
     procedure PlotPlanet1(xx,yy,ipla:integer; pixscale,diam:double);
     procedure PlotSatRing1(xx,yy:integer; pixscale,pa,rot,r1,r2,diam,be : double);
  protected
    { Protected declarations }
  public
    { Public declarations }
    cfgplot : conf_plot;
    cfgchart: conf_chart;
    cnv : Tcanvas;
    starshape: Tbitmap;
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
  published
    { Published declarations }
     function Init(w,h : integer) : boolean;
     Procedure PlotStar(xx,yy: integer; ma,b_v : Double);
     Procedure PlotVarStar(xx,yy: integer; max,min : Double);
     Procedure PlotDblStar(xx,yy: integer; ma,sep,pa,b_v : Double);
     Procedure PlotGalaxie(xx,yy: integer; r1,r2,pa,rnuc,b_vt,b_ve,ma,sbr,pixscale : double);
     Procedure PlotNebula(xx,yy: integer; dim,ma,sbr,pixscale : Double ; typ : Integer);
     Procedure PlotLine(x1,y1,x2,y2,color,width: integer);
     procedure PlotPlanet(xx,yy,ipla:integer; pixscale,jdt,diam,magn,phase,illum,pa,rot,r1,r2,be,dist:double);
     procedure PlotSatel(xx,yy,ipla:integer; pixscale,ma,diam : double; hidesat, showhide : boolean);
  end;

Implementation

constructor TSplot.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 // set safe value
 cfgchart.width:=100;
 cfgchart.height:=100;
 cfgchart.min_ma:=6;
 cfgchart.onprinter:=false;
 cfgchart.drawpen:=1;
end;

destructor TSplot.Destroy;
begin
 inherited destroy;
end;

function TSplot.Init(w,h : integer) : boolean;
begin
cfgchart.Width:=w;
cfgchart.Height:=h;
with cnv do begin
  Brush.Color:=cfgplot.Color[0];
  Pen.Color:=cfgplot.Color[0];
 Rectangle(0,0,cfgchart.Width,cfgchart.Height);
end;
result:=true;
end;

Procedure TSplot.PlotStar1(xx,yy: integer; ma,b_v : Double);
var
  ds,Icol : Integer;
  ico,isz : integer;
  DestR,SrcR :Trect;
begin
with cnv do begin
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
   if ma<-5 then ma:=-5;
   ds := round(maxvalue([1,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma)]));
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
   SrcR:=Rect(isz*cfgplot.starshapesize,ico*cfgplot.starshapesize,(isz+1)*cfgplot.starshapesize,(ico+1)*cfgplot.starshapesize);
   DestR:=Rect(xx-cfgplot.starshapew,yy-cfgplot.starshapew,xx+cfgplot.starshapew+1,yy+cfgplot.starshapew+1);
   copymode:=cmSrcPaint;
   CopyRect(DestR,starshape.canvas,SrcR);
end;
end;

Procedure TSplot.PlotStar0(xx,yy: integer; ma,b_v : Double);
var
  ds,ds2,Icol : Integer;
  co : Tcolor;
begin
with cnv do begin
   Pen.Color := cfgplot.Color[0];
   Pen.Width := cfgchart.DrawPen;
   Pen.Mode := pmCopy;
   Icol:=Round(b_v*10);
   case Icol of
         -999..-3: co := cfgplot.Color[1];
           -2..-1: co := cfgplot.Color[2];
            0..2 : co := cfgplot.Color[3];
            3..5 : co := cfgplot.Color[4];
            6..8 : co := cfgplot.Color[5];
            9..13: co := cfgplot.Color[6];
          14..900: co := cfgplot.Color[7];
          else co:=cfgplot.Color[11];
     end;
     if ma<-5 then ma:=-5;
     ds := round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen);
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

Procedure TSplot.PlotStar(xx,yy: integer; ma,b_v : Double);
begin
 if not cfgplot.Invisible then
   if cfgchart.onprinter then
      case cfgplot.starplot of
      0 : PlotStar0(xx,yy,ma,b_v);
      1 : PlotStar0(xx,yy,ma,b_v);
      end
   else
      case cfgplot.starplot of
      0 : PlotStar0(xx,yy,ma,b_v);
      1 : PlotStar1(xx,yy,ma,b_v);
      end;
end;

Procedure TSplot.PlotVarStar(xx,yy: integer; max,min : Double);
var
  ds,ds2,dsm : Integer;
begin
if not cfgplot.Invisible then begin
  with cnv do begin
     ds := round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-max*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen)-cfgchart.drawpen;
     ds2:= trunc(ds/2)+cfgchart.drawpen;
     Brush.Color := cfgplot.Color[0];
     Pen.Color := cfgplot.Color[0];
     Pen.Width := cfgchart.Drawpen;
     case ds of
       1..4: Ellipse(xx-2-cfgchart.drawpen,yy-2-cfgchart.drawpen,xx+2+cfgchart.drawpen,yy+2+cfgchart.drawpen);
       5: Ellipse(xx-2-cfgchart.drawpen,yy-2-cfgchart.drawpen,xx+3+cfgchart.drawpen,yy+3+cfgchart.drawpen);
       6: Ellipse(xx-3-cfgchart.drawpen,yy-3-cfgchart.drawpen,xx+3+cfgchart.drawpen,yy+3+cfgchart.drawpen);
       7: Ellipse(xx-3-cfgchart.drawpen,yy-3-cfgchart.drawpen,xx+4+cfgchart.drawpen,yy+4+cfgchart.drawpen);
       else Ellipse(xx-ds2,yy-ds2,xx+ds2,yy+ds2);
     end;
     ds2:= trunc(ds/2);
     Pen.Color := cfgplot.Color[11];
     Pen.Width := 1;
     case ds of
       1..4: Ellipse(xx-2,yy-2,xx+2,yy+2);
       5: Ellipse(xx-2,yy-2,xx+3,yy+3);
       6: Ellipse(xx-3,yy-3,xx+3,yy+3);
       7: Ellipse(xx-3,yy-3,xx+4,yy+4);
       else Ellipse(xx-ds2,yy-ds2,xx+ds2,yy+ds2);
     end;
     dsm := round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-min*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen);
     if (ds-dsm)<2*cfgchart.drawpen then ds:=ds-2*cfgchart.drawpen
                   else ds:=dsm;
     ds2 := trunc(ds/2);
     Pen.Color := cfgplot.Color[0];
     Brush.Color := cfgplot.Color[11];
     case ds of
       1..2: ;
       3: Ellipse(xx-1,yy-1,xx+2,yy+2);
       4: Ellipse(xx-2,yy-2,xx+2,yy+2);
       5: Ellipse(xx-2,yy-2,xx+3,yy+3);
       6: Ellipse(xx-3,yy-3,xx+3,yy+3);
       7: Ellipse(xx-3,yy-3,xx+4,yy+4);
       else Ellipse(xx-ds2,yy-ds2,xx+ds2,yy+ds2);
     end;
     end;
end;
end;

Procedure TSplot.PlotDblStar(xx,yy: integer; ma,sep,pa,b_v : Double);
var
  rd: Double;
  ds,ds2 : Integer;
begin
if not cfgplot.Invisible then
 with cnv do begin
   ds := round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen);
   ds2:= trunc(ds/2);
   Pen.Width := 1;
   Pen.Color := cfgplot.Color[15];
   if cfgchart.onprinter then begin
     rd:=ds2 + 3 + 3*(0.7+ln(minvalue([50,maxvalue([0.5,sep])])));
   end
   else begin
     rd:=ds2 + 2 + 2*(0.7+ln(minvalue([50,maxvalue([0.5,sep])])));
   end;
   MoveTo(xx-round(rd*sin(pa)),yy-round(rd*cos(pa)));
   LineTo(xx,yy);
   if cfgchart.onprinter then
      case cfgplot.starplot of
      0 : PlotStar0(xx,yy,ma,b_v);
      1 : PlotStar0(xx,yy,ma,b_v);
      end
   else
      case cfgplot.starplot of
      0 : PlotStar0(xx,yy,ma,b_v);
      1 : PlotStar1(xx,yy,ma,b_v);
      end;
end;
end;

Procedure TSplot.PlotGalaxie(xx,yy: integer; r1,r2,pa,rnuc,b_vt,b_ve,ma,sbr,pixscale : double);
var
  x1,y1: Double;
  ds1,ds2,ds3 : Integer;
  ex,ey,th,rot : double;
  n,ex1,ey1,dc : integer;
  elp : array [1..22] of Tpoint;
  co,cg,nebcolor : Tcolor;
//  labeltxt,sma : string;
  col : byte;
begin
if not cfgplot.Invisible then begin
  ds1:=round(maxvalue([pixscale*r1/2,cfgchart.drawpen]))+cfgchart.drawpen;
  ds2:=round(maxvalue([pixscale*r2/2,cfgchart.drawpen]))+cfgchart.drawpen;
  ds3:=round(pixscale*rnuc/2);
  case Round(b_vt*10) of
             -999: co := $00000000 ;
         -990..-3: co := cfgplot.Color[1];
           -2..-1: co := cfgplot.Color[2];
            0..2 : co := cfgplot.Color[3];
            3..5 : co := cfgplot.Color[4];
            6..8 : co := cfgplot.Color[5];
            9..13: co := cfgplot.Color[6];
          14..999: co := cfgplot.Color[7];
            1000 : co := cfgplot.Color[8];
          else co:=cfgplot.color[11]
  end;
  if cfgchart.onprinter then dc:=4 else dc:=3;
  cg:=((co and $000000ff) div dc)
     +(((co and $0000ff00) div dc)and$0000ff00)
     +(((co and $00ff0000) div dc)and$00ff0000);
  with cnv do begin
   Pen.Width := cfgchart.drawpen;
   case cfgplot.Nebplot of
   0: begin
       Brush.Color := cfgplot.Color[0];
       if co=0 then Pen.Color := cfgplot.Color[11]
              else Pen.Color := co;
       Brush.Style := bsClear;
      end;
   1: begin
       if cfgchart.onprinter then Brush.Color := $00606060+cg
         else begin
          if sbr<0 then begin
             if r1<=0 then r1:=1;
             if r2<=0 then r2:=r1;
             sbr:= ma + 2.5*log10(r1*r2) - 0.26;
          end;
          col := maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((sbr-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
          Nebcolor:=col+256*col+65536*col;
          Brush.Color := Addcolor(Nebcolor,cfgplot.backgroundcolor);
         end;
       Pen.Color := cfgplot.Color[0];
       Brush.Style := bsSolid;
      end;
   end;
   th:=0;
   for n:=1 to 22 do begin
     ex:=ds1*cos(th);
     ey:=ds2*sin(th);
     ex1:=round(ex*sin(pa) - ey*cos(pa)) + xx ;
     ey1:=round(ex*cos(pa) + ey*sin(pa)) + yy ;
     elp[n]:=Point(ex1,ey1);
     th:=th+0.3;
   end;
   Polygon(elp);
   if rnuc>0 then begin
     case Round(b_ve*10) of
               -999: co := $00000000 ;
           -990..-3: co := cfgplot.Color[1];
             -2..-1: co := cfgplot.Color[2];
              0..2 : co := cfgplot.Color[3];
              3..5 : co := cfgplot.Color[4];
              6..8 : co := cfgplot.Color[5];
              9..13: co := cfgplot.Color[6];
            14..999: co := cfgplot.Color[7];
            else co:=cfgplot.Color[11];
     end;
     cg:=((co and $000000ff) div dc)
        +(((co and $0000ff00) div dc)and$0000ff00)
        +(((co and $00ff0000) div dc)and$00ff0000);
     case cfgplot.Nebplot of
     0: begin
         Brush.Color := cfgplot.Color[0];
         if co=0 then Pen.Color := cfgplot.Color[11]
                 else Pen.Color := co;
         Brush.Style := bsClear;
        end;
     1: begin
         if cfgchart.onprinter then begin
           Brush.Color := $00808080+cg;
           Pen.Color := $00808080+cg;
         end else begin
           col := maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((sbr-1-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
           Nebcolor:=col+256*col+65536*col;
           Brush.Color := Addcolor(Nebcolor,cfgplot.backgroundcolor);
           Pen.Color := Brush.Color;
         end;
         Brush.Style := bsSolid;
        end;
     end;
     Ellipse(xx-ds3,yy-ds3,xx+ds3,yy+ds3);
   end;
  end;
end;
end;

Procedure TSplot.PlotNebula1(xx,yy: integer; dim,ma,sbr,pixscale : Double ; typ : Integer);
var
  sz: Double;
  ds,ds2 : Integer;
  col : byte;
  nebcolor : Tcolor;
begin
with cnv do begin
   Pen.Width := cfgchart.drawpen;
   sz:=PixScale*dim/2;
   ds:=round(maxvalue([sz,2*cfgchart.drawpen]));
   if sbr<=0 then begin
     if dim<=0 then dim:=1;
     sbr:= ma + 5*log10(dim) - 0.26;
   end;
   case typ of
   2,6 : col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((sbr-6)/9)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
   13  : col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-(0.8)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
    else col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((sbr-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
   end;
   Nebcolor:=col+256*col+65536*col;
   Pen.Color := Addcolor(Nebcolor,cfgplot.backgroundcolor);
   Brush.Color := Pen.Color;
   Brush.Style := bsSolid;
   case typ of
       1:  begin
           ds2:=round(ds*0.75);
           Ellipse(xx-ds,yy-ds2,xx+ds,yy+ds2);
           end;
       2:  begin
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
       3:  begin
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           Brush.Color := Addcolor(Brush.Color,$00202020);
           Pen.Color :=Brush.Color;
           ds2:=ds div 2;
           Ellipse(xx-ds2,yy-ds2,xx+ds2,yy+ds2);
           end;
       4:  begin
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
       5:  begin
           RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,ds,ds);
           end;
       6:  begin
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
//           RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,ds,ds);
           end;
   7..10:  begin
           ds:=3*cfgchart.drawpen;
           MoveTo(xx-ds+1,yy);
           LineTo(xx+ds,yy);
           MoveTo(xx,yy-ds+1);
           LineTo(xx,yy+ds);
           end;
      11:  begin
           RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,ds,ds);
           end;
      12:  begin
           Pen.Width := 1;
           Pen.Style := psDot;
           Brush.Style := bsClear;
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           Pen.Width := cfgchart.drawpen;
           Pen.Style := psSolid;
           end;
      13:  begin
           Brush.Style := bsClear;
           RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,ds,ds);
           end;
     14 :  Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
     15 :  Rectangle(xx-ds,yy-ds,xx+ds,yy+ds);
     16 :  begin
           polygon([point(xx,yy-ds),
                  point(xx+ds,yy),
                  point(xx,yy+ds),
                  point(xx-ds,yy),
                  point(xx,yy-ds)]);
           end;
       else begin
           if cfgchart.onprinter then begin
           ds:=5;
           MoveTo(xx-ds,yy-ds);
           LineTo(xx+ds,yy+ds);
           MoveTo(xx-ds,yy+ds);
           LineTo(xx+ds,yy-ds);
           end else begin
           MoveTo(xx-1,yy-1);
           LineTo(xx+3,yy+3);
           MoveTo(xx-1,yy+2);
           LineTo(xx+3,yy-2);
           end;
           end;
   end;
   Brush.Style := bsSolid;
end;
end;

Procedure TSplot.PlotNebula0(xx,yy: integer; dim,ma,sbr,pixscale : Double ; typ : Integer);
var
  sz: Double;
  ds,ds2 : Integer;
begin
with cnv do begin
   Pen.Width := cfgchart.drawpen;
   sz:=PixScale*dim/2;
   ds:=round(maxvalue([sz,2*cfgchart.drawpen]));
   ds2:=round(ds*2/3);
   Pen.Color := cfgplot.Color[0];
   Brush.Style := bsClear;
   case typ of
       1:  begin
           Pen.Color := cfgplot.Color[8];
           Ellipse(xx-ds,yy-ds2,xx+ds,yy+ds2);
           end;
       2:  begin
           ds:=ds+cfgchart.drawpen;
           Pen.Color := cfgplot.Color[9];
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           MoveTo(xx-ds,yy);
           LineTo(xx+ds,yy);
           end;
       3:  begin
           ds:=ds+cfgchart.drawpen;
           Pen.Color := cfgplot.Color[9];
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           MoveTo(xx-ds,yy);
           LineTo(xx+ds,yy);
           MoveTo(xx,yy-ds);
           LineTo(xx,yy+ds);
           end;
       4:  begin
           Pen.Color := cfgplot.Color[10];
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
       5:  begin
           Pen.Color := cfgplot.Color[10];
           Rectangle(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
       6:  begin
           ds:=ds+cfgchart.drawpen;
           Pen.Color := cfgplot.Color[10];
           Rectangle(xx-ds,yy-ds,xx+ds,yy+ds);
           MoveTo(xx-ds,yy);
           LineTo(xx+ds,yy);
           MoveTo(xx,yy-ds);
           LineTo(xx,yy+ds);
           end;
   7..10:  begin
           ds:=3*cfgchart.drawpen;
           Pen.Color := cfgplot.Color[9];
           MoveTo(xx-ds+1,yy);
           LineTo(xx+ds,yy);
           MoveTo(xx,yy-ds+1);
           LineTo(xx,yy+ds);
           end;
      11:  begin
           Pen.Color := cfgplot.Color[10];
           Rectangle(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
      12:  begin
           Pen.Color := cfgplot.Color[8];
           Pen.Width := 1;
           Pen.Style := psDot;
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           Pen.Width := cfgchart.drawpen;
           Pen.Style := psSolid;
           end;
      13:  begin
           Pen.Color := cfgplot.Color[11];
           Rectangle(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
     14 :  begin
           Pen.Color := cfgplot.Color[11];
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
     15 :  begin
           Pen.Color := cfgplot.Color[11];
           Rectangle(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
     16 :  begin
           Pen.Color := cfgplot.Color[11];
           polygon([point(xx,yy-ds),
                  point(xx+ds,yy),
                  point(xx,yy+ds),
                  point(xx-ds,yy),
                  point(xx,yy-ds)]);
           end;
       else begin
           Pen.Color := cfgplot.Color[9];
           if cfgchart.onprinter then begin
           ds:=5;
           MoveTo(xx-ds,yy-ds);
           LineTo(xx+ds,yy+ds);
           MoveTo(xx-ds,yy+ds);
           LineTo(xx+ds,yy-ds);
           end else begin
           MoveTo(xx-1,yy-1);
           LineTo(xx+3,yy+3);
           MoveTo(xx-1,yy+2);
           LineTo(xx+3,yy-2);
           end;
           end;
   end;
 Brush.Style := bsSolid;
end;
end;

Procedure TSplot.PlotNebula(xx,yy: integer; dim,ma,sbr,pixscale : Double ; typ : Integer);
begin
 if not cfgplot.Invisible then
   if cfgchart.onprinter then
      case cfgplot.nebplot of
      0 : PlotNebula0(xx,yy,dim,ma,sbr,pixscale,typ);
      1 : PlotNebula0(xx,yy,dim,ma,sbr,pixscale,typ);
      end
   else
      case cfgplot.nebplot of
      0 : PlotNebula0(xx,yy,dim,ma,sbr,pixscale,typ);
      1 : PlotNebula1(xx,yy,dim,ma,sbr,pixscale,typ);
      end;
end;

Procedure TSplot.PlotLine(x1,y1,x2,y2,color,width: integer);
begin
with cnv do begin
  Pen.width:=width*cfgchart.drawpen;
  Pen.Color:=color;
  MoveTo(x1,y1);
  LineTo(x2,y2);
end;
end;

procedure TSplot.PlotPlanet(xx,yy,ipla:integer; pixscale,jdt,diam,magn,phase,illum,pa,rot,r1,r2,be,dist:double);
var b_v:double;
    ds,n : integer;
begin
if not cfgplot.Invisible then begin
  n:=cfgplot.plaplot;
  ds:=round(diam*pixscale/2)*cfgchart.drawpen;
  if n=2 then if ds<10 then n:=1;
  if n=1 then if ds<5 then n:=0;
  if cfgchart.onprinter then
     case n of
      0 : begin // magn
          if ipla<11 then b_v:=planetcolor[ipla] else b_v:=0;
          PlotStar(xx,yy,magn,b_v);
          end;
      1 : begin // diam
          PlotPlanet1(xx,yy,ipla,pixscale,diam);
          if ipla=6 then PlotSatRing1(xx,yy,pixscale,pa,rot,r1,r2,diam,be );
          end;
      2 : begin // image
          end;
      3 : begin // symbol
          end;
     end
  else
     case n of
      0 : begin // magn
          if ipla<11 then b_v:=planetcolor[ipla] else b_v:=0;
          PlotStar(xx,yy,magn,b_v);
          end;
      1 : begin // diam
          PlotPlanet1(xx,yy,ipla,pixscale,diam);
          if ipla=6 then PlotSatRing1(xx,yy,pixscale,pa,rot,r1,r2,diam,be );
          end;
      2 : begin // image
          end;
      3 : begin // symbol
          end;
     end;
end;
end;

procedure TSplot.PlotPlanet1(xx,yy,ipla:integer; pixscale,diam:double);
var ds,ico : integer;
begin
with cnv do begin
 ds:=round(maxvalue([diam*pixscale/2,2*cfgchart.drawpen]));
 case Ipla of
  1: begin ico := 4; end;
  2: begin ico := 2; end;
  3: begin ico := 2; end;
  4: begin ico := 6; end;
  5: begin ico := 4; end;
  6: begin ico := 4; end;
  7: begin ico := 1; end;
  8: begin ico := 1; end;
  9: begin ico := 2; end;
  10:begin ico := 4; end;
  11:begin ico := 2; end;
  else begin ico:=2; end;
 end;
 Brush.Color := cfgplot.Color[ico+1] ;
 if cfgplot.PlanetTransparent then Brush.style:=bsclear
                              else Brush.style:=bssolid;
 Pen.Width := cfgchart.drawpen;
 Pen.Color := cfgplot.Color[11];
 Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
 Pen.Color := cfgplot.Color[0];
 ds:=ds+cfgchart.drawpen;
 Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
end;
end;

Procedure TSplot.PlotSatel(xx,yy,ipla:integer; pixscale,ma,diam : double; hidesat, showhide : boolean);
var
  ds,ds2 : Integer;
begin
if not cfgplot.Invisible then
if not (hidesat xor showhide) then
   with cnv do begin
        Pen.Color := cfgplot.Color[0];
        Pen.Width := cfgchart.drawpen;
        Pen.Mode := pmCopy;
        brush.color:=cfgplot.Color[11];
        ds := round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen);
        ds2:=round(diam*pixscale);
        if ds2>ds then begin
           ds:=ds2;
           brush.color:=cfgplot.Color[6];
        end;
        ds2:= round(ds/2);
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

Procedure TSplot.PlotSatRing1(xx,yy:integer; pixscale,pa,rot,r1,r2,diam,be : double);
var
  step: Double;
  ds1,ds2 : Integer;
  ex,ey,th : double;
  n,ex1,ey1,ir,R : integer;
const fr : array [1..5] of double = (1,0.8801,0.8599,0.6650,0.5486);
begin
with cnv do begin
  pa:=deg2rad*pa+rot;
  ds1:=round(maxvalue([pixscale*r1/2,cfgchart.drawpen]))+cfgchart.drawpen;
  ds2:=round(maxvalue([pixscale*r2/2,cfgchart.drawpen]))+cfgchart.drawpen;
  R:=round(diam*pixscale/2);
  Pen.Width := cfgchart.drawpen;
  Brush.Color := cfgplot.Color[0];
  Pen.Color := cfgplot.Color[5];
  Pen.mode := pmCopy;
  step:=pi2/50;
  for ir:=1 to 5 do begin
   th:=0;
     for n:=0 to 50 do begin
       ex:=(ds1*fr[ir])*cos(th);
       ey:=(ds2*fr[ir])*sin(th);
       ex1:=round(ex*sin(pa) - ey*cos(pa)) + xx ;
       ey1:=round(ex*cos(pa) + ey*sin(pa)) + yy ;
       if n=0 then moveto(ex1,ey1)
       else begin
         if cfgchart.onprinter then begin   // !! pmNot not supported by some printer
           if sqrt(ex*ex+ey*ey)<R then
              if be<0 then if n<=25 then Pen.Color:=cfgplot.Color[11]
                                    else Pen.Color:=cfgplot.Color[0]
                      else if n>25  then Pen.Color:=cfgplot.Color[11]
                                    else Pen.Color:=cfgplot.Color[0]
           else Pen.Color:=cfgplot.Color[11];
         end else
           if sqrt(ex*ex+ey*ey)<1.1*R then
              if be<0 then if n<=25 then Pen.mode := pmCopy
                                    else Pen.mode := pmNot
                      else if n>25  then Pen.mode := pmCopy
                                    else Pen.mode := pmNot
           else Pen.mode := pmCopy;                         
         lineto(ex1,ey1);
       end;
       th:=th+step;
     end;
   end;
   Pen.mode := pmCopy;
  end;
end;

end.

