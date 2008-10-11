unit convwds1;
{$A8}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
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

 WDStxt = record     ar1h: array[1..2] of char;
                     ar1m: array[1..3] of char;
                     sde1: char;
                     de1d: array[1..2] of char;
                     de1m: array[1..2] of char;
                     s0  : char;
                     id  : array[1..7] of char;
                     s00  : char;
                     comp: array[1..5] of char;
                     s1   : char;
                     date1: array[1..4] of char;
                     s02  : char;
                     date2: array[1..4] of char;
                     s03  : char;
                     no  : array[1..2] of char;
                     s04  : char;
                     pa1 : array[1..3] of char;
                     s05  : char;
                     pa2 : array[1..3] of char;
                     s06  : char;
                     sep1: array[1..5] of char;
                     s07  : char;
                     sep2: array[1..5] of char;
                     s08  : char;
                     ma  : array[1..5] of char;
                     s09  : char;
                     mb  : array[1..5] of char;
                     s10  : char;
                     sp  : array[1..9] of char;
                     s11  : char;
                     pm  : array[1..9] of char;
                     s12  : char;
                     dms : char;
                     dmz : array[1..2] of char;
                     dmn : array[1..5] of char;
                     s13  : char;
                     note: array[1..3] of char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..3] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     pb1 : array[1..4] of char;
                     pb2 : array[1..4] of char;
                     cr  :  char;
                     end;
WDSrec = record ar,de,dm :longint ;
                date1,date2,pa1,pa2,sep1,sep2,ma,mb : smallint;
                id : array[1..7] of char;
                comp : array[1..5] of char;
                sp : array[1..9] of char;
                note : array[1..2] of char;
                end;

filidx = record clef : array[1..12] of char;
                ar,de :single;
                end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
const
    lg_reg_x : array [0..5,1..2] of integer = (
(   4, 47),(  9, 38),( 12, 26),
(  12,  1),(  9, 13),(  4, 22));

var
   F: file of wdstxt;
   lin : wdstxt;
   fb : file of wdsrec;
   fo : file of filidx;
   out : wdsrec;
   inp : array[1..150000] of wdsrec;
   idx : array[1..150000] of filidx;
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

procedure Lecture;
var i,j,n,p,sdm :integer;
    ar,de,sde : double;
    buf:string;
const bl : array[1..12]of char =(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
begin
Assignfile(F,pathi);
Reset(F);
i:=0;
repeat
  Read(F,lin);
  if lin.sde=' ' then begin
    sde:=strtofloat(lin.sde1+'1');
    de := sde*strtofloat(lin.de1d)+sde*strtofloat(lin.de1m)/60 ;
    ar := strtofloat(lin.ar1h)+strtofloat(lin.ar1m)/600;
  end else begin
    sde:=strtofloat(lin.sde+'1');
    de := sde*strtofloat(lin.ded)+sde*strtofloat(lin.dem)/60+sde*strtofloat(lin.des)/3600 ;
    ar := strtofloat(lin.arh)+strtofloat(lin.arm)/60+strtofloat(lin.ars)/36000;
  end;
  ar:=15*ar;
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  move(lin.id,out.id,sizeof(out.id));
  move(lin.comp,out.comp,sizeof(out.comp));
  move(lin.sp,out.sp,sizeof(out.sp));
  move(lin.note,out.note,sizeof(out.note));
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
     out.dm:=sdm*strtoint(lin.dmz)*100000+sdm*strtoint(trim(lin.dmn));
     end
     else out.dm := 0;
  if pos('6',out.note)>0 then begin
     out.sep1:=out.sep1*60;
     out.sep2:=out.sep2*60;
  end;
  out.pa1:=-999;
{  if trim(lin.pa1)='1 9'  then out.pa1:=9;
  if trim(lin.pa1)='N'  then out.pa1:=0;
  if (out.pa1=-999) and (trim(lin.pa1)='NF') then out.pa1:=45;
  if (out.pa1=-999) and (trim(lin.pa1)='F' ) then out.pa1:=90;
  if (out.pa1=-999) and (trim(lin.pa1)='E' ) then out.pa1:=90;
  if (out.pa1=-999) and (trim(lin.pa1)='SF') then out.pa1:=135;
  if (out.pa1=-999) and (trim(lin.pa1)='S' ) then out.pa1:=180;
  if (out.pa1=-999) and (trim(lin.pa1)='SP') then out.pa1:=225;
  if (out.pa1=-999) and (trim(lin.pa1)='W' ) then out.pa1:=270;
  if (out.pa1=-999) and (trim(lin.pa1)='P' ) then out.pa1:=270;
  if (out.pa1=-999) and (trim(lin.pa1)='NP') then out.pa1:=315; }
  if (out.pa1=-999) and (trim(lin.pa1)>'') then out.pa1:=strtoint(trim(lin.pa1));
  if trim(lin.pa2)>'' then out.pa2:=strtoint(trim(lin.pa2))
                      else out.pa2:=-999;
  inp[i]:=out;
  move(bl,idx[i].clef,sizeof(idx[i].clef));
  buf:=uppercase(stringreplace(out.id,' ','',[rfReplaceAll]));
  for j:=1 to length(buf) do begin
    idx[i].clef[j]:=buf[j];
  end;
  idx[i].ar:=out.ar/100000;
  idx[i].de:=out.de/100000;
  if (i mod 1000)=0 then begin
     form1.Edit3.Text:=inttostr(i);
     Form1.Update;
  end;
until eof(F);
nl:=i;
form1.Edit3.Text:=inttostr(i);
Form1.Update;
Close(F);
end;

procedure wrt_lg(lgnum:integer);
var i,n,p,zone :integer;
    ar,de,sde,jd1,jd2 : double;
begin
assignfile(fb,patho+'\'+padzeros(inttostr(lgnum),2)+'.dat');
Rewrite(fb);
i:=0;
for n:=1 to nl do begin
  out:=inp[n];
  ar:=out.ar/100000;
  de:=out.de/100000;
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
Form1.Update;
close(fb);
end;

procedure EcritureIdx ;
var i,j :integer;
  lid : filidx;
begin
assignfile(fo,patho+'\wds.idx');
Rewrite(fo);
for i:=1 to nl do begin
  lid:=idx[i];
  Write(Fo,lid);
end;
CloseFile(Fo);
end;

Procedure Tshell(g,d:integer);
var pas,i,j,k : integer;
    lid : filidx;
begin
pas:=1;
while pas < ((d-g+1) div 9) do pas :=pas*3+1;
repeat
  for k:=g to pas do begin
    i:=k+pas; if i<d then
    repeat
      lid:=idx[i];
      j:=i-pas;
      while (j>=k+pas) and (idx[j].clef > lid.clef) do begin
        idx[j+pas] := idx[j];
        j:=j-pas ;
      end;
      if idx[k].clef > lid.clef then begin
        j:=k-pas;
        idx[k+pas]:=idx[k];
      end;
      idx[j+pas]:=lid;
      i:=i+pas;
    until i>d;
  end;
  pas:=pas div 3;
until pas=0;
end;

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
Lecture;
for lgnum:=1 to 50 do begin
  Edit1.Text:=inttostr(lgnum);
  wrt_lg(lgnum);
end;
Edit1.Text:='Tri Index';
Form1.Update;
Tshell(1,nl);
EcritureIdx;
Edit1.Text:='Terminé';
end;

end.
