unit pu_printsetup;

{$MODE Delphi}{$H+}

{
Copyright (C) 2004 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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
{
 Printer setup form for Windows VCL application
}

interface

uses u_help, u_translation, u_constant, u_util, FileUtil,
  SysUtils, Types, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Printers, ExtCtrls, enhedits, Buttons,
  LResources, PrintersDlgs, EditBtn, LazHelpHTML;

type

  { Tf_printsetup }

  Tf_printsetup = class(TForm)
    Button1: TButton;
    Label5: TLabel;
    PaperSize: TComboBox;
    printcmd: TFileNameEdit;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    savepath: TDirectoryEdit;
    printmode: TRadioGroup;
    qtoption: TPanel;
    customoption: TPanel;
    qtsetup: TButton;
    qtprintername: TLabel;
    qtprintresol: TLabel;
    Ok: TButton;
    Cancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    prtres: TLongEdit;
    cmdreport: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaperSizeChange(Sender: TObject);
    procedure printcmdAcceptFileName(Sender: TObject; var Value: String);
    procedure qtsetupClick(Sender: TObject);
    procedure printmodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure prtresChange(Sender: TObject);
    procedure printcmdChange(Sender: TObject);
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

procedure Tf_printsetup.SetLang;
begin
Caption:=rsPrinterSetup;
Label2.caption:=rsPrinter;
Label3.caption:=rsResolution;
Label7.caption:=rsSelectTheSys;
qtsetup.caption:=rsPrinterSetup;
Label1.caption:=rsRasterResolu;
Label4.caption:=rsCommandToUse;
Label5.caption:=rsSize;
Label6.caption:=rsPathToSaveTh;
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
  cm.PrintMethod:=1;
end;
case cm.PrintMethod of
0: begin
   printmode.ItemIndex:=0;
   customoption.Visible:=false;
   qtoption.Visible:=true;
   GetPrinterResolution(cm.prtname,i);
   qtprintername.Caption:=cm.prtname;
   qtprintresol.Caption:=inttostr(i);
   end;
1: begin
   printmode.ItemIndex:=1;
   customoption.Visible:=true;
   qtoption.Visible:=false;
   printcmd.Text:=cm.PrintCmd1;
   savepath.Directory:=SysToUTF8(cm.PrintTmpPath);
   prtres.Value:=cm.PrinterResolution;
   if cm.PrintCmd1='' then cmdreport.text:=''
   else begin
     {$ifdef unix}
       ok:=(0=exec('which '+cm.PrintCmd1));
     {$endif}
     {$ifdef mswindows}
       ok:=Fileexists(cm.PrintCmd1);
     {$endif}
     if ok then begin
        cmdreport.text:=rsCommandFound;
     end else begin
        cmdreport.text:=rsCommandNotFo;
     end;
   end;
   end;
2: begin
   printmode.ItemIndex:=2;
   customoption.Visible:=true;
   qtoption.Visible:=false;
   printcmd.Text:=cm.PrintCmd2;
   savepath.Text:=cm.PrintTmpPath;
   prtres.Value:=cm.PrinterResolution;
   if cm.PrintCmd2='' then cmdreport.text:=''
   else begin
     {$ifdef unix}
       ok:=(0=exec('which '+cm.PrintCmd2));
     {$endif}
     {$ifdef mswindows}
       ok:=Fileexists(cm.PrintCmd2);
     {$endif}
     if ok then begin
        cmdreport.text:=rsCommandFound;
     end else begin
        cmdreport.text:=rsCommandNotFo;
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
procedure Tf_printsetup.printcmdChange(Sender: TObject);
begin
if lockupd then exit;
case cm.PrintMethod of
1: cm.PrintCmd1:=printcmd.Text;
2: cm.PrintCmd2:=printcmd.Text;
end;
updprtsetup;
end;
procedure Tf_printsetup.printcmdAcceptFileName(Sender: TObject;
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
begin
if lockupd then exit;
if DirectoryIsWritable(savepath.Text) then
   cm.PrintTmpPath:=savepath.Text
else
   ShowMessage(rsInvalidPath+savepath.Text);
end;

initialization
  {$i pu_printsetup.lrs}

end.
