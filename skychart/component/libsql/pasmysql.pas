unit pasmysql;

{$IFDEF FPC}
{$MODE Delphi}
{$H+}
{$ELSE}
  {$IFNDEF LINUX}
  {$DEFINE WIN32}
  {$ENDIF}
{$ENDIF}

interface
uses
     {$IFDEF MSWINDOWS}
     Windows,
     {$ENDIF}
     Classes, SysUtils,
     libmysql,
     passql,
     sqlsupport;


//This library is compliant with arbitrary
//versions of libmysql.dll and libmysqld.dll

////////////////////////////////////////////////
//                                            //
// TMyDB component by rene@dubaron.com        //
// TMyDB is a MySQL specific interface        //
// Nom part of libsql library                 //
//                                            //
////////////////////////////////////////////////

// by R.M. Tegel rene@dubaron.com

const MY_DEFAULT_PORT=3306;

type
    TMyVersion = (mvUnknown, mv3_23, mv4_0, mv4_1, mv5_0);
    TMyDB = class (TSQLDB)
    private
    function GetHasResult: Boolean;
    procedure SetEmbedded(const Value: Boolean);
    protected
      MyHandle:MySQL;
      PMyHandle:PMySQL;
      FLibrary:String;
      FHostInfo:String;
      FInfo:String;
      FRealConnect:Boolean;
      FUnixSock:String;
      FConnectOptions:Integer;
      FEmbedded: Boolean;
      FMyVersion: TMyVersion;
      mf: TMySQLFunctions; //short name, less typing..
      procedure StoreResult(Res: PMYSQL_RES);
      procedure FillDBInfo; override;
      function MapDataType (_datatype: Integer): TSQLDataTypes;
      procedure FillFieldInfo (Res: PMYSQL_RES);
    public
      FClientVersion: String; //holds version info of libmysql.dll
      constructor Create (AOwner:TComponent); override;
      destructor Destroy; override;
      function Query (SQL:String):Boolean; override;
      function Connect (Host, User, Pass:String; DataBase:String=''):Boolean; override;
      procedure Close; override;
      function ExplainTable (Table:String): Boolean; override;
      function ShowCreateTable (Table:String): Boolean; override;
      function DumpTable (Table:String): Boolean; override;
      function DumpDatabase (Table:String): Boolean; override;

       //typical MySQL functions:
      function SelectDatabase(Database:String):Boolean;
//       function GetSelectedDatabase:String;
      procedure SetDatabase(Value:String); override;
      function CreateDatabase(Database:String):Boolean; virtual;
      function DropDatabase(Database:String):Boolean;
      procedure ListDatabases(wildcard:String='');
      procedure ListTables(wildcard:String='');
      procedure ListFields(table:String; wildcard:String='');
      procedure ListProcesses;
      function ShutDown:Boolean;
      function Kill (Pid:Integer):Boolean; //Kill specific process
      procedure SetPort (Port:Integer); override;
      procedure SetRealConnect(DoRealConnect:Boolean);
      function Ping:Boolean; //See if server is alive
      function GetLastError:String;
      function GetServerInfo:String;
      function ShowTables: Boolean; override;
      function Flush (Option:String): Boolean; override;
      function TruncateTable (Table:String): Boolean; override;
      function LockTables (Statement:String): Boolean; override;
      function UnLockTables: Boolean; override;
      function Vacuum: Boolean; override;

      function Execute (SQL: String): THandle; override;
      function FetchRow (Handle: THandle; var row: TResultRow): Boolean; override;
      procedure FreeResult (Handle: THandle); override;

      property DBHandle:MySQL read MyHandle; //Actual libmysql.dll / mysqlclient.so handle, use it if you want to call functions yourself
      property HasResult:Boolean read GetHasResult;// write FHasResult; //Queryhas valid result set
      property ServerInfo:String read GetServerInfo; //additional server info
      property Info:String read FInfo;
      property HostInfo:String read FHostInfo;
      property UnixSock:String read FUnixSock write FUnixSock;
    published
      property Embedded: Boolean read FEmbedded write SetEmbedded;
      property RealConnect:Boolean read FRealConnect write SetRealConnect;
      property ClientVersion: String read FClientVersion write FDummyString;
    end;



implementation


//TMyDB has a constructor. Set some variabels to default, nothing more...
constructor TMyDB.Create;
begin
  FLibrary:=DEFAULT_DLL_LOCATION;
  {$IFDEF MSWINDOWS}
  DLL:=FLibrary;
  {$ENDIF}
  FHost:='localhost';
  FPort:=MY_DEFAULT_PORT;
  FActive:=False;
  FActivateOnLoad:=False;
  FRealConnect:=False;
  FConnectOptions:=_CLIENT_COMPRESS or _CLIENT_CONNECT_WITH_DB;
  FDataBaseType := dbMySQL;
  PrimaryKey := 'auto_increment primary key';
  inherited Create(AOwner);
end;

destructor TMyDB.Destroy;
begin
  if Active then
    Close;
  inherited Destroy;
end;

procedure TMyDB.Close;
begin
  if FActive then
    try
      mf.mysql_close(@MyHandle);
      {
      if Assigned (mf.mysql_thread_end) then //embedded mysql
        begin
          //don't.. probably mysql_thread_start also returned false.
//          mf.mysql_thread_end;
//          mf.mysql_server_end;
        end;
      }
      if Assigned(FOnClose) then
        FOnClose(Self);
    except
//      raise Exception.Create('An error occured while closing');
    end;
  FActive:=False;
end;

function TMyDB.Connect(Host, User, Pass:String; DataBase:String):Boolean;
var AHandle:PMySQL;
begin
  Result := False;
  //Close if already active
  if FActive then Close;

  {  $IFDEF MSWINDOWS}
  //Allow user to change shared library
  if FLibrary<>'' then
    DLL_Client:=FLibrary;

  {$IFDEF MSWINDOWS}
    //Embedded mysql 4.1 will definitively not work without config file.
  if FEmbedded and not fileexists ('c:\my.cnf') then
    //for some reason or another, %sysdir%\mysql.ini is not sufficient
    begin
      FCurrentSet.FLastError := -1;
      FCurrentSet.FLastErrorText := 'File c:\my.cnf does not exist';
      exit;
    end;
  {$ENDIF}

  FDllLoaded := MySQLLoadLib (mf, FLibraryPath, FEmbedded);

  if not FDllLoaded then
    exit;

  //Succesfully loaded
  if assigned(mf.mysql_thread_init) then
    begin
      if FEmbedded then
        FActive := mf.mysql_thread_init = 0
      else
        begin
          mf.mysql_thread_init; //call anyway.
          FActive := True;
        end;
    end
  else
    FActive := True;


  if not FActive then
    exit;

  if Assigned (mf.mysql_get_client_info) then
    FClientVersion := mf.mysql_get_client_info;
  FMyVersion := mvUnknown;
  if pos ('3.23.', FClientVersion)>0 then
    FMyVersion := mv3_23;
  if pos ('4.0.', FClientVersion)>0 then
    FMyVersion := mv4_0;
  if pos ('4.1.', FClientVersion)>0 then
    FMyVersion := mv4_1;
  if pos ('5.0.', FCLientVersion)>0 then
    FMyVersion := mv5_0;

  if FEmbedded then //some extra actions if embedded
    begin
      if Assigned (mf.mysql_server_init) then
        Result := 0 = mf.mysql_server_init (3, @DEFAULT_PARAMS, @SERVER_GROUPS)
      else
        exit;
    end
  else //libmysql client init:
    begin
      if assigned(mf.mysql_init) then
        PMyHandle := mf.mysql_init(@MyHandle)
      else
        exit;
    end;

  FDataBase := DataBase;
  PMyHandle := @MyHandle;

  if FEmbedded and (FDatabase='') then
    exit; //no database selected yet.

  if FEmbedded then //the 'dummy' connect proc
    begin

      if Assigned (mf.mysql_connect) then
        begin
          mf.mysql_connect (@MyHandle, nil, nil, nil);
        end
      else
      if Assigned (mf.mysql_real_connect) then
        mf.mysql_real_connect (@MyHandle, nil, nil, nil, PChar(String(FDataBase)), 0, nil, 0);

      if FActive and (FDataBase<>'') then
        mf.mysql_select_db(PMyHandle, PChar(FDataBase));
    end
  else //connect to our database server
    begin
      //Enable realconnect by default, not overridable...
      FRealConnect := True;

      if FRealConnect then
        try
          PMyHandle:= mf.mysql_real_connect(@MyHandle, PChar(String(Host)), PChar(String(User)), PChar(String(Pass)),
                     PChar(String(FDataBase)), FPort, nil {PChar(String(FUnixSock))}, Integer(CLIENT_COMPRESS){ FConnectOptions});
          FActive := PMyHandle<>nil;
          if not FActive then
            begin
              FCurrentSet.FLastErrorText := mf.mysql_error (@MyHandle);
              if pos(#0, FCurrentSet.FLastErrorText)>0 then //probably is
                FCurrentSet.FLastErrorText := copy (FCurrentSet.FLastErrorText, 1, pos(#0, FCurrentSet.FLastErrorText)-1);
              FCurrentSet.FLastError := mf.mysql_errno(@MyHandle);
              LogError;
            end
          else
            FCurrentSet.FLastError := 0;
        except
          FActive:=False;
        end
      else
        begin
          AHandle{PMyHandle}:=mf.mysql_connect(@MyHandle, PChar(Host), PChar(User), PChar(Pass));
          FActive := AHandle<>nil;
          //Select database if assigned:
          if FActive and (FDataBase<>'') then
            mf.mysql_select_db(@MyHandle, PChar(FDataBase));
        end;
    end;

  PMyHandle := @MyHandle;
  Result := FActive;

  if FActive and not (csDesigning in ComponentState) then
    begin
      //Fill in some variables:
      if Assigned (mf.mysql_get_server_info) then
        FVersion := mf.mysql_get_server_info (PMyHandle);
      if Assigned (mf.mysql_character_set_name) then
        FEncoding := mf.mysql_character_set_name(PMyHandle);
      if Assigned (mf.mysql_get_host_info) then
        FHostInfo := mf.mysql_get_host_info (PMyHandle);
      if Assigned (mf.mysql_get_proto_info) then
        FInfo := IntToStr (mf.mysql_get_proto_info (PMyHandle));
    end;

  if FActive then
    FillDBInfo;
  if FActive and Assigned(FOnOpen) then
    FOnOpen(Self);
end;

//An active property was added to allow
//database-access in development state ;)

//Quite direct MySQL functions:
function TMyDB.CreateDatabase(Database:String):Boolean;
begin
  if FActive{ and assigned (mf.mysql_create_db) }then
    Result := FormatQuery ('create database %u', [DataBase]) //(0=mf.mysql_create_db(@MyHandle, PChar(Database)))
  else
    Result := False;
end;

function TMyDB.DropDatabase(Database:String):Boolean;
begin
  if FActive and assigned (mf.mysql_drop_db) then
    Result := (0=mf.mysql_drop_db(@MyHandle, PChar(Database)))
  else
    Result := False;
  if Result and
     (lowercase(FDataBase) = lowercase(DataBase)) then
    FDatabase:='';
end;

function TMyDB.SelectDatabase(Database:String):Boolean;
begin
  if FActive and assigned (mf.mysql_select_db) then
    Result := (0 = mf.mysql_select_db(@MyHandle, PChar(Database)))
  else
    Result := False;
  if Result then FDatabase:=Database;
end;

function TMyDB.Kill(Pid:Integer):Boolean;
begin
  if FActive and assigned (mf.mysql_kill) then
    Result := (0=mf.mysql_kill(@MyHandle, Pid))
  else
    Result := False;
end;

function TMyDB.Ping: Boolean;
begin
  Result:=False;
  if FActive and assigned (mf.mysql_ping) then
    Result:=(mf.mysql_ping(@MyHandle)<>0);
end;

function TMyDB.ShutDown: Boolean;
begin
  if FActive then
    Result := (0=mf.mysql_shutdown(@MyHandle))
  else
    Result := False;
end;


//This is where the results from a query are stored in delphi string-arrays



procedure TMyDB.StoreResult;
//Loop all rows from a result set and put fields in 2D-array
var i, j, ri: Integer;
   // myrow: mysql_row;
    pmyrow: pmysql_row;
    //fields: Pmysql_fields;
    R: TResultRow;
begin
  with FCurrentSet do
    begin
      FHasResult:=False;
      if Res<>nil then
        begin
          FHasResult:=True;
          //reset memory usage counter
          FQuerySize := 0; 
          FRowCount := mf.mysql_num_rows(res); //res^.row_count;

          for i:=0 to FRowCount - 1 do
            begin
              if FCallBackOnly then
                ri:=0 //only 1 row needed
              else
                begin
                  ri := i;
                  //Check ranges; break if rowlimit or memory limit reached:
                  if ((FFetchRowLimit<>0) and ((i+1)>=FFetchRowLimit)) or
                     ((FFetchMemoryLimit<>0) and (FQuerySize>=FFetchMemoryLimit)) then
                    break; //mem limit exceeded...
                end;

              //Fetch a row:
              //myrow:=mf.mysql_fetch_row(res)^;
              pmyrow:=mf.mysql_fetch_row(res);
              if ri<FRowList.Count then
                begin
                  R := TResultRow(FRowList[ri]);
                  R.Clear;
                  R.FNulls.Clear;
                end
              else
                begin
                  R := TResultRow.Create;
                  R.FFields := FFields; //copy pointer to ffields array
                  FRowList.Add(R);
                end;

             for j:=0 to mf.mysql_num_fields(res) - 1 do
                begin
                  if Assigned (pmyrow^[j]) then
                    R.Add(pmyrow^[j])
                  else
                    R.Add('');
                  R.FNulls.Add(Pointer(Integer(pmyrow^[j]<>nil)));
                  inc (FQuerySize, length(String(pmyrow^[j])));
                end;
              if Assigned (FOnFetchRow) then
                try
                  FOnFetchRow (Self, R);
                except end;
            end;

          FillFieldInfo (Res);

          //Some more vars:
          FColCount := mf.mysql_num_fields(res);
          mf.mysql_free_result(res);
          FHasResult:=True;
          if Assigned (FOnSuccess) then
            try
              FOnSuccess(Self);
            except end;
          if Assigned (FOnQueryComplete) then
            try
              FOnQueryComplete(Self);
            except end;
        end
      else //May be invalid result or just no result
        begin  //Result = nil;
          Clear;
//          FLastInsertID := -1;
//          FRowsAffected := -1;
          FLastErrorText := mf.mysql_error(@MyHandle);
          FLastError := mf.mysql_errno(@MyHandle);
          if (FLastError<>0) and (Assigned (OnError)) then
            OnError (Self);
        end;
     //those can also be set on empty result sets:
     FLastInsertID := mf.mysql_insert_id (@MyHandle);
     FRowsAffected := mf.mysql_affected_rows (@MyHandle);
  end;
end;


//This is the main function to perform a query:
function TMyDB.Query (SQL: String): Boolean;
begin
  Result := False;
  if not FActive then
    SetActive(True); //Try once if client just performs query

  Clear;

  with FCurrentSet do
    begin
      FHasResult := False;

      if not FActive then
        exit; //sorry... nothing to do here, handle is invalid.

      if SQL='' then //clear the results:
        begin
          StoreResult (nil);
          //FCurrentSet.Clear;
          exit;
        end;

      if FActive then
        begin
          //Allow user to view or edit query:
          FSQL:=SQL;
          if Assigned (FOnBeforeQuery) then
            FOnBeforeQuery(Self, FSQL);
          SQL:=FSQL;

          //Perform actual query:
          if 0=mf.mysql_query(@MyHandle, PChar(SQL)) then
          //seems noor version of libmysql
          //returns on, even on failure (...)
            begin
              StoreResult(mf.mysql_store_result(@MyHandle));
              FLastError := mf.mysql_errno(@MyHandle);
              Result := FLastError=0;
              FLastErrorText := '';
              FHasResult := True;
            end
          else
            begin
              //StoreResult is able to handle errors and will call OnError as well
              //Calling it with nill forces a result cleanup:
              StoreResult(nil);
              FLastErrorText := mf.mysql_error(@MyHandle); //MyHandle._net.last_error;
              if pos(#0, FLastErrorText)>0 then //probably is
                FLastErrorText := copy (FLastErrorText, 1, pos(#0, FLastErrorText)-1);
              FLastError := mf.mysql_errno(@MyHandle); //MyHandle._net.last_errno;
              //if Assigned (FOnError) then
              //  FOnError(Self);
              LogError;
            end;
        end;
  end;
end;


//Common libmysql / libmysqlclient functions:
procedure TMyDB.ListDatabases;
begin
  if FActive then
    StoreResult(mf.mysql_list_dbs(@MyHandle, PChar(wildcard)));
end;

procedure TMyDB.ListTables;
begin
  if FActive then
    StoreResult(mf.mysql_list_tables(@MyHandle, PChar(wildcard)));
end;

procedure TMyDB.ListProcesses;
begin
  if FActive then
    StoreResult(mf.mysql_list_processes(@MyHandle));
end;

procedure TMyDB.ListFields;
begin
  if FActive then
    StoreResult(mf.mysql_list_fields(@MyHandle, PChar(table), PChar(wildcard)));
end;

function TMyDB.GetServerInfo: String;
begin
  if FActive then
    Result:=mf.mysql_get_server_info(@MyHandle)
  else
    Result:='Inactive';
end;

function TMyDB.GetLastError: String;
begin
  Result := FCurrentSet.FLastErrorText;
end;

//TMyDB control functions:
procedure TMyDB.SetPort;
begin
  if (Port<=0) or (Port>65535) then //Simply don't accept value
    exit;
  if Port<>MY_DEFAULT_PORT then //Force real connect:
    FRealConnect:=True;
  FPort:=Port;
end;

procedure TMyDB.SetRealConnect;
begin
  if not DoRealConnect then //Only connect to default port:
    FPort:=MY_DEFAULT_PORT;
  FRealConnect:=DoRealConnect;
end;

procedure TMyDB.SetDatabase;
begin
  if FActive then
    begin
      if SelectDataBase(Value) then
        FDataBase :=Value;
    end
  else
    FDataBase := Value;
end;


function TMyDB.DumpDatabase(Table: String): Boolean;
begin
  Result := False;
end;

function TMyDB.DumpTable(Table: String): Boolean;
begin
  Result := False;
end;

function TMyDB.ExplainTable(Table: String): Boolean;
begin
  Result := FormatQuery ('explain table %q', [Table]);
end;

function TMyDB.ShowCreateTable(Table: String): Boolean;
begin
  Result := False;
end;

function TMyDB.GetHasResult: Boolean;
begin
  Result := FCurrentSet.FHasResult;
end;

procedure TMyDB.SetEmbedded(const Value: Boolean);
begin
  FEmbedded := Value;
  if FEmbedded then
    FLibrary := MYSQLD_DLL_LOCATION
  else
    FLibrary := DEFAULT_DLL_LOCATION;
end;

procedure TMyDB.FillDBInfo;
begin
  inherited; //clears tables and indexes
  ShowTables;
  Tables := GetColumnAsStrings (0);
  //list indexes
  //Query ('SHOW INDEXES');
  Query('');
  //this returns a lot more than index name
(*
SHOW INDEX returns the index information in a format that closely resembles the SQLStatistics call in ODBC. The following columns are returned:
Column 	Meaning
Table 	Name of the table.
Non_unique 	0 if the index can't contain duplicates.
Key_name 	Name of the index.
Seq_in_index 	Column sequence number in index, starting with 1.
Column_name 	Column name.
Collation 	How the column is sorted in the index. In MySQL, this can have values `A' (Ascending) or NULL (Not sorted).
Cardinality 	Number of unique values in the index. This is updated by running isamchk -a.
Sub_part 	Number of indexed characters if the column is only partly indexed. NULL if the entire key is indexed.
Comment 	Various remarks. For now, it tells whether index is FULLTEXT or not.
*)
  Indexes := GetColumnAsStrings (2);
end;

function TMyDB.ShowTables: Boolean;
begin
//  mf.mysql_list_tables
  Result := Query ('SHOW TABLES');
end;

function TMyDB.Flush (Option:String): Boolean;
begin
  Result := Query ('FLUSH '+Option);
end;

function TMyDB.TruncateTable (Table:String): Boolean;
begin
  Result := Query ('TRUNCATE TABLE '+Table);
end;

function TMyDB.LockTables (Statement:String): Boolean;
begin
  Result := Query ('LOCK TABLES '+Statement);
end;

function TMyDB.UnLockTables: Boolean;
begin
  Result := Query ('UNLOCK TABLES');
end;

function TMyDB.Vacuum: Boolean;
begin
  Result := false;
end;

function TMyDB.MapDataType(_datatype: Integer): TSQLDataTypes;
begin
  case _datatype of
    FIELD_TYPE_DECIMAL,
    FIELD_TYPE_TINY,
    FIELD_TYPE_SHORT,
    FIELD_TYPE_LONG :      Result := dtInteger;
    FIELD_TYPE_FLOAT,
    FIELD_TYPE_DOUBLE:     Result := dtFloat;
    FIELD_TYPE_NULL:       Result := dtNull;
    FIELD_TYPE_TIMESTAMP:  Result := dtTimeStamp;
    FIELD_TYPE_LONGLONG:   Result := dtInt64;
    FIELD_TYPE_INT24:      Result := dtInteger;
    FIELD_TYPE_DATE,
    FIELD_TYPE_TIME,
    FIELD_TYPE_DATETIME:   Result := dtDateTime;
    FIELD_TYPE_YEAR:       Result := dtInteger;
    FIELD_TYPE_NEWDATE:    Result := dtDateTime;

    FIELD_TYPE_ENUM,
    FIELD_TYPE_SET:        Result := dtOther;
    FIELD_TYPE_TINY_BLOB,
    FIELD_TYPE_MEDIUM_BLOB,
    FIELD_TYPE_LONG_BLOB,
    FIELD_TYPE_BLOB:       Result := dtBlob;
    FIELD_TYPE_VAR_STRING,
    FIELD_TYPE_STRING:     Result := dtString;
    FIELD_TYPE_GEOMETRY:   Result := dtOther;
  else
    Result := dtUnknown;
  end;
end;

function TMyDB.Execute(SQL: String): THandle;
begin
  Result := 0;
  if not FDllLoaded then
    exit;
  if 0=mf.mysql_query(@MyHandle, PChar(SQL)) then
    begin
      Result := Integer (mf.mysql_store_result(@MyHandle));
      UseResultSet (Result);
      FCurrentSet.Clear;
      if Result <> 0 then
        begin
          FillFieldInfo (PMYSQL_RES(Result));
          FCurrentSet.FColCount := mf.mysql_num_fields(PMYSQL_RES(Result));
        end;
    end;
end;

function TMyDB.FetchRow(Handle: THandle; var row: TResultRow): Boolean;
var //myrow: mysql_row;
    pmyrow: PMysql_row;
    j: Integer;
begin
  Result := False;
  if not FDllLoaded or (Handle = 0) then
    exit;
  UseResultSet (Handle);
  row := FCurrentSet.FNilRow;
  pmyrow:=mf.mysql_fetch_row(PMYSQL_RES(Handle));
  if not Assigned (pmyrow) then
    exit;
  //bug fix by paul di aggio
  //myrow := pmyrow^;
  FCurrentSet.FCurrentRow.Clear;
  for j:=0 to mf.mysql_num_fields(PMYSQL_RES(Handle)) - 1 do
    begin
      if Assigned (pmyrow^[j]) then
        FCurrentSet.FCurrentRow.Add(pmyrow^[j])
      else
        FCurrentSet.FCurrentRow.Add('');
      FCurrentSet.FCurrentRow.FNulls.Add(Pointer(Integer(pmyrow^[j]<>nil)));
    end;
  row := FCurrentSet.FCurrentRow;
  Result := True;
end;

procedure TMyDB.FreeResult(Handle: THandle);
begin
  if not FDllLoaded or (Handle = 0) then
    exit;
  mf.mysql_free_result(PMYSQL_RES(Handle));
  DeleteResultSet (Handle);
end;

procedure TMyDB.FillFieldInfo(Res: PMYSQL_RES);
var i: Integer;
    Field: PMysql_field;
    FieldDesc: TFieldDesc;
begin
  with FCurrentSet do
    begin
      for i:=0 to mf.mysql_num_fields(res)-1 do
        begin
          Field := mf.mysql_fetch_field(res);
          if not Assigned (Field) then
            continue;
          FieldDesc := TFieldDesc.Create;
          FFields.AddObject(field.Name, FieldDesc);
          with FieldDesc do begin
            //Copy data mainly for PChar/String converting
            //Makes field info available after resource handle is closed!
            //assume field.name is always at same (1st) position:
            name:=field.name;
            case FMyVersion of
              mv3_23:
                begin
                  def:=PMysql_field_32(field).def;
                  table:=PMysql_field_32(field).table;
                  _datatype:=PMysql_field_32(field).enum_field_type;
                  max_length:=PMysql_field_32(field).max_length;
                  flags:=PMysql_field_32(field).flags;
                  decimals:=PMysql_field_32(field).decimals;
                end;
              mv4_0:
                begin
                  def:=PMysql_field_40(field).def;
                  table:=PMysql_field_40(field).table;
                  _datatype:=PMysql_field_40(field).enum_field_type;
                  max_length:=PMysql_field_40(field).max_length;
                  flags:=PMysql_field_40(field).flags;
                  decimals:=PMysql_field_40(field).decimals;
                end;
              mv4_1, mv5_0:
                begin
                  def:=PMysql_field_50(field).def;
                  table:=PMysql_field_50(field).table;
                  _datatype:=PMysql_field_50(field).enum_field_type;
                  max_length:=PMysql_field_50(field).max_length;
                  flags:=PMysql_field_50(field).flags;
                  decimals:=PMysql_field_50(field).decimals;
                end;
            end;
            //map mysql flags to some properties
            //just hope this is compatible across all mysql versions
            //afaik this is 4.1 (3.2 compatible) flag specification
            IsNullable := 0 <> (Flags and NOT_NULL_FLAG);
            IsPrimaryKey := 0 <> (Flags and PRI_KEY_FLAG);
            IsUnique := 0 <> (Flags and UNIQUE_KEY_FLAG);
            IsKey := 0 <> (Flags and MULTIPLE_KEY_FLAG);
            IsBlob := 0 <> (Flags and BLOB_FLAG);
            IsUnsigned := 0 <> (Flags and UNSIGNED_FLAG);
            IsAutoIncrement := 0 <> (Flags and AUTO_INCREMENT_FLAG);
            IsNumeric := 0 <> (Flags and NUM_FLAG);
(*
  non mapped flags:
  ZEROFILL_FLAG   { Field is zerofill }
  BINARY_FLAG     { Field is binary }
  ENUM_FLAG       { Field is an enum }
  TIMESTAMP_FLAG  { Field is a timestamp }
  SET_FLAG        { Field is a set }
*)
          end;
        end;
    end;

end;

end.
