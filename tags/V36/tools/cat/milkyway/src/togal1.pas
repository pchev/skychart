unit togal1;

interface

uses  u_projection, u_constant, u_util,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.xfm}

procedure togal(fin,fon:string);
var fi,fo:textfile;
    buf,s:string;
    ra,dec,l,b :double;
    c:conf_skychart;
begin
assignfile(fi,fin);
reset(fi);
assignfile(fo,fon);
rewrite(fo);
c.JDChart:=jd2000;
repeat
  readln(fi,buf);
  ra:=strtofloat(copy(buf,2,2));
  ra:=ra+strtofloat(copy(buf,5,2))/60;
  ra:=ra+strtofloat(copy(buf,8,4))/3600;
  s:=copy(buf,14,1);
  dec:=strtofloat(copy(buf,15,2));
  dec:=dec+strtofloat(copy(buf,17,2))/60;
  dec:=dec+strtofloat(copy(buf,19,2))/3600;
  if s='-' then dec:=-dec;
  eq2gal(ra*15*deg2rad,dec*deg2rad,l,b,c);
  buf:=artostr(l*rad2deg)+' '+detostr3(b*rad2deg);
  writeln(fo,buf);
until eof(fi);
closefile(fi);
closefile(fo);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
togal('mra1.dat','mgal1.dat');
togal('mra2.dat','mgal2.dat');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
decimalseparator:='.';
end;

procedure reversefile(fn:string);
var fi,fo:textfile;
    buf:string;
    l:tstringlist;
    i:integer;
begin
l:=tstringlist.Create;
assignfile(fi,fn);
reset(fi);
repeat
  readln(fi,buf);
  l.Add(buf);
until eof(fi);
closefile(fi);
assignfile(fo,fn+'.rev');
rewrite(fo);
for i:=l.Count-1 downto 0 do begin
  writeln(fo,l[i]);
end;
closefile(fo);
l.Clear;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
reversefile('mgal1.dat');
reversefile('mgal2.dat');
end;

procedure split(fn:string);
var fi,fo:textfile;
    buf,ff,ff1:string;
    i,l,n,m,k:integer;
begin
assignfile(fi,fn+'.dat.rev');
reset(fi);
m:=-1;
assignfile(fo,'dummy');
rewrite(fo);
repeat
  readln(fi,buf);
  i:=pos('h',buf);
  l:=strtoint(trim(copy(buf,1,i-1)));
  n:=l div 5;
  if n<>m then begin
     writeln(fo,buf);
     closefile(fo);
     ff:='slice/'+fn+'.'+inttostr(n*5);
     k:=ord('a');
     ff1:=ff;
     while fileexists(ff) do begin
        ff:=ff1+chr(k);
        inc(k);
     end;
     assignfile(fo,ff);
     rewrite(fo);
     m:=n;
  end;
  writeln(fo,buf);
until eof(fi);
closefile(fo);
closefile(fi);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
split('mgal1');
split('mgal2');
end;


procedure TForm1.Button4Click(Sender: TObject);
var i : integer;
    f1,f2,rec1,buf:string;
    fi,fo:textfile;
begin
for i:=0 to 71 do begin
  f1:='slice/mgal1.'+inttostr(i*5);
  f2:='slice/mgal2.'+inttostr(i*5);
  reversefile(f2);
  f2:=f2+'.rev';
  assignfile(fi,f1);
  reset(fi);
  assignfile(fo,'slice/slgal.'+inttostr(i*5));
  rewrite(fo);
  readln(fi,rec1);
  writeln(fo,rec1);
  repeat
    readln(fi,buf);
    writeln(fo,buf);
  until eof(fi);
  closefile(fi);
  assignfile(fi,f2);
  reset(fi);
  repeat
    readln(fi,buf);
    writeln(fo,buf);
  until eof(fi);
  closefile(fi);
  writeln(fo,rec1);
  closefile(fo);
end;
end;

procedure getradec(var buf:string);
var l,b,ra,dec:double;
    s:string;
    c:conf_skychart;
begin
  c.JDChart:=jd2000;
  l:=strtofloat(copy(buf,1,3));
  l:=l+strtofloat(copy(buf,5,2))/60;
  l:=l+strtofloat(copy(buf,8,4))/3600;
  s:=copy(buf,14,1);
  b:=strtofloat(copy(buf,15,2));
  b:=b+strtofloat(copy(buf,18,2))/60;
  b:=b+strtofloat(copy(buf,21,2))/3600;
  if s='-' then b:=-b;
  gal2eq(l*deg2rad,b*deg2rad,ra,dec,c);
  buf:=artostr(ra*rad2deg/15)+' '+detostr3(dec*rad2deg);
end;

procedure TForm1.Button5Click(Sender: TObject);
var i : integer;
    f1,buf:string;
    fi,fo:textfile;
begin
assignfile(fo,'mwnew.dat');
rewrite(fo);
for i:=0 to 71 do begin
  f1:='slice/slgal.'+inttostr(i*5);
  assignfile(fi,f1);
  reset(fi);
  readln(fi,buf);
  getradec(buf);
  buf:=buf+'  start      '+inttostr(i*5);
  writeln(fo,buf);
  repeat
    readln(fi,buf);
    getradec(buf);
    if eof(fi) then buf:=buf+'  end'
               else buf:=buf+'  vertex';
    writeln(fo,buf);
  until eof(fi);
  closefile(fi);
end;
closefile(fo);
end;

procedure TForm1.Button6Click(Sender: TObject);
var i : integer;
    f1,buf:string;
    fi,fo:textfile;
begin
for i:=0 to 71 do begin
  f1:='slice/mgal1.'+inttostr(i*5)+'b';
  if not fileexists(f1) then continue;
  assignfile(fi,f1);
  reset(fi);
  assignfile(fo,'slice/sl1.'+inttostr(i*5)+'b');
  rewrite(fo);
  repeat
    readln(fi,buf);
    getradec(buf);
    buf:=buf+'  vertex';
    writeln(fo,buf);
  until eof(fi);
  closefile(fi);
  closefile(fo);
end;
end;

end.
