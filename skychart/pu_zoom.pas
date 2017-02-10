unit pu_zoom;

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
{
 Set the FOV using a log cursor.
}

interface

uses u_help, u_translation, u_util, u_constant, cu_radec, UScaleDPI,
  LCLIntf, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, LResources, Math, LazHelpHTML;

type

  { Tf_zoom }

  Tf_zoom = class(TForm)
    BitBtn3: TBitBtn;
    Button1: TButton;
    RaDec1: TRaDec;
    TrackBar1: TTrackBar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure BitBtn3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RaDec1Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    FApply: TNotifyEvent;
    LockFov:boolean;
    procedure Setfov(value:double);
  public
    { Déclarations publiques }
    fov,logfov : double;
    procedure SetLang;
    property onApply : TNotifyEvent read FApply write FApply;
  end;

var
  f_zoom: Tf_zoom;

implementation
{$R *.lfm}

procedure Tf_zoom.SetLang;
begin
Caption:=rsSetFOV;
BitBtn1.caption:=rsOK;
BitBtn2.caption:=rsCancel;
Button1.caption:=rsHelp;
SetHelp(self,hlpSetFov);
end;

procedure Tf_zoom.Setfov(value:double);
begin
fov:=value;
logfov:=100*log10(fov);
LockFov:=true;
TrackBar1.Position := Round(logfov);
LockFov:=false;
end;

procedure Tf_zoom.TrackBar1Change(Sender: TObject);
begin
  if LockFov then exit;
  LockFov:=true;
  logfov:=TrackBar1.Position;
  fov:=power(10,logfov/100);
  fov:=min(360,fov);
  if fov>3 then fov:=round(fov);
  RaDec1.value:=fov;
  LockFov:=false;
end;

procedure Tf_zoom.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
  LockFov:=false;
end;

procedure Tf_zoom.RaDec1Change(Sender: TObject);
begin
  if LockFov then exit;
  LockFov:=true;
  Setfov(RaDec1.value);
  LockFov:=false;
end;

procedure Tf_zoom.Button1Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_zoom.BitBtn3Click(Sender: TObject);
begin
  if assigned(FApply) then FApply(self);
end;

procedure Tf_zoom.FormShow(Sender: TObject);
begin
setfov(fov);
RaDec1.value:=fov;
TrackBar1.SetTick(-78);
TrackBar1.SetTick(0);
TrackBar1.SetTick(100);
TrackBar1.SetTick(200);
end;

end.
