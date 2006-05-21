unit lsdatasettable;

{
  Borland TDataSet compatible class
  Specify a table name
  And access results read/write (if rowid or equivalent available)
}

interface

uses
  SysUtils, Classes, Db, lsdatasetbase, passql, passqlite, pasmysql;

type
  TlsTable = class(TlsBaseDataSet)
  private
    FTable: String;
    FTables: TStrings;
    FPrimaryKeyIndex: Integer;
    FEditRow: TResultRow;
    FEditRowIndex: Integer;

    procedure SetTable(const Value: String);
  protected
    procedure InternalDelete; override;

    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalInsert; override;
    procedure InternalPost; override;
    procedure InternalEdit; override;
    procedure InternalCancel; override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    function GetCanModify: Boolean; override;
    procedure CheckDBMakeQuery;
  public
    constructor Create (Owner: TComponent); override;
    destructor Destroy; override;

    procedure SetDatabase(const Value: TSqlDB); override;

    function ListTables: TStrings;
  published
    property Table: String read FTable write SetTable;
  end;

implementation

procedure TlsTable.InternalDelete;
begin
  // todo: support deleting
  if FPrimaryKeyIndex >= 0 then
    begin
      //delete from table
      if FHelperSet.FormatQuery('delete from %u where %u=%d',
        [FTable, FResultSet.FieldName[FPrimaryKeyIndex], FResultSet.Row[FCurrent].Format[FPrimaryKeyIndex].AsInteger]) then
        begin
          //dirty trick, delete row from resultset without re-querying
          //fortunately TResultSet allows this kind of tricks
          //Since delete query returned true we assume this gives consistent results.
          FResultSet.Row[FCurrent].Free;
          FResultSet.FRowList.Delete(FCurrent);
          dec (FResultSet.FRowCount);
        end;
    end;
end;

// III: Move data from field to record buffer
procedure TlsTable.SetFieldData(Field: TField; Buffer: Pointer);
var sValue: String;
    iValue: Integer;
    fValue: Double;
    bValue: Boolean;
    tValue: TDateTime;
begin
  case Field.DataType of
    ftString:
      begin
        sValue := PChar (Buffer);
        if FHelperSet.FormatQuery('update %u set %u=%s where %u=%d',
             [FTable, Field.FieldName,
              sValue,
              FResultSet.FieldName[FPrimaryKeyIndex], FResultSet.Row[FCurrent].Format[FPrimaryKeyIndex].AsInteger
             ]) then
          FResultSet.Row[FCurrent].Strings[FFieldOffset + Field.Index] := sValue;
      end;
    ftInteger:
      begin
        Move (Buffer, iValue, SizeOf(iValue));
        if FHelperSet.FormatQuery('update %u set %u=%d where %u=%d',
             [FTable, Field.FieldName,
              iValue,
              FResultSet.FieldName[FPrimaryKeyIndex], FResultSet.Row[FCurrent].Format[FPrimaryKeyIndex].AsInteger
             ]) then
          FResultSet.Row[FCurrent].Strings[FFieldOffset + Field.Index] := IntToStr(iValue);
      end;
    ftFloat:
      begin
        Move (Buffer, fValue, SizeOf(fValue));
        if FHelperSet.FormatQuery('update %u set %u=%f where %u=%d',
             [FTable, Field.FieldName,
              fValue,
              FResultSet.FieldName[FPrimaryKeyIndex], FResultSet.Row[FCurrent].Format[FPrimaryKeyIndex].AsInteger
             ]) then
          FResultSet.Row[FCurrent].Strings[FFieldOffset + Field.Index] := FloatToStr(fValue);
      end;
  end;
end;

procedure TlsTable.InternalInsert;
begin
  // todo: support inserting
  //need to add an extra record here...

  //db specs ?
//  if FEditing then
//    InternalPost;
  FInserting := True;
  InternalEdit;
  //SetState (dsEdit);
end;

procedure TlsTable.InternalEdit;
begin
  if FEditing then
    exit; //or post? or raise exception?
  FEditing := True;
  //issue here.. what if multiple components want to archieve edit state?
  
  FHelperSet.SQLDB.StartTransaction;

end;

procedure TlsTable.InternalPost;
begin
  // TODO: support editing
  FEditing := False;
  FInserting := False;
end;

procedure TlsTable.InternalCancel;
begin
  FEditing := False;
  FInserting := False;
end;

procedure TlsTable.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
  // TODO: support adding
end;


function TlsTable.GetCanModify: Boolean;
begin
  Result := False; // read-only
  //sqlite is editable.. for mysql and odbc i must see how to handle...
  if Assigned(FDatabase) and
     //(FDatabase is TLiteDB) then
     (FPrimaryKeyIndex >= 0)
     // and not FEditing?
    then 
    Result := True;
end;

function TlsTable.ListTables: TStrings;
begin
  if Assigned(FDatabase) then
    begin
      FDatabase.UseResultSet(FHelperSet);
      FDatabase.ShowTables;
      FTables.Free;
      FTables := FDatabase.GetColumnAsStrings;
      //FTables.Assign(FDatabase.Tables)
    end
  else
    FTables.Clear;
  Result := FTables;
end;


procedure TlsTable.SetTable(const Value: String);
begin
  FTable := Value;
  CheckDBMakeQuery;
{
  if FDatabaseOpen then
    begin
      Active := False;
      Active := True;
    end;
}
end;

constructor TlsTable.Create(Owner: TComponent);
begin
  inherited;
  FTables := TStringList.Create;
  FEditRow := TResultRow.Create;
end;

destructor TlsTable.Destroy;
begin
  FEditRow.Free;
  FTables.Free;
  inherited;
end;

procedure TlsTable.CheckDBMakeQuery;
var i: Integer;
    fd: TFieldDesc;
begin
  if Assigned(FDatabase) then
    begin
      FQuery := 'select * from '+FTable;
      FFieldOffset := 0;
      FPrimaryKeyIndex := -1;
      if FDatabase is TLiteDB then
        begin
          FQuery := 'select rowid, * from '+FTable;
          FFieldOffset := 1;
          FPrimaryKeyIndex := 0;
        end;
      if FDatabase is TMyDB then
        begin
          for i := 0 to FResultSet.FFields.Count - 1 do
            begin
              fd := FResultSet.FieldDescriptor [i];
              if fd.IsNumeric and
                 fd.IsAutoIncrement and
                 fd.IsPrimaryKey then
                begin
                  FPrimaryKeyIndex := i;
                  break;
                end;

            end;
        end;
    end;
end;

procedure TlsTable.SetDatabase(const Value: TSqlDB);
begin
  inherited;
  CheckDBMakeQuery;
end;

end.

