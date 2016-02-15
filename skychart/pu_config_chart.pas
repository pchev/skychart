unit pu_config_chart;

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

uses u_help, u_translation, u_constant, u_projection, u_util, fu_config_chart,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, UScaleDPI,
  StdCtrls, ExtCtrls, enhedits, ComCtrls, LResources,
  Buttons, cu_zoomimage, LazHelpHTML;

type

  { Tf_config_chart }

  { Tf_configchart }

  Tf_configchart = class(TForm)
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    f_config_chart1: Tf_config_chart;
    Panel1: TPanel;
    procedure Button4Click(Sender: TObject);
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

procedure Tf_configchart.SetLang;
begin
Caption:=rsChartCoordin;
Button3.caption:=rsOK;
Button4.caption:=rsApply;
Button5.caption:=rsCancel;
Button6.caption:=rsHelp;
SetHelp(self,hlpCfgChart);
end;

procedure Tf_configchart.FormShow(Sender: TObject);
begin
  f_config_chart1.init;
end;

procedure Tf_configchart.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  f_config_chart1.lock;
end;

procedure Tf_configchart.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_configchart.Button4Click(Sender: TObject);
begin
 if assigned(f_config_chart1.onApplyConfig) then f_config_chart1.onApplyConfig(f_config_chart1);
end;

procedure Tf_configchart.Button6Click(Sender: TObject);
begin
  ShowHelp;
end;

end.
