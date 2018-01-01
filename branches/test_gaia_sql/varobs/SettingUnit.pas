unit SettingUnit;

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
  StdCtrls, ExtCtrls, Buttons, LResources, u_param, ComCtrls, EditBtn, Spin;

type

  { TOptForm }

  TOptForm = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    DirectoryEdit3: TDirectoryEdit;
    DirectoryEdit2: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    opencmd: TEdit;
    FileNameEdit0: TFileNameEdit;
    FileNameEdit1: TFileNameEdit;
    FileNameEdit2: TFileNameEdit;
    FileNameEdit3: TFileNameEdit;
    FileNameEdit4: TFileNameEdit;
    FileNameEdit8: TFileNameEdit;
    GroupBox0: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox1: TGroupBox;
    GroupBox9: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    qlurl: TLabeledEdit;
    afoevurl: TLabeledEdit;
    charturl: TLabeledEdit;
    tz: TSpinEdit;
    webobsurl: TLabeledEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    RadioGroup5: TRadioGroup;
    RadioGroup6: TRadioGroup;
    RadioGroup7: TRadioGroup;
    RadioGroup8: TRadioGroup;
    SpinEdit1: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup5Click(Sender: TObject);
    procedure RadioGroup8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptForm: TOptForm;

implementation

{$R *.lfm}

uses variables1;

procedure TOptForm.RadioGroup1Click(Sender: TObject);
begin
  case radiogroup1.ItemIndex of
    0:
    begin
      GroupBox0.Visible := True;
      GroupBox1.Visible := False;
      GroupBox2.Visible := False;
      GroupBox3.Visible := False;
      GroupBox4.Visible := False;
    end;
    1:
    begin
      GroupBox0.Visible := False;
      GroupBox1.Visible := True;
      GroupBox2.Visible := False;
      GroupBox3.Visible := False;
      GroupBox4.Visible := False;
    end;
    2:
    begin
      GroupBox0.Visible := False;
      GroupBox1.Visible := False;
      GroupBox2.Visible := True;
      GroupBox3.Visible := False;
      GroupBox4.Visible := False;
    end;
    3:
    begin
      GroupBox0.Visible := False;
      GroupBox1.Visible := False;
      GroupBox2.Visible := False;
      GroupBox3.Visible := True;
      GroupBox4.Visible := False;
    end;
    4:
    begin
      GroupBox0.Visible := False;
      GroupBox1.Visible := False;
      GroupBox2.Visible := False;
      GroupBox3.Visible := False;
      GroupBox4.Visible := True;
    end;
  end;
end;

procedure TOptForm.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  FileNameEdit0.InitialDir := privatedir;
  FileNameEdit1.InitialDir := privatedir;
  FileNameEdit2.InitialDir := privatedir;
  FileNameEdit3.InitialDir := privatedir;
  FileNameEdit4.InitialDir := privatedir;
  FileNameEdit8.InitialDir := privatedir;
end;

procedure TOptForm.Button1Click(Sender: TObject);
begin
  qlurl.Text := defqlurl;
  afoevurl.Text := defafoevurl;
  charturl.Text := defaavsocharturl;
  webobsurl.Text := defwebobsurl;
  opencmd.Text := DefaultOpenFileCMD;
end;

procedure TOptForm.RadioGroup3Click(Sender: TObject);
begin
  case Radiogroup3.ItemIndex of
    0:
    begin
      Label12.Caption := 'Field No';
      Label13.Caption := 'Field No';
      Label14.Caption := 'Field No';
    end;
    1:
    begin
      Label12.Caption := 'Start.End col';
      Label13.Caption := 'Start.End col';
      Label14.Caption := 'Start.End col';
    end;
  end;
end;

procedure TOptForm.FormShow(Sender: TObject);
begin
  radiogroup1click(Sender);
  RadioGroup5Click(Sender);
  RadioGroup8Click(Sender);
end;

procedure TOptForm.RadioGroup5Click(Sender: TObject);
begin
  case radiogroup5.ItemIndex of
    0:
    begin
      Panel1.Visible := True;
      Panel2.Visible := False;
    end;
    1:
    begin
      Panel1.Visible := False;
      Panel2.Visible := True;
    end;
    2:
    begin
      Panel1.Visible := False;
      Panel2.Visible := False;
    end;
  end;
end;


procedure TOptForm.RadioGroup8Click(Sender: TObject);
begin
  case radiogroup8.ItemIndex of
    0:
    begin // online
      DirectoryEdit2.Visible := False;
    end;
    1:
    begin  // cdrom
      DirectoryEdit2.Visible := True;
    end;
  end;
end;

end.
