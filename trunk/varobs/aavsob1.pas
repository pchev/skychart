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
  LCLIntf, Shellapi, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, LResources;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Button2: TButton;
    UpDown1: TUpDown;
    Label7: TLabel;
    Label8: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label7Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  lpvlst,pulslst : array[1..1000] of string;
  nLPV,curvar : integer;

implementation


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

Function CleanPer(dat:string):string;
var n : integer;
    x : single;
begin
result:=stringreplace(dat,':',' ',[rfReplaceAll]);
result:=stringreplace(result,'/N',' ',[rfReplaceAll]);
result:=stringreplace(result,'(',' ',[rfReplaceAll]);
result:=stringreplace(result,')',' ',[rfReplaceAll]);
result:=stringreplace(result,'+',' ',[rfReplaceAll]);
result:=stringreplace(result,'*',' ',[rfReplaceAll]);
result:=stringreplace(result,'?',' ',[rfReplaceAll]);
result:=stringreplace(result,'<',' ',[rfReplaceAll]);
val(result,x,n);
if n<>0 then result:=' ';
end;

function Jd(annee,mois,jour :INTEGER; Heure:double):double;
 VAR siecle,cor:INTEGER ;
 begin
    if mois<=2 then begin
      annee:=annee-1;
      mois:=mois+12;
    end ;
    if annee*10000+mois*100+jour >= 15821015 then begin
       siecle:=annee div 100;
       cor:=2 - siecle + siecle div 4;
    end else cor:=0;
    jd:=int(365.25*(annee+4716))+int(30.6001*(mois+1))+jour+cor-1524.5 +heure/24;
END ;

Function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil, StrPCopy(zFileName, FileName),
                         StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
end;

Procedure GetValInfo(var f : textfile; design : string; var nom,vartype,per : string);
var buf : string;
begin
vartype:=' ';
per:=' ';
reset(f);
repeat
  readln(f,buf);
  if copy(buf,1,8)=design then begin
    nom:=copy(buf,11,10);
    vartype:=copy(buf,23,10);
    per:=copy(buf,48,8);
    break;
  end;
until eof(f);
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
buf:=form1.edit3.text+constel+'.dat';
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

Procedure ConvAAVSOb;
var fb,fv,f : textfile;
    buf,design,nom,mag,dat,mag1,mag2,datm,vartype,jdt,per,slope,puls,v1,p1,j1 : string;
    i,n,p,year1,year,mois,jour : integer;
    jdm : double;
begin
i:=0;
n:=1;
year1:=strtoint(form1.edit1.text);
buf:=form1.edit2.text;
assignfile(fb,buf);
reset(fb);
buf:=form1.edit4.text;
assignfile(fv,buf);
reset(fv);
buf:='aavso'+inttostr(year1)+'.txt';
assignfile(f,buf);
rewrite(f);
try
repeat
 inc(i);
 form1.label3.caption:=inttostr(i);
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
 GetValInfo(fv,design,nom,vartype,per);
 GetGCVSinfo(nom,v1,p1,slope,j1);
 if trim(vartype)='' then vartype:=v1;
 if trim(per)='' then per:=p1;
 puls:=nom+', '+vartype+', '+mag1+', '+mag2+', '+jdt+', '+per+', '+slope+', '+design;
 writeln(f,puls);
 lpvlst[n]:=trim(design);
 pulslst[n]:=puls;
 inc(n);
until eof(fb);
nLPV:=n-1;
closefile(f);
closefile(fv);
closefile(fb);
form1.label3.caption:='Finished';
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

procedure ConvAAVSOval;
var fv,f : textfile;
    buf,design,nom,mag,mag1,mag2,vartype,jdt,per,slope,puls,v1,p1 : string;
    i,p : integer;
begin
i:=0;
buf:=form1.edit4.text;
assignfile(fv,buf);
reset(fv);
readln(fv,buf);
buf:='aavsoval.txt';
assignfile(f,buf);
rewrite(f);
try
repeat
 inc(i);
 form1.label3.caption:=inttostr(i);
 application.processmessages;
 readln(fv,buf);
 design:=copy(buf,1,8);
 if (trim(design)='')or(design[1]='*') then break;
 if IsLPV(design) then puls:=pulslst[curvar]
 else begin
 vartype:=copy(buf,22,8);
 per:=cleanper(copy(buf,48,8));
 nom:=copy(buf,11,10);
 mag:=trim(copy(buf,30,17));
 p:=pos('-',copy(mag,2,99));
 if p>0 then begin
    p:=p+1;
    mag1:=cleanmag(copy(mag,1,p-1));
    mag2:=cleanmag(copy(mag,p+1,99))
 end else begin
    mag:=trim(mag);
    p:=pos(' ',mag);
    if p>0 then begin
       mag1:=cleanmag(copy(mag,1,p-1));
       mag2:=cleanmag(copy(mag,p+1,99))
    end else begin
       mag1:=cleanmag(mag);
       mag2:='';
    end;
 end;
 GetGCVSinfo(nom,v1,p1,slope,jdt);
 if trim(vartype)='' then vartype:=v1;
 if trim(per)='' then per:=p1;
 puls:=nom+', '+vartype+', '+mag1+', '+mag2+', '+jdt+', '+per+', '+slope+', '+design;
 end;
 writeln(f,puls);
until eof(fv);
closefile(f);
closefile(fv);
form1.label3.caption:='Finished';
except
showmessage('Error for line :'+buf);
raise;
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
screen.cursor:=crhourglass;
try
convaavsob;
convaavsoval;
finally
screen.cursor:=crdefault;
end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
edit3.text:=getcurrentdir+'\const\';
edit1.text:=formatdatetime('yyyy',now);
edit2.text:='bulletin'+formatdatetime('yy',now)+'.txt';
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
if length(edit1.text)=4 then edit2.text:='bulletin'+copy(edit1.text,3,2)+'.txt';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
decimalseparator:='.';
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
Executefile('http://www.aavso.org/observing/aids/','','',SW_SHOWNOACTIVATE);
end;

initialization
  {$i aavsob1.lrs}

end.
