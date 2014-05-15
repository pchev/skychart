program convsac;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils, Classes, Math;

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

filixr = packed record n: smallint;
                r: integer;
                key: array[1..18] of char; 
         end;


const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

const blanc='                                                                  ';

var
   F: textfile;
   fb : file of sacrec;
   fo   : file of filixr;
   out : sacrec;
   inp : array[0..20000] of sacrec;
   ixr : array[1..100000] of filixr;
   nl,nixr : integer;
   pathi,patho : string;
   lgnum : integer;
   mcount,ngccount,iccount: integer;

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

procedure ReadData;
var i :integer;
    buf,lin : string;
    sdec : single;
    ss1,ss2,desc : shortstring;
{$ifdef test_desc_size}
    s : textfile;
{$endif}
begin
{$ifdef test_desc_size}
assignfile(s,'size.txt');
rewrite(s);
{$endif}
Assignfile(F,pathi);
Reset(F);
// header line
Readln(F,lin);
i:=0;
repeat
  inc(i);
  Readln(F,lin);
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
     else writeln('erreur s1 '+buf+'  '+inttostr(i));
  end;
  buf:=nextword(lin);
  ss1:=StringReplace(copy(buf,1,7),'<','',[rfReplaceAll]);
  ss1:=trim(StringReplace(ss1,'?','',[rfReplaceAll]));
  if ss1='' then out.s2:=out.s1
  else case buf[8] of
     'd' : out.s2:=strtofloat(ss1)*60;
     'm' : out.s2:=strtofloat(ss1);
     's' : out.s2:=strtofloat(ss1)/60;
     else writeln('erreur s2 '+buf+'  '+inttostr(i));
  end;
  buf:=trim(nextword(lin));
  if buf='' then out.pa:=255
            else out.pa:=strtoint(buf);
  buf:=trim(nextword(lin))+blanc;
  out.clas:=copy(buf,1,11);
  buf:=trim(nextword(lin));
  buf:=trim(nextword(lin));
  buf:=trim(nextword(lin));
  desc:=trim(nextword(lin));
  buf:=trim(nextword(lin));
{$ifdef test_desc_size}
//  to test for overflow on description field:
  writeln(s,length(buf+desc));
{$endif}
  desc:=desc+';'+buf+blanc;
  out.desc:=desc;
  inp[i]:=out;
until eof(F);
Close(F);
{$ifdef test_desc_size}
Close(s);
{$endif}
nl:=i;
end;

procedure AddIndex(n,r:integer; buf1: string);
var buf:string;
begin
 if copy(buf1,1,2)='M ' then inc(mcount);
 if copy(buf1,1,3)='IC ' then inc(iccount);
 if copy(buf1,1,4)='NGC ' then inc(ngccount);
 buf:=uppercase(stringreplace(buf1,' ','',[rfReplaceAll]))+blanc;
 if trim(buf)>'' then begin
   inc(nixr);
   move(buf[1],ixr[nixr].key,sizeof(ixr[nixr].key));
   ixr[nixr].n:=n;
   ixr[nixr].r:=r;
end;
end;

procedure WrtZone(lgnum:integer);
var i,n,zone,p :integer;
    ar,de : double;
    buf1: string;
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
    // up to 3 index name per record!
    AddIndex(lgnum,i,out.nom1);
    p:=pos(';',out.nom2);
    if p>0 then begin
       buf1:=copy(out.nom2,1,p-1);
       AddIndex(lgnum,i,buf1);
       buf1:=out.nom2;
       delete(buf1,1,p);
    end
    else buf1:=out.nom2;
    AddIndex(lgnum,i,buf1); 
    write(fb,out);
    inc(i);
  end;
end;
close(fb);
end;

procedure WrtIndex ;
var i :integer;
  lin : filixr;
begin
assignfile(fo,patho+PathDelim+'sac.ixr');
Rewrite(fo);
for i:=1 to nixr do begin
  lin:=ixr[i];
  Write(Fo,lin);
end;
CloseFile(Fo);
end;

Procedure SortIndex(g,d:integer);
var step,i,j,k : integer;
    lin : filixr;
begin
step:=1;
while step < ((d-g+1) div 9) do step :=step*3+1;
repeat
  for k:=g to step do begin
    i:=k+step; if i<d then
    repeat
      lin:=ixr[i];
      j:=i-step;
      while (j>=k+step) and (ixr[j].key > lin.key) do begin
        ixr[j+step] := ixr[j];
        j:=j-step ;
      end;
      if ixr[k].key > lin.key then begin
        j:=k-step;
        ixr[k+step]:=ixr[k];
      end;
      ixr[j+step]:=lin;
      i:=i+step;
    until i>d;
  end;
  step:=step div 3;
until step=0;
end;


begin

pathi:='SAC_DeepSky_Ver81_QCQ.TXT';
patho:='sac';
ForceDirectories(patho);
ReadData;
nixr:=0;
mcount:=0;
ngccount:=0;
iccount:=0;
for lgnum:=1 to 50 do begin
  WrtZone(lgnum);
end;
SortIndex(1,nixr);
WrtIndex;
// to test for duplicate or missing names
//writeln('Messier names: '+inttostr(mcount));  // duplicate is M76
//writeln('NGC names: '+inttostr(ngccount));   // many duplicate, i.e. NGC1122-NGC1123
//writeln('IC names: '+inttostr(iccount));     // many missing
end.
