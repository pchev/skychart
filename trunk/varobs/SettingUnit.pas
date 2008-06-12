unit SettingUnit;

{$MODE Delphi}

{
Copyright (C) 2008 Patrick Chevalley

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
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, LResources, u_param, ComCtrls, EditBtn;

type

  { TOptForm }

  TOptForm = class(TForm)
    BitBtn2: TBitBtn;
    Button1: TButton;
    DirectoryEdit3: TDirectoryEdit;
    DirectoryEdit2: TDirectoryEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    FileNameEdit0: TFileNameEdit;
    FileNameEdit1: TFileNameEdit;
    FileNameEdit2: TFileNameEdit;
    FileNameEdit3: TFileNameEdit;
    FileNameEdit4: TFileNameEdit;
    FileNameEdit5: TFileNameEdit;
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
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
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
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptForm: TOptForm;

implementation


Uses variables1;

procedure TOptForm.RadioGroup1Click(Sender: TObject);
begin
case radiogroup1.itemindex of
0 : begin
    GroupBox0.visible:=true;
    GroupBox1.visible:=false;
    GroupBox2.visible:=false;
    GroupBox3.visible:=false;
    GroupBox4.visible:=false;
    end;
1 : begin
    GroupBox0.visible:=false;
    GroupBox1.visible:=true;
    GroupBox2.visible:=false;
    GroupBox3.visible:=false;
    GroupBox4.visible:=false;
    end;
2 : begin
    GroupBox0.visible:=false;
    GroupBox1.visible:=false;
    GroupBox2.visible:=true;
    GroupBox3.visible:=false;
    GroupBox4.visible:=false;
    end;
3 : begin
    GroupBox0.visible:=false;
    GroupBox1.visible:=false;
    GroupBox2.visible:=false;
    GroupBox3.visible:=true;
    GroupBox4.visible:=false;
    end;
4 : begin
    GroupBox0.visible:=false;
    GroupBox1.visible:=false;
    GroupBox2.visible:=false;
    GroupBox3.visible:=false;
    GroupBox4.visible:=true;
    end;
end;
end;

procedure TOptForm.FormCreate(Sender: TObject);
begin
FileNameEdit0.InitialDir:=privatedir;
FileNameEdit1.InitialDir:=privatedir;
FileNameEdit2.InitialDir:=privatedir;
FileNameEdit3.InitialDir:=privatedir;
FileNameEdit4.InitialDir:=privatedir;
FileNameEdit5.InitialDir:=privatedir;
FileNameEdit8.InitialDir:=privatedir;
end;

procedure TOptForm.RadioGroup3Click(Sender: TObject);
begin
case Radiogroup3.itemindex of
0 : begin
      Label12.caption:='Field No';
      Label13.caption:='Field No';
      Label14.caption:='Field No';
    end;
1 : begin
      Label12.caption:='Start.End col';
      Label13.caption:='Start.End col';
      Label14.caption:='Start.End col';
    end;
end;
end;

procedure TOptForm.FormShow(Sender: TObject);
begin
radiogroup1click(sender);
RadioGroup5Click(Sender);
end;

procedure TOptForm.RadioGroup5Click(Sender: TObject);
begin
case radiogroup5.itemindex of
0 : begin
    Panel1.visible:=true;
    Panel2.visible:=False;
    end;
1 : begin
    Panel1.visible:=False;
    Panel2.visible:=true;
    end;
2 : begin
    Panel1.visible:=False;
    Panel2.visible:=False;
    end;
end;
end;

procedure TOptForm.Button1Click(Sender: TObject);
begin
DirectoryEdit2.Text:=aavsocharturl;
end;

initialization
  {$i SettingUnit.lrs}

end.
