unit aavsob1;

{$MODE Delphi}

{
Copyright (C) 2005 Patrick Chevalley

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

interface

uses
//Shellapi,
{$ifdef mswindows}
  Windows,
{$endif}
  LCLIntf,  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, LResources, EditBtn, Fileutil, u_param, u_util2, Spin;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    DirectoryEdit1: TDirectoryEdit;
    FileNameEdit1: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SpinEdit1: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
  private
    Procedure ConvAAVSOb;
    Procedure GetAppDir;
  public
  end;

var
  Form1: TForm1;
  lpvlst,pulslst : array[1..1000] of string;
  nLPV,curvar : integer;

implementation

Procedure TForm1.GetAppDir;
var buf: string;
{$ifdef darwin}
    i: integer;
{$endif}
{$ifdef mswindows}
    PIDL : PItemIDList;
    Folder : array[0..MAX_PATH] of Char;
const CSIDL_PERSONAL = $0005;    // My Documents
      CSIDL_APPDATA  = $001a;   // <user name>\Application Data
      CSIDL_LOCAL_APPDATA = $001c;  // <user name>\Local Settings\Applicaiton Data (non roaming)
{$endif}
begin
{$ifdef darwin}
appdir:=getcurrentdir;
if not DirectoryExists(slash(appdir)+slash('data')+slash('varobs')) then begin
   appdir:=ExtractFilePath(ParamStr(0));
   i:=pos('.app/',appdir);
   if i>0 then begin
     appdir:=ExtractFilePath(copy(appdir,1,i));
   end;
end;
{$else}
appdir:=getcurrentdir;
GetDir(0,appdir);
{$endif}
privatedir:=DefaultPrivateDir;
configfile:=Defaultconfigfile;
{$ifdef unix}
appdir:=expandfilename(appdir);
privatedir:=expandfilename(PrivateDir);
configfile:=expandfilename(configfile);
{$endif}
{$ifdef mswindows}
SHGetSpecialFolderLocation(0, CSIDL_LOCAL_APPDATA, PIDL);
SHGetPathFromIDList(PIDL, Folder);
buf:=trim(Folder);
if buf='' then begin  // old windows version
   SHGetSpecialFolderLocation(0, CSIDL_APPDATA, PIDL);
   SHGetPathFromIDList(PIDL, Folder);
   buf:=trim(Folder);
end;
privatedir:=slash(buf)+privatedir;
configfile:=slash(privatedir)+configfile;
{$endif}
skychart:=slash(appdir)+DefaultSkychart;
if not FileExists(skychart) then skychart:=DefaultSkychart;
if not directoryexists(privatedir) then CreateDir(privatedir);
if not directoryexists(privatedir) then forcedirectory(privatedir);
if not directoryexists(privatedir) then begin
   MessageDlg('Unable to create '+privatedir,
             mtError, [mbAbort], 0);
   Halt;
end;
if not directoryexists(slash(privatedir)+'quicklook') then CreateDir(slash(privatedir)+'quicklook');
if not directoryexists(slash(privatedir)+'afoevdata') then CreateDir(slash(privatedir)+'afoevdata');

if (not directoryexists(slash(appdir)+slash('data')+'varobs')) then begin
  // try under the current directory
  buf:=GetCurrentDir;
  if (directoryexists(slash(buf)+slash('data')+'varobs')) then
     appdir:=buf
  else begin
     // try under the program directory
     buf:=ExtractFilePath(ParamStr(0));
     if (directoryexists(slash(buf)+slash('data')+'varobs')) then
        appdir:=buf
     else begin
         // try share directory under current location
         buf:=ExpandFileName(slash(GetCurrentDir)+SharedDir);
         if (directoryexists(slash(buf)+slash('data')+'varobs')) then
            appdir:=buf
         else begin
            // try share directory at the same location as the program
            buf:=ExpandFileName(slash(ExtractFilePath(ParamStr(0)))+SharedDir);
            if (directoryexists(slash(buf)+slash('data')+'varobs')) then
               appdir:=buf
            else begin
               MessageDlg('Could not found the application data directory.'+crlf
                   +'Please check the program installation.',
                   mtError, [mbAbort], 0);
               Halt;
            end;
         end;
     end;
  end;
end;

ConstDir:=slash(appdir)+slash('data')+slash('varobs');
end;


Function CleanMag(mag:string):string;
var i:integer;
    c:char;
begin
mag:=trim(mag);
result:='';
for i:=1 to length(mag) do begin
  c:=mag[i];
  if ((c>='0')and(c<='9'))or(c='.')or((i=1)and(c='-')) then result:=result+c;
end;
while length(result)<5 do result:=' '+result;
end;

Function CleanDat(dat:string):string;
begin
result:=stringreplace(dat,'|','',[rfReplaceAll]);
result:=stringreplace(result,'+','',[rfReplaceAll]);
result:=stringreplace(result,'-','',[rfReplaceAll]);
result:=stringreplace(result,' ','',[rfReplaceAll]);
end;

Procedure GetGCVSInfo(nom : string; var vartype,per,slope,jdt : string);
var f : textfile;
    buf,id1,id2,constel : string;
    p : integer;
begin
vartype:='          ';
per:='         ';
slope:='   ';
jdt:='             ';
buf:=trim(nom);
p:=pos(' ',buf);
id1:=uppercase(copy(buf,1,p-1));
constel:=copy(buf,p+1,99);
if constel='*' then exit;
constel:=stringreplace(constel,'?','',[]);
buf:=slash(form1.DirectoryEdit1.Directory)+constel+'.dat';
if not fileexists(buf) then exit;
assignfile(f,buf);
reset(f);
repeat
  readln(f,buf);
  id2:=trim(uppercase(copy(buf,1,5)));
  if (copy(id2,1,1)='V')and(length(id2)=5) then begin
     id2:='V'+inttostr(strtoint(copy(id2,2,4)));
  end;
  if id1=id2 then begin
     vartype:=copy(buf,12,10);
     per:=copy(buf,52,15);
     slope:=copy(buf,69,3);
     jdt:=copy(buf,37,13);
     break;
  end;
until eof(f);
closefile(f);
end;

Procedure Tform1.ConvAAVSOb;
var fb,f : textfile;
    buf,design,nom,mag,dat,mag1,mag2,datm,vartype,jdt,per,slope,puls,v1,p1,j1 : string;
    i,n,p,year1,year,mois,jour : integer;
    jdm : double;
begin
i:=0;
n:=1;
year1:=SpinEdit1.Value;
buf:=FileNameEdit1.FileName;
assignfile(fb,buf);
reset(fb);
buf:=slash(privatedir)+'aavso'+inttostr(year1)+'.dat';
assignfile(f,buf);
rewrite(f);
try
repeat
 inc(i);
 label3.caption:='Progress: '+inttostr(i);
 application.processmessages;
 readln(fb,buf);
 design:=copy(buf,7,8);
 if (trim(design)='')or(design='DESIGN. ')or(design='--------') then continue;
 nom:=copy(buf,16,9);
 mag:=copy(buf,28,11);
 dat:=copy(buf,40,999);
 p:=pos('-',mag);
 mag1:=cleanmag(copy(mag,1,p-1));
 mag2:=cleanmag(copy(mag,p+1,99));
 p:=pos('M',dat);
 if p<=0 then continue;
 p:=p-2;
 datm:=cleandat(copy(dat,p,2));
 jour:=strtoint(datm);
 if length(datm)=1 then p:=p+1;
 mois:=1+( (p-2) div 6 );
 year:=year1;
 if mois>12 then begin
    mois:=mois-12;
    year:=year+1;
 end;
 jdm:=jd(year,mois,jour,12);
 str(jdm:10:1,jdt);
 GetGCVSinfo(nom,vartype,per,slope,j1);
 puls:=nom+', '+vartype+', '+mag1+', '+mag2+', '+jdt+', '+per+', '+slope+', '+design;
 writeln(f,puls);
 lpvlst[n]:=trim(design);
 pulslst[n]:=puls;
 inc(n);
until eof(fb);
nLPV:=n-1;
closefile(f);
closefile(fb);
label3.caption:='Finished';
except
showmessage('Error for line :'+buf);
raise;
end;
end;

Function IsLPV(design : string):boolean;
var i : integer;
begin
result:=false;
design:=trim(design);
for i:=1 to nLPV do begin
  if design=lpvlst[i] then begin
     curvar:=i;
     result:=true;
     break;
  end;
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
screen.cursor:=crhourglass;
try
convaavsob;
finally
screen.cursor:=crdefault;
end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
GetAppDir;
OpenFileCmd:=DefaultOpenFileCMD;
DirectoryEdit1.Directory:=slash(appdir)+slash('data')+slash('varobs');
SpinEdit1.Text:=formatdatetime('yyyy',now);
FileNameEdit1.FileName:=slash(privatedir)+'BULLET'+formatdatetime('yy',now)+'.TXT';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
decimalseparator:='.';
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
Executefile(label7.Caption);
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
FileNameEdit1.FileName:=slash(privatedir)+'BULLET'+copy(SpinEdit1.text,3,2)+'.TXT';
end;

initialization
  {$i aavsob1.lrs}

end.
