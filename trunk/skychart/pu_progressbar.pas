unit pu_progressbar;
{
Copyright (C) 2006 Patrick Chevalley

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

{$MODE objfpc}{$H+}

interface

uses u_translation, UScaleDPI,
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, LResources;

type

  { Tf_progress }

  Tf_progress = class(TForm)
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Déclarations privées }
    Fabort: TNotifyEvent;
  public
    { Déclarations publiques }
    procedure SetLang;
    property onAbortClick: TNotifyEvent read Fabort write Fabort;
  end;

implementation
{$R *.lfm}

procedure Tf_progress.SetLang;
begin
Caption:=rsProgress;
SpeedButton2.caption:=rsAbort;
end;

procedure Tf_progress.SpeedButton2Click(Sender: TObject);
begin
if assigned(Fabort) then Fabort(self);
end;

procedure Tf_progress.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self,96);
  SetLang;
end;

end.
