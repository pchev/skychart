unit idxgcvs1;

interface

uses Skylib,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

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
 filidx = record clef : array[1..12] of char;     
                 ar,de :single;
          end;
Type
 GCVtxt = record     l : byte;
                     num : array[1..7] of char;
                     s1  : char;
                     gcvs: array[1..6]of char;
                     cons: array[1..3]of char;
                     s2  : char;
                     s22 : char;
                     arh5 : array[1..2] of char;
                     arm5 : array[1..2] of char;
                     ars5 : array[1..4] of char;
                     sde5 : char;
                     ded5 : array[1..2] of char;
                     dem5 : array[1..2] of char;
                     des5 : array[1..2] of char;
                     s3  : char;
                     vartype : array[1..10] of char;
                     lmax : char;
                     max : array[1..6] of char;
                     s4 : char;
                     s5 : char;
                     lmin : char;
                     s6 : char;
                     min : array[1..6] of char;
                     s7  : char;
                     s8  : char;
                     fmin:char;
                     mcode : char;
                     s9  : array[1..16] of char;
                     ynova : array[1..4] of char;
                     s10  : char;
                     period : array[1..16] of char;
                     s11  : array [1..52] of char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..4] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     cr  :  char;
                     end;
 NSVtxt = record     l : byte;
                     num : array[1..5] of char;
                     s1  : array[1..3] of char;
                     arh5 : array[1..2] of char;
                     arm5 : array[1..2] of char;
                     ars5 : array[1..4] of char;
                     sde5 : char;
                     ded5 : array[1..2] of char;
                     dem5 : array[1..2] of char;
                     des5 : array[1..2] of char;
                     s2  : char;
                     vartype : array[1..5] of char;
                     s3  : char;
                     max : array[1..5] of char;
                     lmax : char;
                     s4 : array [1..2]of char;
                     lmin : char;
                     min : array[1..6] of char;
                     s5 : array [1..2]of char;
                     fmin : char;
                     mcode : char;
                     s9  : array[1..9] of char;
                     desig : array[1..9] of char;
                     s11  : array [1..22] of char;
                     cr  :  char;
                     end;
 NSVStxt = record     l : byte;
                     num : array[1..5] of char;
                     s1  : array[1..19] of char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..4] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     s2  : char;
                     vartype : array[1..6] of char;
                     s3  : char;
                     lmax : char;
                     max : array[1..5] of char;
                     s4 : array [1..2]of char;
                     s7 : char;
                     lmin : char;
                     min : array[1..6] of char;
                     s5 :  char;
                     fmin : char;
                     s6  : array[1..2] of char;
                     mcode : char;
                     s11  : array [1..44] of char;
                     cr  :  char;
                     end;
 EVStxt = record     l : byte;
                     num : array[1..7] of char;
                     s1  : char;
                     ngal : array[1..6] of char;
                     s12  : char;
                     nvar : array[1..5] of char;
                     s11  : char;
                     arh5 : array[1..2] of char;
                     arm5 : array[1..2] of char;
                     ars5 : array[1..5] of char;
                     sde5 : char;
                     ded5 : array[1..2] of char;
                     dem5 : array[1..2] of char;
                     des5 : array[1..4] of char;
                     s2  : char;
                     vartype : array[1..8] of char;
                     max : array[1..5] of char;
                     lmax : char;
                     lmin : char;
                     min : array[1..5] of char;
                     s5 :  char;
                     fmin : char;
                     mcode : char;
                     s9  : array[1..86] of char;
                     ynova : array[1..4] of char;
                     s10  : char;
                     cr  :  char;
                     end;
GCVrec = record ar,de,num :longint ;
                period : single;
                max,min : smallint;
                lmax,lmin,mcode : char;
                gcvs,vartype : array[1..10] of char;
                end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
maxl = 100000;

var
   F: textfile;
   lin1 : gcvtxt;
   lin2 : nsvtxt;
   lin3 : evstxt;
   lin4 : nsvstxt;
   fo   : file of filidx;
   inp : array[1..maxl] of filidx;
   nl : integer;
   pathi,patho : string;

procedure Lecture;
var i,n,p,zone :integer;
    ar,de,sde,jd1,jd2 : double;
    buf : shortstring;
const blanc='                                                                  ';
begin
Assignfile(F,pathi+'\gcvs.dat');
Reset(F);
i:=0;
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin1,sizeof(lin1));
  if lin1.arh5='  ' then continue;
  if lin1.arh='  ' then begin
     sde:=strtofloat(lin1.sde5+'1');
     de := sde*strtofloat(lin1.ded5)+sde*strtofloat(lin1.dem5)/60 ;
     if trim(lin1.des5)>'' then de:=de+sde*strtofloat(lin1.des5)/3600;
     ar := strtofloat(lin1.arh5)+strtofloat(lin1.arm5)/60+strtofloat(lin1.ars5)/3600;
     precession(jd1,jd2,ar,de);
     ar:=15*ar;
     end
  else begin
     sde:=strtofloat(lin1.sde+'1');
     de := sde*strtofloat(lin1.ded)+sde*strtofloat(lin1.dem)/60 ;
     if trim(lin1.des)>'' then de:=de+sde*strtofloat(lin1.des)/3600;
     ar := strtofloat(lin1.arh)+strtofloat(lin1.arm)/60+strtofloat(lin1.ars)/3600;
     ar:=15*ar;
  end;
  inc(i);
  inp[i].de:=de;
  inp[i].ar:=ar;
  if (length(trim(lin1.gcvs))=1)and(trim(lin1.gcvs)>'r') and (trim(lin1.gcvs)<'z')
     then buf:=lin1.gcvs
     else buf:=uppercase(lin1.gcvs);
  buf:=buf+uppercase(lin1.cons)+blanc;
  move(buf[1],inp[i].clef,sizeof(inp[i].clef));
until eof(F);
Close(F);
Assignfile(F,pathi+'\nsv.dat');
Reset(F);
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin2,sizeof(lin2));
  if lin2.arh5='  ' then continue;
     sde:=strtofloat(lin2.sde5+'1');
     de := sde*strtofloat(lin2.ded5)+sde*strtofloat(lin2.dem5)/60 ;
     if trim(lin2.des5)>'' then de:=de+sde*strtofloat(lin2.des5)/3600;
     ar := strtofloat(lin2.arh5)+strtofloat(lin2.arm5)/60+strtofloat(lin2.ars5)/3600;
     precession(jd1,jd2,ar,de);
     ar:=15*ar;
  inc(i);
  inp[i].de:=de;
  inp[i].ar:=ar;
  buf:='NSV   '+lin2.num+blanc;
  move(buf[1],inp[i].clef,sizeof(inp[i].clef));
until eof(F);
Close(F);
Assignfile(F,pathi+'\nsvs.dat');
Reset(F);
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin4,sizeof(lin4));
  if lin4.arh='  ' then continue;
     sde:=strtofloat(lin4.sde+'1');
     de := sde*strtofloat(lin4.ded)+sde*strtofloat(lin4.dem)/60 ;
     if trim(lin4.des)>'' then de:=de+sde*strtofloat(lin4.des)/3600;
     ar := strtofloat(lin4.arh)+strtofloat(lin4.arm)/60+strtofloat(lin4.ars)/3600;
     ar:=15*ar;
  inc(i);
  inp[i].de:=de;
  inp[i].ar:=ar;
  buf:='NSV   '+lin4.num+blanc;
  move(buf[1],inp[i].clef,sizeof(inp[i].clef));
until eof(F);
Close(F);
Assignfile(F,pathi+'\evs_cat.dat');
Reset(F);
jd1:=jd(1950,1,1,0);
jd2:=jd(2000,1,1,0);
repeat
  Readln(F,buf);
  buf:=buf+blanc;
  move(buf,lin3,sizeof(lin3));
  if lin3.arh5='  ' then continue;
     sde:=strtofloat(lin3.sde5+'1');
     de := sde*strtofloat(lin3.ded5)+sde*strtofloat(lin3.dem5)/60 ;
     if trim(lin3.des5)>'' then de:=de+sde*strtofloat(lin3.des5)/3600;
     ar := strtofloat(lin3.arh5)+strtofloat(lin3.arm5)/60+strtofloat(lin3.ars5)/3600;
     precession(jd1,jd2,ar,de);
     ar:=15*ar;
  inc(i);
  inp[i].de:=de;
  inp[i].ar:=ar;
  buf:=uppercase(lin3.ngal)+uppercase(lin3.nvar)+blanc;
  move(buf[1],inp[i].clef,sizeof(inp[i].clef));
until eof(F);
Close(F);
nl:=i;
form1.Edit3.Text:=inttostr(i);
Form1.Update;
end;

procedure Ecriture ;
var i,j :integer;
  lin : filidx;
begin
assignfile(fo,patho);
Rewrite(fo);
for i:=1 to nl do begin
  lin:=inp[i];
  Write(Fo,lin);
end;
CloseFile(Fo);
end;

Procedure Tshell(g,d:integer);
var pas,i,j,k : integer;
    lin : filidx;
begin
form1.edit3.text:='Tri';form1.update;
pas:=1;
while pas < ((d-g+1) div 9) do pas :=pas*3+1;
repeat
  for k:=g to pas do begin
    i:=k+pas; if i<d then
    repeat
      lin:=inp[i];
      j:=i-pas;
      while (j>=k+pas) and (inp[j].clef > lin.clef) do begin
        inp[j+pas] := inp[j];
        j:=j-pas ;
      end;
      if inp[k].clef > lin.clef then begin
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

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
  Lecture;
  edit3.text:=inttostr(nl);
  form1.update;
  Tshell(1,nl);
  Ecriture;
edit3.text:='terminé';
end;

end.
