unit cu_MultiFormChild;
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

uses
    SysUtils, Classes, Types, Math,
{$ifdef linux}
    QGraphics, QButtons, QControls, QStdCtrls, QExtCtrls, QForms ;
{$endif}
{$ifdef mswindows}
    Graphics, Buttons,  Controls, StdCtrls, ExtCtrls, Forms ;
{$endif}

type
  TChildPanel = class(TPanel)
    TopLeftBar, TopRightBar, BotLeftBar, BotRightBar : TPanel;
    TopBar, BotBar, LeftBar, RightBar : TPanel;
    MenuBar: TPanel;
    Title: TLabel;
    ButtonClose: TSpeedButton;
    ButtonMaximize: TSpeedButton;
  private
    { Private declarations }
    FDockedObject: TForm;
    FDockedPanel: TPanel;
    FCaption: string;
    startpoint: TPoint;
    moving, sizing, lockmove: boolean;
    FMaximized: boolean;
    save_top,save_left,save_width,save_height,ini_width,ini_height: integer;
    borderwidth, titleheight: integer;
    titlecolor, bordercolor: TColor;
    FonClose : TNotifyEvent;
    FonMaximize : TNotifyEvent;
    FonRestore : TNotifyEvent;
    FonCaptionChange: TNotifyEvent;
    FHideContent: TNotifyEvent;
    FShowContent: TNotifyEvent;
    procedure SetDockedPanel(value: TPanel);
    procedure SetCaption(value: string);
    procedure SetMaximized(value: boolean);
    procedure Maximize;
    procedure Restore;
    procedure MenuBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MenuBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SizeBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SizeBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SizeBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonMaximizeClick(Sender: TObject);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
    procedure SetTitleColor(col:TColor);
    procedure SetBorderColor(col:TColor);
    procedure SetTitleHeight(x:integer);
    procedure SetBorderWidth(x:integer);
    procedure RestoreSize;
    property onMaximize: TNotifyEvent read FonMaximize write FonMaximize;
    property onRestore: TNotifyEvent read FonRestore write FonRestore;
    property onClose: TNotifyEvent read FonClose write FonClose;
    property onCaptionChange: TNotifyEvent read FonCaptionChange write FonCaptionChange;
    property HideContent: TNotifyEvent read FHideContent write FHideContent;
    property ShowContent: TNotifyEvent read FShowContent write FShowContent;
  published
    { Published declarations }
    procedure Close;
    property DockedObject:TForm read FDockedObject;
    property DockedPanel: TPanel read FDockedPanel write SetDockedPanel;
    property Caption: string read FCaption write SetCaption;
    property Maximized: boolean read FMaximized write SetMaximized;
  end;

implementation

Uses cu_MultiForm;

{$R button.res}

const
{$ifdef mswindows}
   font_offset=0;
{$endif}
{$ifdef linux}
   font_offset=-4;
{$endif}

constructor TChildPanel.Create(AOwner:TComponent);
begin
inherited Create(AOwner);
BorderWidth:=3;  TitleHeight:=12;
{$ifdef mswindows}
BorderColor:=clActiveCaption; TitleColor:=clCaptionText;
{$endif}
{$ifdef linux}
BorderColor:=clHighlight; TitleColor:=clCaptionText;
{$endif}
if (AOWner is TMultiForm) then begin
  BorderWidth:=(AOWner as TMultiForm).BorderWidth;
  BorderColor:=(AOWner as TMultiForm).BorderColor;
  TitleHeight:=(AOWner as TMultiForm).TitleHeight;
  TitleColor:=(AOWner as TMultiForm).TitleColor;
end;
color:=clBlack;
FDockedObject:=nil;
FDockedPanel:=nil;
FCaption:='';
BevelOuter:=bvNone;
//fullrepaint:=false;
TopLeftBar:=TPanel.Create(self);
TopLeftBar.Parent:=self;
TopLeftBar.Tag:=5;
TopLeftBar.Height:=borderwidth;
TopLeftBar.Width:=borderwidth;
TopLeftBar.Top:=0;
TopLeftBar.Left:=0;
TopLeftBar.BevelOuter:=bvNone;
TopLeftBar.Color:=BorderColor;
TopLeftBar.Cursor:=crSizeNWSE;
TopLeftBar.Anchors:=[akLeft,akTop];
TopLeftBar.OnMouseDown:=SizeBarMouseDown;
TopLeftBar.OnMouseUp:=SizeBarMouseUp;
TopLeftBar.OnMouseMove:=SizeBarMouseMove;
TopRightBar:=TPanel.Create(self);
TopRightBar.Tag:=6;
TopRightBar.Parent:=self;
TopRightBar.Height:=borderwidth;
TopRightBar.Width:=borderwidth;
TopRightBar.Top:=0;
TopRightBar.Left:=width-borderwidth;
TopRightBar.BevelOuter:=bvNone;
TopRightBar.Color:=BorderColor;
TopRightBar.Cursor:=crSizeNESW;
TopRightBar.Anchors:=[akRight,akTop];
TopRightBar.OnMouseDown:=SizeBarMouseDown;
TopRightBar.OnMouseUp:=SizeBarMouseUp;
TopRightBar.OnMouseMove:=SizeBarMouseMove;
BotLeftBar:=TPanel.Create(self);
BotLeftBar.Tag:=7;
BotLeftBar.Parent:=self;
BotLeftBar.Width:=borderwidth;
BotLeftBar.Height:=borderwidth;
BotLeftBar.Top:=height-borderwidth;
BotLeftBar.Left:=0;
BotLeftBar.BevelOuter:=bvNone;
BotLeftBar.Color:=BorderColor;
BotLeftBar.Cursor:=crSizeNESW;
BotLeftBar.Anchors:=[akLeft,akBottom];
BotLeftBar.OnMouseDown:=SizeBarMouseDown;
BotLeftBar.OnMouseUp:=SizeBarMouseUp;
BotLeftBar.OnMouseMove:=SizeBarMouseMove;
BotRightBar:=TPanel.Create(self);
BotRightBar.Parent:=self;
BotRightBar.Tag:=8;
BotRightBar.Width:=borderwidth;
BotRightBar.Height:=borderwidth;
BotRightBar.Top:=height-borderwidth;
BotRightBar.Left:=Width-borderwidth;
BotRightBar.BevelOuter:=bvNone;
BotRightBar.Color:=BorderColor;
BotRightBar.Cursor:=crSizeNWSE;
BotRightBar.Anchors:=[akRight,akBottom];
BotRightBar.OnMouseDown:=SizeBarMouseDown;
BotRightBar.OnMouseUp:=SizeBarMouseUp;
BotRightBar.OnMouseMove:=SizeBarMouseMove;
TopBar:=TPanel.Create(self);
TopBar.Parent:=self;
TopBar.Tag:=1;
TopBar.Height:=borderwidth;
TopBar.BevelOuter:=bvNone;
TopBar.Color:=BorderColor;
TopBar.Cursor:=crSizeNS;
TopBar.Align:=alTop;
TopBar.OnMouseDown:=SizeBarMouseDown;
TopBar.OnMouseUp:=SizeBarMouseUp;
TopBar.OnMouseMove:=SizeBarMouseMove;
BotBar:=TPanel.Create(self);
BotBar.Tag:=2;
BotBar.Parent:=self;
BotBar.Height:=borderwidth;
BotBar.BevelOuter:=bvNone;
BotBar.Color:=BorderColor;
BotBar.Cursor:=crSizeNS;
BotBar.Align:=alBottom;
BotBar.OnMouseDown:=SizeBarMouseDown;
BotBar.OnMouseUp:=SizeBarMouseUp;
BotBar.OnMouseMove:=SizeBarMouseMove;
LeftBar:=TPanel.Create(self);
LeftBar.Tag:=3;
LeftBar.Parent:=self;
LeftBar.Width:=borderwidth;
LeftBar.BevelOuter:=bvNone;
LeftBar.Color:=BorderColor;
LeftBar.Cursor:=crSizeWE;
LeftBar.Align:=alLeft;
LeftBar.OnMouseDown:=SizeBarMouseDown;
LeftBar.OnMouseUp:=SizeBarMouseUp;
LeftBar.OnMouseMove:=SizeBarMouseMove;
RightBar:=TPanel.Create(self);
RightBar.Parent:=self;
RightBar.Tag:=4;
RightBar.Width:=borderwidth;
RightBar.BevelOuter:=bvNone;
RightBar.Color:=BorderColor;
RightBar.Cursor:=crSizeWE;
RightBar.Align:=alRight;
RightBar.OnMouseDown:=SizeBarMouseDown;
RightBar.OnMouseUp:=SizeBarMouseUp;
RightBar.OnMouseMove:=SizeBarMouseMove;
MenuBar:=TPanel.Create(self);
MenuBar.Parent:=self;
MenuBar.Height:=TitleHeight;
MenuBar.BevelOuter:=bvNone;
MenuBar.Color:=BorderColor;
MenuBar.Align:=alTop;
MenuBar.OnMouseDown:=MenuBarMouseDown;
MenuBar.OnMouseUp:=MenuBarMouseUp;
MenuBar.OnMouseMove:=MenuBarMouseMove;
//MenuBar.OnDblClick:=ButtonMaximizeClick;
ButtonClose:=TSpeedButton.Create(self);
ButtonClose.Width:=TitleHeight-2;
ButtonClose.Height:=TitleHeight-2;
ButtonClose.Transparent:=true;
ButtonClose.Flat:=true;
ButtonClose.Caption:='';
ButtonClose.Glyph.LoadFromResourceName(HInstance,'CLOSE');
ButtonClose.Parent:=MenuBar;
ButtonClose.Align:=alRight;
ButtonClose.OnClick:=ButtonCloseClick;
ButtonMaximize:=TSpeedButton.Create(self);
ButtonMaximize.Width:=TitleHeight-2;
ButtonMaximize.Height:=TitleHeight-2;
ButtonMaximize.Transparent:=true;
ButtonMaximize.Flat:=true;
ButtonMaximize.Caption:='';
ButtonMaximize.Glyph.LoadFromResourceName(HInstance,'MAXI');
ButtonMaximize.Parent:=MenuBar;
ButtonMaximize.Align:=alRight;
ButtonMaximize.OnClick:=ButtonMaximizeClick;
Title:=TLabel.Create(self);
Title.Parent:=MenuBar;
Title.Top:=font_offset;
Title.Left:=4;
Title.Font.Height:=-(TitleHeight-2);
Title.Font.Color:=TitleColor;
Title.Caption:=FCaption;
Title.OnMouseDown:=MenuBarMouseDown;
Title.OnMouseUp:=MenuBarMouseUp;
Title.OnMouseMove:=MenuBarMouseMove;
//Title.OnDblClick:=ButtonMaximizeClick;
TopBar.Top:=0;
TopLeftBar.BringToFront;
TopRightBar.BringToFront;
BotLeftBar.BringToFront;
BotRightBar.BringToFront;
moving:=false;
sizing:=false;
lockmove:=false;
end;

destructor TChildPanel.Destroy;
begin
try
Title.Free;
ButtonClose.Free;
ButtonMaximize.Free;
MenuBar.Free;
RightBar.Free;
LeftBar.Free;
BotBar.Free;
TopBar.Free;
TopLeftBar.Free;
TopRightBar.Free;
BotLeftBar.Free;
BotRightBar.Free;
inherited destroy;
except
end;
end;

procedure TChildPanel.SetDockedPanel(value: TPanel);
begin
if FDockedObject<>nil then FDockedObject.Free;
FDockedObject:=tform(value.Parent);
FDockedObject.Hide;
FDockedPanel:=value;
FDockedPanel.Parent:=self;
save_top:=top; save_left:=left;
ini_Width:=FDockedPanel.Width+2*borderwidth;
ini_Height:=FDockedPanel.Height+2*borderwidth+titleheight;
save_Width:=ini_Width;
save_Height:=ini_Height;
if not FMaximized then begin
  ClientWidth:=ini_Width;
  ClientHeight:=ini_Height;
end;
FDockedPanel.Align:=alClient;
Caption:=FDockedPanel.Caption;
TopLeftBar.BringToFront;
TopRightBar.BringToFront;
BotLeftBar.BringToFront;
BotRightBar.BringToFront;
end;

procedure TChildPanel.SetCaption(value: string);
begin
FCaption:=value;
Title.Caption:=FCaption;
if assigned(FonCaptionChange) then FonCaptionChange(self);
end;

procedure TChildPanel.MenuBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
onEnter(self);
startpoint:=clienttoscreen(point(X,Y));
moving:=true;
if assigned(FHideContent) then FHideContent(self);
end;

procedure TChildPanel.MenuBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
moving:=false;
if assigned(FShowContent) then FShowContent(self);
end;

procedure TChildPanel.MenuBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var P: Tpoint;
begin
if moving and (not lockmove) then begin
  lockmove:=true;
  P:=clienttoscreen(Point(X,Y));
  top:=top+P.Y-startpoint.Y;
  if top<0 then top:=0;
  if top>(parent.ClientHeight-MenuBar.Height) then top:=parent.ClientHeight-MenuBar.Height;
  left:=left+P.X-startpoint.X;
  if left<-(width-2*MenuBar.Height) then left:=-(width-2*MenuBar.Height);
  if left>(parent.ClientWidth-MenuBar.Height) then left:=parent.ClientWidth-MenuBar.Height;
  startpoint:=P;
  application.ProcessMessages;
  lockmove:=false;
end;
end;

procedure TChildPanel.SizeBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
onEnter(self);
startpoint:=clienttoscreen(point(X,Y));
sizing:=true;
if assigned(FHideContent) then FHideContent(self);
end;

procedure TChildPanel.SizeBarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
sizing:=false;
if assigned(FShowContent) then FShowContent(self);
end;

procedure TChildPanel.SizeBarMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var P: Tpoint;
    dx,dy: integer;
begin
if sizing and (not lockmove) then begin
  lockmove:=true;
  P:=clienttoscreen(Point(X,Y));
  dy:=P.Y-startpoint.Y;
  dx:=P.X-startpoint.X;
  case (sender as TPanel).Tag of
  1: begin  // Top
     height:=height-dy;
     top:=top+dy;
     startpoint:=P;
     end;
  2: begin  // Bottom
     height:=height+dy;
     end;
  3: begin // Left
     width:=width-dx;
     left:=left+dx;
     startpoint:=P;
     end;
  4: begin // Right
     width:=width+dx;
     end;
  5: begin  // Top Left
     height:=height-dy;
     top:=top+dy;
     width:=width-dx;
     left:=left+dx;
     startpoint:=P;
     end;
  6: begin  // Top Right
     height:=height-dy;
     top:=top+dy;
     width:=width+dx;
     startpoint.Y:=P.Y;
     end;
  7: begin // Bottom Left
     height:=height+dy;
     width:=width-dx;
     left:=left+dx;
     startpoint.X:=P.X;
     end;
  8: begin // Bottom Right
     height:=height+dy;
     width:=width+dx;
     end;
  end;
  height:=max(height,MenuBar.Height+Topbar.Height);
  width:=max(width,Title.width+ButtonClose.width+ButtonMaximize.width);
  top:=max(top,0);
  top:=min(top,parent.ClientHeight-MenuBar.Height-Topbar.Height);
  left:=max(left,-width+2*MenuBar.Height);
  left:=min(left,parent.ClientWidth-MenuBar.Height);
  application.ProcessMessages;
  lockmove:=false;
end;
end;

Procedure TChildPanel.Close;
begin
 if assigned(FonClose) then FonClose(self);
end;

procedure TChildPanel.ButtonCloseClick(Sender: TObject);
begin
 if (parent as TMultiForm).KeepLastChild and ((parent as TMultiForm).ChildCount=1) then exit
    else Close;
end;

Procedure TChildPanel.Maximize;
begin
 FMaximized:=true;
 save_top:=top;
 save_left:=left;
 save_width:=width;
 save_height:=height;
 top:=0;
 left:=0;
 width:=parent.Width;
 height:=parent.Height;
 MenuBar.Visible:=false;
 TopLeftBar.Visible:=false;
 TopRightBar.Visible:=false;
 BotLeftBar.Visible:=false;
 BotRightBar.Visible:=false;
 TopBar.Visible:=false;
 BotBar.Visible:=false;
 LeftBar.Visible:=false;
 RightBar.Visible:=false;
 if assigned(FonMaximize) then FonMaximize(self);
end;

Procedure TChildPanel.Restore;
begin
 FMaximized:=false;
 top:=save_top;
 left:=save_left;
 width:=save_width;
 height:=save_height;
 MenuBar.Visible:=true;
 TopLeftBar.Visible:=true;
 TopRightBar.Visible:=true;
 BotLeftBar.Visible:=true;
 BotRightBar.Visible:=true;
 TopBar.Visible:=true;
 BotBar.Visible:=true;
 LeftBar.Visible:=true;
 RightBar.Visible:=true;
 if assigned(FonRestore) then FonRestore(self);
end;

Procedure TChildPanel.RestoreSize;
begin
 width:=ini_width;
 height:=ini_height;
end;

procedure TChildPanel.SetMaximized(value:boolean);
begin
if FMaximized<>value then begin
   FMaximized:=value;
   if FMaximized then
      Maximize
   else
      Restore
end;
end;

procedure TChildPanel.ButtonMaximizeClick(Sender: TObject);
begin
 Maximized:=not FMaximized;
end;

procedure TChildPanel.SetTitleColor(col:TColor);
begin
TitleColor:=col;
Title.Font.Color:=TitleColor;
end;

procedure TChildPanel.SetBorderColor(col:TColor);
begin
BorderColor:=col;
TopLeftBar.Color:=BorderColor;
TopRightBar.Color:=BorderColor;
BotLeftBar.Color:=BorderColor;
BotRightBar.Color:=BorderColor;
TopBar.Color:=BorderColor;
BotBar.Color:=BorderColor;
LeftBar.Color:=BorderColor;
RightBar.Color:=BorderColor;
MenuBar.Color:=BorderColor;

end;

procedure TChildPanel.SetTitleHeight(x:integer);
begin
TitleHeight:=x;
MenuBar.Height:=TitleHeight;
ButtonMaximize.Width:=TitleHeight-2;
ButtonMaximize.Height:=TitleHeight-2;
ButtonClose.Width:=TitleHeight-2;
ButtonClose.Height:=TitleHeight-2;
Title.Font.Height:=-(TitleHeight-2);
end;

procedure TChildPanel.SetBorderWidth(x:integer);
begin
TopLeftBar.SendtoBack;
TopRightBar.SendtoBack;
BotLeftBar.SendtoBack;
BotRightBar.SendtoBack;
BorderWidth:=x;
TopLeftBar.Height:=borderwidth;
TopLeftBar.Width:=borderwidth;
TopLeftBar.Top:=0;
TopLeftBar.Left:=0;
TopRightBar.Height:=borderwidth;
TopRightBar.Width:=borderwidth;
TopRightBar.Top:=0;
TopRightBar.Left:=width-borderwidth;
BotLeftBar.Width:=borderwidth;
BotLeftBar.Height:=borderwidth;
BotLeftBar.Top:=height-borderwidth;
BotLeftBar.Left:=0;
BotRightBar.Width:=borderwidth;
BotRightBar.Height:=borderwidth;
BotRightBar.Top:=height-borderwidth;
BotRightBar.Left:=Width-borderwidth;
TopBar.Height:=borderwidth;
TopBar.Top:=0;
BotBar.Height:=borderwidth;
BotBar.Top:=height-borderwidth;
LeftBar.Width:=borderwidth;
LeftBar.Left:=0;
RightBar.Width:=borderwidth;
RightBar.Left:=width-borderwidth;
TopLeftBar.BringToFront;
TopRightBar.BringToFront;
BotLeftBar.BringToFront;
BotRightBar.BringToFront;
end;

end.
