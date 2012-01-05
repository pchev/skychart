unit demovcl1;
{  Demo to illustrate the use of the catalog library
   VCL Version.

   This demo use the Bright Stars Catalog that is include with the
   base version of Cartes du Ciel.
   The principle of use is the same for all the other catalogs.

   Look at catalogues.pas for a detailed description of the function.
   The comment in this file are in French maybe I will change that
   if I have enough time.

   To use this demo :

   -  Enter the full path for the BSC files
   -  Enter the decimal coordinates RA1 and DE1 of the lower rigth corner
   -  Enter the decimal coordinates RA2 and DE2 of the upper left corner
   -  Press the Search button to show all the stars between the two corner.
   -  Beware to not select a too large area, the number of stars can break
      the 64k limit of the memo component.

   Note :   
   This way to access the catalog do not provide facilities for a chart that
   cross the RA origin, you have to manage this by yourself.
   (i.e. for a chart from 23H to 1H you first get the stars from 23H to 24H
   then from 0H to 1H).
   Cartes du Ciel use the function InitCatWin() and OpenBSCwin() that manage
   this probleme but are heavier to use. Look at the source code if you want
   to use this function.
}

interface

uses catalogues,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Function sgn(x:Double):Double ;
// return the signe of a value
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

Function ARToStr(ar: Double) : string;
// function to convert decimal RA to a string
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(ar);
    min1:=abs(ar-dd)*60;
    if min1>=59.999 then begin
       dd:=dd+sgn(ar);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.95 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(dd:3:0,d);
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:4:1,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+'h'+m+'m'+s+'s';
end;

Function DEToStr(de: Double) : string;
// function to convert decimal DEC to a string
var dd,min1,min,sec: Double;
    d,m,s : string;
begin
    dd:=Int(de);
    min1:=abs(de-dd)*60;
    if min1>=59.99 then begin
       dd:=dd+sgn(de);
       min1:=0.0;
    end;
    min:=Int(min1);
    sec:=(min1-min)*60;
    if sec>=59.5 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.5 then s:='0'+trim(s);
    result := d+'°'+m+chr(39)+s+'"';
end;

procedure TForm1.Button1Click(Sender: TObject);
// main code here
var ar1,ar2,de1,de2,ar,de : double;
    ok : boolean;
    lin : BSCrec;
    buf,buf2 : string;
begin
// get the corner coordinates
ar1:=strtofloat(edit2.text);
ar2:=strtofloat(edit3.text);
de1:=strtofloat(edit4.text);
de2:=strtofloat(edit5.text);
memo1.clear;
// Initialize the path to the catalog files
SetBSCpath(edit1.text);
// Open the necessary files according to the corner coordinates
OpenBSC(ar1,ar2,de1,de2,ok);
if not ok then begin
   showmessage('Cannot find the catalog on '+edit1.text);
   exit;
end;
repeat
  // Read a line of data
  ReadBSC(lin,ok);
  ar:=lin.ar/100000/15;
  de:=lin.de/100000;
  // The following test is necessary as ReadBSC return all the stars
  // from all the files containing at least one star between the corner.
  // But all stars in this file are not necessarily between the corner.
  if (ar<ar1)or(ar>ar2)or(de<de1)or(de>de2) then continue;
  // formating the result for the list
  str(int(lin.flam):2:0,buf);
  buf :=lin.cons+' '+lin.bayer+' '+buf;
  str(lin.hd:6,buf2);
  buf:=buf+' '+buf2;
  buf := buf+' '+artostr(ar);
  buf:=buf+' '+detostr(de);
  str(lin.mv/100:5:2,buf2);
  buf:=buf+' '+buf2+' '+lin.sp;
  // add to the list
  memo1.Lines.Add(buf);
until not ok;
// Close the files
CloseBSC;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
// Initialize the library with the caching flag
InitCat(true);
end;

end.
