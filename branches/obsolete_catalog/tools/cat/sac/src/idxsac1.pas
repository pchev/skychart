unit idxsac1;

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
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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
 filidxnum = record clef :longint ;
                ar,de :single;
          end;

var
  Form1: TForm1;

implementation

const
maxl = 30000;

var
   f   : textfile;
   fo   : file of filidx;
   fon   : file of filidxnum;
   out : sacrec;
   inp : array[1..maxl] of filidx;
   inpn : array[1..maxl] of filidxnum;
   nl : integer;
   pathi,patho,filtre : string;

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
    buf,bufn,buf1,lin : string;
    sdec : single;
    ss1,ss2,desc : shortstring;
const blanc='                                                                  ';
begin
Assignfile(F,pathi);
Reset(F);
Readln(F,lin);
i:=0;
repeat
  Readln(F,lin);
  ss1:=trim(nextword(lin))+blanc;
  ss2:=trim(nextword(lin))+blanc;
  if ((filtre='') or (filtre='M ')) and (copy(ss2,1,2)='M ') then begin
     out.nom1:=ss2;
     out.nom2:=ss1;
  end else begin
     out.nom1:=ss1;
     out.nom2:=ss2;
  end;
  buf:=trim(nextword(lin));   //type
  buf:=trim(nextword(lin))+blanc;  //const
  buf:=trim(nextword(lin));
  out.ar:=15*(strtofloat(copy(buf,1,2))+strtofloat(copy(buf,4,4))/60);
  buf:=trim(nextword(lin));
  sdec:=strtofloat(copy(buf,1,1)+'1');
  out.de:=strtofloat(copy(buf,2,2));
  out.de:=out.de+strtofloat(copy(buf,5,2))/60;
  out.de:=out.de*sdec;
  if filtre='' then begin
    inc(i);
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
  end else begin
    buf:=UpperCase(trim(out.nom1));
    p:=pos(';',buf);
    if p>0 then buf:=copy(buf,1,p-1);
    if copy(buf,1,length(filtre))=filtre then begin
      inc(i);
      buf:=trim(copy(buf,length(filtre),99));
      bufn:='';
      for p:=1 to length(buf) do begin
        if (buf[p]>='0') and (buf[p]<='9') then bufn:=bufn+buf[p]
           else break;
      end;
      inpn[i].clef:=strtoint(bufn);
      inpn[i].ar:=out.ar;
      inpn[i].de:=out.de;
    end;
    buf:=UpperCase(trim(out.nom2));
    p:=pos(';',buf);
    if p>0 then buf:=copy(buf,1,p-1);
    if copy(buf,1,length(filtre))=filtre then begin
      inc(i);
      buf:=trim(copy(buf,length(filtre),99));
      bufn:='';
      for p:=1 to length(buf) do begin
        if (buf[p]>='0') and (buf[p]<='9') then bufn:=bufn+buf[p]
           else break;
      end;
      inpn[i].clef:=strtoint(bufn);
      inpn[i].ar:=out.ar;
      inpn[i].de:=out.de;
    end;
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
  linn: filidxnum;
begin
if filtre='' then begin
  assignfile(fo,patho);
  Rewrite(fo);
  for i:=1 to nl do begin
    lin:=inp[i];
    Write(Fo,lin);
  end;
  CloseFile(Fo);
end else begin
    assignfile(fon,patho);
    Rewrite(fon);
    for i:=1 to nl do begin
      linn:=inpn[i];
      Write(Fon,linn);
    end;
    CloseFile(Fon);
end;
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

Procedure TshellNum(g,d:integer);
var pas,i,j,k : integer;
    linn : filidxnum;
begin
pas:=1;
while pas < ((d-g+1) div 9) do pas :=pas*3+1;
repeat
  for k:=g to pas do begin
    i:=k+pas; if i<d then
    repeat
      linn:=inpn[i];
      j:=i-pas;
      while (j>=k+pas) and (inpn[j].clef > linn.clef) do begin
        inpn[j+pas] := inpn[j];
        j:=j-pas ;
      end;
      if inpn[k].clef > linn.clef then begin
        j:=k-pas;
        inpn[k+pas]:=inpn[k];
      end;
      inpn[j+pas]:=linn;
      i:=i+pas;
    until i>d;
  end;
  pas:=pas div 3;
until pas=0;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
pathi:=edit1.text;
patho:=edit2.text;
filtre:='';
  Lecture;
  edit3.text:=inttostr(nl);
  form1.update;
  Tshell(1,nl);
  Ecriture;
edit3.text:='End: '+inttostr(nl);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
pathi:=edit1.text;
patho:=edit4.text;
filtre:='NGC ';
  Lecture;
  edit3.text:=inttostr(nl);
  form1.update;
  TshellNum(1,nl);
  Ecriture;
edit3.text:='End: '+inttostr(nl);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
pathi:=edit1.text;
patho:=edit5.text;
filtre:='IC ';
  Lecture;
  edit3.text:=inttostr(nl);
  form1.update;
  TshellNum(1,nl);
  Ecriture;
edit3.text:='End: '+inttostr(nl);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
pathi:=edit1.text;
patho:=edit6.text;
filtre:='M ';
  Lecture;
  edit3.text:=inttostr(nl);
  form1.update;
  TshellNum(1,nl);
  Ecriture;
edit3.text:='End: '+inttostr(nl);
end;

initialization
  {$i idxsac1.lrs}

end.
