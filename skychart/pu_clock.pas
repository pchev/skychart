unit pu_clock;

{$mode objfpc}{$H+}

interface

uses  u_constant, u_util, u_translation, u_projection, cu_planet, UScaleDPI,
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ColorBox;

type

  { Tf_clock }

  Tf_clock = class(TForm)
    clock2: TLabel;
    clock3: TLabel;
    clock4: TLabel;
    clock5: TLabel;
    clock6: TLabel;
    ColorBox1: TColorBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    clock1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure ColorBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormShow(Sender: TObject);
    procedure Panel1MouseEnter(Sender: TObject);
    procedure Panel1MouseLeave(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    startpoint: TPoint;
    moving, lockmove: boolean;
    Fplanet: Tplanet;
  public
    { public declarations }
    cfgsc: Tconf_skychart;
    procedure SetLang;
    procedure UpdateClock;
    property planet: Tplanet read Fplanet write Fplanet;
  end;

var
  f_clock: Tf_clock;

implementation

{$R *.lfm}

{ Tf_clock }

procedure Tf_clock.UpdateClock;
var
  y, m, d: word;
  n: TDateTime;
  t, tz, jd0, jdt, st, ra, Dec, dist, diam: double;
begin
  n := cfgsc.tz.NowLocalTime;
  decodedate(n, y, m, d);
  t := frac(n) * 24;
  tz := cfgsc.tz.SecondsOffset / 3600;
  jd0 := jd(y, m, d, 0);
  st := Sidtim(jd0, t - tz, cfgsc.ObsLongitude) * rad2deg / 15;
  jdt := jd(y, m, d, t - tz);
  Fplanet.sun(jdt, ra, Dec, dist, diam);
  precession(jd2000, jdt, ra, Dec);
  ra := ra * rad2deg / 15;
  clock1.Caption := TimToStr(rmod(t + 24, 24)) + blank + TzGMT2UTC(cfgsc.tz.ZoneName);
  clock2.Caption := TimToStr(rmod(t - tz + 24, 24));
  clock3.Caption := TimToStr(rmod(t - tz - (cfgsc.ObsLongitude / 15) + 24, 24));
  clock4.Caption := TimToStr(rmod(st - ra + 24 + 12, 24));
  clock5.Caption := TimToStr(rmod(st + 24, 24));
  clock6.Caption := formatfloat(f5, jdt);
end;

procedure Tf_clock.SetLang;
begin
  Label1.Caption := rsLegal + ':';
  Label2.Caption := rsUT + ':';
  Label3.Caption := rsMeanLocal + ':';
  Label4.Caption := rsTrueSolar + ':';
  Label5.Caption := rsSideral + ':';
  label6.Caption := rsJD2 + ':';
end;

procedure Tf_clock.FormCreate(Sender: TObject);
begin
  {$ifdef darwin}
  FormStyle := fsNormal;
  {$endif}
  {$ifdef lclgtk2}
  FormStyle := fsNormal;
  {$endif}
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_clock.ColorBox1Change(Sender: TObject);
begin
  Font.Color := ColorBox1.Selected;
  ColorBox1.Font.Color := ColorBox1.Selected;
  ColorBox1.Visible := False;
end;

procedure Tf_clock.FormDblClick(Sender: TObject);
begin
  moving := False;
  Hide;
end;

procedure Tf_clock.FormDestroy(Sender: TObject);
begin
  try
  if (cfgsc <> nil) then
    cfgsc.Free;
  if (planet <> nil) then
    planet.Free;
  except
  end;
end;

procedure Tf_clock.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  startpoint := TControl(Sender).clienttoscreen(point(X, Y));
  moving := True;
  lockmove := False;
end;

procedure Tf_clock.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  P: Tpoint;
begin
  if moving and (not lockmove) then
  begin
    lockmove := True;
    P := clienttoscreen(Point(X, Y));
    top := top + P.Y - startpoint.Y;
    if top < 0 then
      top := 0;
    if top > (screen.Height - Height) then
      top := screen.Height - Height;
    left := left + P.X - startpoint.X;
    if left < 0 then
      left := 0;
    if left > (screen.Width - Width) then
      left := screen.Width - Width;
    startpoint := P;
    application.ProcessMessages;
    lockmove := False;
  end;
end;

procedure Tf_clock.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  moving := False;
end;

procedure Tf_clock.FormShow(Sender: TObject);
begin
  ColorBox1.Selected := Font.Color;
  UpdateClock;
  Timer1.Enabled := True;
end;

procedure Tf_clock.Panel1MouseEnter(Sender: TObject);
begin
  ColorBox1.Visible := True;
end;

procedure Tf_clock.Panel1MouseLeave(Sender: TObject);
begin
  ColorBox1.Visible := False;
end;

procedure Tf_clock.FormHide(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure Tf_clock.Timer1Timer(Sender: TObject);
begin
  UpdateClock;
end;

end.
