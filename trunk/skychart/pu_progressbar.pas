unit pu_progressbar;
{
Copyright (C) 2006 Patrick Chevalley

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

{$MODE objfpc}{$H+}

interface

uses u_translation,
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
  SetLang;
end;

initialization
  {$i pu_progressbar.lrs}


end.
