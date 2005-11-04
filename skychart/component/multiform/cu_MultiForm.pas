unit cu_MultiForm;
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
    cu_MultiFormChild, SysUtils, Classes, Types, Math,
{$ifdef linux}
    QGraphics, QMenus, QButtons, QControls, QStdCtrls, QExtCtrls, QForms ;
{$endif}
{$ifdef mswindows}
    Graphics, Menus, Buttons,  Controls, StdCtrls, ExtCtrls, Forms ;
{$endif}

type
  ChildArray = array of TChildPanel;
  TMultiForm = class(TPanel)
  private
    { Private declarations }
    FChildIndex,FActiveChild: integer;
    FMaximized, FKeepLastChild: boolean;
    FBorderWidth, FTitleHeight: integer;
    FBorderColor, FInactiveColor, FTitleColor: TColor;
    FonMaximize : TNotifyEvent;
    FonActiveChildChange : TNotifyEvent;
    FChild: ChildArray;
    FWindowList: TmenuItem;
    FWindowListOffset:integer;
    DestroyTimer: TTimer;
    DestroyChild: TChildPanel;
    DefaultPos:TPoint;
    function GetChildCount:integer;
    function GetActiveChild: TChildPanel;
    function GetActiveObject: TForm;
    procedure ChildClose(Sender: TObject);
    procedure ChildMaximize(Sender: TObject);
    procedure ChildRestore(Sender: TObject);
    procedure CaptionChange(Sender: TObject);
    procedure ChildDestroyTimer(Sender: TObject);
    procedure ChildEnter(Sender: TObject);
    procedure FocusChildClick(Sender: TObject);
    procedure SetMaximized(value:boolean);
    procedure SetBorderWidth(value:integer);
    procedure SetTitleHeight(value:integer);
    procedure SetBorderColor(value:TColor);
    procedure SetInactiveColor(value:TColor);
    procedure SetTitleColor(value:TColor);
    procedure SetWindowList(value:TmenuItem);
    procedure SetResize(Sender: TObject);
    procedure ShowContent(Sender: TObject);
    procedure HideContent(Sender: TObject);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
    function NewChild:TChildPanel;
    procedure Cascade;
    procedure TileVertical;
    procedure TileHorizontal;
    procedure SetActiveChild(n:integer);
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property InactiveBorderColor: TColor read FInactiveColor write SetInactiveColor;
    property TitleColor: TColor read FTitleColor write SetTitleColor;
  published
    { Published declarations }
    property WindowList: TmenuItem read FWindowList write SetWindowList;
    property ChildCount: integer read GetChildCount;
    property Childs: ChildArray read FChild;
    property ActiveChild: TChildPanel read GetActiveChild;
    property ActiveObject: TForm read GetActiveObject;
    property Maximized: boolean read FMaximized write SetMaximized;
    property BorderWidth: integer read FBorderWidth write SetBorderWidth;
    property TitleHeight: integer read FTitleHeight write SetTitleHeight;
    property onMaximize: TNotifyEvent read FonMaximize write FonMaximize;
    property onActiveChildChange: TNotifyEvent read FonActiveChildChange write FonActiveChildChange;
    property KeepLastChild: boolean read FKeepLastChild write FKeepLastChild;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CDC', [TMultiForm]);
end;

constructor TMultiForm.Create(AOwner:TComponent);
begin
inherited Create(AOwner);
FChildIndex:=-1;
FActiveChild:=-1;
FKeepLastChild:=false;
FWindowListOffset:=0;
setlength(FChild,0);
color:=clBlack;
align:=alClient;
BevelOuter:=bvNone;
DestroyTimer:=TTimer.create(self);
DestroyTimer.Enabled:=false;
DestroyTimer.Interval:=100;
DestroyTimer.OnTimer:=ChildDestroyTimer;
FBorderWidth:=3;  FTitleHeight:=12;
{$ifdef mswindows}
FBorderColor:=clActiveCaption;
FTitleColor:=clCaptionText;
FInactiveColor:=clInactiveCaption;
{$endif}
{$ifdef linux}
FBorderColor:=clHighlight;
FTitleColor:=clCaptionText;
FInactiveColor:=clDisabledHighlight;
{$endif}

DefaultPos:=Point(0,0);
onResize:=SetResize;
end;

destructor  TMultiForm.Destroy;
begin
try
FActiveChild:=-1;
inherited destroy;
except
end;
end;

Function TMultiForm.NewChild():TChildPanel;
var m: TmenuItem;
begin
inc(FChildIndex);
setlength(FChild,FChildIndex+1);
FChild[FChildIndex]:=TChildPanel.Create(self);
FChild[FChildIndex].Parent:=self;
FChild[FChildIndex].onClose:=ChildClose;
FChild[FChildIndex].onMaximize:=ChildMaximize;
FChild[FChildIndex].onRestore:=ChildRestore;
FChild[FChildIndex].onCaptionChange:=CaptionChange;
FChild[FChildIndex].onEnter:=ChildEnter;
{$ifdef linux}
FChild[FChildIndex].HideContent:=HideContent;
FChild[FChildIndex].ShowContent:=ShowContent;
{$endif}
FChild[FChildIndex].Tag:=FChildIndex;
FChild[FChildIndex].Top:=DefaultPos.Y;
FChild[FChildIndex].Left:=DefaultPos.X;
FActiveChild:=FChildIndex;
if Assigned(FWindowList) then begin
  m:=TmenuItem.Create(self);
  m.Caption:='Child '+ inttostr(FChildIndex);
  m.Tag:=100+FChildIndex;
  m.OnClick:=FocusChildClick;
  FWindowList.Add(m);
end;
FChild[FChildIndex].Maximized:=FMaximized;
SetActiveChild(FChildIndex);
DefaultPos.X:=DefaultPos.X+FTitleHeight;
DefaultPos.Y:=DefaultPos.Y+FTitleHeight;
if DefaultPos.Y>10*FTitleHeight then begin
   DefaultPos.Y:=0;
   if DefaultPos.X>30*FTitleHeight then DefaultPos.X:=0;
end;
result:=FChild[FChildIndex];
end;

procedure TMultiForm.ChildClose(Sender: TObject);
var i,j,n: integer;
begin
n:=(Sender as TChildPanel).Tag;
if Assigned(FWindowList) then begin
  j:=FWindowList.Count;
  for i:=0 to FWindowList.Count-1 do
   if FWindowList.Items[i].tag=100+n then begin
      FWindowList.Delete(i);
      j:=i;
      break;
   end;
  for i:=j to FWindowList.Count-1 do FWindowList.Items[i].tag:=FWindowList.Items[i].tag-1;
end;  
for i:=n to FChildIndex-1 do begin
   FChild[i]:=FChild[i+1];
   FChild[i].Tag:=i;
end;
dec(FChildIndex);
setlength(FChild,FChildIndex+1);
SetActiveChild(FChildIndex);
DestroyChild:=Sender as TChildPanel;
DestroyTimer.Enabled:=true;
end;

procedure TMultiForm.ChildMaximize(Sender: TObject);
var i: integer;
begin
for i:=0 to FChildIndex do begin
   FChild[i].maximized:=true;
end;
FMaximized:=true;
if assigned(FonMaximize) then FonMaximize(self);
end;

procedure TMultiForm.ChildRestore(Sender: TObject);
var i: integer;
begin
for i:=0 to FChildIndex do begin
   FChild[i].maximized:=false;
end;
FMaximized:=false;
if assigned(FonMaximize) then FonMaximize(self);
end;

procedure TMultiForm.SetMaximized(value:boolean);
var i: integer;
begin
FMaximized:=value;
for i:=0 to FChildIndex do begin
  FChild[i].maximized:=FMaximized;
end;
if assigned(FonMaximize) then FonMaximize(self);
end;

procedure TMultiForm.CaptionChange(Sender: TObject);
var i,n: integer;
begin
n:=(Sender as TChildPanel).Tag+100;
if Assigned(FWindowList) then
 for i:=0 to FWindowList.Count-1 do
   if FWindowList.Items[i].tag=n then begin
      FWindowList.Items[i].Caption:=(Sender as TChildPanel).Caption;
      break;
   end;
end;

procedure TMultiForm.ChildDestroyTimer(Sender: TObject);
begin
DestroyTimer.Enabled:=false;
if DestroyChild<>nil then DestroyChild.Free;
DestroyChild:=nil;
end;

function TMultiForm.GetChildCount:integer;
begin
result:= FChildIndex+1;
end;

function TMultiForm.GetActiveChild: TChildPanel;
begin
if FActiveChild>=0 then
   result:=FChild[FActiveChild]
else
   result:=nil;
end;

function TMultiForm.GetActiveObject: TForm;
begin
if FActiveChild>=0 then
   result:=FChild[FActiveChild].DockedObject
else
   result:=nil;
end;

procedure TMultiForm.SetActiveChild(n:integer);
var i:integer;
begin
try
if parent.visible and (n>=0) then begin
//  FChild[n].SetFocus;
  FChild[n].BringToFront;
end;
except
end;
FActiveChild:=n;
for i:=0 to FChildIndex do begin
  if i=n then FChild[i].SetBorderColor(FBorderColor)
         else FChild[i].SetBorderColor(FInactiveColor);
end;
if assigned(FonActiveChildChange) then FonActiveChildChange(self);
end;

procedure TMultiForm.FocusChildClick(Sender: TObject);
begin
SetActiveChild((Sender as TmenuItem).Tag-100);
end;

procedure TMultiForm.ChildEnter(Sender: TObject);
begin
SetActiveChild((Sender as TChildPanel).Tag);
end;

procedure TMultiForm.SetBorderWidth(value:integer);
var i:integer;
begin
FBorderWidth:=value;
for i:=0 to FChildIndex do begin
  FChild[i].BorderWidth:=FBorderWidth;
end;
end;

procedure TMultiForm.SetTitleHeight(value:integer);
var i:integer;
begin
FTitleHeight:=value;
for i:=0 to FChildIndex do begin
  FChild[i].SetTitleHeight(FTitleHeight);
end;
end;

procedure TMultiForm.SetBorderColor(value:TColor);
begin
FBorderColor:=value;
if FActiveChild>=0 then FChild[FActiveChild].SetBorderColor(FBorderColor);
end;

procedure TMultiForm.SetInactiveColor(value:TColor);
var i:integer;
begin
FInactiveColor:=value;
for i:=0 to FChildIndex do begin
  if i<>FActiveChild then FChild[i].SetBorderColor(FInactiveColor);
end;
end;

procedure TMultiForm.SetTitleColor(value:TColor);
var i:integer;
begin
FTitleColor:=value;
for i:=0 to FChildIndex do begin
  FChild[i].SetTitleColor(FTitleColor);
end;
end;

procedure TMultiForm.SetWindowList(value:TmenuItem);
begin
FWindowList:=value;
FWindowListOffset:=FWindowList.Count;
end;

procedure TMultiForm.SetResize(Sender: TObject);
var i: integer;
begin
if Maximized then
  for i:=0 to FChildIndex do begin
    FChild[i].Width:=clientwidth;
    FChild[i].Height:=clientheight;
  end;
end;

procedure TMultiForm.ShowContent(Sender: TObject);
var i: integer;
begin
  for i:=0 to FChildIndex do begin
    FChild[i].DockedPanel.Show;
  end;
end;

procedure TMultiForm.HideContent(Sender: TObject);
var i: integer;
begin
  for i:=0 to FChildIndex do begin
    FChild[i].DockedPanel.Hide;
  end;
end;

procedure TMultiForm.Cascade;
var i,x,y:integer;
begin
Maximized:=false;
x:=0; y:=0;
for i:=0 to FChildIndex do begin
  FChild[i].RestoreSize;
  FChild[i].top:=x;
  FChild[i].left:=y;
  FChild[i].BringToFront;
  x:=x+FTitleHeight;
  y:=y+FTitleHeight;
  if y>10*FTitleHeight then begin
     y:=0;
     if x>30*FTitleHeight then x:=0;
  end;
end;
SetActiveChild(FChildIndex);
end;

procedure TMultiForm.TileVertical;
var i,j,dx,dy,nx,ny,x,y,n:integer;
    d: double;
begin
d:=round(100*sqrt(FChildIndex+1))/100;
ny:=trunc(d);
if frac(d)=0 then nx:=ny
  else if frac(d)<0.5 then nx:=ny+1
       else begin ny:=ny+1; nx:=ny; end;
dx:=clientwidth div nx;
dy:=clientheight div ny;
Maximized:=false;
for i:=0 to nx-1 do begin
 for j:=0 to ny-1 do begin
  x:=i*dx;
  y:=j*dy;
  n:=i*ny+j;
  if n<FChildIndex then begin
    FChild[n].top:=y;
    FChild[n].left:=x;
    FChild[n].width:=dx;
    FChild[n].height:=dy;
  end;
  if n=FChildIndex then begin
    FChild[n].top:=y;
    FChild[n].left:=x;
    FChild[n].width:=dx;
    FChild[n].height:=clientheight-y;
  end;
 end;
end;
end;

procedure TMultiForm.TileHorizontal;
var i,j,dx,dy,nx,ny,x,y,n:integer;
    d: double;
begin
d:=round(100*sqrt(FChildIndex+1))/100;
nx:=trunc(d);
if frac(d)=0 then ny:=nx
  else if frac(d)<0.5 then ny:=nx+1
       else begin nx:=nx+1; ny:=nx; end;
dx:=clientwidth div nx;
dy:=clientheight div ny;
Maximized:=false;
for i:=0 to ny-1 do begin
 for j:=0 to nx-1 do begin
  x:=j*dx;
  y:=i*dy;
  n:=i*nx+j;
  if n<FChildIndex then begin
    FChild[n].top:=y;
    FChild[n].left:=x;
    FChild[n].width:=dx;
    FChild[n].height:=dy;
  end;
  if n=FChildIndex then begin
    FChild[n].top:=y;
    FChild[n].left:=x;
    FChild[n].width:=clientwidth-x;
    FChild[n].height:=dy;
  end;
 end;
end;
end;

end.
