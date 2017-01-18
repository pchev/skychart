unit pu_printsetup;

{$MODE Delphi}{$H+}

{
Copyright (C) 2004 Patrick Chevalley

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
 Printer setup form for Windows VCL application
}

interface

uses u_help, u_translation, u_constant, u_util, LazUTF8, LazFileUtils, UScaleDPI,
  SysUtils, Types, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Printers, ExtCtrls, enhedits, Buttons,
  LResources, PrintersDlgs, EditBtn, LazHelpHTML;

type

  { Tf_printsetup }

  Tf_printsetup = class(TForm)
    Button1: TButton;
    cmdreport2: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    bmpw: TLongEdit;
    bmph: TLongEdit;
    printcmd2: TFileNameEdit;
    bmpoption: TPanel;
    ResolWarning: TLabel;
    PaperSize: TComboBox;
    printcmd1: TFileNameEdit;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    savepath1: TDirectoryEdit;
    printmode: TRadioGroup;
    printeroption: TPanel;
    psoption: TPanel;
    qtsetup: TButton;
    qtprintername: TLabel;
    qtprintresol: TLabel;
    Ok: TButton;
    Cancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    prtres: TLongEdit;
    cmdreport1: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    savepath2: TDirectoryEdit;
    procedure bmphChange(Sender: TObject);
    procedure bmpwChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaperSizeChange(Sender: TObject);
    procedure printcmd1AcceptFileName(Sender: TObject; var Value: String);
    procedure qtsetupClick(Sender: TObject);
    procedure printmodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure prtresChange(Sender: TObject);
    procedure printcmd1Change(Sender: TObject);
    procedure savepathExit(Sender: TObject);
  private
    { Private declarations }
    lockupd: boolean;
    procedure updprtsetup;
  public
    { Public declarations }
    cm: Tconf_main;
    procedure SetLang;
  end;

var
  f_printsetup: Tf_printsetup;

implementation
{$R *.lfm}

procedure Tf_printsetup.SetLang;
begin
Caption:=rsPrinterSetup;
Label2.caption:=rsPrinter;
Label3.caption:=rsResolution;
Label7.caption:=rsSelectTheSys;
qtsetup.caption:=rsPrinterSetup;
Label1.caption:=rsRasterResolu;
Label4.caption:=StringReplace(rsCommandToUse,'.',':',[]);
Label5.caption:=rsSize;
Label6.caption:=rsPathToSaveTh;
Label8.Caption:=rsWidth;
Label9.caption:=Label4.caption;
Label10.caption:=rsPathToSaveTh;
Label11.Caption:=rsHeight;
printmode.caption:=rsPrintMethod;
printmode.Items[0]:=rsSystemPrinte;
printmode.Items[1]:=rsPostscript;
printmode.Items[2]:=rsBitmapFile;
Ok.Caption:=rsOK;
Cancel.Caption:=rsCancel;
Button1.caption:=rsHelp;
SetHelp(self,hlpMenuFile);
end;

procedure Tf_printsetup.FormShow(Sender: TObject);
begin
PaperSize.ItemIndex:=cm.Paper-1;
updprtsetup;
end;

procedure Tf_printsetup.updprtsetup;
var i:integer;
    ok:boolean;
begin
try
lockupd:=true;
if (cm.PrintMethod=0)and(Printer.PrinterIndex<0) then begin
  ShowMessage(rsNoPrinterFou);
  cm.PrintMethod:=2;
end;
case cm.PrintMethod of
0: begin
   printmode.ItemIndex:=0;
   bmpoption.Visible:=false;
   psoption.Visible:=false;
   printeroption.Visible:=true;
   GetPrinterResolution(cm.prtname,i);
   if i>75 then
      ResolWarning.Caption:=''
   else
      ResolWarning.Caption:=rsWarningLowRe;
   qtprintername.Caption:=cm.prtname;
   qtprintresol.Caption:=inttostr(i);
   end;
1: begin
   printmode.ItemIndex:=1;
   bmpoption.Visible:=false;
   psoption.Visible:=true;
   printeroption.Visible:=false;
   printcmd1.Text:=cm.PrintCmd1;
   savepath1.Directory:=SysToUTF8(cm.PrintTmpPath);
   prtres.Value:=cm.PrinterResolution;
   if cm.PrintCmd1='' then cmdreport1.text:=''
   else begin
     {$ifdef unix}
       ok:=(0=exec('which '+cm.PrintCmd1));
     {$endif}
     {$ifdef mswindows}
       ok:=Fileexists(cm.PrintCmd1);
     {$endif}
     if ok then begin
        cmdreport1.text:=rsCommandFound;
     end else begin
        cmdreport1.text:=rsCommandNotFo;
     end;
   end;
   end;
2: begin
   printmode.ItemIndex:=2;
   bmpoption.Visible:=true;
   psoption.Visible:=false;
   printeroption.Visible:=false;
   printcmd2.Text:=cm.PrintCmd2;
   savepath2.Text:=cm.PrintTmpPath;
   bmpw.Value:=cm.PrintBmpWidth;
   bmph.Value:=cm.PrintBmpHeight;
   if cm.PrintCmd2='' then cmdreport2.text:=''
   else begin
     {$ifdef unix}
       ok:=(0=exec('which '+cm.PrintCmd2));
     {$endif}
     {$ifdef mswindows}
       ok:=Fileexists(cm.PrintCmd2);
     {$endif}
     if ok then begin
        cmdreport2.text:=rsCommandFound;
     end else begin
        cmdreport2.text:=rsCommandNotFo;
     end;
   end;
   end;
end;
finally
lockupd:=false;
end;
end;

procedure Tf_printsetup.qtsetupClick(Sender: TObject);
begin
{$ifdef mswindows}
  PrinterSetupDialog1.execute;
{$endif}
{$ifdef unix}
  PrintDialog1.execute;
{$endif}
  updprtsetup;
end;

procedure Tf_printsetup.FormCreate(Sender: TObject);
var i: integer;
begin
ScaleDPI(Self);
SetLang;
PaperSize.Clear;
for i:=1 to PaperNumber do begin
   PaperSize.Items.Add(Papername[i]);
end;
end;

procedure Tf_printsetup.Button1Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_printsetup.bmpwChange(Sender: TObject);
begin
  cm.PrintBmpWidth := bmpw.Value;
end;

procedure Tf_printsetup.bmphChange(Sender: TObject);
begin
  cm.PrintBmpHeight := bmph.Value;
end;

procedure Tf_printsetup.PaperSizeChange(Sender: TObject);
begin
  cm.Paper:=PaperSize.ItemIndex+1;
end;

procedure Tf_printsetup.printmodeClick(Sender: TObject);
begin
cm.PrintMethod:=printmode.ItemIndex;
updprtsetup;
end;

procedure Tf_printsetup.prtresChange(Sender: TObject);
begin
if lockupd then exit;
cm.PrinterResolution:=prtres.value;
end;

////////// duplicate because of filenameedit onchange bug //////////////////////////
procedure Tf_printsetup.printcmd1Change(Sender: TObject);
begin
if lockupd then exit;
case cm.PrintMethod of
1: cm.PrintCmd1:=printcmd1.Text;
2: cm.PrintCmd2:=printcmd2.Text;
end;
updprtsetup;
end;

procedure Tf_printsetup.printcmd1AcceptFileName(Sender: TObject;
  var Value: String);
begin
if lockupd then exit;
case cm.PrintMethod of
1: cm.PrintCmd1:=value;
2: cm.PrintCmd2:=value;
end;
updprtsetup;
end;
//////////////////////////////////////////

procedure Tf_printsetup.savepathExit(Sender: TObject);
var buf: string;
begin
if lockupd then exit;
case cm.PrintMethod of
1: buf:=savepath1.Text;
2: buf:=savepath2.Text;
else buf:='';
end;
if DirectoryIsWritable(buf) then
   cm.PrintTmpPath:=buf
else
   ShowMessage(rsInvalidPath+buf);
end;

end.
