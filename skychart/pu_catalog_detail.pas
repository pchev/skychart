unit pu_catalog_detail;

{
Copyright (C) 2024 Patrick Chevalley

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

{$mode ObjFPC}{$H+}

interface

uses u_translation, UScaleDPI,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls, StdCtrls, Spin, ColorBox;

type

  { Tf_catalog_detail }

  Tf_catalog_detail = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cbLabel: TCheckBox;
    ColorBox1: TColorBox;
    Label1: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    PanelStar: TPanel;
    Drawing: TComboBox;
    DrawingSize: TSpinEdit;
    TabSheetStar: TTabSheet;
    procedure DrawingChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure Setlang;
  end;

var
  f_catalog_detail: Tf_catalog_detail;

implementation

{$R *.lfm}

{ Tf_catalog_detail }

procedure Tf_catalog_detail.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  Setlang;
end;

procedure Tf_catalog_detail.Setlang;
begin
  caption := rsDrawing;
  Label24.Caption := rsDrawAs;
  Drawing.Items[0] := rsStar;
  Drawing.Items[1] := rsCircle;
  Drawing.Items[2] := rsSquare;
  Drawing.Items[3] := rsLosange;
  Label25.Caption := rsMarkSize;
  Label1.Caption := rsColor;
  cbLabel.Caption := rsShowLabels;
end;

procedure Tf_catalog_detail.DrawingChange(Sender: TObject);
begin
  PanelStar.Visible := Drawing.ItemIndex > 0;
end;



end.

