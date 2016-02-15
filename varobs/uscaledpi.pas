unit UScaleDPI;

{$mode objfpc}{$H+}

interface

uses
  Forms, Graphics, Controls, ComCtrls, Grids, LCLType;

procedure ScaleDPI(Control: TControl);
function DoScaleX(Size: Integer): integer;
function DoScaleY(Size: Integer): integer;

var
  UseScaling: boolean = true;
  DesignDPI: integer = 96;
  RunDPI   : integer = 96;

implementation

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

procedure ScaleDPI(Control: TControl);
var
  n: Integer;
  WinControl: TWinControl;
begin
  if (not UseScaling)or(RunDPI <= DesignDPI) then exit;

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
