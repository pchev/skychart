unit pasthreadedsqlite;

//motivation:
//linux requires all file io be done in single thread
//when predictive sequencitg is _demanded_. Like sqlite flat file database demands it.
//bit of trouble to create a helper thread but Richard Hipp promises it is worth your data integrity.

//Wraps SQLITE te run in a single thread
//This to allow (heavily) multi threaded applications
//to be easily ported to linux and possibly onter unices
//This due slightly different threading methods of linux
//which consequences in file sharing issueus if multiple threads
//are accessing the same file.

//Principle is this:
//A decendant of TLiteDB fetches all requests
//a seperate thread handles all file I/O
//atomic memory writes makes stuff as fast as possible (hopefully)
//multiple threads accessing the same database object
//still need to lock the class
//also it is recommended on platforms that have not this issue (windows)
//to just create a TLiteDB.
//May be it helps stability issues when running wine.
//Target is to be as compatable as possible with TLiteDB
//including multi-thread support

//Use an insteance of TMLiteDB for each database file you wish to access multi threaded
//Be sure to still use Lock and Unlock methods for multi-threaded access to TMLiteDB !!!

//This library is _not_ ready for usage
//shuffling the result sets between two db instances have some consequences
//that must be solved

//usage:
//Share the same database object among threads:
//db := TMLiteDB.Create (nil, 'testbase.ldb');
//each thread should lock the database (just as before):
//db.Lock;
//db.Query;
//db.WorkWithResultSet - do your things
//db.Unlock;

//FormatQuery etc. will still work.



interface

{$IFDEF FPC}
  {$MODE Delphi}
  {$H+}
{$ELSE}
  {$IFNDEF LINUX}
    {$DEFINE WIN32}
  {$ELSE}
    {$DEFINE UNIX}
  {$ENDIF}
{$ENDIF}

uses
    {$IFDEF MSWINDOWS}Windows, {$ENDIF}
    Classes, SysUtils, SyncObjs,
    utf8util,
    passql,
    passqlite,
    sqlsupport;


type TLiteDBCommands = (lcNone, lcUse, lcQuery, lcExecute, lcFetchRow, lcFreeResult,
                         lcQueryW, lcExecuteW, lcFetchRowW);

type

  TThreadExchangeParam = record
    ResultSet: TResultSet;
    Command: TLiteDBCommands;
    Param: String;
    ParamW: String;
    BoolResult: Boolean;
    Handle: Integer;
    row: TResultRow;
  end;


  TSqliteDBThread = class (TThread)

    //Synchronize between the threads
    //Synchronize using atomic variables
    //instead of messages, criticalsections or whatever
    //may be (???) one should wrap those with a TCriticalSection
    //on SMP environments. comments welcome.
    //WaitForSingleEvent or some may be more efficient.

    //For now, thread locking is assumed to be done on a different level.
  protected
    DB: TLiteDB;
  public
    SleepTime: Integer;

    CommandStarted,
    CommandReady: Boolean;

    Param: TThreadExchangeParam;

    procedure Execute; override;
  end;

  TMLiteDB = class (TLiteDB)
  protected
    SqliteDBThread: TSqliteDBThread;
    Param: TThreadExchangeParam;
    //override: open, close, Query, Execute, FetchRow, FreeResult
    procedure RunandWait;
  public
    function Use (Database:String):Boolean; override;
    function Query (SQL:String):Boolean; override;
    function QueryW (SQL:WideString):Boolean; override;

    function Execute (SQL: String): THandle; override;
    function ExecuteW (SQL: WideString): THandle; override;

    function FetchRow (Handle: THandle; var row: TResultRow): Boolean; override;
    function FetchRowW (Handle: THandle; var row: TResultRow): Boolean; override;

    procedure FreeResult (Handle: THandle); override;

    constructor Create (AOwner:TComponent; DataBase:String=''); reintroduce; overload;
    destructor  Destroy; override;
  end;

implementation


{ TMLiteDB }

constructor TMLiteDB.Create(AOwner: TComponent; DataBase: String);
begin
  inherited Create (AOwner);
  SqliteDBThread := TSqliteDBThread.Create(True);
  SqliteDBThread.SleepTime := 10;
  SqliteDBThread.Resume;
  if Database <> '' then
    Use (Database);
end;

destructor TMLiteDB.Destroy;
begin
  SqliteDBThread.Terminate;
  SqliteDBThread.WaitFor;
  SqliteDBThread.Free;
  inherited;
end;

function TMLiteDB.Execute(SQL: String): THandle;
begin
//note that with Execote method
//the thread maintains the resultset. We must not free it!!
  Param.Command := lcExecute;
  Param.Param := SQL;
  RunAndWait;
  FCurrentSet := Param.ResultSet;
  Result := Param.Handle;
  FCurrentSet := Param.ResultSet;
end;

function TMLiteDB.ExecuteW(SQL: WideString): THandle;
begin
  Param.ResultSet := FCurrentSet;
  Param.Command := lcExecuteW;
  Param.ParamW := SQL;
  RunAndWait;
  Result := Param.Handle;
  FCurrentSet := Param.ResultSet;
end;

function TMLiteDB.FetchRow(Handle: THandle; var row: TResultRow): Boolean;
begin
  Param.ResultSet := FCurrentSet;
  Param.Command := lcFetchRow;
  Param.Handle := Handle;
  Param.Param := SQL;
  RunAndWait;
  row := Param.row;
  FCurrentSet := Param.ResultSet;
  Result := Param.BoolResult;
end;

function TMLiteDB.FetchRowW(Handle: THandle; var row: TResultRow): Boolean;
begin
  Param.ResultSet := FCurrentSet;
  Param.Command := lcFetchRowW;
  Param.Handle := Handle;
  Param.ParamW := SQL;
  RunAndWait;
  row := param.row;
  FCurrentSet := Param.ResultSet;
  Result := Param.BoolResult;
end;

procedure TMLiteDB.FreeResult(Handle: THandle);
begin
  Param.ResultSet := FCurrentSet;
  Param.Command := lcFreeResult;
  Param.Handle := Handle;
  RunAndWait;
  //trick our instance
  //to switch back to default result set
  FResultSet := '';
  UseResultSet ('default');
end;

function TMLiteDB.Query(SQL: String): Boolean;
begin
  //note that with Query and related methods
  //the thread will use the result set of this instance
  FCurrentSet.Clear;
  Param.ResultSet := FCurrentSet;
  Param.Command := lcQuery;
  Param.Param := SQL;
  RunAndWait;
  Result := Param.BoolResult;
end;

function TMLiteDB.QueryW(SQL: WideString): Boolean;
begin
  FCurrentSet.Clear;
  Param.ResultSet := FCurrentSet;
  Param.Command := lcQueryW;
  Param.ParamW := SQL;
  RunAndWait;
  Result := Param.BoolResult;
end;

procedure TMLiteDB.RunandWait;
begin
  if SqliteDBThread.Terminated then
    //ouch.. but better exit than endless loop
    exit;
  SqliteDBThread.SleepTime := 0;
  SqliteDBThread.Param := Param;
  SqliteDBThread.CommandReady := False;
  SqliteDBThread.CommandStarted := True;
  while not SqliteDBThread.CommandReady do
    sleep (0);
  Param := SqliteDBThread.Param;
  SqliteDBThread.SleepTime := 10;
end;

function TMLiteDB.Use(Database: String): Boolean;
begin
  Param.ResultSet := FCurrentSet;
  Param.Command := lcUse;
  Param.Param := Database;
  RunAndWait;
end;

{ TSqliteDBThread }

procedure TSqliteDBThread.Execute;
begin
  //
  db := TLiteDB.Create(nil);
  //load dll
  db.Active := True;
  while not Terminated do
    begin
      if not CommandStarted then
        Sleep(SleepTime)
      else
        begin
          CommandStarted := False;
          case Param.Command of
            lcNone:
              begin
                //we've been fooled
              end;
            lcUse:
              begin
                Param.BoolResult := db.Use(Param.Param);
              end;
            lcQuery:
              begin
                db.UseResultSet(Param.ResultSet);
                Param.BoolResult := db.Query (Param.Param);
              end;
            lcExecute:
              begin
                param.Handle := db.Execute(Param.Param);
                param.ResultSet := db.CurrentResult;
              end;
            lcExecuteW:
              begin
                param.Handle := db.ExecuteW(Param.ParamW);
                param.ResultSet := db.CurrentResult;
              end;
            lcFetchRow:
              begin
                param.BoolResult := db.FetchRow(param.Handle, param.row);
                param.ResultSet := db.CurrentResult;
              end;
            lcFetchRowW:
              begin
                param.BoolResult := db.FetchRowW(param.Handle, param.row);
                param.ResultSet := db.CurrentResult;
              end;
            lcFreeResult:
              begin
                db.FreeResult(param.Handle);
              end;
          end;

          CommandReady := True;
        end;
    end;
  db.Free;
end;

end.

