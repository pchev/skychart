unit pu_print;
{
Copyright (C) 2006 Patrick Chevalley

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

{$mode objfpc}{$H+}

interface

uses  u_help, u_translation, u_constant, u_util,
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, enhedits, Printers, LazHelpHTML;

type

  { Tf_print }

  Tf_print = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    Preview: TButton;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LongEdit1: TLongEdit;
    LongEdit2: TLongEdit;
    LongEdit3: TLongEdit;
    LongEdit4: TLongEdit;
    CopyPanel: TPanel;
    copies: TLongEdit;
    PrinterInfo: TLabel;
    Setup: TButton;
    Print: TButton;
    Cancel: TButton;
    prtcolor: TRadioGroup;
    prtorient: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure copiesChange(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LongEdit1Change(Sender: TObject);
    procedure LongEdit2Change(Sender: TObject);
    procedure LongEdit3Change(Sender: TObject);
    procedure LongEdit4Change(Sender: TObject);
    procedure prtcolorClick(Sender: TObject);
    procedure prtorientClick(Sender: TObject);
    procedure SetupClick(Sender: TObject);
  private
    { private declarations }
    Procedure ShowPrtInfo;
  public
    { public declarations }
    cm: Tconf_main;
    procedure SetLang;
  end;

var
  f_print: Tf_print;

implementation
{$R *.lfm}

uses pu_printsetup;

procedure Tf_print.SetLang;
begin
Caption:=rsPrintChart;
prtcolor.caption:=rsColor;
prtcolor.Items[0]:=rsColorLineMod;
prtcolor.Items[1]:=rsBlackWhiteLi;
if prtcolor.Items.Count>=3 then prtcolor.Items[2]:=rsAsOnScreenBl;
prtorient.caption:=rsOrientation;
prtorient.Items[0]:=rsPortrait;
prtorient.Items[1]:=rsLandscape;
GroupBox1.caption:=rsPageMarginIn;
Label1.caption:=rsLeft;
Label2.caption:=rsRight;
Label3.caption:=rsTop;
Label4.caption:=rsBottom;
Label5.Caption:=rsDescription;
Label6.Caption:=rsNumberOfCopi;
CheckBox1.Caption:=rsPrintHeaderA;
Button1.caption:=rsNoMargin;
Button2.caption:=rsDefaultMargi;
Button3.caption:=rsHelp;
Setup.caption:=rsSetup;
Print.caption:=rsPrint;
Preview.Caption:=rsPreview;
Cancel.Caption:=rsCancel;
SetHelp(self,hlpMenuFile);
end;

procedure Tf_print.FormShow(Sender: TObject);
begin
if cm.PrintLandscape then prtorient.ItemIndex:=1
                     else prtorient.ItemIndex:=0;
LongEdit1.Value:=cm.PrtLeftMargin;
LongEdit2.Value:=cm.PrtRightMargin;
LongEdit3.Value:=cm.PrtTopMargin;
LongEdit4.Value:=cm.PrtBottomMargin;
edit1.Text:=cm.PrintDesc;
copies.Value:=cm.PrintCopies;
ShowPrtInfo;
end;

procedure Tf_print.Button1Click(Sender: TObject);
begin
LongEdit1.Value:=0;
LongEdit2.Value:=0;
LongEdit3.Value:=0;
LongEdit4.Value:=0;
end;

procedure Tf_print.Button2Click(Sender: TObject);
begin
LongEdit1.Value:=15;
LongEdit2.Value:=15;
LongEdit3.Value:=10;
LongEdit4.Value:=5;
end;

procedure Tf_print.Button3Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_print.copiesChange(Sender: TObject);
begin
  cm.PrintCopies := copies.Value;
end;

procedure Tf_print.Edit1Change(Sender: TObject);
begin
  cm.PrintDesc:=Edit1.Text;
end;

procedure Tf_print.FormCreate(Sender: TObject);
begin
  SetLang;
end;

procedure Tf_print.LongEdit1Change(Sender: TObject);
begin
cm.PrtLeftMargin:=LongEdit1.Value;
end;

procedure Tf_print.LongEdit2Change(Sender: TObject);
begin
cm.PrtRightMargin:=LongEdit2.Value;
end;

procedure Tf_print.LongEdit3Change(Sender: TObject);
begin
cm.PrtTopMargin:=LongEdit3.Value;
end;

procedure Tf_print.LongEdit4Change(Sender: TObject);
begin
cm.PrtBottomMargin:=LongEdit4.Value;
end;

procedure Tf_print.ShowPrtInfo;
var i: integer;
begin
if (cm.PrintMethod=0)and(Printer.PrinterIndex<0) then begin
  cm.PrintMethod:=1;
end;
prtcolor.ItemIndex:=cm.PrintColor;
if ((cm.PrintMethod=0)or(cm.PrintMethod=1)) then begin
  if prtcolor.ItemIndex=2 then prtcolor.ItemIndex:=0;
    if prtcolor.Items.Count>=3 then prtcolor.Items.Delete(2);
end else begin
  if prtcolor.Items.Count<3 then
     prtcolor.Items.Add(rsAsOnScreenBl)
  else
     prtcolor.Items[2]:=rsAsOnScreenBl;
end;
cm.PrintColor:=prtcolor.ItemIndex;
case cm.PrintMethod of
0 : begin
    GetPrinterResolution(cm.prtname,i);
    PrinterInfo.Caption:=rsprinter+blank+cm.prtname+' @ '+inttostr(i)+' DPI';
    GroupBox1.Visible:=true;
    CopyPanel.Visible:=true;
    Preview.Visible:=true;
    end;
1 : begin
    PrinterInfo.Caption:=rsPostscript+' @ '+inttostr(cm.PrinterResolution)+' DPI';
    GroupBox1.Visible:=true;
    CopyPanel.Visible:=false;
    Preview.Visible:=false;
    end;
2 : begin
    PrinterInfo.Caption:=rsBitmap+'  @ '+inttostr(cm.PrinterResolution)+' DPI';
    GroupBox1.Visible:=true;
    CopyPanel.Visible:=false;
    Preview.Visible:=false;
    end;
end;
end;

procedure Tf_print.prtcolorClick(Sender: TObject);
begin
if ((cm.PrintMethod=0)or(cm.PrintMethod=1))and(prtcolor.ItemIndex=2) then prtcolor.ItemIndex:=0;
cm.PrintColor:=prtcolor.ItemIndex;
end;

procedure Tf_print.prtorientClick(Sender: TObject);
begin
cm.PrintLandscape:=(prtorient.ItemIndex=1);
end;

procedure Tf_print.SetupClick(Sender: TObject);
var savecfgm:Tconf_main;
begin
savecfgm:=Tconf_main.Create;
try
savecfgm.Assign(cm);
f_printsetup.cm:=cm;
formpos(f_printsetup,mouse.cursorpos.x,mouse.cursorpos.y);
if f_printsetup.showmodal=mrOK then begin
 cm:=f_printsetup.cm;
 ShowPrtInfo;
end else begin
 cm.Assign(savecfgm);
end;
finally
savecfgm.Free;
end;
end;

end.
