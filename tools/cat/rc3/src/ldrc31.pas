unit ldrc31;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Trc3: TTable;
    Edit1: TEdit;
    Edit2: TEdit;
    astrodb: TDatabase;
    procedure Button1Click(Sender: TObject);
    procedure astrodbLogin(Database: TDatabase; LoginParams: TStrings);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
type Rc3rec = record arh : array[1..2] of char;
                     arm : array[1..2] of char;
                     ars : array[1..4] of char;
                     s3  : char;
                     sde : char;
                     ded : array[1..2] of char;
                     dem : array[1..2] of char;
                     des : array[1..2] of char;
                     s6  : array [1..46] of char;
                     name : array[1..12] of char;
                     s61 : char;
                     altn: array[1..14] of char;
                     s62 : char;
                     desig: array[1..14] of char;
                     s7  : char;
                     pgc : array[1..11] of char;
                     s8  : char;
                     typ : array[1..7] of char;
                     s9  : array [1..7] of char;
                     stage: array[1..4] of char;
                     s10 : array [1..6] of char;
                     lumcl: array[1..4] of char;
                     s11 : array[1..6] of char;
                     d25 : array[1..4] of char;
                     s12 : array [1..6] of char;
                     r25 : array[1..4] of char;
                     s13 : array[1..11] of char;
                     ae  : array[1..4] of char;
                     s15 : array [1..5] of char;
                     pa  : array[1..3] of char;
                     s16 : char;
                     bt  : array[1..5] of char;
                     s17 : array[1..6] of char;
                     mb  : array[1..5] of char;
                     s18 : array[1..11] of char;
                     m25 : array[1..5] of char;
                     s19 :array[1..6] of char;
                     me  :array [1..5] of char;
                     s20 :array[1..20] of char;
                     b_vt:array[1..4] of char;
                     s21 :array[1..5] of char;
                     b_ve:array[1..4]of char;
                     s22 :array[1..87]of char;
                     vgsr:array[1..5] of char;
                     s23 :array[1..7]of char;
                     end;
var
  rc3f : File of rc3rec;
  rc3 : rc3rec;

procedure TForm1.Button1Click(Sender: TObject);
var i,n:integer;
    ar,de,sde,stage,lumcl,d25,r25,ae,pa,mb,b_v,sm :double;
    nom,typ :string;
    vgsr :integer;
begin
nom:='rc3';
Edit1.Text:=nom;
Form1.Update;
System.Assign(rc3f,'D:\appli\astro\rc\'+nom+'.txt');
System.Reset(rc3f);
with Trc3 do begin
active:=true;
astrodb.starttransaction;
i:=0;
repeat
  inc(i);
  Insert;
  System.Read(rc3f,rc3);
  sde:=strtofloat(rc3.sde+'1');
  de := sde*strtofloat(rc3.ded)+sde*strtofloat(rc3.dem)/60 ;
  if trim(rc3.des)>'' then de:=de+sde*strtofloat(rc3.des)/3600;
  ar := strtofloat(rc3.arh)+strtofloat(rc3.arm)/60+strtofloat(rc3.ars)/3600;
  nom:=trim(rc3.name);
  if nom='' then nom:=trim(rc3.altn);
  if nom='' then nom:=trim(rc3.desig);
  if nom='' then nom:=trim(rc3.pgc);
  typ:=trim(rc3.typ);
  if trim(rc3.stage)>'' then stage:=strtofloat(rc3.stage)
                        else stage:=-999;
  if trim(rc3.lumcl)>'' then lumcl:=strtofloat(rc3.lumcl)
                        else lumcl:=-999;
  if trim(rc3.d25)>'' then d25:=strtofloat(rc3.d25)
                        else d25:=-999;
  if trim(rc3.r25)>'' then r25:=strtofloat(rc3.r25)
                        else r25:=-999;
  if trim(rc3.ae)>'' then ae:=strtofloat(rc3.ae)
                        else ae:=-999;
  if trim(rc3.pa)>'' then pa:=strtofloat(rc3.pa)
                        else pa:=-999;
  if trim(rc3.bt)>'' then mb:=strtofloat(rc3.bt)
                        else mb:=-999;
  if (mb=-999) and (trim(rc3.mb)>'') then mb:=strtofloat(rc3.mb);
  if trim(rc3.me)>'' then sm:=strtofloat(rc3.me)
                        else sm:=-999;
  if (sm=-999) and (trim(rc3.m25)>'') then sm:=strtofloat(rc3.m25);
  if trim(rc3.b_vt)>'' then b_v:=strtofloat(rc3.b_vt)
                        else b_v:=-999;
  if (b_v=-999) and (trim(rc3.b_ve)>'') then b_v:=strtofloat(rc3.b_ve);
  if trim(rc3.vgsr)>'' then vgsr:=strtoint(rc3.vgsr)
                        else vgsr:=-999999;
  Trc3.AppendRecord([ar,de,nom,typ,stage,lumcl,d25,r25,ae,pa,mb,b_v,sm,vgsr]);
  if (i mod 1000)=0 then begin
     Edit2.Text:=inttostr(i);
     Form1.Update;
  end;
until system.eof(rc3f);
Edit2.Text:=inttostr(i);
Form1.Update;
astrodb.commit;
astrodb.connected:=false;
System.Close(rc3f);
Edit2.Text:=inttostr(i)+' Commited';
end;
end;

procedure TForm1.astrodbLogin(Database: TDatabase; LoginParams: TStrings);
begin
  LoginParams.Values['USER NAME'] := 'STARS';
  LoginParams.Values['PASSWORD'] := 'stars';
end;

end.
