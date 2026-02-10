program filtervsx;
{
  This program filter the VSX data file available from CDS
  It produce one data file with all the stars flagged as variable,
  and a second file with only the bright visual variables.
}

uses sysutils;

var fi,fo1,fo2: textfile;
    row,buf,varflag,mflag: string;
    m1,m2: double;
    band1,band2: Char;

begin
  Assign(fi,'vsx.dat');
  Reset(fi);
  Assign(fo1,'vsxv.dat');  // all variables
  Rewrite(fo1);
  Assign(fo2,'vsxb.dat');  // bright variables
  Rewrite(fo2);

  repeat
    readln(fi,row);

    varflag:=copy(row,41,1);
    if varflag<>'0' then continue;  // not a variable

    writeln(fo1,row); // all variable

    buf:=trim(copy(row,106,10))+' ';
    band1:=buf[1];
    buf:=trim(copy(row,131,8))+' ';
    band2:=buf[1];
    if band1 in ['J','H','K','L','M'] then continue;  // IR var
    if band2 in ['J','H','K','L','M'] then continue;

    m1:=StrToFloatDef(trim(copy(row,96,7)),-9999);
    if m1>=13.0 then continue;  // too faint
    m2:=StrToFloatDef(trim(copy(row,121,7)),-9999);
    if (m1<-100)or(m2<-100) then continue; // missing magnitude

    mflag:=copy(row,117,1);
    if mflag='Y' then  // amplitude
      m2:=m1+m2;

    if m2-m1 < 0.5 then continue;  // small amplitude

    writeln(fo2,row); // bright visual variable

  until eof(fi);

  Close(fi);
  Close(fo1);
  Close(fo2);

end.

