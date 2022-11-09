program extractgaiahip;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  LazFileUtils,
  Classes, SysUtils, dynlibs;

var
  i,hipcount: integer;
  buf,sid: string;
  fi12,fi15,fo12,fo15,fohip: Textfile;
  hipnum: string;
  hiplist: array of array of QWord;

 const
    blank25='                         ';

procedure LoadHipparcosCross;
var i: integer;
   fcbuf: string;
   fcrow: TStringList;
   fc: textfile;
   const MaxQWord =qword($ffffffffffffffff);
begin
  // see 1-download.sh
  AssignFile(fc,'HipparcosByGaia');
  reset(fc);
  fcrow:=TStringList.Create;
  SetLength(hiplist,120000,2);
  i:=0;
  hiplist[i,0]:=0;
  hiplist[i,1]:=0;
  inc(i);
  repeat
    ReadLn(fc,fcbuf);
    fcrow.Clear;
    ExtractStrings([','], [], PChar(fcbuf),fcrow,true);

    if fcrow[1]='2' then
      fcbuf:='';

    hiplist[i,0]:=StrToQWord(trim(fcrow[0]));  // source_id
    hiplist[i,1]:=StrToQWord(trim(fcrow[1]));  // hipparcos
    inc(i);
  until eof(fc);
  hiplist[i,0]:=MaxQWord;
  hiplist[i,1]:=MaxQWord;
  inc(i);
  hipcount:=i;
  SetLength(hiplist,hipcount,2);
  fcrow.Free;
end;

function GetHipparcos(sourceid: string; var hn: string): boolean;
var imin,imax: integer;
    key: qword;
begin
   imin:=0;
   imax := hipcount;
   key:=StrToQWord(sourceid);
   result:=false;
   while ((imin<=imax) and (not result)) do begin
     i:=imin + ((imax-imin) div 2);
     if hiplist[i,0]=key
     then begin
       result:=true;
       hn:=IntToStr(hiplist[i,1]);
     end;
     if key>hiplist[i,0]
     then
        imin:=i+1
     else
        imax:=i-1;
   end;
end;

begin
  DefaultFormatSettings.DecimalSeparator:='.';

  LoadHipparcosCross;

  AssignFile(fi12,'catgen_input12.txt');
  Reset(fi12);
  AssignFile(fi15,'catgen_input15.txt');
  Reset(fi15);
  AssignFile(fo12,'catgen_input12_nohip.txt');
  Rewrite(fo12);
  AssignFile(fo15,'catgen_input15_nohip.txt');
  Rewrite(fo15);
  AssignFile(fohip,'cdc_gaia_hipparcos.txt');
  Rewrite(fohip);

  hipnum:='';
  while not eof(fi12) do begin
    ReadLn(fi12,buf);
    try
    sid:=trim(copy(buf,1,21));
    if GetHipparcos(sid,hipnum) then begin
      buf:=buf+copy(hipnum+blank25,1,10);
      writeln(fohip,buf);
    end
    else begin
      writeln(fo12,buf);
    end;
    except
     on E:Exception do begin
        WriteLn(stderr,e.Message+' '+buf);
     end;
    end;
  end;
  while not eof(fi15) do begin
    ReadLn(fi15,buf);
    try
    sid:=trim(copy(buf,1,21));
    if GetHipparcos(sid,hipnum) then begin
      buf:=buf+copy(hipnum+blank25,1,10);
      writeln(fohip,buf);
    end
    else begin
      writeln(fo15,buf);
    end;
    except
     on E:Exception do begin
        WriteLn(stderr,e.Message+' '+buf);
     end;
    end;
  end;
  CloseFile(fohip);
  CloseFile(fi12);
  CloseFile(fi15);
  SetLength(hiplist,0,0);
end.

