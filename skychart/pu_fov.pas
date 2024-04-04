unit pu_fov;

{$mode objfpc}{$H+}

interface

uses u_translation, UScaleDPI,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls;

type

  { Tf_fov }

  Tf_fov = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button6: TButton;
    Button9: TButton;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label8: TLabel;
    PageControl1: TPageControl;
    Eyepiece: TTabSheet;
    Camera: TTabSheet;
    procedure Button6Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure SetLang;
  end;

implementation

const
  f2 = '0.00';
  rad2deg = 180 / pi;

{$R *.lfm}

{ Tf_fov }

procedure Tf_fov.SetLang;
begin
  Caption := rsFieldOfVisio;
  Button1.Caption := rsOK;
  Button2.Caption := rsOK;
  Button6.Caption := rsCompute;
  Button9.Caption := rsCompute;
  label1.Caption := rsFOV;
  Label24.Caption := rsTelescopeFoc;
  Label25.Caption := rsEyepieceFoca;
  Label26.Caption := rsEyepieceAppa;
  Label28.Caption := rsPower;
  Label49.Caption := rsTelescopeFoc;
  Label50.Caption := rsPixelSize;
  Label53.Caption := rsPixelCount;
end;

procedure Tf_fov.Button6Click(Sender: TObject);
begin
  edit10.Text := IntToStr(round((strtofloat(edit6.Text) / strtofloat(edit7.Text))));
  edit9.Text := IntToStr(round(60 * strtofloat(edit8.Text) /
    (strtofloat(edit6.Text) / strtofloat(edit7.Text))));
end;

procedure Tf_fov.Button9Click(Sender: TObject);
var
  f, px, py, cx, cy: single;
begin
  f := strtofloat(edit11.Text);
  px := strtofloat(edit12.Text) / 1000;
  py := strtofloat(edit13.Text) / 1000;
  cx := strtofloat(edit15.Text);
  cy := strtofloat(edit16.Text);
  Edit14.Text := FormatFloat(f2, arctan(px / f) * cx * rad2deg * 60);
  Edit17.Text := FormatFloat(f2, arctan(py / f) * cy * rad2deg * 60);
end;

procedure Tf_fov.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
end;

end.
