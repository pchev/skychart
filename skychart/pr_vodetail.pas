unit pr_vodetail;

{$MODE Delphi}

{                                        
Copyright (C) 2011 Patrick Chevalley

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
 Detail of catalog for the Virtual Observatory interface.
}

interface

uses
  u_translation, u_voconstant, UScaleDPI,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls, enhedits, LResources, Buttons, Spin, ColorBox;

type

  { Tf_vodetail }

  Tf_vodetail = class(TForm)
    Button2: TButton;
    ButtonBack: TButton;
    cbForcecolor: TCheckBox;
    ColorDialog1: TColorDialog;
    cbObjecttype: TComboBox;
    cbStarDrawing: TComboBox;
    PanelStarSymbol: TPanel;
    Shape2: TShape;
    StarDrawingSize: TSpinEdit;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label5: TLabel;
    MagField: TComboBox;
    PanelDso: TPanel;
    PanelNone: TPanel;
    PanelStar: TPanel;
    SizeField: TComboBox;
    NameField: TComboBox;
    Prefix: TEdit;
    FullDownload: TCheckBox;
    Grid: TStringGrid;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    DefMag: TLongEdit;
    DefSize: TLongEdit;
    Shape1: TShape;
    desc: TStaticText;
    tr: TStaticText;
    tn: TStaticText;
    Panel1: TPanel;
    MainPanel: TPanel;
    RadioGroup1: TRadioGroup;
    Table: TLabel;
    Rows: TLabel;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure cbForcecolorChange(Sender: TObject);
    procedure cbObjecttypeChange(Sender: TObject);
    procedure cbStarDrawingChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FullDownloadChange(Sender: TObject);
    procedure GetData(Sender: TObject);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FieldChange(Sender: TObject);
    procedure PrefixChange(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Shape2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure StarDrawingSizeChange(Sender: TObject);
  private
    { Private declarations }
    FPreviewData, FGetData, FUpdateconfig, FGoback: TNotifyEvent;
  public
    { Public declarations }
    needdownload: boolean;
    SelectAll: boolean;
    vo_maxrecord: integer;
    drawcolor: Tcolor;
    forcecolor: integer;
    drawtype: integer;
    tablenum: integer;
    startype, starcolor, starsize: integer;
    field_size, field_mag, field_name, forcesize, forcemag, forcename: integer;
    nameprefix: string;
    procedure Setlang;
    property onPreviewData: TNotifyEvent read FPreviewData write FPreviewData;
    property onGetData: TNotifyEvent read FGetData write FGetData;
    property onUpdateconfig: TNotifyEvent read FUpdateconfig write FUpdateconfig;
    property onGoback: TNotifyEvent read FGoback write FGoback;
  end;

implementation

{$R *.lfm}

procedure Tf_vodetail.Setlang;
begin
  table.Caption := rsTable;
  Rows.Caption := rsRows;
  Label10.Caption := rsDefaultMagni;
  Label9.Caption := rsDefaultSizeA;
  Label1.Caption := rsObjectType;
  FullDownload.Caption := rsDownloadFull + '   ';
  ButtonBack.Caption := '< ' + rsBack;
  Button1.Caption := rsDownloadCata;
  Button2.Caption := rsDataPreview;
  cbForcecolor.Caption := rsForceColor + '   ';
  RadioGroup1.Items[0] := rsCannotDraw + '   ';
  RadioGroup1.Items[1] := rsDrawAsStar + '   ';
  RadioGroup1.Items[2] := rsDrawAsDSO + '    ';
  cbObjecttype.Items[0] := rsUnknowObject;
  cbObjecttype.Items[1] := rsGalaxy;
  cbObjecttype.Items[2] := rsOpenCluster;
  cbObjecttype.Items[3] := rsGlobularClus;
  cbObjecttype.Items[4] := rsPlanetaryNeb;
  cbObjecttype.Items[5] := rsBrightNebula;
  cbObjecttype.Items[6] := rsClusterAndNe;
  cbObjecttype.Items[7] := rsStar;
  cbObjecttype.Items[8] := rsDoubleStar;
  cbObjecttype.Items[9] := rsTripleStar;
  cbObjecttype.Items[10] := rsAsterism;
  cbObjecttype.Items[11] := rsKnot;
  cbObjecttype.Items[12] := rsGalaxyCluste;
  cbObjecttype.Items[13] := rsDarkNebula;
  cbObjecttype.Items[14] := rsCircle;
  cbObjecttype.Items[15] := rsSquare;
  cbObjecttype.Items[16] := rsLosange;
  cbStarDrawing.Items[0] := rsStar;
  cbStarDrawing.Items[1] := rsCircle;
  cbStarDrawing.Items[2] := rsSquare;
  cbStarDrawing.Items[3] := rsLosange;
  Label24.Caption := rsDrawAs;
  Label25.Caption := rsMarkSize;
  Label5.Caption := rsColor;
  Label2.Caption := rsMagnitude;
  Label3.Caption := rsSize;
  Label4.Caption := rsName;
end;

procedure Tf_vodetail.GetData(Sender: TObject);
begin
  if needdownload then
  begin
    if assigned(FGetData) then
      FGetData(self);
  end
  else
  begin
    if assigned(FUpdateconfig) then
      FUpdateconfig(self);
  end;
end;

procedure Tf_vodetail.FullDownloadChange(Sender: TObject);
begin
  if FullDownload.Checked and (StrToIntDef(tr.Caption, MaxInt) > vo_maxrecord) then
  begin
    ShowMessage(Format(rsThisCatalogC, [tr.Caption]));
    FullDownload.Checked := False;
  end;
  if FullDownload.Checked and (StrToIntDef(tr.Caption, 0) = 0) then
  begin
    ShowMessage(Format(rsTheNumberOfR, [IntToStr(vo_maxrecord)]));
  end;
end;

procedure Tf_vodetail.ButtonBackClick(Sender: TObject);
begin
  if assigned(FGoback) then
    FGoback(self);
end;

procedure Tf_vodetail.cbForcecolorChange(Sender: TObject);
begin
  if cbForcecolor.Checked then
    forcecolor := 1
  else
    forcecolor := 0;
end;

procedure Tf_vodetail.cbObjecttypeChange(Sender: TObject);
begin
  drawtype := cbObjecttype.ItemIndex;
end;

procedure Tf_vodetail.cbStarDrawingChange(Sender: TObject);
begin
  startype:=cbStarDrawing.ItemIndex;
  PanelStarSymbol.Visible:=(startype>0);
end;

procedure Tf_vodetail.Button2Click(Sender: TObject);
begin
  if assigned(FPreviewData) then
    FPreviewData(self);
end;

procedure Tf_vodetail.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  Setlang;
  needdownload := True;
  drawtype := 14;
  cbObjecttype.ItemIndex := drawtype;
  drawcolor := clGray;
  ColorDialog1.Color := drawcolor;
  shape1.Brush.Color := drawcolor;
  forcecolor := 0;
  cbForcecolor.Checked := (forcecolor = 1);
  startype:=0;
  cbStarDrawing.ItemIndex:=startype;
  starcolor:=clGray;
  shape2.Brush.Color:=starcolor;
  starsize:=8;
  StarDrawingSize.Value:=starsize;
end;

procedure Tf_vodetail.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  Column, Row, i: integer;
  mark: string;
  forcemark: boolean;
begin
  grid.MouseToCell(X, Y, Column, Row);
  if (row > 0) and (Column = 0) then
  begin
    needdownload := True;
    button1.Caption := rsDownloadCata;
    forcemark := (grid.Cells[1, Row] = NameField.Text) or (grid.Cells[1, Row] = SizeField.Text) or
      (grid.Cells[1, Row] = MagField.Text);
    if forcemark or (grid.Cells[Column, Row] = '') then
      mark := 'x'
    else
      mark := '';
    grid.Cells[Column, Row] := mark;
  end;
  if (row = 0) and (Column = 0) then
  begin
    needdownload := True;
    button1.Caption := rsDownloadCata;
    SelectAll := not SelectAll;
    if SelectAll then
      mark := 'x'
    else
      mark := '';
    for i := 1 to grid.RowCount - 1 do
    begin
      forcemark := (grid.Cells[1, i] = NameField.Text) or (grid.Cells[1, i] = SizeField.Text) or
        (grid.Cells[1, i] = MagField.Text);
      if forcemark then
        grid.Cells[0, i] := 'x'
      else
        grid.Cells[0, i] := mark;
    end;
  end;
end;

procedure Tf_vodetail.FieldChange(Sender: TObject);
var
  buf: string;
  i: integer;
begin
  buf := TComboBox(Sender).Text;
  if (buf > '') and (buf <> rsAutomatic) then
  begin
    if Sender = NameField then
      Prefix.Text := buf + ' ';
    for i := 0 to Grid.RowCount - 1 do
    begin
      if Grid.Cells[1, i] = buf then
      begin
        if Grid.Cells[0, i] <> 'x' then
        begin
          Grid.Cells[0, i] := 'x';
          needdownload := True;
          button1.Caption := rsDownloadCata;
        end;
        break;
      end;
    end;
  end;
end;

procedure Tf_vodetail.PrefixChange(Sender: TObject);
begin
  nameprefix := Prefix.Text;
end;

procedure Tf_vodetail.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  ColorDialog1.Color := drawcolor;
  if ColorDialog1.Execute then
  begin
    drawcolor := ColorDialog1.Color;
    Shape1.Brush.Color := drawcolor;
  end;
end;

procedure Tf_vodetail.Shape2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ColorDialog1.Color := starcolor;
  if ColorDialog1.Execute then
  begin
    starcolor := ColorDialog1.Color;
    Shape2.Brush.Color := starcolor;
  end;
end;

procedure Tf_vodetail.StarDrawingSizeChange(Sender: TObject);
begin
  starsize:=StarDrawingSize.Value;
end;

procedure Tf_vodetail.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    0:
    begin // cannot draw
      PanelStar.Visible:=False;
      PanelDso.Visible:=False;
      PanelNone.Visible:=True;
      Button1.Enabled := False;
      FullDownload.Enabled := False;
      cbObjecttype.Enabled := False;
      DefSize.Enabled := False;
      cbForcecolor.Enabled := False;
      Shape1.Enabled := False;
      label1.Enabled := False;
      label9.Enabled := False;
      MagField.Enabled := False;
      SizeField.Enabled := False;
      Prefix.Enabled := False;
      NameField.Enabled := False;
    end;
    1:
    begin // Star
      PanelStar.Visible:=True;
      PanelDso.Visible:=False;
      PanelNone.Visible:=False;
      Button1.Enabled := True;
      FullDownload.Enabled := True;
      cbObjecttype.Enabled := False;
      DefSize.Enabled := False;
      cbForcecolor.Enabled := False;
      Shape1.Enabled := False;
      label1.Enabled := False;
      label9.Enabled := False;
      MagField.Enabled := True;
      SizeField.Enabled := False;
      Prefix.Enabled := True;
      NameField.Enabled := True;
    end;
    2:
    begin // DSO
      PanelStar.Visible:=False;
      PanelDso.Visible:=True;
      PanelNone.Visible:=False;
      Button1.Enabled := True;
      FullDownload.Enabled := True;
      cbObjecttype.Enabled := True;
      DefSize.Enabled := True;
      cbForcecolor.Enabled := True;
      Shape1.Enabled := True;
      label1.Enabled := True;
      label9.Enabled := True;
      MagField.Enabled := True;
      SizeField.Enabled := True;
      Prefix.Enabled := True;
      NameField.Enabled := True;
    end
  end;
end;



end.
