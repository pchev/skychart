unit pu_config_solsys;

{$MODE Delphi}{$H+}

{
Copyright (C) 2005 Patrick Chevalley

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

interface

uses u_help, u_translation, u_constant, u_util, u_projection, cu_database,
  fu_config_solsys, LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, enhedits, StdCtrls, Buttons, ExtCtrls, ComCtrls, LResources,
  downloaddialog, jdcalendar, EditBtn, Process, LazHelpHTML, FileUtil;

type

  { Tf_configsolsys }

  Tf_configsolsys = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    f_config_solsys1: Tf_config_solsys;
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

procedure Tf_configsolsys.SetLang;
begin
Caption:=rsSolarSystem;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button4.caption:=rsHelp;
SetHelp(self,hlpCfgSol);
end;

procedure Tf_configsolsys.FormShow(Sender: TObject);
begin
  f_config_solsys1.init;
end;

procedure Tf_configsolsys.FormCreate(Sender: TObject);
begin
SetLang;
end;

procedure Tf_configsolsys.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  f_config_solsys1.lock;
end;

procedure Tf_configsolsys.Button2Click(Sender: TObject);
begin
 if assigned(f_config_solsys1.onApplyConfig) then f_config_solsys1.onApplyConfig(f_config_solsys1);
end;

procedure Tf_configsolsys.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;

end.
