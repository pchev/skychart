unit jdcalendar;

{
Copyright (C) 2006 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Dialogs, LCLType, Grids, StdCtrls, LCLVersion,
  Controls, ExtCtrls, Types, GraphType, Graphics, Forms, Buttons, MaskEdit,
  Math, LResources, EditBtn, enhedits;

type
  TDatesLabelsArray = record
    mon, tue, wed, thu, fri, sat, sun, today, jd: string
  end;

type
  TJDMonthlyCalendarGrid = class(TStringGrid)
  private
    { Private declarations }
    jdt: double;
    i, wd, y, m, d, cy, cm, cd: integer;
    h, ch, j: double;
    sel: TGridRect;
    Flabels: TDatesLabelsArray;
    procedure SetJD(Value: double);
    procedure SetLabels(Value: TDatesLabelsArray);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: integer;
      aRect: TRect; aState: TGridDrawState);
  public
    { Public declarations }
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    property labels: TDatesLabelsArray read Flabels write SetLabels;
  published
    { Published declarations }
    property JD: double read jdt write SetJD;
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
    procedure CalendarGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
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
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    property labels: TDatesLabelsArray read Flabels write SetLabels;
  published
    { Published declarations }
    property JD: double read jdt write SetJD;
    property Year: integer read ReadYear write SetYear;
    property Month: integer read ReadMonth write SetMonth;
    property Day: integer read Fday write SetDay;
    property onDateSelect: TNotifyEvent read FonDateSelect write FonDateSelect;
    property onDblClick: TNotifyEvent read FonDblClick write FonDblClick;
  end;

  { TJDCalendarDialog }

  TJDCalendarDialog = class(TCommonDialog)
  private
    savejd: double;
    DF: TForm;
    Flabels: TDatesLabelsArray;
    Fcaption: string;
    AnchorComponent: TControl;
    FFont: TFont;
    FBorderStyle: TFormBorderStyle;
    JDCalendar: TJDMonthlyCalendar;
    procedure CalendarDblClick(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: boolean; override;
    property labels: TDatesLabelsArray read Flabels write Flabels;
  published
    property JD: double read savejd write savejd;
    property BorderStyle: TFormBorderStyle read FBorderStyle write FBorderStyle;
    property Caption: string read Fcaption write Fcaption;
    property font: TFont read FFont write FFont;
  end;

  { TJDDatePicker }

//  TJDDatePicker = class(TEditButton)
  TJDDatePicker = class(TCustomEditButton)
  private
    savejd: double;
    Flabels: TDatesLabelsArray;
    Fcaption: string;
    procedure UpdDate;
  protected
//    procedure DoButtonClick(Sender: TObject); override;  // commented for new lcl  version
    procedure ButtonClick(Sender: TObject);  // weird compilation failed if adding override here?
    procedure SetJD(Value: double);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property labels: TDatesLabelsArray read Flabels write Flabels;
  published
    property ReadOnly default True;
    property Caption: string read Fcaption write Fcaption;
    property JD: double read savejd write SetJD;
    property OnChange;
  end;

{ TTimePicker }
type
  TTimePicker = class(TCustomPanel)
    // minimal DateTimePicker
  private
    { Private declarations }
    EditH, EditM, EditS: TLongEdit;
    LabelH, LabelM: TLabel;
    lockchange: boolean;
    FOnChange: TNotifyEvent;
    procedure EditChange(Sender: TObject);
    procedure SetTime(Value: TDateTime);
    function ReadTime: TDateTime;
    procedure SetEnable(Value: boolean);
    function GetEnable: boolean;
  protected
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Time: TDateTime read ReadTime write SetTime;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Enabled: boolean read GetEnable write SetEnable;
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
function Jdd(annee, mois, jour: integer; Heure: double): double;
procedure Djd(jd: double; var annee, mois, jour: integer; var Heure: double);

implementation

procedure Register;
begin
  RegisterComponents('CDC', [TJDCalendarDialog, TJDDatePicker, TTimePicker,
    TJDMonthlyCalendar]);
end;

{ TJDMonthlyCalendar }

constructor TJDMonthlyCalendar.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
{$ifdef lclwince}
  Width := screen.Width;
  Height := screen.Height;
{$endif}
  Caption := '';
  //BevelOuter:=bvNone;
  BevelOuter := bvLowered;
  BevelInner := bvRaised;
  TopPanel := Tpanel.Create(self);
  TopPanel.Parent := self;
  TopPanel.ParentFont := True;
  TopPanel.Top := 0;
  TopPanel.Left := 0;
  TopPanel.Height := 25;
  TopPanel.Width := Width;
  TopPanel.Align := alTop;
  TopPanel.BevelOuter := bvNone;
  CalendarGrid := TJDMonthlyCalendarGrid.Create(Self);
  CalendarGrid.Parent := self;
  CalendarGrid.ParentFont := True;
  CalendarGrid.BorderStyle := bsNone;
  CalendarGrid.Top := TopPanel.Height;
  CalendarGrid.Left := 0;
  BottomPanel := Tpanel.Create(self);
  BottomPanel.Parent := self;
  BottomPanel.ParentFont := True;
  BottomPanel.Top := CalendarGrid.Top + CalendarGrid.Height;
  BottomPanel.Left := 0;
  BottomPanel.Height := 25;
  BottomPanel.Width := Width;
  BottomPanel.Align := alBottom;
  BottomPanel.BevelOuter := bvNone;
  Width := CalendarGrid.Width;
  Height := TopPanel.Height + CalendarGrid.Height + BottomPanel.Height;

  FYear := TLongEdit.Create(self);
  FYear.Parent := TopPanel;
  FYear.ParentFont := True;
  FYear.MaxValue := 20000;
  FYear.MinValue := -20000;
  FYear.Top := 3;
  FYear.Width := 40;
  FYear.Height := 21;
  //FYear.Height:=abs(FYear.Font.Height)+3;
  FYear.BorderStyle := bsNone;
  DownYear := TButton.Create(self);
  DownYear.Parent := TopPanel;
  DownYear.Height := 21;
  DownYear.Width := DownYear.Height;
  DownYear.Caption := '<';
  DownYear.Left := 2;
  DownYear.Top := FYear.Top-2;
  FYear.Left := DownYear.Left + DownYear.Width + 2;
  UpYear := TButton.Create(self);
  UpYear.Parent := TopPanel;
  UpYear.Height := DownYear.Height;
  UpYear.Width := UpYear.Height;
  UpYear.Caption := '>';
  UpYear.Left := FYear.Left + FYear.Width + 2;
  UpYear.Top := DownYear.Top;
  FMonth := TLongEdit.Create(self);
  FMonth.Parent := TopPanel;
  FMonth.ParentFont := True;
  FMonth.MaxValue := 12;
  FMonth.MinValue := 1;
  FMonth.Top := FYear.Top;
  FMonth.Width := 20;
  //FMonth.Height:=abs(FMonth.Font.Height)+3;
  FMonth.BorderStyle := bsNone;
  UpMonth := TButton.Create(self);
  UpMonth.Parent := TopPanel;
  UpMonth.Height := DownYear.Height;
  UpMonth.Width := UpMonth.Height;
  UpMonth.Caption := '>';
  UpMonth.Left := Width - UpMonth.Width - 2;
  UpMonth.Top := DownYear.Top;
  FMonth.Left := UpMonth.Left - FMonth.Width - 2;
  DownMonth := TButton.Create(self);
  DownMonth.Parent := TopPanel;
  DownMonth.Height := DownYear.Height;
  DownMonth.Width := DownMonth.Height;
  DownMonth.Caption := '<';
  DownMonth.Left := FMonth.Left - DownMonth.Width - 2;
  DownMonth.Top := DownYear.Top;

  Today := TButton.Create(self);
  Today.Parent := TopPanel;
  Today.ParentFont := True;
  Today.Height := DownYear.Height;
  Today.Width := DownMonth.Left - UpYear.Left - UpYear.Width - 8;
  Today.Left := UpYear.Left + UpYear.Width + 4;
  Today.Top := DownYear.Top;
  Today.Caption := 'Today';

  JDLabel := TLabel.Create(self);
  JDLabel.Parent := BottomPanel;
  JDLabel.ParentFont := True;
  JDLabel.Caption := 'Julian Day =';
  JDLabel.Left := 0;
  JDLabel.Top := 6;

  Julian := TFloatEdit.Create(self);
  Julian.Parent := BottomPanel;
  Julian.ParentFont := True;
  Julian.Decimals := 1;
  Julian.Digits := 5;
  Julian.NumericType := ntFixed;
  Julian.Top := 5;
  Julian.Width := 80;
  Julian.Height := 21;
  Julian.Left := JDLabel.Left + JDLabel.Width + 12;
  Julian.BorderStyle := bsNone;
  Julian.MinValue:=-5583575;
  Julian.MaxValue:=9026275;

  jdt := CalendarGrid.JD;
  UpdVal;
  if not (csDesignInstance in ComponentState) then
  begin
    CalendarGrid.OnMouseUp := @CalendarGridMouseUp;
    CalendarGrid.OnDblClick := @CalendarGridDblClick;
    FYear.OnChange := @DateChange;
    FMonth.OnChange := @DateChange;
    Julian.OnChange := @JDChange;
    UpYear.OnClick := @UpYearClick;
    DownYear.OnClick := @DownYearClick;
    UpMonth.OnClick := @UpMonthClick;
    DownMonth.OnClick := @DownMonthClick;
    Today.OnClick := @TodayClick;
  end;
  lockdate := False;
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
  inherited Destroy;
end;

procedure TJDMonthlyCalendar.SetJD(Value: double);
begin
  CalendarGrid.JD := Value;
  jdt := CalendarGrid.JD;
  UpdVal;
end;

procedure TJDMonthlyCalendar.SetYear(Value: integer);
begin
  FYear.Value := Value;
end;

function TJDMonthlyCalendar.ReadYear: integer;
begin
  Result := FYear.Value;
end;

procedure TJDMonthlyCalendar.SetMonth(Value: integer);
begin
  FMonth.Value := Value;
end;

function TJDMonthlyCalendar.ReadMonth: integer;
begin
  Result := FMonth.Value;
end;

procedure TJDMonthlyCalendar.SetDay(Value: integer);
begin
  Fday := Value;
  CalendarGrid.JD := jdd(FYear.Value, FMonth.Value, Fday, 0);
  UpdVal;
end;

procedure TJDMonthlyCalendar.SetLabels(Value: TDatesLabelsArray);
begin
  Flabels := Value;
  Today.Caption := Flabels.today;
  JDLabel.Caption := Flabels.jd;
  JDLabel.Left := Julian.Left - JDLabel.Width - 2;
  CalendarGrid.labels := Flabels;
end;

procedure TJDMonthlyCalendar.UpdVal;
begin
  lockdate := True;
  try
    FYear.Value := CalendarGrid.cy;
    FMonth.Value := CalendarGrid.cm;
    Fday := CalendarGrid.cd;
    Julian.Value := CalendarGrid.JD;
    jdt := CalendarGrid.JD;
  finally
    lockdate := False;
  end;
end;

procedure TJDMonthlyCalendar.CalendarGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  col, row, d: integer;
begin
  if Button = mbLeft then
  begin
    CalendarGrid.MouseToCell(X, Y, Col, Row);
    if (col >= 0) and (row > 0) and (CalendarGrid.Cells[col, row] <> '') then
    begin
      d := StrToInt(CalendarGrid.Cells[col, row]);
      CalendarGrid.JD := jdd(CalendarGrid.cy, CalendarGrid.cm, d, 0);
      UpdVal;
      if assigned(FonDateSelect) then
        FonDateSelect(self);
    end;
  end;
end;

procedure TJDMonthlyCalendar.CalendarGridDblClick(Sender: TObject);
begin
  if assigned(FonDblClick) then
    FonDblClick(self);
end;

procedure TJDMonthlyCalendar.DateChange(Sender: TObject);
begin
  if (not lockdate) and (FMonth.Value > 0) and (FMonth.Value < 13) then
  begin
    CalendarGrid.JD := jdd(FYear.Value, FMonth.Value, Fday, 0);
    UpdVal;
  end;
end;

procedure TJDMonthlyCalendar.JDChange(Sender: TObject);
begin
  if not lockdate then
  begin
    CalendarGrid.JD := Julian.Value;
    UpdVal;
  end;
end;

procedure TJDMonthlyCalendar.TodayClick(Sender: TObject);
var
  yy, mm, dd: word;
begin
  decodedate(now, yy, mm, dd);
  CalendarGrid.JD := jdd(yy, mm, dd, 0);
  UpdVal;
end;

procedure TJDMonthlyCalendar.UpYearClick(Sender: TObject);
begin
  FYear.Value := FYear.Value + 1;
{$ifdef darwin}
  DateChange(Sender);
{$endif}
end;

procedure TJDMonthlyCalendar.DownYearClick(Sender: TObject);
begin
  FYear.Value := FYear.Value - 1;
  {$ifdef darwin}
    DateChange(Sender);
  {$endif}
end;

procedure TJDMonthlyCalendar.UpMonthClick(Sender: TObject);
begin
  if FMonth.Value = 12 then
  begin
    FMonth.Value := 1;
    FYear.Value := FYear.Value + 1;
  end
  else
    FMonth.Value := FMonth.Value + 1;
  {$ifdef darwin}
    DateChange(Sender);
  {$endif}
end;

procedure TJDMonthlyCalendar.DownMonthClick(Sender: TObject);
begin
  if FMonth.Value = 1 then
  begin
    FMonth.Value := 12;
    FYear.Value := FYear.Value - 1;
  end
  else
    FMonth.Value := FMonth.Value - 1;
  {$ifdef darwin}
    DateChange(Sender);
  {$endif}
end;

{ TJDMonthlyCalendarGrid }

constructor TJDMonthlyCalendarGrid.Create(Aowner: TComponent);
var
  yy, mm, dd: word;
begin
  inherited Create(Aowner);
{$ifdef lclwince}
  Width := 240;
  Height := 110;
{$else}
  Width := 290;
  Height := 160;
{$endif}
  ColCount := 7;
  RowCount := 7;
  //Ctl3D:=false;
  FixedColor := Color;
  ScrollBars := ssNone;
  FixedCols := 0;
  FixedRows := 1;
  DefaultColWidth := (Width - ((ColCount - 1) * GridLineWidth)) div ColCount;
  DefaultRowHeight := (Height - ((RowCount - 1) * GridLineWidth)) div RowCount;
  Options := Options - [goRangeSelect];
  Options := Options - [goFixedVertLine];
  Options := Options - [goVertLine];
  Options := Options - [goHorzLine];
  Options := Options - [goColSizing];
  //Options:=Options + [goDrawFocusSelected];
  cells[0, 0] := 'Mon';
  cells[1, 0] := 'Tue';
  cells[2, 0] := 'Wed';
  cells[3, 0] := 'Thu';
  cells[4, 0] := 'Fri';
  cells[5, 0] := 'Sat';
  cells[6, 0] := 'Sun';
  decodedate(now, yy, mm, dd);
  SetJD(jdd(yy, mm, dd, 0));
  OnDrawCell := @GridDrawCell;
end;

destructor TJDMonthlyCalendarGrid.Destroy;
begin
  inherited Destroy;
end;

procedure TJDMonthlyCalendarGrid.SetJD(Value: double);
var
  ro, co: integer;
begin
  jdt := Value;
  djd(jdt, cy, cm, cd, ch);
  jdt := jdd(cy, cm, cd, 0);
  for ro := 1 to Rowcount - 1 do
    for co := 0 to colcount - 1 do
      cells[co, ro] := '';
  d := 1;
  i := 1;
  repeat
    j := jdd(cy, cm, d, 0);
    djd(j, y, m, d, h);
    if m <> cm then
      break;
    wd := 1 + trunc(j + 0.5) mod 7;
    if wd <= 0 then
      wd := 7 + wd;
    if (wd = 1) and (d <> 1) then
      Inc(i);
    cells[wd - 1, i] := IntToStr(d);
    if d = cd then
    begin
      sel.Left := wd - 1;
      sel.Top := i;
      sel.Right := wd - 1;
      sel.Bottom := i;
      selection := sel;
    end;
    Inc(d);
  until d > 31;
end;

procedure TJDMonthlyCalendarGrid.GridDrawCell(Sender: TObject;
  ACol, ARow: integer; aRect: TRect; aState: TGridDrawState);
begin
  if (ACol = sel.left) and (Arow = sel.top) then
  begin
    try
      Canvas.Pen.Color := clBlue;
      Canvas.Brush.style := bsclear;
      arect.bottom := arect.bottom - 1;
      arect.right := arect.right - 1;
      Canvas.rectangle(aRect);
    finally
      Canvas.Brush.style := bssolid;
    end;
  end;
end;

procedure TJDMonthlyCalendarGrid.SetLabels(Value: TDatesLabelsArray);
begin
  Flabels := Value;
  cells[0, 0] := Flabels.Mon;
  cells[1, 0] := Flabels.Tue;
  cells[2, 0] := Flabels.Wed;
  cells[3, 0] := Flabels.Thu;
  cells[4, 0] := Flabels.Fri;
  cells[5, 0] := Flabels.Sat;
  cells[6, 0] := Flabels.Sun;
end;

function Jdd(annee, mois, jour: integer; Heure: double): double;
var
  u, u0, u1, u2: double;
  gregorian: boolean;
begin
  if annee * 10000 + mois * 100 + jour >= 15821015 then
    gregorian := True
  else
    gregorian := False;
  u := annee;
  if mois < 3 then
    u := u - 1;
  u0 := u + 4712;
  u1 := mois + 1;
  if u1 < 4 then
    u1 := u1 + 12;
  Result := floor(u0 * 365.25) + floor(30.6 * u1 + 0.000001) + jour + heure / 24 - 63.5;
  if gregorian then
  begin
    u2 := floor(abs(u) / 100) - floor(abs(u) / 400);
    if u < 0 then
      u2 := -u2;
    Result := Result - u2 + 2;
    if (u < 0) and ((u / 100) = floor(u / 100)) and ((u / 400) <> floor(u / 400)) then
      Result := Result - 1;
  end;
end;

procedure Djd(jd: double; var annee, mois, jour: integer; var Heure: double);
var
  u0, u1, u2, u3, u4: double;
  gregorian: boolean;
begin
  u0 := jd + 0.5;
  if int(u0) >= 2299161 then
    gregorian := True
  else
    gregorian := False;
  u0 := jd + 32082.5;
  if gregorian then
  begin
    u1 := u0 + floor(u0 / 36525) - floor(u0 / 146100) - 38;
    if jd >= 1830691.5 then
      u1 := u1 + 1;
    u0 := u0 + floor(u1 / 36525) - floor(u1 / 146100) - 38;
  end;
  u2 := floor(u0 + 123);
  u3 := floor((u2 - 122.2) / 365.25);
  u4 := floor((u2 - floor(365.25 * u3)) / 30.6001);
  mois := round(u4 - 1);
  if mois > 12 then
    mois := mois - 12;
  jour := round(u2 - floor(365.25 * u3) - floor(30.6001 * u4));
  annee := round(u3 + floor((u4 - 2) / 12) - 4800);
  heure := (jd - floor(jd + 0.5) + 0.5) * 24;
end;

{ TJDCalendarDialog }

constructor TJDCalendarDialog.Create(AOwner: TComponent);
var
  y, m, d: word;
begin
  inherited Create(AOwner);
  FFont := TFont.Create;
  DecodeDate(now, y, m, d);
  savejd := Jdd(y, m, d, 0);
  FBorderStyle := bsDialog;
  AnchorComponent := TControl(AOwner);
  Fcaption := 'JD calendar';
end;

destructor TJDCalendarDialog.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TJDCalendarDialog.CalendarDblClick(Sender: TObject);
begin
  DF.modalresult := mrOk;
end;

function TJDCalendarDialog.Execute: boolean;
var
{$ifdef lclwince}
  okButton: TButton;
  cancelButton: TButton;
{$else}
  okButton: TBitBtn;
{$endif}
  pos: TPoint;
begin
  DF := TForm.Create(Self);
  DF.Caption := Fcaption;
  DF.BorderStyle := FBorderStyle;
  DF.FormStyle := fsStayOnTop;
  DF.Font := FFont;
  DF.AutoScroll := False;
  {$ifdef lclwince}
  DF.Width := screen.Width;
  DF.Height := screen.Height;
  {$endif}

  JDCalendar := TJDMonthlyCalendar.Create(Self);
  with JDCalendar do
  begin
    Font := FFont;
    Parent := DF;
    Align := alTop;
    {$ifdef lclwince}
    Width := DF.Width;
    Height := DF.Height;
    {$endif}
    onDblClick := @CalendarDblClick;
  end;
  JDCalendar.JD := savejd;
  if Flabels.mon <> '' then
    JDCalendar.labels := labels;
  DF.ClientHeight := JDCalendar.Height;
  DF.ClientWidth := JDCalendar.Width;

  if AnchorComponent <> nil then
  begin
    pos.x := 0;
    pos.y := AnchorComponent.Height;
    pos := AnchorComponent.ClientToScreen(pos);
  end
  else
  begin
    pos := mouse.CursorPos;
  end;
  DF.Left := pos.x;
  DF.Top := pos.y;

{$ifdef lclwince}
  okButton := TButton.Create(Self);
  okButton.Caption := 'ok';
{$else}
  okButton := TBitBtn.Create(Self);
  okButton.Kind := bkOK;
  okButton.Caption := '';
  okButton.layout := blGlyphTop;
{$endif}
  with okButton do
  begin
    Parent := JDCalendar.BottomPanel;
    Font := FFont;
    Width := 30;
    Height := 25;
    ModalResult := mrOk;
    Default := True;
    top := 0;
    left := JDCalendar.Width - Width - 2;
  end;
{$ifdef lclwince}
  cancelButton := TButton.Create(Self);
  cancelButton.Caption := 'X';
{$endif}

  Result := DF.ShowModal = mrOk;
  if Result then
    savejd := JDCalendar.JD;

  FreeAndNil(JDCalendar);
  FreeAndNil(okButton);
{$ifdef lclwince}
  FreeAndNil(cancelButton);
{$endif}
  FreeAndNil(DF);
end;

{ TJDDatePicker }

constructor TJDDatePicker.Create(AOwner: TComponent);
var
  y, m, d: word;
begin
  inherited Create(AOwner);
  DecodeDate(now, y, m, d);
  savejd := Jdd(y, m, d, 0);
  Fcaption := 'JD calendar';
  Color := clBtnFace;
  ReadOnly := True;
  Button.Glyph.LoadFromLazarusResource('BtnDatePicker');
//  Button.OnClick := @DoButtonClick;
  Button.OnClick := @ButtonClick;
  Button.Enabled := True;
  UpdDate;
end;

destructor TJDDatePicker.Destroy;
begin
  inherited Destroy;
end;

//procedure TJDDatePicker.DoButtonClick(Sender: TObject);//or onClick
procedure TJDDatePicker.ButtonClick(Sender: TObject);//or onClick
var
  CD: TJDCalendarDialog;
begin
//  inherited DoButtonClick(Sender);
  inherited ButtonClick;

  CD := TJDCalendarDialog.Create(Self);
  CD.JD := savejd;
  if Flabels.mon <> '' then
    CD.labels := Flabels;
  CD.Caption := Fcaption;
  //  CD.BorderStyle:=bsNone;
  try
    if CD.Execute then
    begin
      savejd := CD.JD;
      UpdDate;
    end;
  except
  end;
  FreeAndNil(CD);
end;

procedure TJDDatePicker.UpdDate;
var
  y, m, d: integer;
  hh: double;
  txt: string;
begin
  djd(savejd, y, m, d, hh);
  Text := IntToStr(y);
  txt := IntToStr(m);
  if length(txt) = 1 then
    txt := '0' + txt;
  Text := Text + '.' + txt;
  txt := IntToStr(d);
  if length(txt) = 1 then
    txt := '0' + txt;
  Text := Text + '.' + txt;
end;

procedure TJDDatePicker.SetJD(Value: double);
begin
  savejd := Value;
  UpdDate;
end;

{ TTimePicker }

constructor TTimePicker.Create(Aowner: TComponent);
var
  dsize, lsize: integer;
begin
  inherited Create(Aowner);
  lockchange := True;
  Caption := '';
  BevelOuter := bvNone;
  dsize := 25;
  lsize := 10;
  EditH := TLongEdit.Create(self);
  EditM := TLongEdit.Create(self);
  EditS := TLongEdit.Create(self);
  LabelH := TLabel.Create(self);
  LabelM := TLabel.Create(self);
  EditH.Parent := self;
  EditM.Parent := self;
  EditS.Parent := self;
  LabelH.Parent := self;
  LabelM.Parent := self;
  EditH.ParentFont := True;
  EditM.ParentFont := True;
  EditS.ParentFont := True;
  LabelH.ParentFont := True;
  LabelM.ParentFont := True;
  EditH.Value := 0;
  EditH.MinValue:=0;
  EditH.MaxValue:=23;
  EditH.Top := 0;
  EditH.Left := 0;
  EditH.Width := dsize;
  LabelH.Caption := ':';
  LabelH.Top := (EditH.Height - LabelH.Height) div 2;
  LabelH.Left := EditH.Left + EditH.Width + 2;
  EditM.Value := 0;
  EditM.MinValue:=0;
  EditM.MaxValue:=59;
  EditM.Top := 0;
  EditM.Left := LabelH.Left + lsize;
  EditM.Width := dsize;
  LabelM.Caption := ':';
  LabelM.Top := LabelH.Top;
  LabelM.Left := EditM.Left + EditM.Width + 2;
  EditS.Value := 0;
  EditS.MinValue:=0;
  EditS.MaxValue:=59;
  EditS.Top := 0;
  EditS.Left := LabelM.Left + lsize;
  EditS.Width := dsize;
  Height := EditH.Height;
  Width := EditS.Left + EditS.Width + 2;
  EditH.OnChange := @EditChange;
  EditM.OnChange := @EditChange;
  EditS.OnChange := @EditChange;
  lockchange := False;
  settime(now);
end;

destructor TTimePicker.Destroy;
begin
  inherited Destroy;
end;

function FixNum(txt: string; maxl: integer): string;
var
  i: integer;
  c: string;
begin
  Result := '';
  for i := 1 to length(txt) do
  begin
    c := copy(txt, i, 1);
    if ((c >= '0') and (c <= '9')) then
      Result := Result + c;
    if length(Result) >= maxl then
      break;
  end;
end;

procedure TTimePicker.SetTime(Value: TDateTime);
begin
  EditH.Text := formatdatetime('hh', Value);
  EditM.Text := formatdatetime('nn', Value);
  EditS.Text := formatdatetime('ss', Value);
end;

function TTimePicker.ReadTime: TDateTime;
begin
  EditH.Text := FixNum(EditH.Text, 2);
  EditM.Text := FixNum(EditM.Text, 2);
  EditS.Text := FixNum(EditS.Text, 2);
  Result := (strtointdef(EditH.Text, 0) + (strtointdef(EditM.Text, 0) / 60) +
    (strtointdef(EditS.Text, 0) / 3600)) / 24;
end;

procedure TTimePicker.Paint;
begin
  Caption := '';
  inherited Paint;
end;

procedure TTimePicker.EditChange(Sender: TObject);
begin
  if (not lockchange) and assigned(FOnChange) then
    FOnChange(self);
end;

procedure TTimePicker.SetEnable(Value: boolean);
begin
  EditH.Enabled := Value;
  EditM.Enabled := Value;
  EditS.Enabled := Value;
  LabelH.Enabled := Value;
  LabelM.Enabled := Value;
end;

function TTimePicker.GetEnable: boolean;
begin
  Result := EditH.Enabled;
end;

initialization
  {$I jdcalendar.lrs}

end.

