unit pu_config_system;

{$MODE Delphi}{$H+}

{
Copyright (C) 2005 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

interface

uses u_help, u_translation, u_constant, u_util, cu_database, fu_config_system,
  Dialogs, Controls, Buttons, enhedits, ComCtrls, Classes,
  LCLIntf, SysUtils, Graphics, Forms, FileUtil, UScaleDPI,
  ExtCtrls, StdCtrls, LResources, EditBtn, LazHelpHTML;

type

  { Tf_configsystem }

  Tf_configsystem = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    f_config_system1: Tf_config_system;
    Panel1: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang;
  end;

implementation
{$R *.lfm}

procedure Tf_configsystem.SetLang;
begin
Caption:=rsGeneral;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button4.caption:=rsHelp;
SetHelp(self,hlpCfgSys);
end;

procedure Tf_configsystem.FormShow(Sender: TObject);
begin
  f_config_system1.init;
end;


procedure Tf_configsystem.FormCreate(Sender: TObject);
begin
ScaleDPI(Self);
SetLang;
end;

procedure Tf_configsystem.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  f_config_system1.lock;
end;

procedure Tf_configsystem.Button2Click(Sender: TObject);
begin
if assigned(f_config_system1.onApplyConfig) then f_config_system1.onApplyConfig(f_config_system1);
end;

procedure Tf_configsystem.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;

end.

