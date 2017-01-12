unit extract_pn1;

{ extract a text file from the old gpn CdC catalog

  copy the source to skychart/library/catalog to compile and run
}  

{$mode objfpc}{$H+}

interface

uses gpnunit,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var lin: GPNrec;
  f: textfile;
  i:integer;
  ok:boolean;
  ar,de :string;
  dim,mv,mHb,cs_b,cs_v : string;
  ldim,lv,morph,cs_lb,cs_lv : char;
  png : string;
  pk  : string;
  nam: string;
const f7='##0.0000000';
      f2='##0.00';
      b='                                       ';
begin
  AssignFile(f,'gpn.txt');
  rewrite(f);
  mv:=copy('MV'+b,1,8);
  dim:=copy('DIM'+b,1,8);
  ar:=copy('RA'+b,1,15);
  de:=copy('DEC'+b,1,15);
  nam:=copy('NAME'+b,1,15);
  pk:=copy('PK'+b,1,15);
  png:=copy('GPN'+b,1,15);
  mhb:=copy('MHB'+b,1,8);
  cs_v:=copy('CS V'+b,1,8);
  cs_b:=copy('CS B'+b,1,8);
  ldim:='L';
  lv:='L';
  morph:='M';
  cs_lb:='L';
  cs_lv:='L';
  writeln(f,png,pk,nam,ar,de,lv,mv,mhb,ldim,dim,morph,cs_lv,cs_v,cs_lb,cs_b);

  SetGPNpath('/usr/local/share/skychart/cat/gpn');
  for i:=1 to 50 do begin
    OpenRegion(i,ok);
    while ok do begin
      ReadGPN(lin,ok);
      if ok and (trim(lin.png)>'') then begin
        if lin.mv<9000 then
          mv:=copy(FormatFloat(f2,lin.mv/100)+b,1,8)
        else
          mv:=copy(b,1,8);
        if lin.dim>0.001 then
          dim:=copy(FormatFloat(f2,lin.dim/10)+b,1,8)
        else
          dim:=copy(b,1,8);
        ar:=copy(FormatFloat(f7,lin.ar/100000)+b,1,15);
        de:=copy(FormatFloat(f7,lin.de/100000)+b,1,15);
        nam:=copy(lin.name+b,1,15);
        pk:=lin.pk;
        if pk='      .  ' then
           pk:=copy(b,1,15)
        else
           pk:=copy('PK'+pk+b,1,15);
        png:=copy(lin.png+b,1,15);
        if lin.mhb<9000 then
          mhb:=copy(FormatFloat(f2,lin.mHb/100)+b,1,8)
        else
          mhb:=copy(b,1,8);
        if lin.cs_v<9000 then
          cs_v:=copy(FormatFloat(f2,lin.cs_v/100)+b,1,8)
        else
          cs_v:=copy(b,1,8);
        if lin.cs_b<9000 then
          cs_b:=copy(FormatFloat(f2,lin.cs_b/100)+b,1,8)
        else
          cs_b:=copy(b,1,8);
        ldim:=lin.ldim;
        lv:=lin.lv;
        morph:=lin.morph;
        cs_lb:=lin.cs_lb;
        cs_lv:=lin.cs_lv;
        writeln(f,png,pk,nam,ar,de,lv,mv,mhb,ldim,dim,morph,cs_lv,cs_v,cs_lb,cs_b);
      end;

    end;
  end;
  closefile(f);
end;

end.

