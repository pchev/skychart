unit convngc1;

interface

uses
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
    ngcRec = Record   ic     : char;
                      id     : array [1..4] of char;
                      s2     : char;
                      typ    : array [1..3] of char;
                      s3     : char;
                      rah    : array [1..2] of char;
                      s4     : char;
                      ram    : array [1..4] of char;
                      s5     : char;
                      s6     : char;
                      decsig : char;
                      decd   : array [1..2] of char;
                      s7     : char;
                      decm   : array [1..2] of char;
                      s8     : char;
                      source : char;
                      s9     : char;
                      s10    : char;
                      cons   : array [1..3] of char;
                      l_dim  : char;
                      dim    : array [1..5] of char;
                      s12    : char;
                      s13    : char;
                      ma     : array [1..4] of char;
                      n_ma   : char;
                      s14    : char;
                      desc   : array [1..50] of char;
                      cr     : char;
              end;
              NGCbin = record ar,de :longint ;
                              id    : word;
                              ic    : char;
                              typ   : array [1..3] of char;
                              l_dim : char;
                              n_ma  : char;
                              ma,dim:smallint;
                              cons  : array [1..3] of char;
                              desc  : array[1..50] of char;
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
   F: file of ngcrec;
   ngcl : ngcrec;
   fb : file of ngcbin;
   out : ngcbin;
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

procedure wrt_lg(lgnum:integer);
var i,n,zone :integer;
    ar,de : extended;
begin
Assignfile(F,pathi+'\ngc2000c.txt');
Reset(F);
assignfile(fb,patho+'\'+padzeros(inttostr(lgnum),2)+'.dat');
Rewrite(fb);
i:=0;
repeat
  Read(F,ngcl);
  de := strtofloat(trim(ngcl.decsig)+trim(ngcl.decd))+strtofloat(trim(ngcl.decsig)+trim(ngcl.decm))/60;
  ar := strtofloat(ngcl.rah)+strtofloat(ngcl.ram)/60;
  ar:=15*ar;
  findregion(ar,de,zone);
  if zone=lgnum then begin
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  if ngcl.ma>'    ' then out.ma:= round(strtofloat(ngcl.ma)*100)
                    else out.ma:= 9900;
  if ngcl.dim>'     ' then out.dim:= round(strtofloat(ngcl.dim)*10)
                      else out.dim:= 0;
  out.id := strToInt(ngcl.id);
  move(ngcl.cons,out.cons,sizeof(out.cons));
  move(ngcl.desc,out.desc,sizeof(out.desc));
  move(ngcl.ic,out.ic,sizeof(out.ic));
  move(ngcl.typ,out.typ,sizeof(out.typ));
  move(ngcl.l_dim,out.l_dim,sizeof(out.l_dim));
  move(ngcl.n_ma,out.n_ma,sizeof(out.n_ma));
  write(fb,out);
  if (i mod 100)=0 then begin
     form1.Edit3.Text:=inttostr(i);
     Form1.Update;
  end;
  end;
until eof(F);        
form1.Edit3.Text:=inttostr(i);
Form1.Update;
close(fb);
Close(F);
end;

procedure TForm1.Button1Click(Sender: TObject);
var lgnum : integer;
begin
pathi:=edit1.text;
patho:=edit2.text;
for lgnum:=1 to 50 do begin
  Edit1.Text:=inttostr(lgnum);
  wrt_lg(lgnum);
end;
end;

end.
