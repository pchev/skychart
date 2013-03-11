unit u_unzip;

{

  Unzip a file

  based on mini unzip paszlib demo  : fpc/packages/paszlib/examples/miniunz.pas

}

{$mode objfpc}{$H+}

//{$define zip_debug}

interface

uses unzip, ziputils, paszlib, ctypes,
  Classes, SysUtils;

function FileUnzip(fnzip, TempDir, fn: PChar):boolean;

const
  CASESENSITIVITY = 0;
  WRITEBUFFERSIZE = 8192;

implementation

  function mymkdir(dirname: PChar): boolean;
  var
    S: string;
  begin
    S := StrPas(dirname);
  {$I-}
    mkdir(S);
    mymkdir := IOresult = 0;
  end;

  function makedir(newdir: PChar): boolean;
  var
    buffer: PChar;
    p:      PChar;
    len:    cint;
  var
    hold:   char;
  begin
    makedir := False;
    len     := strlen(newdir);

    if (len <= 0) then
      exit;

    buffer := PChar(allocmem( len + 1));

    strcopy(buffer, newdir);

    if (buffer[len - 1] = '/') then
      buffer[len - 1] := #0;

    if mymkdir(buffer) then
    begin
      if Assigned(buffer) then
        freemem( buffer);
      makedir := True;
      exit;
    end;

    p := buffer + 1;
    while True do
    begin
      while ((p^ <> #0) and (p^ <> '\') and (p^ <> '/')) do
        Inc(p);
      hold := p^;
      p^   := #0;
      if (not mymkdir(buffer)) {and (errno = ENOENT)} then
      begin
      {$ifdef zip_debug}
        WriteLn('couldn''t create directory ', buffer);
      {$endif}
        if Assigned(buffer) then
          freemem( buffer);
        exit;
      end;
      if (hold = #0) then
        break;
      p^ := hold;
      Inc(p);
    end;
    if Assigned(buffer) then
      freemem( buffer);
    makedir := True;
  end;

procedure change_file_date(const filename: PChar; dosdate: longword; tmu_date: tm_unz);
begin
  FileSetDate(filename,dosdate);
end;


  function do_extract_currentfile(uf: unzFile; const popt_extract_without_path: cint; var popt_overwrite: cint): cint;
  var
    filename_inzip: packed array[0..255] of char;
    filename_withoutpath: PChar;
    p:      PChar;
    err:    cint;
    fout:   FILEptr;
    buf:    pointer;
    size_buf: cuInt;
    file_info: unz_file_info;
  var
    write_filename: PChar;
    skip:   cint;
{  var
    rep:    char;
    ftestexist: FILEptr;
  var
    answer: string[127]; }
  var
    c:      char;
  begin
    fout := nil;

    err := unzGetCurrentFileInfo(uf, @file_info, filename_inzip,
      sizeof(filename_inzip), nil, 0, nil, 0);

    if (err <> UNZ_OK) then
    begin
      {$ifdef zip_debug}
      WriteLn('error ', err, ' with zipfile in unzGetCurrentFileInfo');
      {$endif}
      do_extract_currentfile := err;
      exit;
    end;

    size_buf := WRITEBUFFERSIZE;
    buf      := allocmem(size_buf);
    if (buf = nil) then
    begin
      {$ifdef zip_debug}
      WriteLn('Error allocating memory');
      {$endif}
      do_extract_currentfile := UNZ_INTERNALERROR;
      exit;
    end;

    filename_withoutpath := filename_inzip;
    p := filename_withoutpath;
    while (p^ <> #0) do
    begin
      if (p^ = '/') or (p^ = '\') then
        filename_withoutpath := p + 1;
      Inc(p);
    end;

    if (filename_withoutpath^ = #0) then
    begin
      if (popt_extract_without_path = 0) then
      begin
        {$ifdef zip_debug}
        WriteLn('creating directory: ', filename_inzip);
        {$endif}
        mymkdir(filename_inzip);
      end;
    end
    else
    begin

      skip := 0;
      if (popt_extract_without_path = 0) then
        write_filename := filename_inzip
      else
        write_filename := filename_withoutpath;

      err := unzOpenCurrentFile(uf);
      if (err <> UNZ_OK) then begin
      {$ifdef zip_debug}
        WriteLn('error ', err, ' with zipfile in unzOpenCurrentFile');
      {$endif}
      end;

 (*     if ((popt_overwrite = 0) and (err = UNZ_OK)) then
      begin
        rep := #0;

        ftestexist := fopen(write_filename, fopenread);
        if (ftestexist <> nil) then
        begin
          fclose(ftestexist);
          repeat
            Write('The file ', write_filename,
              ' exist. Overwrite ? [y]es, [n]o, [A]ll: ');
            ReadLn(answer);

            rep := answer[1];
            if ((rep >= 'a') and (rep <= 'z')) then
              Dec(rep, $20);
          until (rep = 'Y') or (rep = 'N') or (rep = 'A');
        end;

        if (rep = 'N') then
          skip := 1;

        if (rep = 'A') then
          popt_overwrite := 1;
      end; *)

      if (skip = 0) and (err = UNZ_OK) then
      begin
        fout := fopen(write_filename, fopenwrite);

        { some zipfile don't contain directory alone before file }
        if (fout = nil) and (popt_extract_without_path = 0) and
          (filename_withoutpath <> PChar(@filename_inzip)) then
        begin
          c := (filename_withoutpath - 1)^;
          (filename_withoutpath -1)^ := #0;
          makedir(write_filename);
          (filename_withoutpath -1)^ := c;
          fout := fopen(write_filename, fopenwrite);
        end;

        if (fout = nil) then  begin
          {$ifdef zip_debug}
          WriteLn('error opening ', write_filename);
          {$endif}
        end;
      end;

      if (fout <> nil) then
      begin
        {$ifdef zip_debug}
        WriteLn(' extracting: ', write_filename);
        {$endif}
        repeat
          err := unzReadCurrentFile(uf, buf, size_buf);
          if (err < 0) then
          begin
            {$ifdef zip_debug}
            WriteLn('error ', err, ' with zipfile in unzReadCurrentFile');
            {$endif}
            break;
          end;
          if (err > 0) then
            if (fwrite(buf, err, 1, fout) <> 1) then
            begin
              {$ifdef zip_debug}
              WriteLn('error in writing extracted file');
              {$endif}
              err := UNZ_ERRNO;
              break;
            end;
        until (err = 0);
        fclose(fout);
        if (err = 0) then
          change_file_date(write_filename, file_info.dosDate,
            file_info.tmu_date);
      end;

      if (err = UNZ_OK) then
      begin
        err := unzCloseCurrentFile(uf);
        if (err <> UNZ_OK) then  begin
          {$ifdef zip_debug}
          WriteLn('error ', err, ' with zipfile in unzCloseCurrentFile')
          {$endif}
        end
        else
          unzCloseCurrentFile(uf); { don't lose the error }
      end;
    end;

    if buf <> nil then
      freemem( buf);
    do_extract_currentfile := err;
  end;


  function do_extract_onefile(uf: unzFile; const filename: PChar; opt_extract_without_path: cint; opt_overwrite: cint): cint;
  begin
    if (unzLocateFile(uf, filename, CASESENSITIVITY) <> UNZ_OK) then
    begin
      {$ifdef zip_debug}
      WriteLn('file ', filename, ' not found in the zipfile');
      {$endif}
      do_extract_onefile := 2;
      exit;
    end;

    if (do_extract_currentfile(uf, opt_extract_without_path,
      opt_overwrite) = UNZ_OK) then
      do_extract_onefile := 0
    else
      do_extract_onefile := 1;
  end;

  function FileUnzip(fnzip, TempDir, fn: PChar):boolean;
  var uf: unzFile;
      olddir: string;
  begin
    result:=false;
    uf := unzOpen(fnzip);
    if uf=nil then exit;
    olddir:=GetCurrentDir;
    chdir(TempDir);
    result:=do_extract_onefile(uf,fn,1,1)=UNZ_OK;
    chdir(olddir);
    unzCloseCurrentFile(uf);
  end;

end.

