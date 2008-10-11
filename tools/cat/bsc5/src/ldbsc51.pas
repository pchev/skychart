unit ldbsc51;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    bsc: TTable;
    Query1: TQuery;
    astrodb: TDatabase;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;
Type
    Bsc5Rec = Record  s1     : char;
                      hr     : array [1..4] of char;
                      s2     : char;
                      cnum   : array [1..3] of char;
                      clet   : array [1..4] of char;
                      cons   : array [1..3] of char;
                      s3     : char;
                      dm_cat : array [1..6] of char;
                      s4     : char;
                      dm     : array [1..9] of char;
                      s5     : char;
                      hd     : array [1..6] of char;
                      s6     : char;
                      sao    : array [1..6] of char;
                      s7     : char;
                      fk5    : array [1..4] of char;
                      s8     : char;
                      ir_flag: array [1..6] of char;
                      s9     : char;
                      ir_fla : array [1..6] of char;
                      s10    : char;
                      multip : array [1..6] of char;
                      s11    : char;
                      ads    : array [1..5] of char;
                      s12    : char;
                      ads_co : array [1..6] of char;
                      s13    : char;
                      var_id : array [1..9] of char;
                      s14    : char;
                      rah_19 : array [1..6] of char;
                      s15    : char;
                      ram_19 : array [1..6] of char;
                      s16    : char;
                      ras_19 : array [1..8] of char;
                      s17    : char;
                      decsig1: array [1..6] of char;
                      s18    : char;
                      decd_1 : array [1..6] of char;
                      s19    : char;
                      decm_1 : array [1..6] of char;
                      s20    : char;
                      decs_1 : array [1..6] of char;
                      s21    : char;
                      rah    : array [1..3] of char;
                      s22    : char;
                      ram    : array [1..3] of char;
                      s23    : char;
                      ras    : array [1..4] of char;
                      s24    : char;
                      decsig : array [1..6] of char;
                      s25    : char;
                      decd   : array [1..4] of char;
                      s26    : char;
                      decm   : array [1..4] of char;
                      s27    : char;
                      decs   : array [1..4] of char;
                      s28    : char;
                      glon_o : array [1..9] of char;
                      s29    : char;
                      glat_o : array [1..9] of char;
                      s30    : char;
                      v      : array [1..4] of char;
                      s31    : char;
                      v_code : array [1..6] of char;
                      s32    : char;
                      v_unc  : array [1..5] of char;
                      s33    : char;
                      b_v    : array [1..4] of char;
                      s34    : char;
                      b_v_un : array [1..6] of char;
                      s35    : char;
                      u_b    : array [1..4] of char;
                      s36    : char;
                      u_b_un : array [1..6] of char;
                      s37    : char;
                      r_i    : array [1..4] of char;
                      s38    : char;
                      r_i_co : array [1..6] of char;
                      s39    : char;
                      sptype : array [1..20] of char;
                      s40    : char;
                      sp_code: array [1..11] of char;
                      s41    : char;
                      pm_ra  : array [1..6] of char;
                      s42    : char;
                      pm_dec : array [1..6] of char;
                      s43    : char;
                      par_co : array [1..6] of char;
                      s44    : char;
                      paralla: array [1..8] of char;
                      s45    : char;
                      radvel : array [1..6] of char;
                      s46    : char;
                      radvco : array [1..6] of char;
                      s47    : char;
                      rotvel : array [1..6] of char;
                      s48    : char;
                      rotvco : array [1..6] of char;
                      s49    : char;
                      rotvco2: array [1..6] of char;
                      s49a   : char;
                      mu_mdif: array [1..10] of char;
                      s50    : char;
                      mu_sep : array [1..8] of char;
                      s51    : char;
                      mult_i : array [1..6] of char;
                      s52    : char;
                      mult_c : array [1..6] of char;
                      s53    : char;
                      note_f : array [1..6] of char;
                      s54    : char;
                      glon   : array [1..8] of char;
                      s55    : char;
                      glat   : array [1..8] of char;
                      s56    : char;
                      ra     : array [1..8] of char;
                      s57    : char;
                      dec    : array [1..8] of char;
                      s58    : char;
                      cra    : array [1..8] of char;
                      s59    : char;
                      cdec   : array [1..7] of char;
                      s60    : char;
                      ra1950 : array [1..8] of char;
                      s61    : char;
                      de1950 : array [1..8] of char;
                      s62    : char;
                      cra1950: array [1..8] of char;
                      s63    : char;
                      cde1950: array [1..7] of char;
                      s64    : char;
                      cntr   : array [1..4] of char;
                      s65    : char;
                      crlf   : array [1..2] of char;
              end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
var
   F: file of bsc5rec;
   bsl : bsc5rec;

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
    ar,de,mv,b_v : extended;
    bs,cons,cnum,hd : integer;
    clet,dm_cat,dm,sp : string;
begin
System.Assign(F,'D:\appli\astro\bsc5\bsc5.txt');
System.Reset(F);
astrodb.starttransaction;
i:=0;
repeat
  inc(i);
  System.Read(F,bsl);
  if bsl.hd>'      ' then hd := strtoint(bsl.hd)
                     else hd := 0;
  if hd=0 then continue ;
  de := strtofloat(trim(bsl.decsig)+trim(bsl.decd))+strtofloat(trim(bsl.decsig)+trim(bsl.decm))/60+strtofloat(trim(bsl.decsig)+trim(bsl.decs))/3600;
  ar := strtofloat(bsl.rah)+strtofloat(bsl.ram)/60+strtofloat(bsl.ras)/3600;
  if bsl.v>'      ' then mv:= strtofloat(bsl.v)
                     else mv:= 99;
  if bsl.b_v>'      ' then b_v:= strtofloat(bsl.b_v)
                      else b_v:= 99;
  bs := strToInt(bsl.hr);
  if bsl.cnum>'   ' then cnum := strtoint(bsl.cnum)
                    else cnum := 0;
  clet := trim(bsl.clet);
  if bsl.cons>'   ' then cons := constel(bsl.cons)
                    else cons := 0;
  dm_cat:=trim(bsl.dm_cat);
  dm := trim(bsl.dm);
  sp := trim(bsl.sptype);

  bsc.AppendRecord([ar,de,bs,cons,cnum,clet,dm_cat,dm,hd,mv,b_v,sp]);
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
