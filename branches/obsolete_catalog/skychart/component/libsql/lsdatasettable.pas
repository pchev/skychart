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
    procedure ClearEditRow;
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

procedure TlsTable.SetFieldData(Field: TField; Buffer: Pointer);
var sValue: String;
    iValue: Integer;
    fValue: Double;
    bValue: Boolean;
    tValue: TDateTime;
    row: TResultRow;
begin
  row := PRecInfo(ActiveBuffer).Row;

  if not Assigned(Row) then
    exit;

  case Field.DataType of
    ftString:
      begin
        sValue := PChar (Buffer);
        row.Strings[FFieldOffset + Field.Index] := sValue;
      end;
    ftInteger:
      begin
        Move (Buffer^, iValue, SizeOf(iValue));
        Row.Strings[FFieldOffset + Field.Index] := IntToStr(iValue);
      end;
    ftFloat:
      begin
        Move (Buffer^, fValue, SizeOf(fValue));
        Row.Strings[FFieldOffset + Field.Index] := FloatToStr(fValue);
      end;
  end;

end;

procedure TlsTable.InternalInsert;
var P: PChar;
    i: Integer;
begin
  //ActiveRecord should provide us
  //access to the buffer
  //that was just fetched by the base class
  //row is (supposed to be) nil here, we set it to editrow
  ClearEditRow;
  PRecInfo(ActiveBuffer).Row := FEditRow;
  FInserting := True;
end;

procedure TlsTable.InternalEdit;
begin
  FEditing := True;
  //make sure we have empty and corresponding fields
  ClearEditRow;
  //Copy contents of the row we are editing (dirty workaround - ignores any widestrings)
  FEditRow.Assign (PRecInfo(ActiveBuffer).Row);
  FEditRow.FNulls.Assign(PRecInfo(ActiveBuffer).Row.FNulls);

  //issue here.. what if multiple components want to archieve edit state?
  //seems datasource handles this nicely.
  //since all dataaware components follow the same cursor
  //but multiple writers on same database object
  //may have inconsistencies in nested transactions.
//  FHelperSet.SQLDB.StartTransaction;
end;

procedure TlsTable.InternalPost;
//Examine the stuff being edited
//build a nice query of the now values
//and update or insert, depending on edit mode
  function FormatValue (dt: TSQLDataTypes; c: TResultCell): String;
  begin
    case dt of
      dtString  : Result := FDatabase.FormatSql('%s', [c.AsString]);
      dtInteger : Result := FDatabase.FormatSql('%d', [c.AsInteger]);
      dtFloat   : Result := FDatabase.FormatSql('%f', [c.AsFloat]);
    //todo: other datatypes
    else
      Result := 'NULL';
    end;
  end;

var i: Integer;
    row: TResultRow;
    q,n,v: String;
    fd: TFieldDesc;
begin
  row := PRecInfo(ActiveBuffer).Row;
  if FEditing then
    begin
      //update modified fields
      q := 'update ' + FTable + ' set ';
      v := '';
      for i:=FFieldOffset to row.FFields.Count - 1 do
        begin
          if v<>'' then
            v := v + ', ';
          v := v + FResultSet.FieldName [i] + '=';
          fd := FResultSet.FieldDescriptor[i];
          case fd.datatype of
            dtString, dtNull  : v := v + FDatabase.FormatSql('%s', [row.Format[i].AsString]);
            dtInteger : v := v + FDatabase.FormatSql('%d', [row.Format[i].AsInteger]);
            dtFloat   : v := v + FDatabase.FormatSql('%f', [row.Format[i].AsFloat]);
          //todo: other datatypes
          else
            v := v + 'NULL';
          end;
        end;
      q := q + v + ' where ' + FResultSet.FieldName[FPrimaryKeyIndex] + '=' + IntToStr(FEditRow.Format[FPrimaryKeyIndex].AsInteger);
      //q now holds query
      if FHelperSet.Query(q) then
        //all ok, row is modified
        begin
          //nothing to do, current row holds info
        end
      else
        begin
          //restore contents that were backed up in editrow
          row.Assign(FEditRow);
          row.FNulls.Assign(FEditRow.FNulls);
          row.FFields := FEditRow.FFields;
        end;
    end;

  if FInserting then
    begin
      q := 'insert into '+FTable;
      n := '';
      v := '';
      for i := FFieldOffset to row.FFields.Count - 1 do
        begin
          if i = FPrimaryKeyIndex then
            continue;
          if n<>'' then
            n := n + ', ';
          n := n + FResultSet.FieldName [i];
          if v<>'' then
            v := v + ', ';
          fd := FResultSet.FieldDescriptor[i];  
          case fd.datatype of
            dtString  : v := v + FDatabase.FormatSql('%s', [row.Format[i].AsString]);
            dtInteger : v := v + FDatabase.FormatSql('%d', [row.Format[i].AsInteger]);
            dtFloat   : v := v + FDatabase.FormatSql('%f', [row.Format[i].AsFloat]);
          //todo: other datatypes
          else
            v := v + 'NULL';
          end;
        end;
      q := q + '(' + n + ') values (' + v + ')';
      if FHelperSet.Query(q) then
        begin
          if FPrimaryKeyIndex >= 0 then
            FEditRow.Strings [FPrimaryKeyIndex] := IntToStr (FHelperSet.FLastInsertID);
          FResultSet.FRowList.Insert(ActiveRecord {FCurrent}, FEditRow);
          //FResultSet.FRowList.Add(FEditRow);
          FEditRow := TResultRow.Create;
          FEditRow.FFields := FResultSet.FFields;
        end
      else
        begin
          //insert failed, do nothing
        end;
    end;
  FEditing := False;
  FInserting := False;
//  FHelperSet.SQLDB.Commit;
end;

procedure TlsTable.InternalCancel;
begin
  if FEditing then //not inserting
    begin
      PRecInfo(ActiveBuffer).Row.Assign (FEditRow );
      PRecInfo(ActiveBuffer).Row.FNulls.Assign(FEditRow.FNulls);
    end;
  FEditing := False;
  FInserting := False;
//  FHelperSet.SQLDB.Rollback;
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
  FEditRow.FFields := FResultSet.FFields;
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
      FInternalQuery := 'select * from '+FTable;
      FFieldOffset := 0;
      FPrimaryKeyIndex := -1;
      if FDatabase is TLiteDB then
        begin
          FInternalQuery := 'select rowid, * from '+FTable;
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

procedure TlsTable.ClearEditRow;
var i: Integer;
begin
  FEditRow.Clear;
  FEditRow.FFields := FResultSet.FFields;
  for i := 0 to FEditRow.FFields.Count do
    begin
      FEditRow.Add('');
      FEditRow.FNulls.Add(nil);
    end;
end;

end.

