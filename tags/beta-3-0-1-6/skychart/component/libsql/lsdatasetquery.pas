unit lsdatasetquery;

{
  Borland TDataSet compatible class
  Specify a SQL query
  And access results read-only.
}

interface

uses
  SysUtils, Classes, Db, lsdatasetbase, passql;

type
  TlsQuery = class(TlsBaseDataSet)
  private
    //borlands class completion ''demands'' this here (...)
    FQuery: String;
  protected
    procedure SetQuery(const Value: String);
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalInsert; override;
    procedure InternalPost; override;
    procedure InternalRefresh; override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    function GetCanModify: Boolean; override;
  public
    procedure FormatQuery (Value: string; const Args: array of const);
  published
    property Query: String read FQuery write SetQuery;
  end;

implementation


procedure TlsQuery.InternalPost;
begin
  // TODO: support editing
end;

procedure TlsQuery.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
  // TODO: support adding
end;


// III: Move data from field to record buffer
procedure TlsQuery.SetFieldData(Field: TField; Buffer: Pointer);
begin
  // todo: support changes
end;

procedure TlsQuery.InternalInsert;
begin
  // todo: support inserting
end;

function TlsQuery.GetCanModify: Boolean;
begin
  Result := False; // read-only
end;

procedure TlsQuery.SetQuery(const Value: String);
begin
  FQuery := Value;
  FInternalQuery := Value;

  //perform query on FDatabase
end;

procedure TlsQuery.FormatQuery(Value: string; const Args: array of const);
var s: String;
    ws: WideString;
begin
  TSQLDB._FormatSQL (s, ws, Value, Args, False, TSqlDB.DatabaseType(FDatabase));
  Query := s;
end;

procedure TlsQuery.InternalRefresh;
begin

end;

end.

