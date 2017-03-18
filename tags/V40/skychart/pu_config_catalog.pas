unit pu_config_catalog;

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

uses  XMLConf, u_help, u_translation, u_constant, u_util, cu_catalog, pu_catgen,
  pu_catgenadv, pu_progressbar, FileUtil, pu_voconfig, fu_config_catalog, math,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, UScaleDPI,
  ExtCtrls, StdCtrls, enhedits, Grids, Buttons, ComCtrls, LResources,
  EditBtn, LazHelpHTML;

type

  { Tf_configcatalog }

  Tf_configcatalog = class(TForm)
    Button4: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    f_config_catalog1: Tf_config_catalog;
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

procedure Tf_configcatalog.SetLang;
begin
Caption:=rsCatalog;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button4.caption:=rsHelp;
SetHelp(self,hlpCatalog);
end;

procedure Tf_configcatalog.FormShow(Sender: TObject);
begin
  f_config_catalog1.init
end;

procedure Tf_configcatalog.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_configcatalog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  f_config_catalog1.lock;
end;

procedure Tf_configcatalog.Button2Click(Sender: TObject);
begin
 if assigned(f_config_catalog1.onApplyConfig) then f_config_catalog1.onApplyConfig(f_config_catalog1);
end;

procedure Tf_configcatalog.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;

end.
