unit pu_mosaic;

{$mode objfpc}{$H+}
{
Copyright (C) 2019 Patrick Chevalley

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

uses  u_constant, u_translation, UScaleDPI,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, ExtCtrls, cu_radec;

type

  { Tf_mosaic }

  Tf_mosaic = class(TForm)
    ButtonClear: TButton;
    ButtonSave: TButton;
    DEdown: TButton;
    DEup: TButton;
    MosaicName: TEdit;
    Label8: TLabel;
    Panel1: TPanel;
    RAright: TButton;
    ButtonClose: TButton;
    FrameList: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RAleft: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Ra: TRaDec;
    De: TRaDec;
    SizeX: TSpinEdit;
    SizeY: TSpinEdit;
    Hoverlap: TSpinEdit;
    ApplyTimer: TTimer;
    Voverlap: TSpinEdit;
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure DeChange(Sender: TObject);
    procedure DEdownClick(Sender: TObject);
    procedure MosaicChange(Sender: TObject);
    procedure RaChange(Sender: TObject);
    procedure RAleftClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FrameListChange(Sender: TObject);
    procedure DEupClick(Sender: TObject);
    procedure RArightClick(Sender: TObject);
    procedure ApplyTimerTimer(Sender: TObject);
  private
    FClearMosaic,FApplyMosaic,FSaveMosaic: TNotifyEvent;
    dra,dde: double;
    procedure Apply;
  public
    procedure SetLang;
    property onClearMosaic: TNotifyEvent read FClearMosaic write FClearMosaic;
    property onApplyMosaic: TNotifyEvent read FApplyMosaic write FApplyMosaic;
    property onSaveMosaic: TNotifyEvent read FSaveMosaic write FSaveMosaic;
  end;

var
  f_mosaic: Tf_mosaic;

implementation

{$R *.lfm}

{ Tf_mosaic }

procedure Tf_mosaic.SetLang;
begin
  Caption := rsMosaic;
  GroupBox1.Caption := rsMosaicCenter;
  Label1.Caption := rsRA;
  Label2.Caption := rsDEC;
  GroupBox2.Caption := rsMosaic;
  Label8.Caption := rsName;
  Label5.Caption := rsFinderRectan;
  Label3.Caption := rsMosaicSize;
  Label6.Caption := rsHorizontalOv;
  Label7.Caption := rsVerticalOver;
  ButtonClear.Caption := rsClear;
  ButtonSave.Caption := rsSave;
  ButtonClose.Caption := rsClose;
end;

procedure Tf_mosaic.FormCreate(Sender: TObject);
begin
  dde := 30 / 60;
  dra := dde / 15;
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_mosaic.FormShow(Sender: TObject);
begin
  FrameListChange(Sender);
  Apply;
end;
procedure Tf_mosaic.ButtonCloseClick(Sender: TObject);

begin
  ApplyTimer.Enabled := false;
  Close;
end;

procedure Tf_mosaic.ButtonClearClick(Sender: TObject);
begin
  if Assigned(FClearMosaic) then FClearMosaic(Self);
end;

procedure Tf_mosaic.ButtonSaveClick(Sender: TObject);
begin
  if Assigned(FSaveMosaic) then FSaveMosaic(Self);
end;

procedure Tf_mosaic.Apply;
begin
  ApplyTimer.Enabled := false;
  ApplyTimer.Enabled := true;
end;

procedure Tf_mosaic.ApplyTimerTimer(Sender: TObject);
begin
  ApplyTimer.Enabled := false;
  if Assigned(FApplyMosaic) then FApplyMosaic(Self);
end;

procedure Tf_mosaic.DeChange(Sender: TObject);
begin
  Apply;
end;

procedure Tf_mosaic.RaChange(Sender: TObject);
begin
  Apply;
end;

procedure Tf_mosaic.MosaicChange(Sender: TObject);
begin
  Apply
end;

procedure Tf_mosaic.DEupClick(Sender: TObject);
begin
  De.Value := De.Value + dde;
end;

procedure Tf_mosaic.DEdownClick(Sender: TObject);
begin
   De.Value := De.Value - dde;
end;

procedure Tf_mosaic.RArightClick(Sender: TObject);
begin
  Ra.Value := Ra.Value - dra;
end;

procedure Tf_mosaic.RAleftClick(Sender: TObject);
begin
  Ra.Value := Ra.Value + dra;
end;

procedure Tf_mosaic.FrameListChange(Sender: TObject);
var buf,s: string;
    p: integer;
    x,c: double;
begin
  // size is first part of text
  buf := FrameList.Text;
  p := pos(lmin,buf);
  if p<=0 then exit;
  s := copy(buf,1,p-1);
  x := StrToFloatDef(s,-1);
  if x<0 then exit;
  // dec offset in degree
  dde := x / 60 / 6;
  c := cos(deg2rad * De.Value);
  if c=0 then c:=0.00001;
  // ra offset in hour
  dra := dde / c / 15;
  Apply;
end;


end.

