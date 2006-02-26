unit passqlite3;

{$IFDEF FPC}
{$MODE Delphi}
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

uses {$IFNDEF LINUX}{$IFDEF FPC}LCLIntf, {$ENDIF}Windows, {$ENDIF}Classes, SysUtils, SyncObjs,
     libsqlite3, passql, sqlsupport;

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

  TLiteDB3 = class (TSQLDB)
  private
    FPort: Integer;
    FUser: String;
    FHost: String;
    FPass: String;
  protected
    FBaseInfo:TBaseInfo; //keep track of open databases for thread-safety
  public
    procedure Lock; virtual;
    procedure Unlock; virtual;

    function Query (SQL:String):Boolean; override;
    function Use (Database:String):Boolean; override;
    procedure SetDataBase (Database:String); override;
    function Connect (Host, User, Pass:String; DataBase:String=''):Boolean; override;
    procedure Close;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
    function GetErrorMessage:String;

    //support functions:
    function ExplainTable (Table:String): Boolean; override;
    function ShowCreateTable (Table:String): Boolean; override;
    function DumpTable (Table:String): Boolean; override;
    function DumpDatabase (Table:String): Boolean; override;

    constructor Create (AOwner:TComponent; LibraryPath:String; DataBase:String='');
    destructor  Destroy; override;
  published
    //hide these properties by making them read-only
    property Host:String read FHost;
    property Port:Integer read FPort;
    property User:String read FUser;
    property Password:String read FPass;
  end;


implementation

var DataBases:TStringList; //filled with DB names and appropiate critical sections
    CSConnect:TCriticalSection;
    ii:Integer;

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
  with Sender as TLiteDB3 do
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
              S.FNulls.Add(Pointer(Integer(Value^<>nil)));
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


constructor TLiteDB3.Create(AOwner:TComponent; LibraryPath:String; DataBase:String);
begin
  inherited Create(AOwner);
  PrimaryKey := 'primary key';
  FDataBaseType := dbSqlite3;
  LibsLoaded := LoadLibs(LibraryPath);
  if DataBase<>'' then
    Use (DataBase);
end;

destructor TLiteDB3.Destroy;
begin
  inherited;
end;

function TLiteDB3.Query(SQL: String): Boolean;
var P:PChar;
    i:Integer;
begin
  Result := False;
  FHasResult := False;
  if not LibsLoaded or
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
      SQLite3_BusyTimeout(FBaseInfo.FHandle, 2);
      SQLite3_BusyHandler(FBaseInfo.FHandle, @QueryBusyCallback, Self);
    end;
  FQuerySize := 0;
  if SQL<>'' then  //calling with empty string causes a result cleanup.
    begin
      FLastError := SQLite3_Exec(FBaseInfo.FHandle, PChar(SQL), @QueryCallBack, Self, P);
      if FLastError = SQLITE_ERROR then begin
        SetString(FLastErrorText, P, StrLen(P));
        SQLite3_Free(P);
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
  FRowsAffected := SQLite3_Changes(FBaseInfo.FHandle);
  //we need to do this here (multi-threaded!):
  FLastInsertID := SQLite3_LastInsertRowId(FBaseInfo.FHandle);
  FBaseInfo.CS.Leave;
  FColCount := FFields.Count;
  Result := (FLastError = sqlite_ok);
  FHasResult := Result;
  if Assigned (FOnQueryComplete) then
    try
      FOnQueryComplete(Self);
    except end;
end;


function TLiteDB3.Use (Database: String): Boolean;
var B:TBaseInfo;
    i:Integer;
    P:PChar;
    rslt:Integer;
begin
  Result := False;
  FActive := False;
  //use this database
  if not LibsLoaded then begin
    FLastErrorText := 'ups failed to load libs';
    Exit;
  end;
  //make full path of database:
  if '' = ExtractFilePath (DataBase) then
    //add file path to database
    DataBase := ExtractFilePath (ParamStr(0){Application.ExeName is in Forms unit :( }) + DataBase;
  if not FileExists (DataBase) then
    begin
      //create new, check file extensions:
      if ('' = ExtractFileExt (DataBase)) {and FAddExtension} then
        DataBase := DataBase + '.lit';
    end;
  FDataBase := DataBase;  

  CSConnect.Enter;
  if FDataBase<>'' then //unregister
    begin
      i:=DataBases.IndexOf (FDataBase);
      if i>=0 then //should always be!
        with TBaseInfo (DataBases.Objects [i]) do
          begin
            dec (ReferenceCount);
            if ReferenceCount=0 then
              begin
                //close handle
                SQLite3_Close (FHandle);
                Free;
                DataBases.Delete(i);
              end;
          end;
    end;
  if DataBases.IndexOf(DataBase)<0 then
    begin
      B := TBaseInfo.Create;
      DataBases.AddObject(DataBase, B);
      inc (B.ReferenceCount);
      rslt := SQLite3_Open(PChar(DataBase), B.FHandle);
      if Assigned (B.FHandle) then
        begin
          //FVersion := SQLite3_Version;
          //FEncoding := SQLite_encoding;
          FActive := True;
          Result := True;
        end
      else
        FLastErrorText := P;
      FBaseInfo := B;
    end
  else
    begin
      FBaseInfo := TBaseInfo(DataBases.Objects[DataBases.IndexOf(DataBase)]);
      Result := True;
    end;
  FDataBase := DataBase;
  CSConnect.Leave;
end;

function TLiteDB3.GetErrorMessage: String;
var P: PChar;
begin
  if Assigned (FBaseInfo) then begin
    P := SQLite3_ErrorMsg (FBaseInfo.FHandle);
    Result := P;
    SQLite3_Free(P);
  end;
end;


procedure TLiteDB3.Lock;
begin
  if Assigned (FBaseInfo) then
    FBaseInfo.CS.Enter;
end;

procedure TLiteDB3.UnLock;
begin
  if Assigned (FBaseInfo) then
    FBaseInfo.CS.Leave;
end;

procedure TLiteDB3.StartTransaction;
begin
   if Assigned (FBaseInfo) then
     begin
       Lock;
       Query ('BEGIN'); //start transaction
     end;
end;

procedure TLiteDB3.Commit;
begin
  if Assigned (FBaseInfo) then
    begin
      Query ('COMMIT');
      Unlock;
    end;
end;

procedure TLiteDB3.Rollback;
begin
  if Assigned (FBaseInfo) then
    begin
      Query ('ROLLBACK');
      Unlock;
    end;
end;


procedure TLiteDB3.Close;
begin
  Use ('');
end;

function TLiteDB3.Connect(Host, User, Pass, DataBase: String): Boolean;
begin
  if DataBase<>'' then
    Result := Use (DataBase)
  else
    Result := False;
end;

procedure TLiteDB3.SetDataBase(Database: String);
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

function TLiteDB3.DumpDatabase(Table: String): Boolean;
begin

end;

function TLiteDB3.DumpTable(Table: String): Boolean;
begin

end;

function TLiteDB3.ExplainTable(Table: String): Boolean;
begin

end;

function TLiteDB3.ShowCreateTable(Table: String): Boolean;
begin

end;

initialization
  DataBases := TStringList.Create;
  CSConnect := TCriticalSection.Create;

finalization
  for ii:=0 to DataBases.Count - 1 do
    TBaseInfo (DataBases.Objects[ii]).Free;
  DataBases.Free;
  CSConnect.Free;

end.




