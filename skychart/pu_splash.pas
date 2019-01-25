unit pu_splash;

{$MODE Delphi}{$H+}

{
Copyright (C) 2002 Patrick Chevalley

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
{
 startup splash screen
}

interface

uses
  u_translation, u_constant, u_util, UScaleDPI,
  LCLIntf, Classes, Graphics, Forms, Controls, StdCtrls,
  sysutils, ExtCtrls, LResources, Buttons;

type

  { Tf_splash }

  Tf_splash = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelDate: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure logoDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang;
  end;

var
  f_splash: Tf_splash;

implementation

{$R *.lfm}

procedure Tf_splash.SetLang;
begin
  Caption := rsAbout;
  if rsSkyCharts = 'Cartes du Ciel' then
    Label1.Caption := ''
  else
    Label1.Caption := rsSkyCharts;
  Label3.Caption := format(cdccpy,[cpydate]);
  Label4.Caption := rsThisProgramI;
end;

procedure Tf_splash.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  label2.Caption := rsVersion + blank + cdcversion;
  if cdcbeta then
  begin
    label2.Caption := label2.Caption +blank+'beta-'+ RevisionStr;
    LabelDate.Caption := compile_time;
    LabelDate.Visible := True;
  end
  else
    LabelDate.Visible := False;
  SetLang;
end;

procedure Tf_splash.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure Tf_splash.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Close;
end;

procedure Tf_splash.logoDblClick(Sender: TObject);
begin
  Timer1Timer(Sender);
end;

procedure Tf_splash.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  logoDblClick(Sender);
end;

end.
 
