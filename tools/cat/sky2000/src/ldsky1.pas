unit ldsky1;

interface

uses       
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Tsky: TTable;
    Edit1: TEdit;
    Edit2: TEdit;
    astrocat: TDatabase;
    procedure Button1Click(Sender: TObject);
    procedure astrocatLogin(Database: TDatabase; LoginParams: TStrings);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
type Skyrec = record id  : array[1..8] of char;
                     hd  : array[1..6] of char;
                     s1  : array[1..2] of char;
                     sao : array[1..6] of char;
                     s2  : char;
                     dm_cat: array[1..2] of char;
                     dm_z: array[1..3] of char;
                     dm_n: array[1..5] of char;
                     s3  : array [1..58] of char;
                     arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..6] of char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..5] of char;
                     s4  : array[1..86] of char;
                     vo  : array[1..6] of char;
                     vd  : array[1..5] of char;
                     s5  : array[1..9] of char;
                     bo  : array[1..6] of char;
                     s6  : array[1..40] of char;
                     bp  : array[1..4] of char;
                     s7  : array[1..34] of char;
                     sp  : array[1..3] of char;
                     s8  : array[1..2] of char;
                     sep : array[1..7] of char;
                     d_m : array[1..5] of char;
                     s9  : array[1..145] of char;
                     cr  : char;
                     end;
var
  f : File of skyrec;
  lin : skyrec;

procedure TForm1.Button1Click(Sender: TObject);
var i,n:integer;
    sde,ar,de,v,b,sep,d_m :extended ;
    id,hd,sao,dm_z,dm_n :integer;
    nom,dm_cat,sp : string;
begin
for n:=0 to 23 do begin
nom:='sky'+trim(inttostr(n))+'.txt';
Edit1.Text:=nom;
Form1.Update;
System.Assign(f,'E:\Catalogues\sky2000\'+nom);
System.Reset(f);
with Tsky do begin
active:=true;
astrocat.starttransaction;
i:=0;
repeat
  System.Read(f,lin);
  inc(i);
  sde:=strtofloat(lin.sde+'1');
  de := sde*strtofloat(lin.ded)+sde*strtofloat(lin.dem)/60;
  if trim(lin.des)>'' then de:=de+sde*strtofloat(lin.des)/3600 ;
  ar := strtofloat(lin.arh)+strtofloat(lin.arm)/60+strtofloat(lin.ars)/3600;
  v := 99;
  if trim(lin.vo)>'' then v:=strtofloat(lin.vo);
  if (v=99) and (trim(lin.vd)>'') then v:=strtofloat(lin.vd);
  b := 99;
  if trim(lin.bo)>'' then b:=strtofloat(lin.bo);
  if (b=99) and (trim(lin.bp)>'') then b:=strtofloat(lin.bp);
  if trim(lin.sep)>'' then sep:=strtofloat(lin.sep)
                      else sep:=0;
  if trim(lin.d_m)>'' then d_m:=strtofloat(lin.d_m)
                      else d_m:=0;
  id:=strtoint(lin.id);
  if trim(lin.hd)>'' then hd:=strtoint(lin.hd)
                     else hd:=0;
  if trim(lin.sao)>'' then sao:=strtoint(lin.sao)
                      else sao:=0;
  if trim(lin.dm_z)>'' then dm_z:=strtoint(lin.dm_z)
                       else dm_z:=0;
  if trim(lin.dm_n)>'' then dm_n:=strtoint(lin.dm_n)
                       else dm_n:=0;
  sp:=lin.sp;                        
  dm_cat:=lin.dm_cat;                       
  AppendRecord([ar,de,v,b,sp,sep,d_m,id,hd,sao,dm_cat,dm_z,dm_n]);
  if (i mod 1000)=0 then begin
     Edit2.Text:=inttostr(i);
     Form1.Update;
  end;
until system.eof(f);
Edit2.Text:=inttostr(i);
Form1.Update;
astrocat.commit;
astrocat.connected:=false;
System.Close(f);
Edit2.Text:=inttostr(i)+' Commited';
end;
end;
end;

procedure TForm1.astrocatLogin(Database: TDatabase; LoginParams: TStrings);
begin
  LoginParams.Values['USER NAME'] := 'STARS';
  LoginParams.Values['PASSWORD'] := 'stars';
end;

end.
