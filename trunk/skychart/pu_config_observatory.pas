unit pu_config_observatory;

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

uses
  u_unzip, u_help, u_translation, u_constant, u_util, cu_database, UScaleDPI,
  fu_config_observatory, Math, dynlibs, LCLIntf, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, FileUtil, Buttons, StdCtrls, ExtCtrls, cu_zoomimage,
  enhedits, ComCtrls, LResources, Spin, downloaddialog, CdC_EditBtn, LazHelpHTML;

type

  { Tf_configobservatory }

  Tf_configobservatory = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    f_config_observatory1: Tf_config_observatory;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
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

procedure Tf_configobservatory.SetLang;
begin
Caption:=rsObservatory;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button4.caption:=rsHelp;
SetHelp(self,hlpCfgObs);
end;

procedure Tf_configobservatory.FormCreate(Sender: TObject);
begin
ScaleDPI(Self,96);
SetLang;
end;

procedure Tf_configobservatory.FormShow(Sender: TObject);
begin
  f_config_observatory1.init;
end;

procedure Tf_configobservatory.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  f_config_observatory1.lock;
end;

procedure Tf_configobservatory.Button2Click(Sender: TObject);
begin
f_config_observatory1.Button6Click(nil);
if assigned(f_config_observatory1.onApplyConfig) then f_config_observatory1.onApplyConfig(f_config_observatory1);
end;

procedure Tf_configobservatory.Button1Click(Sender: TObject);
begin
f_config_observatory1.Button6Click(nil);
end;

procedure Tf_configobservatory.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;


end.
