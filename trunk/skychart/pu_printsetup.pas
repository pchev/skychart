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

uses u_constant, u_util,
  SysUtils, Types, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Printers, ExtCtrls, enhedits, Buttons,
  LResources, PrintersDlgs, EditBtn;

type

  { Tf_printsetup }

  Tf_printsetup = class(TForm)
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
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure qtsetupClick(Sender: TObject);
    procedure printmodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure prtresChange(Sender: TObject);
    procedure printcmdChange(Sender: TObject);
    procedure savepathChange(Sender: TObject);
  private
    { Private declarations }
    lockupd: boolean;
    procedure updprtsetup;
  public
    { Public declarations }
    cm: conf_main;
  end;

var
  f_printsetup: Tf_printsetup;

implementation



procedure Tf_printsetup.FormShow(Sender: TObject);
begin
updprtsetup;
end;

procedure Tf_printsetup.updprtsetup;
var i:integer;
    ok:boolean;
begin
try
lockupd:=true;
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
   savepath.Text:=cm.PrintTmpPath;
   prtres.Value:=cm.PrinterResolution;
   if cm.PrintCmd1='' then cmdreport.text:=''
   else begin
     {$ifdef unix}
       ok:=(0=exec('which '+cm.PrintCmd1));
     {$endif}
     {$ifdef win32}
       ok:=Fileexists(cm.PrintCmd1);
     {$endif}
     if ok then begin
        cmdreport.text:='Command found OK.';
     end else begin
        cmdreport.text:='Command not found!';
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
     {$ifdef win32}
       ok:=Fileexists(cm.PrintCmd2);
     {$endif}
     if ok then begin
        cmdreport.text:='Command found OK.';
     end else begin
        cmdreport.text:='Command not found!';
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
{$ifdef win32}
  PrinterSetupDialog1.execute;
{$endif}
{$ifdef unix}
  PrintDialog1.execute;
{$endif}
  updprtsetup;
end;

procedure Tf_printsetup.FormCreate(Sender: TObject);
begin
{$ifdef win32}
 ScaleForm(self,Screen.PixelsPerInch/96);
{$endif}
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

procedure Tf_printsetup.printcmdChange(Sender: TObject);
begin
if lockupd then exit;
case cm.PrintMethod of
1: cm.PrintCmd1:=printcmd.Text;
2: cm.PrintCmd2:=printcmd.Text;
end;
updprtsetup;
end;

procedure Tf_printsetup.savepathChange(Sender: TObject);
begin
if lockupd then exit;
cm.PrintTmpPath:=savepath.Text;
end;

initialization
  {$i pu_printsetup.lrs}

end.
