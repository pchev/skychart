unit pasodbc;

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

//ODBC-32 interface for libsql
//2005 R.M. Tegel
//Modified Artistic License


interface
uses
     {$IFDEF MSWINDOWS}
     Windows,
     {$ENDIF}
     Classes, SysUtils,
     libodbc32,
     passql,
     sqlsupport;


type
    TPromptType = (
      pt_NOPROMPT,
      pt_DRIVER_COMPLETE,
      pt_DRIVER_PROMPT,
      pt_DRIVER_COMPLETE_REQUIRED);

    TODBCDB = class (TSQLDB)
    private
      FDSN: String;
      FPrompt: TPromptType;
      procedure SetDSN(const Value: String);
      procedure SetPrompt(const Value: TPromptType);
      //function FindOwnerWindowHandle: Integer;
    protected
      ODBCEnv: Integer;
      ODBCHandle:Integer;
      ODBCConn: Integer;
      FHostInfo:String;
      FInfo:String;
      FConnectOptions:Integer;
      FConnected: Boolean;
      FInTransaction: Boolean;
      //function GetHasResult: Boolean;
      procedure StoreResult(Statement: Integer);
      function GetErrorMsg (Statement: Integer): String;
      procedure FillDBInfo; override;
      function MapDatatype (_datatype: Integer): TSQLDataTypes;
      procedure StoreFields (Statement: Integer);
      procedure StoreRow (Statement: Integer; row: TResultRow);
    public
      FClientVersion: String; //holds version info of odbc.dll
      constructor Create (AOwner:TComponent); override;
      destructor Destroy; override;
      function Query (SQL:String):Boolean; override;
      function Connect (Host, User, Pass:String; DataBase: String=''):Boolean; override;
      function DriverConnect (DSN: String; hwnd: Integer = 0): Boolean;
      procedure Close; override;
      function ExplainTable (Table:String): Boolean; override;
      function ShowCreateTable (Table:String): Boolean; override;
      function DumpTable (Table:String): Boolean; override;
      function DumpDatabase (Table:String): Boolean; override;

      function ShowTables: Boolean; override;

      {
      property DBHandle:MySQL read MyHandle; //Actual libmysql.dll / mysqlclient.so handle, use it if you want to call functions yourself
      property HasResult:Boolean read GetHasResult;// write FHasResult; //Queryhas valid result set
      property ServerInfo:String read GetServerInfo; //additional server info
      property Info:String read FInfo;
      property HostInfo:String read FHostInfo;
      }
      procedure StartTransaction; override;
      procedure Commit; override;
      procedure Rollback; override;

      function Execute (SQL: String): THandle; override;
      function FetchRow (Handle: THandle; var row: TResultRow): Boolean; override;
      procedure FreeResult (Handle: THandle); override;

    published
      property ClientVersion: String read FClientVersion write FDummyString;
      property DSN: String read FDSN write SetDSN;
      property Prompt: TPromptType read FPrompt write SetPrompt;
    end;



implementation



{ TODBCDB }

procedure TODBCDB.Close;
begin
  inherited;
  if FDLLLoaded then
    begin
      SQLDisconnect(ODBCHandle);
      if Assigned(FOnClose) then FOnClose(Self);
    end;
end;

function TODBCDB.Connect (Host, User, Pass: String; DataBase: String=''): Boolean;
var res: Integer;
begin
  //only one of those required (...)
  //with odbc, each odbc entry _is_ a database.
  //host parameter is more or less obsolete.
  Result := False;
  if not (FDllLoaded and FConnected) then
    exit;
  if (Host='') and (Database<>'') then
    Host := Database;
  res := SQLConnect(ODBCHandle,PChar(Host),SQL_NTS,PChar(User),SQL_NTS,PChar(Pass),SQL_NTS);
  FActive := res = SQL_SUCCESS;
  //SQLConnect(DBHandle,PChar(Database),SQL_NTS,PChar(User),SQL_NTS,PChar(PWD),SQL_NTS);
  Result := FActive;
  if FActive then
    FDatabase := Host
  else
    FDatabase := '';
  if FActive then
    FillDBInfo;
  if FActive and Assigned(FOnOpen) then
    FOnOpen(Self);
end;

constructor TODBCDB.Create(AOwner: TComponent);
begin
  inherited;
  //create a connection handle right after loading (...)
  FDllLoaded := LoadLibODBC32(FLibraryPath);
  if not FDLLLoaded then
    exit;
  if SQL_ERROR = SQLAllocEnv(ODBCEnv) then
    ODBCEnv := -1
  else
    FConnected := SQL_ERROR <> SQLAllocConnect(ODBCEnv,ODBCHandle);
end;

destructor TODBCDB.Destroy;
begin
  if FDllLoaded then
    begin
      if FConnected then
        SQLFreeConnect (ODBCHandle);
      SQLFreeEnv(ODBCEnv);
    end;
  inherited;
end;

function TODBCDB.DumpDatabase(Table: String): Boolean;
begin
  Result := False;
end;

function TODBCDB.DumpTable(Table: String): Boolean;
begin
  Result := False;
end;

function TODBCDB.ExplainTable(Table: String): Boolean;
begin
  Result := False;
end;

function TODBCDB.GetErrorMsg(Statement: Integer): String;
var
  sqlret:SQLRETURN;
  i:SQLSMALLINT;
  retmsglen: SQLSMALLINT;
  SqlMsg: array[0..512] of Char;
  SqlState:array[0..5] of Char;
  errid: SQLRETURN;
begin
  if not FDLLLoaded then
    begin
      Result := 'Failed to load dynamic link library ODBC32';
      exit;
    end;
  i := length (sqlmsg)-2;
  sqlret := SQLGetDiagRec(SQL_HANDLE_STMT, Statement, 1,sqlstate,@errid, SqlMsg, i, retmsglen);
  if sqlret  = SQL_SUCCESS then
    begin
      Result := StrPas(sqlstate)+':'+StrPas(SqlMsg);
    end;
end;

function TODBCDB.Query(SQL: String): Boolean;
var Statement: Integer;
    odbcres: Integer;
begin
  Result := False;
  if not FDLLLoaded then
    exit;

  FCurrentSet.Clear;

  odbcres :=  SQLAllocStmt(ODBCHandle,Statement);
  if odbcres = SQL_SUCCESS then
    begin
      if Assigned (FOnBeforeQuery) then
        try
          FOnBeforeQuery (Self, SQL);
        except end;
      odbcres := SQLExecDirect(Statement, PChar(SQL), Length(SQL));
      case odbcres of
        SQL_SUCCESS, SQL_NO_DATA:
        begin
          //SQLRowCount (Statement, FCurrentSet.FRowCount);
        end;
      end;
      case odbcres of
        SQL_SUCCESS:
        begin
          //storeresult will return the onerror
          StoreResult(Statement);
          FCurrentSet.FLastError := 0;
          FCurrentSet.FLastErrorText := '';
        end;
        SQL_NO_DATA:
        begin
          //may be an insert, update or delete:
          //if 'insert'=lowercase(copy(SQL,1,6)) then
          //last insert id= SELECT @@IDENTITY
          //select rows affected
          //SQLRowCount (Statement, FCurrentSet.FRowCount);
        end;
      else
        begin
          //fetch last error
          FCurrentSet.FLastError := odbcres;
          FCurrentSet.FLastErrorText := GetErrorMsg (Statement);
          if Assigned (FOnError) then
            try
              FOnError (Self);
            except end;
        end;
      end; //case

      //if 'insert'=lowercase(copy(SQL,1,6)) then
        //last insert id= SELECT @@IDENTITY

      //according to ms this call is depreciated
      //and internally mapped to free handle
//      if SQLFreeStmt(StateMent, SQL_DROP)<>SQL_SUCCESS then
      //so we could replace it to
//      if SQLFreeHandle (SQL_HANDLE_STMT, Statement) <> SQL_SUCCESS then
      //however, this is ODBC 3.0 only. better not break backward compatability.
      if SQLFreeStmt(StateMent, SQL_DROP)<>SQL_SUCCESS then
        begin
          //Error
          FCurrentSet.FLastError := -1;
          FCurrentSet.FLastErrorText := 'Could not free statement';
        end;

    end
  else
    begin
      FCurrentSet.FLastError := -1;
      FCurrentSet.FLastErrorText := 'Could not allocate statement';
    end;
end;


procedure TODBCDB.Commit;
var Option: SQLInteger;
begin
  if FInTransaction then
    begin
      SQLEndTran (SQL_HANDLE_DBC, ODBCHandle, SQL_COMMIT);
      Option := SQL_AUTOCOMMIT_ON;
      SQLSetConnectAttr (ODBCHandle, SQL_ATTR_AUTOCOMMIT, @Option, SQL_IS_POINTER);
    end;
  Unlock;
end;


procedure TODBCDB.Rollback;
var Option: SQLInteger;
begin
  if FInTransaction then
    begin
      SQLEndTran (SQL_HANDLE_DBC, ODBCHandle, SQL_ROLLBACK);
      Option := SQL_AUTOCOMMIT_ON;
      SQLSetConnectAttr (ODBCHandle, SQL_ATTR_AUTOCOMMIT, @Option, SQL_IS_POINTER);
    end;
  Unlock;
end;

function TODBCDB.ShowCreateTable(Table: String): Boolean;
begin
  Result := False;
end;

procedure TODBCDB.StartTransaction;
var Option: Integer;
    res: Integer;
begin
  Lock;
  //not too sure if this works, according to docs it should on db's supporting transactions
  Option := SQL_AUTOCOMMIT_OFF;
  res := SQLSetConnectAttr (ODBCHandle, SQL_ATTR_AUTOCOMMIT, @Option, SQL_IS_POINTER);
  //not all db support transactions
  FInTransaction := res = SQL_SUCCESS;
end;

procedure TODBCDB.StoreResult(Statement: Integer);
var i,res,odbcrow: Integer;
    NumCols: SmallInt;
    S: TResultRow;
begin
  CurrentResult.Clear;

//fill fields info
   res :=SQLNumResultCols(Statement, NumCols);
   FCurrentSet.FColCount := NumCols;
   FCurrentSet.FRowCount := 0;
   if (res in [SQL_SUCCESS, SQL_SUCCESS_WITH_INFO]) then
     //something to fetch
     begin
       FCurrentSet.FHasResult := True;
       StoreFields (Statement);


       //fetch rows
   //if (SQL_SUCCESS = SQLRowCount (Statement, FCurrentSet.FRowCount)) and
   //   (FCurrentSet.FRowCount>0) then
     begin
       odbcrow:=SQLFetch (Statement);
      //odbcrow := SQLFetchScroll(Statement, SQL_FETCH_FIRST,1);
      while odbcrow in [SQL_SUCCESS, SQL_SUCCESS_WITH_INFO] do
        begin
          FCurrentSet.FHasResult := True;
          inc (FCurrentSet.FRowCount);
          if FCallBackOnly then
            i:=1
          else
            i:=FCurrentSet.FRowCount;

          if i<=FCurrentSet.FRowList.Count then
            begin
              S := TResultRow(FCurrentSet.FRowList[i - 1]);
              S.Clear;
              S.FNulls.Clear;
            end
          else
            begin
              S := TResultRow.Create;
              S.FFields := FCurrentSet.FFields; //copy pointer to ffields array
              FCurrentSet.FRowList.Add(S);
            end;

          StoreRow (Statement, S);
         if Assigned (FOnFetchRow) then
            try
              FOnFetchRow (Self, S);
            except end;
          odbcrow:=SQLFetch (Statement);
        end;
    end;
    if Assigned (FOnSuccess) then
      try
        FOnSuccess(Self);
      except end;
    if Assigned (FOnQueryComplete) then
      try
        FOnQueryComplete(Self);
      except end;
  end
  else
  if Assigned (FOnError) then
    try
      FOnError (Self);
    except end;
end;

function TODBCDB.ShowTables: Boolean;
var odbcres: Integer;
    Statement: SQLHandle;
    cn,sn,tn,tt: PChar;
    ttype: String;
begin
  Result := False;
  if not FActive then
    exit;
  odbcres :=  SQLAllocStmt(ODBCHandle,Statement);
  if odbcres = SQL_SUCCESS then
    begin
      cn := nil;
      sn := nil;
      tn := nil;
      ttype := '''TABLE'', ''VIEW'''; //, ''SYSTEM TABLE''';
      tt := PChar (ttype);
      //tt := nil;
      odbcres := SQLTables(Statement, cn, 0, sn, 0, tn, 0, tt, SQL_NTS);
      if odbcres = SQL_SUCCESS then
        begin
          Result := True;
          StoreResult (StateMent);
        end;
      SQLFreeStmt (Statement, SQL_DROP);
    end;
end;

function TODBCDB.DriverConnect(DSN: String; hwnd: Integer=0): Boolean;
var res: Integer;
    Buf: array[0..20000] of Char;
    BufLen: SQLSmallInt;
    dc: SQLUSmallInt;
begin
  Result := False;
  if not (FDllLoaded and FConnected) then
    exit;
//  SetLength (Buf, 8192);

//  if (hwnd=0) and (FPrompt <> pt_NOPROMPT) then
//    hwnd := findownerwindowhandle;
  {
  if hwnd<>0 then
    dc := SQL_DRIVER_COMPLETE_REQUIRED
  else
    dc := SQL_DRIVER_NOPROMPT;
  }

  dc := SQLSMALLINT(FPrompt);
  res := SQLDriverConnect (ODBCHandle, hwnd, PChar(DSN), SQL_NTS, Buf, Length(Buf)-20, BufLen, dc);
  if res = SQL_SUCCESS then
    begin
      if BufLen>0 then
        begin
          //SetLength (Buf, BufLen);
        end
      else
        Buf := '';
      FDSN := Buf;
    end
  else
    begin
      FCurrentSet.FLastError := res;
      //FCurrentSet.FLastErrorText := GetErrorMsg;
    end;
  FActive := res = SQL_SUCCESS;
  Result := FActive;
  if FActive then
    FillDBInfo;
  if FActive and Assigned(FOnOpen) then
    FOnOpen(Self);
end;

procedure TODBCDB.SetDSN(const Value: String);
begin
  DriverConnect (Value);
//  FDSN := Value;
end;

procedure TODBCDB.SetPrompt(const Value: TPromptType);
begin
  FPrompt := Value;
end;


procedure TODBCDB.FillDBInfo;
begin
  inherited;  //clears tables and indexes

  if ShowTables then
    begin
      Tables := GetColumnAsStrings(2);
    end;
  //query indexes..
end;                         

function TODBCDB.MapDatatype(_datatype: Integer): TSQLDataTypes;
begin
  case _datatype of
    SQL_UNKNOWN_TYPE:   Result := dtUnknown;
    SQL_LONGVARCHAR:    Result := dtString;
    SQL_BINARY,
    SQL_VARBINARY,
    SQL_LONGVARBINARY:  Result := dtBlob;
    SQL_BIGINT:         Result := dtInt64;
    SQL_TINYINT:        Result := dtTinyInt;
    SQL_BIT:            Result := dtBoolean;
    SQL_WCHAR,
    SQL_WVARCHAR,
    SQL_WLONGVARCHAR:   Result := dtWideString;
    SQL_CHAR:           Result := dtString;
    SQL_NUMERIC,
    SQL_DECIMAL,
    SQL_INTEGER,
    SQL_SMALLINT:       Result := dtInteger;
    SQL_FLOAT,
    SQL_REAL,
    SQL_DOUBLE:         Result := dtFloat;
    SQL_DATETIME:       Result := dtDateTime;
    SQL_VARCHAR:        Result := dtString;
    SQL_TYPE_DATE,
    SQL_TYPE_TIME:      Result := dtDateTime;
    SQL_TYPE_TIMESTAMP: Result := dtTimeStamp;
//    SQL_NO_TOTAL:       Result := dtBoolean; //???
//    SQL_NULL_DATA:      Result := dtNull;
  else
    Result := dtUnknown;
  end;

end;

function TODBCDB.Execute(SQL: String): THandle;
var res: Integer;
    numcols: SmallInt;
begin
  if not FDLLLoaded then
    exit;
  res := SQLAllocStmt (ODBCHandle, Integer(Result));
  if res = SQL_SUCCESS then
    begin
      UseResultSet (Result);
      FCurrentSet.Clear;
      res := SQLExecDirect (Result, PChar(SQL), Length(SQL));
      if res=SQL_SUCCESS then
        begin
          res :=SQLNumResultCols(Result, numcols);
          if res=SQL_SUCCESS then
            begin
              FCurrentSet.FColCount := numcols;
              StoreFields (Result);
            end
          else
            FCurrentSet.FColCount := 0;
        end
      else
        begin
//          if res<>SQL_NO_DATA then
            FCurrentSet.FLastError := res;
          SQLFreeStmt (Result, SQL_DROP);
          Result := 0;
        end;
    end
  else
    Result := 0;
end;

function TODBCDB.FetchRow(Handle: THandle; var row: TResultRow): Boolean;
var res: Integer;
begin
  Result := False;
  row := FCurrentSet.FNilRow;
  if (not FDLLLoaded) or (Handle=0) then
    exit;
  UseResultSet (Handle);
  res := SQLFetch (Handle);
  if res=SQL_SUCCESS then
    begin
      Result := True;
      row := FCurrentSet.FCurrentRow;
      row.Clear;
      StoreRow (Handle, row);
    end
  else
    Result := False;
end;

procedure TODBCDB.FreeResult(Handle: THandle);
begin
  if (not FDLLLoaded) or (Handle = 0) then
    exit;
  //pretty useless to store result here
  FCurrentSet.FLastError := SQLFreeStmt(Handle, SQL_DROP);
  //since we free the result set now
  DeleteResultSet (Handle);
end;

procedure TODBCDB.StoreFields(Statement: Integer);
var i,j,res: Integer;
    ColumnName:String;
    NameLength:SQLSMALLINT;
    ODBCDataType:SQLSMALLINT;
    ColumnSize:SQLUINTEGER;
    DecimalDigits:SQLSMALLINT;
    Nullable:SQLSMALLINT;

begin
  //fetch field info
  for i:=0 to FCurrentSet.FColCount - 1 do
    begin
      SetLength (ColumnName, 512);
      res := SQLDescribeCol(Statement, i+1, PChar(ColumnName),length(ColumnName),Namelength,ODBCdatatype,columnsize,decimaldigits,Nullable);
      if res=SQL_SUCCESS  then
        begin
          SetLength (ColumnName, NameLength);
        end
      else
        begin
          ColumnName := 'Unknown';
        end;
      begin
          j:=FCurrentSet.FFields.AddObject(ColumnName, TFieldDesc.Create);
          with TFieldDesc (FCurrentSet.FFields.Objects [j]) do
            begin
              name := ColumnName;
              _datatype := odbcdatatype;
              datatype := MapDataType (_datatype);
              max_length := columnsize;
              digits := decimaldigits;
              required := Nullable = SQL_NO_NULLS;
            end;
        end;
   end;
end;

procedure TODBCDB.StoreRow(Statement: Integer; row: TResultRow);
var j: Integer;
    field: Integer;
    returnlength: Integer;
    data, buffer: String;
begin
  for j:=0 to FCurrentSet.FColCount - 1 do
    begin
      Data := '';
      SetLength (Buffer, 4034);
      field:=SQLGetData(Statement,j+1,SQL_C_CHAR,PChar(Buffer),Length(Buffer),@returnlength);
      while (field in [SQL_SUCCESS, SQL_SUCCESS_WITH_INFO]) and
            ((returnlength > Length(Buffer)){ or
             (returnlength=SQL_NO_TOTAL)}) do
        begin
          Data := Data + Buffer;
          field:=SQLGetData(Statement,j+1,SQL_C_CHAR,PChar(Buffer),Length(Buffer),@returnlength);
        end;
      if returnlength > 0 then
        SetLength (Buffer, returnlength)
      else
        //Empty field
        Buffer := '';
      Data := Data + Buffer;
      row.Add(Data);
      row.FNulls.Add(Pointer(Integer(returnlength = SQL_NULL_DATA)));
    end;
end;

end.
