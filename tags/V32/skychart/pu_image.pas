unit pu_image;

{$MODE Delphi}{$H+}

{
Copyright (C) 2005 Patrick Chevalley

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
interface

uses Math, u_util, u_translation,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, cu_zoomimage,
  LResources;

type
  Tf_image = class(TForm)
    Image1: TZoomImage;
    Panel1: TPanel;
    VScrollBar: TScrollBar;
    HScrollBar: TScrollBar;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure HScrollBarChange(Sender: TObject);
    procedure VScrollBarChange(Sender: TObject);
  private
    { Private declarations }
    scrollw, scrollh : integer;
    ScrollLock: boolean;
    procedure SetScrollBar;
  public
    { Public declarations }
    titre,labeltext: string;
    imagewidth,imageheight: integer;
    procedure SetLang;
    Procedure LoadImage(f : string);
    Procedure ZoomN(n:double);
    Procedure Zoomplus;
    Procedure Zoommoins;
    Procedure Init;
  end;

var
  f_image: Tf_image;

implementation

procedure Tf_image.SetLang;
begin
Button1.caption:=rsClose;
Button2.caption:=rsZoom;
Button3.caption:=rsZoom2;
end;

Procedure Tf_image.LoadImage(f : string);
begin
 image1.Zoom:=1;
 image1.picture.LoadFromFile(f);
 imagewidth:=image1.picture.width;
 imageheight:=image1.picture.height;
end;

Procedure Tf_image.ZoomN(n:double);
begin
   Image1.Zoom:=n;
   Image1.Draw;
   SetScrollBar;
   Caption:=titre+' x'+formatfloat('0.#',Image1.Zoom);
end;

Procedure Tf_image.Zoomplus;
begin
   Image1.Zoom:=1.5*Image1.Zoom;
   Image1.Draw;
   SetScrollBar;
   Caption:=titre+' x'+formatfloat('0.#',Image1.Zoom);
end;

Procedure Tf_image.Zoommoins;
begin
   Image1.Zoom:=Image1.Zoom/1.5;
   if abs(Image1.Zoom-1)<0.2 then Image1.Zoom:=1;
   Image1.Draw;
   SetScrollBar;
   Caption:=titre+' x'+formatfloat('0.#',Image1.Zoom);
end;

procedure Tf_image.FormKeyPress(Sender: TObject; var Key: Char);
begin
if key=chr(27) then Close;
if (key='+') then Zoomplus;
if (key='-') then Zoommoins;
end;

procedure Tf_image.Init;
begin
Image1.Draw;
Hscrollbar.Position:=Image1.SizeX div 2;
Vscrollbar.Position:=Image1.SizeY div 2;
Caption:=titre+' x'+formatfloat('0.#',Image1.Zoom);
label1.Caption:=labeltext;
end;

procedure Tf_image.Button2Click(Sender: TObject);
begin
Zoomplus;
end;

procedure Tf_image.Button3Click(Sender: TObject);
begin
Zoommoins;
end;

procedure Tf_image.Button1Click(Sender: TObject);
begin
close;
end;

procedure Tf_image.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
if wheeldelta>0 then Zoomplus
                else Zoommoins;
end;

procedure Tf_image.FormCreate(Sender: TObject);
begin
SetLang;
Image1.Align:=alClient;
titre:='';
labeltext:='';
VScrollBar.Width:=15;
end;

procedure Tf_image.FormResize(Sender: TObject);
begin
if visible then begin
   Image1.Draw;
   SetScrollBar;
end;   
end;

Procedure Tf_image.SetScrollBar;
begin
try
ScrollLock:=true;
scrollw:=min(Image1.SizeX-1,round(Image1.Width/Image1.zoom)) div 2;
Hscrollbar.SetParams(Hscrollbar.Position, scrollw, Image1.SizeX-scrollw,1);
Hscrollbar.LargeChange:=scrollw;
Hscrollbar.SmallChange:=scrollw div 10;
scrollh:=min(Image1.SizeY-1,round(Image1.Height/Image1.zoom)) div 2;
Vscrollbar.SetParams(Vscrollbar.Position, scrollh, Image1.SizeY-scrollh,1);
Vscrollbar.LargeChange:=scrollh;
Vscrollbar.SmallChange:=scrollh div 10;
finally
ScrollLock:=false;
end;
end;

procedure Tf_image.HScrollBarChange(Sender: TObject);
begin
if scrolllock then exit;
Image1.Xcentre:=HScrollBar.Position;
Image1.Draw;
end;

procedure Tf_image.VScrollBarChange(Sender: TObject);
begin
if scrolllock then exit;
Image1.Ycentre:=VScrollBar.Position;
Image1.Draw;
end;

initialization
  {$i pu_image.lrs}

end.
