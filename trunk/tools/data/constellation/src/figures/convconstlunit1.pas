unit convconstlUnit1;

{$MODE Delphi}

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

uses FileCtrl, Registry,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MaskEdit,  ComCtrls, FileUtil;

type

  { TConvForm }

  TConvForm = class(TForm)
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    BitBtn2: TBitBtn;
    FilenameEdit1: TEdit;
    FilenameEdit2: TEdit;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    hr: array[1..10000,1..2] of double;
    procedure getHR;
  public
    { Public declarations }
  end;

var
  ConvForm: TConvForm;

implementation

{$R *.lfm}

function copyp(t1: string; First, last: integer): string;
begin
  Result := copy(t1, First, last - First + 1);
end;

procedure TConvForm.getHR;
var
  bsc: textfile;
  buf: string;
  ar,de,des : double;
  n: integer;
begin
  AssignFile(bsc, 'bsc_catalog.dat');
  reset(bsc);
  n:=0;
  while not EOF(bsc) do
  begin
    readln(bsc, buf);
    inc(n);
    ar := strtofloatdef(trim(copyp(buf, 76, 77)),0)+
          strtofloatdef(trim(copyp(buf, 78, 79)),0)/60+
          strtofloatdef(trim(copyp(buf, 80, 83)),0)/3600;
    des:= strtofloatdef(trim(copyp(buf, 84, 84))+'1',1);
    de := strtofloatdef(trim(copyp(buf, 85, 86)),0)+
          strtofloatdef(trim(copyp(buf, 87, 88)),0)/60+
          strtofloatdef(trim(copyp(buf, 89, 90)),0)/3600;
    de := de * des;
    hr[n,1]:=ar;
    hr[n,2]:=de;
  end;
  closefile(bsc);
end;


procedure TConvForm.BitBtn1Click(Sender: TObject);
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
label1.Caption:='';
Application.ProcessMessages;
assignfile(fi,filenameedit1.text);
reset(fi);
assignfile(fo,filenameedit2.text);
rewrite(fo);
try
getHR;
repeat
  readln(fi,buf);
  application.processmessages;
  if trim(buf)='' then continue;
  if copy(buf,1,1)=';' then continue;
  c:=copy(buf,1,3);
  h1:=trim(copy(buf,6,5));
  h2:=trim(copy(buf,13,5));
  h:= strtoint(h1);
  r.ar1:=hr[h,1];
  r.de1:=hr[h,2];
  h:= strtoint(h2);
  r.ar2:=hr[h,1];
  r.de2:=hr[h,2];
  writeln(fo,format('%8.5f %8.4f %8.5f %8.4f',[r.ar1,r.de1,r.ar2,r.de2]));
until eof(fi);
closefile(fi);
closefile(fo);
label1.Caption:='Completed!';
except
 closefile(fi);
 closefile(fo);
 raise;
end
end;

procedure TConvForm.BitBtn2Click(Sender: TObject);
begin
Close;
end;

procedure TConvForm.FormShow(Sender: TObject);
begin
label1.Caption:='';
filenameedit1.Text:='DefaultConstL.txt';
filenameedit2.Text:='DefaultConstL.cln';
end;

end.
