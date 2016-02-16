unit MultiFrame;

{ Copyright (C) 2007 Patrick Chevalley

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

{$mode objfpc}{$H+}

interface

uses
  LCLIntf,LCLType,ChildFrame,
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus, GraphType;

type

  ChildArray = array of TChildFrame;
  
{  TMultiFrame
   The docking area for a TChildFrame component.
   
   Use:
   Create a child frame of your composition.
   On the application main form place a TMultiFrame
   At run time:
   Create a new child from TMultiFrame.NewChild
   Create a child frame with the new childframe as owner.
   Assign the frame to the DockedObject property.
   
   Replace the standard MDI function as below:
   MDIChildCount   -> MultiFrame1.ChildCount
   ActiveMdiChild  -> MultiFrame1.ActiveObject
                   or MultiFrame1.ActiveChild
   MDIChildren[i]  -> MultiFrame1.Childs[i].DockedObject
                   or MultiFrame1.Childs[i]
}
  TMultiFrame = class(TCustomPanel)
  private
    { Private declarations }
    FChildIndex,FActiveChild: integer;
    FMaximized, FKeepLastChild, FWireframeMoveResize: boolean;
    FBorderWidth, FTitleHeight: integer;
    FBorderColor, FInactiveColor, FTitleColor: TColor;
    FonMaximize : TNotifyEvent;
    FOnResize : TNotifyEvent;
    FonActiveChildChange : TNotifyEvent;
    FOnCreateChild : TNotifyEvent;
    FOnDeleteChild : TNotifyEvent;
    FChild: ChildArray;
    DestroyTimer:TTimer;
    DestroyPending: array of TChildFrame;
    DestroyPendingCount: integer;
    DestroyCriticalSection: TCriticalSection;
    FWindowList: TmenuItem;
    FWindowListOffset:integer;
    DefaultPos:TPoint;
    function GetChildCount:integer;
    function GetActiveChild: TChildFrame;
    function GetActiveObject: TFrame;
    procedure ChildClose(Sender: TObject);
    procedure ChildMaximize(Sender: TObject);
    procedure ChildRestore(Sender: TObject);
    procedure CaptionChange(Sender: TObject);
    procedure ChildEnter(Sender: TObject);
    procedure FocusChildClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure SetMaximized(value:boolean);
    procedure SetBorderWidth(value:integer);
    procedure SetTitleHeight(value:integer);
    procedure SetBorderColor(value:TColor);
    procedure SetInactiveColor(value:TColor);
    procedure SetTitleColor(value:TColor);
    procedure SetWindowList(value:TmenuItem);
    procedure SetWireframeMoveResize(value:boolean);
    procedure SetResize(Sender: TObject);
    procedure DestroyChildTimer(Sender: TObject);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor  Destroy; override;
    {
     The list of child window
    }
    property Childs: ChildArray read FChild;
    {
     Create a new child window
    }
    function NewChild(Aname:string=''):TChildFrame;
    {
     Focus next child on list
    }
    function NexChild:integer;
    {
     Cascade the windows
    }
    procedure Cascade;
    {
     Arrange the windows vertically
    }
    procedure TileVertical;
    {
     Arrange the windows horizontally
    }
    procedure TileHorizontal;
    {
     Give the focus to a specific window.
    }
    procedure SetActiveChild(n:integer);
    {
     The number of child actually defined
    }
    property ChildCount: integer read GetChildCount;
    {
     The child that as focus
    }
    property ActiveChild: TChildFrame read GetActiveChild;
    {
     The form contained in ActiveChild, a shortcut for ActiveChild.DockedObject
    }
    property ActiveObject: TFrame read GetActiveObject;
    {
     The border and title color.
     Default value are from the current theme.
    }
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property InactiveBorderColor: TColor read FInactiveColor write SetInactiveColor;
    property TitleColor: TColor read FTitleColor write SetTitleColor;
  published
    { Published declarations }
    {
     The menu that receive the list of child windows
    }
    property WindowList: TmenuItem read FWindowList write SetWindowList;
    {
     Maximise the child windows
    }
    property Maximized: boolean read FMaximized write SetMaximized;
    {
     The desired width for the window border
    }
    property BorderWidth: integer read FBorderWidth write SetBorderWidth;
    {
     The height of the title area
    }
    property TitleHeight: integer read FTitleHeight write SetTitleHeight;
    {
     Set KeepLastChild to true to be sure there is at least one child.
     The last one cannot be closed.
    }
    property KeepLastChild: boolean read FKeepLastChild write FKeepLastChild;
    {
     Set WireframeMoveResize to true to not show the window content during
     move or resize.
    }
    property WireframeMoveResize: boolean read FWireframeMoveResize write SetWireframeMoveResize;
    {
     When the Maximize property change.
     Generally used to draw or hide the resize and close button on the main form.
    }
    property onMaximize: TNotifyEvent read FonMaximize write FonMaximize;
    {
     When the active child change
     Can be use to update the main form title.
    }
    property onActiveChildChange: TNotifyEvent read FonActiveChildChange write FonActiveChildChange;
    {
     When resizings
    }
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    {
     When new child is created
    }
    property OnCreateChild : TNotifyEvent read FOnCreateChild write FOnCreateChild;
    {
     When a child is deleted
    }
    property OnDeleteChild : TNotifyEvent read FOnDeleteChild write FOnDeleteChild;

    published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderStyle;
    property Caption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FullRepaint;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnGetDockCaption;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Misc',[TMultiFrame]);
end;


constructor TMultiFrame.Create(AOwner:TComponent);
begin
inherited Create(AOwner);
DoubleBuffered:=true;
FChildIndex:=-1;
FActiveChild:=-1;
FWindowListOffset:=0;
setlength(FChild,0);
color:=clBlack;
//align:=alClient;
BevelOuter:=bvNone;
BevelWidth:=1;
FBorderWidth:=3;  FTitleHeight:=12;
FBorderColor:=clActiveCaption;
FInactiveColor:=clInactiveCaption;
FTitleColor:=clCaptionText;
{$ifdef lclgtk}
FBorderColor:=$C00000;
FInactiveColor:=clGray;
FTitleColor:=clWhite;
{$endif}
DefaultPos:=Point(0,0);
FOnResize:=nil;
Inherited onResize:=@SetResize;
InitializeCriticalSection(DestroyCriticalSection);
DestroyPendingCount:=0;
SetLength(DestroyPending,DestroyPendingCount);
DestroyTimer:=TTimer.Create(self);
DestroyTimer.Enabled:=false;
DestroyTimer.Interval:=100;
DestroyTimer.OnTimer:=@DestroyChildTimer;
end;

destructor  TMultiFrame.Destroy;
begin
try
DeleteCriticalSection(DestroyCriticalSection);
FActiveChild:=-1;
inherited destroy;
except
end;
end;

Function TMultiFrame.NewChild(Aname:string=''):TChildFrame;
var m: TmenuItem;
begin
inc(FChildIndex);
setlength(FChild,FChildIndex+1);
FChild[FChildIndex]:=TChildFrame.Create(self);
FChild[FChildIndex].Caption:=Aname;
FChild[FChildIndex].Parent:=self;
FChild[FChildIndex].SetBorderWdth(BorderWidth);
FChild[FChildIndex].SetBorderColor(BorderColor);
FChild[FChildIndex].SetTitleHeight(TitleHeight);
FChild[FChildIndex].SetTitleColor(TitleColor);
FChild[FChildIndex].WireframeMoveResize:=WireframeMoveResize;
FChild[FChildIndex].onClose:=@ChildClose;
FChild[FChildIndex].onMaximize:=@ChildMaximize;
FChild[FChildIndex].onRestore:=@ChildRestore;
FChild[FChildIndex].onCaptionChange:=@CaptionChange;
FChild[FChildIndex].onEnter:=@ChildEnter;
FChild[FChildIndex].onCloseQuery:=@FormCloseQuery;
FChild[FChildIndex].Tag:=FChildIndex;
FChild[FChildIndex].Top:=DefaultPos.Y;
FChild[FChildIndex].Left:=DefaultPos.X;
FActiveChild:=FChildIndex;
if Assigned(FWindowList) then begin
  try
  m:=TmenuItem.Create(self);
  m.Caption:='Child '+ inttostr(FChildIndex);
  m.Tag:=100+FChildIndex;
  m.OnClick:=@FocusChildClick;
  FWindowList.Add(m);
  except
  end;
end;
if Assigned(FOnCreateChild) then FOnCreateChild(FChild[FChildIndex]);
FChild[FChildIndex].Maximized:=FMaximized;
SetActiveChild(FChildIndex);
DefaultPos.X:=DefaultPos.X+2*FTitleHeight;
DefaultPos.Y:=DefaultPos.Y+2*FTitleHeight;
if DefaultPos.Y>10*FTitleHeight then begin
   DefaultPos.Y:=0;
   if DefaultPos.X>30*FTitleHeight then DefaultPos.X:=0;
end;
result:=FChild[FChildIndex];
end;

function TMultiFrame.NexChild:integer;
var i: integer;
begin
result:=0;
if FChildIndex>0 then begin
   i:=FActiveChild;
   inc(i);
   if i>FChildIndex then i:=0;
   SetActiveChild(i);
   result:=i;
end;
end;

procedure TMultiFrame.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
CanClose:= not (KeepLastChild and (ChildCount=1));
end;

procedure TMultiFrame.ChildClose(Sender: TObject);
var i,j,n: integer;
begin
if Assigned(FOnDeleteChild) then FOnDeleteChild(Sender);
n:=(Sender as TChildFrame).Tag;
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
EnterCriticalSection(DestroyCriticalSection);
inc(DestroyPendingCount);
SetLength(DestroyPending,DestroyPendingCount);
DestroyPending[DestroyPendingCount-1]:=TChildFrame(Sender);
DestroyTimer.Enabled:=true;
LeaveCriticalSection(DestroyCriticalSection);
end;

procedure TMultiFrame.ChildMaximize(Sender: TObject);
var i: integer;
begin
for i:=0 to FChildIndex do begin
   FChild[i].maximized:=true;
end;
FMaximized:=true;
if assigned(FonMaximize) then FonMaximize(self);
end;

procedure TMultiFrame.ChildRestore(Sender: TObject);
var i: integer;
begin
for i:=0 to FChildIndex do begin
   FChild[i].maximized:=false;
end;
FMaximized:=false;
if assigned(FonMaximize) then FonMaximize(self);
end;

procedure TMultiFrame.SetMaximized(value:boolean);
var i: integer;
begin
FMaximized:=value;
for i:=0 to FChildIndex do begin
  FChild[i].maximized:=FMaximized;
end;
if assigned(FonMaximize) then FonMaximize(self);
end;

procedure TMultiFrame.CaptionChange(Sender: TObject);
var i,n: integer;
begin
n:=(Sender as TChildFrame).Tag+100;
if Assigned(FWindowList) then
 for i:=0 to FWindowList.Count-1 do
   if FWindowList.Items[i].tag=n then begin
      FWindowList.Items[i].Caption:=(Sender as TChildFrame).Caption;
      break;
   end;
end;

function TMultiFrame.GetChildCount:integer;
begin
result:= FChildIndex+1;
end;

function TMultiFrame.GetActiveChild: TChildFrame;
begin
if FActiveChild>=0 then
   result:=FChild[FActiveChild]
else
   result:=nil;
end;

function TMultiFrame.GetActiveObject: TFrame;
begin
if FActiveChild>=0 then
   result:=FChild[FActiveChild].DockedObject
else
   result:=nil;
end;

procedure TMultiFrame.SetActiveChild(n:integer);
var i:integer;
    change: boolean;
begin
try
if (n<0)or(n>FChildIndex) then exit;
if (parent<>nil) and parent.visible and (n>=0) then begin
  FChild[n].BringToFront;
end;
except
end;
change:=(FActiveChild<>n);
FActiveChild:=n;
try
for i:=0 to FChildIndex do begin
  if i=n then FChild[i].SetBorderColor(FBorderColor)
         else FChild[i].SetBorderColor(FInactiveColor);
end;
if change and assigned(FonActiveChildChange) then FonActiveChildChange(self);
except
end;
end;

procedure TMultiFrame.FocusChildClick(Sender: TObject);
begin
SetActiveChild((Sender as TmenuItem).Tag-100);
end;

procedure TMultiFrame.ChildEnter(Sender: TObject);
begin
SetActiveChild((Sender as TChildFrame).Tag);
end;

procedure TMultiFrame.SetBorderWidth(value:integer);
var i:integer;
begin
FBorderWidth:=value;
for i:=0 to FChildIndex do begin
  FChild[i].BorderWidth:=FBorderWidth;
end;
end;

procedure TMultiFrame.SetTitleHeight(value:integer);
var i:integer;
begin
FTitleHeight:=value;
for i:=0 to FChildIndex do begin
  FChild[i].SetTitleHeight(FTitleHeight);
end;
end;

procedure TMultiFrame.SetBorderColor(value:TColor);
begin
FBorderColor:=value;
if FActiveChild>=0 then FChild[FActiveChild].SetBorderColor(FBorderColor);
end;

procedure TMultiFrame.SetInactiveColor(value:TColor);
var i:integer;
begin
FInactiveColor:=value;
for i:=0 to FChildIndex do begin
  if i<>FActiveChild then FChild[i].SetBorderColor(FBorderColor);
end;
end;

procedure TMultiFrame.SetTitleColor(value:TColor);
var i:integer;
begin
FTitleColor:=value;
for i:=0 to FChildIndex do begin
  FChild[i].SetTitleColor(FTitleColor);
end;
end;

procedure TMultiFrame.SetWireframeMoveResize(value:boolean);
var i:integer;
begin
FWireframeMoveResize:=value;
for i:=0 to FChildIndex do begin
  FChild[i].WireframeMoveResize:=FWireframeMoveResize;
end;
end;

procedure TMultiFrame.SetWindowList(value:TmenuItem);
begin
FWindowList:=value;
FWindowListOffset:=FWindowList.Count;
end;

procedure TMultiFrame.SetResize(Sender: TObject);
var i: integer;
begin
if Maximized then
  for i:=0 to FChildIndex do begin
    FChild[i].top:=0;
    FChild[i].left:=0;
    FChild[i].Width:=ClientWidth;
    FChild[i].Height:=ClientHeight;
  end;
if Assigned(FOnResize) then  FOnResize(Sender);
end;

procedure TMultiFrame.Cascade;
var i,x,y:integer;
begin
Maximized:=false;
if ChildCount>0 then begin
x:=0; y:=0;
for i:=0 to FChildIndex do begin
  FChild[i].RestoreSize;
  FChild[i].top:=x;
  FChild[i].left:=y;
  FChild[i].BringToFront;
  x:=x+2*FTitleHeight;
  y:=y+2*FTitleHeight;
  if y>10*FTitleHeight then begin
     y:=0;
     if x>30*FTitleHeight then x:=0;
  end;
end;
SetActiveChild(FChildIndex);
end;
end;

procedure TMultiFrame.TileVertical;
var i,j,dx,dy,nx,ny,x,y,n:integer;
    d: double;
begin
Maximized:=false;
if ChildCount>0 then begin
  d:=round(100*sqrt(FChildIndex+1))/100;
  ny:=trunc(d);
  if frac(d)=0 then nx:=ny
    else if frac(d)<0.5 then nx:=ny+1
         else begin ny:=ny+1; nx:=ny; end;
  dx:=clientwidth div nx;
  dy:=clientheight div ny;
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
end;

procedure TMultiFrame.TileHorizontal;
var i,j,dx,dy,nx,ny,x,y,n:integer;
    d: double;
begin
Maximized:=false;
if ChildCount>0 then begin
  d:=round(100*sqrt(FChildIndex+1))/100;
  nx:=trunc(d);
  if frac(d)=0 then ny:=nx
    else if frac(d)<0.5 then ny:=nx+1
         else begin nx:=nx+1; ny:=nx; end;
  dx:=clientwidth div nx;
  dy:=clientheight div ny;
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
end;

procedure TMultiFrame.DestroyChildTimer(Sender: TObject);
var i,n: integer;
begin
DestroyTimer.Enabled:=false;
EnterCriticalSection(DestroyCriticalSection);
n:=DestroyPendingCount-1;
if n>=0 then begin
  for i:=0 to n do begin
     if DestroyPending[i]<>nil then
        DestroyPending[i].Free;
  end;
end;
DestroyPendingCount:=0;
SetLength(DestroyPending,DestroyPendingCount);
LeaveCriticalSection(DestroyCriticalSection);
end;

end.
