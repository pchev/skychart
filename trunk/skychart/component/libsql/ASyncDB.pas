unit ASyncDB;

//unit implementing a background thread.
//may be usefull for applications that want to do background logging.
//is not essential part of libsql.


interface

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

uses
  {$IFNDEF LINUX}
  Windows, //sleep function
  {$ENDIF}
  SysUtils, Classes,
  syncobjs,
  pasmysql, passqlite, pasODBC, pasjansql, passql,
  sqlsupport;

type
  //TDatabaseType = (dtSqlite, dtMySQL, dtODBC);
  TDBData = class
    SQL: String;
    Results: TResultSet;
    Handle: Integer;
    UserData: Integer;
  end;

  TDBThread = class;

  TOnDBData = procedure (Sender: TComponent; db: TSQLDB; Data: TDBData) of object;

  TASyncDB = class(TComponent)
  private
    { Private declarations }
    CS: TCriticalSection;
    Queue: TList;
    FHandleCount: Integer;
    FUser: String;
    FDatabase: String;
    FPass: String;
    FHost: String;
    FDBType: TDBMajorType;
    FActive: Boolean;
    FOnSuccess: TOnDBData;
    FOnFailure: TOnDBData;
    FMaxQueue: Integer;
    procedure SetDatabase(const Value: String);
    procedure SetDBType(const Value: TDBMajorType);
    procedure SetHost(const Value: String);
    procedure SetPass(const Value: String);
    procedure SetUser(const Value: String);
    procedure SetActive(const Value: Boolean);
    procedure SetOnFailure(const Value: TOnDBData);
    procedure SetOnSuccess(const Value: TOnDBData);
    procedure SetMaxQueue(const Value: Integer);
  protected
    { Protected declarations }
    FThread: TDBThread;
    db: TSqlDB; //used for format function
  public
    { Public declarations }

    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    function Query (SQL: String; UserData: Integer=0): Integer;
    function FormatQuery (SQL: String; const Args: array of const; UserData: Integer=0): Integer;
  published
    { Published declarations }
    property Active: Boolean read FActive write SetActive;
    property DBType: TDBMajorType read FDBType write SetDBType;
    property User: String read FUser write SetUser;
    property Pass: String read FPass write SetPass;
    property Host: String read FHost write SetHost;
    property Database: String read FDatabase write SetDatabase;
    property MaxQueue: Integer read FMaxQueue write SetMaxQueue;
    property OnSuccess: TOnDBData read FOnSuccess write SetOnSuccess;
    property OnFailure: TOnDBData read FOnFailure write SetOnFailure;
  end;

  TDBThread = class (TThread)
    Owner: TASyncDB;
    db: TSqlDB;
    error: String;
    data: TDBData;
    dbtype: TDBMajorType;
    procedure Execute; override;
    procedure SyncSuccess;
    procedure SyncFailure;
  { TASyncDB }
  end;

procedure Register;

implementation

//{ $R *.dcr}

constructor TASyncDB.Create(AOwner: TComponent);
begin
  inherited Create (AOwner);
  Queue := TList.Create;
  CS := TCriticalSection.Create;
  FMaxQueue := 8192; //some arbitrary value
  //needed for formatquery thingy.
  //db := TSqlDB.Create (Self);
end;

destructor TASyncDB.Destroy;
begin
  Active := False;
  CS.Free;
  Queue.Free;
  //db.Free;
  inherited Destroy;
end;

function TASyncDB.FormatQuery(SQL: String;
  const Args: array of const; UserData: Integer=0): Integer;
var s: String;
    w: WideString;
begin
  Result := -1;
  try
    if Assigned (FThread) and Assigned (FThread.db) then
      begin
        TSQLDB._FormatSql (s,w,SQL, Args, False, dbType);
        Result := Query (s, UserData);
      end;
  except end;
end;

function TASyncDB.Query(SQL: String; UserData: Integer=0): Integer;
var data: TDBData;
begin
  CS.Enter;
  if Queue.Count <= FMaxQueue then
    begin
      data := TDBData.Create;
      data.SQL := SQL;
      data.UserData := UserData;
      inc (FHandleCount);
      Result := FHandleCount;
      data.Handle := FHandleCount;
      Queue.Add (data);
    end
  else
    Result := -1;
  CS.Leave;
end;

procedure TASyncDB.SetActive(const Value: Boolean);
begin
  if FActive and not Value then
    begin
      FThread.Terminate;
      FThread.WaitFor;
      FThread.Free;
      FThread := nil;
    end;
  if not FActive and Value then
    begin
      FThread := TDBThread.Create (True);
      FThread.Owner := Self;
      FThread.Resume;
    end;
  FActive := Value;
end;

procedure TASyncDB.SetDatabase(const Value: String);
begin
  CS.Enter;
  FDatabase := Value;
  CS.Leave;
end;

procedure TASyncDB.SetDBType(const Value: TDBMajorType);
begin
  CS.Enter;
  FDBType := Value;
  CS.Leave;
end;

procedure TASyncDB.SetHost(const Value: String);
begin
  CS.Enter;
  FHost := Value;
  CS.Leave;
end;

procedure TASyncDB.SetMaxQueue(const Value: Integer);
begin
  FMaxQueue := Value;
end;

procedure TASyncDB.SetOnFailure(const Value: TOnDBData);
begin
  FOnFailure := Value;
end;

procedure TASyncDB.SetOnSuccess(const Value: TOnDBData);
begin
  FOnSuccess := Value;
end;

procedure TASyncDB.SetPass(const Value: String);
begin
  CS.Enter;
  FPass := Value;
  CS.Leave;
end;

procedure TASyncDB.SetUser(const Value: String);
begin
  CS.Enter;
  FUser := Value;
  CS.Leave;
end;

{ TDBThread }

procedure TDBThread.Execute;
var dbloaded: Boolean;
begin
  //launch appropiate db type
  //and perform queries
  dbloaded := False;
  Owner.CS.Enter;
  case Owner.FDBType of
    dbMySQL:
      begin
        db := TMyDB.Create (nil);
        dbloaded := db.Connect (Owner.FHost, Owner.FUser, Owner.FPass, Owner.FDatabase);
        dbtype := dbMySQL;
      end;
    dbSqlite:
      begin
        db := TLiteDB.Create (nil);
        dbloaded := db.Use (Owner.FDatabase);
        dbtype := dbSqlite;
      end;
    dbODBC:
      begin
        db := TODBCDB.Create (nil);
        dbloaded := db.Connect (Owner.FHost, Owner.FUser, Owner.FPass, Owner.FDatabase);
        dbtype := dbODBC;
      end;
    dbJanSQL:
      begin
        db := TJanDB.Create(nil);
        dbloaded := db.Connect (Owner.FHost, Owner.FUser, Owner.FPass, Owner.FDatabase);
        dbType := dbJanSQL;
      end;
  end;
  Owner.CS.Leave;

  if not dbloaded then
    begin
      Owner.CS.Enter;
      Owner.FActive := False;
      FreeOnTerminate := True;
      Owner.CS.Leave;
      Terminate;
    end;

  while not Terminated do
    begin
      //see if there is anything in queue
      //if so, process.
      data := nil;
      Owner.CS.Enter;
      if Owner.Queue.Count > 0 then
        begin
          data := Owner.Queue[0];
          Owner.Queue.Delete (0);
        end;
      Owner.CS.Leave;
      if Assigned (data) then
        begin
          db.Query (data.SQL);
          data.Results := db.CurrentResult;
          if db.LastError = 0 then
            SyncSuccess
          else
            SyncFailure;
        end
      else
        sleep (200);
    end;
end;

procedure TDBThread.SyncFailure;
begin
  try
    if Assigned (Owner.OnFailure) then
      Owner.OnFailure (Owner, db, data);
  except end;
end;

procedure TDBThread.SyncSuccess;
begin
  try
    if Assigned (Owner.OnSuccess) then
      Owner.OnSuccess (Owner, db, data);
  except end;
end;

procedure Register;
begin
  RegisterComponents('libsql', [TASyncDB]);
end;

end.
