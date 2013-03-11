unit convconstlUnit1;
{
Copyright (C) 2002 Patrick Chevalley

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
{
 Build Constellation Figure file.
}

interface

uses libcatalog, FileCtrl, Registry,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask,  ComCtrls;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    BitBtn2: TBitBtn;
    GroupBox3: TGroupBox;
    CheckBox1: TCheckBox;
    ProgressBar1: TProgressBar;
    FilenameEdit1: TEdit;
    FilenameEdit2: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

VAR  BSCpath, appdir, backuppath : string;

procedure TForm1.BitBtn1Click(Sender: TObject);
type tconstl = record ar1,de1,ar2,de2 : double; end;
var fi : textfile;
    fo : textfile;
    buf,c,h1,h2 : string;
    r : tconstl;
    h : integer;
    ar,de : double;
    ok : boolean;
    msg : array[0..99]of char;
begin
chdir(appdir);
if checkbox1.checked then begin
   forcedirectories(backuppath);
   buf:=backuppath+extractfilename(filenameedit2.text)+'.'+trim(formatdatetime('yyyymmddhhnnss',now));
   if not copyfile(pchar(filenameedit2.text),pchar(buf),false) then begin
      H:=getlasterror;
      formatmessage(FORMAT_MESSAGE_FROM_SYSTEM,nil,H,0,addr(msg[0]),99,nil);
      showmessage('Backup file :'+chr(10)+chr(13)+msg);
      exit;
   end;
end;
assignfile(fi,filenameedit1.text);
reset(fi);
assignfile(fo,filenameedit2.text);
rewrite(fo);
ProgressBar1.min:=0;
ProgressBar1.max:=filesize(fi);
ProgressBar1.position:=0;
try
bitbtn1.enabled:=false;
bitbtn2.enabled:=false;
setbscpath(bscpath);
repeat
  readln(fi,buf);
  ProgressBar1.position:=filepos(fi);
  application.processmessages;
  if trim(buf)='' then continue;
  if copy(buf,1,1)=';' then continue;
  c:=copy(buf,1,3);
  h1:=trim(copy(buf,6,5));
  h2:=trim(copy(buf,13,5));
  h:= strtoint(h1);
  findnumhr(h,ar,de,ok);
  if not ok then raise exception.create('Star HR'+h1+' not found. Line in error : '+buf);
  r.ar1:=ar;
  r.de1:=de;
  h:= strtoint(h2);
  findnumhr(h,ar,de,ok);
  if not ok then raise exception.create('Star HR'+h2+' not found. Line in error : '+buf);
  r.ar2:=ar;
  r.de2:=de;
  writeln(fo,format('%8.5f %8.4f %8.5f %8.4f',[r.ar1,r.de1,r.ar2,r.de2]));
until eof(fi);
closefile(fi);
closefile(fo);
bitbtn1.enabled:=true;
bitbtn2.enabled:=true;
form1.close;
except
closefile(fi);
closefile(fo);
bitbtn1.enabled:=true;
bitbtn2.enabled:=true;
raise;
end
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
AppDir:=trim(GetCurrentDir);
bscpath:='cat\bsc5';
if copy(AppDir,length(Appdir),1)='\' then Appdir:=copy(AppDir,1,length(Appdir)-1);
backuppath:=expandfilename(bscpath+'\backup\');
filenameedit1.Text:=bscpath+'\DefaultConstL.txt';
filenameedit2.Text:=bscpath+'\ConstL.dat';
end;

end.
