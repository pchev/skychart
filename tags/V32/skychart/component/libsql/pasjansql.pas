unit pasjansql;

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

//JanSQL interface for libsql
//2005 R.M. Tegel
//Modified Artistic License
//
//For interfacing wit janSQL library by Jan Verhoeven 2002
//janSQL is a high-speed flat-file typeless sql engine released under Mozilla 1.1 license
//little modified by me.

interface
uses
     {$IFDEF WIN32}
     Windows,
     {$ENDIF}
     Classes, SysUtils,
     janSQL,
     passql,
     sqlsupport;

type
    TJanDB = class (TSQLDB)
    private
      FClientVersion: String;
    protected
      FDataDir: String;
      FAutoCommit: Boolean;
      FHostInfo:String;
      FInfo:String;
      FConnected: Boolean;
      FJanSQL: TJanSQL;
      procedure StoreResult(recordsetindex: Integer);
      function GetErrorMsg (Handle: Integer): String;
      procedure FillDBInfo; override;                                              //Dak_Alpha
      function MapDatatype (_datatype: Integer): TSQLDataTypes;
      procedure StoreFields (recordsetindex: Integer);
      procedure StoreRow (recordsetindex: Integer; rowIndex: Integer; row: TResultRow);
      function FindRecordSet(Handle: Integer): Integer;
    public
      constructor Create (AOwner:TComponent);  overload; override;
      constructor Create (AOwner:TComponent; DataBaseDirectory: String); overload;
      destructor Destroy; override;
      function Query (SQL:String):Boolean; override;
      function Connect (Host, User, Pass:String; DataBase:String=''):Boolean; override;
      function Use (Database:String):Boolean; override;

      procedure Close; override;
      function ExplainTable (Table:String): Boolean; override;
      function ShowCreateTable (Table:String): Boolean; override;
      function DumpTable (Table:String): Boolean; override;
      function DumpDatabase (Table:String): Boolean; override;

      function ShowTables: Boolean; override;

      procedure StartTransaction; override;
      procedure Commit; override;
      procedure Rollback; override;

      function Execute (SQL: String): THandle; override;
      function FetchRow (Handle: THandle; var row: TResultRow): Boolean; override;
      procedure FreeResult (Handle: THandle); override;

    published
      property ClientVersion: String read FClientVersion write FDummyString;
    end;

implementation

{ TJanDB }

procedure TJanDB.Close;
var
  i: Integer;
begin
  inherited;
  //not really a solution:
  // Use ('');

  for i := 1 to FJanSQL.RecordSetCount do                                          //Dak_Alpha
    FJanSQL.ReleaseRecordset(i);                                                   //Dak_Alpha

  if Assigned(FOnClose) then FOnClose(Self);                                       //Dak_Alpha
  FActive := False;                                                                //Dak_Alpha
end;

procedure TJanDB.Commit;
begin
  inherited;
  FJanSQL.SQLDirect('COMMIT');
  FAutoCommit := True;
end;


function TJanDB.Connect(Host, User, Pass:String; DataBase: String): Boolean;
var i: Integer;
begin
  i := FJanSQL.SQLDirect(Format('connect to ''%s''', [DataBase]));
  Result := i<>0;
  if Result then
    begin
      if DataBase[Length(DataBase)] in ['\','/'] then                              //Dak_Alpha
        FDataDir := DataBase
      else                                                                         //Dak_Alpha
        if Pos('/',DataBase)>0 then                                                //Dak_Alpha
          FDataDir := DataBase + '/'                                               //Dak_Alpha
        else                                                                       //Dak_Alpha
          FDataDir := DataBase + '\';                                              //Dak_Alpha
                                                        
      FDatabase := Database;
    end;
  FActive := Result;
  if FActive then                                                                  //Dak_Alpha
  begin                                                                            //Dak_Alpha
    FillDBInfo;                                                                    //Dak_Alpha
    if Assigned(FOnOpen) then FOnOpen(Self);                                       //Dak_Alpha
  end;                                                                             //Dak_Alpha
end;


constructor TJanDB.Create(AOwner: TComponent; DataBaseDirectory: String);
begin
  inherited Create(AOwner);
  //our engine:
  FJanSQL := TJanSQL.Create;
  //default to autocommit.
  FAutoCommit := True;
  if DataBaseDirectory <> '' then
    Use (DatabaseDirectory);
end;

constructor TJanDB.Create(AOwner: TComponent);
begin
  Create (AOwner, '');
end;

destructor TJanDB.Destroy;
begin
  if FActive then Close;                                                           //Dak_Alpha
  FJanSQL.Destroy;
  inherited;
end;

function TJanDB.DumpDatabase(Table: String): Boolean;
begin
  //not implemented
end;

function TJanDB.DumpTable(Table: String): Boolean;
begin
  Result := FormatQuery ('delete from %u', [Table]);
end;

function TJanDB.Execute(SQL: String): THandle;
var i: Integer;
begin
  Result := 0;
  if not FActive then
    exit;
  i := FJanSQL.SQLDirect(SQL);

  if i = 0 then                                                                    //Dak_Alpha
  begin                                                                            //Dak_Alpha
    FCurrentSet.FLastErrorText := FJanSQL.Error;                                   //Dak_Alpha
    FCurrentSet.FLastError := -1;                                                  //Dak_Alpha
  end                                                                              //Dak_Alpha
  else
  begin
    FCurrentSet.FLastErrorText := '';                                              //Dak_Alpha
    FCurrentSet.FLastError := 0;                                                   //Dak_Alpha
    if i > 0 then
    begin
      Result := Integer(FJanSQL.RecordSets[i]);
      UseResultSet (Result);
      FJanSQL.RecordSets[i].Cursor := 0;
      StoreFields (i);
    end;
  end;
end;

function TJanDB.ExplainTable(Table: String): Boolean;
begin
  //not implemented
end;

function TJanDB.FetchRow(Handle: THandle; var row: TResultRow): Boolean;
var i: Integer;
    jrs: TJanRecordSet;
begin
  Result := False;
  if Handle=0 then
    exit;
  UseResultSet (Handle);
  row := FCurrentSet.FCurrentRow;
  row.Clear;
  i := FindRecordSet (Handle);
  if i=0 then
    exit;
  jrs := FJanSQL.RecordSets [i];
  if not Assigned (jrs) then
    exit;

  if jrs.Cursor < jrs.recordcount then
    begin
      Result := True;
      StoreRow (i, jrs.Cursor, row);
      jrs.Cursor := jrs.Cursor + 1;
     end
  else
    begin
      row := FCurrentSet.FNilRow;
      Result := False;
    end;
end;

procedure TJanDB.FillDBInfo;
var
  sr: TSearchRec;
  FileAttrs: Integer;
begin
  inherited; //clears tables and indexes

  FileAttrs := 0;

  if FindFirst(FDataDir+'*.txt', FileAttrs, sr) = 0 then
  begin
    repeat
      Tables.Add(ChangeFileExt(sr.Name,''));
    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;
end;

function TJanDB.FindRecordSet(Handle: Integer): Integer;
var i: Integer;
begin
  Result := 0;
  //finds corresponding recordset by our unique handle:
  for i := 1 to FJanSQL.RecordSetCount do
    if FJanSQL.RecordSets [i] = Pointer(Handle) then
      begin
        Result := i;
        break;
      end;
end;

procedure TJanDB.FreeResult(Handle: THandle);
begin
  inherited;
  FJanSQL.ReleaseRecordset(FindRecordSet(Handle)); 
end;

function TJanDB.GetErrorMsg(Handle: Integer): String;
begin
  //note that index is ignored (!)
  Result := FJanSQL.Error;
end;

function TJanDB.MapDatatype(_datatype: Integer): TSQLDataTypes;
begin
  Result := dtString;
end;

function TJanDB.Query(SQL: String): Boolean;
var h: Integer;
begin
  Result := False;
  if not FActive then
    exit;
  //janSQL has some bugs, therefore this exception catcher:
  try
    h := FJanSQL.SQLDirect(SQL);
  except
    on E: Exception do
      FCurrentSet.FLastErrorText := 'Exception in database parser: '+E.Message;
  end;

  if h = 0 then                                                                    //Dak_Alpha
  begin                                                                            //Dak_Alpha
    FCurrentSet.FLastErrorText := FJanSQL.Error;                                   //Dak_Alpha
    FCurrentSet.FLastError := -1;                                                  //Dak_Alpha
    if Assigned (FOnError) then                                                    //Dak_Alpha
      try                                                                          //Dak_Alpha
        FOnError(Self);                                                            //Dak_Alpha
      except end;                                                                  //Dak_Alpha
    exit;                                                                          //Dak_Alpha
  end                                                                              //Dak_Alpha
  else                                                                             //Dak_Alpha
  begin                                                                            //Dak_Alpha
    FCurrentSet.FLastErrorText := '';                                              //Dak_Alpha
    FCurrentSet.FLastError := 0;                                                   //Dak_Alpha
  end;                                                                             //Dak_Alpha

  if (h>0) then
  begin
    StoreResult (h);
    FJanSQL.ReleaseRecordset(h);
  end;

  if (h<>0) then
  begin
    if Assigned (FOnSuccess) then                                                  //Dak_Alpha
      try                                                                          //Dak_Alpha
        FOnSuccess(Self);                                                          //Dak_Alpha
      except end;                                                                  //Dak_Alpha
    if Assigned (FOnQueryComplete) then                                            //Dak_Alpha
      try                                                                          //Dak_Alpha
        FOnQueryComplete(Self);                                                    //Dak_Alpha
      except end;                                                                  //Dak_Alpha

    if FAutoCommit then
      FJanSQL.SQLDirect('COMMIT');
  end;

  Result := True;                                                                  //Dak_Alpha
end;

procedure TJanDB.Rollback;
begin
  FJanSQL.SQLDirect('rollback');
  FAutoCommit := True;
end;

function TJanDB.ShowCreateTable(Table: String): Boolean;
begin
  //nothing to do.
end;

function TJanDB.ShowTables: Boolean;
begin
  //nothing to do.
end;

procedure TJanDB.StartTransaction;
begin
  FAutoCommit := False;
end;

procedure TJanDB.StoreFields(recordsetindex: Integer);
var Columns,
    i,j : Integer;
    jrs: TjanRecordSet;
begin
  jrs := FJanSQL.RecordSets [recordsetindex];
  if not Assigned(jrs) then
    exit;
  Columns := jrs.fieldcount;
  for i := 0 to Columns - 1 do
    begin
      j:=FCurrentSet.FFields.AddObject(jrs.FieldNames[i], TFieldDesc.Create);
      with TFieldDesc (FCurrentSet.FFields.Objects [j]) do
        begin
          name := jrs.FieldNames[i];
          _datatype := 0;
          datatype := dtUnknown; //we could say string or whatever
                                 //but the engine is typeless.
        end;
    end;
end;

procedure TJanDB.StoreResult(recordsetindex: Integer);
var i,res,odbcrow: Integer;
    NumCols: SmallInt;
    row: TResultRow;
    jrs: TjanRecordSet;
    cursor: Integer;
begin
  CurrentResult.Clear;
  jrs := FJanSQL.RecordSets [recordsetindex];
  if not Assigned(jrs) then
  if Assigned (FOnError) then
    begin
      try
        FOnError (Self);
      except end;
      exit;
    end;

//fill fields info
  FCurrentSet.FColCount := jrs.fieldcount;
  FCurrentSet.FRowCount := jrs.recordcount;
//  FCurrentSet.FHasResult := False;                                               //Dak_Alpha
  FCurrentSet.FHasResult := FCurrentSet.FColCount>0;                               //Dak_Alpha
  StoreFields (recordsetindex);

  for cursor := 0 to jrs.recordcount - 1 do
    begin
      FCurrentSet.FHasResult := True;

      if FCallBackOnly then
        i:=1
      else
        i:=FCurrentSet.FRowCount;

      if cursor<FCurrentSet.FRowList.Count then
        begin
          row := TResultRow(FCurrentSet.FRowList[cursor]);
          row.Clear;
          row.FNulls.Clear;
        end
      else
        begin
          row := TResultRow.Create;
          row.FFields := FCurrentSet.FFields; //copy pointer to ffields array
          FCurrentSet.FRowList.Add(row);
        end;

      StoreRow (recordsetindex, cursor, row);
      if Assigned (FOnFetchRow) then
        try
          FOnFetchRow (Self, row);
        except end;
    end;

//  if Assigned (FOnSuccess) then                                                  //Dak_Alpha
//    try                                                                          //Dak_Alpha
//      FOnSuccess(Self);                                                          //Dak_Alpha
//    except end;                                                                  //Dak_Alpha
//  if Assigned (FOnQueryComplete) then                                            //Dak_Alpha
//    try                                                                          //Dak_Alpha
//      FOnQueryComplete(Self);                                                    //Dak_Alpha
//    except end;                                                                  //Dak_Alpha
end;

procedure TJanDB.StoreRow(recordsetindex: Integer; RowIndex: Integer; row: TResultRow);
var Value: String; //^PChar;
    i:Integer;
    ColCount: Integer;
begin
  ColCount := FJanSQL.RecordSets[recordsetindex].fieldcount;
  if ColCount > 0 then
    begin
      for i := 0 to ColCount - 1 do
        begin
          //todo: keep
          //FJanSQL.RecordSets[0].Cursor;
          //
          Value := FJanSQL.RecordSets[recordsetindex].records[RowIndex].fields[i].value;
          if Value='' then
            row.FNulls.Add(Pointer(1))
          else
            row.FNulls.Add(Pointer(0));
          row.Add (Value);
          //inc (QS, length(Value));
        end;
    end;
end;

function TJanDB.Use(Database: String): Boolean;
begin
  Result := Connect ('','','',Database);
end;

end.
