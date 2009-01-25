unit convtyc21;

interface

uses FileCtrl,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
type
     TYC2rec = record
               gscz : array [1..4] of char;
               s1   : char;
               gscn : array [1..5] of char;
               s2   : char;
               tycn : char;
               s3   : array [1..3] of char;
               arm  : array [1..12] of char;
               s4   : char;
               dem  : array [1..12] of char;
               s5   : char;
               pmar : array [1..7] of char;
               s6   : char;
               pmde : array [1..7] of char;
               s7   : array [1..54] of char;
               bt   : array [1..6] of char;
               s8   : array [1..7] of char;
               vt   : array [1..6] of char;
               s9   : array [1..23] of char;
               ar   : array [1..12] of char;
               s10  : char;
               de   : array [1..12] of char;
               s11  : array [1..29] of char;
               crlf : array [1..2] of char;
               end;
     SUP1rec = record
               gscz : array [1..4] of char;
               s1   : char;
               gscn : array [1..5] of char;
               s2   : char;
               tycn : char;
               s3   : array [1..3] of char;
               ar   : array [1..12] of char;
               s4   : char;
               de   : array [1..12] of char;
               s5   : char;
               pmar : array [1..7] of char;
               s6   : char;
               pmde : array [1..7] of char;
               s7   : array [1..27] of char;
               bt   : array [1..6] of char;
               s8   : array [1..7] of char;
               vt   : array [1..6] of char;
               s9   : array [1..20] of char;
               crlf : array [1..2] of char;
               end;
     TYC2idx = record
               rect2 : array [1..7] of char;
               s1    : char;
               recs1 : array [1..6] of char;
               s2    : array [1..28] of char;
               crlf : array [1..2] of char;
               end;
     TYC2bin = packed record
               ar,de : longint;
               pmar,pmde : word;
               gscz: word;
               gscn: word;
               bt,vt :word
               end;
var
  fbina,fbinb  : file of TYC2bin ;
  ftyc2 : file of TYC2rec ;
  fidx1,fidx2 : file of TYC2idx ;
  fsup1 : file of SUP1rec ;
  rec : TYC2rec ;
  idx,idxn : TYC2idx ;
  sup : SUP1rec ;
  lin : TYC2bin ;
  bpathi,bpatho : string;
  totrec,nrec,ticnum : integer;

//tycn:=trunc(lin.gscz/10000);
//gscz:=frac(lin.gscz/10000)*10000;
//gscn:=lin.gscn;
//ar:=lin.ar/5000000;
//de:=lin.de/5000000;
//pmar:=(((lin.bt and $0000F000) shl 4)+lin.pmar-100000)/10;
//pmde:=(((lin.vt and $0000F000) shl 4)+lin.pmde-100000)/10;
//bt:=((lin.bt and $00000FFF)-200)/100;
//vt:=((lin.vt and $00000FFF)-200)/100;

Function PadZeros(x : string ; l :integer) : string;
const zero = '000000000000';
var p : integer;
begin
x:=trim(x);
p:=l-length(x);
result:=copy(zero,1,p)+x;
end;

procedure ConvMain(pos,num : integer; var ia,ib : integer);
var
   nom : string;
   i,id1 : integer;
   ok : boolean;
   x : cardinal;
   f1,f2 : word;
   ma : double;
begin
seek(ftyc2,pos-1);
for i:=1 to num do begin
Read(ftyc2,rec);
lin.gscz:=strtoint(rec.tycn)*10000 + strtoint(rec.gscz);
lin.gscn:=strtoint(rec.gscn);
if trim(rec.arm)>'' then lin.ar:=round(strtofloat(rec.arm)*5000000)
                    else lin.ar:=round(strtofloat(rec.ar)*5000000);
if trim(rec.dem)>'' then lin.de:=round(strtofloat(rec.dem)*5000000)
                    else lin.de:=round(strtofloat(rec.de)*5000000);
if trim(rec.pmar)>'' then x:=round(10*strtofloat(rec.pmar)+100000)
                     else x:=100000;
lin.pmar:=x and $0000FFFF;
f1 := (x and $000F0000) shr 4;
if trim(rec.pmde)>'' then x:=round(10*strtofloat(rec.pmde)+100000)
                     else x:=100000;
lin.pmde:=x and $0000FFFF;
f2 := (x and $000F0000) shr 4;
if trim(rec.bt)>'' then lin.bt:=round(strtofloat(rec.bt)*100)+200
                   else lin.bt:=4000;
lin.bt:=lin.bt+f1;
if trim(rec.vt)>'' then lin.vt:=round(strtofloat(rec.vt)*100)+200
                   else lin.vt:=4000;
lin.vt:=lin.vt+f2;
ma:=((lin.vt and $00000FFF)-200)/100;
if ma>30 then ma:=((lin.bt and $00000FFF)-200)/100;
if ma <= 11 then begin
   inc(ia);
   write(fbina,lin)
end else begin
   inc(ib);
   write(fbinb,lin);
end;
end;
end;

procedure ConvSup(pos,num : integer; var ia,ib : integer);
var
   nom : string;
   i,id1 : integer;
   ok : boolean;
   x : cardinal;
   f1,f2 : word;
   ma : double;
begin
seek(fsup1,pos-1);
for i:=1 to num do begin
Read(fsup1,sup);
lin.gscz:=strtoint(sup.tycn)*10000 + strtoint(sup.gscz);
lin.gscn:=strtoint(sup.gscn);
lin.ar:=round(strtofloat(sup.ar)*5000000);
lin.de:=round(strtofloat(sup.de)*5000000);
if trim(sup.pmar)>'' then x:=round(10*strtofloat(sup.pmar)+100000)
                     else x:=100000;
lin.pmar:=x and $0000FFFF;
f1 := (x and $000F0000) shr 4;
if trim(sup.pmde)>'' then x:=round(10*strtofloat(sup.pmde)+100000)
                     else x:=100000;
lin.pmde:=x and $0000FFFF;
f2 := (x and $000F0000) shr 4;
if trim(sup.bt)>'' then lin.bt:=round(strtofloat(sup.bt)*100)+200
                   else lin.bt:=4000;
lin.bt:=lin.bt+f1;
if trim(sup.vt)>'' then lin.vt:=round(strtofloat(sup.vt)*100)+200
                   else lin.vt:=4000;
lin.vt:=lin.vt+f2;
ma:=((lin.vt and $00000FFF)-200)/100;
if ma>30 then ma:=((lin.bt and $00000FFF)-200)/100;
if ma <= 11 then begin
   inc(ia);
   write(fbina,lin)
end else begin
   inc(ib);
   write(fbinb,lin);
end;
end;
end;

Procedure Readidx(S:integer; var t2rec1,t2nrec,s1rec1,s1nrec : integer);
begin
seek(fidx1,S-1);
read(fidx1,idx);
t2rec1:=strtoint(idx.rect2);
s1rec1:=strtoint(idx.recs1);
read(fidx1,idxn);
t2nrec:=strtoint(idxn.rect2)-t2rec1;
s1nrec:=strtoint(idxn.recs1)-s1rec1;
end;

Procedure WrtIdx(nt2,ns1: integer);
var buf : string;
    i : integer;
begin
str(nt2:7,buf);
for i:=1 to 7 do idx.rect2[i]:=buf[i];
str(ns1:6,buf);
for i:=1 to 6 do idx.recs1[i]:=buf[i];
write(fidx2,idx);
end;

procedure TForm1.Button1Click(Sender: TObject);
var i,n,lgnum,ia,ib,ia1,ib1,ps,ns,pm,nm :integer;
    lgpath,nom,nomlga,nomlgb,nomox,nomix,nomsup : string;
begin
decimalseparator:='.';
button2.enabled:=false;
bpathi:=edit1.text;
bpatho:=edit2.text;
if copy(bpathi,length(bpathi),1)<>'\' then bpathi:=bpathi+'\';
if copy(bpatho,length(bpatho),1)<>'\' then bpatho:=bpatho+'\';
nrec:=0;
forcedirectories(bpatho);
nomlga:=bpatho+'tyc2a.dat';
nomlgb:=bpatho+'tyc2b.dat';
nomix:=bpathi+'index.dat';
nomox:=bpatho+'tyc2idx.dat';
nom:=bpathi+'catalog.dat';
nomsup:=bpathi+'suppl_1.dat';
if fileexists(nomix) and fileexists(nom) and fileexists(nomsup) then begin
try
filemode:=0;
Assignfile(fbina,nomlga);
Assignfile(fbinb,nomlgb);
AssignFile(fidx1,nomix);
AssignFile(fidx2,nomox);
AssignFile(ftyc2,nom);
AssignFile(fsup1,nomsup);
Reset(ftyc2);
Reset(fsup1);
Reset(fidx1);
rewrite(fidx2);
rewrite(fbina);
rewrite(fbinb);
ia:=1; ib:=1;
ia1:=1; ib1:=1;
for lgnum:=1 to 9537 do begin
  form1.Edit3.Text:=inttostr(lgnum);
  form1.update;
  Readidx(lgnum,pm,nm,ps,ns);
  ConvSup(ps,ns,ia1,ib1);
  ConvMain(pm,nm,ia1,ib1);
  WrtIdx(ib,ia);
  ia:=ia1;
  ib:=ib1;
end;
idx:=idxn;
WrtIdx(ib,ia);
form1.Edit3.Text:=form1.Edit3.Text+'  End';
finally
button2.enabled:=true;
Closefile(fbina);
Closefile(fbinb);
Closefile(ftyc2);
Closefile(fsup1);
Closefile(fidx2);
Closefile(fidx1);
end;
end else Showmessage('Input files not found : '+nom+' , '+nomsup+' , '+nomix);
button2.enabled:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Application.terminate;
end;

end.
