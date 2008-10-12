unit idxsac1;

interface

uses
  math,StrUtils,
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
SACrec = record
            ar,de,ma,sbr,s1,s2 : single;
            pa : byte;
            nom1 : string[17];
            nom2 : string[18];
            typ,cons  : string[3];
            desc : string[120];
            clas : string[11];
         end;
 filidx = record clef :string[18];
                 ar,de :single;
          end;
var
  Form1: TForm1;

implementation

{$R *.DFM}
const
maxl = 30000;

var
   f   : textfile;
   fo   : file of filidx;
   out : sacrec;
   inp : array[1..maxl] of filidx;
   nl : integer;
   pathi,patho : string;

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
    buf,buf1,lin : string;
    sdec : single;
    ss1,ss2,desc : shortstring;
const blanc='                                                                  ';
begin
Assignfile(F,pathi);
Reset(F);
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
  out.de:=out.de*sdec;
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
  ss1:=replacestr(copy(buf,1,7),'<','');
  ss1:=trim(replacestr(ss1,'?',''));
  if ss1='' then out.s1:=0
  else case buf[8] of
     'd' : out.s1:=strtofloat(ss1)*60;
     'm' : out.s1:=strtofloat(ss1);
     's' : out.s1:=strtofloat(ss1)/60;
     else showmessage('erreur s1 '+buf+'  '+inttostr(i));
  end;
  buf:=nextword(lin);
  ss1:=replacestr(copy(buf,1,7),'<','');
  ss1:=trim(replacestr(ss1,'?',''));
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
  desc:=desc+';'+buf+blanc;
  out.desc:=desc;
{  if copy(buf,1,2)='PA' then begin
     p:=pos(',',buf);
     if p=0 then p:=999;
     val(copy(buf,3,p-3),out.pa,p);
     if p>0 then out.pa:=255;
  end else out.pa:=255;}
  inp[i].clef:=UpperCase(stringreplace(out.nom1,' ','',[rfReplaceAll]));
  inp[i].ar:=out.ar;
  inp[i].de:=out.de;
  if trim(out.nom2)>'' then begin
  buf:=UpperCase(stringreplace(out.nom2,' ','',[rfReplaceAll]));
  repeat
  p:=pos(';',buf);
  if p>0 then begin
     buf1:=copy(buf,1,p-1);
     buf:=copy(buf,p+1,99);
  end else buf1:=buf;
  inc(i);
  inp[i].clef:=buf1;
  inp[i].ar:=out.ar;
  inp[i].de:=out.de;
  until p=0;
  end;
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
edit3.text:='terminé '+inttostr(nl);
end;

end.
