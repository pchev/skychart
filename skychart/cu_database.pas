unit cu_database;

{
Copyright (C) 2005 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 General database function.
}
{$mode objfpc}{$H+}
interface

uses
  passql, passqlite, u_constant, u_util, u_projection, cu_fits, FileUtil,
  Forms, StdCtrls, ComCtrls, Classes, Dialogs, SysUtils, StrUtils, u_translation;

type
  TCDCdb = class(TComponent)
  private
    { Private declarations }
    db: TSqlDB;
    FFits: TFits;
    FInitializeDB: TNotifyEvent;
    FAstmsg: string;
    FComMindt: integer;
    tstval: double;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function createDB(cmain: Tconf_main; var ok: boolean): string;
    function dropDB(cmain: Tconf_main): string;
    function checkDBConfig(cmain: Tconf_main): string;
    function ConnectDB(dbn:string): boolean;
    function CheckForUpgrade(memo: Tmemo; updversion: string): boolean;
    function CheckDB: boolean;
    function LoadCountryList(locfile: string; memo: Tmemo): boolean;
    function LoadWorldLocation(locfile, country: string; city_only: boolean;
      memo: Tmemo): boolean;
    function LoadUSLocation(locfile: string; city_only: boolean; memo: Tmemo;
      state: string = ''): boolean;
    procedure GetCountryList(codelist, countrylist: TStrings);
    procedure GetCountryISOCode(countrycode: string; var isocode: string);
    procedure GetCountryFromISO(isocode: string; var cname: string);
    procedure GetCityList(countrycode, filter: string; codelist, citylist: TStrings;
      startr, limit: integer);
    procedure GetCityRange(country: string; lat1, lat2, lon1, lon2: double;
      codelist, citylist: TStrings; limit: integer);
    function GetCityLoc(locid: string;
      var loctype, latitude, longitude, elevation, timezone: string): boolean;
    function UpdateCity(locid: integer;
      country, location, loctype, lat, lon, elev, tz: string): string;
    function DeleteCity(locid: integer): string;
    function DeleteCountry(country: string; deleteall: boolean): string;
    procedure GetCometFileList(cmain: Tconf_main; list: TStrings);
    procedure GetAsteroidFileList(cmain: Tconf_main; list: TStrings);
    function LoadCometFile(comfile: string; memocom: Tmemo): boolean;
    procedure DelComet(comelemlist: string; memocom: Tmemo);
    procedure DelCometAll(memocom: Tmemo);
    function AddCom(comid, comt, comep, comq, comec, comperi, comnode, comi,
      comh, comg, comnam, comeq: string): string;
    function LoadAsteroidFile(astfile: string; astnumbered, stoperr, limit: boolean;
      astlimit: integer; memoast: Tmemo): boolean;
    procedure DelAsteroid(astelemlist: string; memoast: Tmemo);
    procedure DelAstDate(astdeldate: string; memoast: Tmemo);
    procedure DelAstAll(memoast: Tmemo);
    function AddAsteroid(astid, asth, astg, astep, astma, astperi, astnode,
      asti, astec, astax, astref, astnam, asteq: string): string;
    procedure TruncateDailyComet;
    procedure TruncateDailyAsteroid;
    procedure GetCometList(filter: string; maxnumber: integer;
      list: TStringList; var cometid: array of string);
    procedure GetAsteroidList(filter: string; maxnumber: integer;
      var list: TStringList; var astid: array of string);
    function GetCometEpoch(id: string; now_jd: double): double;
    function GetAsteroidEpoch(id: string; now_jd: double): double;
    function GetAstElem(id: string; epoch: double; var h, g, ma, ap, an, ic, ec, sa, eq: double;
      var ref, nam, elem_id: string): boolean;
  published
    function GetAstElemEpoch(id: string; jd: double;
      var epoch, h, g, ma, ap, an, ic, ec, sa, eq: double; var ref, nam, elem_id: string): boolean;
    function GetComElem(id: string; epoch: double; var tp, q, ec, ap, an, ic, h, g, eq: double;
      var nam, elem_id: string): boolean;
    function GetComElemEpoch(id: string; jd: double;
      var epoch, tp, q, ec, ap, an, ic, h, g, eq: double; var nam, elem_id: string): boolean;
    procedure LoadSampleData(memo: Tmemo; cmain: Tconf_main);
    function CountImages(catname: string): integer;
    procedure ScanImagesDirectory(ImagePath: string; ProgressCat: Tlabel;
      ProgressBar: TProgressBar);
    procedure ScanArchiveDirectory(ArchivePath: string; var Count: integer);
    function AddFitsArchiveFile(ArchivePath, fn: string): boolean;
    property onInitializeDB: TNotifyEvent read FInitializeDB write FInitializeDB;
    property AstMsg: string read FAstmsg write FAstmsg;
    property ComMinDT: integer read FComMinDT write FComMinDT;
  end;

implementation

constructor TCDCdb.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFits := TFits.Create(self);
  db := TLiteDB.Create(self);
end;

destructor TCDCdb.Destroy;
begin
  try
    DB.Free;
    FFits.Free;
    inherited Destroy;
  except
    writetrace('error destroy ' + Name);
  end;
end;

function TCDCdb.ConnectDB(dbn:string): boolean;
begin
  try
    dbn := UTF8Encode(dbn);
    if DB.database <> dbn then
      DB.Use(dbn);
    Result := DB.Active;
  except
    Result := False;
  end;
end;

function TCDCdb.Checkdb: boolean;
var
  i, j, k: integer;
  ok, creatednow: boolean;
  indexlist: TStringList;
  emsg: string;
begin
  creatednow := False;
  if DB.Active then
  begin
    indexlist := TStringList.Create;
    Result := True;
    for i := 1 to numsqltable do
    begin
      ok := (sqltable[i, 1] = DB.QueryOne(showtable + ' "' +
        sqltable[i, 1] + '"'));
      if not ok then
      begin  // try to create the missing table
        DB.Query('CREATE TABLE ' + sqltable[i, 1] + sqltable[i, 2]);
        emsg := DB.ErrorMessage;
        if sqltable[i, 3] > '' then
        begin   // create the index
          SplitRec(sqltable[i, 3], ',', indexlist);
          for j := 0 to indexlist.Count - 1 do
          begin
            k := StrToInt(indexlist[j]);
            DB.Query('CREATE INDEX ' + sqlindex[k, 1] + ' on ' + sqlindex[k, 2]);
          end;
        end;
        ok := (sqltable[i, 1] = DB.QueryOne(showtable + ' "' +
          sqltable[i, 1] + '"'));
        if ok then
        begin
          writetrace('Create table ' + sqltable[i, 1] + ' ... Ok');
          creatednow := True;
        end
        else
          writetrace('Create table ' + sqltable[i, 1] + ' ... Failed: ' + emsg);
      end;
      Result := Result and ok;
    end;
    indexlist.Free;
  end
  else
    Result := False;
  if creatednow and (Assigned(FInitializeDB)) then
    FInitializeDB(self);
end;

function TCDCdb.CheckForUpgrade(memo: Tmemo; updversion: string): boolean;
var
  updcountry: boolean;
  i, k: integer;
  buf: string;
  bb: TStringList;
begin
  Result := False;
  updcountry := False;
  if DB.Active then
  begin
    // add isocode column to country table
    if ((not DB.Query('select isocode from cdc_country where country="AF"')) or
      (DB.RowCount < 1)) then
      updcountry := True;
    // Correct Japan code
    if ((DB.Query('select isocode from cdc_country where isocode="JA"')) and
      (DB.RowCount >= 1)) then
      updcountry := True;
    // Correct Australia code
    i := strtointdef(DB.QueryOne('select count(*) from cdc_country where isocode="AU"'), 0);
    if (i > 1) then
      updcountry := True;
    if (updcountry) then
    begin
      if VerboseMsg then
        WriteTrace('Upgrade DB for country change ');

      DB.Query('drop table cdc_country');
      writetrace('Drop table cdc_country ... ' + DB.ErrorMessage);
      DB.Commit;
      DB.Query('CREATE TABLE ' + sqltable[9, 1] + sqltable[9, 2]);
      writetrace('Create table ' + sqltable[9, 1] + ' ...  ' + DB.ErrorMessage);
      LoadCountryList(slash(sampledir) + 'country.dat', memo);
      Result := True;
    end;
    // Correct Fits index
    buf := DB.QueryOne('select sql from sqlite_master where name="cdc_fits_objname"');
    if (pos('objectname', buf) > 0) and (pos('catalogname', buf) = 0) then
    begin
      if VerboseMsg then
        WriteTrace('Upgrade DB for new Fits indexes');
      DB.Query('drop table cdc_fits');
      writetrace('Drop table cdc_fits ... ' + DB.ErrorMessage);
      DB.Commit;
      DB.Query('CREATE TABLE ' + sqltable[8, 1] + sqltable[8, 2]);
      writetrace('Create table ' + sqltable[8, 1] + ' ...  ' + DB.ErrorMessage);
      k := 2;
      DB.Query('CREATE INDEX ' + sqlindex[k, 1] + ' on ' + sqlindex[k, 2]);
    end;
    // change ast_day_pos primary index , drop the table to rebuild in cu_planet
    if (updversion < cdcver) and (updversion < '3.11w') then
    begin
      bb := TStringList.Create;
      try
        DB.Query('select name from sqlite_master where type="table" and name like "cdc_ast_day_%"');
        for i := 0 to DB.RowCount - 1 do
        begin
          bb.add(DB.Results[i][0]);
        end;
        for i := 0 to bb.Count - 1 do
        begin
          buf := bb[i];
          DB.Query('drop table ' + buf);
        end;
      finally
        bb.Free;
      end;
    end;

  end;
end;

function TCDCdb.checkDBConfig(cmain: Tconf_main): string;
var
  msg, dbn: string;
  i: integer;
label
  dmsg;
begin
  try
    dbn := UTF8Encode(cmain.db);
    if ((DB.database = dbn) or DB.use(dbn)) then
      msg := Format(rsDatabaseOpen, [msg, cmain.db, crlf])
    else
    begin
      msg := Format(rsCannotOpenDa, [msg, cmain.db, trim(DB.ErrorMessage) + crlf]);
      goto dmsg;
    end;
    for i := 1 to numsqltable do
    begin
      if sqltable[i, 1] = DB.QueryOne(showtable + ' "' +
        sqltable[i, 1] + '"') then
        msg := Format(rsTableExist, [msg, sqltable[i, 1] + crlf])
      else
      begin
        msg := Format(rsTableDoNotEx, [msg, sqltable[i, 1], crlf]);
        goto dmsg;
      end;
    end;
    msg := Format(rsAllTablesStr, [msg]);
    dmsg:
      Result := msg;
  except
    Result := rsSQLDatabaseS;
  end;
end;

function TCDCdb.createDB(cmain: Tconf_main; var ok: boolean): string;
var
  msg, dbn: string;
  i, j, k: integer;
  indexlist: TStringList;
begin
  ok := False;
  Result := '';
  try
    dbn := UTF8Encode(cmain.db);
    if DB.database <> dbn then
      DB.Use(dbn);
    if DB.database = dbn then
    begin
      indexlist := TStringList.Create;
      ok := True;
      for i := 1 to numsqltable do
      begin
        DB.Query('CREATE TABLE ' + sqltable[i, 1] + sqltable[i, 2]);
        msg := trim(DB.ErrorMessage);
        if sqltable[i, 3] > '' then
        begin   // create the index
          SplitRec(sqltable[i, 3], ',', indexlist);
          for j := 0 to indexlist.Count - 1 do
          begin
            k := StrToInt(indexlist[j]);
            DB.Query('CREATE INDEX ' + sqlindex[k, 1] + ' on ' + sqlindex[k, 2]);
          end;
        end;
        if sqltable[i, 1] <> DB.QueryOne(showtable + ' "' +
          sqltable[i, 1] + '"') then
        begin
          ok := False;
          Result := Format(rsErrorCreatin, [Result + crlf, sqltable[i, 1] +
            blank + msg]);
          break;
        end;
      end;
      indexlist.Free;
    end
    else
    begin
      ok := False;
      Result := Result + crlf + trim(DB.ErrorMessage);
    end;
    DB.flush('tables');
  except
  end;
end;

function TCDCdb.dropDB(cmain: Tconf_main): string;
var
  msg: string;
begin
  Result := '';
  DB.Close;
  DeleteFile(cmain.db);
end;

procedure TCDCdb.GetCometFileList(cmain: Tconf_main; list: TStrings);
var
  i: integer;
begin
  list.Clear;
  try
    if DB.Active then
    begin
      DB.Query('Select elem_id,filedesc from cdc_com_elem_list order by elem_id');
      i := 0;
      while i < DB.Rowcount do
      begin
        list.add(DB.Results[i][0] + '; ' + DB.Results[i][1]);
        Inc(i);
      end;
    end;
  except
  end;
end;

procedure TCDCdb.GetAsteroidFileList(cmain: Tconf_main; list: TStrings);
var
  i: integer;
begin
  list.Clear;
  try
    if DB.Active then
    begin
      DB.Query('Select elem_id,filedesc from cdc_ast_elem_list order by elem_id');
      i := 0;
      while i < DB.Rowcount do
      begin
        list.add(DB.Results[i][0] + '; ' + DB.Results[i][1]);
        Inc(i);
      end;
    end;
  except
  end;
end;

function TCDCdb.LoadCometFile(comfile: string; memocom: Tmemo): boolean;
var
  buf, cmd, filedesc, filenum: string;
  t, ep, id, nam, ec, q, i, node, peri, eq, h, g: string;
  y, m, d, nl: integer;
  hh: double;
  f: textfile;
begin
  Result := False;
  if not fileexists(comfile) then
  begin
    MemoCom.Lines.add(rsFileNotFound);
    exit;
  end;
  try
    if DB.Active then
    begin
      filedesc := extractfilename(comfile) + blank + FormatDateTime(
        'yyyy-mm-dd hh:nn', FileDateToDateTime(FileAge(comfile)));
      Filemode := 0;
      assignfile(f, comfile);
      reset(f);
      DB.starttransaction;
      DB.LockTables('cdc_com_elem WRITE, cdc_ast_com_list WRITE, cdc_com_name WRITE');
      nl := 0;
      repeat
        readln(f, buf);
        Inc(nl);
        if trim(buf) = '' then
          continue;
        if (nl mod 10000) = 0 then
        begin
          MemoCom.Lines.add(Format(rsProcessingLi, [IntToStr(nl)]));
          application.ProcessMessages;
        end;
        id := trim(copy(buf, 1, 12));
        y := StrToInt(trim(copy(buf, 15, 4)));
        m := StrToInt(trim(copy(buf, 20, 2)));
        d := StrToInt(trim(copy(buf, 23, 2)));
        hh := 24 * strtofloat('0' + trim(copy(buf, 25, 5)));
        t := formatfloat(f6, jd(y, m, d, hh));
        ep := trim(copy(buf, 82, 8));
        if ep <> '' then
        begin
          y := StrToInt(trim(copy(ep, 1, 4)));
          m := StrToInt(trim(copy(ep, 5, 2)));
          d := StrToInt(trim(copy(ep, 7, 2)));
          hh := 0;
        end;
        ep := formatfloat(f1, jd(y, m, d, hh));
        q := trim(copy(buf, 31, 9));
        ec := trim(copy(buf, 41, 9));
        peri := trim(copy(buf, 51, 9));
        node := trim(copy(buf, 61, 9));
        i := trim(copy(buf, 71, 9));
        h := trim(copy(buf, 92, 4));
        if trim(h) = '' then
          h := '15';
        g := trim(copy(buf, 97, 4));
        if trim(g) = '' then
          g := '4.0';
        nam := stringreplace(trim(copy(buf, 103, 27)), '"', '\"', [rfreplaceall]);
        eq := '2000';
        if nl = 1 then
        begin
          filedesc := filedesc + ', epoch=' + ep;
          buf := DB.QueryOne('Select max(elem_id) from cdc_com_elem_list');
          if buf <> '' then
            filenum := IntToStr(StrToInt(buf) + 1)
          else
            filenum := '1';
          if not DB.Query('Insert into cdc_com_elem_list (elem_id, filedesc) Values("' +
            filenum + '","' + filedesc + '")') then
            MemoCom.Lines.add(trim(DB.ErrorMessage));
        end;
        cmd := 'REPLACE INTO cdc_com_elem (id,peri_epoch,peri_dist,eccentricity,arg_perihelion,asc_node,inclination,epoch,h,g,name,equinox,elem_id) VALUES (' + '"' + id + '"' + ',"' + t + '"' + ',"' + q + '"' + ',"' + ec + '"' + ',"' + peri + '"' + ',"' + node + '"' + ',"' + i + '"' + ',"' + ep + '"' + ',"' + h + '"' + ',"' + g + '"' + ',"' + nam + '"' + ',"' + eq + '"' + ',"' + filenum + '"' + ')';
        if (not DB.query(cmd)) and (DB.LastError <> 19) then
        begin
          MemoCom.Lines.add(Format(rsInsertFailed, [IntToStr(nl), trim(
            DB.ErrorMessage)]));
        end
        else
          Result := True; // at least one insert
        cmd := 'REPLACE INTO cdc_com_name (name, id) VALUES (' + '"' +
          nam + '"' + ',"' + id + '"' + ')';
        DB.query(cmd);
      until EOF(f);
      closefile(f);
      MemoCom.Lines.add(Format(rsProcessingEn, [IntToStr(nl)]));
    end
    else
    begin
      buf := trim(DB.ErrorMessage);
      if buf <> '0' then
        MemoCom.Lines.add(buf);
    end;
    DB.UnLockTables;
    DB.commit;
    DB.flush('tables');
    memocom.Lines.SaveToFile(slash(DBDir) + 'LoadCometFile.log');
  except
  end;
end;

procedure TCDCdb.DelComet(comelemlist: string; memocom: Tmemo);
var
  i: integer;
  elem_id: string;
begin
  memocom.Clear;
  i := pos(';', comelemlist);
  elem_id := copy(comelemlist, 1, i - 1);
  if trim(elem_id) = '' then
    exit;
  try
    if DB.Active then
    begin
      DB.starttransaction;
      DB.LockTables('cdc_com_elem WRITE, cdc_com_elem_list WRITE');
      memocom.Lines.add(rsDeleteFromEl);
      application.ProcessMessages;
      if not DB.Query('Delete from cdc_com_elem where elem_id=' + elem_id) then
        memocom.Lines.add(Format(rsFailed, [trim(DB.ErrorMessage)]));
      memocom.Lines.add('Delete from element list...');
      application.ProcessMessages;
      if not DB.Query('Delete from cdc_com_elem_list where elem_id=' + elem_id) then
        memocom.Lines.add(Format(rsFailed, [trim(DB.ErrorMessage)]));
      DB.UnLockTables;
      DB.commit;
      DB.flush('tables');
      memocom.Lines.add(rsDeleteDailyD);
      TruncateDailyComet;
      DB.Vacuum;
      memocom.Lines.add(rsDeleteComple);
    end;
  except
  end;
end;

procedure TCDCdb.DelCometAll(memocom: Tmemo);
begin
  memocom.Clear;
  try
    if DB.Active then
    begin
      DB.UnLockTables;
      DB.starttransaction;
      memocom.Lines.add(rsDeleteFromEl);
      application.ProcessMessages;
      DB.TruncateTable('cdc_com_elem');
      memocom.Lines.add(rsDeleteFromEl2);
      application.ProcessMessages;
      DB.TruncateTable('cdc_com_elem_list');
      memocom.Lines.add(rsDeleteFromNa);
      application.ProcessMessages;
      DB.TruncateTable('cdc_com_name');
      DB.commit;

      memocom.Lines.add(rsDeleteDailyD);
      application.ProcessMessages;
      TruncateDailyComet;
      memocom.Lines.add(rsPleaseWait);
      application.ProcessMessages;
      DB.Vacuum;
      memocom.Lines.add(rsDeleteComple);
    end;
  except
  end;
end;

function TCDCdb.AddCom(comid, comt, comep, comq, comec, comperi, comnode,
  comi, comh, comg, comnam, comeq: string): string;
var
  buf, cmd, filedesc, filenum: string;
  t, q, ep, id, nam, ec, i, node, peri, eq, h, g: string;
  y, m, d, p: integer;
  hh,x: double;
begin
  try
    if DB.Active then
    begin
      Result:='Wrong data!';
      id := trim(copy(comid, 1, 7));
      buf := comt;
      p := pos('.', buf);
      y := StrToInt(trim(copy(buf, 1, p - 1)));
      Delete(buf, 1, p);
      p := pos('.', buf);
      m := StrToInt(trim(copy(buf, 1, p - 1)));
      Delete(buf, 1, p);
      p := pos('.', buf);
      if p>0 then begin
        d := StrToInt(trim(copy(buf, 1, p - 1)));
        Delete(buf, 1, p);
        hh := strtofloat(trim('0.' + trim(buf))) * 24;
      end
      else begin
        d := StrToInt(trim(buf));
        hh:=0;
      end;
      t := formatfloat(f6, jd(y, m, d, hh));
      x:=StrToFloatDef(trim(comep),0);
      if x>0 then
        ep:=formatfloat(f1, x)
      else
        ep := formatfloat(f1, jd(y, m, d, hh));
      q := trim(comq);
      ec := trim(comec);
      peri := trim(comperi);
      node := trim(comnode);
      i := trim(comi);
      h := trim(comh);
      g := trim(comg);
      nam := stringreplace(trim(comnam), '"', '\"', [rfreplaceall]);
      eq := trim(comeq);
      buf := DB.QueryOne('Select max(elem_id) from cdc_com_elem_list');
      if buf <> '' then
        filenum := IntToStr(StrToInt(buf) + 1)
      else
        filenum := '1';
      filedesc := 'Add ' + id + ', ' + nam + ', ' + ep;
      DB.Query('Insert into cdc_com_elem_list (elem_id, filedesc) Values("' +
        filenum + '","' + filedesc + '")');
      cmd := 'INSERT INTO cdc_com_elem (id,peri_epoch,peri_dist,eccentricity,arg_perihelion,asc_node,inclination,epoch,h,g,name,equinox,elem_id) VALUES (' + '"' + id + '"' + ',"' + t + '"' + ',"' + q + '"' + ',"' + ec + '"' + ',"' + peri + '"' + ',"' + node + '"' + ',"' + i + '"' + ',"' + ep + '"' + ',"' + h + '"' + ',"' + g + '"' + ',"' + nam + '"' + ',"' + eq + '"' + ',"' + filenum + '"' + ')';
      if DB.query(cmd) then
      begin
        cmd := 'INSERT INTO cdc_com_name (name, id) VALUES (' +
          '"' + nam + '"' + ',"' + id + '"' + ')';
        DB.query(cmd);
        Result := 'OK!';
      end
      else
        Result := Format(rsInsertFailed2, [trim(DB.ErrorMessage)]);
    end
    else
    begin
      buf := trim(DB.ErrorMessage);
      if buf <> '0' then
        Result := buf;
    end;
    DB.flush('tables');
  except
  end;
end;

function TCDCdb.LoadAsteroidFile(astfile: string; astnumbered, stoperr, limit: boolean;
  astlimit: integer; memoast: Tmemo): boolean;
var
  buf, cmd, c, filedesc, filenum: string;
  ep, id, nam, ec, ax, i, node, peri, eq, ma, h, g, ref: string;
  y, m, d, nl, prefl, lid, nerr, ierr, rerr: integer;
  hh: double;
  f: textfile;
begin
  nerr := 1;
  Result := False;
  if not fileexists(astfile) then
  begin
    memoast.Lines.add(rsFileNotFound);
    exit;
  end;
  try
    if DB.Active then
    begin
      filedesc := extractfilename(astfile) + blank + FormatDateTime(
        'yyyy-mm-dd hh:nn', FileDateToDateTime(FileAge(astfile)));
      Filemode := 0;
      assignfile(f, astfile);
      reset(f);
      // minimal file checking to distinguish full mpcorb from daily update
      readln(f, buf);
      nl := 1;
      c := trim(copy(buf, 27, 9));
      val(c, hh, nerr);
      if nerr = 0 then
      begin
        reset(f);
        nl := 0;
      end
      else
        repeat
          readln(f, buf);
          Inc(nl);
        until EOF(f) or (copy(buf, 1, 5) = '-----');
      if EOF(f) then
      begin
        memoast.Lines.add(rsThisFileWasN);
        raise Exception.Create('');
      end;
      memoast.Lines.add(Format(rsDataStartOnL, [IntToStr(nl + 1)]));
      prefl := nl;
      DB.starttransaction;
      DB.LockTables('cdc_ast_elem WRITE, cdc_ast_elem_list WRITE, cdc_ast_name WRITE');
      nerr := 0;
      rerr := 0;
      nl := 0;
      repeat
        readln(f, buf);
        Inc(nl);
        if trim(buf) = '' then
        begin
          if astnumbered then
            break
          else
            continue;
        end;
        if (nl mod 10000) = 0 then
        begin
          memoast.Lines.add(Format(rsProcessingLi, [IntToStr(nl)]));
          application.ProcessMessages;
        end;
        id := trim(copy(buf, 1, 7));
        if id = '' then
        begin
          Dec(nl);
          Inc(rerr);
          Continue;
        end;
        lid := length(id);
        if lid < 7 then
          id := StringofChar('0', 7 - lid) + id;
        h := trim(copy(buf, 9, 5));
        g := trim(copy(buf, 15, 5));
        ep := trim(copy(buf, 21, 5));
        if ep = '' then
        begin
          Dec(nl);
          Inc(rerr);
          Continue;
        end;
        if decode_mpc_date(ep, y, m, d, hh) then
          ep := floattostr(jd(y, m, d, hh))
        else
        begin
          Inc(nerr);
          memoast.Lines.add(Format(rsInvalidEpoch, [IntToStr(nl + prefl), buf]));
          break;
        end;
        ma := trim(copy(buf, 27, 9));
        val(ma, tstval, ierr);
        if ierr <> 0 then
        begin
          Dec(nl);
          Inc(rerr);
          Continue;
        end;
        peri := trim(copy(buf, 38, 9));
        val(peri, tstval, ierr);
        if ierr <> 0 then
        begin
          Dec(nl);
          Inc(rerr);
          Continue;
        end;
        node := trim(copy(buf, 49, 9));
        val(node, tstval, ierr);
        if ierr <> 0 then
        begin
          Dec(nl);
          Inc(rerr);
          Continue;
        end;
        i := trim(copy(buf, 60, 9));
        val(i, tstval, ierr);
        if ierr <> 0 then
        begin
          Dec(nl);
          Inc(rerr);
          Continue;
        end;
        ec := trim(copy(buf, 71, 9));
        val(ec, tstval, ierr);
        if ierr <> 0 then
        begin
          Dec(nl);
          Inc(rerr);
          Continue;
        end;
        ax := trim(copy(buf, 93, 11));
        val(ax, tstval, ierr);
        if ierr <> 0 then
        begin
          Dec(nl);
          Inc(rerr);
          Continue;
        end;
        ref := trim(copy(buf, 108, 10));
        nam := stringreplace(trim(copy(buf, 167, 27)), '"', '\"', [rfreplaceall]);
        eq := '2000';
        if nl = 1 then
        begin
          filedesc := filedesc + ', epoch=' + ep;
          buf := DB.QueryOne('Select max(elem_id) from cdc_ast_elem_list');
          if buf <> '' then
            filenum := IntToStr(StrToInt(buf) + 1)
          else
            filenum := '1';
          if not DB.Query('Insert into cdc_ast_elem_list (elem_id, filedesc) Values("' +
            filenum + '","' + filedesc + '")') then
            memoast.Lines.add(trim(DB.ErrorMessage));
        end;
        cmd := 'REPLACE INTO cdc_ast_elem (id,h,g,epoch,mean_anomaly,arg_perihelion,asc_node,inclination,eccentricity,semi_axis,ref,name,equinox,elem_id) VALUES (' + '"' + id + '"' + ',"' + h + '"' + ',"' + g + '"' + ',"' + ep + '"' + ',"' + ma + '"' + ',"' + peri + '"' + ',"' + node + '"' + ',"' + i + '"' + ',"' + ec + '"' + ',"' + ax + '"' + ',"' + ref + '"' + ',"' + nam + '"' + ',"' + eq + '"' + ',"' + filenum + '"' + ')';
        if (not DB.query(cmd)) and (DB.LastError <> 19) then
        begin
          memoast.Lines.add(Format(rsInsertFailed, [IntToStr(nl + prefl),
            trim(DB.ErrorMessage)]));
          Inc(nerr);
          if stoperr and (nerr > 1000) then
          begin
            memoast.Lines.add(rsMoreThan1000);
            break;
          end;
        end;
        cmd := 'REPLACE INTO cdc_ast_name (name, id) VALUES (' + '"' +
          nam + '"' + ',"' + id + '"' + ')';
        DB.query(cmd);
        if limit and (nl >= astlimit) then
          break;
      until EOF(f);
      closefile(f);
      memoast.Lines.add(Format(rsProcessingEn2, [IntToStr(nl)]));
      if rerr > 0 then
        memoast.Lines.add(Format(rsNumberOfIgno, [IntToStr(rerr)]));
    end
    else
    begin
      buf := trim(DB.ErrorMessage);
      if buf <> '0' then
        memoast.Lines.add(buf);
    end;
    DB.UnLockTables;
    DB.commit;
    DB.flush('tables');
    Result := (nerr = 0);
    memoast.Lines.SaveToFile(slash(DBDir) + 'LoadAsteroidFile.log');
  except
  end;
end;

procedure TCDCdb.DelAsteroid(astelemlist: string; memoast: Tmemo);
var
  i: integer;
  elem_id: string;
begin
  memoast.Clear;
  i := pos(';', astelemlist);
  elem_id := copy(astelemlist, 1, i - 1);
  if trim(elem_id) = '' then
    exit;
  try
    if DB.Active then
    begin
      DB.starttransaction;
      DB.LockTables('cdc_ast_elem WRITE, cdc_ast_elem_list WRITE, cdc_ast_mag WRITE');
      memoast.Lines.add(rsDeleteFromEl);
      application.ProcessMessages;
      if not DB.Query('Delete from cdc_ast_elem where elem_id=' + elem_id) then
        memoast.Lines.add(Format(rsFailed, [trim(DB.ErrorMessage)]));
      memoast.Lines.add(rsDeleteFromEl2);
      application.ProcessMessages;
      if not DB.Query('Delete from cdc_ast_elem_list where elem_id=' + elem_id) then
        memoast.Lines.add(Format(rsFailed, [trim(DB.ErrorMessage)]));
      memoast.Lines.add(rsDeleteFromMo);
      application.ProcessMessages;
      if not DB.Query('Delete from cdc_ast_mag where elem_id=' + elem_id) then
        memoast.Lines.add(Format(rsFailed, [trim(DB.ErrorMessage)]));
      DB.UnLockTables;
      DB.commit;
      DB.flush('tables');
      memoast.Lines.add(rsDeleteDailyD);
      TruncateDailyAsteroid;
      DB.Vacuum;
      memoast.Lines.add(rsDeleteComple);
    end;
  except
  end;
end;

procedure TCDCdb.DelAstDate(astdeldate: string; memoast: Tmemo);
var
  i, y, m: integer;
  jds: string;
begin
  memoast.Clear;
  i := pos('.', astdeldate);
  y := StrToInt(trim(copy(astdeldate, 1, i - 1)));
  m := StrToInt(trim(copy(astdeldate, i + 1, 99)));
  jds := formatfloat(f1, jd(y, m, 1, 0));
  try
    if DB.Active then
    begin
      DB.starttransaction;
      DB.LockTables('cdc_ast_mag WRITE');
      memoast.Lines.add(Format(rsDeleteFromMo2, [jds]));
      application.ProcessMessages;
      if not DB.Query('Delete from cdc_ast_mag where jd<' + jds) then
        memoast.Lines.add(Format(rsFailed, [trim(DB.ErrorMessage)]));
      DB.UnLockTables;
      DB.commit;
      DB.flush('tables');
      DB.Vacuum;
      memoast.Lines.add(rsDeleteComple);
    end;
  except
  end;
end;

procedure TCDCdb.DelAstAll(memoast: Tmemo);
begin
  memoast.Clear;
  try
    if DB.Active then
    begin
      DB.UnLockTables;
      DB.starttransaction;
      memoast.Lines.add(rsDeleteFromEl);
      application.ProcessMessages;
      DB.TruncateTable('cdc_ast_elem');
      memoast.Lines.add(rsDeleteFromEl2);
      application.ProcessMessages;
      DB.TruncateTable('cdc_ast_elem_list');
      memoast.Lines.add(rsDeleteFromNa);
      application.ProcessMessages;
      DB.TruncateTable('cdc_ast_name');
      memoast.Lines.add(rsDeleteFromMo);
      application.ProcessMessages;
      DB.TruncateTable('cdc_ast_mag');
      DB.commit;
      memoast.Lines.add(rsDeleteDailyD);
      application.ProcessMessages;
      TruncateDailyAsteroid;
      memoast.Lines.add(rsPleaseWait);
      application.ProcessMessages;
      DB.Vacuum;
      memoast.Lines.add(rsDeleteComple);
    end;
  except
  end;
end;

function TCDCdb.AddAsteroid(astid, asth, astg, astep, astma, astperi,
  astnode, asti, astec, astax, astref, astnam, asteq: string): string;
var
  buf, cmd, filedesc, filenum: string;
  ep, id, nam, ec, ax, i, node, peri, eq, ma, h, g, ref: string;
  lid: integer;
begin
  try
    if DB.Active then
    begin
      id := trim(copy(astid, 1, 7));
      lid := length(id);
      if lid < 7 then
        id := StringofChar('0', 7 - lid) + id;
      h := trim(asth);
      g := trim(astg);
      ep := trim(astep);
      ma := trim(astma);
      peri := trim(astperi);
      node := trim(astnode);
      i := trim(asti);
      ec := trim(astec);
      ax := trim(astax);
      ref := trim(astref);
      nam := stringreplace(trim(astnam), '"', '\"', [rfreplaceall]);
      eq := trim(asteq);
      buf := DB.QueryOne('Select max(elem_id) from cdc_ast_elem_list');
      if buf <> '' then
        filenum := IntToStr(StrToInt(buf) + 1)
      else
        filenum := '1';
      filedesc := 'Add ' + id + ', ' + nam + ', ' + ep;
      DB.Query('Insert into cdc_ast_elem_list (elem_id, filedesc) Values("' +
        filenum + '","' + filedesc + '")');
      cmd := 'INSERT INTO cdc_ast_elem (id,h,g,epoch,mean_anomaly,arg_perihelion,asc_node,inclination,eccentricity,semi_axis,ref,name,equinox,elem_id) VALUES (' + '"' + id + '"' + ',"' + h + '"' + ',"' + g + '"' + ',"' + ep + '"' + ',"' + ma + '"' + ',"' + peri + '"' + ',"' + node + '"' + ',"' + i + '"' + ',"' + ec + '"' + ',"' + ax + '"' + ',"' + ref + '"' + ',"' + nam + '"' + ',"' + eq + '"' + ',"' + filenum + '"' + ')';
      if DB.query(cmd) then
      begin
        cmd := 'INSERT INTO cdc_ast_name (name, id) VALUES (' +
          '"' + nam + '"' + ',"' + id + '"' + ')';
        DB.query(cmd);
        Result := 'OK!';
      end
      else
        Result := Format(rsInsertFailed2, [trim(DB.ErrorMessage)]);
    end
    else
    begin
      buf := trim(DB.ErrorMessage);
      if buf <> '0' then
        Result := buf;
    end;
    DB.flush('tables');
  except
  end;
end;

procedure TCDCdb.TruncateDailyAsteroid;
var
  i, j: integer;
  dailytable: TStringList;
begin
  dailytable := TStringList.Create;
  try
    DB.UnLockTables;
    DB.Query(showtable + ' "cdc_ast_day_%"');
    i := 0;
    while i < DB.Rowcount do
    begin
      dailytable.add(DB.results[i][0]);
      Inc(i);
    end;
    j := 0;
    DB.StartTransaction;
    while j < dailytable.Count do
    begin
      DB.TruncateTable(dailytable[j]);
      DB.Query('drop table ' + dailytable[j]);
      Inc(j);
    end;
    DB.Commit;
  finally
    dailytable.Free;
  end;
end;

procedure TCDCdb.TruncateDailyComet;
var
  i, j: integer;
  dailytable: TStringList;
begin
  dailytable := TStringList.Create;
  try
    DB.UnLockTables;
    DB.Query(showtable + ' "cdc_com_day_%"');
    i := 0;
    while i < DB.Rowcount do
    begin
      dailytable.add(DB.results[i][0]);
      Inc(i);
    end;
    j := 0;
    DB.StartTransaction;
    while j < dailytable.Count do
    begin
      DB.TruncateTable(dailytable[j]);
      DB.Query('drop table ' + dailytable[j]);
      Inc(j);
    end;
    DB.Commit;
  finally
    dailytable.Free;
  end;
end;

procedure TCDCdb.LoadSampleData(memo: Tmemo; cmain: Tconf_main);
begin
  try
    // load sample asteroid data
    if not LoadAsteroidFile(slash(sampledir) + 'MPCsample.dat', True, False,
      False, 1000, memo) then
    begin
      dropdb(cmain);
      raise Exception.Create('Error loading ' + slash(sampledir) + 'MPCsample.dat');
    end;
    // load sample comet data
    if not LoadCometFile(slash(sampledir) + 'Cometsample.dat', memo) then
    begin
      dropdb(cmain);
      raise Exception.Create('Error loading ' + slash(sampledir) + 'Cometsample.dat');
    end;
    // load location
    if not LoadCountryList(slash(sampledir) + 'country.dat', memo) then
    begin
      dropdb(cmain);
      raise Exception.Create('Error loading ' + slash(sampledir) + 'country.dat');
    end;
    if not LoadWorldLocation(slash(sampledir) + 'world.dat', '', False, memo) then
    begin
      dropdb(cmain);
      raise Exception.Create('Error loading ' + slash(sampledir) + 'world.dat');
    end;
    if not LoadUSLocation(slash(sampledir) + 'us.dat', False, memo) then
    begin
      dropdb(cmain);
      raise Exception.Create('Error loading ' + slash(sampledir) + 'us.dat');
    end;
  except
    on E: Exception do
    begin
      WriteTrace('LoadSampleData: ' + E.Message);
      MessageDlg('LoadSampleData: ' + E.Message + crlf + rsSomethingGoW + crlf
        + rsPleaseTryToR,
        mtError, [mbAbort], 0);
      Halt;
    end;
  end;
  memo.Lines.SaveToFile(slash(DBDir) + 'LoadSampleData.log');
end;

procedure TCDCdb.GetCometList(filter: string; maxnumber: integer;
  list: TStringList; var cometid: array of string);
var
  qry: string;
  i: integer;
begin
  qry := 'SELECT distinct(id),name FROM cdc_com_elem where name like "%' +
    trim(Filter) + '%" limit ' + IntToStr(maxnumber);
  DB.Query(qry);
  if DB.Rowcount > 0 then
    for i := 0 to DB.Rowcount - 1 do
    begin
      cometid[i] := DB.Results[i][0];
      list.Add(DB.Results[i][1]);
    end;
end;

procedure TCDCdb.GetAsteroidList(filter: string; maxnumber: integer;
  var list: TStringList; var astid: array of string);
var
  qry: string;
  i: integer;
begin
  qry := 'SELECT distinct(id),name FROM cdc_ast_elem where name like "%' +
    trim(Filter) + '%" limit ' + IntToStr(maxnumber);
  DB.Query(qry);
  if DB.Rowcount > 0 then
    for i := 0 to DB.Rowcount - 1 do
    begin
      astid[i] := DB.Results[i][0];
      list.Add(DB.Results[i][1]);
    end;
end;

function TCDCdb.GetCometEpoch(id: string; now_jd: double): double;
var
  diff, dif: double;
  i: integer;
  qry: string;
begin
  diff := 1E10;
  Result := 0;
  qry := 'SELECT epoch FROM cdc_com_elem where id="' + id + '"';
  DB.Query(qry);
  if DB.Rowcount > 0 then
    for i := 0 to DB.Rowcount - 1 do
    begin
      dif := abs(strtofloat(strim(DB.Results[i][0])) - now_jd);
      if dif < diff then
      begin
        Result := strtofloat(strim(DB.Results[i][0]));
        diff := dif;
      end;
    end;
end;

function TCDCdb.GetAsteroidEpoch(id: string; now_jd: double): double;
var
  diff, dif: double;
  i: integer;
  qry: string;
begin
  diff := 1E10;
  Result := 0;
  qry := 'SELECT epoch FROM cdc_ast_elem where id="' + id + '"';
  DB.Query(qry);
  if DB.Rowcount > 0 then
    for i := 0 to DB.Rowcount - 1 do
    begin
      dif := abs(strtofloat(strim(DB.Results[i][0])) - now_jd);
      if dif < diff then
      begin
        Result := strtofloat(strim(DB.Results[i][0]));
        diff := dif;
      end;
    end;
end;


function TCDCdb.GetAstElem(id: string; epoch: double;
  var h, g, ma, ap, an, ic, ec, sa, eq: double; var ref, nam, elem_id: string): boolean;
var
  qry: string;
begin
  try
    qry := 'SELECT id,h,g,epoch,mean_anomaly,arg_perihelion,asc_node,inclination,eccentricity,semi_axis,ref,name,equinox,elem_id'
      + ' from cdc_ast_elem ' + ' where id="' + id + '"' + ' and epoch=' +
      strim(formatfloat(f6s, epoch));
    DB.Query(qry);
    if DB.rowcount > 0 then
    begin
      if not trystrtofloat(strim(DB.Results[0][1]), h) then
        h := 17;
      if not trystrtofloat(strim(DB.Results[0][2]), g) then
        g := 0.15;
      ma := strtofloat(strim(DB.Results[0][4]));
      ap := strtofloat(strim(DB.Results[0][5]));
      an := strtofloat(strim(DB.Results[0][6]));
      ic := strtofloat(strim(DB.Results[0][7]));
      ec := strtofloat(strim(DB.Results[0][8]));
      sa := strtofloat(strim(DB.Results[0][9]));
      ref := DB.Results[0][10];
      nam := DB.Results[0][11];
      eq := strtofloat(strim(DB.Results[0][12]));
      elem_id := DB.Results[0][13];
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  except
    Result := False;
  end;
end;

function TCDCdb.GetComElem(id: string; epoch: double;
  var tp, q, ec, ap, an, ic, h, g, eq: double; var nam, elem_id: string): boolean;
var
  qry: string;
begin
  try
    qry := 'SELECT id,peri_epoch,peri_dist,eccentricity,arg_perihelion,asc_node,inclination,epoch,h,g,name,equinox,elem_id'
      + ' from cdc_com_elem ' + ' where id="' + id + '"' + ' and epoch=' +
      formatfloat(f1, epoch);
    DB.Query(qry);
    if DB.Rowcount > 0 then
    begin
      tp := strtofloat(strim(DB.Results[0][1]));
      q := strtofloat(strim(DB.Results[0][2]));
      ec := strtofloat(strim(DB.Results[0][3]));
      ap := strtofloat(strim(DB.Results[0][4]));
      an := strtofloat(strim(DB.Results[0][5]));
      ic := strtofloat(strim(DB.Results[0][6]));
      h := strtofloat(strim(DB.Results[0][8]));
      g := strtofloat(strim(DB.Results[0][9]));
      nam := DB.Results[0][10];
      eq := strtofloat(strim(DB.Results[0][11]));
      elem_id := DB.Results[0][12];
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  except
    Result := False;
  end;
end;

function TCDCdb.GetAstElemEpoch(id: string; jd: double;
  var epoch, h, g, ma, ap, an, ic, ec, sa, eq: double; var ref, nam, elem_id: string): boolean;
var
  qry: string;
  dt, t: double;
  i, j: integer;
begin
  try
    qry := 'SELECT id,h,g,epoch,mean_anomaly,arg_perihelion,asc_node,inclination,eccentricity,semi_axis,ref,name,equinox,elem_id'
      + ' from cdc_ast_elem' + ' where id="' + id + '"';
    DB.Query(qry);
    if DB.Rowcount > 0 then
    begin
      epoch := strtofloat(strim(DB.Results[0][3]));
      dt := abs(jd - epoch);
      j := 0;
      i := 1;
      while i < DB.Rowcount do
      begin
        t := strtofloat(strim(DB.Results[i][3]));
        if abs(jd - t) < dt then
        begin
          epoch := t;
          dt := abs(jd - t);
          j := i;
        end;
        Inc(i);
      end;
      if dt > 365 then
      begin
        FAstmsg := rsWarningSomeA;
      end;
      h := StrToFloatDef(strim(DB.Results[j][1]), 20);
      // H and G not present in file for some poorly observed asteroids
      g := StrToFloatDef(strim(DB.Results[j][2]), 0.15);
      ma := strtofloat(strim(DB.Results[j][4]));
      ap := strtofloat(strim(DB.Results[j][5]));
      an := strtofloat(strim(DB.Results[j][6]));
      ic := strtofloat(strim(DB.Results[j][7]));
      ec := strtofloat(strim(DB.Results[j][8]));
      sa := strtofloat(strim(DB.Results[j][9]));
      ref := DB.Results[j][10];
      nam := DB.Results[j][11];
      eq := strtofloat(strim(DB.Results[j][12]));
      elem_id := DB.Results[j][13];
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  except
    Result := False;
  end;
end;

function TCDCdb.GetComElemEpoch(id: string; jd: double;
  var epoch, tp, q, ec, ap, an, ic, h, g, eq: double; var nam, elem_id: string): boolean;
var
  qry: string;
  dt, t: double;
  i, j: integer;
begin
  try
    qry := 'SELECT id,peri_epoch,peri_dist,eccentricity,arg_perihelion,asc_node,inclination,epoch,h,g,name,equinox,elem_id'
      + ' from cdc_com_elem' + ' where id="' + id + '"';
    DB.Query(qry);
    if DB.Rowcount > 0 then
    begin
      epoch := strtofloat(strim(DB.Results[0][7]));
      dt := abs(jd - epoch);
      j := 0;
      i := 1;
      while i < DB.Rowcount do
      begin
        t := strtofloat(strim(DB.Results[i][7]));
        if abs(jd - t) < dt then
        begin
          epoch := t;
          dt := abs(jd - t);
          j := i;
        end;
        Inc(i);
      end;

      if dt < FComMindt then
      begin
        FComMindt := round(dt - 1);
      end;
      if dt < 36500 then
      begin // 100 years grace period...
        tp := strtofloat(strim(DB.Results[j][1]));
        q := strtofloat(strim(DB.Results[j][2]));
        ec := strtofloat(strim(DB.Results[j][3]));
        ap := strtofloat(strim(DB.Results[j][4]));
        an := strtofloat(strim(DB.Results[j][5]));
        ic := strtofloat(strim(DB.Results[j][6]));
        h := strtofloat(strim(DB.Results[j][8]));
        g := strtofloat(strim(DB.Results[j][9]));
        nam := DB.Results[j][10];
        eq := strtofloat(strim(DB.Results[j][11]));
        elem_id := DB.Results[j][12];
        Result := True;
      end
      else
        Result := False;
    end
    else
    begin
      Result := False;
    end;
  except
    Result := False;
  end;
end;

function TCDCdb.CountImages(catname: string): integer;
var cmd: string;
begin
  try
    if DB.Active then
    begin
      cmd:='select count(*) from cdc_fits ';
      if trim(catname)='' then
        cmd:=cmd+' where length(catalogname)<=4'
      else
        cmd:=cmd+' where catalogname="' + uppercase(catname) + '"';
      Result := strtointdef(DB.QueryOne(cmd), 0);
    end
    else
      Result := 0;
  finally
  end;
end;

procedure TCDCdb.ScanImagesDirectory(ImagePath: string; ProgressCat: Tlabel;
  ProgressBar: TProgressBar);
var
  c, f: tsearchrec;
  i, j, n, p: integer;
  catdir, objn, fname, cmd, cmdl: string;
  dummyfile: boolean;
  ra, de, w, h, r: double;
begin
  try
    if DirectoryExists(ImagePath) then
    begin
      try
        if DB.Active then
        begin
          ProgressCat.Caption := '';
          ProgressBar.position := 0;
          DB.UnLockTables;
          DB.starttransaction;
          cmd := 'delete from cdc_fits where length(catalogname)<=4';
          DB.query(cmd);
          DB.commit;
          j := findfirst(slash(ImagePath) + '*', faDirectory, c);
          while j = 0 do
          begin
            if ((c.attr and faDirectory) <> 0) and (c.Name <> '.') and (c.Name <> '..') then
            begin
              catdir := slash(ImagePath) + c.Name;
              ProgressCat.Caption := c.Name;
              ProgressBar.position := 0;
              Application.ProcessMessages;
              i := findfirst(slash(catdir) + '*.*', 0, f);
              n := 1;
              while i = 0 do
              begin
                Inc(n);
                i := findnext(f);
              end;
              findclose(f);
              ProgressBar.min := 0;
              ProgressBar.max := n;
              if (ProgressBar.Max > 250) then
                ProgressBar.Step := ProgressBar.Max div 250
              else
                ProgressBar.Step := 1;
              i := findfirst(slash(catdir) + '*.*', 0, f);
              n := 0;
              cmdl:='BEGIN;';
              while i = 0 do
              begin
                if f.Name = 'README.TXT' then
                begin
                  i := findnext(f);
                  continue;
                end;
                Inc(n);
                if (n mod ProgressBar.step) = 0 then
                begin
                  ProgressBar.stepit;
                  Application.ProcessMessages;
                end;
                dummyfile := uppercase((extractfileext(f.Name))) = '.NIL';
                if dummyfile then
                begin
                  ra := 99 + random(999999999999999);
                  de := 99 + random(999999999999999);
                  w := 0;
                  h := 0;
                  r := 0;
                  fname := slash(catdir) + f.Name;
                end
                else
                begin
                  // this is much faster than cdcwcs_getinfo
                  FFits.FileName := slash(catdir) + f.Name;
                  ra := FFits.Center_RA;
                  de := FFits.Center_DE;
                  w := FFits.Img_Width;
                  h := FFits.img_Height;
                  r := FFits.Rotation;
                  fname := FFits.FileName;
                end;
                if FFits.header.valid or dummyfile then
                begin
                  objn := extractfilename(f.Name);
                  p := pos(extractfileext(objn), objn);
                  objn := copy(objn, 1, p - 1);
                  objn := uppercase(stringreplace(objn, blank, '', [rfReplaceAll]));
                  cmd := 'INSERT INTO cdc_fits (filename,catalogname,objectname,ra,de,width,height,rotation) VALUES ('
                    + '"' + stringreplace(fname, '\', '\\', [rfReplaceAll]) + '"' +
                    ',"' + uppercase(c.Name) + '"' + ',"' + uppercase(objn) + '"' +
                    ',"' + formatfloat(f5, ra) + '"' + ',"' + formatfloat(f5, de) + '"' +
                    ',"' + formatfloat(f5, w) + '"' + ',"' + formatfloat(f5, h) + '"' +
                    ',"' + formatfloat(f5, r) + '"' + ')';
                cmdl:=cmdl+cmd+';';
                end
                else
                  writetrace(Format(rsInvalidFITSF, [f.Name]));
                i := findnext(f);
              end;
              cmdl:=cmdl+'COMMIT;';
              if not DB.query(cmdl) then
                 writetrace(Format(rsDBInsertFail, [f.Name, DB.ErrorMessage]));
              findclose(f);
            end;
            j := findnext(c);
          end;
          DB.flush('tables');
        end;
      finally
        findclose(c);
      end;
    end
    else
    begin
      ProgressCat.Caption := 'Directory not found!';
    end;
  except
  end;
end;

function TCDCdb.AddFitsArchiveFile(ArchivePath, fn: string): boolean;
var
  ra, de, w, h, r: double;
  p, n: integer;
  info: TcdcWCSinfo;
  cmd, objn, fname: string;
begin
  Result := False;
  fname := slash(ArchivePath) + fn;
  n := cdcwcs_initfitsfile(PChar(fname),0);
  if n=0 then
     n := cdcwcs_getinfo(addr(info),0);
  cdcwcs_release(0);
  if n=0 then
  begin
    ra := deg2rad * info.cra;
    de := deg2rad * info.cdec;
    w := deg2rad * info.wp * info.secpix / 3600;
    h := deg2rad * info.hp * info.secpix / 3600;
    r := deg2rad * info.rot;
    objn := extractfilename(fn);
    p := pos(extractfileext(objn), objn);
    objn := copy(objn, 1, p - 1);
    objn := uppercase(stringreplace(objn, blank, '', [rfReplaceAll]));
    cmd := 'INSERT INTO cdc_fits (filename,catalogname,objectname,ra,de,width,height,rotation) VALUES ('
      + '"' + stringreplace(fname, '\', '\\', [rfReplaceAll]) + '"' +
      ',"' + uppercase(ArchivePath) + '"' + ',"' + uppercase(objn) + '"' +
      ',"' + formatfloat(f9, ra) + '"' + ',"' + formatfloat(f9, de) + '"' +
      ',"' + formatfloat(f5, w) + '"' + ',"' + formatfloat(f5, h) + '"' +
      ',"' + formatfloat(f5, r) + '"' + ')';
    if DB.query(cmd) then
      Result := True
    else
      writetrace(Format(rsDBInsertFail, [fn, DB.ErrorMessage]));
  end
  else
    writetrace(Format(rsInvalidFITSF, [fn]));
end;

procedure TCDCdb.ScanArchiveDirectory(ArchivePath: string; var Count: integer);
var
  f: tsearchrec;
  i, n: integer;
  cmd: string;
begin
  n := 0;
  try
    if DirectoryExists(ArchivePath) then
    begin
      if DB.Active then
      begin
        DB.UnLockTables;
        DB.StartTransaction;
        cmd := 'delete from cdc_fits where catalogname="' + uppercase(ArchivePath) + '"';
        DB.query(cmd);
        DB.Commit;
        i := findfirst(slash(ArchivePath) + '*.*', 0, f);
        DB.StartTransaction;
        while i = 0 do
        begin
          if AddFitsArchiveFile(ArchivePath, f.Name) then
            Inc(n);
          i := findnext(f);
        end;
        findclose(f);
        DB.Commit;
        DB.flush('tables');
      end;
    end;
    Count := n;
  except
  end;
end;

function TCDCdb.LoadCountryList(locfile: string; memo: Tmemo): boolean;
var
  f: textfile;
  buf, sql: string;
  rec: TStringList;
begin
  Result := False;
  Memo.Clear;
  if not fileexists(locfile) then
  begin
    Memo.Lines.add(rsFileNotFound);
    ShowMessage(rsFileNotFound + crlf + locfile);
    exit;
  end;
  try
    if DB.Active then
    begin
      rec := TStringList.Create;
      Filemode := 0;
      assignfile(f, locfile);
      reset(f);
      DB.StartTransaction;
      repeat
        readln(f, buf);
        SplitRec(buf, tab, rec);
        sql := 'insert into cdc_country (country,isocode,name)' + 'values (' +
          '"' + rec[0] + '",' + '"' + rec[1] + '",' + '"' + rec[2] + '")';
        if not DB.Query(sql) then
          Memo.Lines.add(rec[0] + blank + DB.ErrorMessage)
        else
          Result := True;
      until (EOF(f));
      DB.Commit;
      DB.flush('tables');
      closefile(f);
      rec.Free;
    end;
    memo.Lines.SaveToFile(slash(DBDir) + 'LoadCountryList.log');
    application.ProcessMessages;
  except
  end;
end;

function TCDCdb.LoadWorldLocation(locfile, country: string; city_only: boolean;
  memo: Tmemo): boolean;
var
  f: textfile;
  buf, sql, cc: string;
  rec: TStringList;
  nl: integer;
  force_country: boolean;
begin
  Result := False;
  Memo.Clear;
  if not fileexists(locfile) then
  begin
    Memo.Lines.add(rsFileNotFound);
    exit;
  end;
  try
    if DB.Active then
    begin
      rec := TStringList.Create;
      nl := 0;
      force_country := (country <> '');
      Filemode := 0;
      assignfile(f, locfile);
      reset(f);
      readln(f, buf); // heading
      if isnumber(copy(buf, 1, 1)) then
        reset(f);
      DB.starttransaction;
      DB.LockTables('cdc_location WRITE');
      repeat
        readln(f, buf);
        if (nl mod 10000) = 0 then
        begin
          Memo.Lines.add(Format(rsProcessingLi, [IntToStr(nl)]));
          application.ProcessMessages;
        end;
        SplitRec(buf, tab, rec);
        if (rec[17] <> 'V') and  // skip alternate name
          ((not city_only)  // all names
          or ((rec[9] = 'P') and (rec[10] <> 'PPLQ') and
          (rec[10] <> 'PPLW'))  // populated place only
          ) then
        begin
          if not IsNumber(rec[3]) then
            continue;
          if not IsNumber(rec[4]) then
            continue;
          if force_country then
            cc := country
          else
            cc := rec[12];
          sql := 'insert into cdc_location (locid,country,location,type,latitude,longitude,elevation,timezone)'
            + 'values (' + rec[2] + ',' + '"' + cc + '",' +
            '"' + strim(rec[22]) + '",' + '"' + rec[10] + '",' + rec[3] + ',' +
            rec[4] + ',' + '0,' + '0)';
          if not DB.Query(sql) then
            Memo.Lines.add(rec[2] + blank + cc + blank + DB.ErrorMessage)
          else
            Inc(nl);
        end;
      until (EOF(f));
      closefile(f);
      rec.Free;
      DB.UnLockTables;
      DB.commit;
      DB.flush('tables');
      Memo.Lines.add(Format(rsProcessingEn3, [IntToStr(nl)]));
      application.ProcessMessages;
      Result := (nl > 0);
    end;
    memo.Lines.SaveToFile(slash(DBDir) + 'LoadWorldLocation.log');
  except
  end;
end;

function TCDCdb.LoadUSLocation(locfile: string; city_only: boolean;
  memo: Tmemo; state: string = ''): boolean;
var
  f: textfile;
  buf, sql: string;
  rec: TStringList;
  nl: integer;
  elev: double;
begin
  Result := False;
  Memo.Clear;
  if not fileexists(locfile) then
  begin
    Memo.Lines.add(rsFileNotFound);
    exit;
  end;
  try
    if DB.Active then
    begin
      rec := TStringList.Create;
      nl := 0;
      Filemode := 0;
      assignfile(f, locfile);
      reset(f);
      readln(f, buf); // heading
      if isnumber(copy(buf, 1, 1)) then
        reset(f);
      DB.starttransaction;
      DB.LockTables('cdc_location WRITE');
      repeat
        if (nl mod 10000) = 0 then
        begin
          Memo.Lines.add(Format(rsProcessingLi, [IntToStr(nl)]));
          application.ProcessMessages;
        end;
        readln(f, buf);
        SplitRec(buf, tab, rec);
        if ((not city_only)  // all names
          or (rec[2] = 'Populated Place')  // populated place only
          ) then
        begin
          if (state <> '') and (state <> rec[3]) then
            continue; // wrong state
          if not IsNumber(rec[9]) then
            continue;
          if not IsNumber(rec[10]) then
            continue;
          elev := strtointdef(rec[15], 0);
          if rec[1] <> rec[5] then
            rec[1] := rec[1] + ', ' + rec[5];
          sql := 'insert into cdc_location (locid,country,location,type,latitude,longitude,elevation,timezone)'
            + 'values (' + rec[0] + ',' + '"US-' + rec[3] + '",' +
            '"' + Condutf8encode(strim(rec[1])) + '",' + '"' + rec[2] + '",' +
            rec[9] + ',' + rec[10] + ',' + formatfloat('0.0', elev) + ',' +
            '0)';
          if not DB.Query(sql) then
            Memo.Lines.add(rec[0] + blank + rec[3] + blank + DB.ErrorMessage)
          else
            Inc(nl);
        end;
      until (EOF(f));
      closefile(f);
      rec.Free;
      DB.UnLockTables;
      DB.commit;
      DB.flush('tables');
      Memo.Lines.add(Format(rsProcessingEn3, [IntToStr(nl)]));
      Application.ProcessMessages;
      Result := (nl > 0);
    end;
    memo.Lines.SaveToFile(slash(DBDir) + 'LoadUSLocation.log');
  except
  end;
end;

procedure TCDCdb.GetCountryList(codelist, countrylist: TStrings);
var
  i: integer;
  buf: string;
begin
  countrylist.Clear;
  codelist.Clear;
  DB.Query('select country,name from cdc_country');
  i := 0;
  while i < DB.RowCount do
  begin
    codelist.add(DB.results[i][0]);
    buf := DB.results[i][1];
    countrylist.add(Condutf8decode(buf));
    Inc(i);
  end;
end;

procedure TCDCdb.GetCountryISOCode(countrycode: string; var isocode: string);
begin
  isocode := DB.QueryOne('select isocode from cdc_country where country = "' +
    countrycode + '"');
end;

procedure TCDCdb.GetCountryFromISO(isocode: string; var cname: string);
begin
  cname := DB.QueryOne('select name from cdc_country where isocode = "' + isocode + '"');
end;

procedure TCDCdb.GetCityList(countrycode, filter: string; codelist, citylist: TStrings;
  startr, limit: integer);
var
  i, k: integer;
  prev, buf, bufutf8: string;
begin
  citylist.Clear;
  codelist.Clear;
  filter := Condutf8encode(filter);
  buf := 'select locid,location,type from cdc_location where country = "' + countrycode + '" ';
  if filter <> '' then
    buf := buf + ' and location like "' + filter + '" ';
  buf := buf + ' order by location limit ' + IntToStr(startr) + ',' + IntToStr(limit);
  DB.Query(buf);
  i := 0;
  k := 0;
  prev := '';
  while i < DB.RowCount do
  begin
    codelist.add(DB.results[i][0]);
    buf := DB.results[i][1];
    if copy(DB.results[i][2], 1, 3) <> 'PPL' then
      buf := buf + ' -- ' + DB.results[i][2];
    if buf = prev then
    begin
      Inc(k);
      buf := buf + ' -- ' + IntToStr(k);
    end
    else
    begin
      prev := buf;
      k := 0;
    end;
    bufutf8 := Condutf8decode(buf);
    citylist.add(bufutf8);
    Inc(i);
  end;
  if DB.RowCount >= limit then
    citylist.add('...');
end;

procedure TCDCdb.GetCityRange(country: string; lat1, lat2, lon1, lon2: double;
  codelist, citylist: TStrings; limit: integer);
var
  lo1, lo2, la1, la2, buf, prev: string;
  i, k: integer;
begin
  la1 := floattostr(lat1);
  la2 := floattostr(lat2);
  lo1 := floattostr(lon1);
  lo2 := floattostr(lon2);
  DB.Query('select locid,location,type from cdc_location where ' +
    'country="' + country + '" and ' + '(latitude between ' +
    la1 + ' and ' + la2 + ') and ' + '(longitude between ' + lo1 + ' and ' +
    lo2 + ') order by location limit ' + IntToStr(limit));
  i := 0;
  k := 0;
  prev := '';
  while i < DB.RowCount do
  begin
    codelist.add(DB.results[i][0]);
    buf := DB.results[i][1];
    if copy(DB.results[i][2], 1, 3) <> 'PPL' then
      buf := buf + ' -- ' + DB.results[i][2];
    if buf = prev then
    begin
      Inc(k);
      buf := buf + ' -- ' + IntToStr(k);
    end
    else
    begin
      prev := buf;
      k := 0;
    end;
    citylist.add(Condutf8decode(buf));
    Inc(i);
  end;
end;

function TCDCdb.GetCityLoc(locid: string;
  var loctype, latitude, longitude, elevation, timezone: string): boolean;
begin
  DB.Query('select type,latitude,longitude,elevation,timezone from cdc_location where locid="'
    +
    locid + '"');
  if DB.RowCount > 0 then
  begin
    loctype := DB.results[0][0];
    latitude := DB.results[0][1];
    longitude := DB.results[0][2];
    elevation := DB.results[0][3];
    timezone := DB.results[0][4];
    Result := True;
  end
  else
    Result := False;
end;

function TCDCdb.UpdateCity(locid: integer;
  country, location, loctype, lat, lon, elev, tz: string): string;
var
  id, buf: string;
begin
  if locid = 0 then
  begin // Add new location
    id := CdcMinLocid;
    buf := DB.QueryOne('select max(locid) from cdc_location where locid>=' + id);
    if buf <> '' then
    begin
      id := IntToStr(StrToInt(buf) + 1);
    end;
    DB.StartTransaction;
    DB.Query('insert into cdc_location (locid,country,location,type,latitude,longitude,elevation,timezone)' +
      'values (' + id + ',' + '"' + country + '",' +
      '"' + Condutf8encode(location) + '",' + '"' + loctype + '",' +
      lat + ',' + lon + ',' + elev + ',' + tz + ')');
    Result := DB.ErrorMessage;
    DB.Commit;
  end
  else
  begin  // update location
    id := IntToStr(locid);
    DB.StartTransaction;
    DB.Query('update cdc_location set ' + 'latitude=' + lat + ',' +
      'longitude=' + lon + ',' + 'elevation=' + elev + ',' +
      'timezone=' + tz + ' where locid=' + id);
    Result := DB.ErrorMessage;
    DB.Commit;
  end;
end;

function TCDCdb.DeleteCity(locid: integer): string;
begin
  DB.StartTransaction;
  DB.Query('delete from cdc_location where locid="' + IntToStr(locid) + '"');
  Result := DB.ErrorMessage;
  DB.Commit;
end;

function TCDCdb.DeleteCountry(country: string; deleteall: boolean): string;
var
  sql: string;
begin
  sql := 'delete from cdc_location where country="' + country + '"';
  if not deleteall then
    sql := sql + ' and locid<' + CdcMinLocid;
  DB.StartTransaction;
  DB.Query(sql);
  Result := DB.ErrorMessage;
  DB.Commit;
end;

end.
