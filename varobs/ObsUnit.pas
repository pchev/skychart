unit ObsUnit;

{$MODE Delphi}

{
Copyright (C) 2008 Patrick Chevalley

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

interface

uses
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, UScaleDPI,
  StdCtrls, Buttons, ComCtrls, LResources, jdcalendar, EditBtn, u_param, Menus, u_util2;

type

  { TObsForm }

  TObsForm = class(TForm)
    Button1: TButton;
    Editbtn: TButton;
    DateEdit1: TDateEdit;
    Edit1: TEdit;
    Edit9: TEdit;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label7: TLabel;
    Label9: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label10: TLabel;
    CheckBox2: TCheckBox;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PopupMenu1: TPopupMenu;
    TimePicker1: TTimePicker;
    procedure Button1Click(Sender: TObject);
    procedure EditbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure DateEdit1Change(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure CodeClick(Sender: TObject);
  private
    { Private declarations }
    procedure WriteAAVSOheader(var f: textfile);
  public
    { Public declarations }
  end;

var
  ObsForm: TObsForm;
  current: integer;

implementation

{$R *.lfm}

uses variables1, SettingUnit;

const
  coma = ',';

var
  sname: string;
  lockdate: boolean;

function FixLen(buf: string; len: integer): string;
begin
  Result := copy(buf, 1, len);
  while length(Result) < len do
    Result := Result + ' ';
end;

procedure TObsForm.MenuItem2Click(Sender: TObject);
begin
  checkbox2.Checked := False;
  edit3.Text := '';
  edit4.Text := '';
  edit5.Text := '';
  edit6.Text := '';
  edit7.Text := '';
  edit8.Text := '';
  edit9.Text := '';
end;

procedure TObsForm.MenuItem3Click(Sender: TObject);
begin
  Close;
end;

procedure TObsForm.CodeClick(Sender: TObject);
begin
  edit5.Text := trim(edit5.Text) + trim(copy(Tmenuitem(Sender).Caption, 1, 1));
end;

procedure TObsForm.FormShow(Sender: TObject);
var
  p, i: integer;
  buf, nam, con: string;
begin
  checkbox2.Checked := False;
  edit3.Text := '';
  edit4.Text := '';
  edit5.Text := '';
  edit6.Text := '';
  edit7.Text := '';
  edit8.Text := '';
  edit9.Text := '';
  if current > 0 then
  begin
    case optform.radiogroup4.ItemIndex of
      0:
      begin   //AAVSO
        Button1.Visible := True;
        Edit1.Text := varform.Grid1.Cells[0, current];
        Edit1.ReadOnly := False;
        Label6.Caption := 'Comp Star 1';
        Label11.Visible := True;
        edit9.Visible := True;
        label2.Caption := 'JD + GMAT ';
        if Edit2.Text = '' then
          Edit2.Text := trim(varform.Edit1.Text);      // Date
        Edit4.Text := optform.Edit4.Text;            // Observer
      end;
      1:
      begin //VSNET
        Button1.Visible := False;
        buf := trim(varform.Grid1.Cells[0, current]);      // star name
        p := pos(' ', buf);
        if p > 0 then
        begin
          nam := trim(copy(buf, 1, p));
          if (uppercase(copy(nam, 1, 1)) = 'V') and IsNumber(copy(nam, 2, 99)) then
          begin
            nam := 'V' + IntToStr(StrToInt(copy(nam, 2, 99)));
          end;
          for i := 1 to 24 do
            if nam = greek[2, i] then
              nam := greek[1, i];
          con := uppercase(trim(copy(buf, p + 1, 99)));
          if pos(con, uppercase(abrcons)) > 0 then
            sname := con + nam
          else
            sname := nam + con;
        end
        else
          sname := uppercase(buf);
        Edit1.Text := sname;
        Edit1.ReadOnly := False;
        Label6.Caption := 'Comp Stars';
        Label11.Visible := False;
        edit9.Visible := False;
        label2.Caption := 'UT decimal';
        if Edit2.Text = '' then
          Edit2.Text := trim(varform.Edit2.Text);      // Date
        Edit4.Text := optform.Edit4.Text;            // Observer
      end;
    end;
  end;
  Edit2Change(Sender);
  case OptForm.RadioGroup7.ItemIndex of
    0: FileNameEdit1.Text := OptForm.FileNameEdit3.Text;
    1: FileNameEdit1.Text := changefileext(OptForm.FileNameEdit3.Text, '') + '-' +
        trim(edit2.Text) + extractfileext(OptForm.FileNameEdit3.Text);
  end;
end;

procedure TObsForm.Button1Click(Sender: TObject);
begin
  PopupMenu1.PopUp(mouse.cursorpos.x, mouse.cursorpos.y);
end;

procedure TObsForm.EditbtnClick(Sender: TObject);
begin
  ExecuteFile(SafeUTF8ToSys(FilenameEdit1.Text));
end;

procedure TObsForm.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
end;

procedure TObsForm.AddClick(Sender: TObject);
var
  buf, s: string;
  p: integer;
begin
  case OptForm.RadioGroup4.ItemIndex of
    0:
    begin  // aavso vis
      if edit1.Text = '' then
      begin
        ShowMessage('Enter a star name !');
        exit;
      end;
      if edit2.Text = '' then
      begin
        ShowMessage('Enter a date !');
        exit;
      end;
      if edit3.Text = '' then
      begin
        ShowMessage('Enter a magnitude !');
        exit;
      end;
      if edit4.Text = '' then
      begin
        ShowMessage('Enter an observer !');
        exit;
      end;
      if edit6.Text = '' then
      begin
        ShowMessage('Enter comparison stars !');
        exit;
      end;
      if edit7.Text = '' then
      begin
        ShowMessage('Enter chart name !');
        exit;
      end;
      buf := trim(edit1.Text) + coma + trim(edit2.Text) + coma;
      if checkbox2.Checked then
        buf := buf + '<';
      s := trim(edit3.Text);
      p := pos('.', s);
      if p = 0 then
      begin
        ShowMessage('Magnitude must include decimal point !');
        exit;
      end;
      if p = 1 then
        s := '0' + s;
      buf := buf + trim(s) + coma;
      if trim(edit5.Text) = '' then
        buf := buf + 'na' + coma
      else
        buf := buf + trim(edit5.Text) + coma;
      buf := buf + trim(edit6.Text) + coma;
      if trim(edit9.Text) = '' then
        buf := buf + 'na' + coma
      else
        buf := buf + trim(edit9.Text) + coma;
      buf := buf + trim(edit7.Text) + coma;
      if trim(edit8.Text) = '' then
        buf := buf + 'na'
      else
        buf := buf + trim(edit8.Text);
    end;
    1:
    begin  // vsnet
      if edit1.Text = '' then
      begin
        ShowMessage('Enter a star name !');
        exit;
      end;
      if edit2.Text = '' then
      begin
        ShowMessage('Enter a date !');
        exit;
      end;
      if edit3.Text = '' then
      begin
        ShowMessage('Enter a magnitude !');
        exit;
      end;
      if edit4.Text = '' then
      begin
        ShowMessage('Enter an observer !');
        exit;
      end;
      s := trim(edit3.Text);
      if checkbox2.Checked then
        s := '<' + s;
      buf := edit1.Text + ' ' + edit2.Text + ' ' + s + ' ' + edit4.Text + ' ' + edit5.Text + ' ' +
        edit6.Text + ' ' + edit7.Text + ' ' + edit8.Text;
    end;
    else
      buf := '';
  end;
  memo1.Lines.Add(buf);
end;

procedure TObsForm.WriteAAVSOheader(var f: textfile);
begin
  writeln(f, '#TYPE=VISUAL');
  writeln(f, '#OBSCODE=' + trim(edit4.Text));
  writeln(f, '#SOFTWARE=' + software_version);
  writeln(f, '#DELIM=,');
  writeln(f, '#DATE=JD');
  writeln(f, '#REPORT-DATE=' + DateTimeToStr(now));
  writeln(f, '#NAME,DATE,MAG,COMMENTCODE,COMP1,COMP2,CHART,NOTES');
end;

procedure TObsForm.Button2Click(Sender: TObject);
var
  f: textfile;
  i: integer;
  fn, buf: string;
begin
  fn := SafeUTF8ToSys(FilenameEdit1.Text);
  if optform.RadioGroup7.ItemIndex = 0 then
  begin
    try
      assignfile(f, fn);
      if fileexists(fn) then
        append(f)
      else
      begin
        rewrite(f);
        if OptForm.RadioGroup4.ItemIndex = 0 then
          WriteAAVSOheader(f);
      end;
      for i := 0 to memo1.Lines.Count - 1 do
      begin
        buf := memo1.Lines[i];
        writeln(f, buf);
      end;
      closefile(f);
    finally
      memo1.Clear;
    end;
  end
  else
  begin
    if (not fileexists(fn)) or (mrYes = MessageDlg(
      'File already exists. Overwrite ?', mtConfirmation, mbYesNo, 0)) then
    begin
      try
        assignfile(f, fn);
        rewrite(f);
        if OptForm.RadioGroup4.ItemIndex = 0 then
          WriteAAVSOheader(f);
        for i := 0 to memo1.Lines.Count - 1 do
        begin
          buf := memo1.Lines[i];
          writeln(f, buf);
        end;
        closefile(f);
      finally
        memo1.Clear;
        TimePicker1.Time := now;
        DateEdit1Change(Sender);
        FileNameEdit1.Text := changefileext(OptForm.FileNameEdit3.Text, '') + '-' +
          trim(edit2.Text) + extractfileext(OptForm.FileNameEdit3.Text);
      end;
    end;
  end;
end;

procedure TObsForm.DateEdit1Change(Sender: TObject);
var
  y1, m1, d1: word;
  hm: double;
  buf, buf1: string;
begin
  //if lockdate then begin lockdate:=false; exit; end;
  //if locktime then begin locktime:=false; exit; end;
  //getdate(DateEdit1.date,y1,m1,d1);
  //hm:=frac(timepicker1.time);
  hm := frac(timepicker1.time) - TZ / 24;
  hm := hm + trunc(DateEdit1.date);
  getdate(trunc(hm), y1, m1, d1);
  hm := frac(hm);
  try
    lockdate := True;
    locktime := True;
    case optform.radiogroup4.ItemIndex of
      0:
      begin
        str(jd(y1, m1, d1, hm * 24): 9: 4, buf);
        edit2.Text := buf;
        edit2.color := clWindow;
      end;
      1:
      begin
        buf1 := format('%.4d%.2d%.2d', [y1, m1, d1]);
        str(hm: 1: 4, buf);
        edit2.Text := buf1 + copy(buf, 2, 9);
        edit2.color := clWindow;
      end;
    end;
    Application.ProcessMessages;
  finally
    lockdate := False;
    locktime := False;
  end;
end;

procedure TObsForm.Edit2Change(Sender: TObject);
var
  yy, mm, dd, p: integer;
  hm, jdt: double;
  buf: string;
begin
  if lockdate then
  begin
    lockdate := False;
    exit;
  end;
  if locktime then
  begin
    locktime := False;
    exit;
  end;
  try
    case optform.radiogroup4.ItemIndex of
      0:
      begin
        jdt := strtofloat(edit2.Text);
        djd(jdt + (TZ / 24), yy, mm, dd, hm);
        //djd(strtofloat(edit2.text),yy,mm,dd,hm);
      end;
      1:
      begin
        buf := trim(edit2.Text);
        p := pos('.', buf);
        if p = 0 then
          p := length(buf);
        if p < 5 then
        begin
          edit2.color := clRed;
          exit;
        end;
        yy := StrToInt(copy(buf, 1, p - 5));
        mm := StrToInt(copy(buf, p - 4, 2));
        dd := StrToInt(copy(buf, p - 2, 2));
        hm := strtofloat(copy(buf, p, 9)) * 24;
        jdt := jd(yy, mm, dd, hm) + (TZ / 24);
        Djd(jdt, yy, mm, dd, hm);
      end;
    end;
    if (yy > 1800) and (yy < 3000) then
    begin
      edit2.color := clWindow;
      lockdate := True;
      locktime := True;
      DateEdit1.date := setdate(yy, mm, dd);
      lockdate := True;
      locktime := True;
      timepicker1.time := hm / 24;
    end
    else
    begin
      edit2.color := clRed;
    end;
  except
    edit2.color := clRed;
  end;
  Application.ProcessMessages;
  lockdate := False;
  locktime := False;
end;

procedure TObsForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if memo1.Lines.Count > 0 then
  begin
    if mrYes = MessageDlg(
      'You can keep this form open and return later to add a new observation.' +
      crlf + 'Some data are not saved to file and will be lost. Do you really whant to quit ?',
      mtWarning, mbYesNo, 0) then
    begin
      memo1.Clear;
      canclose := True;
    end
    else
      canclose := False;
  end
  else
    canclose := True;
end;

end.
