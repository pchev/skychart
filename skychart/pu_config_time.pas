unit pu_config_time;

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

uses u_help, u_translation, u_constant, u_util, u_projection, cu_tz, UScaleDPI,
  fu_config_time, fu_chart, LCLIntf, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Math, StdCtrls, CheckLst, Buttons, ExtCtrls, Spin, enhedits,
  ComCtrls, LResources, ButtonPanel, jdcalendar, LazHelpHTML, EditBtn;

type

  { Tf_configtime }

  Tf_configtime = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button7: TButton;
    f_config_time1: Tf_config_time;
    Panel1: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
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

procedure Tf_configtime.SetLang;
begin
Caption:=rsDateTime;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button7.caption:=rsHelp;
SetHelp(self,hlpCfgDate);
end;

procedure Tf_configtime.Button2Click(Sender: TObject);
begin
  if assigned(f_config_time1.onApplyConfig) then f_config_time1.onApplyConfig(f_config_time1);
end;

procedure Tf_configtime.Button7Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_configtime.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  f_config_time1.Lock;
end;

procedure Tf_configtime.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self,96);
  SetLang;
end;

procedure Tf_configtime.FormShow(Sender: TObject);
begin
  f_config_time1.Init;
end;

end.
