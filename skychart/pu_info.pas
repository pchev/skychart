unit pu_info;

{$MODE Delphi}{$H+}

{
Copyright (C) 2003 Patrick Chevalley

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
{
 Information Form (TCP/IP Server, Object list, ...)
}

interface

uses
  u_help, u_translation, u_constant, u_util, UScaleDPI,
  SysUtils, Types, Classes, Controls, Forms, Printers, Graphics, LCLType,
  Dialogs, StdCtrls, Grids, ComCtrls, ExtCtrls, Menus, StdActns, ActnList,
  LResources, Buttons, LazHelpHTML;

type
  Tistrfunc = procedure(i: integer; var txt: string) of object;
  Tint1func = procedure(i: integer) of object;
  Tdetinfo = procedure(chart: string; ra, Dec: double; cat, nm, desc: string) of object;

  { Tf_info }

  Tf_info = class(TForm)
    Button4: TButton;
    ComboBox1: TComboBox;
    InfoMemo: TMemo;
    PageControl1: TPageControl;
    SortLabel: TLabel;
    Page1: TPanel;
    Page2: TPanel;
    Page3: TPanel;
    Page4: TPanel;
    StringGrid2: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TitlePanel: TPanel;
    serverinfo: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    StringGrid1: TStringGrid;
    Panel2: TPanel;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    closeconnection: TMenuItem;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    Panel3: TPanel;
    Button3: TButton;
    Edit1: TEdit;
    PopupMenu2: TPopupMenu;
    outslectionner1: TMenuItem;
    Copier1: TMenuItem;
    Button6: TButton;
    Button7: TButton;
    SaveDialog1: TSaveDialog;
    ProgressMemo: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure closeconnectionClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGrid2CompareCells(Sender: TObject;
      ACol, ARow, BCol, BRow: integer; var Result: integer);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure StringGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StringGrid2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
    FGetTCPinfo: Tistrfunc;
    FKillTCP: Tint1func;
    FPrintSetup: TNotifyEvent;
    Fdetailinfo: Tdetinfo;
    RowClick, ColClick: integer;
    ActivePage: integer;
    MouseX, MouseY: integer;
    SearchStr: string;
    SearchPos: integer;
  public
    { Public declarations }
    source_chart: string;
    procedure setpage(n: integer);
    procedure setgrid(txt: string);
    procedure SetLang;
    property OnGetTCPinfo: Tistrfunc read FGetTCPinfo write FGetTCPinfo;
    property OnKillTCP: Tint1func read FKillTCP write FKillTCP;
    property OnPrintSetup: TNotifyEvent read FPrintSetup write FPrintSetup;
    property OnShowDetail: Tdetinfo read Fdetailinfo write Fdetailinfo;
  end;

var
  f_info: Tf_info;

implementation

{$R *.lfm}

procedure Tf_info.SetLang;
begin
  Caption := rsInfo;
  Button2.Caption := rsRefresh;
  CheckBox1.Caption := rsAutoRefresh;
  Button3.Caption := rsSearch;
  Button4.Caption := rsHelp;
  Button6.Caption := rsPrint;
  Button7.Caption := rsSave;
  Button1.Caption := rsClose;
  closeconnection.Caption := rsCloseConnect;
  outslectionner1.Caption := rsSelectAll;
  Copier1.Caption := rsCopy;
  SortLabel.Caption := rsSortBy + ':';
  ComboBox1.Clear;
  ComboBox1.Items.Add('');
  ComboBox1.Items.Add(rsRA);
  ComboBox1.Items.Add(rsDEC);
  ComboBox1.Items.Add(rsType);
  ComboBox1.Items.Add(rsName);
  ComboBox1.Items.Add(rsMagn);
end;

procedure Tf_info.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure Tf_info.Button2Click(Sender: TObject);
var
  i: integer;
  buf: string;
begin
  if not assigned(FGetTCPinfo) then
    exit;
  try
    stringgrid1.RowCount := Maxwindow;
    for i := 1 to Maxwindow do
    begin
      FGetTCPinfo(i, buf);
      stringgrid1.Cells[0, i - 1] := buf;
    end;
  except
  end;
end;

procedure Tf_info.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_info.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = mbRight then
  begin
    stringgrid1.MouseToCell(X, Y, ColClick, RowClick);
    if (ColClick >= 0) and (RowClick >= 0) then
    begin
      stringgrid1.Col := ColClick;
      stringgrid1.Row := RowClick;
    end;
  end;
end;

procedure Tf_info.closeconnectionClick(Sender: TObject);
begin
  if (RowClick >= 0) and assigned(FKillTCP) then
    FKillTCP(RowClick + 1);
end;

procedure Tf_info.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex > 0 then
  begin
    StringGrid2.SortOrder := soAscending;
    StringGrid2.SortColRow(True, ComboBox1.ItemIndex);
    SearchPos := 0;
    SearchStr := '';
    StringGrid2.TopRow := 1;
    StringGrid2.Selection := rect(0, 1, StringGrid2.ColCount - 1, 1);
  end;
end;

procedure Tf_info.StringGrid2CompareCells(Sender: TObject;
  ACol, ARow, BCol, BRow: integer; var Result: integer);
var
  s1, s2, buf: string;
  n1, n2: double;
  p, i1, i2: integer;
begin
  with Sender as TStringGrid do
  begin
    s1 := Cells[ACol, ARow];
    s2 := Cells[BCol, BRow];
  end;
  i1 := 1;
  i2 := 1;
  n1 := 0;
  n2 := 0;
  if (ACol = 5) and (BCol = 5) then
  begin  //magnitude
    p := pos(':', s1);
    if p > 0 then
      buf := copy(s1, p + 1, 999)
    else
      buf := s1;
    val(buf, n1, i1);
    p := pos(':', s2);
    if p > 0 then
      buf := copy(s2, p + 1, 999)
    else
      buf := s2;
    val(buf, n2, i2);
  end;
  if (i1 = 0) and (i2 = 0) then
  begin
    if n1 = n2 then
      Result := 0
    else if n1 > n2 then
      Result := 1
    else
      Result := -1;
  end
  else
  begin
    if s1 = s2 then
      Result := 0
    else if s1 > s2 then
      Result := 1
    else
      Result := -1;
  end;
end;


procedure Tf_info.EditCopy1Execute(Sender: TObject);
begin
  StringGrid2.CopyToClipboard(True);
end;

procedure Tf_info.EditSelectAll1Execute(Sender: TObject);
begin
  StringGrid2.Selection := rect(0, 1, StringGrid2.ColCount - 1, StringGrid2.RowCount - 1);
end;

procedure Tf_info.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  PageControl1.ShowTabs:= false;

  SetLang;
 {$ifdef mswindows}
  SaveDialog1.Options := SaveDialog1.Options - [ofNoReadOnlyReturn];
  { TODO : check readonly test on Windows }
 {$endif}
end;

procedure Tf_info.StringGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  MouseX := X;
  MouseY := Y;
end;

procedure Tf_info.StringGrid2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  MouseX := X;
  MouseY := Y;
end;

procedure Tf_info.StringGrid2DblClick(Sender: TObject);
var
  col, row, i: integer;
  ra, Dec: double;
  buf, s, desc, nm, cat: string;
begin
  StringGrid2.MouseToCell(MouseX, MouseY, Col, Row);
  if row > 0 then
  begin
    buf := StringGrid2.Cells[1, Row];
    ra := strtofloat(copy(buf, 1, 2)) + strtofloat(copy(buf, 4, 2)) / 60 + strtofloat(
      copy(buf, 7, 5)) / 3600;
    buf := StringGrid2.Cells[2, Row];
    s := copy(buf, 1, 1);
    Dec := strtofloat(s + copy(buf, 2, 2)) + strtofloat(s + copy(buf, 4 + length(ldeg), 2)) /
      60 + strtofloat(s + copy(buf, 6 + length(ldeg) + length(lmin), 4)) / 3600;
    nm := StringGrid2.Cells[4, Row];
    cat := StringGrid2.Cells[0, Row];
    desc := '';
    for i := 1 to StringGrid2.ColCount - 1 do
    begin
      buf := trim(StringGrid2.Cells[i, Row]);
      if buf > '' then
      begin
        if desc > '' then
          desc := desc + tab;
        desc := desc + buf;
      end;
    end;
    if assigned(Fdetailinfo) then
      Fdetailinfo(source_chart, deg2rad * ra * 15, deg2rad * Dec, cat, nm, desc);
  end;
end;

procedure Tf_info.FormShow(Sender: TObject);
begin
  Button6.Visible := (Printer.PrinterIndex >= 0);
  case ActivePage of
    0:
    begin
      panel1.Visible := True;
      Button2Click(self);
      Timer1.Enabled := CheckBox1.Checked;
      SetHelp(self, hlpSrvInfo);
    end;
    1:
    begin
      panel1.Visible := True;
      ComboBox1.ItemIndex := 0;
      SearchStr := '';
      SearchPos := 0;
      SetHelp(self, hlpObjList);
    end;
    2:
    begin
      panel1.Visible := False;
      f_info.ProgressMemo.Clear;
      SetHelp(self, hlpIndex);
    end;
    3:
    begin
      panel1.Visible := True;
      SetHelp(self, hlpIndex);
    end;
  end;
end;

procedure Tf_info.setpage(n: integer);
begin

  if n <> 3 then
    Button1.Caption := rsClose;

  ActivePage := n;
  PageControl1.ActivePageIndex := ActivePage;

  case ActivePage of
    0: TitlePanel.Caption := rsTCPIPConnect;
    1: TitlePanel.Caption := rsObjectList;
    2: TitlePanel.Caption := rsProgressMess;
    3: TitlePanel.Caption := rsProgramInfor;
  end;
end;

procedure Tf_info.CheckBox1Click(Sender: TObject);
begin
  Timer1.Enabled := CheckBox1.Checked;
end;

procedure Tf_info.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
end;

procedure Tf_info.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  try
    Button2Click(self);
  finally
    Timer1.Enabled := CheckBox1.Checked;
  end;
end;


procedure Tf_info.Button3Click(Sender: TObject);
var
  n: integer;
  ok: boolean;
begin
  if UpperCase(Edit1.Text) <> Searchstr then
  begin
    SearchStr := UpperCase(Edit1.Text);
    SearchPos := 0;
  end;
  if SearchPos >= StringGrid2.RowCount - 1 then
    SearchPos := 0;
  ok := False;
  n := 0;
  repeat
    repeat
      Inc(SearchPos);
      if pos(SearchStr, UpperCase(StringGrid2.Cells[4, SearchPos])) > 0 then
      begin
        StringGrid2.TopRow := SearchPos;
        StringGrid2.Selection := rect(0, SearchPos, StringGrid2.ColCount - 1, SearchPos);
        ok := True;
        break;
      end;
    until SearchPos >= StringGrid2.RowCount - 1;
    if ok then
      break;
    Inc(n);
    SearchPos := 0;
  until n > 1;
  if not ok then
    ShowMessage(Format(rsNotFound, [Edit1.Text]));
end;

procedure Tf_info.Edit1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = VK_RETURN then
    Button3Click(Sender);
end;

procedure Tf_info.Button6Click(Sender: TObject);
var
  i, r: integer;
  list: TStringList;
  buf, desc: string;
begin
  //PrtGrid(StringGrid2, 'CdC', rsObjectList, '', poLandscape);
  list := TStringList.Create;
  try

    for r := 0 to StringGrid2.RowCount - 1 do
    begin
      desc := '';
      for i := 0 to StringGrid2.ColCount - 1 do
      begin
        buf := trim(StringGrid2.Cells[i, r]);
        if desc > '' then
          desc := desc + tab;
        desc := desc + buf;
      end;
      desc := ExpandTab(desc, 6);
      list.add(desc);
    end;
    PrintStrings(list, 'CdC', rsObjectList, '', poLandscape);
  finally
    list.Free;
  end;
end;

procedure Tf_info.Button7Click(Sender: TObject);
var
  fsep, desc, buf: string;
  r, i: integer;
  f: textfile;
begin
  try
    Savedialog1.DefaultExt := '.csv';
    Savedialog1.filter := 'Comma Separated File (*.csv)|*.csv|Tab Separated File (*.tsv)|*.tsv';
    Savedialog1.Title := rsSaveToFile;
    Savedialog1.Initialdir := HomeDir;
    if SaveDialog1.Execute then
    begin
      if UpperCase(ExtractFileExt(Savedialog1.FileName)) = '.CSV' then
        fsep := ','
      else
        fsep := tab;
      AssignFile(f, SafeUTF8ToSys(Savedialog1.FileName));
      rewrite(f);
      for r := 0 to StringGrid2.RowCount - 1 do
      begin
        desc := '';
        for i := 0 to StringGrid2.ColCount - 1 do
        begin
          buf := trim(StringGrid2.Cells[i, r]);
          if fsep = ',' then
            buf := StringReplace(buf, ',', '.', [rfReplaceAll]);
          if desc > '' then
            desc := desc + fsep;
          desc := desc + buf;
        end;
        writeln(f, desc);
      end;
      CloseFile(f);
    end
  finally
    ChDir(appdir);
  end;
end;

procedure Tf_info.setgrid(txt: string);
var
  i, j, rowc, colc: integer;
  c: char;
  buf: string;
begin
  // find table size
  rowc := 0;
  colc := 0;
  i := 1;
  j := 0;
  repeat
    c := txt[i];
    if c = chr(9) then
    begin // new col
      Inc(j);
    end;
    if c = chr(13) then
    begin // new row
      Inc(j);
      Inc(rowc);
      if j > colc then
        colc := j;
      Inc(i); // skip #10
      j := 0;
    end;
    Inc(i);
  until i > length(txt);
  if colc < 6 then
    colc := 6;
  // setup table
  StringGrid2.Clear;
  StringGrid2.ColCount := colc;
  StringGrid2.RowCount := rowc + 1;
  StringGrid2.FixedRows := 1;
  StringGrid2.Cells[0, 0] := rsCatalog;
  StringGrid2.Cells[1, 0] := rsRA;
  StringGrid2.Cells[2, 0] := rsDEC;
  StringGrid2.Cells[3, 0] := rsType;
  StringGrid2.Cells[4, 0] := rsName;
  StringGrid2.Cells[5, 0] := rsMagn;
  ComboBox1.Clear;
  ComboBox1.Items.Add('');
  ComboBox1.Items.Add(rsRA);
  ComboBox1.Items.Add(rsDEC);
  ComboBox1.Items.Add(rsType);
  ComboBox1.Items.Add(rsName);
  ComboBox1.Items.Add(rsMagn);
  for i := 6 to colc - 1 do
  begin
    StringGrid2.Cells[i, 0] := IntToStr(i);
    ComboBox1.Items.Add(rsColumns + blank + IntToStr(i));
  end;
  // fill the table
  rowc := 1;
  colc := 0;
  i := 1;
  buf := '';
  repeat
    c := txt[i];
    if c = chr(0) then
    begin // ?
    end
    else if c = chr(9) then
    begin // new col
      StringGrid2.Cells[colc, rowc] := trim(buf);
      buf := '';
      Inc(colc);
    end
    else if c = chr(13) then
    begin // new row
      StringGrid2.Cells[colc, rowc] := trim(buf);
      buf := '';
      colc := 0;
      Inc(rowc);
      Inc(i); // skip #10
    end
    else
      buf := buf + c;
    Inc(i);
  until i > length(txt);
  StringGrid2.AutoSizeColumns;
end;

end.
