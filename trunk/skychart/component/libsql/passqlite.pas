unit passqlite;

{$IFDEF FPC}
{$MODE Delphi}
{$H+}
{$ENDIF}

{$IFDEF darwin}
{$DEFINE LINUX}
{$ENDIF}

{$IFNDEF LINUX}
{$DEFINE WIN32}
{$ELSE}
{$DEFINE UNIX}
{$ENDIF}

{
 februari 17. 2004
 porting for the merge between TMyDB and TLiteDB which i was planning for so long.


}
{july 22. 2003
 taken from the sqlite.pas unit from next listed autors
 adjusted by R.M. Tegel (rene@dubaron.com)
 to match my ideas about easy querying
 partly based on ideas i had when developing TMyDB.pas library for MySQL
 (http://kylix.dubaron.com)
 future version might combine sqlite/mysql functionality

 also adjusted to handle multi-threaded access to same DB
 }

interface

uses
  {$IFDEF FPC}LCLIntf, {$ENDIF}
    {$IFDEF WIN32}Windows, {$ENDIF}
    Classes, SysUtils, SyncObjs,
    libsqlite,
    libsqlite3,
    utf8util,
    passql,
    sqlsupport;

type
  TSQLiteExecCallback = function(Sender: TObject; Columns: Integer; ColumnValues: Pointer; ColumnNames: Pointer): integer of object; cdecl;
  TSQLiteBusyCallback = function(Sender: TObject; ObjectName: PChar; BusyCount: integer): integer of object; cdecl;
  TOnData = Procedure(Sender: TObject; Columns: Integer; ColumnNames, ColumnValues: String) of object;
  TOnBusy = Procedure(Sender: TObject; ObjectName: String; BusyCount: integer; var Cancel: Boolean) of object;
  TOnQueryComplete = Procedure(Sender: TObject) of object;

type
  TBaseInfo = class (TObject)
    CS:TCriticalSection;
    ReferenceCount:Integer;
    FHandle:Pointer;
    constructor Create;
    destructor  Destroy; override;
  end;

  //Auto will try dual checking
  //when existing database is openened
  //and on dll loading.
  //it'll just try to load both.
  TSQLiteVersion = (svAuto, sv2 {v2_1..v2_8}, sv3{v3_0});

  TLiteDB = class (TSQLDB)
  private
    FPort: Integer;
    FUser: String;
    FHost: String;
    FPass: String;
    procedure SetSQLiteVersion(const Value: TSQLiteVersion);

    //try to avoid code mess (by making more mess ;)
    function Execute2 (SQL: String): THandle;
    function ExecuteW2 (SQL: WideString): THandle;
    function Execute3 (SQL: String): THandle;
    function ExecuteW3 (SQL: WideString): THandle;
    function FetchRow2 (Handle: THandle; var row: TResultRow): Boolean;
    function FetchRowW2 (Handle: THandle; var row: TResultRow): Boolean;
    function FetchRow3 (Handle: THandle; var row: TResultRow): Boolean;
    function FetchRowW3 (Handle: THandle; var row: TResultRow): Boolean;
    procedure FreeResult2 (Handle: THandle);
    procedure FreeResult3 (Handle: THandle);


  protected
    FBaseInfo:TBaseInfo; //keep track of open databases for thread-safety
    Fsv: TSQLiteVersion;
    procedure FillDBInfo; override;
    procedure StoreFields3 (Fields: TStrings; Stmt: Pointer);
    procedure StoreRow3 (row: TResultRow; Stmt: Pointer; Wide: Boolean; var QS: Integer);
  public
    procedure Lock; override;
    procedure Unlock; override;

    function Query (SQL:String):Boolean; override;
    function QueryW (SQL:WideString):Boolean; override;

    function Execute (SQL: String): THandle; override;
    function ExecuteW (SQL: WideString): THandle; override;

    function FetchRow (Handle: THandle; var row: TResultRow): Boolean; override;
    function FetchRowW (Handle: THandle; var row: TResultRow): Boolean; override;

    procedure FreeResult (Handle: THandle); override;

    function Use (Database:String):Boolean; override;
    procedure SetDataBase (Database:String); override;
    function Connect (Host, User, Pass:String; DataBase:String=''):Boolean; override;
    procedure Close; override;
    procedure StartTransaction; override;
    procedure Commit; override;
    procedure Rollback; override;
    function GetErrorMessage:String; override;
    function GetErrorMessageW:WideString; overload;

    //support functions:
    function ExplainTable (Table:String): Boolean; override;
    function ShowCreateTable (Table:String): Boolean; override;
    function DumpTable (Table:String): Boolean; override;
    function DumpDatabase (Table:String): Boolean; override;
    function ShowTables: Boolean; override;
    function Vacuum: Boolean; override;
    constructor Create (AOwner:TComponent; DataBase:String=''); reintroduce; overload;
    destructor  Destroy; override;
  published
    //hide these properties by making them read-only
    property Host:String read FHost;
    property Port:Integer read FPort;
    property User:String read FUser;
    property Password:String read FPass;
    property SQLiteVersion: TSQLiteVersion read Fsv write SetSQLiteVersion;
  end;


implementation

var DataBases:TStringList; //filled with DB names and appropiate critical sections
    CSConnect:TCriticalSection;

{
function TSQLite.Cancel: boolean;
begin
  Result := False;
  if fBusy and fIsOpen then
  begin
    SQLite_Cancel(fSQLite);
    fBusy := false;
    Result := True;
  end;
end;
}
{
procedure TSQLite.SetBusyTimeout(Timeout: Integer);
begin
  fBusyTimeout := Timeout;
  if fIsOpen then
  begin
    SQLite_BusyTimeout(fSQLite, fBusyTimeout);
    if fBusyTimeout > 0 then
      SQLite_BusyHandler(fSQLite, @BusyCallback, Self)
    else
      SQLite_BusyHandler(fSQLite, nil, nil);
  end;
end;
}

{
function TSQLite.DatabaseDetails(Table: TStrings): boolean;
begin
  Result := Query('SELECT * FROM SQLITE_MASTER;', Table);
end;
}

{ TBaseInfo }
//keeps track of openened sqlite databases.

constructor TBaseInfo.Create;
begin
  inherited Create;
  CS := TCriticalSection.Create;
end;

destructor TBaseInfo.Destroy;
begin
  CS.Free;
  inherited Destroy;
end;

function QueryCallback(Sender: TObject; Columns: Integer; ColumnValues: Pointer; ColumnNames: Pointer): integer; cdecl;
var S:TResultRow;
    FieldName, Value:^PChar;
    i,j:Integer;
begin
  //nice, we got a row. get it.
  with Sender as TLiteDB do
    with FCurrentSet do
      begin
        inc (FRowCount);
        if FCallBackOnly then
          i:=1
        else
          i:=FRowCount;
        if i<=FRowList.Count then
          begin
            S := TResultRow(FRowList[i - 1]);
            S.Clear;
            S.FNulls.Clear;
          end
        else
          begin
            S := TResultRow.Create;
            S.FFields := FFields; //copy pointer to ffields array
            FRowList.Add(S);
          end;
        if Columns > 0 then
          begin
            FieldName := ColumnNames;
            Value := ColumnValues;
            for i := 0 to Columns - 1 do
              begin
                S.Add(Value^);
                S.FNulls.Add(Pointer(Integer(Value^=nil)));
                inc (FQuerySize, length(String(Value^)));
                inc(Value);
              end;
            if FFields.Count = 0 then //do only once per query
              for i := 0 to Columns - 1 do
                begin
                  j:=FFields.AddObject(FieldName^, TFieldDesc.Create);
                  with TFieldDesc (FFields.Objects [j]) do
                    begin
                      name := FieldName^;
  //                    table := '';
                      // etc.
                      //newer versions of sqlite contain more metainfo in next fields
                      //0..n, n+1..2n etc.
                      //todo...
                    end;
                  inc(FieldName);
                end;
            if Assigned (FOnFetchRow) then
              try
                FOnFetchRow (Sender, S);
              except end;
          end;
        //Ready for next row? 0=OK, so this looks a bit weird:
        QueryCallBack := Integer ((not FCallBackOnly) and (FQuerySize>FFetchMemoryLimit)); //return 0 if ok for next row
      end;
end;

function QueryCallback3(Sender: TObject; Stmt: Pointer; Wide: Boolean): Integer;
var S:TResultRow;
    i: Integer;
begin
  //nice, we got a row. get it.
  with Sender as TLiteDB do
    with FCurrentSet do
      begin
        inc (FRowCount);
        if FCallBackOnly then
          i:=1
        else
          i:=FRowCount;
        if i<=FRowList.Count then
          begin
            S := TResultRow(FRowList[i - 1]);
            S.Clear;
            //S.FNulls.Clear;
          end
        else
          begin
            S := TResultRow.Create;
            S.FFields := FFields; //copy pointer to ffields array
            FRowList.Add(S);
          end;

        StoreRow3 (S, stmt, Wide, FQuerySize);

        if FFields.Count = 0 then //do only once per query
          StoreFields3(FFields, Stmt);

        if Assigned (FOnFetchRow) then
          try
            FOnFetchRow (Sender, S);
          except end;

        //Ready for next row? 0=OK, so this looks a bit weird:
        QueryCallBack3 := Integer ((not FCallBackOnly) and (FQuerySize>FFetchMemoryLimit)); //return 0 if ok for next row
      end;
end;


function QueryBusyCallback(Sender: TObject; ObjectName: PChar; BusyCount: integer): integer; cdecl;
begin
(*  with TLiteDB(Sender) do
    begin
      if FThreaded then
        sleep(1)
      else
        begin
          {$IFDEF WITH_GUI}
          Application.ProcessMessages;
          {$ENDIF}
          sleep(0);
        end;
    end;
  *)
  sleep (2);  
  Result := -1;
end;


constructor TLiteDB.Create(AOwner: TComponent; Database: String);
begin
  inherited Create(AOwner);
  PrimaryKey := 'primary key';
  FDataBaseType := dbSqlite;
  if DataBase<>'' then
    Use (DataBase);
end;

destructor TLiteDB.Destroy;
begin
  Use ('');
  inherited;
end;

function TLiteDB.Query(SQL: String): Boolean;
var P,Q:PChar;
    i:Integer;
begin
  Result := False;
  with FCurrentSet do
    begin
      FHasResult := False;
      if not DllLoaded or
         (FBaseInfo = nil) then
        begin
          FLastErrorText := 'Failed to load dll library';
          if Assigned (OnError) then
            OnError (Self);
          exit;
        end;
      Clear;

      FSQL:=SQL;
      if Assigned (OnBeforeQuery) then
        OnBeforeQuery(Self, FSQL);
      SQL:=FSQL;

      FBaseInfo.CS.Enter;
      if Assigned (FBaseInfo.FHandle) then
        begin
          case Fsv of
            sv2:
              begin
                SQLite_BusyTimeout(FBaseInfo.FHandle, 2);
                SQLite_BusyHandler(FBaseInfo.FHandle, @QueryBusyCallback, Self);
              end;
            sv3:
              begin
                SQLite3_BusyTimeout(FBaseInfo.FHandle, 2);
                SQLite3_BusyHandler(FBaseInfo.FHandle, @QueryBusyCallback, Self);
              end;
          end;
        end;
      FQuerySize := 0;
      if SQL<>'' then  //calling with empty string causes a result cleanup.
        begin
          case Fsv of
            sv2:
              begin
                FLastError := SQLite_exec (FBaseInfo.FHandle, PChar(SQL), @QueryCallBack, Self, P);
                FLastErrorText := StrPas (P);
                SQLite_freemem(P);
              end;
            sv3:
              begin
                FLastError := SQLite3_exec (FBaseInfo.FHandle, PChar(SQL), @QueryCallBack, Self, Q);
                if FLastError<>0 then
                  FLastErrorText := SQLite3_errormsg (FBaseInfo.FHandle)
                else
                  FLastErrorText := '';
              end;
          end;

        end;
      i:=FRowList.Count - 1;
      if not FCallBackOnly then //we need to clean up
        begin
          while i>=FRowCount do
            begin
              TResultRow(FRowList[i]).Free;
              FRowList.Delete(i);
              dec(i);
            end;
        end;
      case Fsv of
        sv2:
          begin
            FRowsAffected := SQLite_Changes(FBaseInfo.FHandle);
            //we need to do this here (multi-threaded!):
            FLastInsertID := SQLite_lastinsertrow(FBaseInfo.FHandle);
          end;
        sv3:
          begin
            FRowsAffected := SQLite3_Changes(FBaseInfo.FHandle);
            //we need to do this here (multi-threaded!):
            FLastInsertID := SQLite3_lastinsertrowid(FBaseInfo.FHandle);
          end;
      end;

      FBaseInfo.CS.Leave;
      FColCount := FFields.Count;
      Result := (FLastError = sqlite_ok);
      FHasResult := Result;
      if FHasResult then
        begin
          if Assigned (FOnQueryComplete) then
            try
              FOnQueryComplete(Self);
            except end;
          if Assigned (FOnSuccess) then
            try
              FOnSuccess(Self);
            except end;
        end
      else
        begin
          if Assigned (FOnError) then
            try
              FOnError(Self);
            except end;
        end;
  end;
end;

function TLiteDB.QueryW(SQL: WideString): Boolean;
var S, Q: Pointer;
    i: Integer;
    sr,qr: Integer;
begin
  if Fsv<>sv3 then //not sqlite version 3?
    begin //normal query
      Result := Query (EncodeUTF8(SQL));
      exit;
    end;
  Result := False;
  with FCurrentSet do
    begin
      FHasResult := False;
      if not DllLoaded or
         (FBaseInfo = nil) then
        begin
          FLastErrorText := 'Failed to load dll library';
          if Assigned (OnError) then
            OnError (Self);
          exit;
        end;
      Clear;

      if Assigned (OnBeforeQuery) then
        begin
          FSQL:=EncodeUTF8(SQL);
          OnBeforeQuery(Self, FSQL);
          SQL:=DecodeUTF8(FSQL);
        end;

      FBaseInfo.CS.Enter;
      if Assigned (FBaseInfo.FHandle) then
        begin
          SQLite3_BusyTimeout(FBaseInfo.FHandle, 2);
          SQLite3_BusyHandler(FBaseInfo.FHandle, @QueryBusyCallback, Self);
        end;
      FQuerySize := 0;
      if SQL<>'' then  //calling with empty string causes a result cleanup.
        begin
          //FLastError := SQLite3_exec (FBaseInfo.FHandle, PChar(SQL), @QueryCallBack, Self, P)
          //We run 16-bit sqlite functions ourselves here
          FLastError := SQLite3_prepare16(FBaseInfo.FHandle, PWChar(SQL), length (SQL) * 2, S, Q);
          if FLastError = SQLite_OK then
            begin //Query ok, go fetch the results
              sr := SQLite3_step (S);
              //todo: check status of sr now
              //it can be one of the following:
              //SQLITE_BUSY, SQLITE_DONE, SQLITE_ROW, SQLITE_ERROR, SQLITE_MISUSE
              //especially sqlite_busy is interesting (since rest are errors)
              while sr=SQLITE_ROW do
                begin
                  //callback our fetcher method
                  //QueryCallback(Sender: TObject; Columns: Integer; ColumnValues: Pointer; ColumnNames: Pointer): integer;
                  qr := QueryCallBack3 (Self, S, True);
                  if qr<>0 then
                    break;
                  sr := SQLite3_step(S);
                end;
              if sr<>SQLITE_DONE then
                begin
                  FLastErrorText := SQLite3_errormsg (FBaseInfo.FHandle);
                  FLastError := sr;
                end
              else
                begin
                  FLastErrorText := '';
                  FLastError := 0;
                end;
              //done with the query:
              SQLite3_finalize(S);
              //          SQLite3_reset(S); //the docs are misleading. finalize just freed it. pick either finalize or result.
            end
          else
            FLastErrorText := SQLite3_errormsg (FBaseInfo.FHandle);

        end;

      i:=FRowList.Count - 1;
      if not FCallBackOnly then //we need to clean up
        begin
          while i>=FRowCount do
            begin
              TResultRow(FRowList[i]).Free;
              FRowList.Delete(i);
              dec(i);
            end;
        end;
      FRowsAffected := SQLite3_Changes(FBaseInfo.FHandle);
      //we need to do this here (multi-threaded!):
      FLastInsertID := SQLite3_lastinsertrowid(FBaseInfo.FHandle);

      FBaseInfo.CS.Leave;
      FColCount := FFields.Count;
      Result := (FLastError = sqlite_ok);
      FHasResult := Result;
      if FHasResult then
        begin
          if Assigned (FOnQueryComplete) then
            try
              FOnQueryComplete(Self);
            except end;
          if Assigned (FOnSuccess) then
            try
              FOnSuccess(Self);
            except end;
        end
      else
        begin
          if Assigned (FOnError) then
            try
              FOnError(Self);
            except end;
        end;
  end;
end;


function TLiteDB.Use (Database: String): Boolean;
var B:TBaseInfo;
    i:Integer;
    P:PChar;
    FS: TFileStream;
    Header: String;

begin
  Result := False;
  FActive := False;

  //make full path of database:
  if (DataBase<>'') and
     ('' = ExtractFilePath (DataBase)) then
    //add file path to database
    DataBase := ExtractFilePath (ParamStr(0){Application.ExeName is in Forms unit :( }) + DataBase;

  //if database already exists, force library to correct version:
  if Database <> '' then
    begin
      //load libraries
      if Fsv = svAuto then
        begin
          //first see if file exists. if so, load appropiate library.
          if FileExists (Database) then
            begin
              //Read first part of file.
              //scan for appropiate string.
              try
                FS := TFileStream.Create(Database, fmOpenRead or fmShareDenyNone);
                SetLength (Header, 48);
                FS.Read (Header[1], Length(Header));
                GetDBInfo(Database).Size := FS.Size;
                FS.Free;
              except end;
              if (pos ('**', Header)=1) and
                 (pos ('SQLite 2.1 database', Header)>1) then
                Fsv := sv2
              else
              if (pos ('SQLite', Header)>0) and
                 (pos ('3', Header)>1) then
                Fsv := sv3;
            end;
        end;


      //still auto (new database)? try loading sqlite 3 first.
      if Fsv = svAuto then
        begin
          FDllLoaded := LoadLibSqlite3 (FLibraryPath);
          if FDllLoaded then
            Fsv := sv3
          else
            begin
              FDllLoaded := LoadLibSqlite2 (FLibraryPath);
              if FDllLoaded then
                Fsv := sv2;
            end;
        end
      else //manual control
        if Fsv = sv3 then
          FDllLoaded := LoadLibSqlite3 (FLibraryPath)
        else
        if Fsv = sv2 then
          FDllLoaded := LoadLibSqlite2 (FLibraryPath);
      if not FDllLoaded then
        begin
    //      FLastErrorMessage := 'Failed to load DLL library';
          exit;
        end;
    end;

  CSConnect.Enter;
  if FDataBase<>'' then //unregister previous loaded
    begin
      i:=DataBases.IndexOf (FDataBase);
      if i>=0 then //should always be!
        with TBaseInfo (DataBases.Objects [i]) do
          begin
            dec (ReferenceCount);
            if ReferenceCount=0 then
              begin
                //close handle
                if SQLiteVersion = sv2 then
                  SQLite_close (FHandle)
                else
                  SQLite3_close (FHandle);

                Free;
                DataBases.Delete(i);
              end;
          end;
      if Assigned(FOnClose) then FOnClose(Self);          
    end;

  if (Database<>'') and (DataBases.IndexOf(DataBase)<0) then
    begin
      B := TBaseInfo.Create;
      DataBases.AddObject(DataBase, B);
      inc (B.ReferenceCount);
      case Fsv of
        sv2: B.FHandle := SQLite_open(PChar (DataBase), 1, P);
        sv3:
          begin
            if FUniCode then
              SQLite3_open16(PWChar (DecodeUTF8(DataBase)), B.FHandle)
            else
              SQLite3_open(PChar (DataBase), B.FHandle);
          end;
      end;
      if Assigned (B.FHandle) then
        begin
          if SQLiteVersion = sv2 then
            begin
              FVersion := SQLite_version;
              FEncoding := SQLite_encoding;
            end
          else
            begin
              FVersion := SQLite3_LibVersion;
              if FUnicode then
                FEncoding := 'Unicode'
              else
                FEncoding := 'UTF-8';
            end;
          FActive := True;
          Result := True;
        end
      else
        begin
          FCurrentSet.FLastErrorText := P;
          B.Free;
          B := nil;
          Databases.Delete (Databases.IndexOf (Database));
        end;
      FBaseInfo := B;
    end
  else
    begin
      FActive := (Database<>'');
      Result := FActive;
      if Result then
        begin
          FBaseInfo := TBaseInfo(DataBases.Objects[DataBases.IndexOf(DataBase)]);
          inc (FBaseInfo.ReferenceCount);
        end
      else
        FBaseInfo := nil;
    end;
  FDataBase := DataBase;
  CSConnect.Leave;
  if FActive then
    begin
      FillDBInfo;
      if FActive and Assigned(FOnOpen) then
        FOnOpen(Self);
    end;
end;


function TLiteDB.GetErrorMessageW: WideString;
var P: PChar;
begin
  Result := '';
  if FCurrentSet.FLastError = 0 then
    exit;
  if Assigned (FBaseInfo) then
    case Fsv of
      sv2:
        begin
          P := sqlite_errorstring (FCurrentSet.FLastError);
          Result := P;
          //sqlite_freemem (P);
        end;
      sv3:
        begin
          if FUniCode then
            Result := sqlite3_errormsg16 (FBaseInfo.FHandle)
          else
            Result := sqlite3_errormsg (FBaseInfo.FHandle);
        end;
    end;
end;

function TLiteDB.GetErrorMessage: String;
begin
  Result := GetErrorMessageW;
end;


procedure TLiteDB.Lock;
begin
  if Assigned (FBaseInfo) then
    FBaseInfo.CS.Enter;
end;

procedure TLiteDB.UnLock;
begin
  if Assigned (FBaseInfo) then
    FBaseInfo.CS.Leave;
end;

procedure TLiteDB.StartTransaction;
begin
   if Assigned (FBaseInfo) then
     begin
       //Lock;
       Query ('BEGIN'); //start transaction
     end;
end;

procedure TLiteDB.Commit;
begin
  if Assigned (FBaseInfo) then
    begin
      Query ('COMMIT');
      //Unlock;
    end;
end;

procedure TLiteDB.Rollback;
begin
  if Assigned (FBaseInfo) then
    begin
      Query ('ROLLBACK');
      //Unlock;
    end;
end;


procedure TLiteDB.Close;
begin
  Use ('');
end;

function TLiteDB.Connect(Host, User, Pass, DataBase: String): Boolean;
begin
  if DataBase<>'' then
    Result := Use (DataBase)
  else
    Result := False;
end;

procedure TLiteDB.SetDataBase(Database: String);
begin
  if csDesigning in ComponentState then //nice,
    //but in this case you are force to set active property.
    //Runtime, setting active is not needed.
    //There is also a reason for that
    //You want to be able to avoid change it to full path
    //at design time
    FDataBase := DataBase
  else
    Use (DataBase);
end;

function TLiteDB.DumpDatabase(Table: String): Boolean;
begin
  Result := False;
end;

function TLiteDB.DumpTable(Table: String): Boolean;
begin
  Result := False;
end;

function TLiteDB.ExplainTable(Table: String): Boolean;
begin
  Result := False;
end;

function TLiteDB.ShowCreateTable(Table: String): Boolean;
begin
  Result := False;
end;

procedure TLiteDB.SetSQLiteVersion(const Value: TSQLiteVersion);
begin
//  FSQLiteVersion := Value;
  Fsv := Value; //shorthand.
end;

function TLiteDB.ShowTables: Boolean;
begin
  Result := Query ('SELECT name FROM sqlite_master WHERE type=''table'' ORDER BY name');
end;

function TLiteDB.Vacuum: Boolean;
begin
  Result := Query ('VACUUM');
end;

function TLiteDB.Execute(SQL: String): THandle;
begin
  case Fsv of
    sv2: Result := Execute2 (SQL);
    sv3: Result := Execute3 (SQL);
  else
    Result := 0;
  end;
end;

function TLiteDB.ExecuteW(SQL: WideString): THandle;
begin
  case Fsv of
    sv2: Result := ExecuteW2 (SQL);
    sv3: Result := ExecuteW3 (SQL);
  else
    Result := 0;
  end;
end;

function TLiteDB.FetchRow(Handle: THandle; var row: TResultRow): Boolean;
begin
  case Fsv of
    sv2: Result := FetchRow2 (Handle, row);
    sv3: Result := FetchRow3 (Handle, row);
  else
    begin
      Result := False;
      row := FCurrentSet.FNilRow;
    end;
  end;
end;

function TLiteDB.FetchRowW(Handle: THandle; var row: TResultRow): Boolean;
begin
  case Fsv of
    sv2: Result := FetchRowW2 (Handle, row);
    sv3: Result := FetchRowW3 (Handle, row);
  else
    begin
      Result := False;
      row := FCurrentSet.FNilRow;
    end;
  end;
end;

procedure TLiteDB.FreeResult(Handle: THandle);
begin
  //FreeAndNil (FCurrentRow);
  case Fsv of
    sv2: FreeResult2 (Handle);
    sv3: FreeResult3 (Handle);
  end;
end;

procedure TLiteDB.FillDBInfo;
begin
  inherited; //clears tables and indexes
  //Miha:
  //get tables list
  if Query('SELECT name FROM sqlite_master WHERE type=''table'' ORDER BY name') then
    Tables := GetColumnAsStrings;
  //get indexes list
  if Query('SELECT name FROM sqlite_master WHERE type=''index'' ORDER BY name') then
    Indexes := GetColumnAsStrings;
end;

function TLiteDB.Execute2(SQL: String): THandle;
var Tail, ErrMsg: PChar;
    VM: Pointer;
    res: Integer;
begin
  Result := 0;
  if (not FDLLLoaded) or (FBaseInfo = nil) then
    exit;
  //with FCurrentSet do
    begin
      Clear;
      VM := nil;
      Tail := nil;
      ErrMsg := nil;
      res := sqlite_compile (FBaseInfo.FHandle, PChar(SQL), Tail, VM, ErrMsg);
      if res=0 then
        UseResultSet (Integer(VM))
      else
        UseResultSet ('default');
      with FCurrentSet do
        begin
          Clear;
          FLastError := res;
          FLastErrorText := ErrMsg;
          if Assigned (ErrMsg) then
            sqlite_freemem(ErrMsg);
          if res=0 then
            Result := Integer(VM)
          else
            begin
              Result := 0;
              //Vm is not supposed to be declared, no need to free anything.
            end;
        end;
    end;
end;

function TLiteDB.ExecuteW2(SQL: WideString): THandle;
begin
  Result := Execute2 (EncodeUTF8(SQL));
end;

function TLiteDB.Execute3(SQL: String): THandle;
var Tail: Pointer;
    VM: Pointer;
    res: Integer;
begin
  Result := 0;
  if (not FDLLLoaded) or (FBaseInfo = nil) then
    exit;
  //with FCurrentSet do
    begin
      Clear;
      VM := nil;
      Tail := nil;
      //res := sqlite_compile (FBaseInfo.FHandle, PChar(SQL), Tail, VM, ErrMsg);
      res := sqlite3_prepare (FBaseInfo.FHandle, PChar(SQL), Length(SQL), VM, Tail);
      if res=0 then
        UseResultSet (Integer(VM))
      else
        UseResultSet ('default');
      with FCurrentSet do
        begin
          Clear;
          FLastError := res;
          FLastErrorText := SQLite3_ErrorMsg (FBaseInfo.FHandle);
          if res=0 then
            begin
              Result := Integer(VM);
              StoreFields3(FCurrentSet.FFields, VM);
            end
          else
            begin
              Result := 0;
              //Vm is not supposed to be declared, no need to free anything.
            end;
        end;
    end;
end;

function TLiteDB.ExecuteW3(SQL: WideString): THandle;
var Tail: Pointer;
    VM: Pointer;
    res: Integer;
begin
  Result := 0;
  if (not FDLLLoaded) or (FBaseInfo = nil) then
    exit;
  //with FCurrentSet do
    begin
      Clear;
      VM := nil;
      Tail := nil;
      //res := sqlite_compile (FBaseInfo.FHandle, PChar(SQL), Tail, VM, ErrMsg);
      res := sqlite3_prepare16 (FBaseInfo.FHandle, PWChar(SQL), Length(SQL), VM, Tail);
      if res=0 then
        UseResultSet (Integer(VM))
      else
        UseResultSet (0);
      with FCurrentSet do
        begin
          Clear;
          FLastError := res;
          FLastErrorText := SQLite3_ErrorMsg16 (FBaseInfo.FHandle);
          if res=0 then
            begin
              Result := Integer(VM);
              StoreFields3(FCurrentSet.FFields, VM);
            end
          else
            begin
              Result := 0;
              //Vm is not supposed to be declared, no need to free anything.
            end;
        end;
    end;
end;

function TLiteDB.FetchRow2(Handle: THandle; var row: TResultRow): Boolean;
var N: Integer;
    Values: ^PChar;
    Names: ^PChar;
    i,j: Integer;
begin
//take care on queries that modify the database
(* It is acceptable to call sqlite_finalize on a virtual machine
   before sqlite_step has returned SQLITE_DONE.
   Doing so has the effect of interrupting the operation in progress.
   Partially completed changes will be rolled back and
   the database will be restored to its original state
   (unless an alternative recovery algorithm is selected
   using an ON CONFLICT clause in the SQL being executed.)
   The effect is the same as if a callback function of
   sqlite_exec had returned non-zero.
*)
  UseResultSet (Handle);
  row := FCurrentSet.FCurrentRow;
  row.Clear;
  FCurrentSet.FLastError := sqlite_step (Pointer(Handle), N, Pointer(Values), Pointer(Names));
  if FCurrentSet.FLastError = SQLITE_ROW then
    begin
      Result := True;
      for i:=0 to N-1 do
        begin
          row.Add(Values^);
          row.FNulls.Add(Pointer(Integer(Pointer(Values^)<>nil)));
          j:=row.FFields.AddObject(Names^, TFieldDesc.Create);
          with TFieldDesc (row.FFields.Objects [j]) do
            begin
              name := Names^;
            end;
         inc (Names);
         inc (Values);
        end;
    end
  else
    begin
      row := FCurrentSet.FNilRow;
      Result := False;
    end;
end;

function TLiteDB.FetchRowW2(Handle: THandle; var row: TResultRow): Boolean;
begin
  //not really satisfyable...
  Result := FetchRow2 (Handle, row);
end;

function TLiteDB.FetchRow3(Handle: THandle; var row: TResultRow): Boolean;
var i: Integer;
begin
  UseResultSet (Handle);
  row := FCurrentSet.FCurrentRow;
  row.Clear;
  FCurrentSet.FLastError := sqlite3_step (Pointer(Handle)); //, N, Pointer(Values), Pointer(Names));
  if FCurrentSet.FLastError = SQLITE_ROW then
    begin
      Result := True;
      StoreRow3 (row, Pointer(Handle), False, i);
     end
  else
    begin
      row := FCurrentSet.FNilRow;
      Result := False;
    end;
end;

function TLiteDB.FetchRowW3(Handle: THandle; var row: TResultRow): Boolean;
var i: Integer;
begin
  UseResultSet (Handle);
  row := FCurrentSet.FCurrentRow;
  row.Clear;
  FCurrentSet.FLastError := sqlite3_step (Pointer(Handle)); //, N, Pointer(Values), Pointer(Names));
  if FCurrentSet.FLastError = SQLITE_ROW then
    begin
      Result := True;
      //QueryCallback3 (Self, Pointer(Handle), True);
      StoreRow3 (row, Pointer(Handle), True, i);
     end
  else
    begin
      row := FCurrentSet.FNilRow;
      Result := False;
    end;
end;

procedure TLiteDB.FreeResult2(Handle: THandle);
var Err: PChar;
begin
  if Handle <> 0 then
    begin
      FCurrentSet.FLastError := sqlite_finalize (Pointer(Handle), Err);
      DeleteResultSet (Handle);
      //FCurrentSet.FLastErrorText := Err;
      if Assigned (Err) then
        sqlite_freemem (Err);
    end;
end;

procedure TLiteDB.FreeResult3(Handle: THandle);
begin
  if Handle <> 0 then
    begin
      FCurrentSet.FLastError := sqlite3_finalize (Pointer(Handle));
      DeleteResultSet (Handle);
    end;
end;

procedure FreeDatabases;
var i: Integer;
begin
  for i:=0 to DataBases.Count - 1 do
    TBaseInfo (DataBases.Objects[i]).Free;
end;

procedure TLiteDB.StoreFields3(Fields: TStrings; Stmt: Pointer);
var Columns,
    i,j : Integer;
begin
  Columns := SQLite3_Column_count(stmt);
  for i := 0 to Columns - 1 do
    begin
      j:=Fields.AddObject(Sqlite3_Column_Name(stmt, i), TFieldDesc.Create);
      with TFieldDesc (Fields.Objects [j]) do
        begin
          name := Sqlite3_Column_Name(stmt, i);
          _datatype := Sqlite3_Column_Type (stmt, i);
          case _datatype of
            SQLite_Integer: datatype := dtInteger;
            SQLite_Float:   datatype := dtFloat;
            SQLite_Text:    datatype := dtWideString; //WideString
            SQLite_Blob:    datatype := dtBlob; //string
            SQLite_Null:    datatype := dtNull;
          else
            datatype := dtUnknown; //should not happen
          end;
        end;
    end;
end;

procedure TLiteDB.StoreRow3(row: TResultRow; Stmt: Pointer; Wide: Boolean; var QS: Integer);
var
    Value: String; //^PChar;
    ValueW: WideString;
    i:Integer;
    Columns: Integer;
    ctype: Integer;
    blob: Pointer;
    bloblen: Integer;
begin
  Columns := SQLite3_Column_count(stmt);
  if Columns > 0 then
    begin
      for i := 0 to Columns - 1 do
        begin
          ctype := SQLite3_Column_Type(stmt, i);
          case ctype of
            SQLite_Integer,
            SQLite_Float,
            SQLite_Text:
              begin
                if Wide then
                  begin
                    ValueW := SQLite3_Column_Text16(stmt, i);
                    row.FNulls.Add(Pointer(0));
                    row.AddW(ValueW);  //addW also
                    inc (QS, length(ValueW) * SizeOf (WideChar));
                  end
                else
                  begin
                    Value := SQLite3_Column_Text(stmt, i);
                    row.FNulls.Add(Pointer(0));
                    row.Add (Value);
                    inc (QS, length(Value));
                  end;
              end;
            SQLite_Blob:
              begin
                //now this is really the tricky part..
                //we set addw to empty string
                //but add the blob.
                bloblen := Sqlite3_Column_bytes (stmt, i);
                SetLength (Value, bloblen);
                blob := SQLite3_Column_blob (stmt, i);
                move (blob^, Value[1], bloblen);
                row.Add (Value);
                row.FNulls.Add(Pointer(0));
                inc (QS, length(Value));
              end;
            SQLite_Null:
              begin
                row.AddW ('');
                row.FNulls.Add(Pointer(1));
              end;
          end; //case
        end;
    end;
end;

initialization
  DataBases := TStringList.Create;
  CSConnect := TCriticalSection.Create;

finalization
  FreeDatabases;
  DataBases.Free;
  CSConnect.Free;
end.


(* suggested support functions

//Additional sqlite-specific support functions by Dak
function TLiteDB.GetUserVersion(DataBase: string=''): integer;
var
  ResultPtr: Pointer;
  ResultStr: ^Pointer;
  RowCount, ColCount: Integer;
  ErrMsg: PChar;
  i: integer;
  intDataBase: string;
begin
  if Assigned(FBaseInfo.FHandle) then
  begin
    if DataBase<>'' then intDataBase := DataBase+'.' else intDataBase := '';
    SQLite3_GetTable(FBaseInfo.FHandle, PAnsiChar('PRAGMA '+intDataBase+'user_version'),
                     ResultPtr, RowCount, ColCount, ErrMsg);
    ResultStr := ResultPtr;
    Inc(ResultStr);
    Result := StrToInt(PAnsiChar(ResultStr^));
  end
  else
  begin
    Result := -1;
  end;
end;

//Additional sqlite-specific support functions by Dak
procedure TLiteDB.SetUserVersion(Version: integer; Database: string='');      //Dak..
var
  intDataBase: string;
begin
  if Assigned(FBaseInfo.FHandle) then
  begin
    if DataBase<>'' then intDataBase := DataBase+'.' else intDataBase := '';
    Query('PRAGMA '+intDataBase+'user_version='+IntToStr(Version));
  end;
end;

*)




