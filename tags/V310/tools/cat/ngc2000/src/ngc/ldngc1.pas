unit ldngc1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    ngc: TTable;
    Query1: TQuery;
    astrodb: TDatabase;
    ic: TTable;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;
Type
    ngcRec = Record   ic_ngc : char;
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
                      s11    : char;
                      dim    : array [1..5] of char;
                      s12    : char;
                      s13    : char;
                      ma     : array [1..4] of char;
                      map    : char;
                      s14    : char;
                      descr  : array [1..50] of char;
                      cr     : char;
              end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
var
   F: file of ngcrec;
   ngcl : ngcrec;

Function constel(n:string):integer;
begin
form1.query1.close;
form1.Query1.Params[0].AsString := n;
form1.query1.open;
form1.query1.first;
constel:=form1.Query1.Fields[0].AsInteger;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i,n:integer;
    ar,de,ma,dim : extended;
    id,cons,typ : integer;
    descr : string;
begin
System.Assign(F,'D:\appli\astro\ngc2000\ngc2000.txt');
System.Reset(F);
astrodb.starttransaction;
i:=0;
repeat
  inc(i);
  System.Read(F,ngcl);
  de := strtofloat(trim(ngcl.decsig)+trim(ngcl.decd))+strtofloat(trim(ngcl.decsig)+trim(ngcl.decm))/60;
  ar := strtofloat(ngcl.rah)+strtofloat(ngcl.ram)/60;
  if ngcl.ma>'    ' then ma:= strtofloat(ngcl.ma)
                    else ma:= 99;
  if ngcl.dim>'     ' then dim:= strtofloat(ngcl.dim)
                      else dim:= 0;
  id := strToInt(ngcl.id);
  if ngcl.cons>'   ' then cons := constel(ngcl.cons)
                     else cons := 0;
  descr:=trim(ngcl.descr);
  if trim(ngcl.typ)='Gx'  then typ:=1;
  if trim(ngcl.typ)='OC'  then typ:=2;
  if trim(ngcl.typ)='Gb'  then typ:=3;
  if trim(ngcl.typ)='Nb'  then typ:=5;
  if trim(ngcl.typ)='Pl'  then typ:=4;
  if trim(ngcl.typ)='C+N'  then typ:=6;
  if trim(ngcl.typ)='Ast'  then typ:=10;
  if trim(ngcl.typ)='Kt'  then typ:=11;
  if trim(ngcl.typ)='***'  then typ:=9;
  if trim(ngcl.typ)='D*'  then typ:=8;
  if trim(ngcl.typ)='*'  then typ:=7;
  if trim(ngcl.typ)='?'  then typ:=0;
  if ngcl.typ='   '  then typ:=0;
  if trim(ngcl.typ)='-'  then typ:=-1;
  if trim(ngcl.typ)='PD'  then typ:=-1;
  if ngcl.ic_ngc='I' then ic.AppendRecord([id,ar,de,typ,dim,ma,cons,descr])
                else ngc.AppendRecord([id,ar,de,typ,dim,ma,cons,descr]);
  if (i mod 100)=0 then begin
     Edit1.Text:=inttostr(i);
     Form1.Update;
  end;
until system.eof(F);
Edit1.Text:=inttostr(i);
Form1.Update;
astrodb.commit;
System.Close(F);
Edit1.Text:=inttostr(i)+' Commited';
end;

end.
