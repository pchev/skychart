unit cu_jdcalendar;
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
{
 Monthly calendar using JD without date limitation.
}

interface

uses
    SysUtils, Classes, Math, enhedits,  Types,
{$ifdef linux}
    QGrids, QButtons, QMask, QControls, QStdCtrls, QExtCtrls, QForms ;
{$endif}
{$ifdef mswindows}
   Grids, Buttons, Mask, Controls, StdCtrls, ExtCtrls, Forms ;
{$endif}

type
  TLabelsArray= record
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
    Flabels: TLabelsArray;
    procedure SetJD(Value: double);
    procedure SetLabels(Value: TLabelsArray);
  public
    { Public declarations }
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
  published
    { Published declarations }
     property JD : double read jdt write SetJD;
     property labels: TLabelsArray read Flabels write SetLabels;
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
    UpYear, DownYear, UpMonth, DownMonth: TSpeedButton;
    Today, OKBtn: TSpeedButton;
    JDlabel: TLabel;
    jdt: double;
    Fday: integer;
    Flabels: TLabelsArray;
    lockdate: boolean;
    FonDateSelect: TNotifyEvent;
    FonOKClick: TNotifyEvent;
    FOKBtnVisible:boolean;
    procedure SetJD(Value: double);
    procedure SetYear(Value: integer);
    function ReadYear: integer;
    procedure SetMonth(Value: integer);
    function ReadMonth: integer;
    procedure SetDay(Value: integer);
    procedure SetLabels(Value: TLabelsArray);
    procedure UpdVal;
    procedure CalendarGridMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DateChange(Sender: TObject);
    procedure JDChange(Sender: TObject);
    procedure TodayClick(Sender: TObject);
    procedure UpYearClick(Sender: TObject);
    procedure DownYearClick(Sender: TObject);
    procedure UpMonthClick(Sender: TObject);
    procedure DownMonthClick(Sender: TObject);
    procedure SetOKBtnVisible(value:boolean);
    procedure OKbtnClick(Sender: TObject);
  public
    { Public declarations }
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
  published
    { Published declarations }
     property JD : double read jdt write SetJD;
     property Year : integer read ReadYear write SetYear;
     property Month : integer read ReadMonth write SetMonth;
     property Day : integer read Fday write SetDay;
     property labels: TLabelsArray read Flabels write SetLabels;
     property onDateSelect: TNotifyEvent read FonDateSelect write FonDateSelect;
     property onOKClick: TNotifyEvent read FonOKClick write FonOKClick;
     property OKBtnVisible: boolean read FOKBtnVisible write SetOKBtnVisible;
  end;

type
  TJDDatePicker = class(TMaskEdit)
  private
    { Private declarations }
    CalendarDialog: TForm;
    JDCalendar: TJDMonthlyCalendar;
    OpenCalendar: TSpeedButton;
    CancelButton: TButton;
    savejd:double;
    procedure UpdText;
    procedure SetJD(Value: double);
    function ReadJD: double;
    procedure SetYear(Value: integer);
    function ReadYear: integer;
    procedure SetMonth(Value: integer);
    function ReadMonth: integer;
    procedure SetDay(Value: integer);
    function ReadDay: integer;
    procedure SetLabels(Value: TLabelsArray);
    function ReadLabels: TLabelsArray;
    procedure PaintBtn(Sender: TObject);
    procedure OpenCalendarClick(Sender: TObject);
    procedure OKbtnClick(Sender: TObject);
    procedure CancelSelect(Sender: TObject);
  public
    { Public declarations }
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
  published
    { Published declarations }
     property JD : double read ReadJD write SetJD;
     property Year : integer read ReadYear write SetYear;
     property Month : integer read ReadMonth write SetMonth;
     property Day : integer read ReadDay write SetDay;
     property labels: TLabelsArray read Readlabels write SetLabels;
  end;

type
  TTimePicker = class(TMaskEdit)
  // minimal CLX compatible DateTimePicker
  private
    { Private declarations }
    procedure SetTime(Value: TDateTime);
    function ReadTime: TDateTime;
  public
    { Public declarations }
     constructor Create(Aowner:Tcomponent); override;
     destructor Destroy; override;
  published
    { Published declarations }
     property Time : TDateTime read ReadTime write SetTime;
  end;


procedure Register;
function Jdd(annee,mois,jour :INTEGER; Heure:double):double;
procedure Djd(jd:Double;VAR annee,mois,jour:INTEGER; VAR Heure:double);

implementation

{$R cu_jdcalendar.dcr}

procedure Register;
begin
  RegisterComponents('CDC', [TJDDatePicker,TJDMonthlyCalendar,TTimePicker]);
end;

//////////////////////////////////////////////////////////

constructor TTimePicker.Create(Aowner:Tcomponent);
begin
inherited create(Aowner);
EditMask:='!99:99:99;1; ';
Text:='';
Width:=75;
settime(now);
end;

destructor TTimePicker.Destroy;
begin
inherited destroy;
end;

procedure TTimePicker.SetTime(Value: TDateTime);
begin
Text:=formatdatetime('hh:nn:ss',Value);
end;

function TTimePicker.ReadTime: TDateTime;
begin
result:=strtotime(Text);
end;


//////////////////////////////////////////////////////////

constructor TJDDatePicker.Create(Aowner:Tcomponent);
begin
inherited create(Aowner);
EditMask:='!######.99.99;1; ';
Text:='';
Width:=95;
CalendarDialog:=TForm.Create(self);
{$ifdef mswindows}
CalendarDialog.BorderStyle:=bsNone;
{$endif}
{$ifdef linux}
CalendarDialog.BorderStyle:=fbsNone;
{$endif}
CalendarDialog.visible:=false;
CancelButton:=TButton.Create(self);
CancelButton.Parent:=CalendarDialog;
CancelButton.OnClick:=CancelSelect;
CancelButton.Cancel:=true;
CancelButton.Width:=1;
CancelButton.Height:=1;
JDCalendar:=TJDMonthlyCalendar.Create(Self);
JDCalendar.Parent:=CalendarDialog;
JDCalendar.BevelOuter:=bvRaised;
JDCalendar.BevelInner:=bvLowered;
CalendarDialog.ClientWidth:=JDCalendar.Width;
CalendarDialog.ClientHeight:=JDCalendar.Height;
OpenCalendar:=TSpeedButton.Create(self);
OpenCalendar.Parent:=self;
//OpenCalendar.Flat:=true;
OpenCalendar.Transparent:=false;
OpenCalendar.Height:=Height-1;
OpenCalendar.Width:=Height-1;
OpenCalendar.Layout:=blGlyphBottom;
OpenCalendar.Caption:='...';
OpenCalendar.Left:=Width-Height; // -2;
OpenCalendar.Top:=0;
OpenCalendar.OnClick:=OpenCalendarClick;
JDCalendar.CalendarGrid.OnDblClick:=OKbtnClick;
JDCalendar.onOKClick:=OKbtnClick;
JDCalendar.OKBtnVisible:=true;
onChange:=PaintBtn;
CancelButton.sendtoback;
end;

destructor TJDDatePicker.Destroy;
begin
JDCalendar.Free;
inherited destroy;
end;

procedure TJDDatePicker.SetJD(Value: double);
begin
JDCalendar.JD:=Value;
UpdText;
end;

function TJDDatePicker.ReadJD: double;
begin
result:=JDCalendar.JD;
end;

procedure TJDDatePicker.SetYear(Value: integer);
begin
JDCalendar.Year:=Value;
UpdText;
end;

function TJDDatePicker.ReadYear: integer;
begin
result:=JDCalendar.Year;
end;

procedure TJDDatePicker.SetMonth(Value: integer);
begin
JDCalendar.Month:=Value;
UpdText;
end;

function TJDDatePicker.ReadMonth: integer;
begin
result:=JDCalendar.Month;
end;

procedure TJDDatePicker.SetDay(Value: integer);
begin
JDCalendar.Day:=Value;
UpdText;
end;

function TJDDatePicker.ReadDay: integer;
begin
result:=JDCalendar.Day;
end;

procedure TJDDatePicker.SetLabels(Value: TLabelsArray);
begin
JDCalendar.labels:=value;
end;

function TJDDatePicker.ReadLabels: TLabelsArray;
begin
result:=JDCalendar.Labels;
end;

procedure TJDDatePicker.PaintBtn(Sender: TObject);
begin
OpenCalendar.Repaint;
end;

procedure TJDDatePicker.OpenCalendarClick(Sender: TObject);
var P: TPoint;
begin
savejd:=JDCalendar.JD;
P.x:=-2;
P.y:=Height;
P:=clienttoscreen(P);
CalendarDialog.Left:=P.x;
CalendarDialog.Top:=P.y;
CalendarDialog.Showmodal;
if CalendarDialog.ModalResult=mrOK then UpdText
   else JDCalendar.JD:=savejd;
end;

procedure TJDDatePicker.UpdText;
var yy,mm,dd: integer;
    hh: double;
begin
djd(JDCalendar.JD,yy,mm,dd,hh);
Text:=inttostr(yy)+'.'+inttostr(mm)+'.'+inttostr(dd);
end;

procedure TJDDatePicker.OKbtnClick(Sender: TObject);
begin
CalendarDialog.ModalResult:=mrOK;
end;

procedure TJDDatePicker.CancelSelect(Sender: TObject);
begin
CalendarDialog.ModalResult:=mrCancel;
end;

//////////////////////////////////////////////////////////

constructor TJDMonthlyCalendar.Create(Aowner:Tcomponent);
var yy,mm,dd:word;
begin
inherited create(Aowner);
Caption:='';
//BevelOuter:=bvSpace;
BevelOuter:=bvNone;
TopPanel:=Tpanel.Create(self);
TopPanel.Parent:=self;
TopPanel.Top:=0;
TopPanel.Left:=0;
TopPanel.Height:=21;
TopPanel.Align:=alTop;
TopPanel.BevelOuter:=bvNone;
BottomPanel:=Tpanel.Create(self);
BottomPanel.Parent:=self;
BottomPanel.Top:=0;
BottomPanel.Left:=0;
BottomPanel.Height:=21;
BottomPanel.Align:=alBottom;
BottomPanel.BevelOuter:=bvNone;
CalendarGrid:=TJDMonthlyCalendarGrid.Create(Self);
CalendarGrid.Parent:=self;
CalendarGrid.BorderStyle:=bsNone;
CalendarGrid.Top:=TopPanel.Height;
CalendarGrid.Left:=2;
Width:=CalendarGrid.Width+4;
Height:=TopPanel.Height+CalendarGrid.Height+BottomPanel.Height+2;

FYear:= TLongEdit.Create(self);
FYear.Parent:=TopPanel;
FYear.MaxValue:=20000;
FYear.MinValue:=-20000;
FYear.Top:=2;
FYear.Width:=40;
FYear.Height:=abs(FYear.Font.Height)+3;
FYear.BorderStyle:=bsNone;
DownYear:=TSpeedButton.Create(self);
DownYear.Parent:=TopPanel;
DownYear.Height:=FYear.Height;
DownYear.Width:=DownYear.Height;
DownYear.Layout:=blGlyphBottom;
DownYear.Caption:='<';
DownYear.Left:=2;
DownYear.Top:=FYear.Top-(DownYear.Height-FYear.Height)div 2;
FYear.Left:=DownYear.Left+DownYear.Width+2;
UpYear:=TSpeedButton.Create(self);
UpYear.Parent:=TopPanel;
UpYear.Height:=FYear.Height;
UpYear.Width:=UpYear.Height;
UpYear.Layout:=blGlyphBottom;
UpYear.Caption:='>';
UpYear.Left:=FYear.Left+FYear.Width+2;
UpYear.Top:=DownYear.Top;
FMonth:= TLongEdit.Create(self);
FMonth.Parent:=TopPanel;
FMonth.MaxValue:=12;
FMonth.MinValue:=1;
FMonth.Top:=FYear.Top;
FMonth.Width:=20;
FMonth.Height:=abs(FMonth.Font.Height)+3;
FMonth.BorderStyle:=bsNone;
UpMonth:=TSpeedButton.Create(self);
UpMonth.Parent:=TopPanel;
UpMonth.Height:=FMonth.Height;
UpMonth.Width:=UpMonth.Height;
UpMonth.Layout:=blGlyphBottom;
UpMonth.Caption:='>';
UpMonth.Left:=Width-UpMonth.Width-2;
UpMonth.Top:=UpYear.Top;
FMonth.Left:=UpMonth.Left-FMonth.Width-2;
DownMonth:=TSpeedButton.Create(self);
DownMonth.Parent:=TopPanel;
DownMonth.Height:=FMonth.Height;
DownMonth.Width:=DownMonth.Height;
DownMonth.Layout:=blGlyphBottom;
DownMonth.Caption:='<';
DownMonth.Left:=FMonth.Left-DownMonth.Width-2;
DownMonth.Top:=UpMonth.Top;

Today:=TSpeedButton.Create(self);
Today.Parent:=TopPanel;
Today.Height:=UpYear.Height;
Today.Width:=DownMonth.Left-UpYear.Left-UpYear.Width-8;
Today.Left:=UpYear.Left+UpYear.Width+4;
Today.Top:=UpYear.Top;
Today.Layout:=blGlyphBottom;
Today.Caption:='Today';

Julian:= TFloatEdit.Create(self);
Julian.Parent:=BottomPanel;
Julian.Top:=4;
Julian.Width:=80;
Julian.Left:=Width-Julian.Width-4;
Julian.Height:=abs(Julian.Font.Height)+3;
Julian.BorderStyle:=bsNone;
JDLabel:=TLabel.Create(self);
JDLabel.Parent:=BottomPanel;
JDLabel.Caption:='Julian Day = ';
JDLabel.Left:=Julian.Left-JDLabel.Width-2;
JDLabel.Top:=Julian.Top;
OKbtn:=TSpeedButton.Create(self);
OKbtn.Parent:=BottomPanel;
OKbtn.Height:=Julian.Height;
OKbtn.Width:=Julian.Height;
OKbtn.Left:=2;
OKbtn.Top:=4;
OKbtn.Layout:=blGlyphBottom;
OKbtn.Caption:='';
OKbtn.OnClick:=OKbtnClick;
OKBtn.Glyph.LoadFromResourceName(HInstance,'OKBTN');
OKbtn.Visible:=false;
FOKBtnVisible:=false;
jdt:=CalendarGrid.JD;
UpdVal;
CalendarGrid.OnMouseUp:=CalendarGridMouseUp;
FYear.OnChange:=DateChange;
FMonth.OnChange:=DateChange;
Julian.OnChange:=JDChange;
UpYear.OnClick:=UpYearClick;
DownYear.OnClick:=DownYearClick;
UpMonth.OnClick:=UpMonthClick;
DownMonth.OnClick:=DownMonthClick;
Today.OnClick:=TodayClick;

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
 jdt:=value;
 CalendarGrid.JD:=jdt;
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

procedure TJDMonthlyCalendar.SetLabels(Value: TLabelsArray);
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

procedure TJDMonthlyCalendar.OKbtnClick(Sender: TObject);
begin
  if assigned(FonOKClick) then FonOKClick(self);
end;

procedure TJDMonthlyCalendar.SetOKBtnVisible(value:boolean);
begin
OKBtn.Visible:=value;
FOKBtnVisible:=value;
end;

/////////////////////////////////////////////////////

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
cells[0,0]:='Mon';
cells[1,0]:='Tue';
cells[2,0]:='Wed';
cells[3,0]:='Thu';
cells[4,0]:='Fri';
cells[5,0]:='Sat';
cells[6,0]:='Sun';
decodedate(now,yy,mm,dd);
SetJD(jdd(yy,mm,dd,0));
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

procedure TJDMonthlyCalendarGrid.SetLabels(Value: TLabelsArray);
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

end.
