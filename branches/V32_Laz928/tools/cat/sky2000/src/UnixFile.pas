unit UnixFile;

interface

type UXfile = file;
Procedure OpenUX(var f : UXfile; name : string);
Procedure CloseUX(var f : UXfile);
Procedure ReadUX(var f :UXfile; var lin : string);
function EofUX(var f : UXfile) : boolean;

implementation

const cr=chr(10);

var buf : array[0..1024]of char;
    n,i : integer;

Procedure OpenUX(var f : UXfile; name : string);
begin
Filemode:=0;
Assignfile(f,name);
reset(f,1);
n:=0;
i:=0;
end;

Procedure CloseUX(var f : UXfile);
begin
closefile(f);
end;

Procedure ReadUX(var f :UXfile; var lin : string);
var j : integer;
    c : char;
begin
lin:='';
repeat
if i>=n then begin
   BlockRead(f,buf,1024,n);
   i:=0;
end;
for j:=i to n-1 do begin
  c:=buf[j];
  if c=cr then break
           else lin:=lin+c;
end;
i:=j+1;
until c=cr;
end;

function EofUX(var f : UXfile) : boolean;
begin
result:=eof(f) and (i>=n);
end;

end.
