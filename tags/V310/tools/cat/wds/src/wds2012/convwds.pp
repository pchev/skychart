program convwds;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils, Classes, Math;

Type
 WDStxt = record     WDSname : array[1..10] of char;
                     id      : array[1..7] of char;
                     comp    : array[1..5] of char;
                     s1      : char;
                     date1   : array[1..4] of char;
                     s2      : char;
                     date2   : array[1..4] of char;
                     s3      : char;
                     no      : array[1..4] of char;
                     s4      : char;
                     pa1     : array[1..3] of char;
                     s5      : char;
                     pa2     : array[1..3] of char;
                     s6      : char;
                     sep1    : array[1..5] of char;
                     s7      : char;
                     sep2    : array[1..6] of char;
                     ma      : array[1..5] of char;
                     s9      : char;
                     mb      : array[1..5] of char;
                     s10     : char;
                     sp      : array[1..9] of char;
                     s101    : char;
                     pm      : array[1..18] of char;
                     dms     : char;
                     dmz     : array[1..2] of char;
                     dmn     : array[1..5] of char;
                     s12     : char;
                     note1   : char;
                     note2   : char;
                     note3   : char;
                     note4   : char;
                     n_RAh   : char;
                     arh     : array[1..2] of char;
                     arm     : array[1..2] of char;
                     ars     : array[1..5] of char;
                     sde     : char;
                     ded     : array[1..2] of char;
                     dem     : array[1..2] of char;
                     des     : array[1..4] of char;
                     cr      :  char;
                     end;
WDSrec = record ar,de,dm :longint ;
                date1,date2,pa1,pa2,sep1,sep2,ma,mb : smallint;
                id : array[1..7] of char;
                comp : array[1..5] of char;
                sp : array[1..9] of char;
                note : array[1..2] of char;
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
   Ft: textfile;
   lin : wdstxt;
   fb : file of wdsrec;
   fo   : file of filixr;
   out : wdsrec;
   inp : array[1..200000] of wdsrec;
   ixr : array[1..200000] of filixr;
   nl, nixr : integer;
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
var i,sdm :integer;
    ar,de,sde : double;
    buf:array[0..150] of char;
begin
Assignfile(Ft,pathi);
Reset(Ft);
i:=0;
repeat
//  writeln(inttostr(i));
  FillChar(buf,sizeof(buf),' ');
  readln(ft,buf);
  move(buf,lin,sizeof(lin));
  sde:=strtofloat(lin.sde+'1');
  de := sde*strtofloat(lin.ded)+sde*strtofloatdef(lin.dem,0)/60+sde*strtofloatdef(lin.des,0)/3600 ;
  ar := strtofloat(lin.arh)+strtofloatdef(lin.arm,0)/60+strtofloatdef(lin.ars,0)/3600;
  ar:=15*ar;
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  move(lin.id,out.id,sizeof(out.id));
  move(lin.comp,out.comp,sizeof(out.comp));
  move(lin.sp,out.sp,sizeof(out.sp));
  out.note[1]:=lin.note2;
  out.note[2]:=lin.note3;
  if trim(lin.date1)>'' then out.date1:=strtoint(lin.date1)
                        else out.date1:=-999;
  if trim(lin.date2)>'' then out.date2:=strtoint(lin.date2)
                        else out.date2:=-999;
  if trim(lin.sep1)>'' then out.sep1:=round(strtofloat(trim(lin.sep1))*10)
                       else out.sep1:=0;
  if trim(lin.sep2)>'' then out.sep2:=round(strtofloat(trim(lin.sep2))*10)
                       else out.sep2:=0;
  if trim(lin.ma)>'' then out.ma:=round(strtofloat(trim(lin.ma))*100)
                     else out.ma:=9900;
  if trim(lin.mb)>'' then out.mb:=round(strtofloat(trim(lin.mb))*100)
                     else out.mb:=9900;
  if lin.dms>' ' then begin
     sdm:=strtoint(lin.dms+'1');
     out.dm:=sdm*strtointdef(lin.dmz,0)*100000+sdm*strtointdef(trim(lin.dmn),0);
   end
   else out.dm := 0;
  if trim(lin.pa1)>'' then out.pa1:=strtoint(trim(lin.pa1))
                      else out.pa1:=-999;
  if trim(lin.pa2)>'' then out.pa2:=strtoint(trim(lin.pa2))
                      else out.pa2:=-999;
  inp[i]:=out;
until eof(Ft);
nl:=i;
Close(Ft);
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
    buf:=uppercase(stringreplace(out.id,' ','',[rfReplaceAll]))+blanc;
    move(buf[1],ixr[nixr].key,sizeof(ixr[nixr].key));
    ixr[nixr].n:=lgnum;
    ixr[nixr].r:=i;
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
assignfile(fo,patho+PathDelim+'wds.ixr');
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
pathi:='wds.dat';
patho:='wds';
createdir(patho);
ReadData;
nixr:=0;
for lgnum:=1 to 50 do begin
  WrtZone(lgnum);
end;
SortIndex(1,nl);
WrtIndex;

end.
