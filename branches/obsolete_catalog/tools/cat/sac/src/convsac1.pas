unit convsac1;

{$MODE Delphi}

interface

uses
  math,StrUtils,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, LResources;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;
Type
SACrec = record
            ar,de,ma,sbr,s1,s2 : single;
            pa : byte;
            nom1 : string[17];
            nom2 : string[18];
            typ,cons  : string[3];
            desc : string[120];
            clas : string[11];
         end;
var
  Form1: TForm1;

implementation

const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

blank14 : array [1..14] of char = '              ';

var
   F: textfile;
   fb : file of sacrec;
   out : sacrec;
   inp : array[0..20000] of sacrec;
   nl : integer;
   pathi,patho : string;

Procedure FindRegion(ar,de : double; var lg : integer);
var i1,i2,N,L1 : integer;
begin
i1 := Trunc((de+90)/30) ;
N  := lg_reg_x[i1,1];
L1 := lg_reg_x[i1,2];
i2 := Trunc(ar/(360/N));
Lg := L1+i2;
end;

Function PadZeros(x : string ; l :integer) : string;
const zero = '000000000000';
var p : integer;
begin
x:=trim(x);
p:=l-length(x);
result:=copy(zero,1,p)+x;
end;

function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

function nextword(var inl : string): string;
var p : integer;
    buf : string;
begin
p:=pos('"',inl);
buf:=copy(inl,p+1,9999);
p:=pos('"',buf);
result:=copy(buf,1,p-1);
inl:=copy(buf,p+1,9999);
end;

Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

procedure Lecture;
var i,p :integer;
    buf,lin : string;
    sdec : single;
    ss1,ss2,desc : shortstring;
    s : textfile;
const blanc='                                                                  ';
begin
assignfile(s,'size.txt');
rewrite(s);
Assignfile(F,pathi);
Reset(F);
// header line
Readln(F,lin);
i:=0;
repeat
  inc(i);
  Readln(F,lin);
if (i mod 100)=0 then form1.Edit3.Text:=inttostr(i);
Application.ProcessMessages;
  ss1:=trim(nextword(lin))+blanc;
  ss2:=trim(nextword(lin))+blanc;
  if copy(ss2,1,2)='M ' then begin
     out.nom1:=ss2;
     out.nom2:=ss1;
  end else begin
     out.nom1:=ss1;
     out.nom2:=ss2;
  end;
  buf:=trim(nextword(lin));
  out.typ:='   ';
  if buf='ASTER' then out.typ:='Ast';
  if buf='BRTNB' then out.typ:=' Nb';
  if buf='CL+NB' then out.typ:='C+N';
  if buf='DRKNB' then out.typ:='Drk';
  if buf='GALCL' then out.typ:='Gcl';
  if buf='GALXY' then out.typ:=' Gx';
  if buf='GLOCL' then out.typ:=' Gb';
  if buf='GX+DN' then out.typ:=' Nb';
  if buf='GX+GC' then out.typ:=' Gc';
  if buf='G+C+N' then out.typ:='C+N';
  if buf='LMCCN' then out.typ:='C+N';
  if buf='LMCDN' then out.typ:=' Nb';
  if buf='LMCGC' then out.typ:=' Gb';
  if buf='LMCOC' then out.typ:=' OC';
  if buf='NONEX' then out.typ:='  -';
  if buf='OPNCL' then out.typ:=' OC';
  if buf='PLNNB' then out.typ:=' Pl';
  if buf='SMCCN' then out.typ:='C+N';
  if buf='SMCDN' then out.typ:=' Nb';
  if buf='SMCGC' then out.typ:=' Gb';
  if buf='SMCOC' then out.typ:=' OC';
  if buf='SNREM' then out.typ:=' Nb';
  if buf='QUASR' then out.typ:=' Gx';
  if buf='UVSOB' then out.typ:='  ?';
  if copy(buf,2,4)='STAR'  then out.typ:='Ast';
  if buf='1STAR' then out.typ:='  *';
  if buf='2STAR' then out.typ:=' D*';
  if buf='3STAR' then out.typ:='***';
  out.cons:=trim(nextword(lin))+blanc;
  buf:=trim(nextword(lin));
  out.ar:=15*(strtofloat(copy(buf,1,2))+strtofloat(copy(buf,4,4))/60);
  buf:=trim(nextword(lin));
  sdec:=strtofloat(copy(buf,1,1)+'1');
  out.de:=strtofloat(copy(buf,2,2));
  out.de:=out.de+strtofloat(copy(buf,5,2))/60;
  out.de:=sdec*out.de;
  buf :=copy(nextword(lin),1,4);
  out.ma:=strtofloat(buf);
  if out.ma>90 then out.ma:=99.0;
  buf:=trim(nextword(lin));
  if buf='' then out.sbr:=99.0
            else out.sbr:=strtofloat(buf);
  if out.sbr>90 then out.sbr:=99.0;
  buf:=trim(nextword(lin));        // U2K
  buf:=trim(nextword(lin));        // TI
  buf:=nextword(lin);
  ss1:=StringReplace(copy(buf,1,7),'<','',[rfReplaceAll]);
  ss1:=trim(StringReplace(ss1,'?','',[rfReplaceAll]));
  if ss1='' then out.s1:=0
  else case buf[8] of
     'd' : out.s1:=strtofloat(ss1)*60;
     'm' : out.s1:=strtofloat(ss1);
     's' : out.s1:=strtofloat(ss1)/60;
     else showmessage('erreur s1 '+buf+'  '+inttostr(i));
  end;
  buf:=nextword(lin);
  ss1:=StringReplace(copy(buf,1,7),'<','',[rfReplaceAll]);
  ss1:=trim(StringReplace(ss1,'?','',[rfReplaceAll]));
  if ss1='' then out.s2:=out.s1
  else case buf[8] of
     'd' : out.s2:=strtofloat(ss1)*60;
     'm' : out.s2:=strtofloat(ss1);
     's' : out.s2:=strtofloat(ss1)/60;
     else showmessage('erreur s2 '+buf+'  '+inttostr(i));
  end;
{  buf:=replacestr(trim(nextword(lin)),'<','');
  p:=pos('''',buf);
  if p=0 then begin
     out.s1:=0;
     out.s2:=0;
  end else begin
  out.s1:=strtofloat(copy(buf,1,p-1));
  if copy(buf,p+1,1)='''' then begin
     buf:=copy(buf,p+2,99);
     out.s1:=out.s1/60;
  end else begin
     buf:=copy(buf,p+1,99);
  end;
  if copy(buf,1,1)='X' then begin
     buf:=copy(buf,2,99);
     p:=pos('''',buf);
     out.s2:=strtofloat(copy(buf,1,p-1));
     if copy(buf,p+1,1)='''' then out.s2:=out.s2/60;
  end else out.s2:=out.s1;
  end; }
  buf:=trim(nextword(lin));
  if buf='' then out.pa:=255
            else out.pa:=strtoint(buf);
  buf:=trim(nextword(lin));
  out.clas:=copy(buf,1,10);
  buf:=trim(nextword(lin));
  buf:=trim(nextword(lin));
  buf:=trim(nextword(lin));
  desc:=trim(nextword(lin));
  buf:=trim(nextword(lin));
  writeln(s,length(buf+desc));
  desc:=desc+';'+buf+blanc;
  out.desc:=desc;
{  if copy(buf,1,2)='PA' then begin
     p:=pos(',',buf);
     if p=0 then p:=999;
     val(copy(buf,3,p-3),out.pa,p);
     if p>0 then out.pa:=255;
  end else out.pa:=255;}
  inp[i]:=out;
until eof(F);
Close(F);
Close(s);
nl:=i;
form1.Edit3.Text:=inttostr(i);
Application.ProcessMessages;
end;

procedure wrt_lg(lgnum:integer);
var i,n,zone :integer;
    ar,de : double;
begin
assignfile(fb,patho+PathDelim+padzeros(inttostr(lgnum),2)+'.dat');
Rewrite(fb);
i:=0;
for n:=1 to nl do begin
  out:=inp[n];
  ar:=out.ar;
  de:=out.de;
  findregion(ar,de,zone);
  if zone=lgnum then begin
  inc(i);
  write(fb,out);
  if (i mod 100)=0 then begin
     form1.Edit3.Text:=inttostr(i);
     Form1.Update;
  end;
  end;
end;
form1.Edit3.Text:=inttostr(i);
Application.ProcessMessages;
close(fb);
end;

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
ForceDirectories(patho);
Lecture;
for lgnum:=1 to 50 do begin
  Edit1.Text:=inttostr(lgnum);
  wrt_lg(lgnum);
end;
end;

initialization
  {$i convsac1.lrs}

end.
