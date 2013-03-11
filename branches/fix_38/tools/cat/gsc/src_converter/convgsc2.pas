unit convgsc2;

interface

uses SortGSC1,FileCtrl,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
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
type GSCrec = record
                     ar,de : longint;
                     gscn: word;
                     pe,m,me :smallint;
                     mb,cl : shortint;
                     mult : char;
                     end;
var
  fgsc : file;
  f : File of GSCrec;
  lin : GSCrec;

procedure ReadFITSHeader(var nrecs :integer);
const maxl = 2880;
var debut,fin : boolean;
    t: string;
    d1,d2,l,r,i,recsz : integer;
    header,value : string;
    buf : array [1..maxl] of char;
begin
reset(fgsc,1);
l:=80;
debut:=true; fin:=false;
repeat
 BlockRead(fgsc,buf,maxl,r);
 for i:=0 to 35 do begin
   t:=copy(buf,80*i+1,l);
   d1:=pos('=',t);
   if (d1=0) and (trim(t)<>'END') then continue;
   d2:=pos('/',t);
   if d2=0 then d2:=l ;
   header:=trim(copy(t,1,d1-1));
   value:=trim(copy(t,d1+1,d2-d1-1));
   if (header='XTENSION') and (copy(value,2,5)='TABLE') then debut:=false;
   if debut then continue;
   if trim(t)='END' then fin:=true;
   if (header='NAXIS1') then recsz:=strtoint(value);
   if (header='NAXIS2') then nrecs:=strtoint(value);
 end;
until fin;
end;

Procedure ConvGSC(nom,dirin,dirout : string);
var nrecs,n,r,l : integer;
    buf : array [1..45] of char ;
    tt :string        ;
begin
tt:=dirout+'\'+copy(nom,1,4)+'.dat';
Assignfile(f,tt);
Rewrite(f);
AssignFile(fgsc,dirin+'\'+nom);
ReadFITSheader(nrecs);
l:=45;
for n:=1 to nrecs do begin
 BlockRead(fgsc,buf,l,r);
 lin.gscn := strtoint(copy(buf,1,5));
 lin.ar:=round(strtofloat(copy(buf,6,9))*100000);
 lin.de:=round(strtofloat(copy(buf,15,9))*100000);
 lin.pe:=round(strtofloat(copy(buf,24,5))*10);
 lin.m:=round(strtofloat(copy(buf,29,5))*100);
 lin.me:=round(strtofloat(copy(buf,34,4))*100);
 lin.mb:=strtoint(copy(buf,38,2));
 lin.cl:=strtoint(copy(buf,40,1));
 lin.mult:=buf[45];
 write(f,lin);
end;
Closefile(f);
Closefile(fgsc);
SortFile(tt);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    rc,n :integer;
    zonein,zoneout : string;
    buf : string;
begin
zonein:=Edit1.Text;
zoneout:=Edit3.Text;
buf:=edit2.text;
convGSC(buf,zonein,zoneout);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

end.
