program extractgaia;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  LazFileUtils,
  Classes, SysUtils, math, dynlibs;

var
  i,j,l,n,f,hipcount: integer;
  mag: double;
  buf,bufo: string;
  filelst,row: TStringList;
  fs: TSearchRec;
  ft,fo1,fo2,fo3,fhip: Textfile;
  tmpfn, hipnum: string;
  hiplist: array of array of QWord;

  //  zlib
  const
  {$ifdef linux}
    libz = 'libz.so.1';
  {$endif}
  {$ifdef freebsd}
    libz = 'libz.so.1';
  {$endif}
  {$ifdef darwin}
    libz = 'libz.dylib';
  {$endif}
  {$ifdef mswindows}
    libz = 'zlib1.dll';
  {$endif}

  type
    Tgzopen = function(path, mode: PChar): pointer; cdecl;
    Tgzread = function(gzFile: pointer; buf: pointer; len: cardinal): longint; cdecl;
    Tgzeof = function(gzFile: pointer): longbool; cdecl;
    Tgzclose = function(gzFile: pointer): longint; cdecl;

  var
    gzopen: Tgzopen;
    gzread: Tgzread;
    gzeof: Tgzeof;
    gzclose: Tgzclose;
    zlibok: boolean;
    zlib: TLibHandle;
    gzf: pointer;
    ffile: file;
    gzbuf: array[0..4095] of char;
    ok:boolean;

const
    blank25='                         ';

function Slash(nom: string): string;
begin
  Result := trim(nom);
  if copy(Result, length(nom), 1) <> PathDelim then
    Result := Result + PathDelim;
end;

procedure LoadHipparcosCross;
var i: integer;
   fcbuf: string;
   fcrow: TStringList;
   fc: textfile;
begin
  AssignFile(fc,'hipparcos_cross.csv');
  reset(fc);
  readln(fc); // remove header
  fcrow:=TStringList.Create;
  SetLength(hiplist,120000,2);
  i:=0;
  repeat
    ReadLn(fc,fcbuf);
    fcrow.Clear;
    ExtractStrings([','], [], PChar(fcbuf),fcrow,true);
    hiplist[i,0]:=StrToQWord(trim(fcrow[0]));  // source_id
    hiplist[i,1]:=StrToQWord(trim(fcrow[1]));  // hipparcos
    inc(i);
  until eof(fc);
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
   repeat
     i:=imin + ((imax-imin) div 2);
     if hiplist[i,0]>key
     then
        imax:=i
     else
        imin:=i;
     if hiplist[i,0]=key
     then begin
       result:=true;
       hn:=IntToStr(hiplist[i,1]);
     end;
   until result or (abs(imax-imin)<2);
end;

begin
  DefaultFormatSettings.DecimalSeparator:='.';
  zlibok:=false;
  zlib := LoadLibrary(libz);
   if zlib <> 0 then
   begin
     gzopen := Tgzopen(GetProcedureAddress(zlib, 'gzopen'));
     gzread := Tgzread(GetProcedureAddress(zlib, 'gzread'));
     gzclose := Tgzclose(GetProcedureAddress(zlib, 'gzclose'));
     gzeof := Tgzeof(GetProcedureAddress(zlib, 'gzeof'));
     zlibok := True;
   end
   else
     zlibok := False;
  if not zlibok then begin
    WriteLn(stderr,'Could not load '+libz);
    halt(1);
  end;
  tmpfn:='tmp.csv';

  LoadHipparcosCross;

  AssignFile(fo1,'catgen_input15.txt');
  Rewrite(fo1);
  AssignFile(fo2,'catgen_input18.txt');
  Rewrite(fo2);
  AssignFile(fo3,'catgen_input21.txt');
  Rewrite(fo3);
  AssignFile(fhip,'gaia_hipparcos.txt');
  Rewrite(fhip);

  filelst:=TStringList.Create;
  f := findfirst(slash('csv') + '*.csv.gz', 0, fs);
  while f = 0 do
  begin
    filelst.Add(fs.Name);
    f := findnext(fs);
  end;
  FindClose(fs);
  filelst.Sorted:=true;

  row := TStringList.Create;
  for j:=0 to filelst.Count-1 do
  begin
     WriteLn(IntToStr(j+1)+'/'+IntToStr(filelst.Count)+' '+filelst[j]);
     DeleteFile(tmpfn);
     gzf := gzopen(PChar(slash('csv') + filelst[j]), PChar('rb'));
     Filemode := 2;
     assignfile(ffile, tmpfn);
     rewrite(ffile, 1);
     repeat
        l := gzread(gzf, @gzbuf, length(gzbuf));
        blockwrite(ffile, gzbuf, l, n);
     until gzeof(gzf);
     gzclose(gzf);
     CloseFile(ffile);
     //DeleteFile(slash('csv') + filelst[j]);

     AssignFile(ft,tmpfn);
     Reset(ft);
     ReadLn(ft);

     while not eof(ft) do begin
       ReadLn(ft,buf);
       try

       row.Clear;
       ExtractStrings([','], [], PChar(buf),row,true);

       bufo:=copy(row[2]+blank25,1,21)+    // source_id
             copy(row[5]+blank25,1,23)+    // ra
             copy(row[7]+blank25,1,23)+    // dec
             copy(row[9]+blank25,1,23)+    // parallax
             copy(row[13]+blank25,1,23)+   // pmra
             copy(row[15]+blank25,1,23)+   // pmdec
             copy(row[69]+blank25,1,12)+   // phot_g_mean_mag
             copy(row[74]+blank25,1,12)+   // phot_bp_mean_mag
             copy(row[79]+blank25,1,12)+   // phot_rp_mean_mag
             copy(row[89]+blank25,1,20);   // radial_velocity

       mag:=StrToFloatDef(trim(row[69]),999);

       if mag<15 then begin
          if GetHipparcos(trim(row[2]),hipnum) then begin
            bufo:=bufo+hipnum;
            writeln(fhip,bufo)
          end
          else
             writeln(fo1,bufo)
       end
       else if mag<18 then
             writeln(fo2,bufo)
       else
             writeln(fo3,bufo)

       except
         on E:Exception do begin
            WriteLn(stderr,filelst[j]+': '+e.Message+'  '+buf);
         end;
       end;
     end;

     CloseFile(ft);
     DeleteFile(tmpfn);
  end;
  CloseFile(fhip);
  CloseFile(fo1);
  CloseFile(fo2);
  CloseFile(fo3);
  row.Free;
  filelst.Free;
  SetLength(hiplist,0,0);
end.

