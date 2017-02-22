unit UScaleDPI;

{$mode objfpc}{$H+}

interface

uses  cu_radec, math, Types, StdCtrls,
  Forms, Graphics, Controls, ComCtrls, Grids, LCLType;

procedure SetScale(cnv:TCanvas);
procedure ScaleDPI(Control: TControl);
procedure ScaleImageList(ImgList: TImageList);
function DoScaleX(Size: Integer): integer;
function DoScaleY(Size: Integer): integer;
function scale: double;

var
  UseScaling: boolean = true;
  DesignDPI: integer = 96;
  RunDPI   : integer = 96;

implementation

uses BGRABitmap, BGRABitmapTypes;

procedure SetScale(cnv:TCanvas);
var rs: TSize;
    sc: double;
const teststr = 'The Lazy Fox Jumps';
      designlen = 125;
      designhig = 15;
begin
  {$ifdef SCALE_BY_DPI_ONLY}
  RunDPI:=Screen.PixelsPerInch;
  {$else}
  rs:=cnv.TextExtent(teststr);
  sc:=rs.cx/designlen;
  sc:=max(sc,rs.cy/designhig);
  if abs(1-sc)<0.1 then sc:=1;
  RunDPI:=round(DesignDPI*sc);
  {$endif}
end;

function scale: double;
begin
 result:=UScaleDPI.RunDPI/UScaleDPI.DesignDPI;
 if result<1 then result:=1;
end;

function DoScaleX(Size: Integer): integer;
begin
  if (not UseScaling)or(RunDPI <= DesignDPI) then
    result := Size
  else
    result := MulDiv(Size, RunDPI, DesignDPI);
end;

function DoScaleY(Size: Integer): integer;
begin
  if (not UseScaling)or(RunDPI <= DesignDPI) then
    result := Size
  else
    result := MulDiv(Size, RunDPI, DesignDPI);
end;

procedure ScaleImageList(ImgList: TImageList);
var
  TempBmp: TBitmap;
  TempBGRA: array of TBGRABitmap;
  NewWidth,NewHeight: integer;
  i: Integer;

begin
  if (not UseScaling)or(RunDPI <= DesignDPI*1.2) then exit;

  NewWidth := DoScaleX(ImgList.Width);
  NewHeight := DoScaleY(ImgList.Height);

  setlength(TempBGRA, ImgList.Count);
  TempBmp := TBitmap.Create;
  for i := 0 to ImgList.Count-1 do
  begin
    ImgList.GetBitmap(i,TempBmp);
    TempBGRA[i] := TBGRABitmap.Create(TempBmp);
    TempBGRA[i].ResampleFilter := rfBestQuality;
    if (TempBGRA[i].width=0) or (TempBGRA[i].height=0) then continue;
    while (TempBGRA[i].Width < NewWidth) or (TempBGRA[i].Height < NewHeight) do
      BGRAReplace(TempBGRA[i], TempBGRA[i].FilterSmartZoom3(moLowSmooth));
    BGRAReplace(TempBGRA[i], TempBGRA[i].Resample(NewWidth,NewHeight));
  end;
  TempBmp.Free;

  ImgList.Clear;
  ImgList.Width:= NewWidth;
  ImgList.Height:= NewHeight;

  for i := 0 to high(TempBGRA) do
  begin
    ImgList.Add(TempBGRA[i].Bitmap,nil);
    TempBGRA[i].Free;
  end;
end;

procedure ScaleDPI(Control: TControl);
var
  n: Integer;
  WinControl: TWinControl;
begin
  if (not UseScaling)or(RunDPI <= DesignDPI) then exit;

  if Control is TUpDown then begin
    // do not resize two time
    if TUpDown(Control).Parent is TRaDec then begin
      TRaDec(TUpDown(Control).Parent).lockchange:=true;
      WinControl:=TUpDown(Control).Associate;
      TUpDown(Control).Associate:=nil;
      TUpDown(Control).Associate:=WinControl;
      TRaDec(TUpDown(Control).Parent).lockchange:=true;
      exit;
    end
    else begin
       if TUpDown(Control).Associate<>nil then begin
         WinControl:=TUpDown(Control).Associate;
         TUpDown(Control).Associate:=nil;
         TUpDown(Control).Associate:=WinControl;
         exit;
       end;
    end;
  end;

  with Control do begin
    Left:=DoScaleX(Left);
    Top:=DoScaleY(Top);
    Width:=DoScaleX(Width);
    Height:=DoScaleY(Height);
  end;

  if Control is TToolBar then begin
    with TToolBar(Control) do begin
      ButtonWidth:=DoScaleX(ButtonWidth);
      ButtonHeight:=DoScaleY(ButtonHeight);
    end;
    exit;
  end;

  if Control is TStringGrid then begin
    with TStringGrid(Control) do begin
      for n:=0 to ColCount-1 do begin
        ColWidths[n]:=DoScaleX(ColWidths[n]);
      end;
    end;
    exit;
  end;


  if Control is TWinControl then begin
    WinControl:=TWinControl(Control);
    if WinControl.ControlCount > 0 then begin
      for n:=0 to WinControl.ControlCount-1 do begin
        if WinControl.Controls[n] is TControl then begin
          ScaleDPI(WinControl.Controls[n]);
        end;
      end;
    end;
  end;
end;

end.
