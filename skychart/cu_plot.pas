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
{$mode delphi}{$H+}

interface

uses u_translation, FileUtil, BGRABitmap, BGRABitmapTypes,
  u_constant, u_util, u_planetrender, u_bitmap, PostscriptCanvas,
  SysUtils, Types, StrUtils, FPImage, LCLType, LCLIntf, IntfGraphics, FPCanvas,
  Menus, StdCtrls, Dialogs, Controls, ExtCtrls, Math, Classes, Graphics;


type

  TSide   = (U,D,L,R);  // Up, Down, Left, Right
  TSideSet = set of TSide;
  TEditLabelPos = procedure(lnum,left,top: integer) of object;
  Tintfunc = procedure(i: integer) of object;
  Tvoidfunc = procedure of object;

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
     FDeleteAllLabel: Tvoidfunc;
     FLabelClick: Tintfunc;
     PlanetBMPs: Tbitmap;
     PlanetBMP : Tbitmap;
     XplanetImg: TPicture;
     PlanetBMPjd,PlanetBMProt : double;
     PlanetBMPpla : integer;
     Xplanetrender: boolean;
     IntfImgReady: boolean;
     OldGRSlong: double;
     TransparentColor : TFPColor;
     Procedure PlotStar0(x,y: single; ma,b_v : Double);
     Procedure PlotStar1(x,y: single; ma,b_v : Double);
     Procedure PlotStar2(x,y: single; ma,b_v : Double);
     procedure PlotPlanet1(xx,yy,ipla:integer; pixscale,diam:double);
     procedure PlotPlanet2(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,phase,pa,poleincl,sunincl,w,gw:double;WhiteBg:boolean);
     procedure PlotPlanet3(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,pa,gw:double;WhiteBg:boolean);
     procedure PlotPlanet4(xx,yy,ipla:integer; pixscale:double;WhiteBg:boolean);
     procedure PlotPlanet5(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,rot:double;WhiteBg:boolean; size,margin:integer);
     procedure PlotSatRing1(xx,yy:integer; pixscale,pa,rot,r1,r2,diam,be : double; WhiteBg:boolean);
     procedure BezierSpline(pts : array of Tpoint;n : integer);
     function  ClipVector(var x1,y1,x2,y2: integer;var clip1,clip2:boolean):boolean;
     procedure labelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
     procedure labelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
     procedure labelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
     procedure labelMouseLeave(Sender: TObject);
     procedure Setstarshape(value:Tbitmap);
     procedure InitXPlanetRender;
     procedure SetImage(value:TCanvas);
     procedure InitStarBmp;
  protected
    { Protected declarations }
  public
    { Public declarations }
    cfgplot : Tconf_plot;
    cfgchart: Tconf_chart;
    cbmp : TBGRABitmap;
    cnv, destcnv  : Tcanvas;
    Fstarshape,starbmp,compassrose,compassarrow: Tbitmap;
    Astarbmp: array [0..6,0..10] of Tbitmap;
    Bstarbmp: array [0..6,0..10] of TBGRABitmap;
    starbmpw:integer;
    IntfImg : TLazIntfImage;
    editlabelmenu: Tpopupmenu;
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
  published
    { Published declarations }
     function Init(w,h : integer) : boolean;
     function InitLabel : boolean;
     procedure ClearImage;
     Procedure FlushCnv;
     Procedure InitPixelImg;
     Procedure ClosePixelImg;
     Procedure PlotBorder(LeftMargin,RightMargin,TopMargin,BottomMargin: integer);
     Procedure PlotStar(xx,yy: single; ma,b_v : Double);
     Procedure PlotVarStar(x,y: single; vmax,vmin : Double);
     Procedure PlotDblStar(x,y,r: single; ma,sep,pa,b_v : Double);
//--------------------------------------------
      Procedure PlotDeepSkyObject(Axx,Ayy: single;Adim,Ama,Asbr,Apixscale:Double;Atyp:Integer;Amorph:String);
      Procedure PlotDSOGxy(Ax,Ay: single; Ar1,Ar2,Apa,Arnuc,Ab_vt,Ab_ve,Ama,Asbr,Apixscale : double;Amorph:string);
      Procedure PlotDSOOcl(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
      procedure PlotDSOPNe(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
      procedure PlotDSOGCl(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
      procedure PlotDSOBN(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
      Procedure PlotDSOClNb(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
      procedure PlotDSOStar(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
      procedure PlotDSODStar(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
      procedure PlotDSOTStar(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
      procedure PlotDSOAst(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
      Procedure PlotDSOHIIRegion(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
      Procedure PlotDSOGxyCl(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
      Procedure PlotDSODN(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
      Procedure PlotDSOUnknown(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
      Procedure PlotDSOCircle(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
      Procedure PlotDSOlozenge(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
      Procedure PlotDSORectangle(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
//---------------------------------------------
     Procedure PlotCRose(rosex,rosey,roserd,rot:single;flipx,flipy:integer; WhiteBg:boolean; RoseType: integer);
     Procedure PlotLine(x1,y1,x2,y2:single; lcolor,lwidth: integer; style:TFPPenStyle=psSolid);
     Procedure PlotImage(xx,yy: single; iWidth,iHeight,Rotation : double; flipx, flipy :integer; WhiteBg, iTransparent : boolean;var ibmp:TBitmap; TransparentMode:integer=0);
     procedure PlotPlanet(x,y: single;flipx,flipy,ipla:integer; jdt,pixscale,diam,magn,phase,pa,rot,poleincl,sunincl,w,r1,r2,be:double;WhiteBg:boolean;size:integer=0;margin:integer=0);
     procedure PlotEarthShadow(x,y: single; r1,r2,pixscale: double);
     procedure PlotSatel(x,y:single;ipla:integer; pixscale,ma,diam : double; hidesat, showhide : boolean);
     Procedure PlotAsteroid(x,y:single;symbol: integer; ma : Double);
     Procedure PlotComet(x,y,cx,cy:single;symbol: integer; ma,diam,PixScale : Double);
     procedure TextOutAntiAlias(x, y: single; s: string; c: TBGRAPixel);
     function  PlotLabel(i,labelnum,fontnum:integer; xxs,yys,rs:single; Xalign,Yalign:TLabelAlign; WhiteBg,forcetextlabel:boolean; txt:string; opaque:boolean=false):integer;
     procedure PlotText(xx,yy,fontnum,lcolor:integer; Xalign,Yalign:TLabelAlign; txt:string; opaque:boolean=true; clip:boolean=false; marge: integer=5);
     procedure PlotTextCR(xx,yy,fontnum,labelnum:integer; txt:string; WhiteBg: boolean; opaque:boolean=true);
     procedure PlotOutline(x,y:single;op,lw,fs,closed: integer; r2:double; col: Tcolor);
     Procedure PlotCircle(x1,y1,x2,y2:single;lcolor:integer;moving:boolean);
     Procedure PlotPolyLine(p:array of Tpoint; lcolor:integer; moving:boolean);
     procedure FloodFill(X, Y: Integer; FillColor: TColor);
     property Starshape: TBitmap read Fstarshape write Setstarshape;
     property OnEditLabelPos: TEditLabelPos read FEditLabelPos write FEditLabelPos;
     property OnEditLabelTxt: TEditLabelPos read FEditLabelTxt write FEditLabelTxt;
     property OnDefaultLabel: Tintfunc read FDefaultLabel write FDefaultLabel;
     property OnDeleteLabel: Tintfunc  read FDeleteLabel write FDeleteLabel;
     property OnDeleteAllLabel: Tvoidfunc read FDeleteAllLabel write FDeleteAllLabel;
     property OnLabelClick: Tintfunc read FLabelClick write FLabelClick;
     Procedure Movelabel(Sender: TObject);
     Procedure EditlabelTxt(Sender: TObject);
     Procedure DefaultLabel(Sender: TObject);
     Procedure Deletelabel(Sender: TObject);
     Procedure DeleteAlllabel(Sender: TObject);
     property Image: TCanvas write SetImage;

  end;

  const cliparea = 10;
  
Implementation

constructor TSplot.Create(AOwner:TComponent);
var i,j : integer;
    MenuItem: TMenuItem;
begin
 inherited Create(AOwner);
for i:=0 to 6 do
  for j:=0 to 10 do begin
    Astarbmp[i,j]:=Tbitmap.create;
    Bstarbmp[i,j]:=TBGRABitmap.create;
  end;
 starbmp:=Tbitmap.Create;
 cbmp:=TBGRABitmap.Create;
 cnv:=cbmp.canvas;
 cfgplot:=Tconf_plot.Create;
 cfgchart:=Tconf_chart.Create;
 // set safe value
 starbmpw:=1;
 editlabel:=-1;
 cbmp.SetSize(100,100);
 cfgchart.width:=100;
 cfgchart.height:=100;
 cfgchart.min_ma:=6;
 cfgchart.onprinter:=false;
 cfgchart.drawpen:=1;
 cfgchart.drawsize:=1;
 cfgchart.fontscale:=1;
 TransparentColor.red:= 0;
 TransparentColor.green:=0;
 TransparentColor.blue:= 0;
 TransparentColor.alpha:=65535;
 IntfImgReady:=false;
 InitPlanetRender;
 InitXPlanetRender;
 try
 if planetrender or Xplanetrender then begin
    planetbmp:=Tbitmap.create;
    planetbmp.Width:=450;
    planetbmp.Height:=450;
    planetbmps:=Tbitmap.create;
    planetbmps.Width:=450;
    planetbmps.Height:=450;
    xplanetimg:=TPicture.create;
 end;
 if planetrender then begin
    settexturepath(slash(appdir)+slash('data')+slash('planet'));
    // try if it work
    planetrender:=false;
    RenderPluto(0,0,0,0,0,1,planetbmp.width,slash(Tempdir)+'planet.bmp');
    // we are here! so it don't crash, reset the value.
    planetrender:=true;
 end;
 except
   planetrender:=false;
 end;
 for i:=1 to maxlabels do begin
    labels[i]:=Tlabel.Create(nil);
    labels[i].parent:=TPanel(AOwner);
    labels[i].tag:=i;
    labels[i].color:=clNone;
    labels[i].ShowAccelChar:=false;
    labels[i].Font.CharSet:=FCS_ISO_10646_1;
    labels[i].PopupMenu:=editlabelmenu;
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
 MenuItem.Caption := rsMoveLabel;
 MenuItem.OnClick := MoveLabel;
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := rsEditLabel;
 MenuItem.OnClick := EditLabelTxt;
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := rsDefaultLabel;
 MenuItem.OnClick := DefaultLabel;
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := rsHideLabel;
 MenuItem.OnClick := DeleteLabel;
 MenuItem := TMenuItem.Create(editlabelmenu);
 editlabelmenu.Items.Add(MenuItem);
 MenuItem.Caption := rsResetAllLabe;
 MenuItem.OnClick := DeleteAllLabel;
end;

destructor TSplot.Destroy;
var i,j:integer;
begin
try
 for i:=1 to maxlabels do labels[i].Free;
for i:=0 to 6 do
  for j:=0 to 10 do begin
     Astarbmp[i,j].free;
     Bstarbmp[i,j].free;
  end;
 starbmp.Free;
 cbmp.Free;
 cfgplot.Free;
 cfgchart.Free;
 if planetrender then begin
    ClosePlanetRender;
 end;
 if planetrender or Xplanetrender then begin
    planetbmp.Free;
    planetbmps.Free;
    xplanetimg.Free;
 end;
 inherited destroy;
except
writetrace('error destroy '+name);
end;
end;

procedure TSplot.SetImage(value:TCanvas);
begin
 destcnv:=value;
end;

procedure TSplot.ClearImage;
begin
if cfgplot.UseBMP then begin
   cbmp.Fill(cfgplot.Color[0]);
end else with cnv do begin
 Brush.Color:=cfgplot.Color[0];
 Pen.Color:=cfgplot.Color[0];
 Brush.style:=bsSolid;
 Pen.Mode:=pmCopy;
 Pen.Style:=psSolid;
 Rectangle(0,0,cfgchart.Width,cfgchart.Height);
end;
end;

function TSplot.Init(w,h : integer) : boolean;
var Rgn : HRGN;
begin
cfgchart.Width:=w;
cfgchart.Height:=h;
if cfgplot.UseBMP then begin
  cbmp.SetSize(w,h);
  cnv:=nil; // to be sure we no more use it!
end else begin
  cnv:=destcnv
end;
ClearImage;
if not cfgplot.UseBMP then
with cnv do begin
 Font.CharSet:=FCS_ISO_10646_1;
{$ifndef lclqt}      // problem with QT clipping
 if cfgchart.onprinter then begin
     Rgn:=CreateRectRgn(cfgplot.xmin, cfgplot.ymin, cfgplot.xmax, cfgplot.ymax);
     SelectClipRgn(cnv.Handle, Rgn);
     DeleteObject(Rgn);
 end;
{$endif}
end;
InitLabel;
if (cfgplot.starplot>0)and(cfgchart.drawsize<>starbmpw)and(Fstarshape<>nil) then begin
   starbmpw:=cfgchart.drawsize;
   BitmapResize(Fstarshape,starbmp,starbmpw);
   InitStarBmp;
end;
result:=true;
end;

Procedure TSplot.PlotBorder(LeftMargin,RightMargin,TopMargin,BottomMargin: integer);
var xmin,xmax,ymin,ymax: integer;
begin
  if (not cfgplot.UseBMP)and((LeftMargin>0)or(RightMargin>0)or(TopMargin>0)or(BottomMargin>0)) then begin
      with cnv do begin
        Pen.Color := clWhite;
        Pen.Width := 1;
        Pen.Mode := pmCopy;
        Brush.Color := clWhite;
        Brush.Style := bsSolid;
        xmin:=0; ymin:=0;
        xmax:=cfgchart.width;
        ymax:=cfgchart.height;
        Rectangle(xmin,ymin,xmin+LeftMargin,ymax);
        Rectangle(xmax-RightMargin,ymin,xmax,ymax);
        Rectangle(xmin,ymin,xmax,ymin+TopMargin);
        Rectangle(xmin,ymax-BottomMargin,xmax,ymax);
        Pen.Color := clBlack;
        Pen.Width := 2*cfgchart.drawpen;
        Brush.Color := clWhite;
        moveto(xmin+LeftMargin,ymin+TopMargin);
        lineto(xmin+LeftMargin,ymax-BottomMargin);
        moveto(xmin+LeftMargin,ymax-BottomMargin);  // Postscriptcanvas do not move after line
        lineto(xmax-RightMargin,ymax-BottomMargin);
        moveto(xmax-RightMargin,ymax-BottomMargin);
        lineto(xmax-RightMargin,ymin+TopMargin);
        moveto(xmax-RightMargin,ymin+TopMargin);
        lineto(xmin+LeftMargin,ymin+TopMargin);
      end;
  end;
end;

procedure TSplot.InitXPlanetRender;
begin
 OldGRSlong:=-9999;
 Xplanetrender:=true;
end;

Procedure TSplot.InitPixelImg;
begin
{if (cfgplot.starplot=2) then begin
  cbmp.LoadFromBitmapIfNeeded;
  IntfImgReady:=true;
end;}
end;

Procedure TSplot.ClosePixelImg;
begin
{if IntfImgReady then begin
    if not cfgchart.onprinter then begin
       cbmp.InvalidateBitmap;
    end;
  end;
IntfImgReady:=false; }
end;

Procedure TSplot.FlushCnv;
begin
if cfgplot.UseBMP then begin
 cbmp.LoadFromBitmapIfNeeded;
 cbmp.Draw(destcnv,0,0,true); // draw bitmap to screen
end else begin
 destcnv.CopyMode:=cmSrcCopy;
 destcnv.Draw(0,0,cbmp.Bitmap);
end;
cnv:=destcnv;           // direct plot to screen;
end;

procedure TSplot.Setstarshape(value:Tbitmap);
begin
Fstarshape:=value;
starbmpw:=1;
starbmp.Assign(Fstarshape);
InitStarBmp;
end;

//todo: check if alpha transparency work
{$IFDEF LCLGTK}  {$DEFINE OLD_MASK_TRANSPARENCY} {$ENDIF}
{$IFDEF LCLQT} {$DEFINE OLD_MASK_TRANSPARENCY} {$ENDIF}
procedure SetTransparencyFromLuminance(bmp:Tbitmap; method: integer);
var
  memstream:Tmemorystream;
  IntfImage: TLazIntfImage;
  x,y: Integer;
  newalpha : word;
  CurColor: TFPColor;
  ImgHandle, ImgMaskHandle: HBitmap;
begin
try
if (bmp.Width<2)or(bmp.Height<2) then exit;
    IntfImage:=nil;
    try
      IntfImage:=bmp.CreateIntfImage;
      for y:=0 to IntfImage.Height-1 do begin
        for x:=0 to IntfImage.Width-1 do begin
          CurColor:=IntfImage.Colors[x,y];
          newalpha:=MaxIntValue([CurColor.red,CurColor.green,CurColor.blue]);
          case method of
          0: begin  // linear for nebulae
             {$IF DEFINED(OLD_MASK_TRANSPARENCY)}
                if newalpha<=(0) then
                    CurColor:=colTransparent
                else
                    CurColor.alpha:=alphaOpaque;
             {$ELSE}
                {$IFDEF LCLGTK2}
                CurColor.alpha:=MinIntValue([alphaOpaque,newalpha * 3]);
                {$ELSE}
                CurColor.alpha:=newalpha;
                {$ENDIF}
             {$ENDIF}
             end;
          1: begin  // hard contrast for bitmap stars
       //      {$IF DEFINED(OLD_MASK_TRANSPARENCY) or DEFINED(LCLGTK2)}
                if newalpha<(50*255) then
                    CurColor:=colTransparent
                else
                    CurColor.alpha:=alphaOpaque;
    //         {$ELSE}
     {           if (newalpha>200*255) then newalpha:=alphaOpaque;
                if (newalpha<100*255) then newalpha:=newalpha div 2;
                if (newalpha<500) then newalpha:=alphaTransparent;
                CurColor.alpha:=newalpha;  }
     //        {$ENDIF}
             end;
          2: begin  // black transparent
                if newalpha<=(0) then
                    CurColor:=colTransparent
                else
                    CurColor.alpha:=alphaOpaque;
             end;
           end;
          IntfImage.Colors[x,y]:=CurColor;
        end;
      end;
      IntfImage.CreateBitmaps(ImgHandle, ImgMaskHandle);
      bmp.SetHandles(ImgHandle, ImgMaskHandle);
//     {$IF DEFINED(OLD_MASK_TRANSPARENCY) or DEFINED(LCLGTK2)}
      memstream:=Tmemorystream.create;
      bmp.SaveToStream(memstream);
      memstream.position := 0;
      bmp.LoadFromStream(memstream);
      bmp.Transparent:=true;
//      {$ELSE}
 {      if isWin98 then begin
         memstream:=Tmemorystream.create;
         bmp.SaveToStream(memstream);
         memstream.position := 0;
         bmp.LoadFromStream(memstream);
         memstream.free;
       end;   }
//      {$ENDIF}
    finally
      IntfImage.Free;
//      {$IF DEFINED(OLD_MASK_TRANSPARENCY) or DEFINED(LCLGTK2)}
      memstream.free;
//      {$ENDIF}
    end;
except
end;
end;

procedure SetBGRATransparencyFromLuminance(bmp:TBGRABitmap; method: integer; whitebg:boolean=false);
var
  i: Integer;
  newalpha: byte;
  p: PBGRAPixel;
begin
if (bmp.Width<2)or(bmp.Height<2) then exit;
p := bmp.Data;
for i := bmp.NbPixels-1 downto 0 do
begin
  newalpha:=MaxIntValue([p^.red,p^.green,p^.blue]);
  case method of
  0 : ;                      // 0: linear for nebulae
  1 : if newalpha<50 then    // 1: hard contrast for stars  and planets
         newalpha:=0
      else
         newalpha:=255;
  2 : if newalpha<=0 then    // 2: black transparent
         newalpha:=0
      else
         newalpha:=255;
  end;
  if whitebg then begin
    p^.red:=255-p^.red;
    p^.green:=255-p^.green;
    p^.blue:=255-p^.blue;
  end;
  p^.alpha:=newalpha;
  inc(p);
end;
bmp.InvalidateBitmap;
end;

procedure TSplot.InitStarBmp;
var
    i,j,bw: integer;
    SrcR,DestR: Trect;
begin
bw:=2*cfgplot.starshapew*starbmpw;
for i:=0 to 6 do
  for j:=0 to 10 do begin
   SrcR:=Rect(j*cfgplot.starshapesize*starbmpw,i*cfgplot.starshapesize*starbmpw,(j+1)*cfgplot.starshapesize*starbmpw,(i+1)*cfgplot.starshapesize*starbmpw);
   DestR:=Rect(0,0,bw,bw);
   Astarbmp[i,j].Width:=bw;
   Astarbmp[i,j].Height:=bw;
{$IFNDEF OLD_MASK_TRANSPARENCY}
   Astarbmp[i,j].PixelFormat:=pf32bit;
{$ENDIF}
   Astarbmp[i,j].canvas.CopyMode:=cmSrcCopy;
   Astarbmp[i,j].canvas.CopyRect(DestR,starbmp.canvas,SrcR);
   Bstarbmp[i,j].Assign(Astarbmp[i,j]);
   SetTransparencyFromLuminance(Astarbmp[i,j],1);
   SetBGRATransparencyFromLuminance(Bstarbmp[i,j],1);
  end;
end;

function TSplot.InitLabel : boolean;
var i:integer;
begin
editlabel:=-1;
for i:=1 to maxlabels do labels[i].visible:=false;
result:=true;
end;

Procedure TSplot.PlotStar1(x,y: single; ma,b_v : Double);  // bitmap image
var
  ds,Icol : Integer;
  ico,isz,xx,yy : integer;
begin
xx:=round(x);
yy:=round(y);
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
 ds := round(max(1,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma)));
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
 if cfgplot.UseBMP then begin
   cbmp.PutImage(xx-cfgplot.starshapew*starbmpw,yy-cfgplot.starshapew*starbmpw,Bstarbmp[ico,isz],dmDrawWithTransparency);
 end else
   with cnv do begin
   CopyMode:=cmSrcCopy;
   Draw(xx-cfgplot.starshapew*starbmpw,yy-cfgplot.starshapew*starbmpw,Astarbmp[ico,isz]);
   end;
end;

Procedure TSplot.PlotStar0(x,y: single; ma,b_v : Double);  // draw ellipse
var
  ds,ds2,Icol,xx,yy : Integer;
  co : Tcolor;
begin
xx:=round(x);
yy:=round(y);
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
ds := round(max(3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma))*cfgchart.drawsize);
ds2:= round(ds/2);
if cfgplot.UseBMP then begin
  cbmp.EllipseAntialias(x,y,ds2,ds2,ColorToBGRA(cfgplot.Color[0]),cfgchart.DrawPen);
  cbmp.FillEllipseAntialias(x,y,ds2,ds2,ColorToBGRA(co));
end else with cnv do begin
   Pen.Color := cfgplot.Color[0];
   Pen.Width := cfgchart.DrawPen;
   Pen.Mode := pmCopy;
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

Procedure TSplot.PlotStar2(x,y: single; ma,b_v : Double);  // antialias sprite
type
  TPos=single;
var
  LineWidth,AAWidth,Lum,R,G,B  : TPos;
  Alpha, UseContrast, Distance,
  OutLevelR, OutLevelG, OutLevelB : TPos;
  DX, DY : TPos; // Distance elements
  XCount, YCount : integer;
  MinX, MinY, MaxX, MaxY, bmWidth : integer;
  ExistingPixelRed, ExistingPixelGreen, ExistingPixelBlue,
  NewPixelR, NewPixelG, NewPixelB : integer;
  Icol : Integer;
  co : Tcolor;
  col: TBGRAPixel;
const
  PointAlpha : single = 0.15;  // Transparency at Solid;

begin
//  if not IntfImgReady then exit;
  LineWidth:=0;
  if ma<0 then ma:=ma/10;                               // avoid Moon and Sun be too big
  Lum := (1.1*cfgchart.min_ma-ma)/cfgchart.min_ma;      // logarithmic luminosity proportional to magnitude
  if Lum<0.1 then Lum:=0.1;                             // for object fainter than the limit (asteroid)
  AAwidth:=cfgchart.drawsize*cfgplot.partsize*power(cfgplot.magsize,Lum); // particle size also depend on the magnitude

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
            Alpha := PointAlpha - PointAlpha * (Distance / (LineWidth+AAWidth+0.5))
        end;

        col:=GetPixel(XCount,YCount);
        ExistingPixelBlue  :=  col.blue*255;
        ExistingPixelGreen :=  col.green*255;
        ExistingPixelRed   :=  col.red*255;

        OutLevelR := ExistingPixelRed*(1-Alpha) + Lum*R*Alpha*UseContrast;
        NewPixelR := trunc(OutLevelR/255);
        if NewPixelR>255 then NewPixelR := 255;

        OutLevelG := ExistingPixelGreen*(1-Alpha) + Lum*G*Alpha*UseContrast;
        NewPixelG := trunc(OutLevelG/255);
        if NewPixelG>255 then NewPixelG := 255;

        OutLevelB := ExistingPixelBlue*(1-Alpha) + Lum*B*Alpha*UseContrast;
        NewPixelB := trunc(OutLevelB/255);
        if NewPixelB>255 then NewPixelB := 255;

        col.red:=NewPixelR;
        col.green:=NewPixelG;
        col.blue:=NewPixelB;
        SetPixel(XCount,YCount,col);
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

Procedure TSplot.PlotVarStar(x,y: single; vmax,vmin : Double);
var
  ds,ds2,dsm,xx,yy : Integer;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then begin
  // maxima
  ds := round(max(3,(cfgplot.starsize*(cfgchart.min_ma-vmax*cfgplot.stardyn/80)/cfgchart.min_ma))*cfgchart.drawsize)-cfgchart.drawpen;
  // minima
  dsm := round(max(3,(cfgplot.starsize*(cfgchart.min_ma-vmin*cfgplot.stardyn/80)/cfgchart.min_ma))*cfgchart.drawsize);
  if (ds-dsm)<2*cfgchart.drawpen then dsm:=ds-2*cfgchart.drawpen;
  if cfgplot.UseBMP then begin
    // external ellipse
    ds2:= trunc(ds/2)+cfgchart.drawpen;
    cbmp.EllipseAntialias(x,y,ds2,ds2,ColorToBGRA(cfgplot.Color[0]),cfgchart.DrawPen);
    // external ellipse outline
    ds2:= trunc(ds/2);
    cbmp.EllipseAntialias(x,y,ds2,ds2,ColorToBGRA(cfgplot.Color[11]),cfgchart.DrawPen);
    // internal ellipse
    ds2:= trunc(dsm/2);
    cbmp.EllipseAntialias(x,y,ds2,ds2,ColorToBGRA(cfgplot.Color[0]),cfgchart.DrawPen);
  end else with cnv do begin
     // external ellipse
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
     // external ellipse outline
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
     // internal ellipse
     ds2 := trunc(dsm/2);
     Pen.Color := cfgplot.Color[0];
     Brush.Color := cfgplot.Color[11];
     case dsm of
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
 ds := round(max(3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma))*cfgchart.drawsize);
 ds2:= trunc(ds/2);
 rd:=max(r,ds2 + cfgchart.drawsize*(2+2*(0.7+ln(min(50,max(0.5,sep))))));
 if cfgplot.UseBMP then begin
   PlotStar(x,y,ma,b_v);
   cbmp.DrawLineAntialias(x,y,x-round(rd*sin(pa)),y-round(rd*cos(pa)),ColorToBGRA(cfgplot.Color[15]),1,false);
 end else with cnv do begin
   PlotStar(x,y,ma,b_v);
   Pen.Width := 1;
   Pen.Color := cfgplot.Color[15];
   Brush.style:=bsSolid;
   Pen.Mode:=pmCopy;
   MoveTo(xx-round(rd*sin(pa)),yy-round(rd*cos(pa)));
   LineTo(xx,yy);
end;
end;

Procedure TSplot.PlotDeepSkyObject(Axx,Ayy: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer; Amorph : String);
begin
{
  Here's where we break out the plot routines for each type of deep sky object
  we do it this way so that we can (in future) plot using different symbol sets
  it also clears the way for introducing more deep sky object types based on the CdS
  heirarchy.

  NOTE: We are using here a cut down version of the SACv7.1 list.
        And the NGC2000,rather than Steinecke's NGC/IC lists.

  confusingly the existing code sets up the rec.neb.nebtype array differently
  for the SAC and NGC base catalogs
  The default values for rec.neb.nebtype(1..18) is:
    nebtype: array[1..18] of string=(' - ',' ? ',' Gx',' OC',' Gb',' Pl',' Nb','C+N','  *',' D*','***','Ast',' Kt','Gcl','Drk','Cat','Cat','Cat');

--------------------------------------------------------------------------------------------------------------------
 The SAC read routine loads in:
      nebtype: array[1..18] of string=(' - ',' ? ',' Gx',' OC',' Gb',' Pl',' Nb','C+N','  *',' D*','***','Ast',' Kt','Gcl','Drk','Cat','Cat','Cat');
   not found=-1,Gx=1,OC=2,Gb=3,Pl=4,Nb=5,C+N=6,*=7,D*=8,***=9,Ast=10,Kt=11,Gcl=12,Drk=13,'?'=0,spaces=0,'-'=-1,PD=-1;
   (PD = plate defect. where has this come from (it's the NGC)..?)

 The NGC read routine ignores 12 and 13:
   not found=-1,Gx=1,OC=2,Gb=3,Pl=4,Nb=5,C+N=6,*=7,D*=8,***=9,Ast=10,Kt=11,?=0,spaces=0,'-'=-1,PD=-1;

--------------------------------------------------------------------------------------------------------------------
 For v3 we continue to use these old types
 the case cconstruct is ordered by *** frequency *** of object occurence
}
  if not cfgplot.Invisible then  // if its above the horizon...
    begin
      case Atyp of
         -1: // special case equating to catalog entry of '-' or 'PD'
            PlotDSOUnknown(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
          0: // unknown - general case where catalog entry is '?' or spaces
            PlotDSOUnknown(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
//        1:  // galaxy - not called from here, they are plotted back in cu_skychart.DrawDeepSkyObject
          2:  // open cluster
            PlotDSOOcl(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp,Amorph);
          4:  // planetary
            PlotDSOPNe(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp,Amorph);
          3:  // globular cluster
            PlotDSOGCl(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp,Amorph);
          5:  // bright nebula (emission and reflection)
            PlotDSOBN(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp,Amorph);
          6:  // cluster with nebula
            PlotDSOClNb(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp,Amorph);
          7:  // star
            PlotDSOStar(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
          8:  // double star
            PlotDSODStar(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
          9:  // triple star
            PlotDSOTStar(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
          10: // asterism
            PlotDSOAst(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
          11: // Knot (more accurately as an HII region e.g. in M101, M33 and the LMC)
            PlotDSOHIIRegion(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
          12: // galaxy cluster
            PlotDSOGxyCl(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp,Amorph);
          13: // dark nebula
            PlotDSODN(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp,Amorph);
          14 : // Circle
            PlotDSOCircle(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
          15 : // Rectangle
            PlotDSORectangle(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
          16 : // lozenge
            PlotDSOlozenge(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
         else PlotDSOUnknown(Axx,Ayy,Adim,Ama,Asbr,Apixscale,Atyp);
      end;
    end;
end;


Procedure TSplot.PlotLine(x1,y1,x2,y2:single; lcolor,lwidth: integer; style:TFPPenStyle=psSolid);
begin
if (abs(x1-cfgchart.hw)<cfgplot.outradius)and(abs(y1-cfgchart.hh)<cfgplot.outradius) and
   (abs(x2-cfgchart.hw)<cfgplot.outradius)and(abs(y2-cfgchart.hh)<cfgplot.outradius)
then begin
 if lwidth=0 then
   lwidth:=1
 else
   lwidth:=lwidth*cfgchart.drawpen;
if cfgplot.UseBMP then begin
  case style of
    psSolid: cbmp.DrawLineAntialias(x1,y1,x2,y2,ColorToBGRA(lcolor),lwidth,false);
    psDash: cbmp.DrawLineAntialias(round(x1),round(y1),round(x2),round(y2),ColorToBGRA(lcolor),BGRAPixelTransparent,3,true);
    psDot: cbmp.DrawLineAntialias(round(x1),round(y1),round(x2),round(y2),ColorToBGRA(lcolor),BGRAPixelTransparent,1,true);
    psDashDot: cbmp.DrawLineAntialias(round(x1),round(y1),round(x2),round(y2),ColorToBGRA(lcolor),BGRAPixelTransparent,5,true);
    psDashDotDot: cbmp.DrawLineAntialias(round(x1),round(y1),round(x2),round(y2),ColorToBGRA(lcolor),BGRAPixelTransparent,10,true);
    else cbmp.DrawLineAntialias(x1,y1,x2,y2,ColorToBGRA(lcolor),lwidth,false);
  end;
end else with cnv do begin
  Pen.width:=lwidth;
  Brush.Style:=bsClear;
  Brush.Color:=cfgplot.backgroundcolor;
  Pen.Mode:=pmCopy;
  Pen.Color:=lcolor;
  Pen.Style:=style;
  {$ifdef mswindows}if style<>psSolid then Pen.width:=1;{$endif}
  MoveTo(round(x1),round(y1));
  LineTo(round(x2),round(y2));
  Pen.Style:=psSolid;
end;
end;
end;

procedure TSplot.PlotOutline(x,y:single;op,lw,fs,closed: integer; r2:double; col: Tcolor);
var xx,yy,l:integer;
    outlineptsf: array of TPointf;
function SingularPolygon: boolean;
var i,j,k: integer;
    newpoint: boolean;
    x: array[1..3] of double;
    y: array[1..3] of double;
begin
result:=true;
k:=1;
for j:=1 to 3 do begin
  x[j]:=maxdouble;
  y[j]:=maxdouble;
end;
for i:=0 to  outlinenum -1 do begin
  newpoint:=false;
  for j:=1 to 3 do begin
    if outlinepts[i].x<>x[j] then newpoint:=true;
    if outlinepts[i].y<>y[j] then newpoint:=true;
    if newpoint then break;
  end;
  if newpoint then begin
     x[k]:=outlinepts[i].x;
     y[k]:=outlinepts[i].y;
     inc(k);
  end;
  if k>3 then begin
    result:=false;
    break;
  end;
end;
end;
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
       if outlineinscreen and(outlinenum>=2)and(not SingularPolygon) then begin
         // object is to be draw
         dec(outlinenum);
         if outlinecol=cfgplot.bgColor then outlinecol:=outlinecol xor clWhite;
         outlinemax:=outlinenum+1;
         if (cfgplot.nebplot=0) and (outlinetype=2) then outlinetype:=0;
         if (cfgchart.onprinter) and (outlinetype=1) then outlinetype:=0;
         if cfgplot.UseBMP then begin
           case outlinetype of
           0 : begin
                 setlength(outlinepts,outlinenum+1);
                 setlength(outlineptsf,outlinenum+1);
                 for l:=0 to outlinenum do begin outlineptsf[l].x:=outlinepts[l].x;outlineptsf[l].y:=outlinepts[l].y;end;
                 cbmp.DrawPolyLineAntialias(outlineptsf,ColorToBGRA(outlinecol),outlinelw*cfgchart.drawpen,true);
               end;
           1 : Bezierspline(outlinepts,outlinenum+1);
           2 : begin
                 setlength(outlinepts,outlinenum+1);
                 setlength(outlineptsf,outlinenum+1);
                 for l:=0 to outlinenum do begin outlineptsf[l].x:=outlinepts[l].x;outlineptsf[l].y:=outlinepts[l].y;end;
                 cbmp.FillPolyAntialias(outlineptsf,ColorToBGRA(outlinecol));
               end;
           end;
         end else begin
           {$ifdef darwin}
           if (outlinetype=1) then outlinetype:=0; // TODO: spline wrongly implemented on Carbon
           {$endif}
           cnv.Pen.Mode:=pmCopy;
           cnv.Pen.Width:=outlinelw*cfgchart.drawpen;
           cnv.Pen.Color:=outlinecol;
           cnv.Brush.Style:=bsSolid;
           cnv.Brush.Color:=outlinecol;
           case outlinetype of
           0 : begin setlength(outlinepts,outlinenum+1); cnv.polyline(outlinepts);end;
           1 : Bezierspline(outlinepts,outlinenum+1);
           2 : begin setlength(outlinepts,outlinenum+1); cnv.polygon(outlinepts);end;
           end;
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
    pf: array of TPointf;
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
if cfgplot.UseBMP then begin
  setlength(pf,1+m);
  for i:=0 to m do begin pf[i].x:=p[i].x;pf[i].y:=p[i].y;end;
  cbmp.DrawPolyLineAntialias(cbmp.ComputeClosedSpline(pf),ColorToBGRA(outlinecol),outlinelw*cfgchart.drawpen,true);
end else begin
  cnv.PolyBezier(p);
end;
end;

procedure TSplot.PlotPlanet(x,y: single;flipx,flipy,ipla:integer; jdt,pixscale,diam,magn,phase,pa,rot,poleincl,sunincl,w,r1,r2,be:double;WhiteBg:boolean;size:integer=0;margin:integer=0);
var b_v:double;
    ds,n,xx,yy : integer;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then begin
 n:=cfgplot.plaplot;
 ds:=round(diam*pixscale/2)*cfgchart.drawsize;
 if ((xx+ds)>0) and ((xx-ds)<cfgchart.Width) and ((yy+ds)>0) and ((yy-ds)<cfgchart.Height) then begin
  if (n=2) and ((ds<5)or(ds>1500)) then n:=1;
  if (n=1) and (ds<5)  then n:=0;
  if ((not planetrender)and(not use_xplanet)) and (n=2) then n:=1;
  case n of
      0 : begin // magn
          if ipla<11 then b_v:=planetcolor[ipla] else b_v:=1020;
          //if not IntfImgReady then InitPixelImg;
          PlotStar(x,y,magn,b_v);
          end;
      1 : begin // diam
          //if IntfImgReady then ClosePixelImg;
          PlotPlanet1(xx,yy,ipla,pixscale,diam);
          if ipla=6 then PlotSatRing1(xx,yy,pixscale,pa,rot,r1,r2,diam,flipy*be,WhiteBg );
          end;
      2 : begin // image
          //if IntfImgReady then ClosePixelImg;
          rot:=rot*FlipX*FlipY;
          if (ipla=10)and(size>0) then begin
            PlotPlanet5(xx,yy,flipx,flipy,ipla,jdt,pixscale,diam,rot,WhiteBg,size,margin)
          end else begin
          {$ifdef mswindows}
          if use_Xplanet then
             PlotPlanet3(xx,yy,flipx,flipy,ipla,jdt,pixscale,diam,pa+rad2deg*rot,r1,WhiteBg)
          else   
             PlotPlanet2(xx,yy,flipx,flipy,ipla,jdt,pixscale,diam,phase,pa+rad2deg*rot,poleincl,sunincl,w,r1,WhiteBg);
          {$endif}
          {$ifdef unix}
             PlotPlanet3(xx,yy,flipx,flipy,ipla,jdt,pixscale,diam,pa+rad2deg*rot,r1,WhiteBg);
          {$endif}
          end;
          end;
      3 : begin // symbol
          //if IntfImgReady then ClosePixelImg;
          PlotPlanet4(xx,yy,ipla,pixscale,WhiteBg);
          end;
  end;
 end; 
end;
end;

procedure TSplot.PlotPlanet1(xx,yy,ipla:integer; pixscale,diam:double); // ellipse
var ds,ico : integer;
    col:TBGRAPixel;
begin
ds:=round(max(diam*pixscale/2,2*cfgchart.drawpen));
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
if cfgplot.UseBMP then begin
   if cfgplot.Color[11]>cfgplot.BgColor then begin
     col := ColorToBGRA(cfgplot.Color[ico+1]) ;
   end
   else if cfgchart.onprinter then col := ColorToBGRA(cfgplot.BgColor)
                              else col := ColorToBGRA(cfgplot.Color[11]);
   if cfgplot.TransparentPlanet then col.alpha:=128
                                else col.alpha:=255;
   cbmp.EllipseAntialias(xx,yy,ds,ds,ColorToBGRA(cfgplot.Color[11]),cfgchart.drawpen);
   cbmp.FillEllipseAntialias(xx,yy,ds,ds,col);
end else with cnv do begin
   if cfgplot.Color[11]>cfgplot.BgColor then begin
     Brush.Color := cfgplot.Color[ico+1] ;
   end
   else if cfgchart.onprinter then Brush.Color := cfgplot.BgColor
                              else Brush.Color := cfgplot.Color[11];
   if cfgplot.TransparentPlanet then Brush.style:=bsclear
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

Procedure TSplot.PlotImage(xx,yy: single; iWidth,iHeight,Rotation : double; flipx, flipy :integer; WhiteBg, iTransparent : boolean; var ibmp:TBitmap; TransparentMode:integer=0);
var dsx,dsy,zoom : single;
    DestX,DestY :integer;
    SrcR: TRect;
    memstream: TMemoryStream;
    imabmp:Tbitmap;
    rbmp: Tbitmap;
    outbmp:TBGRABitmap;
    trWhiteBg: boolean;
begin
if (iWidth<2)or(iHeight<2) then exit;
zoom:=iWidth/ibmp.Width;
imabmp:=Tbitmap.Create;
rbmp:=Tbitmap.Create;
if not DisplayIs32bpp then begin
  imabmp.PixelFormat:=pf32bit;
  rbmp.PixelFormat:=pf32bit;
end;
memstream := TMemoryStream.create;
try
if cfgplot.UseBMP and WhiteBg then begin
 WhiteBg:=false;
 trWhiteBg:=true;
end;
if (iWidth<=cfgchart.Width)or(iHeight<=cfgchart.Height) then begin
   // image smaller than chart, write in full
  if (zoom>1)or((ibmp.Height<=1024)and(ibmp.Width<=1024)) then begin
      BitmapRotation(ibmp,rbmp,Rotation,WhiteBg); // rotation first for best quality
      dsx:=(rbmp.Width/ibmp.Width)*iWidth/2;
      dsy:=(rbmp.Height/ibmp.Height)*iHeight/2;
      BitmapResize(rbmp,imabmp,zoom);
   end else begin
      BitmapResize(ibmp,rbmp,zoom);               // resize first for best performance
      BitmapRotation(rbmp,imabmp,Rotation,WhiteBg);
      dsx:=(imabmp.Width/rbmp.Width)*iWidth/2;
      dsy:=(imabmp.Height/rbmp.Height)*iHeight/2;
   end;
   DestX:=round(xx-dsx);
   DestY:=round(yy-dsy);
   BitmapFlip(imabmp,(flipx<0),(flipy<0));
   if cfgplot.UseBMP then begin
    outbmp:=TBGRABitmap.Create(imabmp);
    SetBGRATransparencyFromLuminance(outbmp,TransparentMode,trWhiteBg);
    cbmp.PutImage(DestX,DestY,outbmp,dmDrawWithTransparency);
    outbmp.free;
   end else begin
     {$IFNDEF OLD_MASK_TRANSPARENCY}
     rbmp.PixelFormat:=pf32bit;
     {$endif}
     rbmp.Width:=imabmp.Width;
     rbmp.Height:=imabmp.Height;
     rbmp.Canvas.Draw(0,0,imabmp);
     if iTransparent then begin
        if DisplayIs32bpp then SetTransparencyFromLuminance(rbmp,TransparentMode)
                          else rbmp.TransparentColor:=clBlack;
     end else begin
       {$IF DEFINED(LCLGTK2)}
        rbmp.SaveToStream(memstream);
        memstream.position := 0;
        rbmp.LoadFromStream(memstream);
        rbmp.Transparent:=false;
        {$ENDIF}
     end;
     cnv.CopyMode:=cmSrcCopy;
     cnv.Draw(DestX,DestY,rbmp);
   end;
end else begin
   // only a part of the image is displayed
   BitmapRotation(ibmp,rbmp,Rotation,WhiteBg);
   BitmapFlip(rbmp,(flipx<0),(flipy<0));
   xx:=(rbmp.Width/2)+((cfgchart.Width/2)-xx)/zoom;
   yy:=(rbmp.Height/2)+((cfgchart.Height/2)-yy)/zoom;
   dsx:=cfgchart.Width/2/zoom;
   dsy:=dsx*cfgchart.height/cfgchart.width;
   SrcR:=Rect(round(xx-dsx),round(yy-dsy),round(xx+dsx),round(yy+dsy));
   imabmp.Width:=round(2*dsx);
   imabmp.Height:=round(2*dsy);
   if WhiteBg then begin
     imabmp.Canvas.Brush.Color:=clWhite;
     imabmp.Canvas.Pen.Color:=clWhite;
   end else begin
     imabmp.Canvas.Brush.Color:=clBlack;
     imabmp.Canvas.Pen.Color:=clBlack;
   end;
   imabmp.Canvas.Rectangle(0,0,imabmp.Width,imabmp.Height);
   imabmp.canvas.CopyRect(Rect(0,0,imabmp.Width,imabmp.Height),rbmp.Canvas,SrcR);
   BitmapResize(imabmp,rbmp,zoom);
   if cfgplot.UseBMP then begin
     outbmp:=TBGRABitmap.Create(rbmp);
     SetBGRATransparencyFromLuminance(outbmp,TransparentMode,trWhiteBg);
     cbmp.PutImage(0,0,outbmp,dmDrawWithTransparency);
     outbmp.free;
   end else begin
     {$IFNDEF OLD_MASK_TRANSPARENCY}
     imabmp.PixelFormat:=pf32bit;
     {$endif}
     imabmp.Width:=rbmp.Width;
     imabmp.Height:=rbmp.Height;
     imabmp.Canvas.Draw(0,0,rbmp);
     if iTransparent then begin
        if DisplayIs32bpp then SetTransparencyFromLuminance(imabmp,TransparentMode)
                          else imabmp.TransparentColor:=clBlack;
     end else begin
       {$IF DEFINED(LCLGTK2)}
        imabmp.SaveToStream(memstream);
        memstream.position := 0;
        imabmp.LoadFromStream(memstream);
        imabmp.Transparent:=false;
        {$ENDIF}
     end;
     cnv.CopyMode:=cmSrcCopy;
     cnv.Draw(0,0,imabmp);
   end;
end;
finally
  try
  rbmp.Free;
  memstream.Free;
  imabmp.Free;
  except
  end;
end;
end;

procedure TSplot.PlotPlanet2(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,phase,pa,poleincl,sunincl,w,gw:double;WhiteBg:boolean);
var ds,mode : integer;
    fn: shortstring;
const planetsize=450;
      moonsize=1000;
begin
fn:=slash(Tempdir)+'planet.bmp';
if ipla=6 then ds:=round(max(2.2261*diam*pixscale,4*cfgchart.drawpen))
          else ds:=round(max(diam*pixscale,4*cfgchart.drawpen));
if (planetBMPpla<>ipla)or(abs(planetbmpjd-jdt)>0.000695)or(abs(planetbmprot-pa)>0.2) then begin
 case ipla of
  1 :  RenderMercury(w,phase,pa,poleincl,sunincl,1,planetsize, fn);
  2 :  RenderVenus(w,phase,pa,poleincl,sunincl,1,planetsize, fn);
  4 :  RenderMars(w,phase,pa,poleincl,sunincl,1,planetsize, fn);
  5 :  RenderJupiter(w-gw,phase,pa,poleincl,sunincl,1,planetsize, fn);
  6 :  RenderSaturn(w,phase,pa,poleincl,sunincl,1,planetsize, fn);
  7 :  RenderUranus(w,phase,pa,poleincl,sunincl,1,planetsize, fn);
  8 :  RenderNeptune(w,phase,pa,poleincl,sunincl,1,planetsize, fn);
  9 :  RenderPluto(w,phase,pa,poleincl,sunincl,1,planetsize, fn);
  10 : RenderSun(w,pa,poleincl,1,planetsize, fn);
  11 : RenderMoon(w,phase,pa,poleincl,sunincl,1,moonsize, fn);
 end;
 planetbmp.LoadFromFile(SysToUTF8(fn));
 planetbmppla:=ipla;
 planetbmpjd:=jdt;
 planetbmprot:=pa;
end;
if cfgplot.TransparentPlanet then mode:=0
   else mode:=2;
PlotImage(xx,yy,ds,ds,0,flipx,flipy,WhiteBg,true,planetbmp,mode);
end;

procedure TSplot.PlotPlanet3(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,pa,gw:double;WhiteBg:boolean);
var ds,i,mode : integer;
    cmd, searchdir: string;
    ok: boolean;
begin
ok:=true;
if ipla=6 then ds:=round(max(2.2261*diam*pixscale,4*cfgchart.drawpen))
          else ds:=round(max(diam*pixscale,4*cfgchart.drawpen));
if (planetBMPpla<>ipla)or(abs(planetbmpjd-jdt)>0.000695)or(abs(planetbmprot-pa)>0.2) then begin
 searchdir:='"'+slash(appdir)+slash('data')+'planet"';
 {$ifdef unix}
    cmd:='export LC_ALL=C; xplanet';
 {$endif}
 {$ifdef mswindows}
    if not DirectoryExists(xplanet_dir) then exit;
    chdir(xplanet_dir);
    cmd:='xplanet.exe';
 {$endif}
 cmd:=cmd+' -target '+epla[ipla]+' -origin earth -rotate '+ formatfloat(f1,pa) +
      ' -light_time -tt -num_times 1 -jd '+ formatfloat(f5,jdt) +
      ' -searchdir '+searchdir+
      ' -config xplanet.config -verbosity -1'+
      ' -radius 50'+
      ' -geometry 450x450 -output "'+slash(Tempdir)+'planet.png'+'"';
 if ipla=5 then cmd:=cmd+' -grs_longitude '+formatfloat(f1,gw);
 DeleteFile(slash(Tempdir)+'planet.png');
 i:=exec(cmd);
 if i=0 then begin
   xplanetimg.LoadFromFile(SysToUTF8(slash(Tempdir)+'planet.png'));
   chdir(appdir);
   planetbmp.Assign(xplanetimg.Bitmap);
   planetbmppla:=ipla;
   planetbmpjd:=jdt;
   planetbmprot:=pa;
 end
 else begin // something go wrong with xplanet
    writetrace('Return code '+inttostr(i)+' from '+cmd);
    PlotPlanet1(xx,yy,ipla,pixscale,diam);
    ok:=false;
    planetbmpjd:=0;
 end;
end;
if cfgplot.TransparentPlanet then mode:=0
   else mode:=2;
if ok then PlotImage(xx,yy,ds,ds,0,flipx,flipy,WhiteBg,true,planetbmp,mode);
end;

procedure TSplot.PlotPlanet5(xx,yy,flipx,flipy,ipla:integer; jdt,pixscale,diam,rot:double;WhiteBg:boolean; size,margin:integer);
var ds,mode : integer;
    jpg:TJPEGImage;
    fn:string;
begin
 if size=0 then exit;
 fn:=slash(Tempdir)+'sun.jpg';
 if not FileExists(fn) then begin  // use default image
   fn:=slash(appdir)+slash('data')+slash('planet')+'sun-0.jpg';
   size:=1024; margin:=107;
 end;
 if not FileExists(fn) then begin
   PlotPlanet1(xx,yy,ipla,pixscale,diam);
   exit;
 end;
 ds:=round(max(diam*pixscale,4*cfgchart.drawpen)*size/(size-2*margin));
 jpg:=TJPEGImage.Create;
 jpg.LoadFromFile(SysToUTF8(fn));
 chdir(appdir);
 planetbmp.Assign(jpg);
 planetbmppla:=ipla;
 planetbmpjd:=jdt;
 planetbmprot:=0;
 if cfgplot.TransparentPlanet then mode:=0
    else mode:=2;
 PlotImage(xx,yy,ds,ds,rot,flipx,flipy,WhiteBg,true,planetbmp,mode);
end;

procedure TSplot.PlotPlanet4(xx,yy,ipla:integer; pixscale:double;WhiteBg:boolean);
var symbol: string;
    ds,mode : integer;
    spng: TPortableNetworkGraphic;
    sbmp: TBitmap;
begin
 symbol:=slash(appdir)+slash('data')+slash('planet')+'symbol'+inttostr(ipla)+'.png';
 if fileexists(symbol) then begin
   spng:=TPortableNetworkGraphic.Create;
   sbmp:=TBitmap.Create;
   try
   spng.LoadFromFile(symbol);
   sbmp.Assign(spng);
   if WhiteBg then BitmapNegative(sbmp);
   BitmapResize(sbmp,PlanetBMP,cfgchart.drawsize);
   finally
   spng.Free;
   sbmp.Free;
   end;
   planetbmppla:=ipla;
   planetbmpjd:=MaxInt;
   planetbmprot:=999;
   ds:=planetbmp.Width;
   if cfgplot.TransparentPlanet then mode:=0
       else mode:=2;
   PlotImage(xx,yy,ds,ds,0,1,1,WhiteBg,true,planetbmp,mode);
 end;
end;

procedure TSplot.PlotEarthShadow(x,y: single; r1,r2,pixscale: double);
var
   ds1,ds2,xx,yy,xm,ym : Integer;
   mbmp,mask:tbitmap;
   mc: TBGRABitmap;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then begin
ds1:=round(max(r1*pixscale/2,2*cfgchart.drawpen));
ds2:=round(max(r2*pixscale/2,2*cfgchart.drawpen));
if ((xx+ds2)>0) and ((xx-ds2)<cfgchart.Width) and ((yy+ds2)>0) and ((yy-ds2)<cfgchart.Height) then begin
if cfgplot.UseBMP then begin
  case  cfgplot.nebplot of
   0: begin
      cbmp.EllipseAntialias(x,y,ds1,ds1,ColorToBGRA(cfgplot.Color[11]),cfgchart.drawpen);
      cbmp.EllipseAntialias(x,y,ds2,ds2,ColorToBGRA(cfgplot.Color[11]),cfgchart.drawpen);
      end;
   1: begin
      mc:=TBGRABitmap.Create(2*ds2,2*ds2);
      // mask=shadow to substract from the moon
      xm:=ds2;
      ym:=ds2;
      mc.Fill(BGRAPixelTransparent);
      mc.FillEllipseAntialias(xm,ym,ds2,ds2,ColorToBGRA(clRed,10));
      mc.FillEllipseAntialias(xm,ym,ds1,ds1,ColorToBGRA(clRed,10));
      // Apply the shadow
      cbmp.PutImage(xx-xm,yy-xm,mc,dmDrawWithTransparency);
      mc.Free;
      end;  // 1
    end; // case
end else with cnv do begin
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
      mbmp.Width:=2*ds2;
      mbmp.Height:=mbmp.Width;
      // get source bitmap from the chart
      mbmp.Canvas.CopyRect(rect(0,0,mbmp.Width,mbmp.Height),cnv,rect(xx-ds2,yy-ds2,xx+ds2,yy+ds2));
      // mask=shadow to substract from the moon
      xm:=ds2;
      ym:=ds2;
      mask.Width:=mbmp.Width;
      mask.Height:=mbmp.Height;
      mask.Canvas.Pen.Color:=clBlack;
      mask.Canvas.Brush.Color:=clBlack;
      mask.Canvas.Rectangle(0,0,mask.Width,mask.Height);
      mask.Canvas.Pen.Color:=$080800;
      mask.Canvas.Brush.Color:=$080800;
      mask.Canvas.Ellipse(xm-ds2,ym-ds2,xm+ds2,ym+ds2);
      mask.Canvas.Pen.Color:=$606000;
      mask.Canvas.Brush.Color:=$606000;
      mask.Canvas.Ellipse(xm-ds1,ym-ds1,xm+ds1,ym+ds1);
      // substract the shadow
      BitmapSubstract(mbmp,mask);
      // finally copy back the image
      mbmp.Transparent:=false;
      copymode:=cmSrcCopy;
      copyrect(rect(xx-ds2,yy-ds2,xx+ds2,yy+ds2),mbmp.Canvas,rect(0,0,mbmp.Width,mbmp.Height));
      mbmp.Free;
      mask.Free;
      end;  // 1
    end; // case
end; // with
end;  // if xx
end;
end;

Procedure TSplot.PlotSatel(x,y:single;ipla:integer; pixscale,ma,diam : double; hidesat, showhide : boolean);
var
  ds,ds2,xx,yy : Integer;
  ds1: single;
begin
xx:=round(x);
yy:=round(y);
if not cfgplot.Invisible then
  if not (hidesat xor showhide) then begin
    ds := round(max(3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma))*cfgchart.drawsize);
    ds2:=round(diam*pixscale);
    if ds2>ds then begin
      //if IntfImgReady then ClosePixelImg;
      ds1:=ds2/2;
      if cfgplot.UseBMP then begin
        cbmp.FillEllipseAntialias(x,y,ds1,ds1,ColorToBGRA(cfgplot.Color[20]));
        cbmp.EllipseAntialias(x,y,ds1,ds1,ColorToBGRA(cfgplot.Color[0]),cfgchart.drawpen);
      end else with cnv do begin
        Pen.Color := cfgplot.Color[0];
        Pen.Width := cfgchart.drawpen;
        Brush.style:=bsSolid;
        Pen.Mode := pmCopy;
        //brush.color:=cfgplot.Color[11];
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
      end;
     end else begin
        //if not IntfImgReady then InitPixelImg;
        PlotStar(x,y,ma,1020)
     end;
   end;
end;

Procedure TSplot.PlotSatRing1(xx,yy:integer; pixscale,pa,rot,r1,r2,diam,be : double; WhiteBg:boolean);
var
  step: Double;
  ds1,ds2 : Integer;
  ex,ey,th : double;
  n,ex1,ey1,ir,R : integer;
  exf0,eyf0,exf1,eyf1: single;
  col,rcol: TBGRAPixel;
const fr : array [1..5] of double = (1,0.8801,0.8599,0.6650,0.5486);
begin
pa:=deg2rad*pa+rot-pid2;
ds1:=round(max(pixscale*r1/2,cfgchart.drawpen))+cfgchart.drawpen;
ds2:=round(max(pixscale*r2/2,cfgchart.drawpen))+cfgchart.drawpen;
R:=round(diam*pixscale/2);
step:=pi2/50;
if cfgplot.UseBMP then begin
  col := ColorToBGRA(cfgplot.Color[5]);
  if WhiteBg then col := ColorToBGRA(clBlack);
  for ir:=1 to 5 do begin
   th:=0;
     for n:=0 to 50 do begin
       ex:=(ds1*fr[ir])*cos(th);
       ey:=(ds2*fr[ir])*sin(th);
       exf1:=ex*sin(pa) - ey*cos(pa) + xx ;
       eyf1:=ex*cos(pa) + ey*sin(pa) + yy ;
       if n=0 then begin
         exf0:=exf1;
         eyf0:=eyf1;
       end else begin
           if sqrt(ex*ex+ey*ey)<1.1*R then
              if be<0 then if n<=25 then rcol:=ColorToBGRA(clBlack)
                                    else rcol:=col
                      else if n>25  then rcol:=ColorToBGRA(clBlack)
                                    else rcol:=col
           else rcol:=col;
         cbmp.DrawLineAntialias(exf0,eyf0,exf1,eyf1,rcol,cfgchart.drawpen,false);
         exf0:=exf1;
         eyf0:=eyf1;
       end;
       th:=th+step;
     end;
   end;
end else with cnv do begin
  Pen.Width := cfgchart.drawpen;
  Brush.Color := cfgplot.Color[0];
  Pen.Color := cfgplot.Color[5];
  if WhiteBg then Pen.Color:=clBlack;
  Pen.mode := pmCopy;
  for ir:=1 to 5 do begin
   th:=0;
     for n:=0 to 50 do begin
       ex:=(ds1*fr[ir])*cos(th);
       ey:=(ds2*fr[ir])*sin(th);
       ex1:=round(ex*sin(pa) - ey*cos(pa)) + xx ;
       ey1:=round(ex*cos(pa) + ey*sin(pa)) + yy ;
       if n=0 then moveto(ex1,ey1)
       else begin
         if cfgchart.onprinter and WhiteBg then begin   // !! pmNot not supported by some printer
           if sqrt(ex*ex+ey*ey)<1.1*R then
              if be<0 then if n<=25 then Pen.Color:=clBlack
                                    else Pen.Color:=clWhite
                      else if n>25  then Pen.Color:=clBlack
                                    else Pen.Color:=clWhite
           else Pen.Color:=clBlack;
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
  diamondf: array[0..3] of TPointf;
begin
case symbol of
0 : begin
    ds:=3*cfgchart.drawsize;
    if cfgplot.UseBMP then begin
        diamondf[0]:=pointf(x,y-ds);
        diamondf[1]:=pointf(x+ds,y);
        diamondf[2]:=pointf(x,y+ds);
        diamondf[3]:=pointf(x-ds,y);
        cbmp.FillPolyAntialias(diamondf,ColorToBGRA(cfgplot.Color[20]));
        cbmp.DrawPolygonAntialias(diamondf,ColorToBGRA(cfgplot.Color[0]),cfgchart.DrawPen);
      end else with cnv do begin
         xx:=round(x);
         yy:=round(y);
         Pen.Color := cfgplot.Color[0];
         Pen.Width := cfgchart.DrawPen;
         Pen.Mode := pmCopy;
         Brush.Color := cfgplot.Color[20];
         Brush.style:=bsSolid;
         diamond[0]:=point(xx,yy-ds);
         diamond[1]:=point(xx+ds,yy);
         diamond[2]:=point(xx,yy+ds);
         diamond[3]:=point(xx-ds,yy);
         Polygon(diamond);
      end;
    end;
1 : begin
  plotstar(x,y,ma,1020);
  end;
end;
end;

Procedure TSplot.PlotComet(x,y,cx,cy:single;symbol: integer; ma,diam,PixScale : Double);
var ds,ds1,xx,yy,cxx,cyy,i,j,co:integer;
    cp1,cp2: array[0..3] of TPoint;
    cpf1,cpf2: array[0..3] of TPointf;
    cr,cg,cb: byte;
    Col: Tcolor;
    colb: TBGRAPixel;
    dx,dy,a,r,k : double;
begin
xx:=round(x);
yy:=round(y);
cxx:=round(cx);
cyy:=round(cy);
dx:=cxx-xx;
dy:=cyy-yy;
if (symbol=1)and(cfgplot.nebplot=0) then symbol:=2;
if cfgplot.UseBMP then begin
   case symbol of
   0: begin
        colb:=ColorToBGRA(cfgplot.Color[21]);
        ds:=2*cfgchart.drawsize;
        cbmp.FillEllipseAntialias(x,y,ds,ds,colb);
        cbmp.EllipseAntialias(x,y,ds,ds,ColorToBGRA(cfgplot.Color[0]),cfgchart.DrawPen);
        cbmp.DrawLineAntialias(x,y,x-4*ds,y-4*ds,colb,cfgchart.DrawPen,false);
        cbmp.DrawLineAntialias(x,y,x-2*ds,y-4*ds,colb,cfgchart.DrawPen,false);
        cbmp.DrawLineAntialias(x,y,x-4*ds,y-2*ds,colb,cfgchart.DrawPen,false);
      end;
   1: begin
        r:=sqrt(dx*dx+dy*dy);
        r:=max(r,12*cfgchart.drawpen);
        a:=arctan2(dy,dx);
        if ma<5 then k:=1
        else if ma>18 then k:=0.5
        else k:=1-(ma-5)*0.05;
        cr:=round(k*(cfgplot.Color[21] and $FF));
        cg:=round(k*((cfgplot.Color[21] shr 8) and $FF));
        cb:=round(k*((cfgplot.Color[21] shr 16) and $FF));
        ds:=round(max(PixScale*diam/2,2*cfgchart.drawpen));
        for i:=19 downto 0 do begin  // coma
          co:=max(0,255-i*13);
          Col:=(cr*co div 255)+256*(cg*co div 255)+65536*(cb*co div 255);
          Col:=Addcolor(Col,cfgplot.backgroundcolor);
          colb:=ColorToBGRA(Col);
          ds1:=round((i+1)*ds/20);
          cbmp.FillEllipseAntialias(x,y,ds1,ds1,colb);
        end;
        if r>30 then begin  // tail
        cr:=cr div 2;
        cg:=cg div 2;
        cb:=cb div 2;
        if (dx<>0)or(dy<>0) then for i:=0 to 9 do begin
         cpf1[2].X:=x;
         cpf1[2].Y:=y;
         cpf1[3].X:=x;
         cpf1[3].Y:=y;
         cpf2:=cpf1;
         r:=0.99*r;
         for j:=0 to 19 do begin
          co:=max(0,255-i*20-j*13);
          Col:=(cr*co div 255)+256*(cg*co div 255)+65536*(cb*co div 255);
          Col:=Addcolor(Col,cfgplot.backgroundcolor);
          colb:=ColorToBGRA(Col);
          cpf1[0].X:=cpf1[3].X;
          cpf1[0].Y:=cpf1[3].Y;
          cpf1[1].X:=cpf1[2].X;
          cpf1[1].Y:=cpf1[2].Y;
          cpf1[2].X:=x+((j+1)*r/20*cos(a+0.015*(i)));
          cpf1[2].Y:=y+((j+1)*r/20*sin(a+0.015*(i)));
          cpf1[3].X:=x+((j+1)*0.99*r/20*cos(a+0.015*(i+1)));
          cpf1[3].Y:=y+((j+1)*0.99*r/20*sin(a+0.015*(i+1)));
          if (abs(cpf1[2].X-cpf1[3].X)>1)or(abs(cpf1[2].Y-cpf1[3].Y)>1) then cbmp.FillPolyAntialias(cpf1,colb)
             else cbmp.DrawLineAntialias(cpf1[0].X,cpf1[0].Y,cpf1[2].X,cpf1[2].Y,colb,cfgchart.DrawPen,false);
          cpf2[0].X:=cpf2[3].X;
          cpf2[0].Y:=cpf2[3].Y;
          cpf2[1].X:=cpf2[2].X;
          cpf2[1].Y:=cpf2[2].Y;
          cpf2[2].X:=x+((j+1)*r/20*cos(a-0.015*(i)));
          cpf2[2].Y:=y+((j+1)*r/20*sin(a-0.015*(i)));
          cpf2[3].X:=x+((j+1)*0.99*r/20*cos(a-0.015*(i+1)));
          cpf2[3].Y:=y+((j+1)*0.99*r/20*sin(a-0.015*(i+1)));
          if (abs(cpf2[2].X-cpf2[3].X)>1)or(abs(cpf2[2].Y-cpf2[3].Y)>1) then cbmp.FillPolyAntialias(cpf2,colb)
             else cbmp.DrawLineAntialias(cpf2[0].X,cpf2[0].Y,cpf2[2].X,cpf2[2].Y,colb,cfgchart.DrawPen,false);
         end;
        end;
        end;
        PlotStar(x,y,ma+3,1021);
      end;
   2: begin
        colb:=ColorToBGRA(cfgplot.Color[21]);
        ds:=round(max(3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma))*cfgchart.drawsize/2);
        cbmp.FillEllipseAntialias(x,y,ds,ds,colb);
        cbmp.EllipseAntialias(x,y,ds,ds,ColorToBGRA(cfgplot.Color[0]),cfgchart.DrawPen);
        ds:=round(max(PixScale*diam/2,2*cfgchart.drawpen));
        cbmp.EllipseAntialias(x,y,ds,ds,colb,cfgchart.DrawPen);
        ds:=ds+cfgchart.drawpen;
        cbmp.EllipseAntialias(x,y,ds,ds,ColorToBGRA(cfgplot.Color[0]),cfgchart.DrawPen);
        r:=sqrt(dx*dx+dy*dy);
        r:=max(r,12*cfgchart.drawpen);
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
end else with cnv do begin
   Pen.Color := cfgplot.Color[0];
   Pen.Width := cfgchart.DrawPen;
   Pen.Mode := pmCopy;
   Brush.Color := cfgplot.Color[21];
   Brush.style:=bsSolid;
   case symbol of
   0: begin
        ds:=2*cfgchart.drawsize;
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
        r:=max(r,12*cfgchart.drawpen);
        a:=arctan2(dy,dx);
        if ma<5 then k:=1
        else if ma>18 then k:=0.5
        else k:=1-(ma-5)*0.05;
        cr:=round(k*(cfgplot.Color[21] and $FF));
        cg:=round(k*((cfgplot.Color[21] shr 8) and $FF));
        cb:=round(k*((cfgplot.Color[21] shr 16) and $FF));
        pen.Mode:=pmCopy;
        brush.Style:=bsSolid;
        ds:=round(max(PixScale*diam/2,2*cfgchart.drawpen));
        for i:=19 downto 0 do begin  // coma
          co:=max(0,255-i*13);
          Col:=(cr*co div 255)+256*(cg*co div 255)+65536*(cb*co div 255);
          Col:=Addcolor(Col,cfgplot.backgroundcolor);
          pen.Color:=Col;
          brush.Color:=Col;
          ds1:=round((i+1)*ds/20);
          Ellipse(xx-ds1,yy-ds1,xx+ds1,yy+ds1);
        end;
        if r>30 then begin  // tail
        cr:=cr div 2;
        cg:=cg div 2;
        cb:=cb div 2;
        if (dx<>0)or(dy<>0) then for i:=0 to 9 do begin
         cp1[2].X:=xx;
         cp1[2].Y:=yy;
         cp1[3].X:=xx;
         cp1[3].Y:=yy;
         cp2:=cp1;
         r:=0.99*r;
         for j:=0 to 19 do begin
          co:=max(0,255-i*20-j*13);
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
          if (abs(cp1[2].X-cp1[3].X)>1)or(abs(cp1[2].Y-cp1[3].Y)>1) then polygon(cp1)
             else line(cp1[0].X,cp1[0].Y,cp1[2].X,cp1[2].Y);
          cp2[0].X:=cp2[3].X;
          cp2[0].Y:=cp2[3].Y;
          cp2[1].X:=cp2[2].X;
          cp2[1].Y:=cp2[2].Y;
          cp2[2].X:=xx+round((j+1)*r/20*cos(a-0.015*(i)));
          cp2[2].Y:=yy+round((j+1)*r/20*sin(a-0.015*(i)));
          cp2[3].X:=xx+round((j+1)*0.99*r/20*cos(a-0.015*(i+1)));
          cp2[3].Y:=yy+round((j+1)*0.99*r/20*sin(a-0.015*(i+1)));
          if (abs(cp2[2].X-cp2[3].X)>1)or(abs(cp2[2].Y-cp2[3].Y)>1) then polygon(cp2)
             else line(cp2[0].X,cp2[0].Y,cp2[2].X,cp2[2].Y);
         end;
        end;
        end;
        PlotStar(xx,yy,ma+3,1021);
      end;
   2: begin
        ds:=round(max(3,(cfgplot.starsize*(cfgchart.min_ma-ma*cfgplot.stardyn/80)/cfgchart.min_ma))*cfgchart.drawsize/2);
        Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
        ds:=round(max(PixScale*diam/2,2*cfgchart.drawpen));
        Brush.style:=bsClear;
        Pen.Color := cfgplot.Color[21];
        Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
        Pen.Color := cfgplot.Color[0];
        ds:=ds+cfgchart.drawpen;
        Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
        Brush.style:=bsSolid;
        r:=sqrt(dx*dx+dy*dy);
        r:=max(r,12*cfgchart.drawpen);
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

procedure TSplot.TextOutAntiAlias(x, y: single; s: string; c: TBGRAPixel);
var
  size:  TSize;
  temp:  TBGRABitmap;
  xx,yy: integer;
begin
  size:=cbmp.TextSize(s);
  temp := TBGRABitmap.Create(2*size.cx, 2*size.cy);
  temp.FontHeight:=2*cbmp.FontHeight;
  temp.FontStyle:=cbmp.FontStyle;
  temp.FontName:=cbmp.FontName;
  xx:=trunc(x);
  yy:=trunc(y);
  xx:=round(x-xx);
  yy:=round(y-yy);
  temp.TextOut(-xx,-yy,s,c);
  temp.Assign(temp.Resample(size.cx,size.cy,rmFineResample));
  cbmp.PutImage(round(x), round(y), temp, dmDrawWithTransparency);
  temp.Free;
end;

function TSplot.PlotLabel(i,labelnum,fontnum:integer; xxs,yys,rs:single; Xalign,Yalign:TLabelAlign; WhiteBg,forcetextlabel:boolean; txt:string; opaque:boolean=false):integer;
var ts:TSize;
    ATextStyle: TTextStyle;
    lcolor:Tcolor;
    xx,yy,r: integer;
begin
xx:=round(xxs);
yy:=round(yys);
r:=round(rs);
if (abs(xx-cfgchart.hw)<cfgplot.outradius)and(abs(yy-cfgchart.hh)<cfgplot.outradius)
then begin
// If drawing to the printer force to plot the text label to the canvas
// even if label editing is selected
if (cfgchart.onprinter or forcetextlabel) then begin
if cfgplot.UseBMP then begin;
  ATextStyle.Opaque:=opaque;
  cbmp.FontName:=cfgplot.FontName[fontnum];
  lcolor:=cfgplot.LabelColor[labelnum];
  if lcolor=cfgplot.backgroundcolor then lcolor:=(not lcolor)and $FFFFFF;
  if cfgplot.FontBold[fontnum] then cbmp.FontStyle:=[fsBold] else cbmp.FontStyle:=[];
  if cfgplot.FontItalic[fontnum] then cbmp.FontStyle:=cbmp.FontStyle+[fsItalic];
  cbmp.FontHeight:=trunc(cfgplot.LabelSize[labelnum]*cfgchart.fontscale*96/72);
  ts:=cbmp.TextSize(txt);
  if r>=0 then begin
  case Xalign of
   laLeft   : xxs:=xxs+labspacing*cfgchart.drawpen+rs;
   laRight  : xxs:=xxs-ts.cx-labspacing*cfgchart.drawpen-rs;
   laCenter : xxs:=xxs-(ts.cx div 2);
  end;
  case Yalign of
   laTop    : yys:=yys-rs;
   laBottom : yys:=yys-ts.cy+rs;
   laCenter : yys:=yys-(ts.cy div 2);
  end;
  end;
  if opaque then cbmp.FillRect(round(xxs),round(yys),round(xxs+ts.cx),round(yys+ts.cy),cfgplot.backgroundcolor);
  TextOutAntialias(xxs,yys,txt,ColorToBGRA(lcolor));
end else with cnv do begin
  ATextStyle := TextStyle;
  ATextStyle.Opaque:=opaque;
  TextStyle:=ATextStyle;
  if opaque then Brush.Style:=bsSolid
            else Brush.Style:=bsClear;
  Pen.Mode:=pmCopy;
  Font.Name:=cfgplot.FontName[fontnum];;
  Font.Color:=cfgplot.LabelColor[labelnum];
  if cfgplot.FontBold[fontnum] then Font.Style:=[fsBold] else Font.Style:=[];
  if cfgplot.FontItalic[fontnum] then font.style:=font.style+[fsItalic];
  Font.Size:=cfgplot.LabelSize[labelnum]*cfgchart.fontscale;
 // Font.Orientation:=900;
  ts:=TextExtent(txt);
  if r>=0 then begin
  case Xalign of
   laLeft   : xx:=xx+labspacing*cfgchart.drawpen+r;
   laRight  : xx:=xx-ts.cx-labspacing*cfgchart.drawpen-r;
   laCenter : xx:=xx-(ts.cx div 2);
  end;
  case Yalign of
   laTop    : yy:=yy-r;
   laBottom : yy:=yy-ts.cy+r;
   laCenter : yy:=yy-(ts.cy div 2);
  end;
  end;
  if cnv is TPostscriptCanvas then begin
    TextOut(xx,yy,txt);
  end else begin
    TextOut(xx,yy,txt);
  end;
  Font.Orientation:=0;
end;
// If drawing to the screen use movable label 
end else begin
if i>maxlabels then begin
  result:=-1;
  exit;
end;
with labels[i] do begin
//  Color:=cfgplot.Color[0];
//  Transparent:=true;
  color:=clNone;
  Font.Name:=cfgplot.FontName[fontnum];
  Font.Color:=cfgplot.LabelColor[labelnum];
  if WhiteBg and (Font.Color=clWhite) then Font.Color:=clBlack;
  Font.Size:=cfgplot.LabelSize[labelnum];
  if cfgplot.FontBold[fontnum] then Font.Style:=[fsBold] else Font.Style:=[];
  if cfgplot.FontItalic[fontnum] then font.style:=font.style+[fsItalic];
  caption:=txt;
 {
  visible:=true;
  AutoSize:=true;
  Font.Orientation:=0;
  caption:=txt;
  AdjustSize;
  h:=height;
  w:=width;
  AutoSize:=false;
  Font.Orientation:=600;
  width:=h;
  height:=w;
 }
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
end;
result:=0;
end;

procedure TSplot.PlotText(xx,yy,fontnum,lcolor:integer; Xalign,Yalign:TLabelAlign; txt:string; opaque:boolean=true; clip:boolean=false; marge: integer=5);
var ts:TSize;
    arect: TRect;
    ATextStyle:TTextStyle;
begin
if (abs(xx-cfgchart.hw)<cfgplot.outradius)and(abs(yy-cfgchart.hh)<cfgplot.outradius)
then begin
if cfgplot.UseBMP then begin;
  ATextStyle.Opaque:=opaque;
  cbmp.FontHeight:=trunc(cfgplot.FontSize[fontnum]*cfgchart.fontscale*96/72);
  if cfgplot.FontBold[fontnum] then cbmp.FontStyle:=[fsBold] else cbmp.FontStyle:=[];
  if cfgplot.FontItalic[fontnum] then cbmp.FontStyle:=cbmp.FontStyle+[fsItalic];
  cbmp.FontName:=cfgplot.FontName[fontnum];
  if lcolor=cfgplot.backgroundcolor then lcolor:=(not lcolor)and $FFFFFF;
  ts:=cbmp.TextSize(txt);
  case Xalign of
   laRight  : xx:=xx-ts.cx;
   laCenter : xx:=xx-(ts.cx div 2);
  end;
  case Yalign of
   laBottom : yy:=yy-ts.cy;
   laCenter : yy:=yy-(ts.cy div 2);
  end;
  if clip then begin
    if yy<cfgplot.ymin then yy:=cfgplot.ymin+marge;
    if (yy+ts.cy+marge)>cfgplot.ymax then yy:=cfgplot.ymax-ts.cy-marge;
    if xx<cfgplot.xmin then xx:=cfgplot.xmin+marge;
    if (xx+ts.cx+marge)>cfgplot.xmax then xx:=cfgplot.xmax-ts.cx-marge;
  end;
  arect:=Bounds(xx,yy,ts.cx,ts.cy+2);
  if opaque then cbmp.FillRect(arect,cfgplot.backgroundcolor);
  cbmp.TextRect(arect,xx,yy,txt,ATextStyle,ColorToBGRA(lcolor));
end else with cnv do begin
  ATextStyle := TextStyle;
  ATextStyle.Opaque:=opaque;
  TextStyle:=ATextStyle;
  if opaque then Brush.Style:=bsSolid
            else Brush.Style:=bsClear;
  Brush.Color:=cfgplot.backgroundcolor;
  Pen.Mode:=pmCopy;
  Pen.Color:=cfgplot.backgroundcolor;
  Font.Name:=cfgplot.FontName[fontnum];
  Font.Color:=lcolor;
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
  if clip then begin
    if yy<cfgplot.ymin then yy:=cfgplot.ymin+marge;
    if (yy+ts.cy+marge)>cfgplot.ymax then yy:=cfgplot.ymax-ts.cy-marge;
    if xx<cfgplot.xmin then xx:=cfgplot.xmin+marge;
    if (xx+ts.cx+marge)>cfgplot.xmax then xx:=cfgplot.xmax-ts.cx-marge;
  end;
  arect:=Bounds(xx,yy,ts.cx,ts.cy+2);
  if cnv is TPostscriptCanvas then begin
    if opaque then Rectangle(arect);
    TextOut(xx,yy,txt);
  end else begin
    arect:=Bounds(xx,yy,ts.cx,ts.cy+2);
    textRect(arect,xx,yy,txt);
  end;
end;
end;
end;

procedure TSplot.PlotTextCR(xx,yy,fontnum,labelnum:integer; txt:string; WhiteBg: boolean; opaque:boolean=true);
var ls,p:Integer;
    buf: string;
    arect: TRect;
    ts: TSize;
    ATextStyle:TTextStyle;
    lcolor:TColor;
begin
if (abs(xx-cfgchart.hw)<cfgplot.outradius)and(abs(yy-cfgchart.hh)<cfgplot.outradius)
then begin
if cfgplot.UseBMP then begin;
   ATextStyle.Opaque:=opaque;
   cbmp.FontHeight:=trunc(cfgplot.FontSize[fontnum]*cfgchart.fontscale*96/72);
   if cfgplot.FontBold[fontnum] then cbmp.FontStyle:=[fsBold] else cbmp.FontStyle:=[];
   if cfgplot.FontItalic[fontnum] then cbmp.FontStyle:=cbmp.FontStyle+[fsItalic];
   cbmp.FontName:=cfgplot.FontName[fontnum];
   lcolor:=cfgplot.LabelColor[labelnum];
   if lcolor=cfgplot.backgroundcolor then lcolor:=(not lcolor)and $FFFFFF;
   ts:=cbmp.TextSize('1');
   {$ifdef lclgtk}
   ls:=round(1.5*ts.cy;));
   {$else}
   ls:=ts.cy;
   {$endif}
   repeat
     p:=pos(crlf,txt);
     if p=0 then buf:=txt
       else begin
         buf:=copy(txt,1,p-1);
         delete(txt,1,p+1);
     end;
     ts:=cbmp.TextSize(buf);
     arect:=Bounds(xx,yy,ts.cx,ts.cy+2);
     if opaque then cbmp.FillRect(arect,cfgplot.backgroundcolor);
     cbmp.TextRect(arect,xx,yy,buf,ATextStyle,ColorToBGRA(lcolor));
     yy:=yy+ls;
   until p=0;
end else with cnv do begin
    ATextStyle := TextStyle;
    ATextStyle.Opaque:=opaque;
    TextStyle:=ATextStyle;
    if opaque then Brush.Style:=bsSolid
              else Brush.Style:=bsClear;
    Brush.Color:=cfgplot.backgroundcolor;
    Pen.Mode:=pmCopy;
    Pen.Color:=cfgplot.backgroundcolor;
    Font.Name:=cfgplot.FontName[fontnum];
    Font.Color:=cfgplot.LabelColor[labelnum];
    if Font.Color=Brush.Color then Font.Color:=(not Font.Color)and $FFFFFF;
    Font.Size:=cfgplot.LabelSize[labelnum]*cfgchart.fontscale;
    if cfgplot.FontBold[fontnum] then Font.Style:=[fsBold] else Font.Style:=[];
    if cfgplot.FontItalic[fontnum] then font.style:=font.style+[fsItalic];
    {$ifdef lclgtk}
    ls:=round(1.5*cnv.TextHeight('1'));
    {$else}
    ls:=round(cnv.TextHeight('1'));
    {$endif}
    repeat
      p:=pos(crlf,txt);
      if p=0 then buf:=txt
        else begin
          buf:=copy(txt,1,p-1);
          delete(txt,1,p+1);
      end;
      ts:=TextExtent(buf);
      arect:=Bounds(xx,yy,ts.cx,ts.cy+2);
      if cnv is TPostscriptCanvas then begin
         if opaque then Rectangle(arect);
         TextOut(xx,yy,buf);
      end else begin
         textRect(arect,xx,yy,buf);
      end;
      yy:=yy+ls;
    until p=0;
end;
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
//  labels[editlabel].Transparent:=true;
  labels[editlabel].color:=clNone;
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
//labels[editlabel].Transparent:=false;
labels[editlabel].Color:=cfgplot.Color[0];
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
if assigned(FDeleteAllLabel) then FDeleteAllLabel;
end;

Procedure TSplot.PlotCircle(x1,y1,x2,y2:single;lcolor: integer;moving:boolean);
var x,y,r: single;
begin
if cfgplot.UseBMP and (not moving) then begin
 x:=(x1+x2)/2;
 y:=(y1+y2)/2;
 r:=abs(x1-x2)/2;
 cbmp.EllipseAntialias(x,y,r,r,ColorToBGRA(lcolor),cfgchart.drawpen);
end else with cnv do begin
  Pen.Width:=cfgchart.drawpen;
  if moving then begin
     Pen.Color:=clWhite;
     Pen.Mode:=pmXor;
  end else begin
     Pen.Color:=lcolor;
     Pen.Mode:=pmCopy;
  end;
  Brush.Style:=bsClear;
  Ellipse(round(x1),round(y1),round(x2),round(y2));
  Pen.Mode:=pmCopy;
  brush.Style:=bsSolid;
end;
end;


Procedure TSplot.PlotCRose(rosex,rosey,roserd,rot:single;flipx,flipy:integer; WhiteBg:boolean; RoseType: integer);
var c,s: extended;
    i: integer;
    col: TBGRAPixel;
begin
if (cfgplot.nebplot>0)and(compassrose<>nil)and(compassrose.width>0)and(compassarrow<>nil)and(compassarrow.width>0)
 then begin
   case RoseType of
    1: PlotImage(rosex,rosey,2*roserd,2*roserd,rot,flipx,flipy,WhiteBg,true,compassrose,2);
    2: PlotImage(rosex,rosey,2*roserd,2*roserd,rot,flipx,flipy,WhiteBg,true,compassarrow,2);
   end;
end else begin
  if FlipY<0 then rot:=pi-rot;
  if FlipX<0 then rot:=-rot;
  if cfgplot.usebmp then begin
    case RoseType of
    1: begin
       col:=ColorToBGRA(cfgplot.Color[13]);
       cbmp.EllipseAntialias(rosex,rosey,roserd,roserd,col,cfgchart.drawpen);
       sincos(rot,c,s);
       if not WhiteBg then col:=ColorToBGRA(clRed);
       cbmp.DrawLineAntialias(rosex+(roserd*s/8),rosey-(roserd/8*c),rosex-(roserd*c),rosey-(roserd*s),col,cfgchart.drawpen,false);
       cbmp.DrawLineAntialias(rosex-(roserd*c),rosey-(roserd*s),rosex-(roserd*s/8),rosey+(roserd/8*c),col,cfgchart.drawpen,false);
       cbmp.DrawLineAntialias(rosex-(roserd*s/8),rosey+(roserd/8*c),rosex+(roserd*s/8),rosey-(roserd/8*c),col,cfgchart.drawpen,false);
       if not WhiteBg then col:=ColorToBGRA(clBlue);
       cbmp.DrawLineAntialias(rosex+(roserd*s/8),rosey-(roserd/8*c),rosex+(roserd*c),rosey+(roserd*s),col,cfgchart.drawpen,false);
       cbmp.DrawLineAntialias(rosex+(roserd*c),rosey+(roserd*s),rosex-(roserd*s/8),rosey+(roserd/8*c),col,cfgchart.drawpen,false);
       col:=ColorToBGRA(cfgplot.Color[13]);
       for i:=1 to 7 do begin
           sincos(rot+i*pi/4,c,s);
           cbmp.DrawLineAntialias(rosex-(roserd*c),rosey-(roserd*s),rosex-(0.9*roserd*c),rosey-(0.9*roserd*s),col,cfgchart.drawpen,false);
       end;
       end;
    2: begin
       col:=ColorToBGRA(cfgplot.Color[12]);
       sincos(rot,c,s);
       cbmp.DrawLineAntialias(rosex+(roserd*s/8),rosey-(roserd/8*c),rosex-(roserd*c),rosey-(roserd*s),col,cfgchart.drawpen,false);
       cbmp.DrawLineAntialias(rosex-(roserd*c),rosey-(roserd*s),rosex-(roserd*s/8),rosey+(roserd/8*c),col,cfgchart.drawpen,false);
       cbmp.DrawLineAntialias(rosex-(roserd*s/8),rosey+(roserd/8*c),rosex+(roserd*s/8),rosey-(roserd/8*c),col,cfgchart.drawpen,false);
       end;
    end;
  end else with cnv do begin
    Pen.Width:=cfgchart.drawpen;
    Pen.Mode:=pmCopy;
    Brush.Style:=bsClear;
    case RoseType of
    1: begin
       Pen.Color:=cfgplot.Color[13];
       Ellipse(round(rosex-roserd),round(rosey-roserd),round(rosex+roserd),round(rosey+roserd));
       sincos(rot,c,s);
       if not WhiteBg then Pen.Color:=clRed;
       moveto(round(rosex+(roserd*s/8)),round(rosey-(roserd/8*c)));
       lineto(round(rosex-(roserd*c)),round(rosey-(roserd*s)));
       moveto(round(rosex-(roserd*c)),round(rosey-(roserd*s)));
       lineto(round(rosex-(roserd*s/8)),round(rosey+(roserd/8*c)));
       moveto(round(rosex-(roserd*s/8)),round(rosey+(roserd/8*c)));
       lineto(round(rosex+(roserd*s/8)),round(rosey-(roserd/8*c)));
       if not WhiteBg then Pen.Color:=clBlue;
       moveto(round(rosex+(roserd*s/8)),round(rosey-(roserd/8*c)));
       lineto(round(rosex+(roserd*c)),round(rosey+(roserd*s)));
       moveto(round(rosex+(roserd*c)),round(rosey+(roserd*s)));
       lineto(round(rosex-(roserd*s/8)),round(rosey+(roserd/8*c)));
       Pen.Color:=cfgplot.Color[13];
       for i:=1 to 7 do begin
           sincos(rot+i*pi/4,c,s);
           moveto(round(rosex-(roserd*c)),round(rosey-(roserd*s)));
           lineto(round(rosex-(0.9*roserd*c)),round(rosey-(0.9*roserd*s)));
       end;
       end;
    2: begin
       Pen.Color:=cfgplot.Color[12];
       sincos(rot,c,s);
       moveto(round(rosex+(roserd*s/8)),round(rosey-(roserd/8*c)));
       lineto(round(rosex-(roserd*c)),round(rosey-(roserd*s)));
       moveto(round(rosex-(roserd*c)),round(rosey-(roserd*s)));
       lineto(round(rosex-(roserd*s/8)),round(rosey+(roserd/8*c)));
       moveto(round(rosex-(roserd*s/8)),round(rosey+(roserd/8*c)));
       lineto(round(rosex+(roserd*s/8)),round(rosey-(roserd/8*c)));
       end;
    end;
    Pen.Mode:=pmCopy;
    brush.Style:=bsSolid;
  end;
end;
end;

Procedure TSplot.PlotPolyLine(p:array of Tpoint; lcolor:integer; moving:boolean);
begin
if cfgplot.UseBMP and (not moving) then begin
 cbmp.DrawPolyLineAntialias(p,ColorToBGRA(lcolor),true);
end else with cnv do begin
  Pen.Width:=cfgchart.drawpen;
  if moving then begin
     Pen.Color:=clWhite;
     Pen.Mode:=pmXor;
  end else begin
     Pen.Color:=lcolor;
     Pen.Mode:=pmCopy;
  end;
  Polyline(p);
  Pen.Mode:=pmCopy;
end;
end;

procedure TSplot.FloodFill(X, Y: Integer; FillColor: TColor);
begin
if cfgplot.UseBMP then begin
  cbmp.FloodFill(x,y,ColorToBGRA(FillColor),fmSet);
end else begin
  cnv.FloodFill(x,y,FillColor,fsBorder);
end;
end;

Procedure TSplot.PlotDSOGxy(Ax,Ay: single; Ar1,Ar2,Apa,Arnuc,Ab_vt,Ab_ve,Ama,Asbr,Apixscale : double;Amorph:string);
{
Plots galaxies - Arnuc comes thru as 0, Ab_vt and Ab_ve come thru as 100
}

var
  ds1,ds2,xx,yy : Integer;
  ex,ey,th : double;
  n,ex1,ey1 : integer;
  exf1,eyf1: single;
  elp : array [1..44] of Tpoint;
  elpf : array [1..44] of Tpointf;
  nebcolor : Tcolor;
  col,r,g,b : byte;

begin
  xx:=round(Ax);
  yy:=round(Ay);
  if Ar2=0 then Ar2:=Ar1/2;
  ds1:=round(max(Apixscale*Ar1/2,cfgchart.drawpen))+cfgchart.drawpen;
  ds2:=round(max(Apixscale*Ar2/2,cfgchart.drawpen))+cfgchart.drawpen;
  nebcolor:=cfgplot.Color[31];                           // Fix Color
  if (cfgplot.nebplot=1)and cfgplot.DSOColorFillGxy then // SBR Color
      begin
        if Asbr<0 then
          begin
            if Ar1<=0 then Ar1:=1;
            if Ar2<=0 then Ar2:=Ar1;
            Asbr:= Ama + 2.5*log10(Ar1*Ar2) - 0.26;
          end;
        col := maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,
                      trunc(cfgplot.Nebbright-((Asbr-11)/4)*
                           (cfgplot.Nebbright-cfgplot.Nebgray))])]);
        r:=cfgplot.Color[31] and $FF;
        g:=(cfgplot.Color[31] shr 8) and $FF;
        b:=(cfgplot.Color[31] shr 16) and $FF;
        Nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
        NebColor := Addcolor(Nebcolor,cfgplot.backgroundcolor);
      end;
  if cfgplot.UseBMP then begin
    th:=0;
    for n:=1 to 44 do
      begin
        ex:=ds1*cos(th);
        ey:=ds2*sin(th);
        exf1:=ex*sin(Apa) - ey*cos(Apa) + Ax ;
        eyf1:=ex*cos(Apa) + ey*sin(Apa) + Ay ;
        elpf[n]:=Pointf(exf1,eyf1);
        th:=th+0.15;
      end;
    if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillGxy then // line mode
      cbmp.DrawPolygonAntialias(elpf, ColorToBGRA(nebcolor), cfgchart.drawpen)
    else
      cbmp.FillPolyAntialias(elpf, ColorToBGRA(nebcolor));
  end else begin
      cnv.Pen.Width := cfgchart.drawpen;
      cnv.Brush.style:=bsSolid;
      cnv.Pen.Mode:=pmCopy;
      cnv.Pen.Color:=nebcolor;

      if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillGxy then // line mode
        begin
          cnv.Brush.style:=bsClear;
          if cfgplot.DSOColorFillGxy and not cfgchart.onprinter then
            begin
              cnv.Brush.Style := bsSolid;
              cnv.Pen.Color := nebcolor;
              cnv.Brush.Color := cnv.Pen.Color;
            end;
        end;

      if (cfgplot.nebplot=1)and cfgplot.DSOColorFillGxy then // graphics mode
        begin
          cnv.Brush.Color := nebcolor;
          cnv.Pen.Color := nebcolor;
          cnv.Brush.Style := bsSolid;
        end;

      th:=0;
      for n:=1 to 44 do
        begin
          ex:=ds1*cos(th);
          ey:=ds2*sin(th);
          ex1:=round(ex*sin(Apa) - ey*cos(Apa)) + xx ;
          ey1:=round(ex*cos(Apa) + ey*sin(Apa)) + yy ;
          elp[n]:=Point(ex1,ey1);
          th:=th+0.15;
        end;
      cnv.Polygon(elp);
  end;
end;

Procedure TSplot.PlotDSOOcl(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
{
  Plot open clusters
}
var
  sz: Double;
  ds,xx,yy : Integer;
  col,r,g,b : byte;
  nebcolor : Tcolor;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,2*cfgchart.drawpen));
  nebcolor:=cfgplot.Color[24];                           // Fix color
  if (cfgplot.nebplot=1)and cfgplot.DSOColorFillOCl then // SBR color
    begin
      if Asbr<=0 then
        begin
          if Adim<=+0 then
            Adim:=1;
          Asbr:= Ama + 5*log10(Adim) - 0.26;
        end;
      if Asbr<10 then Asbr:=10;  //some very bright cluster make too bright surface
//    adjust colour by using Asbr and UI options
      col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((Asbr-6)/9)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
      r:=cfgplot.Color[24] and $FF;
      g:=(cfgplot.Color[24] shr 8) and $FF;
      b:=(cfgplot.Color[24] shr 16) and $FF;
      nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
      nebcolor := Addcolor(nebcolor,cfgplot.backgroundcolor);
    end;
if cfgplot.usebmp then begin
    if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillOCl then // line mode
      cbmp.EllipseAntialias(Ax,Ay,ds,ds,ColorToBGRA(nebcolor),cfgchart.drawpen)
    else
      cbmp.FillEllipseAntialias(Ax,Ay,ds,ds,ColorToBGRA(nebcolor));
end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode := pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := nebcolor;
  cnv.Brush.Style := bsSolid;

  if (cfgplot.nebplot=1)and cfgplot.DSOColorFillOCl then // graphic mode
    begin
      cnv.Pen.Color := nebcolor;
      cnv.Brush.Color := nebcolor;
    end;

  if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillOCl then // line mode
// line mode
    begin
      ds:=ds+cfgchart.drawpen;
      if cfgplot.DSOColorFillOCl and not cfgchart.onprinter then
        begin
          cnv.Brush.Style := bsSolid;
          cnv.Pen.Color := nebcolor;
          cnv.Brush.Color := cnv.Pen.Color;
        end
      else
        begin
          if cfgchart.onprinter and (ds<(10)) then
            cnv.Pen.Style := psSolid
          else
            cnv.Pen.Style := psDot;
          {$ifdef mswindows}cnv.Pen.width:=1;{$endif}
          cnv.Brush.Style := bsClear;
        end;
    end;

{ and draw it... we're using an ellipse, in future we may adjust this for non-circular clusters
  use the symbol set from Display>Options
}
  cnv.Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
  end;
end;


Procedure TSplot.PlotDSOPNe(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
{
  Plot planetary nebulae - currently these are shown as circular...
  todo: change so that we can plot non-circular ones
  ---> nice but where to find the information ????
  
  Also, use Skiff's formula in DS to calc the SBr. This is fairly close
  to the published OIII brightness.
}
var
  sz: Double;
  ds,xx,yy : Integer;
  col,r,g,b : byte;
  nebcolor : Tcolor;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,2*cfgchart.drawpen));
  nebcolor:=cfgplot.Color[26];                           // Fix color
  if (cfgplot.nebplot=1)and cfgplot.DSOColorFillPNe then // SBR color
  begin
    if Asbr<=0 then
      begin
        if Adim<=+0 then
          Adim:=1;
        Asbr:= Ama + 5*log10(Adim) - 0.26;
      end;
//    adjust colour by using Asbr and UI options
    col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((Asbr-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);      r:=cfgplot.Color[26] and $FF;
    g:=(cfgplot.Color[26] shr 8) and $FF;
    b:=(cfgplot.Color[26] shr 16) and $FF;
    nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
    nebcolor := Addcolor(nebcolor,cfgplot.backgroundcolor);
  end;
  if cfgplot.usebmp then begin
    if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillPNe then // line mode
      cbmp.EllipseAntialias(Ax,Ay,ds,ds,ColorToBGRA(nebcolor),cfgchart.drawpen)
    else
      cbmp.FillEllipseAntialias(Ax,Ay,ds,ds,ColorToBGRA(nebcolor));
    cbmp.DrawHorizLine(xx-round(ds*1.3),yy,xx+round(ds*1.3),ColorToBGRA(nebcolor));
end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := nebcolor;
  cnv.Brush.Style := bsSolid;

  if (cfgplot.nebplot=1)and cfgplot.DSOColorFillPNe then // graphic mode
    begin
//    in graphic mode, the obect is ALWAYS shown as filled.
      cnv.Pen.Color := nebcolor;
      cnv.Brush.Color := nebcolor;
    end;

  if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillPNe then // line mode
    begin
      ds:=ds+cfgchart.drawpen;
      if cfgplot.DSOColorFillPNe and not cfgchart.onprinter then
        begin
          cnv.Brush.Style := bsSolid;
          cnv.Pen.Color := nebcolor;
          cnv.Brush.Color := cnv.Pen.Color;
        end
      else
        begin
          cnv.Brush.Style := bsClear;
          cnv.Pen.Style := psSolid;
        end;
    end;

// and draw it... we're using an circle, in future we may adjust this for non-circular planetaries

  cnv.Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
  cnv.MoveTo((xx-round(ds*1.3)),yy);
  cnv.LineTo((xx+round(ds*1.3)),yy);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;



Procedure TSplot.PlotDSOGCl(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
{
  Plot globular clusters - currently these are shown as circular...
}
var
  sz: Double;
  ds,ds2,xx,yy : Integer;
  col,r,g,b : byte;
  nebcolor : Tcolor;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,2*cfgchart.drawpen));
  nebcolor:=cfgplot.Color[25];                           // Fix color
  if (cfgplot.nebplot=1)and cfgplot.DSOColorFillGCl then // SBR color
    begin
      if Asbr<=0 then
        begin
          if Adim<=+0 then
            Adim:=1;
          Asbr:= Ama + 5*log10(Adim) - 0.26;
        end;
//    adjust colour by using Asbr and UI options
      col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((Asbr-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
      r:=cfgplot.Color[25] and $FF;
      g:=(cfgplot.Color[25] shr 8) and $FF;
      b:=(cfgplot.Color[25] shr 16) and $FF;
      nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
      nebcolor := Addcolor(nebcolor,cfgplot.backgroundcolor);
    end;
  if cfgplot.usebmp then begin
    if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillGCl then begin// line mode
      cbmp.EllipseAntialias(Ax,Ay,ds,ds,ColorToBGRA(nebcolor),cfgchart.drawpen);
      cbmp.DrawHorizLine(xx-ds,yy,xx+ds,ColorToBGRA(nebcolor));
      cbmp.DrawVertLine(xx,yy-ds,yy+ds,ColorToBGRA(nebcolor));
    end else begin
      cbmp.FillEllipseAntialias(Ax,Ay,ds,ds,ColorToBGRA(nebcolor));
      ds2:=ds div 3;
      nebcolor := Addcolor(nebcolor,$00202020);
      cbmp.FillEllipseAntialias(Ax,Ay,ds2,ds2,ColorToBGRA(nebcolor));
    end;

end else begin

  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := nebcolor;
  cnv.Brush.Style := bsSolid;

  if (cfgplot.nebplot=1)and cfgplot.DSOColorFillGCl then // graphic mode
    begin
//    in graphic mode, the obect is ALWAYS shown as filled.
      cnv.Pen.Color := nebcolor;
      cnv.Brush.Color := cnv.Pen.Color;
//    draw outer limit
      cnv.Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
      cnv.Brush.Color := Addcolor(cnv.Brush.Color,$00202020);
      cnv.Pen.Color :=cnv.Brush.Color;
      ds2:=ds div 3; // a third looks more realistic
//    draw core
      cnv.Ellipse(xx-ds2,yy-ds2,xx+ds2,yy+ds2);
    end;

  if (cfgplot.nebplot=0) or not cfgplot.DSOColorFillGCl then // line mode
    begin
      ds2:=round(ds*2/3);
      ds:=ds+cfgchart.drawpen;
      if cfgplot.DSOColorFillGCl and not cfgchart.onprinter then
        begin
          cnv.Brush.Style := bsSolid;
          cnv.Pen.Color := nebcolor;
          cnv.Brush.Color := cnv.Pen.Color;
        end
      else
        begin
          cnv.Brush.Style := bsClear;
          cnv.Pen.Style := psSolid;
        end;
//    and draw it... we're using an circle,
      cnv.Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);
      cnv.MoveTo(xx-ds,yy);
      cnv.LineTo(xx+ds,yy);
      cnv.MoveTo(xx,yy-ds);
      cnv.LineTo(xx,yy+ds);
    end;

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;

end;
end;

Procedure TSplot.PlotDSOBN(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
{
  Plot bright nebula - both emmission and reflection are plotted the same
  in the future, we'll separate these out, maybe even for Herbig-Haro and variable nebulae
}
var
  sz: Double;
  ds,dsr,xx,yy : Integer;
  col,r,g,b : byte;
  nebcolor : Tcolor;
  ObjMorph:string;
  fill: boolean;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,2*cfgchart.drawpen));
  dsr:=ds div 4;
  // emission of reflection nebula?
    ObjMorph:=LeftStr(Amorph, 1);
    if ObjMorph = 'R'
    then begin
      nebcolor := cfgplot.Color[29];
      fill:=cfgplot.DSOColorFillRN and not cfgchart.onprinter;
    end
    else begin
      nebcolor := cfgplot.Color[28];
      fill:=cfgplot.DSOColorFillEN and not cfgchart.onprinter;
    end;
    if (cfgplot.nebplot=1) and fill then // SBR color
      begin
        if Asbr<=0 then
          begin
            if Adim<=+0 then
              Adim:=1;
            Asbr:= Ama + 5*log10(Adim) - 0.26;
          end;
  //    adjust colour by using Asbr and UI options
        col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((Asbr-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
        r:=nebcolor and $FF;
        g:=(nebcolor shr 8) and $FF;
        b:=(nebcolor shr 16) and $FF;
        nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
        nebcolor := Addcolor(nebcolor,cfgplot.backgroundcolor);
      end;
if cfgplot.UseBMP then begin
  if (cfgplot.nebplot=0)or not fill then begin// line mode
    cbmp.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr,ColorToBGRA(nebcolor),BGRAPixelTransparent);
  end else begin
    cbmp.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr,ColorToBGRA(nebcolor),ColorToBGRA(nebcolor));
  end;
end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := nebcolor;
  cnv.Brush.Style := bsClear;

  if (cfgplot.nebplot=1) and fill then // graphic mode
    begin
//    in graphic mode, the obect is ALWAYS shown as filled.
      cnv.Brush.Style := bsSolid;
      cnv.Brush.Color := nebcolor;
      cnv.Pen.Color := cnv.Brush.Color;
      cnv.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr);
    end;

  if (cfgplot.nebplot=0) or not fill then // line mode
    begin
      ds:=ds+cfgchart.drawpen;
      cnv.Brush.Style := bsClear;
      cnv.Pen.Style := psSolid;

//emission nebula?
  if ObjMorph = 'E' then
      if cfgplot.DSOColorFillEN and not cfgchart.onprinter
        then
          begin
            cnv.Brush.Style := bsSolid;
            cnv.Brush.Color := cnv.Pen.Color;
          end;

//reflection nebula?
  if ObjMorph = 'R' then
      if cfgplot.DSOColorFillRN and not cfgchart.onprinter
        then
          begin
            cnv.Brush.Style := bsSolid;
            cnv.Brush.Color := cnv.Pen.Color;
          end;

//    and draw it... we're using an rectangle in the event that we don't have an outline
      cnv.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr);
    end;

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSOClNb(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
{
  Plot nebula and cluster associations - e.g. M8, M42...
}
var
  sz: Double;
  ds,dsr,xx,yy : Integer;
  col,r,g,b : byte;
  nebcolor : Tcolor;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,2*cfgchart.drawpen));
  dsr:=ds div 4;
  nebcolor:=cfgplot.Color[29];                           // Fix color
  if (cfgplot.nebplot=1) and cfgplot.DSOColorFillEN then // SBR color
    begin
      if Asbr<=0 then
        begin
          if Adim<=+0 then
            Adim:=1;
          Asbr:= Ama + 5*log10(Adim) - 0.26;
        end;
  //    adjust colour by using Asbr and UI options
      col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((Asbr-6)/9)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
      r:=cfgplot.Color[29] and $FF;
      g:=(cfgplot.Color[29] shr 8) and $FF;
      b:=(cfgplot.Color[29] shr 16) and $FF;
      nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
      nebcolor := Addcolor(nebcolor,cfgplot.backgroundcolor);
    end;
if cfgplot.UseBMP then begin
  if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillEN then begin// line mode
    cbmp.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr,ColorToBGRA(nebcolor),BGRAPixelTransparent);
    cbmp.DrawHorizLine(xx-ds,yy,xx+ds,ColorToBGRA(nebcolor));
    cbmp.DrawVertLine(xx,yy-ds,yy+ds,ColorToBGRA(nebcolor));
  end else begin
    cbmp.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr,ColorToBGRA(nebcolor),ColorToBGRA(nebcolor));
  end;
end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := nebcolor;
  cnv.Brush.Style := bsSolid;

  if (cfgplot.nebplot=1) and cfgplot.DSOColorFillEN then // graphic mode
    begin
//    in graphic mode, the obect is ALWAYS shown as filled.
      cnv.Pen.Color := nebcolor;
      cnv.Brush.Color := cnv.Pen.Color;
      cnv.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr);
    end;

  if (cfgplot.nebplot=0) or not cfgplot.DSOColorFillEN then // line mode
    begin
      ds:=ds+cfgchart.drawpen;
      if cfgplot.DSOColorFillEN and not cfgchart.onprinter then
        begin
          cnv.Brush.Style := bsSolid;
          cnv.Pen.Color := cfgplot.Color[29];
          cnv.Brush.Color := cnv.Pen.Color;
        end
      else
        begin
          cnv.Brush.Style := bsClear;
          cnv.Pen.Style := psSolid;
        end;
//    and draw it... we're using an rectangle in the event that we don't have an outline
//    Ideally all extended nebulae should have an outline.
      cnv.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr);
      cnv.MoveTo(xx-ds,yy);
      cnv.Pen.Color := cfgplot.Color[24];
      cnv.LineTo(xx+ds,yy);
      cnv.MoveTo(xx,yy-ds);
      cnv.LineTo(xx,yy+ds);
    end;

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSOStar(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
{
  Plot DSO that is actually a single star
}
var
  sz: Double;
  ds,xx,yy : Integer;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  Adim:=0.5;
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,4*cfgchart.drawpen));
  if cfgplot.UseBMP then begin
    cbmp.DrawHorizLine(xx-ds,yy,xx+ds,ColorToBGRA(cfgplot.Color[24]));
    cbmp.DrawVertLine(xx,yy-ds,yy+ds,ColorToBGRA(cfgplot.Color[24]));
  end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := cfgplot.Color[24];

// Plotted as an '+', so there's no difference between line and graphics mode
// we use the same colour as for open clusters

  cnv.MoveTo(xx-ds,yy);
  cnv.LineTo(xx+ds,yy);
  cnv.MoveTo(xx,yy-ds);
  cnv.LineTo(xx,yy+ds);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSODStar(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
{
  Plot DSO that is actually a double star
  DSO's as stars are slit into different routines as we may decide to use
  different symbols for single, or multiple stars cataloged as DSOs.
  ToDO: Implement user-definable symbol sets.
}
var
  sz: Double;
  ds,xx,yy : Integer;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  Adim:=0.5;
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,4*cfgchart.drawpen));
  if cfgplot.UseBMP then begin
    cbmp.DrawHorizLine(xx-ds,yy,xx+ds,ColorToBGRA(cfgplot.Color[24]));
    cbmp.DrawVertLine(xx,yy-ds,yy+ds,ColorToBGRA(cfgplot.Color[24]));
  end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := cfgplot.Color[24];

// Plotted as a '+', so there's no difference between line and graphics mode
// we use the same colour as for open clusters

  cnv.MoveTo(xx-ds,yy);
  cnv.LineTo(xx+ds,yy);
  cnv.MoveTo(xx,yy-ds);
  cnv.LineTo(xx,yy+ds);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSOTStar(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
{
 Plot DSO that is actually a triple star
}
var
  sz: Double;
  ds,xx,yy : Integer;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  Adim:=0.5;
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,4*cfgchart.drawpen));
  if cfgplot.UseBMP then begin
    cbmp.DrawHorizLine(xx-ds,yy,xx+ds,ColorToBGRA(cfgplot.Color[24]));
    cbmp.DrawVertLine(xx,yy-ds,yy+ds,ColorToBGRA(cfgplot.Color[24]));
  end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := cfgplot.Color[24];

// Plotted as a '+', so there's no difference between line and graphics mode
// we use the same colour as for open clusters

  cnv.MoveTo(xx-ds,yy);
  cnv.LineTo(xx+ds,yy);
  cnv.MoveTo(xx,yy-ds);
  cnv.LineTo(xx,yy+ds);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSOAst(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
{
  Asterisms are chance? groupings of stars so plot as for open clusters apart from colour
}
var
  sz: Double;
  ds,xx,yy : Integer;
  col,r,g,b : byte;
  nebcolor : Tcolor;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,2*cfgchart.drawpen));
  nebcolor:=cfgplot.Color[23];                           // Fix color
  if (cfgplot.nebplot=1)and cfgplot.DSOColorFillOCl then // SBR color
    begin
      if Asbr<=0 then
        begin
          if Adim<=+0 then
            Adim:=1;
          Asbr:= Ama + 5*log10(Adim) - 0.26;
        end;
      if Asbr<10 then Asbr:=10;  //some very bright cluster make too bright surface
//    adjust colour by using Asbr and UI options
      col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((Asbr-6)/9)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
      r:=cfgplot.Color[23] and $FF;
      g:=(cfgplot.Color[23] shr 8) and $FF;
      b:=(cfgplot.Color[23] shr 16) and $FF;
      nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
      nebcolor := Addcolor(nebcolor,cfgplot.backgroundcolor);
    end;
if cfgplot.usebmp then begin
    if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillOCl then // line mode
      cbmp.EllipseAntialias(Ax,Ay,ds,ds,ColorToBGRA(nebcolor),cfgchart.drawpen)
    else
      cbmp.FillEllipseAntialias(Ax,Ay,ds,ds,ColorToBGRA(nebcolor));
end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := nebcolor;
  cnv.Brush.Style := bsSolid;

  if (cfgplot.nebplot=1) and cfgplot.DSOColorFillAst then // graphic mode
    begin
      cnv.Pen.Color := nebcolor;
      cnv.Brush.Color := cnv.Pen.Color;
    end;

  if (cfgplot.nebplot=0) or not cfgplot.DSOColorFillAst then // line mode
// line mode
    begin
      ds:=ds+cfgchart.drawpen;
      if cfgplot.DSOColorFillAst and not cfgchart.onprinter then
        begin
          cnv.Brush.Style := bsSolid;
          cnv.Pen.Color := nebcolor;
          cnv.Brush.Color := cnv.Pen.Color;
        end
      else
        begin
          cnv.Pen.Style := psDashDot;
          {$ifdef mswindows}cnv.Pen.width:=1;{$endif}
          cnv.Brush.Style := bsClear;
        end;
//      cnv.MoveTo(xx-ds,yy);
    end;

// and draw it... we're using an ellipse, in future we may adjust this for non-circular asterisms
  cnv.Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSOHIIRegion(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
{
  Plot HII regions. SAC has these catalogued as 'knots'. We plot them as if they
  are emission nebulae (bright nebulae)
}
var
  sz: Double;
  ds,dsr,xx,yy : Integer;
  col,r,g,b : byte;
  nebcolor : Tcolor;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,2*cfgchart.drawpen));
  dsr:=ds div 4;
  nebcolor:=cfgplot.Color[28];                           // Fix color
  if (cfgplot.nebplot=1) and cfgplot.DSOColorFillEN then // SBR color
  begin
    if Asbr<=0 then
      begin
        if Adim<=+0 then
          Adim:=1;
        Asbr:= Ama + 5*log10(Adim) - 0.26;
      end;
//    adjust colour by using Asbr and UI options
    col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((Asbr-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
    r:=cfgplot.Color[28] and $FF;
    g:=(cfgplot.Color[28] shr 8) and $FF;
    b:=(cfgplot.Color[28] shr 16) and $FF;
    nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
    nebcolor := Addcolor(nebcolor,cfgplot.backgroundcolor);
  end;
if cfgplot.UseBMP then begin
  if (cfgplot.nebplot=0)or not cfgplot.DSOColorFillEN then begin// line mode
    cbmp.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr,ColorToBGRA(nebcolor),BGRAPixelTransparent);
    cbmp.DrawHorizLine(xx-ds,yy,xx+ds,ColorToBGRA(nebcolor));
    cbmp.DrawVertLine(xx,yy-ds,yy+ds,ColorToBGRA(nebcolor));
  end else begin
    cbmp.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr,ColorToBGRA(nebcolor),ColorToBGRA(nebcolor));
  end;
end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := cfgplot.Color[28];
  cnv.Brush.Style := bsSolid;

  if (cfgplot.nebplot=1) and cfgplot.DSOColorFillEN then // graphic mode
    begin
      if Asbr<=0 then
        begin
          if Adim<=+0 then
            Adim:=1;
          Asbr:= Ama + 5*log10(Adim) - 0.26;
        end;
//    adjust colour by using Asbr and UI options
      col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-((Asbr-11)/4)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
      r:=cfgplot.Color[28] and $FF;
      g:=(cfgplot.Color[28] shr 8) and $FF;
      b:=(cfgplot.Color[28] shr 16) and $FF;
      nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
//    in graphic mode, the obect is ALWAYS shown as filled.
      cnv.Pen.Color := Addcolor(nebcolor,cfgplot.backgroundcolor);
      cnv.Brush.Color := cnv.Pen.Color;
      cnv.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr);
    end;

  if (cfgplot.nebplot=0) or not cfgplot.DSOColorFillEN then // line mode
    begin
      ds:=ds+cfgchart.drawpen;
      if cfgplot.DSOColorFillEN and not cfgchart.onprinter then
        begin
          cnv.Brush.Style := bsSolid;
          cnv.Pen.Color := cfgplot.Color[28];
          cnv.Brush.Color := cnv.Pen.Color;
        end
      else
        begin
          cnv.Brush.Style := bsClear;
          cnv.Pen.Style := psSolid;
        end;
//    and draw it... we're using an rectangle in the event that we don't have an outline
      cnv.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr);
      cnv.MoveTo(xx-ds,yy);
      cnv.LineTo(xx+ds,yy);
      cnv.MoveTo(xx,yy-ds);
      cnv.LineTo(xx,yy+ds);
    end;

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSOGxyCl(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
{
  Plot galaxy cluster - in SAC they are the Abell clusters, the size is the Abell radius
  confusingly, this is not the *angular* radius of the cluster
}
var
  sz: Double;
  ds,xx,yy : Integer;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,2*cfgchart.drawpen));
  if cfgplot.UseBMP then begin
     cbmp.EllipseAntialias(Ax,Ay,ds,ds,ColorToBGRA(cfgplot.Color[32]),cfgchart.drawpen/2);
  end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psDot;
  {$ifdef mswindows}cnv.Pen.width:=1;{$endif}
  cnv.Pen.Color := cfgplot.Color[32];
  cnv.Brush.Style := bsClear;

{ Plotted as an open dashed circle, so there's no difference between line and
  graphics mode
}
  ds:=ds+cfgchart.drawpen;
  cnv.Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSODN(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer;Amorph:string);
{
  Plot dark nebula
}
var
  sz: Double;
  ds,dsr,xx,yy : Integer;
  col,r,g,b : byte;
  nebcolor : Tcolor;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,2*cfgchart.drawpen));
  dsr:=ds div 4;
  nebcolor:= cfgplot.Color[27];                          // Fix color
  if (cfgplot.nebplot=1) and cfgplot.DSOColorFillDN then // SBR color
    begin
      if Asbr<=0 then
        begin
          if Adim<=+0 then
            Adim:=1;
          Asbr:= Ama + 5*log10(Adim) - 0.26;
        end;
//    adjust colour by using Asbr and UI options
      col:=maxintvalue([cfgplot.Nebgray,minintvalue([cfgplot.Nebbright,trunc(cfgplot.Nebbright-(0.8)*(cfgplot.Nebbright-cfgplot.Nebgray))])]);
      r:=cfgplot.Color[27] and $FF;
      g:=(cfgplot.Color[27] shr 8) and $FF;
      b:=(cfgplot.Color[27] shr 16) and $FF;
      nebcolor:=(r*col div 255)+256*(g*col div 255)+65536*(b*col div 255);
      nebcolor := Addcolor(nebcolor,cfgplot.backgroundcolor);
    end;
  if cfgplot.UseBMP then begin
     cbmp.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr,ColorToBGRA(nebcolor),BGRAPixelTransparent);
  end else begin
  cnv.Pen.Width := cfgchart.drawpen;
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := nebcolor;
  cnv.Brush.Style := bsSolid;

  if (cfgplot.nebplot=1) and cfgplot.DSOColorFillDN then // graphic mode
    begin
//    do not fill the dark nebulae in graphic mode.
      cnv.Brush.Style := bsClear;
      cnv.Pen.Color := nebcolor;
      cnv.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr);
    end;

  if (cfgplot.nebplot=0) or not cfgplot.DSOColorFillDN then // line mode
    begin
      ds:=ds+cfgchart.drawpen;
      if cfgplot.DSOColorFillDN and not cfgchart.onprinter then
        begin
          cnv.Brush.Style := bsSolid;
          cnv.Pen.Color := nebcolor;
          cnv.Brush.Color := cnv.Pen.Color;
        end
      else
        begin
          cnv.Brush.Style := bsClear;
          cnv.Pen.Style := psSolid;
        end;
//    and draw it... we're using an rectangle in the event that we don't have an outline
      cnv.RoundRect(xx-ds,yy-ds,xx+ds,yy+ds,dsr,dsr);
    end;

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSOUnknown(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
{
 Plot unknown object?
}
var
  sz: Double;
  ds,xx,yy : Integer;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  Adim:=0.5;
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,4*cfgchart.drawpen));
  if cfgplot.UseBMP then begin
    cbmp.DrawLine(xx-ds,yy-ds,xx+ds+1,yy+ds,ColorToBGRA(cfgplot.Color[35]),true);
    cbmp.DrawLine(xx+ds,yy-ds,xx-ds,yy+ds+1,ColorToBGRA(cfgplot.Color[35]),true);
  end else begin
  cnv.Pen.Width := cfgchart.drawpen;

  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := cfgplot.Color[35];

// Plotted as an 'X', so there's no difference between line and graphics mode

  cnv.MoveTo(xx-ds,yy-ds);
  cnv.LineTo(xx+ds+1,yy+ds);
  cnv.MoveTo(xx+ds,yy-ds);
  cnv.LineTo(xx-ds,yy+ds+1);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSOCircle(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
{
 Plot a circle
}
var
  sz: Double;
  ds,xx,yy : Integer;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,4*cfgchart.drawpen));
  if cfgplot.UseBMP then begin
    cbmp.EllipseAntialias(Ax-ds,Ay-ds,Ax+ds,Ay+ds,ColorToBGRA(cfgplot.Color[7]),cfgchart.drawpen);
  end else begin
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := cfgplot.Color[7];
  cnv.Brush.Style := bsClear;

// Plotted as a circle, so there's no difference between line and graphics mode

  cnv.Ellipse(xx-ds,yy-ds,xx+ds,yy+ds);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSORectangle(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
{
 Plot a rectangle
}
var
  sz: Double;
  ds,xx,yy : Integer;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,4*cfgchart.drawpen));
  if cfgplot.UseBMP then begin
    cbmp.RectangleAntialias(Ax-ds,Ay-ds,Ax+ds,Ay+ds,ColorToBGRA(cfgplot.Color[7]),cfgchart.drawpen);
  end else begin
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := cfgplot.Color[7];
  cnv.Brush.Style := bsClear;

// Plotted as a rectangle, so there's no difference between line and graphics mode

  cnv.Rectangle(xx-ds,yy-ds,xx+ds,yy+ds);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

Procedure TSplot.PlotDSOlozenge(Ax,Ay: single; Adim,Ama,Asbr,Apixscale : Double ; Atyp : Integer);
{
 Plot a lozenge
}
var
  sz: Double;
  ds,xx,yy : Integer;
begin
// set defaults
  xx:=round(Ax);
  yy:=round(Ay);
  sz:=APixScale*Adim/2;                         // calc size
  ds:=round(max(sz,4*cfgchart.drawpen));
  if cfgplot.UseBMP then begin
    cbmp.DrawPolygonAntialias([PointF(xx,yy-ds),
         PointF(Ax+ds,Ay),
         PointF(Ax,Ay+ds),
         PointF(Ax-ds,Ay),
         PointF(Ax,Ay-ds)],
         ColorToBGRA(cfgplot.Color[7]),cfgchart.drawpen);
  end else begin
  cnv.Pen.Mode:=pmCopy;
  cnv.Pen.Style := psSolid;
  cnv.Pen.Color := cfgplot.Color[7];
  cnv.Brush.Style := bsClear;

// Plotted as a lozenge, so there's no difference between line and graphics mode

  cnv.polygon([point(xx,yy-ds),
         point(xx+ds,yy),
         point(xx,yy+ds),
         point(xx-ds,yy),
         point(xx,yy-ds)]);

// reset brush and pen back to default ready for next object
  cnv.Brush.Style := bsClear;
  cnv.Pen.Style := psSolid;
end;
end;

end.

