unit lsdatasetbase;

{

LibSQL TDataset base class
By Rene Tegel 2005
This class allows interfacing with any TSqlDB based class
as provided by libsql.

Many thanks to Marco Cantu for providing tutorial
and example code on how to create a TDataSet
This code is inspired by his example code

Marco writes on his website:
"The complete source code for this custom dataset can
be found on my Web site: feel free to use it as a starting
point of your own work, and (if you are willing) share
the results with me and the community."

And so i did ;)
}

interface

uses
  DB, Classes, SysUtils, Windows, Forms, Contnrs, passql;

type
  TlsBaseDataSet = class (TDataSet)
  private
    FReportedStringLength: Integer;
    procedure SetReportedStringLength(const Value: Integer);

  protected
    FDatabase: TSqlDB;
    //results as presented te the user
    FResultSet: TResultSet;
    //internal helper set. better than using 'default' set or some of the base component.
    FHelperSet: TResultSet;
    FTempSet: TResultSet; //restore result set that was currently selected
    FInternalQuery: String;
    
    FFieldOffset: Integer; //specify if you want to hide fields from the presented result
    FInserting: Boolean;
    FEditing: Boolean;

    // record data and status
    FDatabaseOpen: Boolean;
    FRecordSize: Integer; // actual data + housekeeping
    FCurrent: Integer;
    // dataset virtual methods
    function AllocRecordBuffer: PChar; override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function GetRecordSize: Word; override;
    procedure InternalInitFieldDefs; override;
    
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalClose; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalPost; override;

    procedure InternalSetToRecord(Buffer: PChar); override;
    function IsCursorOpen: Boolean; override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetRecordCount: Integer; override;
    procedure SetRecNo(Value: Integer); override;
    function GetRecNo: Integer; override;

    //libsql added property:
    procedure SetDatabase(const Value: TSqlDB); virtual;
  public

    constructor Create (Owner: TComponent); override;
    destructor Destroy; override;

    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;


  published
    // redeclared data set properties
    property Active;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;

    //added property
    property Database: TSqlDB read FDatabase write SetDatabase;
    //reported string length on variable length string fields with unknown or undefined maximum length
    property ReportedStringLength: Integer read FReportedStringLength write SetReportedStringLength;
  end;

type
  PRecInfo = ^TRecInfo;
  TRecInfo = record
    Index: Integer;
    Row: TResultRow;
    Bookmark: Longint;
    BookmarkFlag: TBookmarkFlag;
  end;

implementation

procedure TlsBaseDataSet.InternalInitFieldDefs;
var i: Integer;
    ft: TFieldType;
    dt: TSQLDataTypes;
    fs: Integer;
    fn: String;
begin
  // field definitions
  FieldDefs.Clear;
  if Assigned(FResultSet) then
    begin
      //all as string now (first make it work, right? Then make it work right.)
      for i := FFieldOffset to FResultSet.FFields.Count - 1 do
        begin
          fs :=0;
          //convert field type:
          dt := FResultSet.FieldType [i];
          case dt of
            dtEmpty: ft := ftUnknown;
            //dtNull is sometimes reported if column type is unknown (typically sqlite)
            dtNull: begin ft := ftString; fs := FReportedStringLength; end;
            dtTinyInt,
            dtInteger: ft := ftInteger;
            dtInt64: begin ft := ftString; fs := 22; end; //TDataSet not supports int64 (?)
            dtFloat: ft := ftFloat;
            dtCurrency: ft := ftCurrency;
            dtDateTime,
            dtTimeStamp: ft := ftDateTime;
            dtWideString: begin ft := ftString; fs := FReportedStringLength; end;
            dtBoolean: ft := ftBoolean;
            dtString:  begin ft := ftString; fs := FReportedStringLength; end;
            dtBlob:    ft := ftBlob;
            dtOther,
            passql.dtUnknown: ft := ftUnknown;
          else
            ft := ftUnknown;
          end;
          //setting 0 as data size seems legal (assumed it is < dsMaxStringSize)
          //however, to allow editing we must supply a (max) length for string-typed fields.
          //for other types (integer, float etc) with fixed size
          //it is even _illegal_ to specify size. spoken about consistency...
          //please note that TDataSet is flexible enough to allow
          //strings larger than reported string size to be read.
          //However, those can not successfully be edited (...)
          fn := FResultSet.FFields[i];
          while FieldDefs.IndexOf(fn)>=0 do
            fn := fn + '_';
          FieldDefs.Add(fn, ft, fs);
        end;
    end;
end;

function TlsBaseDataSet.GetFieldData (
  Field: TField; Buffer: Pointer): Boolean;
var
  row: TResultRow;
  Bool1: WordBool;
  strAttr: string;
  t: TDateTimeRec;
  vString: String;
  vInteger: Integer;
  vFloat: Double;
  vBoolean: Boolean;
  FieldIndex: Integer;
begin
  //row := FResultSet.Row [PRecInfo(ActiveBuffer).Index];
  row := PRecInfo(ActiveBuffer).Row;
  if not Assigned(row) then
    begin

      Result := False;
      exit;

      //Inserting / appending a record

    end;
  FieldIndex := FFieldOffset + Field.Index;

  Result := True;
  case Field.DataType of
    ftString:
      begin
        vString := row[FieldIndex];
        //Move (s, Buffer^, Length(s));
        if Length (vstring) > dsMaxStringSize then
          //truncate (sorry..)
          SetLength (vString, dsMaxStringSize);
        StrCopy (Buffer, pchar(vString));
      end;
    ftInteger:
      begin
        vInteger := row.Format [FieldIndex].AsInteger;
        Move (vInteger, Buffer^, sizeof (Integer));
      end;
    ftBoolean:
      begin
        vBoolean := row.Format [FieldIndex].AsBoolean;
        Move (vBoolean, Buffer^, sizeof (WordBool));
      end;
    ftFloat:
      begin
        vFloat := row.Format [FieldIndex].AsFloat;
        Move (vFloat, Buffer^, sizeof (Double));
      end;
  else
    Result := False;
  end;
end;



function TlsBaseDataSet.AllocRecordBuffer: PChar;
begin
  Result := StrAlloc(fRecordSize);
end;

procedure TlsBaseDataSet.InternalInitRecord(Buffer: PChar);
begin
  FillChar(Buffer^, FRecordSize, 0);
  //PRecInfo(Buffer).Row := FResultSet.FNilRow;
end;

procedure TlsBaseDataSet.FreeRecordBuffer (var Buffer: PChar);
begin
  StrDispose(Buffer);
end;

procedure TlsBaseDataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  PInteger(Data)^ := PRecInfo(Buffer).Bookmark;
end;

function TlsBaseDataSet.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer).BookmarkFlag;
end;

function TlsBaseDataSet.GetRecNo: Integer;
begin
  Result := FCurrent + 1;
end;

function TlsBaseDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
begin
  Result := grError;
  if not Assigned (FResultSet) then
    exit;
  Result := grOK; // default
  case GetMode of
    gmNext: // move on
      if FCurrent < FResultSet.FRowCount - 1 then
        Inc (fCurrent)
      else
        Result := grEOF; // end of file
    gmPrior: // move back
      if FCurrent > 0 then
        Dec (fCurrent)
      else
        Result := grBOF; // begin of file
    gmCurrent: // check if empty
      if fCurrent >= FResultSet.FRowCount then
        Result := grEOF;
  end;

  if Result = grOK then // read the data
    with PRecInfo(Buffer)^ do
    begin
      Index := fCurrent;
      Row := FResultSet.Row [FCurrent];
      BookmarkFlag := bfCurrent;
      Bookmark := fCurrent;
    end;
end;

function TlsBaseDataSet.GetRecordCount: Integer;
begin
  Result := FResultSet.FRowCount;
end;

function TlsBaseDataSet.GetRecordSize: Word;
begin
  Result := SizeOf(TRecInfo); //4; // actual data without house-keeping
end;

procedure TlsBaseDataSet.InternalAddRecord(Buffer: Pointer;
  Append: Boolean);
begin
  // todo: support adding items
end;

procedure TlsBaseDataSet.InternalClose;
begin
  // disconnet and destroy field objects
  BindFields (False);
  if DefaultFields then
    DestroyFields;
  // closed
  FDatabaseOpen := False;
end;



procedure TlsBaseDataSet.InternalFirst;
begin
  FCurrent := 0;
end;

procedure TlsBaseDataSet.InternalGotoBookmark(Bookmark: Pointer);
begin
  if (Bookmark <> nil) then
    FCurrent := Integer (Bookmark);
end;

procedure TlsBaseDataSet.InternalHandleException;
begin
  Application.HandleException(Self);
end;

procedure TlsBaseDataSet.InternalLast;
begin
  FCurrent := FResultSet.FRowCount - 1;
end;

procedure TlsBaseDataSet.InternalOpen;
begin
  FDatabaseOpen := False;

  // initialize some internal values:
  FRecordSize := sizeof (TRecInfo);
  FCurrent := -1;
  BookmarkSize := sizeOf (Integer);

  //TSQLDB database active is needed:
  if Assigned (FDatabase) then
    begin
      FDatabase.Active := True;
      //FIsTableOpen := FDatabase.Active;
      if not FDatabase.Active then
        exit;
    end
  else
    exit;

  // initialize field definitions and create fields


  // read directory data
  //ReadListData;
  //Only active if this query is valid:
  FDatabaseOpen := FResultSet.Query(FInternalQuery);


  if FDatabaseOpen then
    begin
      //create our fielddefs
      InternalInitFieldDefs;
      //obliged TDataSet call
      if DefaultFields then
        CreateFields;
      //Bind our defined fields:
      BindFields (True);
    end;

end;

procedure TlsBaseDataSet.InternalPost;
begin

end;

procedure TlsBaseDataSet.InternalSetToRecord(Buffer: PChar);
begin
  FCurrent := PRecInfo(Buffer).Index;
end;

function TlsBaseDataSet.IsCursorOpen: Boolean;
begin
  Result := FDatabaseOpen;
end;

procedure TlsBaseDataSet.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  PRecInfo(Buffer).Bookmark := PInteger(Data)^;
end;

procedure TlsBaseDataSet.SetBookmarkFlag(Buffer: PChar;
  Value: TBookmarkFlag);
begin
  PRecInfo(Buffer).BookmarkFlag := Value;
end;

procedure TlsBaseDataSet.SetRecNo(Value: Integer);
begin
  if (Value < 0) or (Value > FResultSet.FRowCount) then
    raise Exception.Create ('Record number out of range');
  FCurrent := Value - 1;
end;

constructor TlsBaseDataSet.Create(Owner: TComponent);
begin
  inherited;
  //create 'dummy' sets here to avoid errors on unexpected/out of sequence calls.
  FResultSet := TResultSet.Create(nil);
  FHelperSet := TResultSet.Create(nil);
  FReportedStringLength := 42;
end;

destructor TlsBaseDataSet.Destroy;
begin
  inherited;
  if Assigned (FResultSet) then
    FResultSet.Free;
  if Assigned(FHelperSet) then
    FHelperSet.Free;
end;

procedure TlsBaseDataSet.SetDatabase(const Value: TSqlDB);
begin
  FDatabase := Value;
  if Assigned (FResultSet) then
    FResultSet.Free;
  if Assigned(FHelperSet) then
    FHelperSet.Free;
  FResultSet := TResultSet.Create(Value);
  FHelperSet := TResultSet.Create(value);
end;

procedure TlsBaseDataSet.SetReportedStringLength(const Value: Integer);
begin
  FReportedStringLength := Value;
end;

end.
