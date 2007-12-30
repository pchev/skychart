program libcheck;
{$APPTYPE CONSOLE}

//Application to test various aspects of libsql
//tests major query types for errors
//any inconsistencies using result sets
//and memory leaks if memcheck is enabled
//based on sqlite but easy to adjust for other databases

uses
  Windows,
  SyncObjs,
  MemCheck,
  SysUtils,
  passql,
  passqlite,
  zlib,
  staticsqlite3;

var
  db: TLiteDB;
  i,h: Integer;
  row: TResultRow;
  rs: TResultSet;
  tc: Integer;
  c: Integer;

begin
  //TMultiReadExclusiveWriteSynchronizer
  //FlushFileBuffers;
  try
    //test main constructor / destructor:
    db := TLiteDB.Create(nil, ':memory:');
    if not db.DllLoaded then
      begin
        writeln ('sqlite dynamic link library not found');
        exit;
      end;
    writeln ('SQLite version: '+db.ServerVersion);
    db.SetUserVersion(2);
    writeln ('User version: ', db.GetUserVersion);
    db.Free;

    //basic query on DB
    db := TLiteDB.Create(nil, ':memory:');
    for i := 0 to 1000 do
      db.FormatQuery('select %d+%d', [1,1]);
    writeln (db.Results[0].FieldName[0]);
    writeln (db.Results[0].FieldTypeName[0]);
    db.Free;

    //basic formatquery on DB
    db := TLiteDB.Create(nil, ':memory:');
    db.FormatQuery('select %d+%d', [1,1]);
    writeln (db.Results[0][0]);
    db.Free;

    //Andy's issue
    //basic formatexecute on DB, repeated
    db := TLiteDB.Create(nil, ':memory:');
    db.Query ('create table temp (name text)');
    for i:=0 to 200 do
      db.FormatQuery('insert into temp (name) values (%s)', ['Text']);
    for i:=0 to 500 do
      begin
        h := db.FormatExecute('select name from temp where name=%s', ['Text']);
//        h := db.Execute ('select 432432 ueo ueeuue');
        db.FreeResult(h);
      end;
    db.Free;

    //Andy's issue, again
    db:=TLiteDB.Create(nil,'test.lit');
    db.QueryOne('CREATE TABLE temp (id NUMERIC, name TEXT)');
    db.QueryOne('INSERT INTO temp (id, name) VALUES (1,''test'')');

    for i:=1 to 500 do begin
      h:=db.FormatExecute('SELECT name FROM temp WHERE id=%d',[1]);
      db.FreeResult(h);
    end;

    db.Free;






    //Per row fetching using execute method using DB
    db := TLiteDB.Create(nil, ':memory:');
    h := db.Execute ('select 1+1');
    while db.FetchRow(h, row) do
      writeln (row[0]);
    db.FreeResult(h);
    db.Free;

    //Per row fetching using formatexecute method using DB
    db := TLiteDB.Create(nil, ':memory:');
    h := db.FormatExecute ('select %d + %d', [1, 1]);
    while db.FetchRow(h, row) do
      writeln (row[0]);
    db.FreeResult(h);
    db.Free;

    //Result set testing:
    db := TLiteDB.Create(nil, ':memory:');
    rs := db.UseResultSet('testing');
    rs.Query('select 1+1');
    writeln (rs.Row[0][0]);
    db.Free; //db should free the result set

    db := TLiteDB.Create(nil, ':memory:');
    rs := db.UseResultSet('testing');
    rs.Query('select 1+1');
    writeln (rs.Row[0][0]);
    rs.Free; //db should not complain about resultset being freed
    db.Free;

    db := TLiteDB.Create(nil, ':memory:');
    rs := TResultSet.Create(db);
    rs.Query('select 1+1');
    writeln (rs.Row[0][0]);
    db.Free; //db does _not_ free the result set since it was manually created
    rs.Free;

    db := TLiteDB.Create(nil, ':memory:');
    rs := TResultSet.Create(db);
    rs.FormatQuery('select %d + %d', [1,1]);
    writeln (rs.Row[0][0]);
    db.Free;

    //double usage of resultset
    db := TLiteDB.Create(nil, ':memory:');
    db.UseResultSet(rs);
    rs.FormatQuery('select %d + %d', [1,1]);
    writeln (rs.Row[0][0]);
    db.Free;
    rs.Free;

    //row fetching using a TResultSet
    db := TLiteDB.Create(nil, ':memory:');
    rs := db.UseResultSet('rowfetch');
    if rs.Execute ('select 1+1') then
      while rs.FetchRow do
        writeln (rs.Fetched[0]);
    rs.FreeResult;
    db.Free;

    writeln ('Now benchmarking');
    writeln;
    c := 1;
    db := TLiteDB.Create(nil, 'sqlitebenchmark');
    db.Query('pragma synchronous=off');
    repeat
      writeln (format ('inserting %d records', [c]));
      //basic formatexecute on DB, repeated
      db.Query('drop table temp');
      db.Query ('create table temp (name text)');
      tc := GetTickCount;
      for i:=1 to c do
        db.FormatQuery('insert into temp (name) values (%s)', ['test']);
      writeln ('Seperate transactions ',GetTickCount - tc , ' ms');
      db.Query('drop table temp');
      db.Query ('create table temp (name text)');
  //    db.Query('delete from temp');
      tc := GetTickCount;
      db.StartTransaction;
      for i:=0 to c do
        db.FormatQuery('insert into temp (name) values (%s)', ['test']);
      db.Commit;
      writeln ('Single transaction ',GetTickCount - tc, ' ms');
      writeln;
      c := c * 10;
    until c > 10;
    db.Free;

    db := TLiteDB.Create(nil, 'sqlitebenchmark');
    db.Query ('select 1+1');
    writeln ('Dak result: ', db.Results[0][0]);
    db.Free;
  except
    on E:Exception do
      writeln (E.Message);
  end;

  writeln ('Please hit the <ENTER> key');
  readln;

end.



