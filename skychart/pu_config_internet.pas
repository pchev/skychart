unit pu_config_internet;

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

interface

uses u_help, u_translation, u_constant, u_util, fu_config_internet, UScaleDPI,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, Buttons, Spin, ExtCtrls, enhedits, ComCtrls, LResources,
  ButtonPanel, Grids, LazHelpHTML;

type

  { Tf_config_internet }

  { Tf_configinternet }

  Tf_configinternet = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button6: TButton;
    f_config_internet1: Tf_config_internet;
    Panel1: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
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

procedure Tf_configinternet.SetLang;
begin
Caption:=rsInternet;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button6.caption:=rsHelp;
SetHelp(self,hlpCfgInt);
end;

procedure Tf_configinternet.FormShow(Sender: TObject);
begin
  f_config_internet1.init;
end;

procedure Tf_configinternet.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  f_config_internet1.lock;
end;

procedure Tf_configinternet.Button2Click(Sender: TObject);
begin
 if assigned(f_config_internet1.onApplyConfig) then f_config_internet1.onApplyConfig(f_config_internet1);
end;

procedure Tf_configinternet.Button6Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_configinternet.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self,96);
  SetLang;
end;


end.
