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

uses u_constant, u_util, u_planetrender, u_bitmap,
     Math, SysUtils, Classes, Types,
{$ifdef linux}
   Qt, Qmenus, QForms, QStdCtrls, QControls, QExtCtrls, QGraphics;
{$endif}
{$ifdef mswindows}
   jpeg, Menus, StdCtrls, Dialogs, Controls, ExtCtrls, Windows, Graphics;
{$endif}

type

  TSide   = (U,D,L,R);  // Up, Down, Left, Right
  TSideSet = set of TSide;
  TEditLabelPos = procedure(lnum,left,top: integer) of object;
  Tintfunc = procedure(i: integer) of object;

  TSplot = class(TComponent)
  private
    { Private declarations }
     outx0,outy0,outx1,outy1:integer;
     outlineclosed,outlineinscreen: boolean;
     outlinetype,outlinemax,outlinenum,outlinelw: integer;
     outlinecol: Tcolor;
     outlinepts: array of TPoint;
     labels: array [1..maxlabels] of Tlabel;
     editlabel,editlabelx,editlabely,selectedlabel : integer;
     editlabelmod: boolean;
     FEditLabelPos: TEditLabelPos;
     FEditLabelTxt: TEditLabelPos;
     FDefaultLabel: Tintfunc;
     FDeleteLabel: Tintfunc;
     FDeleteAllLabel: Tintfunc;
     FLabelClick: Tintfunc;
     editlabelmenu: Tpopupmenu;
     Planetbmpmask: Tbitmap;
     PlanetBMP : Tbitmap;
     XplanetImg: TPicture;
     PlanetBMPjd,PlanetBMProt : double;
     PlanetBMPpla : integer;
     Xplanetrender: boolean;
     OldGRSlong: double;
     imabmp,imacopy,imamask:tbitmap;
     Procedure PlotStar0(x,y: single; ma,b_v : Double);
     Procedure PlotStar1(x,y: single; ma,b_v : Double);
     Procedure PlotStar2(x,y: single; ma,b_v : Double);
     Procedure PlotNebula0(x,y: single; dim,ma,sbr,pixscale : Double ; typ : Integer);
     Procedure PlotNebula1(x,y: single; dim,ma,sbr,pixscale : Double ; typ : Integer);
     procedure PlotPlanet1(xx,yy,ipla:integer; pixscale,diam:double);
     procedure PlotPlanet2(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,phase,pa,poleincl,sunincl,w,gw:double);
     procedure PlotPlanet3(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,pa,gw:double);
     procedure PlotSatRing1(xx,yy:integer; pixscale,pa,rot,r1,r2,diam,be : double);
     procedure BezierSpline(pts : array of Tpoint;n : integer);
     function  ClipVector(var x1,y1,x2,y2: integer;var clip1,clip2:boolean):boolean;
     procedure labelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
     procedure labelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
     procedure labelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
     procedure labelMouseLeave(Sender: TObject);
     procedure Setstarshape(value:Tbitmap);
     procedure InitXPlanetRender;
     procedure SetImage(value:Timage);
//     procedure MapGRSlongitude(GRSlongitude: double); //  No more necessary with Xplanet 1.2.0 !
  protected
    { Protected declarations }
  public
    { Public declarations }
    cfgplot : conf_plot;
    cfgchart: conf_chart;
    cbmp : Tbitmap;
    cnv, destcnv  : Tcanvas;
    Fstarshape,starbmp: Tbitmap;
    starbmpw:integer;
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
  published
    { Published declarations }
     function Init(w,h : integer) : boolean;
     function InitLabel : boolean;
     Procedure Flush;
     Procedure PlotStar(xx,yy: single; ma,b_v : Double);
     Procedure PlotVarStar(x,y: single; max,min : Double);
     Procedure PlotDblStar(x,y,r: single; ma,sep,pa,b_v : Double);
     Procedure PlotGalaxie(x,y: single; r1,r2,pa,rnuc,b_vt,b_ve,ma,sbr,pixscale : double);
     Procedure PlotNebula(xx,yy: single; dim,ma,sbr,pixscale : Double ; typ : Integer);
     Procedure PlotLine(x1,y1,x2,y2:single; color,width: integer);
     Procedure PlotImage(x,y: single; Width,Height,Rotation : double; flipx, flipy :integer; WhiteBg, Transparent :boolean; bmp:Tbitmap);
     procedure PlotPlanet(x,y:single;flipx,flipy,ipla:integer; jdt,pixscale,diam,magn,phase,pa,rot,poleincl,sunincl,w,r1,r2,be:double);
     procedure PlotEarthShadow(x,y: single; r1,r2,pixscale: double);
     procedure PlotSatel(x,y:single;ipla:integer; pixscale,ma,diam : double; hidesat, showhide : boolean);
     Procedure PlotAsteroid(x,y:single;symbol: integer; ma : Double);
     Procedure PlotComet(x,y,cx,cy:single;symbol: integer; ma,diam,PixScale : Double);
     function  PlotLabel(i,xx,yy,r,labelnum,fontnum:integer; Xalign,Yalign:TLabelAlign; WhiteBg,forcetextlabel:boolean; txt:string):integer;
     procedure PlotText(xx,yy,fontnum,color:integer; Xalign,Yalign:TLabelAlign; txt:string);
     procedure PlotTextCR(xx,yy,fontnum,labelnum:integer; txt:string);
     procedure PlotOutline(x,y:single;op,lw,fs,closed: integer; r2:double; col: Tcolor);
     Procedure PlotCircle(x1,y1,x2,y2:single;color:integer;moving:boolean);
     Procedure PlotPolyLine(p:array of Tpoint; color:integer; moving:boolean);
     property Starshape: TBitmap read Fstarshape write Setstarshape;
     property OnEditLabelPos: TEditLabelPos read FEditLabelPos write FEditLabelPos;
     property OnEditLabelTxt: TEditLabelPos read FEditLabelTxt write FEditLabelTxt;
     property OnDefaultLabel: Tintfunc read FDefaultLabel write FDefaultLabel;
     property OnDeleteLabel: Tintfunc read FDeleteLabel write FDeleteLabel;
     property OnDeleteAllLabel: Tintfunc read FDeleteAllLabel write FDeleteAllLabel;
     property OnLabelClick: Tintfunc read FLabelClick write FLabelClick;
     Procedure Movelabel(Sender: TObject);
     Procedure EditlabelTxt(Sender: TObject);
     Procedure DefaultLabel(Sender: TObject);
     Procedure Deletelabel(Sender: TObject);
     Procedure DeleteAlllabel(Sender: TObject);
     property Image: TImage write SetImage;
  end;

  const cliparea = 10;
  
Implementation

constructor TSplot.Create(AOwner:TComponent);
begin
 inherited Create(AOwner);
 imabmp:=tbitmap.Create;
 imabmp.PixelFormat:=pf32bit;
 imacopy:=tbitmap.Create;
 imacopy.PixelFormat:=pf32bit;
 imamask:=tbitmap.Create;
 imamask.PixelFormat:=pf32bit;
 starbmp:=Tbitmap.Create;
 cbmp:=Tbitmap.Create;
 cnv:=cbmp.canvas;
 // set safe value
 starbmpw:=1;
 editlabel:=-1;
 cbmp.PixelFormat:=pf32bit;
 cbmp.width:=100;
 cbmp.height:=100;
 cfgchart.width:=100;
 cfgchart.height:=100;
 cfgchart.min_ma:=6;
 cfgchart.onprinter:=false;
 cfgchart.drawpen:=1;
 cfgchart.fontscale:=1;

 InitPlanetRender;
 InitXPlanetRender;
 try
 if planetrender or Xplanetrender then begin
    planetbmp:=Tbitmap.create;
    planetbmp.Width:=450;
    planetbmp.Height:=450;
    planetbmpmask:=Tbitmap.create;
    planetbmpmask.Width:=450;
    planetbmpmask.Height:=450;
    xplanetimg:=TPicture.create;
 end;
 if planetrender then begin
    settexturepath(slash(appdir)+slash('data')+slash('planet'));
    // try if it work
    planetrender:=false;
    RenderPluto(0,0,0,0,0,1,planetbmp.width, planetbmp);
    // we are here! so it don't crash, reset the value.
    planetrender:=true;
 end;
 except
   planetrender:=false;
   if cfgplot.plaplot=2 then cfgplot.plaplot:=1;
 end;
end;

destructor TSplot.Destroy;
var i:integer;
begin
try
 //for i:=1 to maxlabels do labels[i].Free;
 starbmp.Free;
 cbmp.Free;
 imabmp.Free;
 imacopy.Free;
 imamask.Free;
 if planetrender or Xplanetrender then begin
    planetbmp.Free;
    planetbmpmask.Free;
    xplanetimg.Free;
 end;
 if planetrender then begin
    ClosePlanetRender;
 end;
 inherited destroy;
except
end;
end;

procedure TSplot.SetImage(value:Timage);
var i : integer;
    MenuItem: TMenuItem;
begin
 destcnv:=value.Canvas;
 for i:=1 to maxlabels do begin
    labels[i]:=Tlabel.Create(nil);
    labels[i].parent:=value.parent;
    labels[i].tag:=i;                                
    labels[i].transparent:=true;
    labels[i].ShowAccelChar:=false;
    {$ifdef linux} labels[i].Font.CharSet:=fcsAnyCharSet; {$endif}
    {$ifdef mswindows} labels[i].Font.CharSet:=DEFAULT_CHARSET; {$endif}
    labels[i].OnMouseDown:=labelmousedown;
    labels[i].OnMouseUp:=labelmouseup;
    labels[i].OnMouseMove:=labelmousemove;
    labels[i].OnMouseLeave:=labelmouseleave;
 end;
 editlabelmenu:=Tpopupmenu.Create(self);
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := '';
 MenuItem.Enabled:=false;
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := '-';
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := 'Move label';
 MenuItem.OnClick := MoveLabel;
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := 'Edit label';
 MenuItem.OnClick := EditLabelTxt;
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := 'Default label';
 MenuItem.OnClick := DefaultLabel;
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := 'Delete label';
 MenuItem.OnClick := DeleteLabel;
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := 'Reset all label';
 MenuItem.OnClick := DeleteAllLabel;
end;

function TSplot.Init(w,h : integer) : boolean;
begin
cfgchart.Width:=w;
cfgchart.Height:=h;
cbmp.Width:=w;
cbmp.Height:=h;
cnv:=cbmp.Canvas; // defered plot to bitmap
with cnv do begin
 Brush.Color:=cfgplot.Color[0];
 Pen.Color:=cfgplot.Color[0];
 Brush.style:=bsSolid;
 Pen.Mode:=pmCopy;
 Pen.Style:=psSolid;
 Rectangle(0,0,cfgchart.Width,cfgchart.Height);
end;
InitLabel;
if (cfgchart.drawpen<>starbmpw)and(Fstarshape<>nil) then begin
   starbmpw:=cfgchart.drawpen;
   ImageResize(Fstarshape,starbmp,starbmpw);
end;
result:=true;
end;

procedure TSplot.InitXPlanetRender;
begin
 OldGRSlong:=-9999;
 Xplanetrender:=true;
end;

Procedure TSplot.Flush;
begin
 destcnv.Draw(0,0,cbmp);
 cnv:=destcnv;  // direct plot to screen;
end;

procedure TSplot.Setstarshape(value:Tbitmap);
begin
Fstarshape:=value;
starbmpw:=1;
starbmp.Width:=Fstarshape.Width;
starbmp.Height:=Fstarshape.Height;
starbmp.PixelFormat:=Fstarshape.PixelFormat;
starbmp.Canvas.Draw(0,0,Fstarshape);
end;

function TSplot.InitLabel : boolean;
var i:integer;
begin
editlabel:=-1;
for i:=1 to maxlabels do labels[i].visible:=false;
result:=true;
end;

Procedure TSplot.PlotStar1(x,y: single; ma,b_v : Double);
var
  ds,Icol : Integer;
  ico,isz,xx,yy : integer;
  DestR,SrcR :Trect;
  co: TColor;
  b : TBitmap;
begin
xx:=round(x);
yy:=round(y);
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
   if b_v>1000 then begin
      co:=cfgplot.Color[trunc(b_v-1000)];
      b:=Tbitmap.Create;
      try
      b.Width:=2*(cfgplot.starshapew+1)*starbmpw;
      b.Height:=2*(cfgplot.starshapew+1)*starbmpw;
      b.PixelFormat:=starbmp.PixelFormat;
      b.Canvas.Brush.Color:=co;
      b.Canvas.Rectangle(0,0,b.Width,b.height);
      SrcR:=Rect(isz*cfgplot.starshapesize*starbmpw,ico*cfgplot.starshapesize*starbmpw,(isz+1)*cfgplot.starshapesize*starbmpw,(ico+1)*cfgplot.starshapesize*starbmpw);
      DestR:=Rect(0,0,b.Width,b.Height);
      b.canvas.copymode:=cmMergeCopy;
      b.canvas.CopyRect(DestR,starbmp.canvas,SrcR);
      SrcR:=DestR;
      DestR:=Rect(xx-cfgplot.starshapew*starbmpw,yy-cfgplot.starshapew*starbmpw,xx+(cfgplot.starshapew+1)*starbmpw,yy+(cfgplot.starshapew+1)*starbmpw);
      copymode:=cmSrcPaint;
      CopyRect(DestR,b.canvas,SrcR);
      finally
      b.Free;
      end;
   end else begin
     SrcR:=Rect(isz*cfgplot.starshapesize*starbmpw,ico*cfgplot.starshapesize*starbmpw,(isz+1)*cfgplot.starshapesize*starbmpw,(ico+1)*cfgplot.starshapesize*starbmpw);
     DestR:=Rect(xx-cfgplot.starshapew*starbmpw,yy-cfgplot.starshapew*starbmpw,xx+(cfgplot.starshapew+1)*starbmpw,yy+(cfgplot.starshapew+1)*starbmpw);
     copymode:=cmSrcPaint;
     CopyRect(DestR,starbmp.canvas,SrcR);
   end;
end;
end;

Procedure TSplot.PlotStar0(x,y: single; ma,b_v : Double);
var
  ds,ds2,Icol,xx,yy : Integer;
  co : Tcolor;
begin
xx:=round(x);
yy:=round(y);
with cnv do begin
   Pen.Color := cfgplot.Color[0];
   Pen.Width := cfgchart.DrawPen;
   Pen.Mode := pmCopy;
   if b_v>1000 then co:=cfgplot.Color[trunc(b_v-1000)]
   else begin
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
     end;
     if ma<-5 then ma:=-5;
     ds := round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen);
     ds2:= round(ds/2);
     Brush.Color := co ;
     Brush.style:=bsSolid;
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

Procedure TSplot.PlotStar2(x,y: single; ma,b_v : Double);
type
  TPos=single;
  TColorArray = array[0..32767] of Longword;
  PColorArray = ^TColorArray;
var LineWidth,AAWidth,Lum,R,G,B  : TPos;
var
  Alpha, UseContrast, Distance,
  OutLevelR, OutLevelG, OutLevelB : TPos;
  DX, DY : TPos; // Distance elements
  XCount, YCount : integer;
  MinX, MinY, MaxX, MaxY, bmWidth : integer;
  ExistingPixelRed, ExistingPixelGreen, ExistingPixelBlue,
  NewPixelR, NewPixelG, NewPixelB : integer;
  P : PColorArray;
  Icol,Contrast : Integer;
  co,px : Tcolor;
const
  PointAlpha : single = 0.2;  // Transparency at Solid;

begin
  LineWidth:=0;
  if ma<0 then ma:=ma/10;                               // avoid Moon and Sun be too big
  Lum := (1.1*cfgchart.min_ma-ma)/cfgchart.min_ma;      // logarithmic luminosity proportional to magnitude
  if Lum<0.1 then Lum:=0.1;                             // for object fainter than the limit (asteroid)
  AAwidth:=cfgchart.drawpen*cfgplot.partsize*power(cfgplot.magsize,Lum); // particle size also depend on the magnitude

  if b_v>1000 then co:=cfgplot.Color[trunc(b_v-1000)]   // Use direct color table indice
  else begin
  Icol:=Round(b_v*10);                                  // Use color from B-V
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
  end;
  R := co and $FF;
  G := (co div $100) and $FF;
  B := (co div $10000) and $FF;
  R := ( (R * cfgplot.Saturation) + (65536-cfgplot.Saturation) ) * 0.0035;
  G := ( (G * cfgplot.Saturation) + (65536-cfgplot.Saturation) ) * 0.0035;
  B := ( (B * cfgplot.Saturation) + (65536-cfgplot.Saturation) ) * 0.0035;

  UseContrast := (cfgplot.contrast * cfgplot.contrast) shr 6;
  if (AAWidth<1) then begin
    Lum := Lum * AAWidth;
    AAWidth := 1;
  end;
  MinX := round(X - LineWidth - AAWidth - 0.5);
  MaxX := round(X + LineWidth + AAWidth + 0.5);
  MinY := round(Y - LineWidth - AAWidth - 0.5);
  MaxY := round(Y + LineWidth + AAWidth + 0.5);

  with cbmp do begin
  bmWidth := Width;

  for YCount := MinY to MaxY do
  if (YCount>=0) and (YCount<(Height)) then begin
    P := ScanLine[YCount];
    for XCount := MinX to MaxX do begin
      if (XCount>=0) and (XCount<bmWidth) then begin
        DX := XCount - X;
        DY := YCount - Y;
        Distance := Hypot(DX,DY);
        if Distance<LineWidth then
          Alpha := PointAlpha*0.75
        else begin
          if Distance>(LineWidth+AAWidth+0.5) then
            Alpha := 0
          else
            Alpha := PointAlpha - PointAlpha * Distance / (LineWidth+AAWidth+0.5)
        end;

        ExistingPixelBlue  :=  P[XCount] and $FF;
        ExistingPixelGreen :=  (P[XCount] div $100) and $FF;
        ExistingPixelRed   :=  (P[XCount] div $10000) and $FF;

        OutLevelR := (ExistingPixelRed)*(1-Alpha) +  ((Lum*R*(Alpha)*UseContrast) /256 );
        NewPixelR := trunc(OutLevelR);
        if NewPixelR>255 then NewPixelR := 255;

        OutLevelG := (ExistingPixelGreen)*(1-Alpha) +  ((Lum*G*(Alpha)*UseContrast) /256 );
        NewPixelG := trunc(OutLevelG);
        if NewPixelG>255 then NewPixelG := 255;

        OutLevelB := (ExistingPixelBlue)*(1-Alpha) +  ((Lum*B*(Alpha)*UseContrast) /256 );
        NewPixelB := trunc(OutLevelB);
        if NewPixelB>255 then NewPixelB := 255;

        P[XCount] := (NewPixelB + NewPixelG*$100 + NewPixelR*$10000);
      end;
    end;
  end;
  end;
end;


Procedure TSplot.PlotStar(xx,yy: single; ma,b_v : Double);
begin
 if not cfgplot.Invisible then
      case cfgplot.starplot of
      0 : PlotStar0(xx,yy,ma,b_v);
      1 : PlotStar1(xx,yy,ma,b_v);
      2 : PlotStar2(xx,yy,ma,b_v);
      end;
end;

Procedure TSplot.PlotVarStar(x,y: single; max,min : Double);
var
  ds,ds2,dsm,xx,yy : Integer;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then begin
  with cnv do begin
     ds := round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-max*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen)-cfgchart.drawpen;
     ds2:= trunc(ds/2)+cfgchart.drawpen;
     Brush.Color := cfgplot.Color[0];
     Brush.style:=bsSolid;
     Pen.Mode:=pmCopy;
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

Procedure TSplot.PlotDblStar(x,y,r: single; ma,sep,pa,b_v : Double);
var
  rd: Double;
  ds,ds2,xx,yy : Integer;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then
 with cnv do begin
   ds := round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen);
   ds2:= trunc(ds/2);
   Pen.Width := 1;
   Pen.Color := cfgplot.Color[15];
   Brush.style:=bsSolid;
   Pen.Mode:=pmCopy;
   rd:=max(r,ds2 + cfgchart.drawpen*(2+2*(0.7+ln(minvalue([50,maxvalue([0.5,sep])])))));
   MoveTo(xx-round(rd*sin(pa)),yy-round(rd*cos(pa)));
   LineTo(xx,yy);
end;
end;

Procedure TSplot.PlotGalaxie(x,y: single; r1,r2,pa,rnuc,b_vt,b_ve,ma,sbr,pixscale : double);
var
  x1,y1: Double;
  ds1,ds2,ds3,xx,yy : Integer;
  ex,ey,th,rot : double;
  n,ex1,ey1 : integer;
  elp : array [1..22] of Tpoint;
  co,nebcolor : Tcolor;
  col,r,g,b : byte;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then begin
  ds1:=round(maxvalue([pixscale*r1/2,cfgchart.drawpen]))+cfgchart.drawpen;
  ds2:=round(maxvalue([pixscale*r2/2,cfgchart.drawpen]))+cfgchart.drawpen;
  ds3:=round(pixscale*rnuc/2);
  if b_vt>1000 then co:=cfgplot.Color[trunc(b_vt-1000)]
  else begin
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
  end;
  with cnv do begin
   Pen.Width := cfgchart.drawpen;
   Brush.style:=bsSolid;
   Pen.Mode:=pmCopy;
   case cfgplot.Nebplot of
   0: begin
       Brush.Color := cfgplot.Color[0];
       if co=0 then Pen.Color := cfgplot.Color[11]
              else Pen.Color := co;
       Brush.Style := bsClear;
      end;
   1: begin
       if sbr<0 then begin
          if r1<=0 then r1:=1;
          if r2<=0 then r2:=r1;
          sbr:= ma + 2.5*log10(r1*r2) - 0.26;
       end;
       col := maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((sbr-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
       r:=co and $FF;
       g:=(co shr 8) and $FF;
       b:=(co shr 16) and $FF;
       Nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
       Brush.Color := Addcolor(Nebcolor,cfgplot.backgroundcolor);
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
   // different surface brightness and color for the nucleus, no more used with present catalog
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
     case cfgplot.Nebplot of
     0: begin
         Brush.Color := cfgplot.Color[0];
         if co=0 then Pen.Color := cfgplot.Color[11]
                 else Pen.Color := co;
         Brush.Style := bsClear;
        end;
     1: begin
         col := maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((sbr-1-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
         r:=co and $FF;
         g:=(co shr 8) and $FF;
         b:=(co shr 16) and $FF;
         Nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
         Brush.Color := Addcolor(Nebcolor,cfgplot.backgroundcolor);
         Pen.Color := Brush.Color;
         Brush.Style := bsSolid;
        end;
     end;
     Ellipse(xx-ds3,yy-ds3,xx+ds3,yy+ds3);
   end;
  end;
end;
end;

Procedure TSplot.PlotNebula1(x,y: single; dim,ma,sbr,pixscale : Double ; typ : Integer);
var
  sz: Double;
  ds,ds2,xx,yy : Integer;
  col,r,g,b : byte;
  nebcolor : Tcolor;
  Procedure SetColor(i:integer);
   begin
     r:=cfgplot.Color[i] and $FF;
     g:=(cfgplot.Color[i] shr 8) and $FF;
     b:=(cfgplot.Color[i] shr 16) and $FF;
     Nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
     cnv.Pen.Color := Addcolor(Nebcolor,cfgplot.backgroundcolor);
     cnv.Brush.Color := cnv.Pen.Color;
   end;
begin
xx:=round(x);
yy:=round(y);
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
   Brush.Style := bsSolid;
   Pen.Mode:=pmCopy;
   case typ of
       1:  begin
           SetColor(8);
           ds2:=round(ds*0.75);
           Ellipse(xx-ds,yy-ds2,xx+ds,yy+ds2);
           end;
       2:  begin
           SetColor(9);
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
       3:  begin
           SetColor(9);
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           Brush.Color := Addcolor(Brush.Color,$00202020);
           Pen.Color :=Brush.Color;
           ds2:=ds div 2;
           Ellipse(xx-ds2,yy-ds2,xx+ds2,yy+ds2);
           end;
       4:  begin
           SetColor(10);
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
       5:  begin
           SetColor(10);
           RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,ds,ds);
           end;
       6:  begin
           SetColor(10);
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
//           RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,ds,ds);
           end;
   7..10:  begin
           SetColor(9);
           ds:=3*cfgchart.drawpen;
           MoveTo(xx-ds+1,yy);
           LineTo(xx+ds,yy);
           MoveTo(xx,yy-ds+1);
           LineTo(xx,yy+ds);
           end;
      11:  begin
           SetColor(10);
           RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,ds,ds);
           end;
      12:  begin
           SetColor(8);
           Pen.Width := 1;
           Pen.Style := psDot;
           Brush.Style := bsClear;
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           Pen.Width := cfgchart.drawpen;
           Pen.Style := psSolid;
           end;
      13:  begin
           SetColor(11);
           Brush.Style := bsClear;
           RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,ds,ds);
           end;
     14 :  begin
           SetColor(11);
           Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
     15 :  begin
           SetColor(11);
           Rectangle(xx-ds,yy-ds,xx+ds,yy+ds);
           end;
     16 :  begin
           SetColor(11);
           polygon([point(xx,yy-ds),
                  point(xx+ds,yy),
                  point(xx,yy+ds),
                  point(xx-ds,yy),
                  point(xx,yy-ds)]);
           end;
       else begin
           SetColor(9);
           MoveTo(xx-1,yy-1);
           LineTo(xx+3,yy+3);
           MoveTo(xx-1,yy+2);
           LineTo(xx+3,yy-2);
           end;
   end;
   Brush.Style := bsSolid;
end;
end;

Procedure TSplot.PlotNebula0(x,y: single; dim,ma,sbr,pixscale : Double ; typ : Integer);
var
  sz: Double;
  ds,ds2,xx,yy : Integer;
begin
xx:=round(x);
yy:=round(y);
with cnv do begin
   Pen.Width := cfgchart.drawpen;
   sz:=PixScale*dim/2;
   ds:=round(maxvalue([sz,2*cfgchart.drawpen]));
   ds2:=round(ds*2/3);
   Pen.Color := cfgplot.Color[0];
   Pen.Mode:=pmCopy;
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
           MoveTo(xx-1,yy-1);
           LineTo(xx+3,yy+3);
           MoveTo(xx-1,yy+2);
           LineTo(xx+3,yy-2);
           end;
   end;
 Brush.Style := bsSolid;
end;
end;

Procedure TSplot.PlotNebula(xx,yy: single; dim,ma,sbr,pixscale : Double ; typ : Integer);
begin
 if not cfgplot.Invisible then
      case cfgplot.nebplot of
      0 : PlotNebula0(xx,yy,dim,ma,sbr,pixscale,typ);
      1 : PlotNebula1(xx,yy,dim,ma,sbr,pixscale,typ);
      end;
end;

Procedure TSplot.PlotLine(x1,y1,x2,y2:single; color,width: integer);
begin
with cnv do begin
  Pen.width:=width*cfgchart.drawpen;
  Pen.Mode:=pmCopy;
  Pen.Color:=color;
  if (abs(x1-cfgchart.hw)<cfgplot.outradius)and(abs(y1-cfgchart.hh)<cfgplot.outradius) and
     (abs(x2-cfgchart.hw)<cfgplot.outradius)and(abs(y2-cfgchart.hh)<cfgplot.outradius)
     then begin
        MoveTo(round(x1),round(y1));
        LineTo(round(x2),round(y2));
  end;
end;
end;

procedure TSplot.PlotOutline(x,y:single;op,lw,fs,closed: integer; r2:double; col: Tcolor);
var xx,yy:integer;
procedure addpoint(x,y:integer);
begin
// add a point to the line
 if (outlinenum+1)>=outlinemax then begin
    outlinemax:=outlinemax+100;
    setlength(outlinepts,outlinemax);
 end;
 outlinepts[outlinenum].x:=x;
 outlinepts[outlinenum].y:=y;
 inc(outlinenum);
end;
function processpoint(xx,yy:integer):boolean;
var x1,y1,x2,y2:integer;
    clip1,clip2:boolean;
begin
// find if we can plot this point
if outlineinscreen and
   (abs(xx-cfgchart.hw)<cfgplot.outradius)and
   (abs(yy-cfgchart.hh)<cfgplot.outradius)and
   ((intpower(outx1-xx,2)+intpower(outy1-yy,2))<r2)
   then
   begin
      // begin at last point
      addpoint(outx1,outy1);
      x1:=outx1; y1:=outy1; x2:=xx; y2:=yy;
      // find if clipping is necessary
      ClipVector(x1,y1,x2,y2,clip1,clip2);
      if clip1 then addpoint(x1,y1);
      if clip2 then addpoint(x2,y2);
      // set last point
      outx1:=xx;
      outy1:=yy;
      result:=true;
   end else begin
      // point outside safe area, ignore the whole object.
      outlineinscreen:=false;
      result:=false;
end;
end;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then begin
  case op of
  0 : begin // init vector
       // set line options
       outlinetype:=fs;
       outlinenum:=0;
       outlinecol:=col;
       outlinelw:=lw;
       outlineclosed:=(closed=1);
       outlineinscreen:=true;
       outlinemax:=100;
       setlength(outlinepts,outlinemax);
       // initialize first point
       outx0:=xx;
       outy0:=yy;
       outx1:=xx;
       outy1:=yy;
      end;
  1 : begin // close and draw vector
       // process last point
       if outlineclosed then begin
          processpoint(xx,yy);
          if processpoint(outx0,outy0) then addpoint(outx1,outy1);
       end else begin
          if processpoint(xx,yy) then addpoint(outx1,outy1);
       end;
       if outlineinscreen and(outlinenum>=2) then begin
         // object is to be draw
         dec(outlinenum);
         if outlinecol=cfgplot.bgColor then outlinecol:=outlinecol xor clWhite;
         cnv.Pen.Mode:=pmCopy;
         cnv.Pen.Width:=outlinelw*cfgchart.drawpen;
         cnv.Pen.Color:=outlinecol;
         cnv.Brush.Style:=bsSolid;
         cnv.Brush.Color:=outlinecol;
         outlinemax:=outlinenum+1;
         if (cfgplot.nebplot=0) and (outlinetype=2) then outlinetype:=0;
         case outlinetype of
         0 : begin setlength(outlinepts,outlinenum+1); cnv.polyline(outlinepts);end;
         1 : Bezierspline(outlinepts,outlinenum+1);
         2 : begin setlength(outlinepts,outlinenum+1); cnv.polygon(outlinepts);end;
         end;
       end;
     end;
 2 : begin // add point
       processpoint(xx,yy);
     end; 
 end; // case op
end;  // not invisible
end;

procedure TSplot.BezierSpline(pts : array of Tpoint;n : integer);
var p : array of TPoint;
    i,m : integer;
function LC(Pt1,Pt2:TPoint; c1,c2:extended):TPoint;
begin
    result:= Point(round(Pt1.x*c1 + (Pt2.x-Pt1.x)*c2),
                   round(Pt1.y*c1 + (Pt2.y-Pt1.y)*c2));
end;
begin
m:=3*(n-1);
setlength(p,1+m);
p[0]:=pts[0];
for i:=0 to n-3 do begin
  p[3*i+1]:=LC(pts[i],pts[i+1],1,1/3);
  p[3*i+2]:=LC(pts[i+1],pts[i+2],1,-1/3);
  p[3*i+3]:=pts[i+1]
end;
p[m-2]:=LC(pts[n-2],pts[n-1],1,1/3);
p[m-1]:=LC(pts[n-1],pts[0],1,1/3);
p[m]:=pts[n-1];
{$ifdef linux}
for m:=0 to n-1 do begin
  cnv.PolyBezier(p,3*m);
end;
{$endif}
{$ifdef mswindows}
  cnv.PolyBezier(p);
{$endif}
end;

procedure TSplot.PlotPlanet(x,y: single;flipx,flipy,ipla:integer; jdt,pixscale,diam,magn,phase,pa,rot,poleincl,sunincl,w,r1,r2,be:double);
var b_v:double;
    ds,n,xx,yy : integer;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then begin
 n:=cfgplot.plaplot;
 ds:=round(diam*pixscale/2)*cfgchart.drawpen;
 if ((xx+ds)>0) and ((xx-ds)<cfgchart.Width) and ((yy+ds)>0) and ((yy-ds)<cfgchart.Height) then begin
  if (n=2) and ((ds<5)or(ds>1500)) then n:=1;
  if (n=1) and (ds<5)  then n:=0;
  if ((not planetrender)and(not Xplanetrender)) and (n=2) then n:=1;
  {$ifdef linux}
     if (n=2)and(ipla=10) then n:=1;
  {$endif}
  case n of
      0 : begin // magn
          if ipla<11 then b_v:=planetcolor[ipla] else b_v:=1020;
          PlotStar(x,y,magn,b_v);
          end;
      1 : begin // diam
          PlotPlanet1(xx,yy,ipla,pixscale,diam);
          if ipla=6 then PlotSatRing1(xx,yy,pixscale,pa,rot,r1,r2,diam,be );
          end;
      2 : begin // image
          {$ifdef mswindows}
          if use_Xplanet then
             PlotPlanet3(xx,yy,flipx,flipy,ipla,jdt,pixscale,diam,pa+rad2deg*rot,r1)
          else   
             PlotPlanet2(xx,yy,flipx,flipy,ipla,jdt,pixscale,diam,phase,pa+rad2deg*rot,poleincl,sunincl,w,r1);
          {$endif}
          {$ifdef linux}
             PlotPlanet3(xx,yy,flipx,flipy,ipla,jdt,pixscale,diam,pa+rad2deg*rot,r1);
          {$endif}
          end;
      3 : begin // symbol
          end;
  end;
 end; 
end;
end;

procedure TSplot.PlotPlanet1(xx,yy,ipla:integer; pixscale,diam:double);
var ds,ico : integer;
begin
with cnv do begin
 ds:=round(maxvalue([diam*pixscale/2,2*cfgchart.drawpen]));
 if cfgplot.Color[11]>cfgplot.BgColor then begin
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
 end
 else Brush.Color := cfgplot.BgColor ;
 if cfgplot.PlanetTransparent then Brush.style:=bsclear
                              else Brush.style:=bssolid;
 Pen.Width := cfgchart.drawpen;
 Pen.Color := cfgplot.Color[11];
 Pen.Mode:=pmCopy;
 Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
 Pen.Color := cfgplot.Color[0];
 Brush.style:=bsclear;
 ds:=ds+cfgchart.drawpen;
 Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
end;
end;

Procedure TSplot.PlotImage(x,y: single; Width,Height,Rotation : double; flipx, flipy :integer; WhiteBg, Transparent : boolean; bmp:Tbitmap);
var dsx,dsy,xx,yy : single;
    DestR,SrcR :Trect;
begin
if not transparent then BitmapNotZero(bmp);
BitmapRotation(bmp,imabmp,Rotation,WhiteBg);
//BitmapRotMask(imamask,imabmp,bmp,Rotation);
BitmapBlackMask(imamask,imabmp);
if (Width<=cfgchart.Width)and(Height<=cfgchart.Height) then begin
   // image smaller than chart, write in full
   xx:=x;
   yy:=y;
   dsx:=(imabmp.Width/bmp.Width)*Width/2;
   dsy:=(imabmp.Height/bmp.Height)*Height/2;
   DestR:=Rect(round(xx-flipx*dsx),round(yy-flipy*dsy),round(xx+flipx*dsx),round(yy+flipy*dsy));
   cnv.copymode:=cmSrcAnd;
   cnv.StretchDraw(DestR,imamask);
   cnv.copymode:=cmSrcPaint;
   cnv.StretchDraw(DestR,imabmp);
end else begin
   // only a part of the image is displayed
   xx:=(imabmp.Width/2)+flipx*((cfgchart.Width/2)-x)*bmp.Width/Width;
   yy:=(imabmp.Height/2)+flipy*((cfgchart.Height/2)-y)*bmp.height/Height;
   dsx:=(bmp.Width*cfgchart.Width/Width)/2;
   dsy:=dsx*cfgchart.height/cfgchart.width;
   SrcR:=Rect(round(xx-dsx),round(yy-dsy),round(xx+dsx),round(yy+dsy));
   if (flipx>0)and(flipy>0) then DestR:=Rect(0,0,cfgchart.Width,cfgchart.Height)
     else if (flipx<0)and(flipy<0) then DestR:=Rect(cfgchart.Width,cfgchart.Height,0,0)
     else if flipx<0 then DestR:=Rect(cfgchart.Width,0,0,cfgchart.Height)
     else if flipy<0 then DestR:=Rect(0,cfgchart.Height,cfgchart.Width,0);
   imacopy.canvas.copymode:=cmSrcCopy;
   imacopy.Width:=round(2*dsx);
   imacopy.Height:=round(2*dsy);
   if WhiteBg then begin
     imacopy.Canvas.Brush.Color:=clBlack;
     imacopy.Canvas.Pen.Color:=clBlack;
   end else begin
     imacopy.Canvas.Brush.Color:=clWhite;
     imacopy.Canvas.Pen.Color:=clWhite;
   end;
   imacopy.Canvas.Rectangle(0,0,imacopy.Width,imacopy.Height);
   imacopy.canvas.CopyRect(Rect(0,0,imacopy.Width,imacopy.Height),imamask.Canvas,SrcR);
   cnv.copymode:=cmSrcAnd;
   cnv.StretchDraw(DestR,imacopy);
   cnv.copymode:=cmSrcPaint;
   if WhiteBg then begin
     imacopy.Canvas.Brush.Color:=clWhite;
     imacopy.Canvas.Pen.Color:=clWhite;
   end else begin
     imacopy.Canvas.Brush.Color:=clBlack;
     imacopy.Canvas.Pen.Color:=clBlack;
   end;
   imacopy.Canvas.Rectangle(0,0,imacopy.Width,imacopy.Height);
   imacopy.canvas.CopyRect(Rect(0,0,imacopy.Width,imacopy.Height),imabmp.Canvas,SrcR);
   cnv.StretchDraw(DestR,imacopy);
end;
end;

procedure TSplot.PlotPlanet2(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,phase,pa,poleincl,sunincl,w,gw:double);
var ds,i : integer;
    DestR :Trect;
const planetsize=450;
      moonsize=1000;
begin
if ipla=6 then ds:=round(maxvalue([2.2261*diam*pixscale/2,2*cfgchart.drawpen]))
          else ds:=round(maxvalue([diam*pixscale/2,2*cfgchart.drawpen]));
if (planetBMPpla<>ipla)or(abs(planetbmpjd-jdt)>0.000695)or(abs(planetbmprot-pa)>0.2) then begin
 case ipla of
  1 :  RenderMercury(w,phase,pa,poleincl,sunincl,1,planetsize, planetbmp);
  2 :  RenderVenus(w,phase,pa,poleincl,sunincl,1,planetsize, planetbmp);
  4 :  RenderMars(w,phase,pa,poleincl,sunincl,1,planetsize, planetbmp);
  5 :  RenderJupiter(w-gw,phase,pa,poleincl,sunincl,1,planetsize, planetbmp);
  6 :  RenderSaturn(w,phase,pa,poleincl,sunincl,1,planetsize, planetbmp);
  7 :  RenderUranus(w,phase,pa,poleincl,sunincl,1,planetsize, planetbmp);
  8 :  RenderNeptune(w,phase,pa,poleincl,sunincl,1,planetsize, planetbmp);
  9 :  RenderPluto(w,phase,pa,poleincl,sunincl,1,planetsize, planetbmp);
  10 : RenderSun(w,pa,poleincl,1,planetsize, planetbmp);
  11 : RenderMoon(w,phase,pa,poleincl,sunincl,1,moonsize, planetbmp);
 end;
 planetbmppla:=ipla;
 planetbmpjd:=jdt;
 planetbmprot:=pa;
end;
DestR:=Rect(xx-flipx*ds,yy-flipy*ds,xx+flipx*ds,yy+flipy*ds);
if not cfgplot.planetTransparent then begin
  i:=planetbmp.Width;
  planetbmpmask.Width:=i;
  planetbmpmask.Height:=i;
  planetbmpmask.canvas.brush.color:=clwhite;
  planetbmpmask.canvas.brush.style:=bssolid;
  planetbmpmask.canvas.pen.color:=clwhite;
  planetbmpmask.canvas.pen.width:=1;
  planetbmpmask.canvas.rectangle(0,0,i,i);
  planetbmpmask.canvas.pen.color:=clblack;
  planetbmpmask.canvas.brush.color:=clblack;
  case ipla of
    5  : planetbmpmask.canvas.ellipse(0,round(i*0.0289),i,round(i*0.9689));
    6  : planetbmpmask.canvas.ellipse(round(i*0.2756),round(i*0.2978),round(i*0.7244),round(i*0.7));
    7  : planetbmpmask.canvas.ellipse(0,round(i*0.0133),i,round(i*0.9867));
    8  : planetbmpmask.canvas.ellipse(0,round(i*0.0133),i,round(i*0.9867));
    else planetbmpmask.canvas.ellipse(0,0,i,i);
  end;
  cnv.copymode:=cmSrcAnd;
  cnv.StretchDraw(DestR,planetbmpmask);
end;
cnv.copymode:=cmSrcPaint;
cnv.StretchDraw(DestR,planetbmp);
end;

(* procedure TSplot.MapGRSlongitude(GRSlongitude: double); //  No more necessary with Xplanet 1.2.0 !
var jup: TPicture;
    jup0: TPicture;
   {$ifdef mswindows}
      jupjpg: TJpegImage;
   {$endif}
    x0,i: integer;
    fn: WideString;
    f: textfile;
    longfn,buf:string;
begin
longfn:=slash(tempdir)+'jupiter0.long';
if  (OldGRSlong=-9999) and fileexists(longfn) then begin
   {$I-}
   assignfile(f,longfn);
   reset(f);
   readln(f,buf);
   closefile(f);
   {$I+}
   val(buf,OldGRSlong,i);
end;
if abs(GRSlongitude-OldGRSlong)>1 then begin
   jup:=TPicture.Create;
   jup0:=TPicture.Create;
   {$ifdef mswindows}
      jupjpg:=TJpegImage.Create;
   {$endif}
   try
   {$ifdef mswindows}
      jupjpg.loadfromfile(slash(appdir)+slash('data')+slash('planet')+'jupiter.jpg');
      jup.Bitmap.Assign(jupjpg);
   {$endif}
   {$ifdef linux}
      jup.loadfromfile(slash(appdir)+slash('data')+slash('planet')+'jupiter.jpg');
   {$endif}
   x0:=round((jup.width/2)+(jup.width/360)*(180-GRSlongitude));
   fn:=slash(tempdir)+'jupiter0.jpg';
   jup0.bitmap.width:=jup.width;
   jup0.bitmap.height:=jup.height;
   jup0.bitmap.canvas.copyrect(rect(0,0,jup.width-x0,jup.height),jup.bitmap.canvas,rect(x0,0,jup.width,jup.height));
   jup0.bitmap.canvas.copyrect(rect(jup.width-x0,0,jup.width,jup.height),jup.bitmap.canvas,rect(0,0,x0,jup.height));
   {$ifdef linux}
      QPixMap_save(jup0.Bitmap.Handle,@fn,PChar('JPEG'),30);
   {$endif}
   {$ifdef mswindows}
      jupjpg.Assign(jup0.Bitmap);
      jupjpg.CompressionQuality:=30;
      jupjpg.SaveToFile(fn);
   {$endif}
   OldGRSlong:=GRSlongitude;
   assignfile(f,longfn);
   buf:=formatfloat(f1,GRSlongitude);
   rewrite(f);
   writeln(f,buf);
   closefile(f);
   finally
   jup.free;
   jup0.free;
   {$ifdef mswindows}
      jupjpg.free;
   {$endif}
   end;
end;
end; *)

procedure TSplot.PlotPlanet3(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,pa,gw:double);
var ds,i : integer;
    cmd, searchdir: string;
    DestR :Trect;
const planetsize=450;
      moonsize=1000;
begin
if ipla=6 then ds:=round(maxvalue([2.2261*diam*pixscale/2,2*cfgchart.drawpen]))
          else ds:=round(maxvalue([diam*pixscale/2,2*cfgchart.drawpen]));
if (planetBMPpla<>ipla)or(abs(planetbmpjd-jdt)>0.000695)or(abs(planetbmprot-pa)>0.2) then begin
{ if ipla=5 then begin
    MapGRSlongitude(gw);     //  No more necessary with Xplanet 1.2.0 !
    searchdir:='"'+tempdir+'"';
    if not fileexists(slash(tempdir)+'xplanet.config') then
       exec('cp '+'"'+slash(appdir)+slash('data')+slash('planet')+'xplanet.config" '+'"'+slash(tempdir)+'xplanet.config"');
 end
 else}
 searchdir:='"'+slash(appdir)+slash('data')+'planet"';
 {$ifdef linux}
    cmd:='xplanet';
 {$endif}
 {$ifdef mswindows}
    chdir(xplanet_dir);
    cmd:='xplanet.exe';
 {$endif}
 cmd:=cmd+' -target '+pla[ipla]+' -origin earth -rotate '+
      stringreplace(formatfloat(f1,pa),'.',SysDecimalSeparator,[]) +
      ' -light_time -tt -num_times 1 -jd '+
      stringreplace(formatfloat(f5,jdt),'.',SysDecimalSeparator,[]) +
      ' -searchdir '+searchdir+
      ' -config xplanet.config -verbosity -1'+
      ' -radius 50'+
      ' -geometry 450x450 -output "'+slash(Tempdir)+'planet.jpg'+'"';
 if ipla=5 then cmd:=cmd+' -grs_longitude '+formatfloat(f1,gw);
 exec(cmd);
 xplanetimg.LoadFromFile(slash(Tempdir)+'planet.jpg');
 {$ifdef linux}
    planetbmp.Assign(xplanetimg);
 {$endif}
 {$ifdef mswindows}
    chdir(appdir);
    planetbmp.Canvas.Draw(0,0,xplanetimg.Graphic);
 {$endif}
 planetbmppla:=ipla;
 planetbmpjd:=jdt;
 planetbmprot:=pa;
end;
DestR:=Rect(xx-flipx*ds,yy-flipy*ds,xx+flipx*ds,yy+flipy*ds);
if not cfgplot.planetTransparent then begin
  i:=planetbmp.Width;
  planetbmpmask.Width:=i;
  planetbmpmask.Height:=i;
  planetbmpmask.canvas.brush.color:=clwhite;
  planetbmpmask.canvas.brush.style:=bssolid;
  planetbmpmask.canvas.pen.color:=clwhite;
  planetbmpmask.canvas.pen.width:=1;
  planetbmpmask.canvas.rectangle(0,0,i,i);
  planetbmpmask.canvas.pen.color:=clblack;
  planetbmpmask.canvas.brush.color:=clblack;
  case ipla of
    5  : planetbmpmask.canvas.ellipse(0,round(i*0.0289),i,round(i*0.9689));
    6  : planetbmpmask.canvas.ellipse(round(i*0.2756),round(i*0.2978),round(i*0.7244),round(i*0.7));
    7  : planetbmpmask.canvas.ellipse(0,round(i*0.0133),i,round(i*0.9867));
    8  : planetbmpmask.canvas.ellipse(0,round(i*0.0133),i,round(i*0.9867));
    else planetbmpmask.canvas.ellipse(0,0,i,i);
  end;
  cnv.copymode:=cmSrcAnd;
  cnv.StretchDraw(DestR,planetbmpmask);
end;
cnv.copymode:=cmSrcPaint;
cnv.StretchDraw(DestR,planetbmp);
end;

procedure TSplot.PlotEarthShadow(x,y: single; r1,r2,pixscale: double);
var
   ds1,ds2,xx,yy,xm,ym,i,j : Integer;
   mbmp,mask:tbitmap;
   P,M: Pbytearray;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then
with cnv do begin
 ds1:=round(maxvalue([r1*pixscale/2,2*cfgchart.drawpen]));
 ds2:=round(maxvalue([r2*pixscale/2,2*cfgchart.drawpen]));
 if ((xx+ds2)>0) and ((xx-ds2)<cfgchart.Width) and ((yy+ds2)>0) and ((yy-ds2)<cfgchart.Height) then begin
  case  cfgplot.nebplot of
   0: begin
      Pen.Width := cfgchart.drawpen;
      Pen.Color := cfgplot.Color[11];
      Brush.style:=bsClear;
      Ellipse(xx-ds1,yy-ds1,xx+ds1,yy+ds1);
      Brush.style:=bsClear;
      Ellipse(xx-ds2,yy-ds2,xx+ds2,yy+ds2);
      end;
   1: begin
      mbmp:=Tbitmap.Create;
      mask:=Tbitmap.Create;
      mask.PixelFormat:=pf32bit;
      mbmp.PixelFormat:=pf32bit;
      mbmp.Width:=2*ds2;
      mbmp.Height:=mbmp.Width;
      mask.Width:=mbmp.Width;
      mask.Height:=mbmp.Height;
      xm:=ds2;
      ym:=ds2;
      // mask=shadow to substract from the moon
      mask.Canvas.Pen.Color:=clBlack;
      mask.Canvas.Brush.Color:=clBlack;
      mask.Canvas.Rectangle(0,0,mask.Width,mask.Height);
      mask.Canvas.Pen.Color:=$080800;
      mask.Canvas.Brush.Color:=$080800;
      mask.Canvas.Ellipse(xm-ds2,ym-ds2,xm+ds2,ym+ds2);
      mask.Canvas.Pen.Color:=$101000;
      mask.Canvas.Brush.Color:=$101000;
      mask.Canvas.Ellipse(xm-ds1,ym-ds1,xm+ds1,ym+ds1);
      // get source bitmap from the chart
      mbmp.Canvas.CopyRect(rect(0,0,mbmp.Width,mbmp.Height),cnv,rect(xx-ds2,yy-ds2,xx+ds2,yy+ds2));
      mask.PixelFormat:=pf32bit;
      mbmp.PixelFormat:=pf32bit;
      // substract the shadow
      for i:= 0 to mbmp.Height-1 do begin
         P:=mbmp.ScanLine[i];
         M:=mask.ScanLine[i];
         for j:=0 to 4*(mbmp.Width-1) do begin
            P[j]:=max(0,round((P[j]-M[j])));
         end;
      end;
      // mask to erase anything outside the shadow
      mask.Canvas.Pen.Color:=clBlack;
      mask.Canvas.Brush.Color:=clBlack;
      mask.Canvas.Rectangle(0,0,mask.Width,mask.Height);
      mask.Canvas.Pen.Color:=clWhite;
      mask.Canvas.Brush.Color:=clWhite;
      mask.Canvas.Ellipse(xm-ds2,ym-ds2,xm+ds2,ym+ds2);
      mbmp.Canvas.copymode:=cmSrcAnd;
      mbmp.Canvas.copyrect(rect(xm-ds2,ym-ds2,xm+ds2,ym+ds2),mask.Canvas,rect(0,0,mbmp.Width,mbmp.Height));
      // mask to clear the destination
      mask.Canvas.Pen.Color:=clWhite;
      mask.Canvas.Brush.Color:=clWhite;
      mask.Canvas.Rectangle(0,0,mask.Width,mask.Height);
      mask.Canvas.Pen.Color:=clBlack;
      mask.Canvas.Brush.Color:=clBlack;
      mask.Canvas.Ellipse(xm-ds2,ym-ds2,xm+ds2,ym+ds2);
      copymode:=cmSrcAnd;
      copyrect(rect(xx-ds2,yy-ds2,xx+ds2,yy+ds2),mask.Canvas,rect(0,0,mbmp.Width,mbmp.Height));
      // finally copy back the image
      copymode:=cmSrcPaint;
      copyrect(rect(xx-ds2,yy-ds2,xx+ds2,yy+ds2),mbmp.Canvas,rect(0,0,mbmp.Width,mbmp.Height));
      mbmp.Free;
      mask.Free;
      end;  // 1
    end; // case
 end;  // if xx
end; // with
end;

Procedure TSplot.PlotSatel(x,y:single;ipla:integer; pixscale,ma,diam : double; hidesat, showhide : boolean);
var
  ds,ds2,xx,yy : Integer;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then
if not (hidesat xor showhide) then
   with cnv do begin
        Pen.Color := cfgplot.Color[0];
        Pen.Width := cfgchart.drawpen;
        Brush.style:=bsSolid;
        Pen.Mode := pmCopy;
        brush.color:=cfgplot.Color[11];
        ds := round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen);
        ds2:=round(diam*pixscale);
        if ds2>ds then begin
           ds:=ds2;
           brush.color:=cfgplot.Color[20];
           ds2:= round(ds/2);
           if ((xx+ds)>0) and ((xx-ds)<cfgchart.Width) and ((yy+ds)>0) and ((yy-ds)<cfgchart.Height) then begin
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
        end else PlotStar(x,y,ma,1020);                    
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
  pa:=deg2rad*pa+rot-pid2;
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
           if sqrt(ex*ex+ey*ey)<1.1*R then
              if be<0 then if n<=25 then Pen.Color:=cfgplot.Color[11]
                                    else Pen.Color:=cfgplot.Color[5]
                      else if n>25  then Pen.Color:=cfgplot.Color[11]
                                    else Pen.Color:=cfgplot.Color[5]
           else Pen.Color:=cfgplot.Color[11];
         end else
           if sqrt(ex*ex+ey*ey)<1.1*R then
              if be<0 then if n<=25 then Pen.mode := pmNot
                                    else Pen.mode := pmCopy
                      else if n>25  then Pen.mode := pmNot
                                    else Pen.mode := pmCopy
           else Pen.mode := pmCopy;                         
         lineto(ex1,ey1);
       end;
       th:=th+step;
     end;
   end;
   Pen.mode := pmCopy;
  end;
end;

Procedure TSplot.PlotAsteroid(x,y:single;symbol: integer; ma : Double);
var
  ds,xx,yy : Integer;
  diamond: array[0..3] of TPoint;
begin
xx:=round(x);
yy:=round(y);
with cnv do begin
   Pen.Color := cfgplot.Color[0];
   Pen.Width := cfgchart.DrawPen;
   Pen.Mode := pmCopy;
   Brush.Color := cfgplot.Color[20];
   Brush.style:=bsSolid;
   case symbol of
   0 : begin
     ds:=3*cfgchart.drawpen;
     diamond[0]:=point(xx,yy-ds);
     diamond[1]:=point(xx+ds,yy);
     diamond[2]:=point(xx,yy+ds);
     diamond[3]:=point(xx-ds,yy);
     Polygon(diamond);
     end;
   1 : begin
     plotstar(x,y,ma,1020);
     end;
   end;
end;
end;

Procedure TSplot.PlotComet(x,y,cx,cy:single;symbol: integer; ma,diam,PixScale : Double);
var ds,ds1,xx,yy,cxx,cyy,i,j,co:integer;
    cp1,cp2: array[0..3] of TPoint;
    cr,cg,cb: byte;
    Col: Tcolor;
    dx,dy,a,r,k : double;
begin
xx:=round(x);
yy:=round(y);
cxx:=round(cx);
cyy:=round(cy);
with cnv do begin
   Pen.Color := cfgplot.Color[0];
   Pen.Width := cfgchart.DrawPen;
   Pen.Mode := pmCopy;
   Brush.Color := cfgplot.Color[21];
   Brush.style:=bsSolid;
   dx:=cxx-xx;
   dy:=cyy-yy;
   if (symbol=1)and(cfgplot.nebplot=0) then symbol:=2;
   case symbol of
   0: begin
        ds:=2*cfgchart.drawpen;
        Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
        Pen.Color := cfgplot.Color[21];
        moveto(xx,yy);
        lineto(xx-4*ds,yy-4*ds);
        moveto(xx,yy);
        lineto(xx-2*ds,yy-4*ds);
        moveto(xx,yy);
        lineto(xx-4*ds,yy-2*ds);
      end;
   1: begin
        r:=sqrt(dx*dx+dy*dy);
        r:=maxvalue([r,12*cfgchart.drawpen]);
        a:=arctan2(dy,dx);
        if ma<5 then k:=1
        else if ma>18 then k:=0.5
        else k:=1-(ma-5)*0.0385;
        cr:=round(k*(cfgplot.Color[21] and $FF));
        cg:=round(k*((cfgplot.Color[21] shr 8) and $FF));
        cb:=round(k*((cfgplot.Color[21] shr 16) and $FF));
        pen.Mode:=pmCopy;
        brush.Style:=bsSolid;
        ds:=round(maxvalue([PixScale*diam/2,2*cfgchart.drawpen]));
        for i:=19 downto 0 do begin
          co:=max(0,255-i*10);
          Col:=(cr*co div 255)+256*(cg*co div 255)+65536*(cb*co div 255);
          Col:=Addcolor(Col,cfgplot.backgroundcolor);
          pen.Color:=Col;
          brush.Color:=Col;
          ds1:=round((i+1)*ds/20);
          Ellipse(xx-ds1,yy-ds1,xx+ds1,yy+ds1);
        end;
        if (dx<>0)or(dy<>0) then for i:=0 to 9 do begin
         cp1[2].X:=xx;
         cp1[2].Y:=yy;
         cp1[3].X:=xx;
         cp1[3].Y:=yy;
         cp2:=cp1;
         r:=0.99*r;
         for j:=0 to 19 do begin
          co:=max(0,255-i*14-j*10);
          Col:=(cr*co div 255)+256*(cg*co div 255)+65536*(cb*co div 255);
          Col:=Addcolor(Col,cfgplot.backgroundcolor);
          pen.Color:=Col;
          brush.Color:=Col;
          cp1[0].X:=cp1[3].X;
          cp1[0].Y:=cp1[3].Y;
          cp1[1].X:=cp1[2].X;
          cp1[1].Y:=cp1[2].Y;
          cp1[2].X:=xx+round((j+1)*r/20*cos(a+0.015*(i)));
          cp1[2].Y:=yy+round((j+1)*r/20*sin(a+0.015*(i)));
          cp1[3].X:=xx+round((j+1)*0.99*r/20*cos(a+0.015*(i+1)));
          cp1[3].Y:=yy+round((j+1)*0.99*r/20*sin(a+0.015*(i+1)));
          polygon(cp1);
          cp2[0].X:=cp2[3].X;
          cp2[0].Y:=cp2[3].Y;
          cp2[1].X:=cp2[2].X;
          cp2[1].Y:=cp2[2].Y;
          cp2[2].X:=xx+round((j+1)*r/20*cos(a-0.015*(i)));
          cp2[2].Y:=yy+round((j+1)*r/20*sin(a-0.015*(i)));
          cp2[3].X:=xx+round((j+1)*0.99*r/20*cos(a-0.015*(i+1)));
          cp2[3].Y:=yy+round((j+1)*0.99*r/20*sin(a-0.015*(i+1)));
          polygon(cp2);
         end;
        end;
        PlotStar(xx,yy,ma,1021);
      end;
   2: begin
        ds:=round(maxvalue([3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma)])*cfgchart.drawpen/2);
        Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
        ds:=round(maxvalue([PixScale*diam/2,2*cfgchart.drawpen]));
        Brush.style:=bsClear;
        Pen.Color := cfgplot.Color[21];
        Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
        Pen.Color := cfgplot.Color[0];
        ds:=ds+cfgchart.drawpen;
        Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
        Brush.style:=bsSolid;
        r:=sqrt(dx*dx+dy*dy);
        r:=maxvalue([r,12*cfgchart.drawpen]);
        a:=arctan2(dy,dx);
        cxx:=xx+round(r*cos(a));
        cyy:=yy+round(r*sin(a));
        PlotLine(xx+cfgchart.drawpen,yy+cfgchart.drawpen,cxx+cfgchart.drawpen,cyy+cfgchart.drawpen,cfgplot.Color[0],1);
        PlotLine(xx,yy,cxx,cyy,cfgplot.Color[21],1);
        r:=0.9*r;
        cxx:=xx+round(r*cos(a+0.18));
        cyy:=yy+round(r*sin(a+0.18));
        PlotLine(xx+cfgchart.drawpen,yy+cfgchart.drawpen,cxx+cfgchart.drawpen,cyy+cfgchart.drawpen,cfgplot.Color[0],1);
        PlotLine(xx,yy,cxx,cyy,cfgplot.Color[21],1);
        cxx:=xx+round(r*cos(a-0.18));
        cyy:=yy+round(r*sin(a-0.18));
        PlotLine(xx+cfgchart.drawpen,yy+cfgchart.drawpen,cxx+cfgchart.drawpen,cyy+cfgchart.drawpen,cfgplot.Color[0],1);
        PlotLine(xx,yy,cxx,cyy,cfgplot.Color[21],1);
      end;
   end;
end;
end;

function TSplot.PlotLabel(i,xx,yy,r,labelnum,fontnum:integer; Xalign,Yalign:TLabelAlign; WhiteBg,forcetextlabel:boolean; txt:string):integer;
var ts:TSize;
begin
// If drawing to the printer force to plot the text label to the canvas
// even if label editing is selected
if (cfgchart.onprinter or forcetextlabel) then begin
with cnv do begin
  Brush.Style:=bsClear;
  Pen.Mode:=pmCopy;
  {$ifdef linux} Font.CharSet:=fcsAnyCharSet; {$endif}
  {$ifdef mswindows} Font.CharSet:=DEFAULT_CHARSET; {$endif}
  Font.Name:=cfgplot.FontName[fontnum];
  if WhiteBg then Font.Color:=clBlack
     else Font.Color:=cfgplot.LabelColor[labelnum];
  Font.Size:=cfgplot.LabelSize[labelnum]*cfgchart.fontscale;
  if cfgplot.FontBold[fontnum] then Font.Style:=[fsBold] else Font.Style:=[];
  if cfgplot.FontItalic[fontnum] then font.style:=font.style+[fsItalic];
  ts:=cnv.TextExtent(txt);
  if r>=0 then begin
  case Xalign of
   laLeft   : xx:=xx+labspacing*cfgchart.drawpen+r;
   laRight  : xx:=xx-ts.cx-labspacing*cfgchart.drawpen-r;
   laCenter : xx:=xx-(ts.cx div 2);
  end;
  case Yalign of
   laBottom : yy:=yy-ts.cy;
   laCenter : yy:=yy-(ts.cy div 2);
  end;
  end;
  textout(xx,yy,txt);
end;
// If drawing to the screen use movable label 
end else begin
if i>maxlabels then begin
  result:=-1;
  exit;
end;
with labels[i] do begin
  Color:=cfgplot.Color[0];
  Transparent:=true;
  Font.Name:=cfgplot.FontName[fontnum];
  Font.Color:=cfgplot.LabelColor[labelnum];
  if WhiteBg and (Font.Color=clWhite) then Font.Color:=clBlack;
  Font.Size:=cfgplot.LabelSize[labelnum];
  if cfgplot.FontBold[fontnum] then Font.Style:=[fsBold] else Font.Style:=[];
  if cfgplot.FontItalic[fontnum] then font.style:=font.style+[fsItalic];
  caption:=txt;
  //tag:=id;
  if r>=0 then begin
    case Xalign of
     laLeft   : xx:=xx+labspacing+r;
     laRight  : xx:=xx-width-labspacing-r;
     laCenter : xx:=xx-(width div 2);
    end;
    case Yalign of
     //laTop
     laBottom : yy:=yy-height;
     laCenter : yy:=yy-(height div 2);
    end;
  end;
  left:=xx;
  top:=yy;
  visible:=true;
end;
end;
result:=0;
end;

procedure TSplot.PlotText(xx,yy,fontnum,color:integer; Xalign,Yalign:TLabelAlign; txt:string);
var ts:TSize;
begin
with cnv do begin
Brush.Color:=cfgplot.Color[0];
Brush.Style:=bsSolid;
Pen.Mode:=pmCopy;
Font.Name:=cfgplot.FontName[fontnum];
Font.Color:=color;
if Font.Color=Brush.Color then Font.Color:=(not Font.Color)and $FFFFFF;
Font.Size:=cfgplot.FontSize[fontnum]*cfgchart.fontscale;
if cfgplot.FontBold[fontnum] then Font.Style:=[fsBold] else Font.Style:=[];
if cfgplot.FontItalic[fontnum] then font.style:=font.style+[fsItalic];
ts:=cnv.TextExtent(txt);
case Xalign of
 laRight  : xx:=xx-ts.cx;
 laCenter : xx:=xx-(ts.cx div 2);
end;
case Yalign of
 laBottom : yy:=yy-ts.cy;
 laCenter : yy:=yy-(ts.cy div 2);
end;
textout(xx,yy,txt);
end;
end;

procedure TSplot.PlotTextCR(xx,yy,fontnum,labelnum:integer; txt:string);
var ls,p:Integer;
    buf: string;
begin
with cnv do begin
Brush.Color:=cfgplot.backgroundcolor;
Brush.Style:=bsSolid;
Pen.Mode:=pmCopy;
Font.Name:=cfgplot.FontName[fontnum];
Font.Color:=cfgplot.LabelColor[labelnum];
if Font.Color=Brush.Color then Font.Color:=(not Font.Color)and $FFFFFF;
Font.Size:=cfgplot.LabelSize[labelnum]*cfgchart.fontscale;
if cfgplot.FontBold[fontnum] then Font.Style:=[fsBold] else Font.Style:=[];
if cfgplot.FontItalic[fontnum] then font.style:=font.style+[fsItalic];
ls:=cnv.TextHeight('A');
repeat
  p:=pos(crlf,txt);
  if p=0 then buf:=txt
    else begin
      buf:=copy(txt,1,p-1);
      delete(txt,1,p+1);
  end;
  textout(xx,yy,buf);
  yy:=yy+ls;
until p=0;
end;
end;

function TSplot.ClipVector(var x1,y1,x2,y2: integer;var clip1,clip2:boolean):boolean;
var
 side,side1,side2:  TSideSet;
 x,y: double;
 xR,xL,yU,yD: integer;
  procedure GetSide (x,y:integer; var side: TSideSet);
  begin
    side := [];
    if x < xL then side := [L]
    else if x > xR then side := [R];
    if y < yU then side := side + [U]
    else if y > yD then side := side + [D]
  end;
  procedure doClip;
  var deltaX,deltaY: double;
  begin
    deltaX := x2-x1;
    deltaY := y2-y1;
    if R in side then begin
       x:=xR;
       y:=y1+deltaY*(xR-x1)/deltaX;
    end
    else if L in side then begin
       x:=xL;
       y:=y1+deltaY*(xL-x1)/deltaX;
    end
    else if D in side then begin
       x:=x1+deltaX*(yD-y1)/deltaY;
       y:=yD;
    end
    else if U in side then begin
       x:=x1+deltaX*(yU-y1)/deltaY;
       y:=yU;
    end;
  end;
begin
  xL:=-cliparea;
  xR:=cfgchart.Width+cliparea;
  yU:=-cliparea;
  yD:=cfgchart.Height+cliparea;
  GetSide(x1,y1,side1);
  GetSide(x2,y2,side2);
  result:=(side1*side2=[]);
  clip1:=false;
  clip2:=false;
  while ((side1<>[])or(side2<>[]))and result do begin
    side:=side1;
    if side = [] then side:=side2;
    doclip;
    if side = side1 then begin
      clip1:=true;
      x1:=round(x);
      y1:=round(y);
      GetSide(x1,y1,side1);
    end else begin
      clip2:=true;
      x2:=round(x);
      y2:=round(y);
      GetSide(x2,y2,side2);
    end;
    result:=(side1*side2=[]);
  end;
end;

procedure TSplot.labelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var pt:Tpoint;
begin
if editlabel<0 then with Sender as Tlabel do begin
pt:=clienttoscreen(point(x,y));
if button=mbRight then begin
  selectedlabel:=tag;
  editlabelx:=pt.x;
  editlabely:=pt.y;
  editlabelmod:=false;
  editlabelmenu.Items[0].Caption:=labels[selectedlabel].Caption;
  editlabelmenu.popup(pt.x,pt.y);
end else if button=mbLeft then begin
  if assigned(FLabelClick) then FLabelClick(tag);
end;
end;
end;

procedure TSplot.labelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var pt:Tpoint;
begin
if editlabel>0 then with Sender as Tlabel do begin
  pt:=clienttoscreen(point(x,y));
  labels[editlabel].left:=labels[editlabel].Left+pt.X-editlabelX;
  labels[editlabel].Top:=labels[editlabel].Top+pt.Y-editlabelY;
  editlabelx:=pt.x;
  editlabely:=pt.y;
  editlabelmod:=true;
end;
end;

procedure TSplot.labelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if editlabel>0 then begin
  labels[editlabel].Transparent:=true;
  labels[editlabel].Cursor:=crDefault;
  if editlabelmod and assigned(FEditLabelPos) then FEditLabelPos(editlabel,labels[editlabel].left,labels[editlabel].top);
end;
editlabel:=-1;
end;

procedure TSplot.labelMouseLeave(Sender: TObject);
begin
if editlabel>0 then begin
 // force the label to the cursor while editing
 labels[editlabel].left:=labels[editlabel].Left+mouse.CursorPos.x-editlabelX;
 labels[editlabel].Top:=labels[editlabel].Top+mouse.CursorPos.y-editlabelY;
 editlabelx:=mouse.CursorPos.x;
 editlabely:=mouse.CursorPos.y;
end;
end;

Procedure TSplot.Movelabel(Sender: TObject);
begin
mouse.CursorPos:=point(editlabelx,editlabely);
editlabel:=selectedlabel;
labels[editlabel].Transparent:=false;
labels[editlabel].Cursor:=crSizeAll;
end;

Procedure TSplot.EditlabelTxt(Sender: TObject);
begin
if (selectedlabel>0)and assigned(FEditLabelTxt) then FEditLabelTxt(selectedlabel,editlabelx,editlabely);
end;

Procedure TSplot.DefaultLabel(Sender: TObject);
begin
if (selectedlabel>0)and assigned(FDefaultLabel) then FDefaultLabel(selectedlabel);
end;

Procedure TSplot.Deletelabel(Sender: TObject);
begin
if (selectedlabel>0)and assigned(FDeleteLabel) then FDeleteLabel(selectedlabel);
end;

Procedure TSplot.DeleteAlllabel(Sender: TObject);
begin
if assigned(FDeleteAllLabel) then FDeleteAllLabel(0);
end;

Procedure TSplot.PlotCircle(x1,y1,x2,y2:single;color: integer;moving:boolean);
begin
with cnv do begin
  Pen.Width:=cfgchart.drawpen;
  if moving then begin
     Pen.Color:=clWhite;
     Pen.Mode:=pmXor;
  end else begin
     Pen.Color:=color;
     Pen.Mode:=pmCopy;
  end;
  Brush.Style:=bsClear;
  Ellipse(round(x1),round(y1),round(x2),round(y2));
end;
end;

Procedure TSplot.PlotPolyLine(p:array of Tpoint; color:integer; moving:boolean);
begin
with cnv do begin
  Pen.Width:=cfgchart.drawpen;
  if moving then begin
     Pen.Color:=clWhite;
     Pen.Mode:=pmXor;
  end else begin
     Pen.Color:=color;
     Pen.Mode:=pmCopy;
  end;
  Polyline(p);
end;
end;

end.

