program convpgc;

{
    OBSOLETE! nom[16] is too short for new identification in hyperleda
}    

{
extract the data from an Hyperleda database mirror :
psql -c "CREATE OR REPLACE FUNCTION cdc_name(integer) RETURNS character varying AS 'SELECT design FROM designation WHERE PGC = \$1 and iref in (1,2,3,4,5,6,7,67,88) order by iref asc;' LANGUAGE SQL" hl
psql -o pgc.txt -c "select pgc, cdc_name(pgc), al2000, de2000, bt, bvt, brief, objtype, type, to_char((10 ^ logd25)/10,9990.99), to_char((10 ^ logd25)/10 / (10 ^ logr25),9990.99), pa, v from meandata where (objtype in ('G','Q','g') or (objtype='M' and multiple='M'))" hl
}


{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils, Classes, Math;

Type
PGCrec = record
                pgc,ar,de,hrv   : Longint;
                nom   : array [1..16] of char;
                typ   : array [1..4] of char;
                pa    : byte;
                maj,min,mb : smallint;
                end;

filixr = packed record n: smallint;
                r: integer;
                key: Longint;
         end;

const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

blank16 : array [1..16] of char = '                ';
blank4 = '    ';
maxl = 5000000; // max number of pgc objects ( 3360174 by 2012)

var
   F: textfile;
   fb : file of pgcrec;
   fo : file of filixr;
   outl : pgcrec;
   inp : array[0..maxl] of pgcrec;
   ixr : array[1..maxl] of filixr;
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

procedure ReadData;
var i,j,n,zone,lgnum :integer;
    ar,de,sde : extended;
    buf,v,w,b : string;
    maj,min : double;
begin
buf:=pathi;
Assignfile(F,buf);
Reset(F);
i:=0;
Readln(F,buf);  // header 1
Readln(F,buf);  // header 2
try
repeat
  Readln(F,buf);
  if copy(buf,1,1)='(' then break;
  if (trim(copy(buf,1,8))='')or(trim(copy(buf,43,11))='')or(trim(copy(buf,30,11))='') then continue;
  inc(i);
  // PGC
  outl.pgc:=strtoint(copy(buf,1,8));
  // RA DEC
  de := strtofloat(copy(buf,43,11));
  ar := strtofloat(copy(buf,30,10));
  ar:=15*ar;
  outl.de:=round(de*100000);
  outl.ar:=round(ar*100000);
  // NOM
  move(blank16,outl.nom,sizeof(outl.nom));
  v:=copy(buf,12,16);
//  if copy(v,1,3)='PGC' then v:=blank16; // pas de repetition du nom 
  w:='';
  for j:=1 to length(v) do if (v[j]<>' ') then w:=w+v[j];
  w:=w+blank16;
  for j:=1 to 16 do outl.nom[j]:=w[j];
  // TYPE
  move(blank4,outl.typ,sizeof(outl.typ));
  v:=copy(buf,94,4);
  if v=blank4 then v:=copy(buf,84,1);
  for j:=1 to length(v) do outl.typ[j]:=v[j];
  // PA
  v:=copy(buf,123,6);
  if (v)<>'      ' then outl.pa:=round(strtofloat(v))
                else outl.pa:=255;
  // MAJ axis
  v:=trim(copy(buf,101,8));
  if (v)<>'' then begin
     maj:=strtofloat(v);
     outl.maj:=round(maj*100);
     end
  else begin
     maj:=0;
     outl.maj:=0;
  end;
  // Min axis
  v:=trim(copy(buf,112,8));
  if (v)<>'' then begin
     min:=strtofloat(v);
     outl.min:=round(min*100)
  end else
     outl.min:=round(maj*100);
  // Mag
  v:=trim(copy(buf,57,6));
  if (v)<>'' then outl.mb:=round(strtofloat(v)*100)
                        else outl.mb:=-9990;
  // RV
  v:=trim(copy(buf,132,12));
  if (v)<>'' then outl.hrv:=round(strtofloat(v))
                        else outl.hrv:=-999999;
  //
  inp[i]:=outl;
until eof(F);
Close(F);
writeln('tot galaxies '+inttostr(i));
nl:=i;
except
 writeln('Error at line: '+inttostr(i+2));
 writeln(buf);
end;
end;

Procedure SortData(g,d:integer);
var pas,i,j,k : integer;
    lin : PGCrec;
begin
pas:=1;
while pas < ((d-g+1) div 9) do pas :=pas*3+1;
repeat
  for k:=g to pas do begin
    i:=k+pas; if i<d then
    repeat
      lin:=inp[i];
      j:=i-pas;
      while (j>=k+pas) and (inp[j].maj > lin.maj) do begin
        inp[j+pas] := inp[j];
        j:=j-pas ;
      end;
      if inp[k].maj > lin.maj then begin
        j:=k-pas;
        inp[k+pas]:=inp[k];
      end;
      inp[j+pas]:=lin;
      i:=i+pas;
    until i>d;
  end;
  pas:=pas div 3;
until pas=0;
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
  outl:=inp[n];
  ar:=outl.ar/100000;
  de:=outl.de/100000;
  findregion(ar,de,zone);
  if zone=lgnum then begin
    inc(nixr);
    ixr[nixr].key:=outl.pgc;
    ixr[nixr].n:=lgnum;
    ixr[nixr].r:=i;
    write(fb,outl);
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
assignfile(fo,patho+PathDelim+'pgc.ixr');
Rewrite(fo);
for i:=1 to nixr do begin
  lin:=ixr[i];
  Write(Fo,lin);
end;
CloseFile(Fo);
end;

begin
pathi:='pgc.txt';
patho:='./pgc';
CreateDir(patho);
writeln('Read data');
ReadData;
writeln('Sort by size');
SortData(1,nl);
nixr:=0;
writeln('Write catalog');
for lgnum:=1 to 50 do begin
  WrtZone(lgnum);
end;
writeln('Sort index');
SortIndex(1,nl);
writeln('Write index');
WrtIndex;
end.

