unit splashunit;

{$MODE Delphi}

{
Copyright (C) 2008 Patrick Chevalley

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

interface

uses
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, LResources, u_param;

type

  { Tsplash }

  Tsplash = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    BitBtn1: TBitBtn;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    SplashTimer: Boolean;
  end;

var
  splash: Tsplash;

implementation


procedure Tsplash.Timer1Timer(Sender: TObject);
begin
  Timer1.enabled:=false;
  splash.free;
end;

procedure Tsplash.FormShow(Sender: TObject);
begin
  if SplashTimer then Timer1.enabled:=true;
end;


procedure Tsplash.Image1Click(Sender: TObject);
begin
modalresult:=mrCancel;
end;

initialization
  {$i splashunit.lrs}

end.
