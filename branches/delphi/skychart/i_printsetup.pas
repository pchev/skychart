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
 Printer setup common code
}

procedure Tf_printsetup.FormShow(Sender: TObject);
begin
updprtsetup;
prtcolor.ItemIndex:=cm.PrintColor;
if cm.PrintLandscape then prtorient.ItemIndex:=1
                     else prtorient.ItemIndex:=0;
end;

procedure Tf_printsetup.updprtsetup;
var i:integer;
    ok:boolean;
begin
case cm.PrintMethod of
0: begin
   printmode.ItemIndex:=0;
   if cm.PrintColor=2 then begin
      cm.PrintColor:=0;
      prtcolor.ItemIndex:=cm.PrintColor;
   end;
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
   {$ifdef linux}
     ok:=(0=exec('which pnmtops'));
   {$endif}
   {$ifdef mswindows}
     ok:=Fileexists(slash(appdir)+'plugins\bmptops.bat');
   {$endif}
   if ok then begin
      cmdreport.text:='Netpbm package OK.';
   end else begin
      cmdreport.text:='Please install Netpbm package.';
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
     {$ifdef linux}
       ok:=(0=exec('which '+cm.PrintCmd2));
     {$endif}
     {$ifdef mswindows}
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
end;

procedure Tf_printsetup.qtsetupClick(Sender: TObject);
begin
{$ifdef linux}
  Printer.executesetup;
{$endif}
{$ifdef mswindows}
  PrintDialog1.execute;
{$endif}
updprtsetup;
end;

procedure Tf_printsetup.printmodeClick(Sender: TObject);
begin
cm.PrintMethod:=printmode.ItemIndex;
updprtsetup;
end;

procedure Tf_printsetup.prtresChange(Sender: TObject);
begin
cm.PrinterResolution:=prtres.value;
end;

procedure Tf_printsetup.printcmdChange(Sender: TObject);
begin
case cm.PrintMethod of
1: cm.PrintCmd1:=printcmd.Text;
2: cm.PrintCmd2:=printcmd.Text;
end;
updprtsetup;
end;

procedure Tf_printsetup.savepathChange(Sender: TObject);
begin
cm.PrintTmpPath:=savepath.Text;
end;

procedure Tf_printsetup.prtcolorClick(Sender: TObject);
begin
if (cm.PrintMethod=0)and(prtcolor.ItemIndex=2) then prtcolor.ItemIndex:=0;
cm.PrintColor:=prtcolor.ItemIndex;
end;

procedure Tf_printsetup.prtorientClick(Sender: TObject);
begin
cm.PrintLandscape:=(prtorient.ItemIndex=1);
end;

procedure Tf_printsetup.savepathselClick(Sender: TObject);
begin
{$ifdef mswindows}
  FolderDialog1.Directory:=savepath.Text;
  if FolderDialog1.execute then
     savepath.Text:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=savepath.Text;
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     savepath.Text:=f_directory.DirectoryTreeView1.Directory;
{$endif}
end;

procedure Tf_printsetup.printcmdselClick(Sender: TObject);
var f : string;
begin
f:=expandfilename(printcmd.Text);
opendialog1.InitialDir:=extractfilepath(f);
opendialog1.filename:=extractfilename(f);
opendialog1.Filter:='All Files|*.*';
opendialog1.DefaultExt:='';
try
if opendialog1.execute then begin
   printcmd.Text:=opendialog1.FileName;
end;
finally
 chdir(appdir);
end;
end;
