unit passql;

{$IFDEF FPC}
{$MODE DELPHI}              
{$H+}
{$ENDIF}

{$IFDEF LINUX}
{$DEFINE UNIX}
{$ENDIF}

{$IFNDEF UNIX}
{$DEFINE WIN32}
  {$IFNDEF FPC}
  {$DEFINE DELPHI}
  {$ENDIF}
{$ENDIF}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  Classes, SysUtils,
  {$IFNDEF VER130} //Delphi 5
  {$IFNDEF VER120} //Delphi 4
  { $ IFNDEF VER110} //BCB 3 - not sure if it compiles at all.
  {$IFNDEF VER100} //Delphi 3
  Variants,
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  sqlsupport, utf8util, SyncObjs
  {$IFDEF VER150} //and up, not needed, function is in sqlsupport as well
  , strutils
  {$ENDIF}
  ;

{$I libsqlversion.inc}


  NaN = {$IFNDEF FPC}0.0 / 0.0{$ELSE}nil{$ENDIF}; //Not A Number; a special float.
  VarIntTypes =
    {$IFDEF VER130} //delphi 5..
      [ varSmallInt, varInteger, varByte];
    {$ELSE}
      [varShortInt, varSmallInt, varInteger, varByte, varWord, varLongword, varInt64];
    {$ENDIF}

type
  TSQLDataTypes = (
    dtEmpty,
    dtNull,
    dtTinyInt,
    dtInteger,
    dtInt64,
    dtFloat,
    dtCurrency,
    dtDateTime,
    dtTimeStamp,
    dtWideString,
    dtBoolean,
    dtString,
    dtBlob,
    dtOther,
    dtUnknown
  );

  //used for dump table/database and showcreatetable functions
  TDumpTarget = (dt_TestOnly, dt_String, dt_File, dt_Stream, dt_Strings);

  TDumpTargets = set of TDumpTarget;

  TFieldDesc = class
    name: String;
    table: String;
    def: String; //database specific
    _datatype: Byte; //database specific
//    length: Integer; MySQL per-cell based info, ignore...
    max_length: Integer; //~= size
    flags: Integer; //database specific
    decimals: Integer; //database specific
    datatype: TSQLDataTypes;
    Required: Boolean;
    digits: Integer;
    //cross-database if available
    IsNumeric, //non-float(!)
    IsAutoIncrement,
    IsPrimaryKey,
    IsKey,
    IsUnique,
    IsBlob,
    IsUnsigned,
    IsNullable: Boolean;
  end;

  TSQLDB = class;

  TResultCell = class (TObject)
  private
    function GetWideString: WideString;
  protected
    FValue:String;
    FWideValue: WideString;
    FIsNull:Boolean;
    FValidValue: Boolean;
    function GetInteger:Int64;
    function GetFloat:Extended;
    function GetBoolean:Boolean;
    function GetSQLDateTime: TDateTime;                                            //Dak_Alpha
    function GetSQLTime: TDateTime;                                                //Dak_Alpha
  public
    property IsNull:Boolean read FIsNull;
    property AsString:String read FValue;
    property AsWideString: WideString read GetWideString;
    property AsInteger:Int64 read GetInteger;
    property AsBoolean:Boolean read GetBoolean;
    property AsFloat:Extended read GetFloat;
    //This my properties can solve problem with working with date and time
    //in results. Now you can get as result Tdatetime and not string and you
    //dont must convert thist string manuly.
    //It requires that the date be represented in strict format
    // yyyy-mm-dd [hh:nn[:ss[:mmm]]]
    property AsSQLDateTime: TDateTime read GetSQLDateTime;                         //Dak_Alpha
    //It requires that the date be represented in strict format
    // hh:nn[:ss[:mmm]]
    property AsSQLTime: TDateTime read GetSQLTime;                                 //Dak_Alpha
//    property AsVariant:Variant read FValue;                                      
    property ValidValue: Boolean read FValidValue;
  end;

  TResultRow = class (TStringList)
  private
    function GetMemoryStream(Index: Variant): TMemoryStream;
  protected
  public //i'd prefer to have this private or protected, but thats impossible right now...
    FNulls:TList;
    FResultCell:TResultCell;
    FFields:TStrings;
    FNameValue:TStrings;
    FWideStrings: TStrings;
    function GetString (i:Variant):String;
    function GetResultCell (i:Variant):TResultCell;
    function GetIsNull (i:Variant):Boolean;
    function GetByField (Value: String):TResultCell;
    function GetAsNameValue:TStrings;
    function GetFieldsAsTabSep: String;
    function GetAsTabSep: String;
    function GetStringW (i: Variant): WideString;
    function Add (const Value: String): Integer; override;
    procedure AddW(Value: WideString);
    function GetColCount: Integer;
    function GetVariant (i: Variant): Variant;
    function FieldIndex (Value: Variant): Integer;

    procedure Clear; override;
//public
    constructor Create;
    destructor  Destroy; override;
    //override Strings property to customize behavior
    //note:
    //property Strings isn't listed, because it doesn't need to be overriden. but it can do so.
    property Columns[Index: Variant]: Variant read GetVariant; default;
    property AsString[Index:Variant]:String read GetString;
    property Wide[Index:Variant]:WideString read GetStringW;
    property Format[Index:Variant]:TResultCell read GetResultCell;
    property IsNull[i:Variant]:Boolean read GetIsNull;
    property ByField[Value:String]:TResultCell read GetByField;
    //Return TMemoryStream object. Applicable to Blob field or Clob field etc.     //Dak_Alpha
    property AsMemoryStream[Index:Variant]: TMemoryStream read GetMemoryStream;    //Dak_Alpha
    property Fields:TStrings read FFields;
    property AsTabSep: String read GetAsTabSep;
    property FieldsAsTabSep: String read GetFieldsAsTabSep;
    property AsNameValue:TStrings read GetAsNameValue;
    property ColCount: Integer read GetColCount;
  end;

  TResultSet = class (TObject)
  private
    FAutoFree: Boolean;
    function GetErrorMessage: string;                                              //Dak_Alpha
  protected
    FFetchedRow: TResultRow; //never create, it is pointer to existing row
    function GetFieldName(Index: Integer): String;
    function GetFieldType(Index: Variant): TSQLDataTypes;
    function GetFieldDescriptor(Index: Variant): TFieldDesc;
    function GetFieldTypeName(Index: Variant): String;
    function FieldExists(Fieldname: String): Boolean;
  public //TPersistant?
    //all those should be protected
    SQLDB: TSQLDB;
    FRowCount: Integer;
    FColCount: Integer;
    FLastInsertID:Int64;
    FRowsAffected: Int64;
    FRowList: TList;
    FFields: TStringList;
    FDataBase: String;
    FNilRow : TResultRow;
    FCurrentRow: TResultRow;
    FSQL: String;
    FQuerySize:Integer;
    FCallbackOnly:Boolean;
    FLastError:Integer;
    FHasResult:Boolean;
    FLastErrorText:String;
    FResultAsStrings: TStrings;
    FName: String;
    FStmt: THandle;

    constructor Create (DB: TSQLDB=nil);
    destructor Destroy; override;
    procedure Refresh; //Refreshes last SQL query.
    procedure Clear; //Cleans up
    function GetResultRow(Index: Integer): TResultRow;
    function FieldIndex (Value: Variant): Integer;


    function Query (SQL:String):Boolean;
    function QueryW (SQL: WideString): Boolean;

    function  FormatQuery (Value: string; const Args: array of const): Boolean;
    function  FormatQueryW (Value: WideString; const Args: array of const): Boolean;

    function  Execute (SQL: String): Boolean;
    function  ExecuteW (SQL: WideString): Boolean;

    function FormatExecute (SQL: String; const Args: array of const):Boolean; virtual;
    function FormatExecuteW (SQL: WideString; const Args: array of const): Boolean; virtual;

    function  FetchRow: Boolean;
    function  FetchRowW: Boolean;

    procedure FreeResult;

    //use Row to access results of a Query method
    property Row[Index: Integer]: TResultRow read GetResultRow;
    //Use Fetched te access one row using the execute method
    property Fetched:TResultRow read FFetchedRow;

    //This works confusing and will only lead to errors.
    //property Results:TResultRow read FFetchedRow;

    //Usefull for external ResulSet objects
    procedure AttachToDB(DB: TSQLDB);                                              //Dak_Alpha
    procedure DetachFromDB;                                                        //Dak_Alpha
    property AutoFree: Boolean read FAutoFree write FAutoFree;                     //Dak_Alpha

    property FieldName[Index: Integer]: String read GetFieldName;
    property FieldType[Index: Variant]: TSQLDataTypes read GetFieldType;
    property FieldTypeName[Index: Variant]: String read GetFieldTypeName;
    property FieldDescriptor[Index: Variant]: TFieldDesc read GetFieldDescriptor;

    property ErrorMessage: string read GetErrorMessage;                            //Dak_Alpha
    property RowCount: Integer read FRowCount;                                     //Dak_Alpha
    property ColCount: Integer read FColCount;                                     //Dak_Alpha
  end;

  TDatabaseInfo = class
    Name: String;
    Size: Int64;
    Tables: TStrings;
    Indexes: TStrings;
    constructor Create;
    destructor Destroy; override;
  end;

  TOnFetchRow = procedure (Sender: TObject; Row:TResultRow) of Object;
  TOnBeforeQuery = procedure (Sender: TObject; var SQL:String) of Object;

  //base class for sql interfaces
  TSQLDB = class (TComponent)
  private
    //equivalent to addresultset and deleteresultset
    //however, they don't create or free the result sets.
    //these methods are intended to be called by an instance of TResultSet
    procedure RegisterResultSet (ResultSet: TResultSet);
    procedure RemoveResultSet (ResultSet: TResultSet);
    procedure SetThreadSafe(const Value: Boolean);
  protected
    //may or may not be used for specific DB engines, it's common anyhow
    FActive:Boolean;
    FActivateOnLoad:Boolean;
    FThreadSafe: Boolean;
    FHost:String;
    FPort:Integer;
    FUser:String;
    FPass:String;
//    FThreaded: Boolean;
    //typical behaviour for all DB:

    FDataBase: String;
    FDatabaseInfo: TStrings;
    FSetNameCount: Integer;

    FSQL: String;
    FResultSet: String;
    FLibraryPath: String;
    FTables: TStrings;
    FIndexes: TStrings;

    FCurrentSet: TResultSet;
    FResultSets: TStringList;
    FCallBackOnly: Boolean;

    FDummyString:String;
    FDummyBool:Boolean;
    FFetchRowLimit:Integer;
    FFetchMemoryLimit:Integer;
    FDllLoaded:Boolean;
    FDataBaseType: TDBMajorType;
    FDataBaseSubType: TDBSubType;
    FCSLock: TCriticalSection;
    FErrorLog: TFileName;
//    FMaxQuerySize:Integer;

    //The events
    FOnFetchRow:TOnFetchRow;
    FOnQueryComplete:TNotifyEvent;
    FOnError:TNotifyEvent;
    FOnBeforeQuery:TOnBeforeQuery;
    FOnSuccess:TNotifyEvent;
    FOnOpen:TNotifyEvent;
    FOnClose:TNotifyEvent;



    procedure DoQuery (SQL:String);

    procedure DumpInit;
    procedure DumpWrite (Line:String);
    procedure DumpFinal;

    procedure LogError;
    procedure ClearAllResultSets;

    procedure SetLibraryPath(const Value: String);
    procedure SetIndexes(const Value: TStrings);
    procedure SetTables(const Value: TStrings);

    function GetLibraryPath: String;
    function GetIndexes: TStrings;
    function GetTables: TStrings;

    function GetDBInfo (DB: String): TDatabaseInfo;
    function GetLastError: Integer;
    procedure SetResultSet(const Value: String);

    procedure FillDBInfo; virtual;

  public
    (*  Only virtual procedures may be database specific
        for some functions prototypes exists that does not need overriden*)

    FVersion:String;
    FEncoding:String;

    FDumpTargets : TDumpTargets;
    FDumpType:TDBMajorType;
    FDumpString: String;
    FDumpFile: TFileName;
    FDumpStream: TStream;
    FDumpFileStream:TStream;
    FDumpStrings: TStrings;

    FUniCode: Boolean;

    PrimaryKey: String;

    procedure RefreshDBInfo;

    function Execute (SQL: String): THandle; virtual; abstract;
    function ExecuteW (SQL: WideString): THandle; virtual;

    function FetchRow (Handle: THandle; var row: TResultRow): Boolean; virtual; abstract;
    function FetchRowW (Handle: THandle; var row: TResultRow): Boolean; virtual;

    procedure FreeResult (Handle: THandle); virtual; abstract;

    function BindExecute (SQL: String; const Args: array of const):THandle; virtual;
    function BindExecuteW (SQL: WideString; const Args: array of const): THandle; virtual;

    function FormatExecute (SQL: String; const Args: array of const):THandle; virtual;
    function FormatExecuteW (SQL: WideString; const Args: array of const): THandle; virtual;

    procedure Lock; virtual;
    procedure Unlock; virtual;

    function Query (SQL:String):Boolean; virtual; abstract; //must override;
    function QueryW (SQL: WideString): Boolean; virtual;

    function Connect (Host, User, Pass:String; DataBase:String=''):Boolean; virtual; abstract;
    function ConnectW (Host, User, Pass:String; DataBase:WideString=''):Boolean; virtual;

    procedure Close; virtual;
    function Use (Database:String):Boolean; virtual;
    function UseW (Database: WideString): Boolean; virtual;
    procedure StartTransaction; virtual;
    procedure Commit; virtual;
    procedure Rollback; virtual;
    function GetErrorMessage:String; virtual;

    //typical mysql
    procedure SetDataBase (Database:String); virtual;
    procedure SetDataBaseW (Database: WideString); virtual;
    procedure SetPort (Port:Integer); virtual;

    //all these functions call query or operate on a Query result set.
    function  QueryOne (SQL:String):String;
    //comment this out if not supported by compiler:
    class function DatabaseType (DB: TSQLDB): TDBMajorType;
    class procedure _FormatSql(var sql: String; var sqlw: WideString; Value: String; const Args: array of const; Wide: Boolean; DBType: TDBMajorType);
    function FormatSql (Value: String; const Args: array of const): String;
    function FormatSqlW (Value: String; const Args: array of const): WideString;

    function  _FormatQuery (Value: string; const Args: array of const; Wide: Boolean=False):Boolean;
    function  FormatQuery (Value: string; const Args: array of const): Boolean;
    function  FormatQueryW (Value: WideString; const Args: array of const): Boolean;
    procedure Clear; //clean up results

    function  GetField (I:Integer):String;
    function GetFieldCount:Integer;
    function  GetOneResult:String;
    function  GetResult(I:Integer):TResultRow;
    function GetResultFromColumnName(Field: String): TResultRow;
    function QueryStrings (SQL:String; Strings:TStrings):Boolean;
    procedure SetActive (DBActive:Boolean);

    //Additional support routines to get result in specific format
    function GetResultAsText:String; //Tab-seperated
    function GetResultAsHTML:String; //HTML table
    function GetResultAsCS:String; //Comma seperated
    function GetResultAsStrings:TStrings; //TStrings, one row per line, tab seperated
//      function GetOneColumnAsStrings:TStrings; //First column as strings
//      function GetOneRowAsStrings:TStrings; //First row as strings, with fieldnames
    function GetColumnAsStrings (Index: Integer = 0): TStrings;

    //support functions, database specific:
    //please, remember to set FDumpTargets and optionally FDumpType first.
    function ExplainTable (Table:String): Boolean; virtual; abstract;
    function ShowCreateTable (Table:String): Boolean; virtual; abstract;
    function DumpTable (Table:String): Boolean; virtual; abstract;
    function DumpDatabase (Table:String): Boolean; virtual; abstract;
    function ShowTables: Boolean; virtual; abstract;
    function Flush (Option:String): Boolean; virtual;
    function TruncateTable (Table:String): Boolean; virtual;
    function LockTables (Statement:String): Boolean; virtual;
    function UnLockTables: Boolean; virtual;
    function Vacuum: Boolean; virtual;

    //property support functions
    function GetRowsAffected: Int64;
    function GetRowCount: Integer;
    function GetLastInsertID: Int64;
    function GetCurrentResult: TResultSet;

    //Selects, adds if necessary
    function UseResultSet (Name: String): TResultSet; overload;
    function UseResultSet (Value: Integer): TResultSet; overload;
    function UseResultSet (rset: TResultSet): TResultSet; overload;

    //add if not exist:
    function AddResultSet (Name: String): TResultSet;

    //if exists, returns set else nil
    function ExistResultSet (Name: String): TResultSet;

    function DeleteResultSet (Name: String): Boolean; overload;
    function DeleteResultSet (Value: Integer): Boolean; overload;

    function InsertResultsetIntoTable (Table: String; ResultSet: TResultSet; CreateNewTable: Boolean=False): Boolean;

    procedure ClearResultSets;

    function SetNameFromInt (Value: Integer): String;
    function UniqueSetName: String;


    procedure Loaded; override;
    constructor Create (AOwner:TComponent); override;
    destructor  Destroy; override;

    property Results[Index: Integer]:TResultRow read GetResult; default;
    property Column [Field: String]: TResultRow read GetResultFromColumnName;
    property Fields [Index:Integer]:String read GetField;
    property LastError:Integer read GetLastError;
    property ErrorMessage:String read GetErrorMessage;
  published
    //result set based:
    property CurrentResult: TResultSet read GetCurrentResult;
    property RowsAffected:Int64 read GetRowsAffected;
    property RowCount:Integer read GetRowCount;
    property LastInsertID:Int64 read GetLastInsertID;

    property Active:Boolean read FActive write SetActive;
    property DllLoaded:Boolean read FDLLLoaded write FDummyBool;
    property LibraryPath: String read FLibraryPath write SetLibraryPath;
    property Tables: TStrings read GetTables write SetTables;
    property Indexes: TStrings read GetIndexes write SetIndexes;
    property DataBase:String read FDataBase write SetDataBase;
    property SQL:String read FSQL write DoQuery;
    property Host:String read FHost write FHost;
    property Port:Integer read FPort write SetPort;
    property User:String read FUser write FUser;
    property Password:String read FPass write FPass;

    property Result:String read GetOneResult;

    property UniCode: Boolean read FUniCode write FUniCode;
    property CallBackOnly:Boolean read FCallBackOnly write FCallBackOnly;

    property ColCount:Integer read GetFieldCount;
    property FieldCount:Integer read GetFieldCount;

    property FetchRowLimit:Integer read FFetchRowLimit write FFetchRowLimit default 0;
    property FetchMemoryLimit:Integer read FFetchMemoryLimit write FFetchMemoryLimit default 0; //2*1024*1024; //2Mb       //Events:

    property ServerVersion:String read FVersion write FDummyString;
    property ServerEncoding:String read FEncoding write FDummyString;

    property ResultAsText:String read GetResultAsText; //Tab-seperated
    property ResultAsHTML:String read GetResultAsHTML; //HTML table
    property ResultAsCommaSeperated:String read GetResultAsCS; //Comma seperated
//  property ResultAsStrings:TStrings read GetResultAsStrings; //TStrings, one row per line, tab seperated

    property ResultSet: String read FResultSet write SetResultSet;

    property ErrorLog: TFileName read FErrorLog write FErrorLog;
    property ThreadSafe: Boolean read FThreadSafe write SetThreadSafe;

    property OnFetchRow:TOnFetchRow read FOnFetchRow write FOnFetchRow;
    property OnQueryComplete:TNotifyEvent read FOnQueryComplete write FOnQueryComplete;
    property OnError:TNotifyEvent read FOnError write FOnError;
    property OnBeforeQuery:TOnBeforeQuery read FOnBeforeQuery write FOnBeforeQuery;
    property OnOpen:TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose:TNotifyEvent read FOnClose write FOnClose;
    property OnSuccess:TNotifyEvent read FOnSuccess write FOnSuccess;
  end;

implementation

{ TDatabaseInfo }

constructor TDatabaseInfo.Create;
begin
  inherited;
  Tables := TStringList.Create;
  Indexes := TStringList.Create;
end;

destructor TDatabaseInfo.Destroy;
begin
  Tables.Free;
  Indexes.Free;
  inherited;
end;

{ TResultCell }

function TResultCell.GetInteger: Int64;
begin
  Result := StrToInt64Def (FValue, 0);
end;

function TResultCell.GetFloat: Extended;
begin
  try
    Result := StrToFloat (StringReplace (FValue, '.', DecimalSeparator, []));
  except
    Result := 0;
  end;
end;

function TResultCell.GetBoolean: Boolean;
begin
  Result := (not FIsNull) and
            (FValue<>'') and
            (
                (
                  (FValue<>'0') and
                  (lowercase(FValue)<>'false') and
                  (lowercase(FValue)<>'n')
                )
              or
               (lowercase(FValue)='true')
            );
end;

// DateTime support by Dak_Alpha..
function TResultCell.GetSQLDateTime: TDateTime;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  Pos1, Pos2: Word;
  TmpValue: string;
begin
// It requires that the date be in strict yyyy-mm-dd [hh:nn[:ss[:mmm]]]
  Result := 0;
  TmpValue := Trim(FValue);

  try

    //Get Year
    Pos1 := 1;
    Pos2 := PosEx('-',TmpValue);
    if Pos2 = 5 then
      Year := StrToInt(Copy(TmpValue,Pos1,Pos2-1))
    else
      Exit;

    //Get Month (unofficially respect format yyyy-m-d [h:n[:s[:m]]] too)
    Pos1 := Pos2+1;
    Pos2 := PosEx('-',TmpValue,Pos1);
    if (Pos2-Pos1) in [1..2] then
      Month := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1))
    else
      Exit;
    Delete(TmpValue,1,Pos2);

    //Get Day
    if Length(TmpValue)>2 then
    begin
      Pos1 := 1;
      Pos2 := PosEx(' ',TmpValue);
      if (Pos2-Pos1) in [1..2] then
        Day := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1))
      else
        Exit;

      //Get Hour
      Pos1 := Pos2+1;
      Pos2 := PosEx(':',TmpValue,Pos1);
      if (Pos2-Pos1) in [1..2] then
        Hour := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1))
      else
        Exit;

      //Get Minuts
      Delete(TmpValue,1,Pos2);
      if Length(TmpValue)>2 then
      begin
        Pos1 := 1;
        Pos2 := PosEx(':',TmpValue);
        if Pos2 = Length(TmpValue) then Exit;
        if (Pos2-Pos1) in [1..2] then
          Min := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1))
        else
          Exit;

        //Get Second
        Delete(TmpValue,1,Pos2);
        if Length(TmpValue)>2 then
        begin
          Pos1 := 1;
          Pos2 := PosEx(':',TmpValue);
          if Pos2 = Length(TmpValue) then Exit;
          if (Pos2-Pos1) in [1..2] then
            Sec := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1))
          else
            Exit;

          //Get milisecond
          Delete(TmpValue,1,Pos2);
          if Length(TmpValue) in [1..3] then
          begin
            Pos1 := 1;
            Pos2 := Length(TmpValue)+1;
            if (Pos2-Pos1) in [1..3] then
            begin
              while Pos2<4 do
              begin
                TmpValue := TmpValue + '0';
                Inc(Pos2);
              end;
              MSec := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1));
              Result := EncodeDate(Year,Month,Day) + EncodeTime(Hour,Min,Sec,MSec);
            end
            else
              Exit;
          end
          else
            Result := EncodeDate(Year,Month,Day) + EncodeTime(Hour,Min,Sec,0);

        end
        else
        begin
          //Get sec if sec is last value
          Pos1 := 1;
          Pos2 := Length(TmpValue)+1;
          if Pos2>1 then
          begin
            Sec := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1));
            Result := EncodeDate(Year,Month,Day) + EncodeTime(Hour,Min,Sec,0);
          end;
        end;

      end
      else
      begin
        //Get min if min is last value
        Pos1 := 1;
        Pos2 := Length(TmpValue)+1;
        if Pos2>1 then
        begin
          Min := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1));
          Result := EncodeDate(Year,Month,Day) + EncodeTime(Hour,Min,0,0);
        end;
      end;

    end
    else
    begin
      //Get day if day is last value
      Pos1 := 1;
      Pos2 := Length(TmpValue)+1;
      if Pos2>1 then
      begin
        Day := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1));
        Result := EncodeDate(Year, Month, Day);
      end;
    end;

  except
    Result := 0;
  end;
end;

// Dito (Time support by Dak_Alpha..)
function TResultCell.GetSQLTime: TDateTime;
var
  Hour, Min, Sec, MSec: Word;
  Pos1, Pos2: Word;
  TmpValue: string;
begin
// It requires that the time be in strict hh:nn[:ss[:mmm]]
// (unofficially respect format h:n[:s[:m]] too)
  Result := 0;
  TmpValue := Trim(FValue);

  try
    //Get Hour
    Pos1 := 1;
    Pos2 := PosEx(':',TmpValue,Pos1);
    if (Pos2-Pos1) in [1..2] then
      Hour := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1))
    else
      Exit;

    //Get Minuts
    Delete(TmpValue,1,Pos2);
    if Length(TmpValue)>2 then
    begin
      Pos1 := 1;
      Pos2 := PosEx(':',TmpValue);
      if Pos2 = Length(TmpValue) then Exit;
      if (Pos2-Pos1) in [1..2] then
        Min := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1))
      else
        Exit;

      //Get Second
      Delete(TmpValue,1,Pos2);
      if Length(TmpValue)>2 then
      begin
        Pos1 := 1;
        Pos2 := PosEx(':',TmpValue);
        if Pos2 = Length(TmpValue) then Exit;
        if (Pos2-Pos1) in [1..2] then
          Sec := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1))
        else
          Exit;

        //Get milisecond
        Delete(TmpValue,1,Pos2);
        if Length(TmpValue) in [1..3] then
        begin
          Pos1 := 1;
          Pos2 := Length(TmpValue)+1;
          if (Pos2-Pos1) in [1..3] then
          begin
            while Pos2<4 do
            begin
              TmpValue := TmpValue + '0';
              Inc(Pos2);
            end;
            MSec := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1));
            Result := EncodeTime(Hour,Min,Sec,MSec);
          end
          else
            Exit;
        end
        else
          Result := EncodeTime(Hour,Min,Sec,0);

      end
      else
      begin
        //Get sec if sec is last value
        Pos1 := 1;
        Pos2 := Length(TmpValue)+1;
        if Pos2>1 then
        begin
          Sec := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1));
          Result := EncodeTime(Hour,Min,Sec,0);
        end;
      end;

    end
    else
    begin
      //Get min if min is last value
      Pos1 := 1;
      Pos2 := Length(TmpValue)+1;
      if Pos2>1 then
      begin
        Min := StrToInt(Copy(TmpValue,Pos1,Pos2-Pos1));
        Result := EncodeTime(Hour,Min,0,0);
      end;
    end;
  except
    Result := 0;
  end;
end;

function TResultCell.GetWideString: WideString;
begin
  if FIsNull then
    Result := ''
  else
    begin
      if FWideValue<>'' then
        Result := FWideValue
      else
        //parse value as widestring
        Result := DecodeUTF8(FValue);
    end;
end;

{ TResultRow}

constructor TResultRow.Create;
begin
  inherited;
  FResultCell := TResultCell.Create;
  FNulls := TList.Create;
  FNameValue := TStringList.Create;
  FWideStrings := TStringList.Create;
end;

destructor TResultRow.Destroy;
var
  i: Integer;                                                                      //Dak_Alpha
begin
  //Destroy TMemoryStream objects if is assigned                                   //Dak_Alpha
  for i := 0 to Count-1 do                                                         //Dak_Alpha
  begin                                                                            //Dak_Alpha
    if Assigned(Objects[i]) then                                                   //Dak_Alpha
    begin                                                                          //Dak_Alpha
       Objects[i].Free;                                                            //Dak_Alpha
       Objects[i] := nil;                                                          //Dak_Alpha
    end;                                                                           //Dak_Alpha
  end;                                                                             //Dak_Alpha
  FResultCell.Free;
  FNulls.Free;
  FNameValue.Free;
  FWideStrings.Free;
  inherited;
end;

procedure TResultRow.Clear;
var
  i: Integer;                                                                      //Dak_Alpha
begin
  //Destroy TMemoryStream objects if is assigned                                   //Dak_Alpha
  for i := 0 to Count-1 do                                                         //Dak_Alpha
  begin                                                                            //Dak_Alpha
    if Assigned(Objects[i]) then                                                   //Dak_Alpha
    begin                                                                          //Dak_Alpha
       Objects[i].Free;                                                            //Dak_Alpha
       Objects[i] := nil;                                                          //Dak_Alpha
    end;                                                                           //Dak_Alpha
  end;                                                                             //Dak_Alpha
  inherited Clear;
  FNulls.Clear;
  FWideStrings.Clear;
  FNameValue.Clear;
  //FFields.Clear;
end;

procedure TResultRow.AddW(Value: WideString);
var s: String;
begin
  if Value='' then
    s:=''
  else
    begin
      SetLength (s, length(Value)*2);
      System.Move (Value[1], S[1], Length(S));
    end;
  FWideStrings.Add(S);
  //also put self in list of 'normal' strings.
  //yes, two times memory usage. sorry.
  //i'll rethink this part later
  //but for now we just need it.
  Add (EncodeUTF8(Value));
end;

function TResultRow.GetResultCell(i: Variant): TResultCell;
var idx: Integer;
begin
  with FResultCell do
    begin
      idx := FieldIndex (i);
      if (idx>=0) and (idx<count) then
        begin
          FValue := Strings[idx];
          FIsNull := Integer(FNulls[idx])<>0;
          FValidValue := True;
        end
      else
        begin
          FValue := '';
          FIsNull := True;
          FValidValue := False;
        end;
    end;
  Result := FResultCell;
end;

function TResultRow.GetString(i: Variant): String;
var idx: Integer;
begin
  idx := FieldIndex (i);
  if (idx>=0) and (idx<Count) then
    Result := Strings[idx]
  else
    Result := '';
end;

function TResultRow.GetStringW(i: Variant): WideString;
var s: String;
    idx: Integer;
begin
  //we have two options here.
  //either widestring is filled and we return that
  //or widestring is not, we return an utf-8 decoded version of strings.
  idx := FieldIndex (i);
  if FWideStrings.Count > 0 then
    begin
      if (idx>=0) and (idx<FWideStrings.Count) then
        begin
          s := FWideStrings[idx];
          SetLength (Result, length(s) div 2);
          if Result<>'' then
            System.move (s[1], Result[1], length(Result) * SizeOf(WideChar));
        end;
    end
  else
    Result := DecodeUTF8(GetString(idx));
end;

function TResultRow.GetByField(Value: String): TResultCell;
begin
  Result := GetResultCell (FFields.IndexOf (Value) );
end;

function TResultRow.GetIsNull(i: Variant): Boolean;
var idx: Integer;
begin
  idx := FieldIndex (i);
  if (idx>=0) and (idx<FNulls.Count) then
    Result := Integer(FNulls[idx])<>0
  else
    Result := True;
end;

function TResultRow.GetAsNameValue: TStrings;
var i:Integer;
begin
  Result := FNameValue;
  Result.Clear;
  if FFields.Count<>Count then
    exit; //this will be an empty set (nilrow)
  for i:=0 to Count - 1 do
    Result.Add(FFields[i]+'='+Strings[i])
end;



function TResultRow.GetAsTabSep: String;
var i: Integer;
begin
  Result := '';
  for i:=0 to ColCount - 2 do
    Result := Result + AsString[i] + #9;
  Result := Result + AsString[ColCount - 1];
end;

function TResultRow.GetFieldsAsTabSep: String;
var i: Integer;
begin
  Result := '';
  for i:=0 to FFields.Count - 2 do
    Result := Result + FFields[i]+#9;
  if FFields.Count > 0 then
  Result := Result + FFields[FFields.Count - 1];
end;

function TResultRow.GetColCount: Integer;
begin
  Result := FFields.Count;
end;

function TResultRow.GetVariant(i: Variant): Variant;
var r: TResultCell;
begin
  //i is numeric index or field name
  if (VarType(i) in VarIntTypes) then
    r := Format[i] //as column index
  else
    r := ByField[i]; //as field name
  //variants won't typecast from NULL to anything else  
  {f r.IsNull then
    Result := NULL
  else
  }
  Result := r.AsString;
end;

function TResultRow.FieldIndex(Value: Variant): Integer;
// var isString: Boolean;
begin
  //if value is Integer; return
  //else fetch index from field list
  if (VarType(Value) in varIntTypes) then
    Result := Value
  else
    Result := FFields.IndexOf (Value);
end;

function TResultRow.Add(const Value: String): Integer;
begin
  Result := inherited Add (Value);
  FWideStrings.Add ('');
end;


function TResultSet.FieldExists(Fieldname: String): Boolean;
begin
  Result := FFields.IndexOf (Fieldname) >= 0;
end;

function TResultSet.GetFieldName(Index: Integer): String;
begin
  if (Index>=0) and (Index<FFields.Count) then
    Result := FFields[Index]
  else
    Result := '';
end;

function TResultSet.GetFieldType(Index: Variant): TSQLDataTypes;
var i: Integer;
begin
  i := FieldIndex(Index);
  if (i>=0) and (i<FFields.Count) then
    Result := TFieldDesc(FFields.Objects[i]).Datatype
  else
    Result := dtEmpty;
end;

function TResultSet.GetFieldDescriptor(Index: Variant): TFieldDesc;
var i: Integer;
begin
  i := FieldIndex(Index);
  if (i>=0) and (i<FFields.Count) then
    Result := TFieldDesc(FFields.Objects[i])
  else
    Result := nil;
end;

function TResultSet.GetFieldTypeName(Index: Variant): String;
var dt: TSQLDataTypes;
begin
  dt := GetFieldType(Index);
  case dt of
    dtEmpty: Result := 'Empty';
    dtNull: Result := 'Null';
    dtTinyInt: Result := 'TinyInt';
    dtInteger: Result := 'Integer';
    dtInt64: Result := 'Int64';
    dtFloat: Result := 'Float';
    dtCurrency: Result := 'Currency';
    dtDateTime: Result := 'DateTime';
    dtTimeStamp: Result := 'TimeStamp';
    dtWideString: Result := 'WideString';
    dtBoolean: Result := 'Boolean';
    dtString: Result := 'String';
    dtBlob: Result := 'Blob';
    dtOther: Result := 'Other';
    dtUnknown: Result := 'Unknown';
  else //can never happen unless type TSQLDataTypes changes
    Result := '';
  end;
end;

function TResultRow.GetMemoryStream(Index: Variant): TMemoryStream;                //Dak_Alpha
var
  idx: Integer;
  tmpStream: TMemoryStream;
begin
  idx := FieldIndex (Index);
  if (idx>=0) and (idx<Count) then
    if Assigned(Objects[idx]) then
    begin
      TMemoryStream(Objects[idx]).Position := 0;
      Result := TMemoryStream(Objects[idx]);
    end
    else
    begin
      tmpStream := TMemoryStream.Create;
      tmpStream.Write(Strings[idx][1],Length(Strings[idx]));
      tmpStream.Position := 0;
      Objects[idx] := tmpStream;
      Result := tmpStream;
    end
  else
    Result := nil;
end;

{ TResultSet }

procedure TResultSet.Clear;
var i: Integer;
begin
  for i := 0 to FRowList.Count - 1 do
    TResultRow(FRowList[i]).Free;
  FRowList.Clear;
  //memory leak fix by Thomas Zangl:
  for i := 0 to FFields.Count - 1 do
    TFieldDesc(FFields.Objects[i]).Free;
  FFields.Clear;
  FRowCount := 0;
  FRowsAffected := 0;
  FLastInsertID := 0;
  FQuerySize := 0;
  FLastError := 0;
  FLastErrorText := '';
  FSQL := '';                                                                      //Dak_Alpha
end;

constructor TResultSet.Create(DB: TSQLDB=nil);
begin
  FRowList := TList.Create;
  FFields  := TStringList.Create;
  FNilRow  := TResultRow.Create;
  FNilRow.FFields := FFields;
  FCurrentRow := TResultRow.Create;
  FCurrentRow.FFields := FFields;
  SQLDB := db;
  if Assigned (SQLDB) then
    SQLDB.RegisterResultSet (Self);
end;

destructor TResultSet.Destroy;
begin
  Clear;
  FRowList.Free;
  FNilRow.Free;
  FCurrentRow.Free;
  FFields.Free;
  if Assigned (SQLDB) then
    SQLDB.RemoveResultSet (Self);
  inherited;
end;

//by Dak_Alpha...
procedure TResultSet.AttachToDB(DB: TSQLDB);                                       //Dak_Alpha
begin
  if Assigned (SQLDB) then
    SQLDB.RemoveResultSet(Self);

  SQLDB := DB;

  if Assigned(SQLDB) then
  begin
    SQLDB.RegisterResultSet(Self);
  end;
end;

//by Dak_Alpha...
procedure TResultSet.DetachFromDB;                                                 //Dak_Alpha
begin
  if Assigned (SQLDB) then
    SQLDB.RemoveResultSet(Self);

  SQLDB := nil;
end;

function TResultSet.FetchRowW: Boolean;
var TempSet: TResultSet;
begin
  if Assigned (SQLDB) then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (Self);
      SQLDB.CurrentResult.FCallbackOnly := True;
      Result := SQLDB.FetchRowW (FStmt, FFetchedRow);
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;

function TResultSet.FetchRow: Boolean;
var TempSet: TResultSet;
begin
  if Assigned (SQLDB) then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (Self);
      Result := SQLDB.FetchRow (FStmt, FFetchedRow);
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;

function TResultSet.ExecuteW(SQL: WideString): Boolean;
var TempSet: TResultSet;
begin
  FFetchedRow := FNilRow;
  if Assigned (SQLDB) and (FName<>'') then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (FName);
      FStmt := SQLDB.ExecuteW (SQL);
      Result := FStmt <> 0;
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;

function TResultSet.Execute(SQL: String): Boolean;
var TempSet: TResultSet;
begin
  FFetchedRow := FNilRow;
  if Assigned (SQLDB) and (FName<>'') then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (FName);
      FStmt := SQLDB.Execute (SQL);
      Result := FStmt <> 0;
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;

function TResultSet.FormatQuery(Value: string;
  const Args: array of const): Boolean;
var TempSet: TResultSet;
begin
  if Assigned (SQLDB) and (FName<>'') then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (FName);
      Result := SQLDB.FormatQuery (Value, Args);
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;

function TResultSet.FormatQueryW(Value: WideString;
  const Args: array of const): Boolean;
var TempSet: TResultSet;
begin
  if Assigned (SQLDB) and (FName<>'') then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (FName);
      Result := SQLDB.FormatQueryW (Value, Args);
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;

function TResultSet.GetResultRow(Index: Integer): TResultRow;
begin
  if (Index>=0) and (Index<FRowList.Count) then
    begin
      Result := TResultRow(FRowList[Index])
    end
  else
    Result := FNilRow;
end;

function TResultSet.Query(SQL: String): Boolean;
var TempSet: TResultSet;
begin
  if Assigned (SQLDB) and (FName<>'') then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (FName);
      Result := SQLDB.Query (SQL);
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;

function TResultSet.QueryW(SQL: WideString): Boolean;
var TempSet: TResultSet;
begin
  if Assigned (SQLDB){ and (FName<>'')} then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (Self);
      Result := SQLDB.QueryW(SQL);
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;

procedure TResultSet.Refresh;
begin
  SQLDB.Query (FSQL);
end;

function TResultSet.FieldIndex(Value: Variant): Integer;
begin
  if (VarType(Value) in varIntTypes) then
    Result := Value
  else
    Result := FFields.IndexOf (Value);
end;

//Dak_Alpha...
function TResultSet.GetErrorMessage: string;                                       //Dak_Alpha
begin
  if FLastErrorText <> '' then
    Result := FLastErrorText
  else
    Result := IntToStr (FLastError);
end;

{ TSQLDB }

procedure TSQLDB.DoQuery;  //procedure needed for SQL property
begin
  if not (csLoading in ComponentState) then
    Query (SQL);
end;

function TSQLDB.GetOneResult: String;
begin
  if (FCurrentSet.FRowCount >=1) and (FCurrentSet.FColCount >= 1) then
    Result := Results[0][0]
  else
    Result := '';
end;

function TSQLDB.QueryOne(SQL: String): String;
begin
  if Query (SQL) then
    Result := GetOneResult
  else
    Result := '';
end;

function TSQLDB.FormatQuery(Value: string; const Args: array of const): Boolean;
begin
  Result := _FormatQuery (Value, Args);
end;

function TSQLDB.FormatQueryW(Value: Widestring; const Args: array of const): Boolean;
begin
  //i've chosen to encode as utf-8 here (for Value, not for Args)
  //mostly, the query will not be big in size, but params may well be.
  //since Delphi lacks good WideString functions (like pos, copy etc)
  //i've chosen this approach.
  //i agree i'd favour native 16-bit handling
  //but as said: there are no string support functions for it yet. so..
  Result := _FormatQuery (EncodeUTF8(Value), Args, True);
end;

function TSQLDB._FormatQuery (Value: string; const Args: array of const; Wide: Boolean=False):Boolean;
var sql:String;
    sqlw: WideString;

begin
  //we could call the format function,
  //but we need to escape non-numerical values anyhow
  //open arrays are fun since they involve some compiler magic :)
  //Result := False;
  sql:='';
  sqlw := '';

  _FormatSQL (sql, sqlw, Value, Args, Wide, FDataBaseType);


  //We need to clear the result set!
  Query (''); //empty result set

  with FCurrentSet do
    begin
      //this function succeeds if some string contains a '%%'.. fixed
      FLastErrorText := 'Invalid format';
      FLastError := -1;
    end;

  if Wide then
    Result := QueryW(sqlw)
  else
    Result := Query (sql);
end;

function TSQLDB.GetField(i: Integer): String;
begin
  if (i>=0) and (i<FCurrentSet.FFields.Count) then
    Result := FCurrentSet.FFields[i]
  else
    Result := '';
end;

function TSQLDB.GetResult(i: Integer): TResultRow;
begin
  if (i>=0) and (i<FCurrentSet.FRowList.Count) then
    Result := TResultRow (FCurrentSet.FRowList[i])
  else
    Result := FCurrentSet.FNilRow;  //give back a valid pointer to an empty row
end;

function TSQLDB.QueryStrings(SQL: String; Strings: TStrings): Boolean;
var i:Integer;
begin
  Strings.Clear;
  Result := Query (SQL);
  if Result then
    begin
      for i:=0 to FCurrentSet.FRowCount-1 do
        Strings.Add(Results[i][0]);
    end;
end;

procedure TSQLDB.Loaded;
begin
  inherited;
  if FActivateOnLoad then
    SetActive(True);
end;

procedure TSQLDB.SetActive;
begin
  if (csLoading in ComponentState) and
     not (csDesigning in ComponentState) then
    begin
      FActivateOnLoad:=DBActive;
      exit;
    end;
  if DBActive and not FActive then
    Connect(FHost, FUser, FPass, FDataBase);
  if FActive and not DBActive then
    Close;
end;

//Some virtual prototypes
function TSQLDB.Use (DataBase:String):Boolean;
begin
  Result := Query ('USE '+DataBase);
end;

function TSQLDB.GetErrorMessage: String;
begin
  Result := FCurrentSet.ErrorMessage;                                              //Dak_Alpha
end;

procedure TSQLDB.StartTransaction;
begin
  //Lock;
  Query ('BEGIN'); //start transaction
end;

procedure TSQLDB.Commit;
begin
  Query ('COMMIT');
  //Unlock;
end;

procedure TSQLDB.Rollback;
begin
  Query ('ROLLBACK');
  //Unlock;
end;

procedure TSQLDB.SetDataBase(Database: String);
begin
  FDataBase := DataBase;
  if not (csLoading in ComponentState) then
    Use (DataBase);
end;

procedure TSQLDB.Close;
begin
  //Virtual
  FActive := False;
end;

//Additional output-generating functions:
function TSQLDB.GetResultAsText: String; //TAB-seperated
var i,j:Integer;
    v: String;
begin
  if FCurrentSet.FHasResult then
    begin
      Result:='';
      v:='';
      for i:=0 to RowCount - 1 do
        begin
          v := v +Results[i][0];
          for j:=1 to FieldCount - 1 do
            v:=v+#9+Results[i][j];
          v:=v+{$IFNDEF LINUX}#13+{$ENDIF}#10;
          if i mod 20=0 then
            begin
              Result := Result + v;
              v:='';
            end;
        end;
      Result := Result + v;
    end
  else
    Result := '';
end;

function TSQLDB.GetResultAsHTML: String; //TAB-seperated
var i,j:Integer;
begin
  if FCurrentSet.FHasResult then
    begin
      Result:='<TABLE>';
      for i:=0 to RowCount - 1 do
        begin
          Result:=Result+'<TR>'+Results[i][0];
          for j:=1 to FieldCount - 1 do
            begin
              Result:=Result+'<TD>'+Results[i][j]+'</TD>';
            end;
          Result:=Result+#13+#10;
        end;
      Result:=Result+'</TABLE>'+#13+#10;
    end
  else
    Result := '<!-- no result -->';
end;

function TSQLDB.GetResultAsCS: String;
var i,j:Integer;
begin
  if FCurrentSet.FHasResult then
    begin
      Result:='';
      for i:=0 to RowCount - 1 do
        begin
          Result:=Result+'"'+Results[i][0]+'"';

          for j:=1 to FieldCount - 1 do
            Result:=Result+', "'+Results[i][j]+'"';
          Result:=Result+{$IFNDEF LINUX}#13+{$ENDIF}#10;
        end;
    end
  else
    Result := '';
end;

function TSQLDB.GetResultAsStrings: TStrings;
var i:Integer;
begin
  with FCurrentSet do
    begin
      if not Assigned (FResultAsStrings) then
        FResultAsStrings := TStringList.Create;
      FResultAsStrings.Clear;
      if FHasResult then
        begin
          for i := 0 to RowCount - 1 do
            FResultAsStrings.Add (Results[i][0]);
        end;
      Result := FResultAsStrings;
    end;
end;

procedure TSQLDB.SetPort(Port: Integer);
begin
  FPort := Port;
end;

procedure TSQLDB.Clear;
var i:Integer;
begin
  with FCurrentSet do
    begin
      for i:=0 to FRowList.Count - 1 do
        TResultRow (FRowList[i]).Free;
      for i:=0 to FFields.Count - 1 do
        FFields.Objects [i].Free;
      FRowList.Clear;
      FFields.Clear;
      FRowCount := 0;
      FColCount := 0;
      FRowsAffected:=-1;
      FLastInsertID:=-1;
      FHasResult:=False;
    end;
end;

constructor TSQLDB.Create(AOwner: TComponent);
begin
  inherited;
  //info for current used database:
  FDatabaseInfo := TStringList.Create;
  //fill default db:
  GetDBInfo ('');

  //result sets
  FResultSets := TStringList.Create;
  FResultSets.Sorted := True;
  FCurrentSet := UseResultSet ('default');

  FFetchMemoryLimit := 32*1024*1024; //16MB
  FCSLock := TCriticalSection.Create;
  FThreadSafe := True; //enabled by default
  //5 digits to start:
  FSetNameCount := 10000;
end;

destructor TSQLDB.Destroy;
var i: Integer;
begin
  Active := False;
  Clear;
  FCSLock.Free;
  ClearAllResultSets;
  FResultSets.Free;
  for i := 0 to FDatabaseInfo.Count - 1 do
    FDatabaseInfo.Objects[i].Free;
  FDatabaseInfo.Free;
  inherited;
end;



function TSQLDB.GetFieldCount: Integer;
begin
  if FCurrentSet.FHasResult then
    Result := FCurrentSet.FFields.Count
  else
    Result := 0;
end;

procedure TSQLDB.DumpInit;
begin
  //clear results:
  FDumpString := '';
  FDumpFileStream := nil;
  if not Assigned (FDumpStrings) then
    FDumpStrings := TStringList.Create;
  FDumpStrings.Clear;
  if dt_File in FDumpTargets then
    try
      FDumpFileStream := TFileStream.Create (FDumpFile, fmOpenWrite or fmCreate);
    except
      FDumpFileStream := nil;
      FDumpTargets := FDumpTargets - [dt_File];
    end;
  if dt_Stream in FDumpTargets then
    //actually do nothing
    if not Assigned (FDumpStream) or
       not (FDumpStream is TStream) then
      FDumpTargets := FDumpTargets - [dt_Stream];
end;

procedure TSQLDB.DumpWrite(Line: String);
begin
  if dt_Strings in FDumpTargets then
    FDumpStrings.Add (Line);
  Line := Line + #13#10; //Line now always is <> ''
  if dt_String in FDumpTargets then
    FDumpString := FDumpString + Line;
  if dt_File in FDumpTargets then
    try
      FDumpFileStream.Write (Line[1], Length (Line));
    except end;
  if dt_Stream in FDumpTargets then
    try
      FDumpStream.Write (Line[1], Length(Line));
    except end;
end;

procedure TSQLDB.DumpFinal;
begin
  if dt_File in FDumpTargets then
    try  //allways be carefull with streams:
      FDumpFileStream.Free;
      FDumpFileStream := nil;
    except end;
end;


procedure TSQLDB.Lock;
begin
  if FThreadSafe then
    FCSLock.Enter;
end;

procedure TSQLDB.Unlock;
begin
  if FThreadSafe then
    FCSLock.Leave;
end;

procedure TSQLDB.LogError;
var f: TextFile;
begin
  if FErrorLog='' then
    exit;
  if LastError=0 then
    exit;
  {$I-}
  AssignFile (f, FErrorLog);
  if FileExists (FErrorLog) then
    Append (f)
  else
    Rewrite (f);
  writeln (f, 'Error on query '+SQL);  
  writeln (f, IntToStr(FCurrentSet.FLastError)+' '+FCurrentSet.FLastErrorText);

  CloseFile(f);
  {$I+}
end;

function TSQLDB.GetResultFromColumnName(Field: String): TResultRow;
begin
  Result := GetResult (FCurrentSet.FFields.IndexOf(Field));
end;

function TSQLDB.AddResultSet(Name: String): TResultSet;
var i: Integer;
begin
  Result := ExistResultSet(Name);
  if not Assigned(Result) then
    begin
      i := FResultSets.AddObject (Name, TResultSet.Create);
      Result := TResultSet(FResultSets.Objects[i]);
      Result.SQLDB := Self;
      Result.FName := Name;
      Result.FAutoFree := True;
    end;
end;

function TSQLDB.ExistResultSet(Name: String): TResultSet;
var i:Integer;
begin
  Result := nil;
  i := FResultSets.IndexOf (Name);
  if i>=0 then
    Result := TResultSet(FResultSets.Objects[i]);
end;

function TSQLDB.GetCurrentResult: TResultSet;
begin
  Result := FCurrentSet;
end;

function TSQLDB.GetLastError: Integer;
begin
  Result := FCurrentSet.FLastError;
end;

function TSQLDB.GetLastInsertID: Int64;
begin
  Result := FCurrentSet.FLastInsertID;
end;

function TSQLDB.GetRowCount: Integer;
begin
  Result := FCurrentSet.FRowCount;
end;

function TSQLDB.GetRowsAffected: Int64;
begin
  Result := FCurrentSet.FRowsAffected;
end;

function TSQLDB.UseResultSet(Name: String): TResultSet;
begin
  //just an alias
  if FResultSet <> Name then
  //current set is different
    begin
      FCurrentSet := AddResultSet(Name);
    end;
  Result := FCurrentSet;
  FResultSet := Name;
end;


function TSQLDB.QueryW(SQL: WideString): Boolean;
begin
  //Call Query using widestrings
  Result := Query (EncodeUTF8(SQL));
end;

procedure TSQLDB.SetDataBaseW(Database: WideString);
begin
  SetDatabase (EncodeUTF8(Database));
end;

function TSQLDB.UseW(Database: WideString): Boolean;
begin
  FUnicode := True;
  Result := Use (EncodeUTF8(DataBase));
end;

procedure TSQLDB.ClearAllResultSets;
var i: Integer;
begin
  for i:=FResultSets.Count - 1 downto 0 do
    //please take care
    //in TResultSet.Destroy
    //it removes itself from _this very queue (!)
    //counting down solves this.
    if TResultSet (FResultSets.Objects[i]).FAutoFree then
      TResultSet(FResultSets.Objects[i]).Free
    else
      //Inform resultset it has no owner anymore:
      TResultSet(FResultSets.Objects[i]).SQLDB := nil;
  FResultSets.Clear;
end;

procedure TSQLDB.ClearResultSets;
begin
  ClearAllResultSets;
  FCurrentSet := TResultSet.Create;
  FResultSets.AddObject ('default', FCurrentSet);
end;

function TSQLDB.DeleteResultSet(Name: String): Boolean;
var i: Integer;
    iscurrent: Boolean;
begin
  i := FResultSets.IndexOf(Name);
  Result := i>=0;
  if Result then
    begin
      iscurrent := FResultSets.Objects[i] = FCurrentSet;
      if TResultSet (FResultSets.Objects[i]).FAutoFree then
        //Resultset will unregister itself from the FResultSets list:
        FResultSets.Objects[i].Free
      else
        //User created it.
        begin
          //inform resultset it has no owner:
          TResultSet (FResultSets.Objects[i]).SQLDB := nil;
          //Delete it from the list:
          FResultSets.Delete (i);
        end;
      if iscurrent then
        UseResultSet ('default'); //always make sure we use a result set.
    end;
end;

procedure TSQLDB.SetResultSet(const Value: String);
begin
  UseResultSet (Value);
  FResultSet := Value;
end;

class function TSQLDB.DatabaseType(DB: TSQLDB): TDBMajorType;
var s: String;
begin
  if DB=nil then
    Result := dbANSI
  else
  begin
    s := lowercase (DB.ClassName);
    if (s = 'tlitedb') or (s='tmlitedb') then
      Result := dbSQLite
    else
    if s = 'tmydb' then
      Result := dbMySQL
    else
    if s = 'todbcdb' then
      Result := dbODBC
    else
    if s = 'tjandb' then
      Result := dbJanSQL
    else
      Result := dbANSI;
  end;
end;

class procedure TSQLDB._FormatSql(var sql: String; var sqlw: WideString; Value: String; const Args: array of const;
  Wide: Boolean; DBType: TDBMajorType);
var i,j: Integer;
    c: char;
//    cw: WideChar;
    p:String;
    pw: WideString;
    vc: String;
begin
  sql := '';
  sqlw := '';
  for i:=0 to high(Args) do
    begin

      j:=pos('%', Value);
      while copy (Value, j+1, 1)='%' do //skip this occurence
        begin
          if Wide then
            sqlw := sqlw + DecodeUTF8(copy(Value,1,j))
          else
            sql:=sql+copy(Value,1,j);
          Value := copy (Value, j+2, maxint);
          j:=pos('%', Value);
        end;

      if j<length(Value) then
        c:=upcase(Value[j+1])
      else
        c:=#0; //exit;
      //support for 'any' type by wildcard
      if c='*' then
        c := 'A';
      if Wide then
        sqlw := sqlw + DecodeUTF8 (copy(Value,1,j-1))
      else
        begin
          vc := copy(Value,1,j-1);
          sql := sql + vc;
        end;
      Value:=copy(Value, j+2, maxint);

      p := '';
      pw := '';

      with Args[i] do
          case VType of
            vtBoolean:
              begin
                if c in ['B', 'Q', 'A'] then
                  p := IntToStr(Integer(VBoolean))
                else
                  exit; //illegal format
              end;
            vtInteger:
              begin
                if c in ['D', 'Q', 'A'] then
                  p := IntToStr(VInteger)
                else
                  exit; //illegal format
              end;
            vtString:
              begin
                if c in ['S', 'Q', 'Z', 'U', 'X', 'A'] then
                  p :=  String(VString^)
                else
                if c in ['W'] then
                  begin
                    p := String(VString^);
                    pw := DecodeUTF8(p);
                    p := '';
                  end
                else
                  exit; //illegal format
              end;
            vtChar:
              begin
                if c in ['S', 'Q', 'Z', 'U', 'X', 'A'] then
                  p := VChar
                else
                  exit; //illegal format
              end;
            vtWideChar:
              begin
                if c in ['W', 'S', 'Q', 'Z', 'U', 'A'] then
                  pw := VWideChar
                else
                  exit; //illegal format
              end;
            vtExtended:
              begin
                if c in ['F', 'Q', 'A'] then
                  begin
                    p := FloatToStr(Extended(VExtended^));
                    //odbc: use system format
                    //sqlite, mysql, use dot. replace
                    if DBType in [dbMySQL, dbSQLite] then
                      p := StringReplace (p, ',', '.', []);
                  end
                else
                  exit; //illegal format
              end;
            vtInt64:
              begin
                if c in ['I', 'D', 'Q', 'A'] then
                  p := IntToStr(VInt64^)
                else
                  exit; //illegal format
              end;
            vtAnsiString:
              begin
                if c in ['S', 'Q', 'Z', 'U', 'X', 'A'] then
                    p := String(VAnsiString)
                else
                  exit; //illegal format
              end;
            vtWideString:
              begin
                if c in ['S', 'W', 'Q', 'Z', 'U', 'A'] then
                  pw := WideString(VWideString)
                else
                  exit;
              end;
            vtVariant:
              begin
                if c in ['S', 'Q', 'Z', 'A'] then
                  begin
                    if Wide then
                      pw := WideString (VVariant^)
                    else
                      p := String(VVariant^);
                  end
                else
                  exit; //illegal format
              end;
            vtCurrency:
              begin
                if c in ['S', 'Q', 'Z'] then
                  begin
                    p := CurrToStr(VCurrency^);
                    if DBType in [dbMySQL, dbSQLite] then
                      p := StringReplace (p, ',', '.', []);
                  end
                else
                  exit; //illegal format
              end;
            else
              exit;
          end; //case

        //rules:
        // d - decimal, not quoted
        // b - boolean, not quoted
        // i - int64, 'd' also allowed
        // s - string, variant, currency, autoquoted
        // f - float
        // z - binary safe (Zero-safe + quotes escaped), many types
        // q - any type quoted; force quote, all types
        // u - do not quote string types
        // x - binary safe but not quoted, string types
        // a - any type unquoted

        //other way round:
        // strings: S Q Z X A
        // integers: D Q A
        // int64: D I Q A
        // float: F Q A
        // Boolean: B Q A

        //table
        //      quoted binary datatype
        // S      yes    no   strings, char, array of char, variants (casted as string)
        // U      no     no   String types
        // D,I    no     no   Integers, ordinal types
        // F      no     no   floating point (any type)
        // Z      yes    yes  Binary data as string
        // X      no     yes  Binary data, not quoted (recommended only to use if you quote the data yourself)
        // A      no     no   Any type not quoted
        // Q      yes    no   Any type quoted

        // char, char array, variant and currency types: see string types

        //last note about floats: for sqlite i'm not too sure at the moment
        //how decimal seperator is threated, weather it is locally or not
        //mysql uses a dot everywhere ... have to check this out.


        if (c='X') then //make this string binary (8-bit only)
          p := Escape (p); //we just assume same syntax is valid on both mydb and litedb databases

        if (c='S') or (c='Z') or (c='W') then //quote string
          begin
            if pw<>'' then
              pw := QuoteEscapeW (pw, DBType)
            else
              p:= QuoteEscape (p, DBType);
          end;

        if (c='Q') then
          begin
            if pw<>'' then
              pw := AddQuoteW(pw)
            else
              p := AddQuote (p);
          end;

        if Wide then
          begin
            if pw<>'' then
              sqlw := sqlw + pw
            else
              sqlw := sqlw + p;
          end
        else
          begin
            if pw<>'' then
              sql := sql + EncodeUTF8(pw)
            else
              sql := sql + p;
          end;
    end;

  //in case it was nicely formatted, but out of arguments:

  Value := StringReplace (Value, '%%', '%', [rfReplaceAll]);
  if Wide then
    begin
      sqlw := sqlw + DecodeUTF8(Value);
    end
  else
    begin
      sql := sql+Value;
    end;
end;

function TSQLDB.FormatSql(Value: String;
  const Args: array of const): String;
var w: WideString;
begin
  _FormatSql (Result, w, Value, Args, False, FDataBaseType);
end;

function TSQLDB.FormatSqlW(Value: String;
  const Args: array of const): WideString;
var v: String;
begin
  _FormatSql (v, Result, Value, Args, True, FDataBaseType);
end;

function TSQLDB.ExecuteW(SQL: WideString): THandle;
begin
  Result := Execute (EncodeUTF8(SQL));
end;

//more or less obsolete...
function TSQLDB.FetchRowW(Handle: THandle; var row: TResultRow): Boolean;
begin
  Result := FetchRow(Handle, row);
end;

function TSQLDB.BindExecute(SQL: String;
  const Args: array of const): THandle;
begin
  //if no binding available, format.
  Result := FormatExecute (SQL, Args);
end;

function TSQLDB.BindExecuteW(SQL: WideString;
  const Args: array of const): THandle;
begin
  Result := FormatExecuteW (SQL, Args);
end;

function TSQLDB.ConnectW(Host, User, Pass: String;
  DataBase: WideString): Boolean;
begin
  FUnicode := True;
  Result := Connect (Host, User, Pass, EncodeUTF8(Database));
end;

function TSQLDB.FormatExecute(SQL: String;
  const Args: array of const): THandle;
begin
  Result := Execute (FormatSQL(SQL, Args));
end;

function TSQLDB.FormatExecuteW(SQL: WideString;
  const Args: array of const): THandle;
begin
  Result := ExecuteW (FormatSQLW(SQL, Args));
end;

procedure TResultSet.FreeResult;
var TempSet: TResultSet;
begin
  if Assigned (SQLDB) then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (Self);
      SQLDB.FreeResult (FStmt);
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end;
  FFetchedRow := FNilRow;
end;

function TResultSet.FormatExecuteW(SQL: WideString;
  const Args: array of const): Boolean;
var TempSet: TResultSet;
begin
  FFetchedRow := FNilRow;
  if Assigned (SQLDB) and (FName<>'') then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (FName);
      FStmt := SQLDB.FormatExecuteW (SQL, Args);
      Result := FStmt <> 0;
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;

function TResultSet.FormatExecute(SQL: String;
  const Args: array of const): Boolean;
var TempSet: TResultSet;
begin
  FFetchedRow := FNilRow;
  if Assigned (SQLDB) then
    begin
      SQLDB.Lock;
      TempSet := SQLDB.FCurrentSet;
      SQLDB.UseResultSet (Self);
      FStmt := SQLDB.FormatExecute (SQL, Args);
      Result := FStmt <> 0;
      SQLDB.UseResultSet(TempSet);
      SQLDB.Unlock;
    end
  else
    Result := False;
end;



procedure TSQLDB.SetIndexes(const Value: TStrings);
begin
  Indexes.Assign (Value);
  Value.Free;
end;

procedure TSQLDB.SetLibraryPath(const Value: String);
begin
  FLibraryPath := Value;
end;

procedure TSQLDB.SetTables(const Value: TStrings);
begin
  Tables.Assign (Value);
  Value.Free;
end;

function TSQLDB.GetIndexes: TStrings;
begin
  Result := GetDBInfo (FDatabase).Indexes;
end;

function TSQLDB.GetLibraryPath: String;
begin
  Result := FLibraryPath;
end;

function TSQLDB.GetTables: TStrings;
begin
  Result := GetDBInfo (FDatabase).Tables;
end;

function TSQLDB.GetDBInfo(DB: String): TDatabaseInfo;
var i: Integer;
begin
  i := FDatabaseInfo.IndexOf (DB);
  if i<0 then
    begin
      i := FDatabaseInfo.AddObject (DB, TDatabaseInfo.Create);
    end;
  Result := TDatabaseInfo(FDatabaseInfo.Objects[i]);
end;

procedure TSQLDB.FillDBInfo;
begin
  Tables.Clear;
  Indexes.Clear;
  //inherited implementations may fill those
end;

function TSQLDB.GetColumnAsStrings(Index: Integer): TStrings;
var i: Integer;
begin
  Result := TStringList.Create;
  with FCurrentSet do
    begin
      for i:=0 to FRowCount - 1 do
        Result.Add (Row[i][Index]);
    end;
end;

function TSQLDB.SetNameFromInt(Value: Integer): String;
begin
  Result := '__setname__'+IntToStr(value);
end;

function TSQLDB.UniqueSetName: String;
begin
  inc (FSetNameCount);
  Result := '__unique__'+IntToStr(FSetNameCount);
end;

function TSQLDB.UseResultSet(Value: Integer): TResultSet;
begin
  Result := UseResultSet(SetNameFromInt(Value));
end;

function TSQLDB.UseResultSet(rset: TResultSet): TResultSet;
begin
  if FCurrentSet<>rset then
    begin
      //add to list of result sets, if not exists:
      if FResultSets.IndexOfObject (rset)<0 then
        begin
          //adds current set (if not done)
          rset.SQLDB := Self;
          rset.FName := UniqueSetName;
          FResultSets.AddObject (rset.FName, rset);
        end;
      FCurrentSet := rset;
      FResultSet := rset.FName;
    end;
  Result := rset;
end;

function TSQLDB.DeleteResultSet(Value: Integer): Boolean;
begin
  Result := DeleteResultSet (SetNameFromInt(Value));
end;

procedure TSQLDB.RegisterResultSet(ResultSet: TResultSet);
begin
  ResultSet.FName := UniqueSetName;
  FResultSets.AddObject (ResultSet.FName, ResultSet);
end;

procedure TSQLDB.RemoveResultSet(ResultSet: TResultSet);
var i: Integer;
    iscurrent: Boolean;
begin
  i := FResultSets.IndexOf (ResultSet.FName);
  if (i>=0) then
    begin
      iscurrent := FResultSets.Objects[i] = FCurrentSet;
      FResultSets.Delete (i);
      if iscurrent then
        UseResultSet ('default');
    end;
end;

procedure TSQLDB.SetThreadSafe(const Value: Boolean);
begin
  FThreadSafe := Value;
end;

function TSQLDB.Flush(Option: String): Boolean;
begin
  Result := False;
end;

function TSQLDB.LockTables(Statement: String): Boolean;
begin
  Result := False;
end;

function TSQLDB.TruncateTable(Table: String): Boolean;
begin
  Result := Query ('DELETE FROM '+Table);
end;

function TSQLDB.UnLockTables: Boolean;
begin
  Result := false;
end;

function TSQLDB.Vacuum: Boolean;
begin
  Result := false;
end;

procedure TSQLDB.RefreshDBInfo;
begin
  FillDBInfo;
end;

function TSQLDB.InsertResultsetIntoTable(Table: String;
  ResultSet: TResultSet; CreateNewTable: Boolean=False): Boolean;
//inserts the contents of a resultset into table
//usefull for passing data accross databases
begin
  //todo
  Result := False;
end;

end.
