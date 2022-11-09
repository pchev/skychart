program extractgaia;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  LazFileUtils,
  Classes, SysUtils, dynlibs;

var
  j,l,n,f: integer;
  mag: double;
  buf,bufo: string;
  filelst,row: TStringList;
  fs: TSearchRec;
  ft,fo12,fo15,fo18,fo21: Textfile;
  tmpfn: string;

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

const
    blank25='                         ';

function Slash(nom: string): string;
begin
  Result := trim(nom);
  if copy(Result, length(nom), 1) <> PathDelim then
    Result := Result + PathDelim;
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

  AssignFile(fo12,'catgen_input12.txt');
  Rewrite(fo12);
  AssignFile(fo15,'catgen_input15.txt');
  Rewrite(fo15);
  AssignFile(fo18,'catgen_input18.txt');
  Rewrite(fo18);
  AssignFile(fo21,'catgen_input21.txt');
  Rewrite(fo21);

  filelst:=TStringList.Create;
  f := findfirst(slash('csv') + 'GaiaSource_*.csv.gz', 0, fs);
  while f = 0 do
  begin
    filelst.Add(fs.Name);
    f := findnext(fs);
  end;
  FindClose(fs);
  filelst.Sorted:=true;

  row := TStringList.Create;
  n:=0;
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

     AssignFile(ft,tmpfn);
     Reset(ft);
     repeat
       ReadLn(ft,buf);   // skip header
     until copy(buf,1,1)<>'#';

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

       if mag<=12.0 then
          writeln(fo12,bufo)
       else if mag<=15.0 then
          writeln(fo15,bufo)
       else if mag<=18.0 then
          writeln(fo18,bufo)
       else
          writeln(fo21,bufo)

       except
         on E:Exception do begin
            WriteLn(stderr,filelst[j]+': '+e.Message+'  '+buf);
         end;
       end;
     end;

     CloseFile(ft);
     DeleteFile(tmpfn);
  end;
  CloseFile(fo12);
  CloseFile(fo15);
  CloseFile(fo18);
  CloseFile(fo21);
  row.Free;
  filelst.Free;
end.

