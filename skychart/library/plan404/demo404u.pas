unit demo404u;
{
  Test program for libplan404

  The default jd date and the reference result are
  from the original Steve Moshier example.

  This program run only with the CLX, you can
  quickly copy it if you want to test with the VCL.

}

interface

uses Math,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Memo1: TMemo;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

type
TPlanetData = record
   JD : double;
   l : double ;
   b : double ;
   r : double ;
   x : double ;
   y : double ;
   z : double ;
   ipla : integer;
   end;
PPlanetData = ^TPlanetData;

const rad2deg = 180/pi;
      deg2rad = pi/180;
      jd2000  = 2451545.0;

{$ifdef linux}
Function Plan404( pla : PPlanetData):integer; cdecl; external 'libplan404.so';
{$endif}
{$ifdef mswindows}
Function Plan404( pla : PPlanetData):integer; cdecl; external 'libplan404.dll';
{$endif}

{$R *.xfm}

Function sgn(x:Double):Double ;
begin
if x<0 then
   sgn:= -1
else
   sgn:=  1 ;
end ;

Function DEToStr(de: Double) : string;
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
    if sec>=59.995 then begin
       min:=min+1;
       sec:=0.0;
    end;
    str(abs(dd):2:0,d);
    if abs(dd)<10 then d:='0'+trim(d);
    if de<0 then d:='-'+d else d:='+'+d;
    str(min:2:0,m);
    if abs(min)<10 then m:='0'+trim(m);
    str(sec:2:0,s);
    if abs(sec)<9.95 then s:='0'+trim(s);
    result := d+'d'+m+'m'+s+'s';
end;

function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

procedure PrecessionEcl(ti,tf : double; VAR l,b : double);  // l,b in radian !
var i1,i2,i3,i4,i5,i6,i7,i8 : double ;
begin
i1:=(ti-2451545.0)/36525 ;
i2:=(tf-ti)/36525;
i3:=deg2rad*(((47.0029-0.06603*i1+0.000598*i1*i1)*i2+(-0.03302+0.000598*i1)*i2*i2+0.000060*i2*i2*i2)/3600);
i4:=deg2rad*((174.876384*3600+3289.4789*i1+0.60622*i1*i1-(869.8089+0.50491*i1)*i2+0.03536*i2*i2)/3600);
i5:=deg2rad*(((5029.0966+2.22226*i1-0.000042*i1*i1)*i2+(1.11113-0.000042*i1)*i2*i2-0.000006*i2*i2*i2)/3600);
i6:=cos(i3)*cos(b)*sin(i4-l)-sin(i3)*sin(b);
i7:=cos(b)*cos(i4-l);
i8:=cos(i3)*sin(b)+sin(i3)*cos(b)*sin(i4-l);
l:=i5+i4-arctan2(i6,i7);
b:=arcsin(i8);
l:=rmod(l+2*pi,2*pi);
end;

procedure TForm1.Button1Click(Sender: TObject);
var pla : TPlanetData;
    jd : double;
    i:integer;
    txt:string;
begin
memo1.Clear;
jd:=strtofloat(edit1.Text);
//planet
for i:=1 to 9 do begin
 pla.ipla:=i;
 pla.JD:=jd;
 Plan404(addr(pla));
 // precess to equinox of date
 PrecessionEcl(jd2000,jd,pla.l,pla.b);
 txt:='  '+inttostr(pla.ipla)+':  ';
 txt:=txt+detostr(rad2deg*pla.l)+'  ';
 txt:=txt+detostr(rad2deg*pla.b)+'  ';
 txt:=txt+formatfloat('00.000000',pla.r);
 memo1.lines.add(txt);
end;
// moon
 pla.ipla:=11;
 pla.JD:=jd;
 Plan404(addr(pla));
 // already equinox of date !
 txt:=' '+inttostr(pla.ipla)+':  ';
 txt:=txt+detostr(rad2deg*pla.l)+'  ';
 txt:=txt+detostr(rad2deg*pla.b)+'  ';
 txt:=txt+formatfloat('00.000000',pla.r);
 memo1.lines.add(txt);
end;

begin
decimalseparator:='.';
end.
