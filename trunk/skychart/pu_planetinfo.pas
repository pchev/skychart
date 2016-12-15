unit pu_planetinfo;
{
Copyright (C) 2016 Patrick Chevalley

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

{$mode objfpc}{$H+}

interface

uses u_constant, u_translation, Math, u_util, cu_planet, u_projection, process,
  BGRABitmap, BGRABitmapTypes, Classes, SysUtils, FileUtil, Forms, Controls,
  UScaleDPI, Types, Graphics, Dialogs, ComCtrls, ExtCtrls, Buttons, StdCtrls,
  ActnList, LCLType, u_Orbits;

type

  { Tf_planetinfo }

  Tf_planetinfo = class(TForm)
    acPlanetsVisibility: TAction;
    acSim1: TAction;
    acSim2: TAction;
    acMars: TAction;
    acMoon: TAction;
    acMercury: TAction;
    acEarth: TAction;
    acSun: TAction;
    acFreePlanetView: TAction;
    acVenus: TAction;
    acJupiter: TAction;
    acSaturn: TAction;
    acUranus: TAction;
    acNeptune: TAction;
    acPluto: TAction;
    ActionList1: TActionList;
    cbRectangular: TCheckBox;
    cbIcons: TCheckBox;
    cbLabels: TCheckBox;
    cbChartSync: TCheckBox;
    cbDistance: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Image1: TImage;
    Label1: TLabel;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PanelMain: TPanel;
    PanelLeft: TPanel;
    PanelrgTarget: TPanel;
    PanelrgOrigin: TPanel;
    PanelTop: TPanel;
    rgOrigin: TRadioGroup;
    rgTarget: TRadioGroup;
    MainTimer: TTimer;
    tbtnEarth: TToolButton;
    tbtnSun: TToolButton;
    NAVTimer: TTimer;
    ToolButton1: TToolButton;
    txtFOV: TStaticText;
    txtNext: TStaticText;
    txtJDdx: TStaticText;
    txtPrev: TStaticText;
    CheckBox1: TCheckBox;
    ImageList1: TImageList;
    tbPlanets: TToolBar;
    tbtnPlanetVisibility: TToolButton;
    tbtnSim1: TToolButton;
    tbtnSim2: TToolButton;
    tbtnMars: TToolButton;
    tbtnMercury: TToolButton;
    tbtnVenus: TToolButton;
    tbtnJupiter: TToolButton;
    tbtnSaturn: TToolButton;
    tbtnUranus: TToolButton;
    ToolButton8: TToolButton;
    tbtnPluto: TToolButton;
    procedure acEarthExecute(Sender: TObject);
    procedure acFreePlanetViewExecute(Sender: TObject);
    procedure acMarsExecute(Sender: TObject);
    procedure acPlutoExecute(Sender: TObject);
    procedure acSim1Execute(Sender: TObject);
    procedure acSim2Execute(Sender: TObject);
    procedure acPlanetsVisibilityExecute(Sender: TObject);
    procedure acMercuryExecute(Sender: TObject);
    procedure acSunExecute(Sender: TObject);
    procedure acVenusExecute(Sender: TObject);
    procedure acJupiterExecute(Sender: TObject);
    procedure acSaturnExecute(Sender: TObject);
    procedure acUranusExecute(Sender: TObject);
    procedure acNeptuneExecute(Sender: TObject);
    procedure cbChartSyncChange(Sender: TObject);
    procedure cbDistanceChange(Sender: TObject);
    procedure cbIconsChange(Sender: TObject);
    procedure cbLabelsChange(Sender: TObject);
    procedure cbRectangularChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Label1Click(Sender: TObject);
    procedure PaintBox2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure PaintboxMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Image1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox2Click(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject);
    procedure rgOriginClick(Sender: TObject);
    procedure rgTargetClick(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
    procedure NAVTimerTimer(Sender: TObject);
    procedure txtJDdxDecClick(Sender: TObject);
    procedure txtNextClick(Sender: TObject);
    procedure txtPrevClick(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { private declarations }

    firstuse : Boolean;

    EnableEvents: Boolean;

    ElapsedTime: cardinal;

    dxJD: Double;
    TimeIndex : integer;

    IsProcessingPlanets : Boolean;

    FOV : Double;
    xmin,xmax,ymin,ymax: integer;
    Initialized, ActiveNoon: boolean;
    ActiveDate, ActiveSizeX,ActiveSizeY: integer;
    TextZoom: single;
    zoomlock: boolean;

    NAV_Current: integer;
    NAV_On: boolean;

    NAV_Bits: TBits;

    NAV_Hint_Index: Integer;
    NAV_isPainting : Boolean;

    CurJDTT_OLD : double;

    Orbit: TOrbits;

    NAV_Orig: TBGRABitmap;
    NAV_Image: TBGRABitmap;
    NAV_Disabled: TBGRABitmap;

    procedure SetDefaultFOV;
    procedure SetView(AViewIndex, AMoonIndex: integer);

    procedure Rescale_Internal;
    procedure NAV_Coloring(col: TColor; bmp:TBGRABitmap);
    procedure NAV_Disable(bmp:TBGRABitmap);

    procedure NAV_TurnON;
    procedure NAV_TurnOFF;

    procedure rgTargetAsync(Data: PtrInt);

  public
    { public declarations }

    FPlanet : Tplanet;

    Planet_Origin       : integer;
    Planet_Origin_Index : integer;

    Planet_Target       : integer;
    Planet_Target_Index : integer;

    View_Index    : integer;

    config: Tconf_skychart;
    plbmp: TBGRABitmap;
    CenterAtNoon, ShowCurrentObject: boolean;
    ActivePage: integer;

    //Pointer to linked chart to sync data
    LinkedChartData: Tconf_skychart;

    ChartSync: Boolean;

    Procedure SetLang;
    Procedure RefreshInfo;
    procedure SetRadioButtons;
    procedure PlotLine(bmp:TBGRABitmap; lbl:string; y:integer; des,h1,h2,ht:double);
    Procedure PlotTwilight(bmp:TBGRABitmap);
    Procedure PlotPlanet(bmp:TBGRABitmap);
    Procedure PlotSelection(bmp:TBGRABitmap);
    Procedure PlotFrame(bmp:TBGRABitmap);
    procedure PlotPlanetImage(bmp:TBGRABitmap; ATarget, AOrigin : integer);
    Procedure PlotHeader(bmp:TBGRABitmap; title:string; showobs,showtime: boolean);
    property planet: Tplanet read Fplanet write Fplanet;

    // Inc/Dec and get string for navigation speed
    procedure SetTimeSpeed(ATimeIndex: integer);
    procedure IncTimeSpeed;
    procedure DecTimeSpeed;
    function GetTimeSpeed_Str: string;

  end;

var
  f_planetinfo: Tf_planetinfo;

type
  TFOV = array[C_Mercury..C_Callisto] of double;

const
  marginleft   = 80;
  marginright  = 80;
  margintop    = 80;
  marginbottom = 20;


  CFOV_FromEarth: TFov =
   (
   0.002727, // Mercury
   0.006000, // Venus
   0.232000, // Earth
   0.004900, // Mars
   0.023000, // Jupiter
   0.011288, // Saturn
   0.001818, // Uranus
   0.001182, // Neptune
   0.000050, // Pluto
   1.500,    // Sun
   1.100000, // Moon
   0.000636, // Io
   0.000546, // Europe
   0.000900, // Ganymed
   0.000818  // Callisto

   );

   CFOV_FromSun: TFov =
    (
    0.007972, // Mercury
    0.012723, // Venus
    0.010000, // Earth
    0.003039, // Mars
    0.019008, // Jupiter
    0.011270, // Saturn
    0.002000, // Uranus
    0.001182, // Neptune
    0.000054, // Pluto
    1.500,    // Sun
    0.002722, // Moon
    0.000478, // Io
    0.000410, // Europe
    0.000744, // Ganymed
    0.000676  // Callisto

    );

   CFOV_FromPlanet: TFov =
    (
    0.220000, // Mercury
    0.220000, // Venus
    0.220000, // Earth
    0.220000, // Mars
    0.200000, // Jupiter
    0.200000, // Saturn
    0.220000, // Uranus
    0.220000, // Neptune
    0.220000, // Pluto
    0.220000, // Sun
    1.100000, // Moon
    1.000000, // Io
    0.500000, // Europe
    0.500000, // Ganymed
    0.300000  // Callisto

    );

   C_OneSec   = 1.0/86400;
   C_OneMin   = 1.0/1440;
   C_OneHour  = 1.0/24;
   C_OneDay   = 1.0;
   C_OneMonth = 31;
   C_OneYear  = 365.256;

   // Revolution of planets
   CRevolution: array [C_Mercury..C_Callisto] of double =
    (
    87.969,              // Mercury
    224.701,             // Venus
    C_OneYear,           // Earth
    686.98,              // Mars
    C_OneYear * 11.862,  // Jupiter
    C_OneYear * 29.457,  // Saturn
    C_OneYear * 84.011,  // Uranus
    C_OneYear * 164.79,  // Neptune
    C_OneYear * 247.68 , // Pluto
    0, // Sun
    0, // Moon
    0, // Io
    0, // Europe
    0, // Ganymed
    0  // Callisto

    );

var
   VTimeSpeed : array of double;

const

    View_PlanetVisibility = 0;

    View_Sun     = 1;
    View_Mercury = 2;
    View_Venus   = 3;
    View_Earth   = 4;
    View_Mars    = 5;
    View_Jupiter = 6;
    View_Saturn  = 7;
    View_Uranus  = 8;
    View_Neptune = 9;
    View_Pluto   = 10;
    View_Sim1    = 11;
    View_Sim2    = 12;
    View_FreePlanet = 13;

var
  CFOV: TFov;

const

  NAV_ResetTime    = 0;
  NAV_StepPrev     = 1;
  NAV_StepForward  = 2;
  NAV_PlayPrev     = 3;
  NAV_Play         = 4;
  NAV_DecTimeSpeed = 5;
  NAV_IncTimeSpeed = 6;
  NAV_ChartSync    = 7;

  NAV_btnLen = 24;

implementation

{$R *.lfm}

{ Tf_planetinfo }

procedure Tf_planetinfo.SetTimeSpeed(ATimeIndex: integer);
begin

  TimeIndex := ATimeIndex;

  if TimeIndex < low(VTimeSpeed) then
    TimeIndex := low(VTimeSpeed);

  if TimeIndex > high(VTimeSpeed) then
    TimeIndex := high(VTimeSpeed);

  dxJD := VTimeSpeed[TimeIndex]

end;

procedure Tf_planetinfo.IncTimeSpeed;
begin

  if TimeIndex+1 <= high(VTimeSpeed) then
    inc(TimeIndex);

  if TimeIndex = 0 then
    inc(TimeIndex);

  SetTimeSpeed(TimeIndex);

end;

procedure Tf_planetinfo.DecTimeSpeed;
begin

  if TimeIndex-1 >= low(VTimeSpeed) then
    dec(TimeIndex);

  SetTimeSpeed(TimeIndex);

end;

function Tf_planetinfo.GetTimeSpeed_Str: string;
var
  idx: integer;
  d: double;
  c: integer;
begin

  Result := '';

  idx := TimeIndex;

  try

    d := VTimeSpeed[idx];

    if d = CRevolution[C_Mercury] then Result := rsMercury else
    if d = CRevolution[C_Venus]   then Result := rsVenus   else
    if d = CRevolution[C_Mars ]   then Result := rsMars    else
    if d = CRevolution[C_Jupiter] then Result := rsJupiter else
    if d = CRevolution[C_Saturn]  then Result := rsSaturn  else
    if d = CRevolution[C_Uranus]  then Result := rsUranus  else
    if d = CRevolution[C_Neptune] then Result := rsNeptune else
    if d = CRevolution[C_Pluto]   then Result := rsPluto   else

    begin

      c := round (d / C_OneYear);
      if c > 0 then
      begin

        result := result + IntToStr(round(c)) + ' ';

        if c=1 then
          result := result + LowerCase(rsYear)
        else
          result := result + LowerCase(rsYears);

        exit;
      end;

      c := round (d / C_OneMonth);
      if c > 0 then
      begin
        result := result + IntToStr(round(c)) + ' ';

        // there is no plural for months
        result := result + LowerCase(rsMonth);

        exit;
      end;

      c := round (d / C_OneDay);
      if c > 0 then
      begin

        result := result + IntToStr(round(c)) + ' ';

        if c=1 then
          result := result + LowerCase(rsDay)
        else
          result := result + LowerCase(rsDays);

        exit;
      end;

      c := round (d / C_OneHour);
      if c > 0 then
      begin

        result := result + IntToStr(round(c)) + ' ';

        if c=1 then
          result := result + LowerCase(rsHour)
        else
          result := result + LowerCase(rsHours);

        exit;
      end;

      c := round (d / C_OneMin);
      if c > 0 then
      begin

        result := result + IntToStr(round(c)) + ' ';

        if c=1 then
          result := result + LowerCase(rsMinute)
        else
          result := result + LowerCase(rsMinutes);

        exit;
      end;

      result := result + IntToStr(round(c)) + ' ';

    end;

  finally
  end;

end;

procedure Tf_planetinfo.SetLang;
begin
  caption:=rsSolarSystemI;
  txtNext.caption:=rsNext;
  txtPrev.caption:=rsPrev;

  Label1.Caption:=rsStartGraphAt;
  cbIcons.Caption:=rsIcons;
  cbLabels.Caption:=rsLabels;
  cbDistance.Caption:=rsDistance;
  cbChartSync.Caption:=rsChartSync;
  cbRectangular.Caption:=rsRectangular;

  acPlanetsVisibility.Hint:=rsPlanetVisibi;
  acSun.Hint     := GetPlanetNameLang(C_Sun);
  acMoon.Hint    := GetPlanetNameLang(C_Moon);
  acMercury.Hint := GetPlanetNameLang(C_Mercury);
  acVenus.Hint   := GetPlanetNameLang(C_Venus);
  acEarth.Hint   := GetPlanetNameLang(C_Earth);
  acMars.Hint    := GetPlanetNameLang(C_Mars);
  acJupiter.Hint := GetPlanetNameLang(C_Jupiter);
  acSaturn.Hint  := GetPlanetNameLang(C_Saturn);
  acUranus.Hint  := GetPlanetNameLang(C_Uranus);
  acNeptune.Hint := GetPlanetNameLang(C_Neptune);
  acPluto.Hint   := GetPlanetNameLang(C_Pluto);

  acSim1.Hint     := rsInnerSolarSy;
  acSim2.Hint     := rsOuterSolarSy;

  txtJDdx.Caption := GetTimeSpeed_Str;

  rgTarget.Caption:=rsLookAt;
  rgOrigin.Caption:=rsFrom+':';
  rgOrigin.Items[0] := rsEarth;
  rgOrigin.Items[1] := rsSun;
  rgOrigin.Items[2] := rsPlanet;

  FormResize(self);
end;

procedure Tf_planetinfo.NAV_Coloring(col: TColor; bmp:TBGRABitmap);
var
  x, y : integer;
  coln,black:TBGRAPixel;
  p: PBGRAPixel;
  W, H: integer;
begin

  try

    bmp.Assign(NAV_Orig);

    coln := ColorToBGRA(col);
    black := ColorToBGRA(clBlack);

    W := bmp.Width;
    H := bmp.Height;

    for y := 0 to H -1 do
    begin
       p := bmp.Data ;

       {
       inc(p, y*w);

       pp := index * NAV_btnLen;
       inc(p,pp);
       }

       //for x := 0 to NAV_btnLen -1 do
       for x := 0 to W*H -1 do
       begin

          if p^ <> black then
            p^ := coln;

        inc(p);

       end;

    end;

    bmp.InvalidateBitmap;

  finally

  end;

end;

procedure Tf_planetinfo.NAV_Disable(bmp:TBGRABitmap);
var
  x, y : integer;
  black:TBGRAPixel;
  p: PBGRAPixel;
  W, H: integer;
begin

  try

    //bmp.Assign(NAV_Orig);

    black := ColorToBGRA(clBlack);

    W := bmp.Width;
    H := bmp.Height;

    for y := 0 to H -1 do
    begin
       p := bmp.Data ;

       for x := 0 to W*H -1 do
       begin

          if (x mod W) > NAV_btnLen then
            p^ := black;

        inc(p);

       end;

    end;

    bmp.InvalidateBitmap;

  finally

  end;

end;

procedure Tf_planetinfo.FormCreate(Sender: TObject);
begin
  {$ifdef lclgtk2}
  PanelLeft.Color:=clBlack;
  PanelLeft.Font.Color:=clWhite;
  {$endif}

  firstuse := true;

  //NAV Status bits
  NAV_Bits := TBits.Create(8);
  NAV_Bits.Clearall;

  NAV_Orig     := TBGRABitmap.Create(Image1.Picture.Bitmap);
  NAV_Image    := TBGRABitmap.Create(NAV_Orig);
  NAV_Disabled := TBGRABitmap.Create(NAV_Orig);

  EnableEvents:= false;

  ChartSync := false;

  zoomlock:=false;

  View_Index := View_PlanetVisibility;

  NAV_Coloring(clRed,  NAV_Image);
  NAV_Coloring(clGray, NAV_Disabled);

  NAV_Disable(NAV_Disabled);

  NAV_isPainting := false;

  NAV_TurnOFF;

  PanelrgTarget.Visible := False;
  PanelrgOrigin.Visible := False;
  txtFOV.Visible := False;

  Planet_Target := 1;
  Planet_Target_Index := 0;

  Planet_Origin := 1;
  Planet_Origin_Index := 0;

  IsProcessingPlanets := false;

  FOV := 1.0;

  ElapsedTime :=0;

  ScaleDPI(Self);

  Initialized:=false;

  config:=Tconf_skychart.Create;
  plbmp:=TBGRABitmap.Create;

  CenterAtNoon:=true;
  ShowCurrentObject:=true;
  setlang;
  ActivePage:=-1;
  ActiveDate:=-1;
  ActiveSizeX:=-1;
  ActiveSizeY:=-1;
  ActiveNoon:=false;
  TextZoom:=1;

  //3h dxJP by default
  SetTimeSpeed(6);
  txtJDdx.Caption := GetTimeSpeed_Str;

  IsProcessingPlanets := false;

  NAV_Current := NAV_Play;

  CurJDTT_OLD := config.CurJDTT;

  Orbit := TOrbits.Create(plbmp,TextZoom);

end;

procedure Tf_planetinfo.CheckBox1Change(Sender: TObject);
begin
  CenterAtNoon := not CheckBox1.Checked;
  RefreshInfo;
end;

procedure Tf_planetinfo.SetView(AViewIndex, AMoonIndex: integer);
begin

  EnableEvents := false;

  try

    View_Index := AViewIndex;

    Rescale_Internal;

    PaintBox1.Repaint;

    PanelrgTarget.Visible := False;
    PanelrgOrigin.Visible := False;

    ComboBox1.Visible := False;
    ComboBox2.Visible := False;

    cbDistance.Visible := False;

    Orbit.SetPlanet(Fplanet);
    Orbit.SetConfig(Config);

    Orbit.SetShowLabel(cbLabels.Checked);

    cbLabels.Visible:= not (View_Index = View_PlanetVisibility);

    PanelrgTarget.Visible := not (View_Index = View_PlanetVisibility);
    PanelrgOrigin.Visible := not (View_Index = View_PlanetVisibility);

    txtFOV.Visible := (View_Index >= View_Sun) and (View_Index <= View_Pluto);

    case View_Index of

      View_PlanetVisibility:
      begin
        //rgTarget.Visible := False;
        //rgOrigin.Visible := False;
      end;

      View_Sun:
      begin

        Planet_Target := C_Sun;
        Planet_Target_Index := AMoonIndex;

        SetRadioButtons
      end;

      View_Earth   :
      begin
        Planet_Target := C_Earth;
        Planet_Target_Index := AMoonIndex;

        if AMoonIndex > 0 then
          Planet_Target := Earth_Sat[AMoonIndex];

        SetRadioButtons
      end;

      View_Mercury :
      begin
        Planet_Target := C_Mercury;
        Planet_Target_Index := AMoonIndex;

        SetRadioButtons
      end;

      View_Venus:
      begin
        Planet_Target := C_Venus;
        Planet_Target_Index := AMoonIndex;

        SetRadioButtons
      end;

      View_Mars    :
      begin
        Planet_Target := C_Mars;
        Planet_Target_Index := AMoonIndex;

        if AMoonIndex > 0 then
            Planet_Target := Mars_Sat[AMoonIndex];

        SetRadioButtons
      end;

      View_Jupiter :
      begin
        Planet_Target := C_Jupiter;
        Planet_Target_Index := AMoonIndex;

        if AMoonIndex > 0 then
            Planet_Target := Jupiter_Sat[AMoonIndex];

        SetRadioButtons
      end;

      View_Saturn  :
      begin
        Planet_Target := C_Saturn;
        Planet_Target_Index := AMoonIndex;

        if AMoonIndex > 0 then
          Planet_Target := Saturn_Sat[AMoonIndex];

        SetRadioButtons
      end;

      View_Uranus  :
      begin
        Planet_Target := C_Uranus;
        Planet_Target_Index := AMoonIndex;

        if AMoonIndex > 0 then
          Planet_Target := Uranus_Sat[AMoonIndex];

        SetRadioButtons
      end;

      View_Neptune :
      begin
        Planet_Target := C_Neptune;
        Planet_Target_Index := AMoonIndex;

        if AMoonIndex > 0 then
          Planet_Target := Neptune_Sat[AMoonIndex];

        SetRadioButtons
      end;

      View_Pluto   :
      begin
        Planet_Target := C_Pluto;
        Planet_Target_Index := AMoonIndex;

        if AMoonIndex > 0 then
          Planet_Target := Pluto_Sat[AMoonIndex];

        SetRadioButtons
      end;

      View_Sim1:
      begin
        PanelrgTarget.Visible := False;
        PanelrgOrigin.Visible := False;

        ComboBox1.Visible := False;
        ComboBox2.Visible := False;

        cbDistance.Visible := True;

        Orbit.RefreshOrbit := True;
        Orbit.TypeOfOrbit := 0;

        Orbit.SetDrawnRegion(xmax,xmin,ymax,ymin);

      end;

      View_Sim2:
      begin
        PanelrgTarget.Visible := False;
        PanelrgOrigin.Visible := False;

        ComboBox1.Visible := False;
        ComboBox2.Visible := False;

        cbDistance.Visible := True;

        Orbit.RefreshOrbit := True;
        Orbit.TypeOfOrbit := 1;

        Orbit.SetDrawnRegion(xmax,xmin,ymax,ymin);
      end;

      View_FreePlanet:
      begin
        ComboBox1.Visible := True;
        ComboBox2.Visible := True;
      end;

    end;

    SetDefaultFOV;
    RefreshInfo;

  finally
    EnableEvents:= true;
  end;

end;

procedure Tf_planetinfo.acPlanetsVisibilityExecute(Sender: TObject);
begin
  SetView(View_PlanetVisibility, 0);
end;

procedure Tf_planetinfo.acSunExecute(Sender: TObject);
begin
  SetView(View_Sun, 0);
end;

procedure Tf_planetinfo.acMercuryExecute(Sender: TObject);
begin
  SetView(View_Mercury, 0);
end;

procedure Tf_planetinfo.acVenusExecute(Sender: TObject);
begin
  SetView(View_Venus, 0);
end;

procedure Tf_planetinfo.acEarthExecute(Sender: TObject);
begin
  SetView(View_Earth, 0);
end;

procedure Tf_planetinfo.acFreePlanetViewExecute(Sender: TObject);
begin
  //SZ Unable until finish
  //SetView(View_FreePlanet, 0);
end;

procedure Tf_planetinfo.acMarsExecute(Sender: TObject);
begin
  SetView(View_Mars, 0);
end;

procedure Tf_planetinfo.acJupiterExecute(Sender: TObject);
begin
  SetView(View_Jupiter, 0);
end;

procedure Tf_planetinfo.acSaturnExecute(Sender: TObject);
begin
  SetView(View_Saturn, 0);
end;

procedure Tf_planetinfo.acUranusExecute(Sender: TObject);
begin
  SetView(View_Uranus, 0);
end;

procedure Tf_planetinfo.acNeptuneExecute(Sender: TObject);
begin
  SetView(View_Neptune, 0);
end;

procedure Tf_planetinfo.acPlutoExecute(Sender: TObject);
begin
  SetView(View_Pluto, 0);
end;

procedure Tf_planetinfo.acSim1Execute(Sender: TObject);
begin
  SetView(View_Sim1, 0);
end;

procedure Tf_planetinfo.acSim2Execute(Sender: TObject);
begin
  SetView(View_Sim2, 0);
end;

procedure Tf_planetinfo.cbChartSyncChange(Sender: TObject);
begin

  ChartSync := cbChartSync.Checked;

  if ChartSync then
  begin
    NAV_Current :=  NAV_ChartSync;
    NAV_Bits.Bits[NAV_Current] := true;
    PaintBox2.Hint:= '';

    txtJDdx.Caption := rsChartSync;
  end
  else
  begin
     NAV_Current :=  NAV_Play;
     NAV_TurnOFF;

     txtJDdx.Caption := GetTimeSpeed_Str;
  end;

  PaintBox2.Invalidate;

  MainTimer.Enabled := ChartSync;

end;

procedure Tf_planetinfo.cbDistanceChange(Sender: TObject);
begin
  Orbit.IsDisplayDistance := cbDistance.Checked;
  RefreshInfo;
end;

procedure Tf_planetinfo.cbIconsChange(Sender: TObject);
begin
  tbPlanets.Visible:= cbIcons.Checked;
  FormResize(self);
end;

procedure Tf_planetinfo.cbLabelsChange(Sender: TObject);
begin
  Orbit.SetShowLabel(cbLabels.Checked);
  RefreshInfo;
end;

procedure Tf_planetinfo.cbRectangularChange(Sender: TObject);
begin
  PanelrgOrigin.Visible := PanelrgTarget.Visible and (not cbRectangular.Checked);
  RefreshInfo;
end;

procedure Tf_planetinfo.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  // Wait until finish processing, otherwise AV will happens

  cbChartSync.Checked := false;
  cbChartSyncChange(self);

  while IsProcessingPlanets do
     Application.ProcessMessages;

  NAV_Current := NAV_ResetTime;

end;

procedure Tf_planetinfo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var z: double;
begin
  if ssShift in Shift then
    z:=2
  else
    z:=1.1;
  case key of
    VK_ADD,VK_OEM_PLUS        :
     if fov > 2e-6 then
     begin
       fov := fov / z;
       RefreshInfo;
     end;
    VK_SUBTRACT,VK_OEM_MINUS  :
     if fov < 1e3 then
     begin
       fov := fov * z;
       RefreshInfo;
     end;
  end;
end;

procedure Tf_planetinfo.Label1Click(Sender: TObject);
begin
 CheckBox1.Checked:=not CheckBox1.Checked;
end;

procedure Tf_planetinfo.PaintBox2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  p : tPoint;
  index : integer;
begin
  if ChartSync then exit;

  p := Mouse.CursorPos;
  p := PaintBox2.ScreenToClient(p);

  index := p.X div NAV_btnLen;

  if index <> NAV_Hint_Index then
  begin

    case index of

      NAV_ResetTime    : PaintBox2.Hint:= rsResetTime;
      NAV_StepPrev     : PaintBox2.Hint:= rsStepBackward;
      NAV_StepForward  : PaintBox2.Hint:= rsStepForward;
      NAV_PlayPrev     : PaintBox2.Hint:= rsPlayBackward;
      NAV_Play         : PaintBox2.Hint:= rsPlayForward;
      NAV_DecTimeSpeed : PaintBox2.Hint:= rsDecrementTim2;
      NAV_IncTimeSpeed : PaintBox2.Hint:= rsIncrementTim2;

    else
      PaintBox2.Hint:= '';
    end;

    Application.HideHint;
    Application.ActivateHint(PaintBox2.ClientToScreen(Point(x,y)));

    NAV_Hint_Index := index;

  end;

end;

procedure Tf_planetinfo.PaintBoxMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var z: double;
begin
  // Zoom in/out with mouse wheel
  if zoomlock then exit;
  zoomlock:=true;
  try
  if fov < 1e3 then
  begin
    if ssShift in Shift then
      z:=2
    else
      z:=1.1;
    fov := fov * z;
    RefreshInfo;
  end;
  Application.ProcessMessages;
  finally
    zoomlock:=false;
  end;
end;

procedure Tf_planetinfo.PaintboxMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var z: double;
begin
  // Zoom in/out with mouse wheel
  if zoomlock then exit;
  zoomlock:=true;
  try
  if fov > 2e-6 then
  begin
    if ssShift in Shift then
      z:=2
    else
      z:=1.1;
    fov := fov / z;
    RefreshInfo;
  end;
  Application.ProcessMessages;
  finally
    zoomlock:=false;
  end;
end;

procedure Tf_planetinfo.Image1Click(Sender: TObject);
begin
end;

procedure Tf_planetinfo.PaintBox1Paint(Sender: TObject);
begin
  plbmp.Draw(PaintBox1.Canvas, 0, 0, false);
end;

procedure Tf_planetinfo.NAV_TurnON;
begin
  NAV_On := true;
  PaintBox2.Repaint;
end;

procedure Tf_planetinfo.NAV_TurnOFF;
begin
  NAV_On := false;
  NAV_Bits.Clearall;
  PaintBox2.Repaint;
end;

procedure Tf_planetinfo.PaintBox2Click(Sender: TObject);
var
  p : tPoint;
  index : integer;
  NAV_OldPlay: integer;

  procedure Blink_Internal;
  begin
    NAV_TurnON;
    NAVTimer.Enabled:=true;
  end;

begin

  if ChartSync then exit;

  p := Mouse.CursorPos;
  p := PaintBox2.ScreenToClient(p);

  index := p.X div NAV_btnLen;

  case index of

    NAV_ResetTime:
     begin

       NAV_Current := NAV_ResetTime;
       MainTimer.Enabled := false;

       NAV_Bits.Bits[NAV_Current] := true;

       config.CurJDTT := config.JDChart;
       RefreshInfo;

       NAV_Current := NAV_Play;
     end;

    NAV_StepPrev:
     begin

      NAV_Current := NAV_StepPrev;
      MainTimer.Enabled := false;

      NAV_Bits.Bits[NAV_Current] := true;

      config.CurJDTT := config.CurJDTT - dxJD;
      RefreshInfo;

      NAV_Current := -1;
     end;

    NAV_StepForward:
     begin

       NAV_Current:= NAV_StepForward;
       MainTimer.Enabled := false;

       NAV_Bits.Bits[NAV_Current] := true;

       config.CurJDTT := config.CurJDTT + dxJD;
       RefreshInfo;

       NAV_Current := -1;

    end;

    NAV_PlayPrev:

     begin
      NAV_Current:= NAV_PlayPrev;
      MainTimer.Enabled := not MainTimer.Enabled;

      NAV_Bits.Bits[NAV_Current] := MainTimer.Enabled;
     end;

    NAV_Play:

     begin
       NAV_Current:= NAV_Play;
       MainTimer.Enabled := not MainTimer.Enabled;

       NAV_Bits.Bits[NAV_Current] := MainTimer.Enabled;
     end;

    NAV_DecTimeSpeed:

     begin

       NAV_OldPlay:= NAV_Current;

       DecTimeSpeed;
       NAV_Current := NAV_DecTimeSpeed;
       txtJDdx.Caption := GetTimeSpeed_Str;

       NAV_Bits.Bits[NAV_Current] := true;

       Blink_Internal;

       if NAV_OldPlay = NAV_Play then
         NAV_Current := NAV_Play
       else
       if NAV_OldPlay = NAV_PlayPrev then
         NAV_Current := NAV_PlayPrev;

     end;

    NAV_IncTimeSpeed:

     begin

       NAV_OldPlay:= NAV_Current;

       IncTimeSpeed;
       Nav_Current := NAV_IncTimeSpeed;
       txtJDdx.Caption := GetTimeSpeed_Str;

       NAV_Bits.Bits[NAV_Current] := true;

       Blink_Internal;

       if NAV_OldPlay = NAV_Play then
         NAV_Current := NAV_Play
       else
       if NAV_OldPlay = NAV_PlayPrev then
         NAV_Current := NAV_PlayPrev;

     end;

  end;

end;

procedure Tf_planetinfo.PaintBox2Paint(Sender: TObject);
var
  i,x: integer;
begin

  // Avoding flickering and possible AV
  if NAV_isPainting then exit;

  NAV_isPainting := true;

  if ChartSync then
    NAV_Disabled.Draw(PaintBox2.Canvas, 0, 0, false)
  else
    NAV_Orig.Draw(PaintBox2.Canvas, 0, 0, false);

  try

    if NAV_On then
    begin

      //First index bit set to true
      if NAV_Bits.OpenBit >= 0 then
      begin

        for i:=0 to NAV_Bits.Size-1 do
        begin

          if NAV_Bits.Bits[i] then
          begin

            if i = NAV_ChartSync then
              x := 0
            else
              x := i * NAV_btnLen;

            NAV_Image.DrawPart(rect(x, 0, x + NAV_btnLen-1, NAV_Image.Height), PaintBox2.Canvas, x, 0, true);

          end;

        end;

      end
      else
        NAV_On:= false;

    end;

  finally
    NAV_isPainting := false;
  end;

end;

procedure Tf_planetinfo.rgOriginClick(Sender: TObject);
begin

  if EnableEvents then
  begin
    SetDefaultFOV;
    RefreshInfo;
  end;

end;

procedure Tf_planetinfo.rgTargetClick(Sender: TObject);
begin
  // use async call to not alter radio button in their own event
  if EnableEvents then
    Application.QueueAsyncCall(@rgTargetAsync,0);
end;

procedure Tf_planetinfo.rgTargetAsync(Data: PtrInt);
begin
  SetView(View_Index, rgTarget.ItemIndex);
end;

procedure Tf_planetinfo.MainTimerTimer(Sender: TObject);
begin

  if not IsProcessingPlanets then
  begin

    if ChartSync then
    begin

      if CurJDTT_OLD <> LinkedChartData.CurJDTT then
      begin
        config.CurJDTT := LinkedChartData.CurJDTT;
        CurJDTT_OLD := config.CurJDTT;

        RefreshInfo;

      end;
    end
    else
    begin

      if NAV_Current = NAV_Play then
        config.CurJDTT := config.CurJDTT + dxJD;

      if NAV_Current = NAV_PlayPrev then
        config.CurJDTT := config.CurJDTT - dxJD;

      RefreshInfo;

    end;

  end;

  // This must be performed in order to avoid freezing
  Application.ProcessMessages;

end;

procedure Tf_planetinfo.NAVTimerTimer(Sender: TObject);
begin

  if not IsProcessingPlanets then
  begin
    NAVTimer.Enabled:=false;

    NAV_Bits[NAV_IncTimeSpeed]:= false;
    NAV_Bits[NAV_DecTimeSpeed]:= false;

    PaintBox2.Repaint;

  end;

end;

procedure Tf_planetinfo.txtJDdxDecClick(Sender: TObject);
begin
  DecTimeSpeed;
  txtJDdx.Caption := GetTimeSpeed_Str;
end;

procedure Tf_planetinfo.txtPrevClick(Sender: TObject);
begin

  if View_Index>0 then
  begin
    dec(View_Index);
    SetView(View_Index,0);
  end;

end;

procedure Tf_planetinfo.txtNextClick(Sender: TObject);
begin

//  Unable last tab until finish
//  if View_Index < tbPlanets.ButtonList.Count-1 then
    if View_Index < tbPlanets.ButtonList.Count-2 then
  begin
    inc(View_Index);
    SetView(View_Index,0);
  end;

end;

procedure Tf_planetinfo.FormDestroy(Sender: TObject);
begin

  NAV_Orig.Free;
  NAV_Image.Free;
  NAV_Disabled.Free;

  NAV_Bits.Free;

  plbmp.Free;
  config.Free;
  Orbit.Free;
end;

procedure Tf_planetinfo.FormResize(Sender: TObject);
begin

  if firstuse then exit;

  while IsProcessingPlanets do
    Application.ProcessMessages;

  Rescale_Internal;

  PaintBox1.Repaint;

  plbmp.SetSize(Panel4.ClientWidth, Panel4.ClientHeight);
  plbmp.Fill(ColorToBGRA(clBlack));

  if (View_Index = View_Sim1) or (View_Index = View_Sim2) then
    Orbit.SetDrawnRegion(xmax,xmin,ymax,ymin);

  if Initialized then RefreshInfo;

end;

procedure Tf_planetinfo.FormShow(Sender: TObject);
begin
  ActivePage:=-1;

  if firstuse then
  begin

    Rescale_Internal;

    firstuse := false;

  end;

end;

procedure Tf_planetinfo.SetDefaultFOV;

  function Fov_Calc(ATarget, AOrigin: integer; AConst: double): double;
  var
    dist,fov : double;
  begin
    Fov :=  CFov[ATarget];

    if AOrigin in[C_Sun,C_Earth] then
    begin
      dist:=  Orbit.PlanetDistance(AOrigin, ATarget, config.CurJDTT);
      Fov :=  1/AConst/dist ;
    end;

    Result := fov;
  end;

  procedure SetFovInternal;
//  var
//    dist: double;
  begin

    case View_Index of

      View_Sun       : Fov := CFov[C_Sun];
      View_Mercury   : Fov := Fov_Calc(C_Mercury, Planet_Origin, 267.5);
      View_Venus     : Fov := Fov_Calc(C_Venus,   Planet_Origin, 109.4);
      View_Earth     :
        begin

          if Planet_Target_Index = 0 then
            Fov := CFov[C_Earth]
          else
            Fov := CFov[C_Moon];

        end;

      View_Mars      :
         begin

           case Planet_Target_Index of
             0:    Fov := Fov_Calc(C_Mars,   Planet_Origin, 195.7);
             1..2: Fov := Fov_Calc(C_Mars,   Planet_Origin,  10000);
           end;

         end;

            //fov := Earth_Radius/km_au * diam_real[C_Mars] / dist;
             //fov := arctan(fov) ;
             //fov := radtodeg(fov);
             //fov := 1/fov/dist;

           {
           case Subindex of
              0: Fov := CFov[C_Mars];
              1: Fov := CFov[C_Phobos];
              2: Fov := CFov[C_Deimos];
           end;
           }

      View_Jupiter   :
         begin

           case Planet_Target_Index of
             0: Fov := Fov_Calc(C_Jupiter,   Planet_Origin, 10.2);
             1: Fov := CFov[C_Io];
             2: Fov := CFov[C_Europa];
             3: Fov := CFov[C_Ganymede];
             4: Fov := CFov[C_Callisto];
           end;

         end;

      View_Saturn      :
       begin

         case Planet_Target_Index of
           0:    Fov := Fov_Calc(C_Saturn,   Planet_Origin, 9.20);
           1..2: Fov := Fov_Calc(C_Saturn,   Planet_Origin,  1000);
           3..5: Fov := Fov_Calc(C_Saturn,   Planet_Origin,  500);
           6:    Fov := Fov_Calc(C_Saturn,   Planet_Origin,  180);
           7:    Fov := Fov_Calc(C_Saturn,   Planet_Origin,  1000);
           8:    Fov := Fov_Calc(C_Saturn,   Planet_Origin,  500);
         end;

       end;

      View_Uranus      :
       begin

         case Planet_Target_Index of
           0:    Fov := Fov_Calc(C_Uranus,   Planet_Origin,  26.80);
           1..3: Fov := Fov_Calc(C_Uranus,   Planet_Origin,  1000);
           4..5: Fov := Fov_Calc(C_Uranus,   Planet_Origin,  500);
         end;

       end;

      View_Neptune     :
       begin

         case Planet_Target_Index of
           0:    Fov := Fov_Calc(C_Neptune,  Planet_Origin,  26.28);
           1:    Fov := Fov_Calc(C_Neptune,  Planet_Origin,  250);
         end;

       end;

      View_Pluto       : Fov := Fov_Calc(C_Pluto,    Planet_Origin, 578.31);
      View_FreePlanet  : Fov := 1.0;

    end;

  end;

  procedure SetFromEarth;
  begin
    Planet_Origin := C_Earth;
    Planet_Origin_Index:= 0;

    CFOV := CFOV_FromEarth;
    SetFovInternal;
  end;


  procedure SetFromSun;
  begin
    Planet_Origin := C_Sun;
    Planet_Origin_Index:= 1;

    CFOV := CFov_FromSun;
    SetFovInternal;
  end;

  procedure SetFromPlanet;
  begin

    Planet_Origin := GetPlanetParent(Planet_Target);
    Planet_Origin_Index:= 2;

    CFOV := CFov_FromPlanet;
    SetFovInternal;
  end;

begin

  if not( View_Index in [View_PlanetVisibility, View_Sim1, View_Sim2, View_FreePlanet]) then
  begin;

    case rgOrigin.ItemIndex of
      0: SetFromEarth;
      1: SetFromSun;
      2: SetFromPlanet;
    end;

  end;

end;

procedure Tf_planetinfo.SetRadioButtons;
var
    i: integer;
    origbody: string;
begin

  PanelrgTarget.Visible := not( View_Index in [View_PlanetVisibility, View_Sim1, View_Sim2]);
  PanelrgOrigin.Visible := PanelrgTarget.Visible and (not cbRectangular.Checked);

  rgTarget.Items.Clear;

  while rgOrigin.Items.Count<3 do
    rgOrigin.Items.Add('');

  rgOrigin.Items[0] := config.ObsName;
  rgOrigin.Items[1] := rsSun;

  if View_Index=View_Sun then
     origbody:=rsSun
  else
     origbody:=GetPlanetNameLang(View_Index-1);

  if Planet_Target_Index=0 then
     rgOrigin.Items[2] := Format(rsAbove, [origbody])
  else
     rgOrigin.Items[2] := origbody;

  if View_Index = View_Sun then
  begin
    if rgOrigin.Items.Count=3 then
      rgOrigin.Items.Delete(2);
    rgOrigin.Items[1] := Format(rsAbove, [origbody])
  end;

  case View_Index of

    View_Sun       : rgTarget.Items.Add(rsSun);
    View_Mercury   : rgTarget.Items.Add(rsMercury);
    View_Venus     : rgTarget.Items.Add(rsVenus);
    View_Earth     :
      begin
        rgTarget.Items.Add(rsEarth);
        rgTarget.Items.Add(rsMoon);
        if Planet_Target_Index=0 then rgOrigin.Items[0] := Format(rsAbove, [config.ObsName]);
      end;

    View_Mars      :
      begin
        rgTarget.Items.Add(rsMars);

        for i in Mars_Sat do
          rgTarget.Items.Add(GetPlanetNameLang(i));

      end;

    View_Jupiter   :
    begin
      rgTarget.Items.Add(rsJupiter);

      for i in Jupiter_Sat do
        rgTarget.Items.Add(GetPlanetNameLang(i));

    end;

    View_Saturn    :
       begin
         rgTarget.Items.Add(rsSaturn);

         for i in Saturn_Sat do
           rgTarget.Items.Add(GetPlanetNameLang(i));

       end;

    View_Uranus    :
       begin
         rgTarget.Items.Add(rsUranus);

         for i in Uranus_Sat do
           rgTarget.Items.Add(GetPlanetNameLang(i));

       end;

    View_Neptune   :
    begin
      rgTarget.Items.Add(rsNeptune);

      for i in Neptune_Sat do
        rgTarget.Items.Add(GetPlanetNameLang(i));

    end;

    View_Pluto     :
      begin
        rgTarget.Items.Add(rsPluto);
        for i in Pluto_Sat do
          rgTarget.Items.Add(GetPlanetNameLang(i));

      end;

    View_FreePlanet     :
      begin
        rgTarget.Items.Add('Free Planet View');
        //for i in Pluto_Sat do
        //  rgTarget.Items.Add(GetPlanetNameLang(i));

      end;

  end;

  if rgTarget.Items.Count > 0 then
    rgTarget.ItemIndex := Planet_Target_Index;

end;

procedure Tf_planetinfo.Rescale_Internal;
var
  MB,MT, ML, MR: integer; // Margines zoomed
  W, H, W1, H1: integer;
begin

  plbmp.SetSize(Panel4.Width, Panel4.Height);
  plbmp.Fill(ColorToBGRA(clBlack));

//  PaintBox1.Repaint;

  TextZoom:=plbmp.Width/800;

  MT := round(margintop     * TextZoom);
  MB := round(marginbottom  * TextZoom);
  ML := round(marginleft    * TextZoom);
  MR := round(marginright   * TextZoom);

  xmin := 0;
  xmax := plbmp.Width;

  ymin := 0;
  ymax := plbmp.Height;

  if (View_Index in [View_PlanetVisibility]) then
  begin

    xmin := ML;
    xmax := plbmp.Width-MR;

    ymin := MT;
    ymax := plbmp.Height-MB;

  end
  else

  if not cbRectangular.Checked and
    (View_Index in [View_Sun..View_Pluto])   then
  begin

    ymin := MT;
    ymax := plbmp.Height;

  end
  else

  if (View_Index in [View_Sim1..View_Sim2]) then
  begin

    ymin := MT;
    ymax := plbmp.Height;

  end
  else

  //if shown rectangular projection, adopt resolution

  if cbRectangular.Checked and
    (View_Index in [View_Sun..View_Pluto])
  then
  begin

    ymin := MT;
    ymax := plbmp.Height;

    W := xmax - xmin;
    H := ymax - ymin;

    // Ensure 2:1 ratio

    W1 := W;
    H1 := W1 div 2;

    if H1 > H then
    begin
      H1 := H;
      W1 := H1*2;
    end;

    if W1 > W then
    begin
      W1 := W;
      H1 := W1 div 2;
    end;

    xmin := ((W - W1) div 2);
    xmax := xmin + W1;

    ymin := ((H - H1 + MT) div 2);
    ymax := ymin + H1;

  end;

end;

procedure Tf_planetinfo.RefreshInfo;

var y,m,d: integer;
    h: double;

  procedure Plot_Internal(const Aarr: array of integer; APlanet: Integer; ASubindex: integer);
  begin

    if ASubindex > 0 then
      Aplanet := Aarr[ASubindex-1];

    PlotHeader(plbmp, GetPlanetNameLang(Aplanet), false, true);
    PlotPlanetImage(plbmp,Aplanet, Planet_Origin);

  end;

begin

  if IsProcessingPlanets then exit;

  IsProcessingPlanets := true;

  NAV_Bits.Bits[NAV_Current] := true;

  NAV_TurnON;

  txtPrev.Visible := View_Index <> 0;
  txtNext.Visible := View_Index <> tbPlanets.ButtonList.Count-1;

try

  Initialized := false;

  // time
  config.CurJDUT:=config.CurJDTT-config.DT_UT/24;  // UT from TT
  Djd(config.CurJDUT,y,m,d,h);
  config.jd0:=jd(y,m,d,0);                         // JD at 0h UT
  config.CurST:=Sidtim(config.jd0,h,config.ObsLongitude,config.eqeq); // Sidereal time
  Djd(config.CurJDUT+config.TimeZone/24,y,m,d,h);  // Local time
  config.CurYear:=y;
  config.CurMonth:=m;
  config.CurDay:=d;
  config.CurTime:=h;

  //
  Rescale_Internal;

  ActivePage  := View_Index;
  ActiveDate  := trunc(config.CurJDTT);
  ActiveNoon  := CenterAtNoon;
  ActiveSizeX := Panel1.Width;
  ActiveSizeY := Panel1.Height;

  // Set desired interval for timer to 20 ms
  if MainTimer.Interval <> 20 then MainTimer.Interval := 20;

  case View_Index of

    View_PlanetVisibility:
       begin
        PlotHeader(plbmp, rsPlanetVisibi, true, false);
        PlotTwilight(plbmp);
        PlotPlanet(plbmp);
        PlotSelection(plbmp);
        PlotFrame(plbmp);
     end;

     View_Sun:
        begin
          PlotHeader(plbmp,pla[C_Sun], false, true);
          PlotPlanetImage(plbmp,C_Sun, Planet_Origin);
        end;

     View_Earth   : Plot_Internal(Earth_Sat, C_Earth, Planet_Target_Index);
     View_Mercury :
        begin
          PlotHeader(plbmp,pla[C_Mercury], false, true);
          PlotPlanetImage(plbmp,C_Mercury, Planet_Origin);
        end;

     View_Venus:
        begin
          PlotHeader(plbmp,pla[C_Venus], false, true);
          PlotPlanetImage(plbmp,C_Venus, Planet_Origin);
        end;

     View_Mars    : Plot_Internal(Mars_Sat,    C_Mars,    Planet_Target_Index);
     View_Jupiter : Plot_Internal(Jupiter_Sat, C_Jupiter, Planet_Target_Index);
     View_Saturn  : Plot_Internal(Saturn_Sat,  C_Saturn,  Planet_Target_Index);
     View_Uranus  : Plot_Internal(Uranus_Sat,  C_Uranus,  Planet_Target_Index);
     View_Neptune : Plot_Internal(Neptune_Sat, C_Neptune, Planet_Target_Index);
     View_Pluto   : Plot_Internal(Pluto_Sat,   C_Pluto,   Planet_Target_Index);

     View_Sim1:
        begin
           Orbit.PlotOrbit(config.CurJDTT);
           PlotHeader(plbmp, rsInnerSolarSy, false, false);
        end;

     View_Sim2:
        begin
           Orbit.PlotOrbit(config.CurJDTT);
           PlotHeader(plbmp, rsOuterSolarSy, false, false);
        end;

     View_FreePlanet:
      begin
        //rgTarget.Items.Add(rsPluto);
        //for i in Pluto_Sat do
        //  rgTarget.Items.Add(GetPlanetNameLang(i));

      end;

  end;

  CheckBox1.Checked := not CenterAtNoon;
  CheckBox1.Visible := View_Index=0;
  Label1.Visible := CheckBox1.Visible;
  cbRectangular.Visible := (View_Index>0)and(View_Index<11);

  PaintBox1.Repaint;

//  SetRadioButtons;

  if fov >= (1/3600) then
    txtFOV.Caption:= rsFOV2 + DEToStrShort(fov,1)
  else
    txtFOV.Caption:= rsFOV2 + DEToStrShort(fov,3);

  NAV_Bits.Bits[NAV_ResetTime]   := false;
  NAV_Bits.Bits[NAV_StepForward] := false;
  NAV_Bits.Bits[NAV_StepPrev]    := false;
  NAV_Bits.Bits[NAV_Play]        := false;
  NAV_Bits.Bits[NAV_PlayPrev]    := false;
  NAV_Bits.Bits[NAV_ChartSync]   := false;

  finally
    IsProcessingPlanets := false;
    Initialized:=true;

    PaintBox2.Repaint;
  end;
end;

Procedure Tf_planetinfo.PlotTwilight(bmp:TBGRABitmap);
var ars,des,dist,diam,hp1,hp2,h : double;

  procedure PlotRect(de,hh,h1,h2:double; color: integer);
  var x1,x2: integer;
  begin
  if h1>-99 then begin
    if CenterAtNoon then begin
      h1:=rmod(h1+config.timezone+24,24);
      h2:=rmod(h2+config.timezone+24,24);
    end else begin
      h1:=rmod(h1+config.timezone+24+12,24);
      h2:=rmod(h2+config.timezone+24+12,24);
    end;
    x1:=xmin+round((h1/24)*(xmax-xmin));
    x2:=xmin+round((h2/24)*(xmax-xmin));
    if h2>=h1 then begin
      bmp.FillRect(x1,ymin,x2,ymax,ColorToBGRA(dfskycolor[color]),dmSet);
    end else begin
      bmp.FillRect(xmin,ymin,x2,ymax,ColorToBGRA(dfskycolor[color]),dmSet);
      bmp.FillRect(x1,ymin,xmax,ymax,ColorToBGRA(dfskycolor[color]),dmSet);
    end;
  end else begin
    if config.ObsLatitude-90+rad2deg*de-hh>0 then begin
       bmp.FillRect(xmin,ymin,xmax,ymax,ColorToBGRA(dfskycolor[color]),dmSet);
    end;
  end;
  end;

begin

  Fplanet.Sun(config.CurJDTT,ars,des,dist,diam);
  precession(jd2000,config.CurJDUT,ars,des);
  if (ars<0) then ars:=ars+pi2;
  // astro twilight
  h:=-18;
  Time_Alt(config.jd0,ars,des,h,hp1,hp2,config.ObsLatitude,config.ObsLongitude);
  PlotRect(des,h,hp1,hp2,5);
  // nautical twilight
  h:=-12;
  Time_Alt(config.jd0,ars,des,h,hp1,hp2,config.ObsLatitude,config.ObsLongitude);
  PlotRect(des,h,hp1,hp2,4);
  // civil twilight
  h:=-6;
  Time_Alt(config.jd0,ars,des,h,hp1,hp2,config.ObsLatitude,config.ObsLongitude);
  PlotRect(des,h,hp1,hp2,3);
  // sun rise
  h:=0;
  Time_Alt(config.jd0,ars,des,h,hp1,hp2,config.ObsLatitude,config.ObsLongitude);
  PlotRect(des,h,hp1,hp2,2);
end;

procedure Tf_planetinfo.PlotLine(bmp:TBGRABitmap; lbl:string; y:integer; des,h1,h2,ht:double);
var x1,x2,xt:integer;
    ts : Tsize;
begin
  if h1>-99 then begin
    if (h1<>0)or(h2<>24) then begin
      if CenterAtNoon then begin
        h1:=rmod(h1+24,24);
        h2:=rmod(h2+24,24);
      end else begin
        h1:=rmod(h1+24+12,24);
        h2:=rmod(h2+24+12,24);
      end;
    end;
    x1:=xmin+round((h1/24)*(xmax-xmin));
    x2:=xmin+round((h2/24)*(xmax-xmin));
    if h2>=h1 then begin
      bmp.DrawLineAntialias(x1,y,x2,y,ColorToBGRA(clYellow),3);
    end else begin
      bmp.DrawLineAntialias(xmin,y,x2,y,ColorToBGRA(clYellow),3);
      bmp.DrawLineAntialias(x1,y,xmax,y,ColorToBGRA(clYellow),3);
    end;
  end else begin
    if config.ObsLatitude-90+rad2deg*des>0 then begin
       bmp.DrawLineAntialias(xmin,y,xmax,y,ColorToBGRA(clYellow),3);
    end;
  end;
  if ht>-99 then begin
    if CenterAtNoon then begin
      ht:=rmod(ht+24,24);
    end else begin
      ht:=rmod(ht+24+12,24);
    end;
    xt:=xmin+round((ht/24)*(xmax-xmin));
    bmp.DrawVertLine(xt,y,y-5,ColorToBGRA(clYellow));
  end;
  bmp.FontHeight:=round(16*TextZoom);
  bmp.FontStyle:=[fsBold];
  repeat
    ts:=bmp.TextSize(lbl);
    if (ts.cx>xmin-5) then bmp.FontHeight:=bmp.FontHeight-1;
  until (ts.cx<=xmin-5)or(bmp.FontHeight<8);
  bmp.TextOut(xmin-5,y-6,lbl,ColorToBGRA(clWhite),taRightJustify);
  bmp.TextOut(xmax+5,y-5,lbl,ColorToBGRA(clWhite),taLeftJustify);
end;

Procedure Tf_planetinfo.PlotPlanet(bmp:TBGRABitmap);
var ipla,yc,ys,i:integer;
    ar,de,dist,diam,dkm,phase,illum,magn,dp,xp,yp,zp,vel,hp1,hp2,ht,azr,azs: double;
begin

  if ShowCurrentObject and config.FindOK and (config.FindType<>ftPla) then
    ys:=trunc((ymax-ymin)/11)
  else
    ys:=trunc((ymax-ymin)/10);

  yc:=ymin+ys;

  // sun first
  ipla:=C_Sun;
  Fplanet.Sun(config.CurJDTT,ar,de,dist,diam);
  precession(jd2000,config.CurJDUT,ar,de);
  if (ar<0) then ar:=ar+pi2;
  RiseSet(config.jd0,ar,de,hp1,ht,hp2,azr,azs,i,config);
  case i of
    0: PlotLine(bmp,pla[ipla],yc,de,hp1,hp2,ht);
    1: PlotLine(bmp,pla[ipla],yc,de,0,24,ht);
    2: PlotLine(bmp,pla[ipla],yc,de,-100,-100,-100);
  end;

  // moon second
  ipla:=C_Moon;
  yc:=yc+ys;
  Fplanet.Moon(config.CurJDTT,ar,de,dist,dkm,diam,phase,illum);
  precession(jd2000,config.CurJDUT,ar,de);
  if (ar<0) then ar:=ar+pi2;
  RiseSet(config.jd0,ar,de,hp1,ht,hp2,azr,azs,i,config);
  case i of
    0: PlotLine(bmp,pla[ipla],yc,de,hp1,hp2,ht);
    1: PlotLine(bmp,pla[ipla],yc,de,0,24,ht);
    2: PlotLine(bmp,pla[ipla],yc,de,-100,-100,-100);
  end;

  // other planets
  for ipla:=C_Mercury to C_Neptune do
  begin
    if ipla=C_Earth then continue; // skip earth
    yc:=yc+ys;
    Fplanet.Planet(ipla,config.CurJDTT,ar,de,dist,illum,phase,diam,magn,dp,xp,yp,zp,vel);
    precession(jd2000,config.CurJDUT,ar,de);
    if (ar<0) then ar:=ar+pi2;
    RiseSet(config.jd0,ar,de,hp1,ht,hp2,azr,azs,i,config);
    case i of
      0: PlotLine(bmp,pla[ipla],yc,de,hp1,hp2,ht);
      1: PlotLine(bmp,pla[ipla],yc,de,0,24,ht);
      2: PlotLine(bmp,pla[ipla],yc,de,-100,-100,-100);
    end;
  end;
end;

procedure Tf_planetinfo.PlotSelection(bmp:TBGRABitmap);
var
  yc,ys,i:integer;
  hp1,hp2,ht,azr,azs: double;

begin

  if ShowCurrentObject and config.FindOK and (config.FindType<>ftPla) then
  begin
    ys:=trunc((ymax-ymin)/11);
    yc:=ymax-ys;
    RiseSet(config.jd0,config.FindRA,config.FindDec,hp1,ht,hp2,azr,azs,i,config);
    case i of
      0: PlotLine(bmp,config.FindName,yc,config.FindDec,hp1,hp2,ht);
      1: PlotLine(bmp,config.FindName,yc,config.FindDec,0,24,ht);
      2: PlotLine(bmp,config.FindName,yc,config.FindDec,-100,-100,-100);
    end;
  end;

end;

Procedure Tf_planetinfo.PlotHeader(bmp:TBGRABitmap; title:String; showobs,showtime: boolean);
var
  c:TBGRAPixel;
  buf: string;
  JD: Double;
begin

  JD := config.CurTime;

  c:=ColorToBGRA(clWhite);
  bmp.FontHeight:=round(24*TextZoom);
  bmp.FontStyle:=[fsBold];
  bmp.TextOut(bmp.Width div 2,10,title,c,taCenter);
  bmp.FontHeight:=round(16*TextZoom);
  buf:=Date2Str(config.CurYear,config.CurMonth,config.CurDay)+blank+'  ( '+TzGMT2UTC(config.tz.ZoneName)+' )';
  bmp.TextOut(20,40,buf,c,taLeftJustify);

  if showobs then
  begin
    buf:=config.ObsName;
    bmp.TextOut(bmp.Width-20,40,buf,c,taRightJustify);
  end
  else
  if showtime then
  begin
     buf:=ArmToStr(JD);
     bmp.TextOut(bmp.Width-20,40,buf,c,taRightJustify);
  end;

end;

Procedure Tf_planetinfo.PlotFrame(bmp:TBGRABitmap);
var
  x,y,i: integer;
  l: string;
  c:TBGRAPixel;
  JD: Double;
begin

  JD := config.CurTime;

  c:=ColorToBGRA(clWhite);
  bmp.FontHeight:=round(12*TextZoom);
  bmp.FontStyle:=[fsBold];
  bmp.Rectangle(xmin,ymin,xmax,ymax,c,dmSet);
  for i:=0 to 24 do begin
      x:=xmin+trunc(i*((xmax-xmin)/24));
      y:=ymin-round(5*TextZoom);
      bmp.DrawVertLine(x,y,ymin,c);
      if CenterAtNoon then l:=inttostr(i)
         else l:=inttostr((i+12) mod 24);
      if (i mod 2)=0 then bmp.TextOut(x,y-15,l,c,taCenter);
  end;
  if CenterAtNoon then x:=xmin+trunc(JD*((xmax-xmin)/24))
                  else x:=xmin+trunc(rmod(JD+12,24)*((xmax-xmin)/24));
  bmp.DrawVertLine(x,ymin,ymax,ColorToBGRA(clRed));
end;

procedure Tf_planetinfo.PlotPlanetImage(bmp:TBGRABitmap; ATarget, AOrigin : integer);
var
   rectangular, searchdir,sz,buf,aConfig : string;
   irc,j: integer;
   gw: double;
   b: TBGRABitmap;
   r: TStringList;
   W,H: integer;
   targetLat, targetLong: double;
   originLat, originLong: double;
   origin, target: string;
   UseOrigin, UseLatLong, UseTarget, UseOriginFile: Boolean;
begin

  W := xmax-xmin;
  H := ymax-ymin;

  sz := inttostr(W)+'x'+inttostr(H);

  searchdir:=slash(appdir)+slash('data')+'planet';
  r:=TStringList.Create;

  if ATarget=C_Jupiter then gw:=Fplanet.JupGRS(config.GRSlongitude,config.GRSdrift,config.GRSjd,config.CurJDTT)
            else gw:=0;

  // For display Earth in different projection

  if cbRectangular.Checked then
    rectangular := 'rectangular'
  else
    rectangular := '';

  searchdir:=ScaledPlanetMapDir (ATarget,  H);

  // determinate target and origin
  target := GetPlanetName(ATarget);
  origin := GetPlanetParentName(AOrigin);

  originLat  :=  config.ObsLatitude;
  originLong := -config.ObsLongitude;

  targetLat  :=  config.ObsLatitude;
  targetLong := -config.ObsLongitude;

  // Autoset
  if cbRectangular.Checked then
  begin
    UseOriginFile := false;
    UseOrigin     := false;
    UseTarget     := true;
    UseLatLong    := false;
  end
  else
  begin
     if origin=target then
     begin
       UseOriginFile := false;
       UseOrigin     := false;
       UseTarget     := true;

       if (target = 'earth')and(Planet_Origin_Index=0) then
         UseLatLong    := true
       else
         UseLatLong    := false;

     end
     else

    if (origin='earth') then
    begin
      if (target='moon') then
        UseOriginFile:=(Planet_Origin_Index=0)
      else
        UseOriginFile := true;
      UseLatLong    := false;
      UseOrigin     := true;
      UseTarget     := true;
    end
    else

    if (origin='sun') then
    begin
      UseOriginFile := false;
      UseOrigin     := true;
      UseTarget     := true;

      if (target='earth') then
        UseLatLong    := true
      else;
        UseLatLong    := false
    end
    else

    begin
      UseOriginFile := false;
      UseOrigin     := true;
      UseTarget     := true;
      UseLatLong    := false;
    end;

  end;

  if (target='earth')or(origin<>'earth') then
    aConfig:='xplanet2.config'    // config with Earth
  else
    aConfig:='xplanet3.config';   // config without Earth, to avoid to draw earth surface in front of the planet

  GetXplanet_Plain(
    Xplanetversion,searchdir,sz,slash(Tempdir)+'info2.png',
      0,gw,config.CurJDTT,irc,r,rectangular, fov,
      UseOriginFile, UseLatLong,
      UseOrigin, origin,
      UseTarget, target,
      originLat, originLong,
      targetLat, targetLong,
      '','',
      aConfig,
      cbLabels.Checked
    );


  if (irc=0)and(FileExists(slash(Tempdir)+'info2.png')) then
  begin
    b:=TBGRABitmap.Create(slash(Tempdir)+'info2.png');

    bmp.PutImage(xmin, ymin,b,dmSet);

    b.Free;
  end else
  begin // something go wrong with xplanet
     buf:='';
     if r.Count>0 then for j:=0 to r.Count-1 do begin
      buf:=buf+r[j]+crlf;
     end;
     writetrace('Return code '+inttostr(irc)+' from xplanet');
     writetrace(buf);
 end;

  r.Free;

end;

procedure init;
var
  i: integer;
begin

  SetLength(VTimeSpeed, 30);

  i := 0; VTimeSpeed[i] := C_OneMin;
  inc(i); VTimeSpeed[i] := C_OneMin * 3;
  inc(i); VTimeSpeed[i] := C_OneMin * 5;
  inc(i); VTimeSpeed[i] := C_OneMin * 10;
  inc(i); VTimeSpeed[i] := C_OneMin * 30;
  inc(i); VTimeSpeed[i] := C_OneHour;
  inc(i); VTimeSpeed[i] := C_OneHour * 3;
  inc(i); VTimeSpeed[i] := C_OneHour * 6;
  inc(i); VTimeSpeed[i] := C_OneHour * 12;
  inc(i); VTimeSpeed[i] := C_OneDay;
  inc(i); VTimeSpeed[i] := C_OneDay * 3;
  inc(i); VTimeSpeed[i] := C_OneDay * 10;
  inc(i); VTimeSpeed[i] := C_OneMonth;
  inc(i); VTimeSpeed[i] := CRevolution[C_Mercury];  // Mercury revolution
  inc(i); VTimeSpeed[i] := C_OneMonth * 3;
  inc(i); VTimeSpeed[i] := C_OneMonth * 6;
  inc(i); VTimeSpeed[i] := CRevolution[C_Venus];    // Venus   revolution
  inc(i); VTimeSpeed[i] := CRevolution[C_Earth];    // Earth   revolution
  inc(i); VTimeSpeed[i] := CRevolution[C_Mars];     // Mars    revolution
  inc(i); VTimeSpeed[i] := CRevolution[C_Jupiter];  // Jupiter revolution
  inc(i); VTimeSpeed[i] := CRevolution[C_Saturn];   // Saturn  revolution
  inc(i); VTimeSpeed[i] := CRevolution[C_Uranus];   // Uranus  revolution
  inc(i); VTimeSpeed[i] := CRevolution[C_Neptune];  // Neptune revolution
  inc(i); VTimeSpeed[i] := CRevolution[C_Pluto];    // Pluto   revolution

  SetLength(VTimeSpeed, i+1);

end;

procedure fin;
begin
  SetLength(VTimeSpeed, 0);
end;

initialization
  init;

finalization
  fin

end.

