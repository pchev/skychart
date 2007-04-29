unit jdcalendar; 
{
Copyright (C) 2006 Patrick Chevalley

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

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Dialogs, LCLType, Grids, StdCtrls,
  Controls, ExtCtrls, Types, GraphType, Graphics, Forms, Buttons, MaskEdit,
  Math, LResources, EditBtn, enhedits;


type
  TDatesLabelsArray= record
                mon,tue,wed,thu,fri,sat,sun,today,jd : string
                end;

type
  TJDMonthlyCalendarGrid = class(TStringGrid)
  private
    { Private declarations }
    jdt: double;
    i,wd,y,m,d,cy,cm,cd : integer;
    h,ch,j : double;
    sel: TGridRect;
    Flabels: TDatesLabelsArray;
    procedure SetJD(Value: double);
    procedure SetLabels(Value: TDatesLabelsArray);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer; aRect: TRect; aState: TGridDrawState);
  public
    { Public declarations }
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
     property labels: TDatesLabelsArray read Flabels write SetLabels;
  published
    { Published declarations }
     property JD : double read jdt write SetJD;
  end;


type
  TJDMonthlyCalendar = class(TPanel)
  private
    { Private declarations }
    CalendarGrid: TJDMonthlyCalendarGrid;
    TopPanel: TPanel;
    BottomPanel: TPanel;
    FYear: TLongEdit;
    FMonth: TLongEdit;
    Julian: TFloatEdit;
    UpYear, DownYear, UpMonth, DownMonth: TButton;
    Today: TButton;
    JDlabel: TLabel;
    jdt: double;
    Fday: integer;
    Flabels: TDatesLabelsArray;
    lockdate: boolean;
    FonDateSelect, FonDblClick: TNotifyEvent;
    procedure SetJD(Value: double);
    procedure SetYear(Value: integer);
    function ReadYear: integer;
    procedure SetMonth(Value: integer);
    function ReadMonth: integer;
    procedure SetDay(Value: integer);
    procedure SetLabels(Value: TDatesLabelsArray);
    procedure UpdVal;
    procedure CalendarGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CalendarGridDblClick(Sender: TObject);
    procedure DateChange(Sender: TObject);
    procedure JDChange(Sender: TObject);
    procedure TodayClick(Sender: TObject);
    procedure UpYearClick(Sender: TObject);
    procedure DownYearClick(Sender: TObject);
    procedure UpMonthClick(Sender: TObject);
    procedure DownMonthClick(Sender: TObject);
  public
    { Public declarations }
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
     property labels: TDatesLabelsArray read Flabels write SetLabels;
  published
    { Published declarations }
     property JD : double read jdt write SetJD;
     property Year : integer read ReadYear write SetYear;
     property Month : integer read ReadMonth write SetMonth;
     property Day : integer read Fday write SetDay;
     property onDateSelect: TNotifyEvent read FonDateSelect write FonDateSelect;
     property onDblClick: TNotifyEvent read FonDblClick write FonDblClick;
  end;

{ TJDCalendarDialog }

  TJDCalendarDialog = class(TCommonDialog)
  private
    savejd:double;
    DF:TForm;
    Flabels: TDatesLabelsArray;
    Fcaption:string;
    AnchorComponent: TControl;
    FBorderStyle: TFormBorderStyle;
    JDCalendar:TJDMonthlyCalendar;
    procedure CalendarDblClick(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
    property labels: TDatesLabelsArray read Flabels write Flabels;
  published
    property JD : double read savejd write savejd;
    property BorderStyle: TFormBorderStyle read FBorderStyle write FBorderStyle;
    property Caption: string read Fcaption write Fcaption;
  end;

{ TJDDatePicker }

  TJDDatePicker = class(TEditButton)
  private
    savejd:double;
    Flabels: TDatesLabelsArray;
    Fcaption:string;
    procedure UpdDate;
  protected
    procedure DoButtonClick (Sender: TObject); override;
    procedure SetJD(value:double);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property labels: TDatesLabelsArray read Flabels write Flabels;
  published
    property ReadOnly default true;
    property Caption: string read Fcaption write Fcaption;
    property JD : double read savejd write SetJD;
  end;
  
{ TTimePicker }
type
  TTimePicker = class(TCustomPanel)
  // minimal DateTimePicker
  private
    { Private declarations }
    EditH, EditM, EditS : TEdit;
    LabelH, LabelM : TLabel;
    lockchange:boolean;
    FOnChange: TNotifyEvent;
    procedure Paint; override;
    procedure EditChange(Sender: TObject);
    procedure SetTime(Value: TDateTime);
    function ReadTime: TDateTime;
    procedure SetEnabled(value:boolean);
    function GetEnabled: boolean;
  public
    { Public declarations }
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
  published
    { Published declarations }
     property Time : TDateTime read ReadTime write SetTime;
     property OnChange: TNotifyEvent read FOnChange write FOnChange;
     property Enabled: boolean Read GetEnabled Write SetEnabled;
     property Font;
     property Hint;
     property ParentColor;
     property ParentFont;
     property ParentShowHint;
     property PopupMenu;
     property ShowHint;
     property TabOrder;
     property TabStop;
     property Visible;
  end;


procedure Register;
function Jdd(annee,mois,jour :INTEGER; Heure:double):double;
procedure Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);

implementation

procedure Register;
begin
  RegisterComponents('CDC',[TJDCalendarDialog,TJDDatePicker,TTimePicker]);
end;

{ TJDMonthlyCalendar }

constructor TJDMonthlyCalendar.Create(Aowner:Tcomponent);
begin
inherited create(Aowner);
Caption:='';
//BevelOuter:=bvNone;
BevelOuter:=bvLowered;
BevelInner:=bvRaised;
TopPanel:=Tpanel.Create(self);
TopPanel.Parent:=self;
TopPanel.Top:=0;
TopPanel.Left:=0;
TopPanel.Height:=25;
TopPanel.Align:=alTop;
TopPanel.BevelOuter:=bvNone;
BottomPanel:=Tpanel.Create(self);
BottomPanel.Parent:=self;
BottomPanel.Top:=0;
BottomPanel.Left:=0;
BottomPanel.Height:=25;
BottomPanel.Align:=alBottom;
BottomPanel.BevelOuter:=bvNone;
CalendarGrid:=TJDMonthlyCalendarGrid.Create(Self);
CalendarGrid.Parent:=self;
CalendarGrid.BorderStyle:=bsNone;
CalendarGrid.Top:=TopPanel.Height;
CalendarGrid.Left:=0;
Width:=CalendarGrid.Width;
Height:=TopPanel.Height+CalendarGrid.Height+BottomPanel.Height;

FYear:= TLongEdit.Create(self);
FYear.Parent:=TopPanel;
FYear.MaxValue:=20000;
FYear.MinValue:=-20000;
FYear.Top:=2;
FYear.Width:=40;
FYear.Height:=21;
//FYear.Height:=abs(FYear.Font.Height)+3;
FYear.BorderStyle:=bsNone;
DownYear:=TButton.Create(self);
DownYear.Parent:=TopPanel;
DownYear.Height:=21;
DownYear.Width:=DownYear.Height;
DownYear.Caption:='<';
DownYear.Left:=2;
DownYear.Top:=FYear.Top;
FYear.Left:=DownYear.Left+DownYear.Width+2;
UpYear:=TButton.Create(self);
UpYear.Parent:=TopPanel;
UpYear.Height:=DownYear.Height;
UpYear.Width:=UpYear.Height;
UpYear.Caption:='>';
UpYear.Left:=FYear.Left+FYear.Width+2;
UpYear.Top:=DownYear.Top;
FMonth:= TLongEdit.Create(self);
FMonth.Parent:=TopPanel;
FMonth.MaxValue:=12;
FMonth.MinValue:=1;
FMonth.Top:=FYear.Top;
FMonth.Width:=20;
//FMonth.Height:=abs(FMonth.Font.Height)+3;
FMonth.BorderStyle:=bsNone;
UpMonth:=TButton.Create(self);
UpMonth.Parent:=TopPanel;
UpMonth.Height:=DownYear.Height;
UpMonth.Width:=UpMonth.Height;
UpMonth.Caption:='>';
UpMonth.Left:=Width-UpMonth.Width-2;
UpMonth.Top:=DownYear.Top;
FMonth.Left:=UpMonth.Left-FMonth.Width-2;
DownMonth:=TButton.Create(self);
DownMonth.Parent:=TopPanel;
DownMonth.Height:=DownYear.Height;
DownMonth.Width:=DownMonth.Height;
DownMonth.Caption:='<';
DownMonth.Left:=FMonth.Left-DownMonth.Width-2;
DownMonth.Top:=DownYear.Top;

Today:=TButton.Create(self);
Today.Parent:=TopPanel;
Today.Height:=DownYear.Height;
Today.Width:=DownMonth.Left-UpYear.Left-UpYear.Width-8;
Today.Left:=UpYear.Left+UpYear.Width+4;
Today.Top:=DownYear.Top;
Today.Caption:='Today';

JDLabel:=TLabel.Create(self);
JDLabel.Parent:=BottomPanel;
JDLabel.Caption:='Julian Day =';
JDLabel.Left:=0;
JDLabel.Top:=6;

Julian:= TFloatEdit.Create(self);
Julian.Parent:=BottomPanel;
Julian.Decimals:=1;
Julian.Digits:=5;
Julian.NumericType:=ntFixed;
Julian.Top:=4;
Julian.Width:=80;
Julian.Height:=21;
Julian.Left:=JDLabel.Left+JDLabel.Width+12;
Julian.BorderStyle:=bsNone;

jdt:=CalendarGrid.JD;
UpdVal;
if not ( csDesignInstance in ComponentState ) then begin
CalendarGrid.OnMouseUp:=@CalendarGridMouseUp;
CalendarGrid.OnDblClick:=@CalendarGridDblClick;
FYear.OnChange:=@DateChange;
FMonth.OnChange:=@DateChange;
Julian.OnChange:=@JDChange;
UpYear.OnClick:=@UpYearClick;
DownYear.OnClick:=@DownYearClick;
UpMonth.OnClick:=@UpMonthClick;
DownMonth.OnClick:=@DownMonthClick;
Today.OnClick:=@TodayClick;
end;
lockdate:=false;
end;

destructor TJDMonthlyCalendar.Destroy;
begin
CalendarGrid.Free;
FYear.Free;
FMonth.Free;
Julian.Free;
UpYear.Free;
DownYear.Free;
UpMonth.Free;
DownMonth.Free;
JDLabel.Free;
TopPanel.Free;
BottomPanel.Free;
inherited destroy;
end;

procedure TJDMonthlyCalendar.SetJD(Value: double);
begin
 CalendarGrid.JD:=value;
 jdt:=CalendarGrid.JD;
 UpdVal;
end;

procedure TJDMonthlyCalendar.SetYear(Value: integer);
begin
FYear.value:=value;
end;

function TJDMonthlyCalendar.ReadYear: integer;
begin
result:=FYear.Value;
end;

procedure TJDMonthlyCalendar.SetMonth(Value: integer);
begin
FMonth.value:=value;
end;

function TJDMonthlyCalendar.ReadMonth: integer;
begin
result:=FMonth.Value;
end;

procedure TJDMonthlyCalendar.SetDay(Value: integer);
begin
 Fday:=value;
 CalendarGrid.JD:=jdd(FYear.value,FMonth.Value,Fday,0);
 UpdVal;
end;

procedure TJDMonthlyCalendar.SetLabels(Value: TDatesLabelsArray);
begin
Flabels:=value;
Today.Caption:=Flabels.today;
JDLabel.Caption:=Flabels.jd;
JDLabel.Left:=Julian.Left-JDLabel.Width-2;
CalendarGrid.labels:=Flabels;
end;

procedure TJDMonthlyCalendar.UpdVal;
begin
lockdate:=true;
try
  FYear.Value:=CalendarGrid.cy;
  FMonth.Value:=CalendarGrid.cm;
  Fday:=CalendarGrid.cd;
  Julian.Value:=CalendarGrid.JD;
  jdt:=CalendarGrid.JD;
finally
  lockdate:=false;
end;
end;

procedure TJDMonthlyCalendar.CalendarGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var col,row,d:integer;
begin
if Button=mbLeft then begin
 CalendarGrid.MouseToCell(X, Y, Col, Row);
 if (col>=0) and (row>0) and (CalendarGrid.Cells[col,row]<>'') then begin
    d:=strtoint(CalendarGrid.Cells[col,row]);
    CalendarGrid.JD:=jdd(CalendarGrid.cy,CalendarGrid.cm,d,0);
    UpdVal;
    if assigned(FonDateSelect) then FonDateSelect(self);
 end;
end;
end;

procedure TJDMonthlyCalendar.CalendarGridDblClick(Sender: TObject);
begin
 if assigned(FonDblClick) then FonDblClick(self);
end;

procedure TJDMonthlyCalendar.DateChange(Sender: TObject);
begin
 if (not lockdate)and(FMonth.value>0)and(FMonth.value<13) then begin
   CalendarGrid.JD:=jdd(FYear.value,FMonth.Value,Fday,0);
   UpdVal;
 end;
end;

procedure TJDMonthlyCalendar.JDChange(Sender: TObject);
begin
 if not lockdate then begin
   CalendarGrid.JD:=Julian.value;
   UpdVal;
 end;
end;

procedure TJDMonthlyCalendar.TodayClick(Sender: TObject);
var yy,mm,dd: word;
begin
 decodedate(now,yy,mm,dd);
 CalendarGrid.JD:=jdd(yy,mm,dd,0);
 UpdVal;
end;

procedure TJDMonthlyCalendar.UpYearClick(Sender: TObject);
begin
 FYear.Value:=FYear.Value+1;
end;

procedure TJDMonthlyCalendar.DownYearClick(Sender: TObject);
begin
 FYear.Value:=FYear.Value-1;
end;

procedure TJDMonthlyCalendar.UpMonthClick(Sender: TObject);
begin
 if FMonth.Value=12 then begin
   FMonth.Value:=1;
   FYear.Value:=FYear.Value+1;
 end
 else
   FMonth.Value:=FMonth.Value+1;
end;

procedure TJDMonthlyCalendar.DownMonthClick(Sender: TObject);
begin
 if FMonth.Value=1 then begin
   FMonth.Value:=12;
   FYear.Value:=FYear.Value-1;
 end
 else
   FMonth.Value:=FMonth.Value-1;
end;

  { TJDMonthlyCalendarGrid }

constructor TJDMonthlyCalendarGrid.Create(Aowner:Tcomponent);
var yy,mm,dd:word;
begin
inherited create(Aowner);
Width:=230;
Height:=130;
ColCount:=7;
RowCount:=7;
//Ctl3D:=false;
FixedColor:=Color;
ScrollBars:=ssNone;
FixedCols:=0;
FixedRows:=1;
DefaultColWidth:=(Width-((ColCount-1)*GridLineWidth)) div ColCount;
DefaultRowHeight:=(Height-((RowCount-1)*GridLineWidth)) div RowCount;
Options:=Options - [goRangeSelect];
Options:=Options - [goFixedVertLine];
Options:=Options - [goVertLine];
Options:=Options - [goHorzLine];
Options:=Options - [goColSizing];
//Options:=Options + [goDrawFocusSelected];
cells[0,0]:='Mon';
cells[1,0]:='Tue';
cells[2,0]:='Wed';
cells[3,0]:='Thu';
cells[4,0]:='Fri';
cells[5,0]:='Sat';
cells[6,0]:='Sun';
decodedate(now,yy,mm,dd);
SetJD(jdd(yy,mm,dd,0));
OnDrawCell:=@GridDrawCell;
end;

destructor TJDMonthlyCalendarGrid.Destroy;
begin
inherited destroy;
end;

procedure TJDMonthlyCalendarGrid.SetJD(Value: double);
var ro,co: integer;
begin
jdt:=value;
djd(jdt,cy,cm,cd,ch);
jdt:=jdd(cy,cm,cd,0);
for ro:=1 to Rowcount-1 do
  for co:=0 to colcount-1 do
     cells[co,ro]:='';
d:=1;
i:=1;
repeat
  j:=jdd(cy,cm,d,0);
  djd(j,y,m,d,h);
  if m<>cm then break;
  wd:=1+trunc(j+0.5) mod 7;
  if wd<=0 then wd:=7+wd;
  if (wd=1)and(d<>1) then inc(i);
  cells[wd-1,i]:=inttostr(d);
  if d=cd then begin
    sel.Left:=wd-1;
    sel.Top:=i;
    sel.Right:=wd-1;
    sel.Bottom:=i;
    selection:=sel;
  end;
  inc(d);
until d>31;
end;

procedure TJDMonthlyCalendarGrid.GridDrawCell(Sender: TObject; ACol, ARow: Integer; aRect: TRect; aState: TGridDrawState);
begin
 if (ACol=sel.left)and(Arow=sel.top) then begin
    try
    Canvas.Pen.Color := clBlue;
    Canvas.Brush.style := bsclear;
    arect.bottom:=arect.bottom-1;
    arect.right:=arect.right-1;
    Canvas.rectangle(aRect);
    finally
    Canvas.Brush.style := bssolid;
    end;
 end;
end;

procedure TJDMonthlyCalendarGrid.SetLabels(Value: TDatesLabelsArray);
begin
Flabels:=value;
cells[0,0]:=Flabels.Mon;
cells[1,0]:=Flabels.Tue;
cells[2,0]:=Flabels.Wed;
cells[3,0]:=Flabels.Thu;
cells[4,0]:=Flabels.Fri;
cells[5,0]:=Flabels.Sat;
cells[6,0]:=Flabels.Sun;
end;

function Jdd(annee,mois,jour :INTEGER; Heure:double):double;
var u,u0,u1,u2 : double;
	gregorian : boolean;
begin
if annee*10000+mois*100+jour >= 15821015 then gregorian:=true else gregorian:=false;
u:=annee;
if mois<3 then u:=u-1;
u0:=u+4712;
u1:=mois+1;
if u1<4 then u1:=u1+12;
result:=floor(u0*365.25)+floor(30.6*u1+0.000001)+jour+heure/24-63.5;
if gregorian then begin
   u2:=floor(abs(u)/100)-floor(abs(u)/400);
   if u<0 then u2:=-u2;
   result:=result-u2+2;
   if (u<0)and((u/100)=floor(u/100))and((u/400)<>floor(u/400)) then result:=result-1;
end;
end;

PROCEDURE Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);
var u0,u1,u2,u3,u4 : double;
	gregorian : boolean;
begin
u0:=jd+0.5;
if int(u0)>=2299161 then gregorian:=true else gregorian:=false;
u0:=jd+32082.5;
if gregorian then begin
   u1:=u0+floor(u0/36525)-floor(u0/146100)-38;
   if jd>=1830691.5 then u1:=u1+1;
   u0:=u0+floor(u1/36525)-floor(u1/146100)-38;
end;
u2:=floor(u0+123);
u3:=floor((u2-122.2)/365.25);
u4:=floor((u2-floor(365.25*u3))/30.6001);
mois:=round(u4-1);
if mois>12 then mois:=mois-12;
jour:=round(u2-floor(365.25*u3)-floor(30.6001*u4));
annee:=round(u3+floor((u4-2)/12)-4800);
heure:=(jd-floor(jd+0.5)+0.5)*24;
end;

{ TJDCalendarDialog }

constructor TJDCalendarDialog.Create(AOwner: TComponent);
var y,m,d: word;
begin
  inherited Create(AOwner);
  DecodeDate(now,y,m,d);
  savejd:=Jdd(y,m,d,0);
  FBorderStyle:=bsDialog;
  AnchorComponent:=TControl(AOwner);
  Fcaption:='JD calendar';
end;

destructor TJDCalendarDialog.Destroy;
begin
  inherited Destroy;
end;

procedure TJDCalendarDialog.CalendarDblClick(Sender: TObject);
begin
  DF.modalresult:=mrOK;
end;

function TJDCalendarDialog.Execute:boolean;
var okButton:TBitBtn;
    cancelButton:TBitBtn;
    pos:TPoint;
begin
  DF:=TForm.Create(Self);
  DF.Caption:=Fcaption;
  DF.BorderStyle:=FBorderStyle;
  DF.FormStyle:=fsStayOnTop;

  JDCalendar:=TJDMonthlyCalendar.Create(Self);
  with JDCalendar do begin
    Parent:=DF;
    Align:=alTop;
    onDblClick:=@CalendarDblClick;
  end;
  JDCalendar.JD:=savejd;
  if Flabels.mon<>'' then JDCalendar.labels:=labels;
  DF.ClientHeight:=JDCalendar.Height;
  DF.ClientWidth:=JDCalendar.Width;

  if AnchorComponent <> nil then begin
    pos.x:=0;
    pos.y:=AnchorComponent.Height;
    pos:=AnchorComponent.ClientToScreen(pos);
  end else begin
    pos:=mouse.CursorPos;
  end;
  DF.Left:=pos.x;
  DF.Top:=pos.y;

  okButton:=TBitBtn.Create(Self);
  with okButton do begin
    Parent:=JDCalendar.BottomPanel;
    Kind:=bkOK;
    Caption:='';
    layout:=blGlyphTop;
    Width:=30;
    Height:=25;
    ModalResult:=mrOK;
    Default:=True;
    top:=2;
    left:=JDCalendar.width-width-2;
  end;
  cancelButton:=TBitBtn.Create(Self);
  with cancelButton do begin
    Parent:=JDCalendar.BottomPanel;
    Kind:=bkCancel;
    Caption:='';
    layout:=blGlyphTop;
    ModalResult:=mrCancel;
    Width:=30;
    Height:=25;
    Cancel:=True;
    top:=2;
    left:=okButton.left-width-5;
  end;

  Result:=DF.ShowModal=mrOK;
  if Result then savejd:=JDCalendar.JD;
  
  FreeAndNil(JDCalendar);
  FreeAndNil(okButton);
  FreeAndNil(cancelButton);
  FreeAndNil(DF);
end;

{ TJDDatePicker }

constructor TJDDatePicker.Create(AOwner: TComponent);
var y,m,d: word;
begin
  inherited Create(AOwner);
  DecodeDate(now,y,m,d);
  savejd:=Jdd(y,m,d,0);
  Fcaption:='JD calendar';
  Color:=clBtnFace;
  ReadOnly:=true;
  Button.Glyph.LoadFromLazarusResource('BtnDatePicker');
  Button.OnClick:= @DoButtonClick;
  UpdDate;
end;

destructor TJDDatePicker.Destroy;
begin
  inherited Destroy;
end;

procedure TJDDatePicker.DoButtonClick(Sender:TObject);//or onClick
var CD:TJDCalendarDialog;
begin
  inherited DoButtonClick(Sender);

  CD:=TJDCalendarDialog.Create(Self);
  CD.JD:=savejd;
  if Flabels.mon<>'' then CD.labels:=Flabels;
  CD.Caption:=Fcaption;
//  CD.BorderStyle:=bsNone;
  try
    if CD.Execute then begin
      savejd:=CD.JD;
      UpdDate;
    end;
  except
  end;
  FreeAndNil(CD);
end;

procedure TJDDatePicker.UpdDate;
var y,m,d: integer;
    hh:double;
    txt:string;
begin
 djd(savejd,y,m,d,hh);
 Text:=inttostr(y);
 txt:=inttostr(m);
 if length(txt)=1 then txt:='0'+txt;
 Text:=Text+'.'+txt;
 txt:=inttostr(d);
 if length(txt)=1 then txt:='0'+txt;
 Text:=Text+'.'+txt;
end;

procedure TJDDatePicker.SetJD(value:double);
begin
savejd:=value;
UpdDate;
end;

{ TTimePicker }

constructor TTimePicker.Create(Aowner:Tcomponent);
var dsize,lsize: Integer;
begin
inherited create(Aowner);
lockchange:=true;
Caption:='';
BevelOuter:=bvNone;
dsize:=25;
lsize:=10;
EditH := TEdit.Create(self);
EditM := TEdit.Create(self);
EditS:= TEdit.Create(self);
LabelH := TLabel.Create(self);
LabelM := TLabel.Create(self);
EditH.Parent:=self;
EditM.Parent:=self;
EditS.Parent:=self;
LabelH.Parent:=self;
LabelM.Parent:=self;
EditH.ParentFont:=true;
EditM.ParentFont:=true;
EditS.ParentFont:=true;
LabelH.ParentFont:=true;
LabelM.ParentFont:=true;
EditH.Text:='0';
EditH.Top:=0;
EditH.Left:=0;
EditH.Width:=dsize;
LabelH.Caption:=':';
LabelH.Top:=(EditH.Height-LabelH.Height) div 2;
LabelH.Left:=EditH.Left+EditH.Width+2;
EditM.Text:='0';
EditM.Top:=0;
EditM.Left:=LabelH.Left+lsize;
EditM.Width:=dsize;
LabelM.Caption:=':';
LabelM.Top:=LabelH.Top;
LabelM.Left:=EditM.Left+EditM.Width+2;
EditS.Text:='0';
EditS.Top:=0;
EditS.Left:=LabelM.Left+lsize;
EditS.Width:=dsize;
Height:=EditH.Height;
Width:=EditS.Left+EditS.Width+2;
EditH.OnChange:=@EditChange;
EditM.OnChange:=@EditChange;
EditS.OnChange:=@EditChange;
lockchange:=false;
settime(now);
end;

destructor TTimePicker.Destroy;
begin
inherited destroy;
end;

function FixNum(txt: string; maxl:integer): string;
var i:integer;
    c:string;
begin
result:='';
for i:=1 to length(txt) do begin
  c:=copy(txt,i,1);
  if ((c>='0')and(c<='9'))
     then result:=result+c;
  if length(result)>=maxl then break;
end;
end;

procedure TTimePicker.SetTime(Value: TDateTime);
begin
EditH.Text:=formatdatetime('hh',Value);
EditM.Text:=formatdatetime('mm',Value);
EditS.Text:=formatdatetime('ss',Value);
end;

function TTimePicker.ReadTime: TDateTime;
var val,h,m,s: string;
begin
EditH.Text:=FixNum(EditH.Text,2);
EditM.Text:=FixNum(EditM.Text,2);
EditS.Text:=FixNum(EditS.Text,2);
val:=trim(EditH.Text)+':'+trim(EditM.Text)+':'+trim(EditS.Text);
result:=strtotime(val);
end;

procedure TTimePicker.Paint;
begin
caption:='';
inherited Paint;
end;

procedure TTimePicker.EditChange(Sender: TObject);
begin
if (not lockchange) and assigned(FOnChange) then FOnChange(self);
end;

procedure TTimePicker.SetEnabled(value:boolean);
begin
EditH.Enabled:=value;
EditM.Enabled:=value;
EditS.Enabled:=value;
LabelH.Enabled:=value;
LabelM.Enabled:=value;
end;

function TTimePicker.GetEnabled: boolean;
begin
result:=EditH.Enabled;
end;

initialization
  {$I jdcalendar.lrs}

end.

