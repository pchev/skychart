program convgcvs;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils, Classes, Math;

Type
 GCVtxt = record     l : byte;
                     num : array[1..6] of char;
                     s1  : char;
                     s1a  : char;
                     gcvs: array[1..10]of char;
                     s2  : char;
                     s2a  : char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..4] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     s3  : char;
                     s3a  : char;
                     vartype : array[1..10] of char;
                     s3b  : char;
                     lmax : char;
                     max : array[1..6] of char;
                     s4 : char;
                     s5 : char;
                     s5a : char;
                     lmin : char;
                     min : array[1..6] of char;
                     s7  : char;
                     s8  : char;
                     s8a  : char;
                     fmin:char;
                     lmin2 : char;
                     min2 : array[1..6] of char;
                     s72  : char;
                     s82  : char;
                     s82a  : char;
                     fmin2:char;
                     s82b  : char;
                     s8b  : char;
                     mcode : char;
                     s8c  : char;
                     s9  : array[1..16] of char;
                     ynova : array[1..4] of char;
                     s10  : char;
                     s10a  : char;
                     s10b  : char;
                     period : array[1..16] of char;
                     s11  : array [1..1024] of char;
                     end;
 

GCVrec = record ar,de,num :longint ;
                period : single;
                max,min : smallint;
                lmax,lmin,mcode : char;
                gcvs,vartype : array[1..10] of char;
                end;

filixr = packed record n: smallint;
                r: integer;
                key: array[1..12] of char; 
         end;


const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

var
   F: textfile;
   lin1 : gcvtxt;
   fb : file of gcvrec;
   fo   : file of filixr;
   out : gcvrec;
   inp : array[0..200000] of gcvrec;
   ixr : array[1..200000] of filixr;
   nl,nixr : integer;
   pathi,patho : string;
   lgnum : integer;

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

procedure ReadData;
var i,p :integer;
    ar,de,sde : double;
    buf : shortstring;
const blanc='                                                                  ';
begin
writeln('gcvs_cat.dat');
Assignfile(F,pathi+PathDelim+'gcvs_cat.dat');
Reset(F);
i:=0;
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin1,sizeof(lin1));
  if lin1.arh='  ' then continue;
  sde:=strtofloat(lin1.sde+'1');
  de := sde*strtofloat(lin1.ded)+sde*strtofloat(lin1.dem)/60 ;
  if trim(lin1.des)>'' then de:=de+sde*strtofloat(lin1.des)/3600;
  ar := strtofloat(lin1.arh)+strtofloat(lin1.arm)/60+strtofloat(lin1.ars)/3600;
  ar:=15*ar;
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  out.num:=strtoint(lin1.num);
  move(lin1.gcvs,out.gcvs,sizeof(out.gcvs));
  move(lin1.vartype,out.vartype,sizeof(out.vartype));
  if trim(lin1.ynova)>'' then begin
     p:=length(trim(lin1.vartype))+1;
     out.vartype[p+1]:=lin1.ynova[1];
     out.vartype[p+2]:=lin1.ynova[2];
     out.vartype[p+3]:=lin1.ynova[3];
     out.vartype[p+4]:=lin1.ynova[4];
  end;
  out.lmax:=lin1.lmax;
  out.lmin:=lin1.lmin;
  if trim(lin1.max)>'' then out.max:=round(strtofloat(trim(lin1.max))*100)
                      else out.max:=9900;
  if trim(lin1.min)>'' then out.min:=round(strtofloat(trim(lin1.min))*100)
                      else out.min:=9900;
  if lin1.fmin=')' then out.min:=out.min+out.max;
  out.mcode:=lin1.mcode;
  if trim(lin1.period)>'' then out.period:=strtofloat(lin1.period)
                         else out.period:=0;
  inp[i]:=out;
until eof(F);
Close(F);
writeln('tot stars '+inttostr(i));

nl:=i;
end;

procedure WrtZone(lgnum:integer);
var i,n,zone :integer;
    ar,de : double;
    buf: shortstring;
const blanc='                                                                  ';
begin
assignfile(fb,patho+PathDelim+padzeros(inttostr(lgnum),2)+'.dat');
Rewrite(fb);
i:=0;
for n:=1 to nl do begin
  out:=inp[n];
  ar:=out.ar/100000;
  de:=out.de/100000;
  findregion(ar,de,zone);
  if zone=lgnum then begin
    inc(nixr);
    buf:=uppercase(stringreplace(out.gcvs,' ','',[rfReplaceAll]))+blanc;
    move(buf[1],ixr[nixr].key,sizeof(ixr[nixr].key));
    ixr[nixr].n:=lgnum;
    ixr[nixr].r:=i;
    write(fb,out);
    inc(i);
  end;
end;
close(fb);
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

procedure WrtIndex ;
var i :integer;
  lin : filixr;
begin
assignfile(fo,patho+PathDelim+'gcvs.ixr');
Rewrite(fo);
for i:=1 to nixr do begin
  lin:=ixr[i];
  Write(Fo,lin);
end;
CloseFile(Fo);
end;

begin
pathi:='./';
patho:='./gcvs';
CreateDir(patho);
ReadData;
nixr:=0;
for lgnum:=1 to 50 do begin
  WrtZone(lgnum);
end;
SortIndex(1,nl);
WrtIndex;

end.

