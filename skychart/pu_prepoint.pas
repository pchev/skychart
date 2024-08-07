unit pu_prepoint;

{$mode objfpc}{$H+}
{
Copyright (C) 2020 Patrick Chevalley

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

uses u_translation,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, EditBtn, ComCtrls, ExtCtrls;

type

  { Tf_prepoint }

  Tf_prepoint = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    msg: TLabel;
    ObjLabel: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TimeObsS: TSpinEdit;
    TimeObsM: TSpinEdit;
    TimeObsH: TSpinEdit;
    TimeLength: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FRecenter,FRecenterNow: TNotifyEvent;
  public
    procedure SetLang;
    property onRecenter: TNotifyEvent read FRecenter write FRecenter;
    property onRecenterNow: TNotifyEvent read FRecenterNow write FRecenterNow;
  end;

var
  f_prepoint: Tf_prepoint;

implementation

{$R *.lfm}

procedure Tf_prepoint.FormCreate(Sender: TObject);
begin
  SetLang;
end;

procedure Tf_prepoint.Button3Click(Sender: TObject);
begin
  if Assigned(FRecenter) then FRecenter(self);
end;

procedure Tf_prepoint.Button4Click(Sender: TObject);
begin
  if Assigned(FRecenterNow) then FRecenterNow(self);
end;

procedure Tf_prepoint.SetLang;
begin
  Caption := rsPrePointing;
  label1.Caption := rsObservationT;
  label2.Caption := rsPrePointLine;
  button1.Caption:=rsOK;
  button2.Caption:=rsCancel;
end;

end.

