unit convgsc1;

interface

uses SortGSC1,FileCtrl,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ExtCtrls, BrowseDr, Buttons;

// use componant TBrowseDirectoryDlg by Brad Stowers  http://www.pobox.com/~bstowers/delphi/ 

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
    Panel1: TPanel;
    nonstellar: TCheckBox;
    multiple: TCheckBox;
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    Edit4: TEdit;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    BrowseDirectoryDlg1: TBrowseDirectoryDlg;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
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
  running,stoping : boolean;

procedure ReadFITSHeader(var nrecs :integer);
const maxl = 2880;
var debut,fin : boolean;
    t: string;
    d1,d2,l,r,i,recsz : integer;
    header,value : string;
    buf : array [1..maxl] of char;
    itsfits : boolean;
begin
itsfits:=false;
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
   if (header='SIMPLE')and(value='T') then itsfits:=true;
   if (header='XTENSION') and (copy(value,2,5)='TABLE') then debut:=false;
   if debut then continue;
   if trim(t)='END' then fin:=true;
   if (header='NAXIS1') then recsz:=strtoint(value);
   if (header='NAXIS2') then nrecs:=strtoint(value);
 end;
 if not itsfits then raise Exception.Create('Incorrect input file, not FITS format');
until fin;
end;

Procedure ConvGSC(nom,dirin,dirout : string);
var nrecs,n,r,l,pnum : integer;
    buf : array [1..45] of char ;
    tt :string        ;
begin
pnum:=-1;
FileMode:=0;
tt:=dirout+'\'+copy(nom,1,4)+'.dat';
Assignfile(f,tt);
Rewrite(f);
AssignFile(fgsc,dirin+'\'+nom);
ReadFITSheader(nrecs);
l:=45;
for n:=1 to nrecs do begin
 BlockRead(fgsc,buf,l,r);
 lin.gscn := strtoint(copy(buf,1,5));
 lin.mult:=buf[45];
 if form1.multiple.Checked and (lin.mult='T') then begin
    if lin.gscn=pnum then continue;
    pnum:=lin.gscn;
 end;
 lin.cl:=strtoint(copy(buf,40,1));
 if form1.nonstellar.Checked and (lin.cl>0) and (lin.cl<>2) then continue;
 lin.ar:=round(strtofloat(copy(buf,6,9))*100000);
 lin.de:=round(strtofloat(copy(buf,15,9))*100000);
 lin.pe:=round(strtofloat(copy(buf,24,5))*10);
 lin.m:=round(strtofloat(copy(buf,29,5))*100);
 lin.me:=round(strtofloat(copy(buf,34,4))*100);
 lin.mb:=strtoint(copy(buf,38,2));
 write(f,lin);
end;
Closefile(f);
Closefile(fgsc);
form1.edit3.text:=form1.edit3.text+' Sorting';
form1.edit3.update;
SortFile(tt);
Application.processmessages;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    rc,n,i :integer;
    dirin,dirout,zonein,zoneout,currentzone : string;
    dirlst : Tsearchrec;
const nlst : array [0..11,1..5] of char =
       ('N0000','N0730','N1500','N2230','N3000','N3730','N4500','N5230','N6000','N6730','N7500','N8230');
      slst : array [0..11,1..5] of char =
      ('S8230','S7500','S6730','S6000','S5230','S4500','S3730','S3000','S2230','S1500','S0730','S0000');
//
procedure convertzone;
begin
forcedirectories(zoneout);
rc:=FindFirst(zonein+'\*.gsc',0,dirlst);
n:=0;
while rc=0 do begin
  if stoping then break;
  inc(n);
  Edit3.text:=currentzone+' '+inttostr(n)+' '+dirlst.name;
  Form1.update;
  convGSC(dirlst.name,zonein,zoneout);
  rc:=FindNext(dirlst);
end;
FindClose(dirlst);
edit3.text:=inttostr(n)+' End';
form1.refresh;
sleep(500);
end;
//
begin
running:=true;
stoping:=false;
try
dirin:=trim(Edit1.Text);
if copy(dirin,length(dirin),1)<>'\' then dirin:=dirin+'\';
dirout:=trim(Edit2.Text);
if copy(dirout,length(dirout),1)<>'\' then dirout:=dirout+'\';
case Radiogroup1.ItemIndex of
0 : begin
    currentzone:=uppercase(trim(edit4.text));
    zonein:=dirin+currentzone;
    zoneout:=dirout+currentzone;
    convertzone;
    end;
1 : for i:=0 to 11 do begin
    if stoping then break;
    currentzone:=nlst[i];
    zonein:=dirin+currentzone;
    zoneout:=dirout+currentzone;
    convertzone;
    end;
2 : for i:=0 to 11 do begin
    if stoping then break;
    currentzone:=slst[i];
    zonein:=dirin+currentzone;
    zoneout:=dirout+currentzone;
    convertzone;
    end;
end;
finally
running:=false;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
decimalseparator:='.';
edit3.text:=' ';
running:=false;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
if RadioGroup1.itemindex >0 then edit4.enabled:=false
                            else edit4.enabled:=true;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
canclose:=true;
if running then begin
  if mrOK<>MessageDlg('Cancel running conversion ?',mtConfirmation,mbOkCancel,0) then canclose:=false;
end;
if canclose then stoping:=true;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
BrowseDirectoryDlg1.selection:=edit1.text;
if BrowseDirectoryDlg1.Execute then edit1.text:=BrowseDirectoryDlg1.selection;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
BrowseDirectoryDlg1.selection:=edit2.text;
if BrowseDirectoryDlg1.Execute then edit2.text:=BrowseDirectoryDlg1.selection;
end;

end.
