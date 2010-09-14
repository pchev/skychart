unit pu_zoom;

{$MODE Delphi}{$H+}

{
Copyright (C) 2005 Patrick Chevalley

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
{
 Set the FOV using a log cursor.
}

interface

uses u_help, u_translation, u_util, u_constant,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, LResources, Math, LazHelpHTML;

type

  { Tf_zoom }

  Tf_zoom = class(TForm)
    Button1: TButton;
    TrackBar1: TTrackBar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    Fnightvision:boolean;
  public
    { Déclarations publiques }
    fov,logfov : double;
    procedure SetLang;
  end;

var
  f_zoom: Tf_zoom;

implementation

procedure Tf_zoom.SetLang;
begin
Caption:=rsSetFOV;
BitBtn1.caption:=rsOK;
BitBtn2.caption:=rsCancel;
Button1.caption:=rsHelp;
SetHelp(self,hlpSetFov);
end;

procedure Tf_zoom.TrackBar1Change(Sender: TObject);
begin
logfov:=TrackBar1.Position;
fov:=power(10,logfov/100);
fov:=min(360,fov);
if fov>3 then fov:=round(fov);
Edit1.text:=DeMtoStr(fov);
end;

procedure Tf_zoom.FormCreate(Sender: TObject);
begin
SetLang;
  Fnightvision:=false;
end;

procedure Tf_zoom.Button1Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_zoom.FormShow(Sender: TObject);
begin
{$ifdef mswindows}
if Fnightvision<>nightvision then begin
   SetFormNightVision(self,nightvision);
   Fnightvision:=nightvision;
end;
{$endif}
logfov:=100*log10(fov);
TrackBar1.Position := Round(logfov);
Edit1.text:=DeMtoStr(fov);
TrackBar1.SetTick(-78);
TrackBar1.SetTick(0);
TrackBar1.SetTick(100);
TrackBar1.SetTick(200);
end;

initialization
  {$i pu_zoom.lrs}

end.
