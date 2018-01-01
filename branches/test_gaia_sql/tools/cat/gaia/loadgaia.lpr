program loadgaia;

// level 10:  select ra,de from gaia where round((source_id / 549755813888)-0.5)=324067
//      ou :  select ra,de from gaia where (source_id / 549755813888)=324067
//
// pixarea:=4*pi/nside2npix(nside);
// pixwidth:=sqrt(pixarea);

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, math, dynlibs,
  libsql, passql, passqlite;

const
  ndb=7;
  magl: array[0..ndb-1] of integer =(8,14,16,17,18,19,99);
var
  db: array [0..ndb-1] of TSqlDB;
  i,j,l,n,f: integer;
  dbname,buf,sql: string;
  mag: integer;
  filelst,row: TStringList;
  fs: TSearchRec;
  ft: Textfile;
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

  for i:=0 to ndb-1 do begin
    db[i] := TLiteDB.Create(nil);
    dbname := 'gaiadr1_'+inttostr(i);
    DeleteFile(dbname);
    db[i].Use(dbname);
    sql:= 'CREATE TABLE ' +
          'gaia' +
          '('+
          'source_id INTEGER PRIMARY KEY ASC, '+
          'ra REAL NOT NULL, '+
          'de REAL NOT NULL, '+
          'parallax REAL, '+
          'pmra REAL, '+
          'pmdec REAL, '+
          'phot_g_mean_mag REAL '+
          ')';
    db[i].Query(sql);
    if db[i].LastError<>0 then
      WriteLn(stderr,db[i].ErrorMessage+'  '+sql);
    db[i].Commit;
  end;

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
     AssignFile(ft,tmpfn);
     Reset(ft);
     ReadLn(ft);
     for i:=0 to ndb-1 do db[i].StartTransaction;

     while not eof(ft) do begin
       ReadLn(ft,buf);
       try
       row.Clear;
       ExtractStrings([','], [], PChar(buf),row,true);
       mag:=floor(StrToFloat(row[51]));
       case mag of //  8,14,16,17,18,19,99
          -99..8 : i:=0;
           9..14 : i:=1;
          15..16 : i:=2;
              17 : i:=3;
              18 : i:=4;
              19 : i:=5;
           else    i:=6;
       end;
        sql:='INSERT INTO gaia '+
            '(source_id, ra, de, parallax, pmra, pmdec, phot_g_mean_mag) '+
            'values ('+
            '"'+row[1]+'",'+
            '"'+row[4]+'",'+
            '"'+row[6]+'",'+
            '"'+row[8]+'",'+
            '"'+row[10]+'",'+
            '"'+row[12]+'",'+
            '"'+row[51]+'")';
       db[i].Query(sql);
       if db[i].LastError<>0 then
         WriteLn(stderr,db[i].ErrorMessage+'  '+sql);
       except
         on E:Exception do begin
            WriteLn(stderr,filelst[j]+': '+e.Message+'  '+buf);
         end;
       end;
     end;

     CloseFile(ft);
     for i:=0 to ndb-1 do db[i].Commit;
     DeleteFile(tmpfn);
  end;
  row.Free;

  for i:=0 to ndb-1 do begin
    db[i].Commit;
    db[i].Free;
  end;
end.

