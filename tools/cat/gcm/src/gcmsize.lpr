program gcmsize;

uses math,sysutils;

var
  fin, fout: TextFile;
  buf,b200,strd,strmuv: string;
  c,rc,d,muv: double;
  i: integer;

begin
  b200:='';
  for i:=1 to 200 do b200:=b200+' ';
  AssignFile(fin,'mwgc.onerow');
  Reset(fin);
  AssignFile(fout,'catalog.txt');
  Rewrite(fout);
  // title line
  ReadLn(fin,buf);
  buf:=copy(buf+b200,1,264)+' '+'diam '+' '+'sbr  ';
  WriteLn(fout,buf);
  repeat
    ReadLn(fin,buf);
    buf:=copy(buf+b200,1,264);
    // externel diameter
    try
    c:=StrToFloat(copy(buf,215,4));
    rc:=StrToFloat(copy(buf,225,4));
    d:= rc * power(10, c);
    strd:=FormatFloat('00.00',d);
    except
      strd:='     ';
    end;
    // surface brightness  mag/arcmin
    try
    muv:=StrToFloat(copy(buf,238,5));
    muv:=muv - 8.89;
    strmuv:=FormatFloat('00.00',muv);
    except
      strmuv:='     ';
    end;
    // add to line
    buf:=buf+' '+strd+' '+strmuv;
    WriteLn(fout,buf);
  until eof(fin);
  CloseFile(fin);
  CloseFile(fout);

end.

