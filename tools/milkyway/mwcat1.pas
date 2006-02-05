unit mwcat1;

interface

uses u_util,u_projection,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.xfm}

Procedure MilkyWay(dir:string);
var fi,fo : textfile;
    buf : string;
    i,j,k,flag : integer;
    s,ar,de,arp,dep : double;
begin
for k:=0 to 1 do
for i:=1 to 5 do begin
case k of
0 : begin
    assignfile(fi,dir+'mw_ol'+inttostr(i)+'.dat');
    assignfile(fo,dir+'milkyway_line_'+inttostr(i)+'.dat');
    end;
1 : begin
    assignfile(fi,dir+'mw_sh'+inttostr(i)+'.dat');
    assignfile(fo,dir+'milkyway_shade_'+inttostr(i)+'.dat');
    end;
end;
reset(fi);
rewrite(fo);
j:=0;
flag:=2;
readln(fi,buf);
arp:=strtoint(copy(buf,1,2))+strtoint(copy(buf,3,2))/60+strtoint(copy(buf,5,2))/3600;
s:=strtoint(copy(buf,7,1)+'1');
dep:=s*(strtoint(copy(buf,8,2))+strtoint(copy(buf,10,2))/60+strtoint(copy(buf,12,2))/3600);
repeat
  readln(fi,buf);
  ar:=strtoint(copy(buf,1,2))+strtoint(copy(buf,3,2))/60+strtoint(copy(buf,5,2))/3600;
  s:=strtoint(copy(buf,7,1)+'1');
  de:=s*(strtoint(copy(buf,8,2))+strtoint(copy(buf,10,2))/60+strtoint(copy(buf,12,2))/3600);
  if flag=2 then flag:=0
     else if angulardistance(15*ar,de,15*arp,dep)>1 then flag:=2 else flag:=1;
  buf:=artostr(arp)+' '+detostr(dep)+' ';
  if flag=1 then writeln(fo,buf+'vertex')
  else if flag=0 then writeln(fo,buf+'start')
  else if flag=2 then writeln(fo,buf+'end');
  arp:=ar;
  dep:=de;
until eof(fi);
buf:=artostr(arp)+' '+detostr(dep)+' ';
writeln(fo,buf+'end');
closefile(fi);
closefile(fo);
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
milkyway(edit1.text);
end;

end.
