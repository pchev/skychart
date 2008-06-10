unit SettingUnit;

{$MODE Delphi}

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
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, LResources, u_param;

type

  { TOptForm }

  TOptForm = class(TForm)
    Directoryedit1: TEdit;
    Directoryedit2: TEdit;
    FilenameEdit0: TEdit;
    FilenameEdit1: TEdit;
    FilenameEdit2: TEdit;
    FilenameEdit3: TEdit;
    FilenameEdit4: TEdit;
    FilenameEdit5: TEdit;
    FilenameEdit6: TEdit;
    FilenameEdit7: TEdit;
    FilenameEdit8: TEdit;
    RadioGroup1: TRadioGroup;
    GroupBox4: TGroupBox;
    RadioGroup2: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    GroupBox0: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    BitBtn1: TBitBtn;
    RadioGroup3: TRadioGroup;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label17: TLabel;
    GroupBox7: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    GroupBox8: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    RadioGroup5: TRadioGroup;
    Panel1: TPanel;
    RadioGroup4: TRadioGroup;
    Label15: TLabel;
    Panel2: TPanel;
    Label22: TLabel;
    Label23: TLabel;
    Edit4: TEdit;
    Label16: TLabel;
    RadioGroup6: TRadioGroup;
    GroupBox9: TGroupBox;
    Button1: TButton;
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
    GroupBox0.visible:=False;
    GroupBox1.visible:=false;
    GroupBox2.visible:=false;
    GroupBox3.visible:=false;
    GroupBox4.visible:=false;
    GroupBox7.visible:=true;
    GroupBox8.visible:=false;
    end;
1 : begin
    GroupBox0.visible:=false;
    GroupBox1.visible:=false;
    GroupBox2.visible:=false;
    GroupBox3.visible:=false;
    GroupBox4.visible:=false;
    GroupBox7.visible:=false;
    GroupBox8.visible:=true;
    end;
2 : begin
    GroupBox0.visible:=true;
    GroupBox1.visible:=false;
    GroupBox2.visible:=false;
    GroupBox3.visible:=false;
    GroupBox4.visible:=false;
    GroupBox7.visible:=false;
    GroupBox8.visible:=false;
    end;
3 : begin
    GroupBox0.visible:=false;
    GroupBox1.visible:=true;
    GroupBox2.visible:=false;
    GroupBox3.visible:=false;
    GroupBox4.visible:=false;
    GroupBox7.visible:=false;
    GroupBox8.visible:=false;
    end;
4 : begin
    GroupBox0.visible:=false;
    GroupBox1.visible:=false;
    GroupBox2.visible:=true;
    GroupBox3.visible:=false;
    GroupBox4.visible:=false;
    GroupBox7.visible:=false;
    GroupBox8.visible:=false;
    end;
5 : begin
    GroupBox0.visible:=false;
    GroupBox1.visible:=false;
    GroupBox2.visible:=false;
    GroupBox3.visible:=true;
    GroupBox4.visible:=false;
    GroupBox7.visible:=false;
    GroupBox8.visible:=false;
    end;
6 : begin
    GroupBox0.visible:=false;
    GroupBox1.visible:=false;
    GroupBox2.visible:=false;
    GroupBox3.visible:=false;
    GroupBox4.visible:=true;
    GroupBox7.visible:=false;
    GroupBox8.visible:=false;
    end;
end;
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
end;
end;

procedure TOptForm.Button1Click(Sender: TObject);
begin
DirectoryEdit2.Text:=aavsocharturl;
end;

initialization
  {$i SettingUnit.lrs}

end.
