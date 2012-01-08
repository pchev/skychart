unit convbsc1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls, Buttons;

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
    Bsc5Rec = Record
                      hr     : array [1..4] of char;
                      cnum   : array [1..3] of char;
                      clet   : array [1..4] of char;
                      cons   : array [1..3] of char;
                      dm_cat : array [1..2] of char;
                      dm     : array [1..9] of char;
                      hd     : array [1..6] of char;
                      sao    : array [1..6] of char;
                      fk5    : array [1..4] of char;
                      ir_flag: char;
                      ir_fla : char;
                      multip : char;
                      ads    : array [1..5] of char;
                      ads_co : array [1..2] of char;
                      var_id : array [1..9] of char;
                      rah_19 : array [1..2] of char;
                      ram_19 : array [1..2] of char;
                      ras_19 : array [1..4] of char;
                      decsig1: char;
                      decd_1 : array [1..2] of char;
                      decm_1 : array [1..2] of char;
                      decs_1 : array [1..2] of char;
                      rah    : array [1..2] of char;
                      ram    : array [1..2] of char;
                      ras    : array [1..4] of char;
                      decsig : char;
                      decd   : array [1..2] of char;
                      decm   : array [1..2] of char;
                      decs   : array [1..2] of char;
                      glon_o : array [1..6] of char;
                      glat_o : array [1..6] of char;
                      v      : array [1..5] of char;
                      v_code : char;
                      v_unc  : char;
                      b_v    : array [1..5] of char;
                      b_v_un : char;
                      u_b    : array [1..5] of char;
                      u_b_un : char;
                      r_i    : array [1..5] of char;
                      r_i_co : char;
                      sptype : array [1..20] of char;
                      sp_code: char;
                      pmar   : array [1..6] of char;
                      pmde   : array [1..6] of char;
                      par_co : char;
                      paralla: array [1..5] of char;
                      radvel : array [1..4] of char;
                      radvco : array [1..4] of char;
                      lrotv  : array [1..2] of char;
                      rotvel : array [1..3] of char;
                      rotvco : char;
                      dmag   : array [1..4] of char;
                      mu_sep : array [1..6] of char;
                      mult_i : array [1..4] of char;
                      mult_c : array [1..2] of char;
                      note_f : char;
                      cr     : char;
              end;

              BSCrec = record hd,bs,ar,de :longint ;
                              pmar,pmde:smallint;
                              mv,b_v   :smallint;
                              cons     : array [1..3] of char;
                              flam     : byte;
                              bayer    : array[1..4]of char;
                              sp       : array[1..20] of char;
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
   F: file of bsc5rec;
   bsl : bsc5rec;
   fb : file of BSCrec;
   out : BSCrec;
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
    clet : array[1..4] of char;
begin
Assignfile(F,pathi+'\catalog.txt');
Reset(F);
assignfile(fb,patho+'\'+padzeros(inttostr(lgnum),2)+'.dat');
Rewrite(fb);
i:=0;
repeat
  Read(F,bsl);
  if bsl.hd>'      ' then out.hd := strtoint(bsl.hd)
                     else out.hd := 0;
  if out.hd=0 then continue ;
  out.pmar:=round(strtofloat(bsl.pmar)*1000);
  out.pmde:=round(strtofloat(bsl.pmde)*1000);
  de := strtofloat(trim(bsl.decsig)+trim(bsl.decd))+strtofloat(trim(bsl.decsig)+trim(bsl.decm))/60+strtofloat(trim(bsl.decsig)+trim(bsl.decs))/3600;
  ar := strtofloat(bsl.rah)+strtofloat(bsl.ram)/60+strtofloat(bsl.ras)/3600;
  ar:=15*ar;
  findregion(ar,de,zone);
  if zone=lgnum then begin
  inc(i);
  out.de:=round(de*100000);
  out.ar:=round(ar*100000);
  if bsl.v>'      ' then out.mv:= round(strtofloat(bsl.v)*100)
                     else out.mv:= 9900;
  if bsl.b_v>'      ' then out.b_v:= round(strtofloat(bsl.b_v)*100)
                      else out.b_v:= 9900;
  out.bs := strToInt(bsl.hr);
  if bsl.cnum>'   ' then out.flam := strtoint(bsl.cnum)
                    else out.flam := 0;
  move(bsl.clet,out.bayer,sizeof(out.bayer)) ;
  move(bsl.cons,out.cons,sizeof(out.cons)) ;
  move(bsl.sptype,out.sp,sizeof(out.sp)) ;
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
