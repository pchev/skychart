unit libodbc32;

interface       

//origin:
//constSQL.pas by Piotr Sobkiewicz psobkiew@kr.onet.pl
//license: unknown, public, downloadable at torry's, no project homepage

//rene 2005
//added credits to Piotr
//made some adjustments, maybe linux compatible maybe not
//modified library to support dynamic loading
//added few functions
//trying to make freepascal / kylix compatability
//ODBC compatability on unix not tested
//but you may get it to work, for example using IODBC.org
//debain has package IODCB.

{$IFNDEF FPC}
  {$IFDEF LINUX} //Kylix
  {$DEFINE UNIX}
  {$ENDIF}
{$ELSE}
  {$MODE DELPHI}
{$ENDIF}

uses
  {$IFNDEF UNIX}
  Windows,
  {$ENDIF}
  SysUtils
  {$IFDEF FPC}
  ,DynLibs
  {$ENDIF}
  ;

const
{$IFDEF UNIX}
  ODBC32='odbc32.so';  //libodbc32.so on some systems?
{$ELSE}
  ODBC32='odbc32.dll';
{$ENDIF}

//common header interface


  // return values from functions
  SQL_SUCCESS  = 0;
  SQL_SUCCESS_WITH_INFO =  1;
  SQL_NO_DATA           =  100;
  SQL_ERROR             = (-1);
  SQL_INVALID_HANDLE    = (-2);
  SQL_NEED_DATA         =  99;
  SQL_NTS               = (-3);

  SQL_PARAM_TYPE_UNKNOWN = 0;
  SQL_PARAM_INPUT        = 1;
  SQL_PARAM_INPUT_OUTPUT = 2;
  SQL_RESULT_COL         = 3;
  SQL_PARAM_OUTPUT       = 4;
  SQL_RETURN_VALUE       = 5;

  //used for SQLFreeStmt
  //unsure about these types:
  SQL_CLOSE = 0;
  SQL_DROP = 1;
  SQL_UNBIND = 2;
  SQL_RESET_PARAMS = 3;

  //transactions:

  SQL_COMMIT = 0;
  SQL_ROLLBACK= 1;

  SQL_AUTOCOMMIT_OFF = 0;
  SQL_AUTOCOMMIT_ON = 1;

  //driverconnect options
  SQL_DRIVER_NOPROMPT = 0;
  SQL_DRIVER_COMPLETE = 1;
  SQL_DRIVER_PROMPT = 2;
  SQL_DRIVER_COMPLETE_REQUIRED = 3;

// Codes used for FetchOrientation in SQLFetchScroll(),
//   and in SQLDataSources()

  SQL_FETCH_NEXT     = 1;
  SQL_FETCH_FIRST    = 2;
  SQL_FETCH_LAST     = 3;
  SQL_FETCH_PRIOR    = 4;
  SQL_FETCH_ABSOLUTE = 5;
  SQL_FETCH_RELATIVE = 6;

{ handle type identifiers }
  SQL_HANDLE_ENV   = 1;
  SQL_HANDLE_DBC   = 2;
  SQL_HANDLE_STMT  = 3;
  SQL_HANDLE_DESC  = 4;

  { Operations in SQLSetPos }
  SQL_POSITION                = 0;
  SQL_REFRESH                 = 1;
  SQL_UPDATE                  = 2;
  SQL_DELETE                  = 3;

{ Lock options in SQLSetPos }
  SQL_LOCK_NO_CHANGE          = 0;
  SQL_LOCK_EXCLUSIVE          = 1;
  SQL_LOCK_UNLOCK             = 2;

  { statement attributes }
  SQL_ATTR_APP_ROW_DESC       = 10010;
  SQL_ATTR_APP_PARAM_DESC     = 10011;
  SQL_ATTR_IMP_ROW_DESC       = 10012;
  SQL_ATTR_IMP_PARAM_DESC     = 10013;
  SQL_ATTR_CURSOR_SCROLLABLE  = (-1);
  SQL_ATTR_CURSOR_SENSITIVITY = (-2);
  SQL_QUERY_TIMEOUT           =0;
  SQL_MAX_ROWS                =1;
  SQL_NOSCAN                  =2;
  SQL_MAX_LENGTH              =3;
  SQL_ASYNC_ENABLE            =4;       // same as SQL_ATTR_ASYNC_ENABLE */
  SQL_BIND_TYPE               =5;
  SQL_CURSOR_TYPE             = 6;
  SQL_CONCURRENCY             = 7;
  SQL_KEYSET_SIZE             =8;
  SQL_ROWSET_SIZE             =9;
  SQL_SIMULATE_CURSOR         =10;
  SQL_RETRIEVE_DATA           =11;
  SQL_USE_BOOKMARKS           =12;
  SQL_GET_BOOKMARK            =13;      //      GetStmtOption Only */
  SQL_ROW_NUMBER              = 14;     //      GetStmtOption Only */
  SQL_ATTR_CURSOR_TYPE        = SQL_CURSOR_TYPE;
  SQL_ATTR_CONCURRENCY        = SQL_CONCURRENCY;
  SQL_ATTR_FETCH_BOOKMARK_PTR = 16;
  SQL_ATTR_ROW_STATUS_PTR     = 25;
  SQL_ATTR_ROWS_FETCHED_PTR   = 26;
  SQL_AUTOCOMMIT              = 102;
  SQL_ATTR_AUTOCOMMIT         = SQL_AUTOCOMMIT;

  SQL_ATTR_ROW_NUMBER         = SQL_ROW_NUMBER;
  SQL_TXN_ISOLATION           = 108;
  SQL_ATTR_TXN_ISOLATION      = SQL_TXN_ISOLATION;
  SQL_ATTR_MAX_ROWS           = SQL_MAX_ROWS;
  SQL_ATTR_USE_BOOKMARKS      = SQL_USE_BOOKMARKS;

{ SQL_ATTR_CURSOR_SCROLLABLE values }
  SQL_NONSCROLLABLE              = 0;
  SQL_SCROLLABLE                 = 1;
  { SQL_CURSOR_TYPE options }
  SQL_CURSOR_FORWARD_ONLY     = 0;
  SQL_CURSOR_KEYSET_DRIVEN    = 1;
  SQL_CURSOR_DYNAMIC          = 2;
  SQL_CURSOR_STATIC           = 3;
  SQL_CURSOR_TYPE_DEFAULT     = SQL_CURSOR_FORWARD_ONLY;{ Default value }

{ whether an attribute is a pointer or not }
  SQL_IS_POINTER    = (-4);
  SQL_IS_UINTEGER   = (-5);
  SQL_IS_INTEGER    = (-6);
  SQL_IS_USMALLINT  = (-7);
  SQL_IS_SMALLINT   = (-8);
  { SQLExtendedFetch "fFetchType" values }
  SQL_FETCH_BOOKMARK = 8;
  SQL_SCROLL_OPTIONS = 44;

{ SQLGetData() code indicating that the application row descriptor
    specifies the data type }
  SQL_ARD_TYPE      = (-99);

// Cursor typ
type TCursorType = (ctFORWARD_ONLY,ctSTATIC,ctKEYSET_DRIVEN,ctDYNAMIC);



const
  { values of NULLABLE field in descriptor }
  SQL_NO_NULLS = 0;
  SQL_NULLABLE = 1;
  { Value returned by SQLGetTypeInfo() to denote that it is
   not known whether or not a data type supports null values. }
  SQL_NULLABLE_UNKNOWN = 2;

{ SQL data type codes }
const
  SQL_UNKNOWN_TYPE  = 0;
  SQL_LONGVARCHAR   =(-1);
  SQL_BINARY        =(-2);
  SQL_VARBINARY     =(-3);
  SQL_LONGVARBINARY =(-4);
  SQL_BIGINT        =(-5);
  SQL_TINYINT       =(-6);
  SQL_BIT           =(-7);
  SQL_WCHAR         =(-8);
  SQL_WVARCHAR      =(-9);
  SQL_WLONGVARCHAR  =(-10);
  SQL_CHAR          = 1;
  SQL_NUMERIC       = 2;
  SQL_DECIMAL       = 3;
  SQL_INTEGER       = 4;
  SQL_SMALLINT      = 5;
  SQL_FLOAT         = 6;
  SQL_REAL          = 7;
  SQL_DOUBLE        = 8;
  SQL_DATETIME      = 9;
  SQL_VARCHAR       = 12;
  SQL_TYPE_DATE     = 91;
  SQL_TYPE_TIME     = 92;
  SQL_TYPE_TIMESTAMP= 93;
  SQL_NO_TOTAL   = -4;
  SQL_NULL_DATA  = (-1);
{ C data type codes }
  SQL_C_CHAR =   SQL_CHAR ; //            /* CHAR, VARCHAR, DECIMAL, NUMERIC */
  SQL_C_LONG        = SQL_INTEGER;
  SQL_C_SHORT       = SQL_SMALLINT;
  SQL_C_TYPE_DATE   = SQL_TYPE_DATE;
  SQL_C_TYPE_TIME   = SQL_TYPE_TIME;
  SQL_C_DATETIME    = SQL_DATETIME;
  SQL_C_TYPE_TIMESTAMP  = SQL_TYPE_TIMESTAMP;
  SQL_C_NUMERIC         = SQL_NUMERIC;
  SQL_C_BIT             = SQL_BIT;
  SQL_C_BINARY          = SQL_BINARY;
  SQL_C_DOUBLE          = SQL_DOUBLE;
  SQL_MAX_NUMERIC_LEN   = 16;

type
  SQLCHAR      = Char;
  SQLSMALLINT  = smallint;
  SQLUSMALLINT = Word;
  SQLRETURN    = SQLSMALLINT;
  SQLHANDLE    = LongInt;
  SQLHENV      = SQLHANDLE;
  SQLHDBC      = SQLHANDLE;
  SQLHSTMT     = SQLHANDLE;
  SQLINTEGER   = LongInt;
  SQLUINTEGER  = Cardinal;
  SQLPOINTER   = Pointer;
  SQLREAL      = real;
  SQLDOUBLE    = Double;
  SQLFLOAT     = Double;
  PSQLCHAR      = PChar;
  PSQLINTEGER   = ^SQLINTEGER;
  PSQLUINTEGER  = ^SQLUINTEGER;
  PSQLSMALLINT  = ^SQLSMALLINT;
  PSQLUSMALLINT = ^SQLUSMALLINT;
  PSQLREAL      = ^SQLREAL;
  PSQLDOUBLE    = ^SQLDOUBLE;
  PSQLFLOAT     = ^SQLFLOAT;
  PSQLHandle    = ^SQLHANDLE;
  PSQLReturn    = ^SQLRETURN;

//typedef struct tagSQL_NUMERIC_STRUCT
//{
//        SQLCHAR         precision;
//        SQLSCHAR        scale;
//        SQLCHAR         sign;   /* 1 if positive, 0 if negative */
//        SQLCHAR         val[SQL_MAX_NUMERIC_LEN];
//} SQL_NUMERIC_STRUCT;

type
  SQL_NUMERIC_STRUCT = packed record
        precision:Byte  ;
        scale:Byte      ;
        sign:Byte       ;    { 1 if positive, 0 if negative }
        val:array [0..SQL_MAX_NUMERIC_LEN-1] of Byte;
  end;
  PSQL_NUMERIC_STRUCT = ^SQL_NUMERIC_STRUCT;



type
  SQL_DATE_STRUCT = packed record
    Year : SQLSMALLINT;
    Month : SQLUSMALLINT;
    Day : SQLUSMALLINT;
  end;
  PSQL_DATE_STRUCT = ^SQL_DATE_STRUCT;

  SQL_TIME_STRUCT = packed record
    Hour : SQLUSMALLINT;
    Minute : SQLUSMALLINT;
    Second : SQLUSMALLINT;
  end;
  PSQL_TIME_STRUCT = ^SQL_TIME_STRUCT;

  SQL_TIMESTAMP_STRUCT = packed record
    Year :     SQLUSMALLINT;
    Month :    SQLUSMALLINT;
    Day :      SQLUSMALLINT;
    Hour :     SQLUSMALLINT;
    Minute :   SQLUSMALLINT;
    Second :   SQLUSMALLINT;
    Fraction : SQLUINTEGER;
  end;
  PSQL_TIMESTAMP_STRUCT = ^SQL_TIMESTAMP_STRUCT;



TFieldType = (ftUnknown, ftString,
               ftSmallint, ftInteger, ftWord,
               ftBoolean, ftFloat, ftCurrency, ftBCD,
               ftDate, ftTime,
               ftDateTime, ftBytes, ftVarBytes,
               ftAutoInc, ftBlob,
               ftMemo, ftGraphic, ftFmtMemo,
               ftParadoxOle, ftDBaseOle,
                ftTypedBinary, ftCursor);
type

  TSQLAllocEnv = function (var phenv:LongInt):Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLAllocConnect=function (henv:LongInt; var phdbc:Integer):Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLFreeEnv=function (henv:LongInt) :Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLFreeConnect=function (hdbc:LongInt) :Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLConnect=function (hdbc:Integer; szDSN:PCHAR; cbDSN:Smallint; szUID:PCHAR; cbUID:Smallint; szAuthStr:PCHAR; cbAuthStr:Smallint) :Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLDisconnect=function (hdbc:Integer) :Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLAllocStmt=function (hdbc:Integer; var phstmt:Integer):Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLFreeStmt=function (hstmt:Integer;  fOption:Smallint) :Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLExecDirect=function (hstmt:Integer;  szSqlStr:PCHAR;  cbSqlStr:Integer) :Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLFetchScroll=function (hstmt:Integer;
            FetchOrientation: Smallint; FetchOffset: Integer) :Smallint;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLGetDiagRec=function (
               HandleType:   SQLSMALLINT;
               Handle:       SQLHANDLE;
               RecNumber:    SQLSMALLINT;
               Sqlstate:     PSQLCHAR;
               NativeError: PSQLRETURN;
               MessageText:     PSQLCHAR;
               BufferLength:    SQLSMALLINT;
               var TextLength:  SQLSMALLINT ):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLSetPos=function (
               hstmt:SQLHSTMT;
               irow:SQLUSMALLINT;
               fOption:SQLUSMALLINT;
               fLock:SQLUSMALLINT):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};

  TSQLSetStmtAttr=function (
               StatementHandle:SQLHSTMT;
               Attribute:SQLINTEGER;
               Value:SQLPOINTER;
               StringLength:SQLINTEGER):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLNumResultCols=function (
               StatementHandle:SQLHSTMT;
               var ColumnCount:SQLSMALLINT):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF}; 
  TSQLDescribeCol=function (
               StatementHandle:SQLHSTMT;
               ColumnNumber:SQLUSMALLINT;
               ColumnName:PSQLCHAR;
               BufferLength:SQLSMALLINT;
               var NameLength:SQLSMALLINT;
               var DataType:SQLSMALLINT;
               var ColumnSize:SQLUINTEGER;
               var DecimalDigits:SQLSMALLINT;
               var Nullable:SQLSMALLINT):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLBindCol=function (
               StatementHandle:SQLHSTMT;
               ColumnNumber:SQLUSMALLINT;
               TargetType:SQLSMALLINT;
               TargetValue:SQLPOINTER;
               BufferLength:SQLINTEGER;
               StrLen_or_Ind:PSQLINTEGER):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF}; 
  TSQLGetData=function (
               StatementHandle:SQLHSTMT;
               ColumnNumber:SQLUSMALLINT;
               TargetType:SQLSMALLINT;
               TargetValue:SQLPOINTER;
               BufferLength:SQLINTEGER;
               StrLen_or_Ind:PSQLINTEGER):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF}; 
  TSQLBindParameter=function (
               hstmt:SQLHSTMT;
               ipar:SQLUSMALLINT;
               fParamType:SQLSMALLINT;
               fCType:SQLSMALLINT;
               fSqlType:SQLSMALLINT;
               cbColDef:SQLUINTEGER;
               ibScale:SQLSMALLINT;
               rgbValue:SQLPOINTER;
               cbValueMax:SQLINTEGER;
               pcbValue:PSQLINTEGER):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};
  TSQLPrepare=function (
               StatementHandle:SQLHSTMT;
               StatementText:PSQLCHAR;
               TextLength:SQLINTEGER):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF}; 

  TSQLExecute=function (
               StatementHandle:SQLHSTMT):SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};

  TSQLSetParam=function ( hstmt:Integer;  ipar:Smallint;
                     fCType:Smallint;  fSqlType:Smallint;
                     cbColDef:Integer;  ibScale:Smallint;
                     var RGBValue:PCHAR;
                     var pcbValue:Integer) :SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};


{
SQLRETURN SQLRowCount(
     SQLHSTMT     StatementHandle,
     SQLINTEGER *     RowCountPtr);
}
  TSQLRowCount=function  (StatementHandle: SQLHSTMT; var RowCountPtr: SQLInteger): SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};


{
SQLRETURN SQLFetch(
     SQLHSTMT     StatementHandle);
}

  TSQLFetch=function  (StatementHandle: SQLHSTMT): SQLRETURN;{$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};

{
SQLRETURN SQLEndTran(
     SQLSMALLINT     HandleType,
     SQLHANDLE     Handle,
     SQLSMALLINT     CompletionType);
}
  TSQLEndTran = function (htype : SQLSmallInt;
                          handle : SQLHANDLE;
                          comptype: SQLSmallInt):SQLRETURN; {$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};

{  SQLRETURN SQLSetConnectAttr(
     SQLHDBC     ConnectionHandle,
     SQLINTEGER     Attribute,
     SQLPOINTER     ValuePtr,
     SQLINTEGER     StringLength);
}
  TSQLSetConnectAttr = function (
                         hdbc: SQLHDBC;
                         Attr: SQLInteger;
                         Value: SQLPointer;
                         StrLength: SQLInteger
                       ): SQLRETURN; {$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};

{
SQLRETURN SQLTables(
     SQLHSTMT     StatementHandle,
     SQLCHAR *     CatalogName,
     SQLSMALLINT     NameLength1,
     SQLCHAR *     SchemaName,
     SQLSMALLINT     NameLength2,
     SQLCHAR *     TableName,
     SQLSMALLINT     NameLength3,
     SQLCHAR *     TableType,
     SQLSMALLINT     NameLength4);
}

  //this function proves MS is nuts.
  //general usage: call with all params nil or zero except hstmt.
  TSQLTables = function (hstmt: SQLHSTMT;
                         CatName: PSQLChar; CatLen: SQLSmallInt;
                         SchemaName: PSQLChar; SchemaLen: SQLSmallInt;
                         TableName: PSQLChar; TableLen: SQLSmallInt;
                         TableType: PSQLChar; TypeLen: SQLSmallInt
                        ): SQLRETURN; {$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};

{
SQLRETURN SQLDriverConnect(
     SQLHDBC     ConnectionHandle,
     SQLHWND     WindowHandle,
     SQLCHAR *     InConnectionString,
     SQLSMALLINT     StringLength1,
     SQLCHAR *     OutConnectionString,
     SQLSMALLINT     BufferLength,
     SQLSMALLINT *     StringLength2Ptr,
     SQLUSMALLINT     DriverCompletion);
}


  TSQLDriverConnect = function (
    hdbc: SQLHDBC;
    HWND: THandle; //SQLHWND;
    InConnnectionString: PSQLChar; InConnLength: SQLSMALLINT;
    OutConnnectionString: PSQLChar; OutBufferLength: SQLSMALLINT;
    var OutConnLength: SQLSMALLINT;
    DriverCompletion: SQLUSMALLINT): SQLRETURN; {$IFDEF LINUX}cdecl{$ELSE}stdcall{$ENDIF};



{ //todo
SQLRETURN SQLDataSources(
     SQLHENV     EnvironmentHandle,
     SQLUSMALLINT     Direction,
     SQLCHAR *     ServerName,
     SQLSMALLINT     BufferLength1,
     SQLSMALLINT *     NameLength1Ptr,
     SQLCHAR *     Description,
     SQLSMALLINT     BufferLength2,
     SQLSMALLINT *     NameLength2Ptr);
}

var
  SQLAllocEnv:TSQLAllocEnv;
  SQLAllocConnect:TSQLAllocConnect;
  SQLAllocStmt:TSQLAllocStmt;
  SQLBindCol:TSQLBindCol;
  SQLBindParameter:TSQLBindParameter;
  SQLConnect:TSQLConnect;
  SQLDescribeCol:TSQLDescribeCol;
  SQLDisconnect:TSQLDisconnect;
  SQLExecDirect:TSQLExecDirect;
  SQLExecute:TSQLExecute;
  SQLFetch:TSQLFetch;
  SQLFetchScroll:TSQLFetchScroll;
  SQLFreeConnect:TSQLFreeConnect;
  SQLFreeEnv:TSQLFreeEnv;
  SQLFreeStmt:TSQLFreeStmt;
  SQLGetData:TSQLGetData;
  SQLGetDiagRec:TSQLGetDiagRec;
  SQLNumResultCols:TSQLNumResultCols;
  SQLPrepare:TSQLPrepare;
  SQLRowCount:TSQLRowCount;
  SQLSetPos:TSQLSetPos;
  SQLSetStmtAttr:TSQLSetStmtAttr;
  SQLSetParam:TSQLSetParam;
  SQLEndTran: TSQLEndTran;
  SQLSetConnectAttr: TSQLSetConnectAttr;
  SQLTables: TSQLTables;
  SQLDriverConnect: TSQLDriverConnect;

function LoadLibODBC32(var LibraryName: String): Boolean;


var ODBC32LibsLoaded: Boolean = False;
    ODBC32LoadLibsFailed: Boolean = False;

implementation

var ODBCDLLHandle: {$IFDEF FPC}TLibHandle = 0{$ELSE}THandle = 0{$ENDIF}; //THandle

{$IFDEF FPC}
//FPC Support function helping typecasting:
function GetProcAddress(hModule: HMODULE; lpProcName: PChar): Pointer;
begin
  Result := GetProcedureAddress(hModule, lpProcName);
end;
{$ENDIF}

function LoadLibODBC32 (var LibraryName: String): Boolean;
begin
  //load libraries
  if ODBC32LibsLoaded or (ODBC32LoadLibsFailed) then
    //already loaded
    begin
      Result := ODBC32LibsLoaded;
      exit;
    end;
    
  if LibraryName='' then
    LibraryName := ODBC32;

  ODBCDLLHandle := {$IFNDEF FPC}LoadLibrary(PChar(LibraryName)){$ELSE}LoadLibrary(LibraryName){$ENDIF};

  if ODBCDLLHandle <> {$IFDEF FPC}0{$ELSE}{$IFDEF UNIX}nil{$ELSE}0{$ENDIF}{$ENDIF} then
    begin
      SQLAllocEnv:=GetProcAddress (ODBCDLLHandle, 'SQLAllocEnv');
      SQLAllocConnect:=GetProcAddress (ODBCDLLHandle, 'SQLAllocConnect');
      SQLFreeEnv:=GetProcAddress (ODBCDLLHandle, 'SQLFreeEnv');
      SQLFreeConnect:=GetProcAddress (ODBCDLLHandle, 'SQLFreeConnect');
      SQLConnect:=GetProcAddress (ODBCDLLHandle, 'SQLConnect');
      SQLDisconnect:=GetProcAddress (ODBCDLLHandle, 'SQLDisconnect');
      SQLAllocStmt:=GetProcAddress (ODBCDLLHandle, 'SQLAllocStmt');
      SQLFreeStmt:=GetProcAddress (ODBCDLLHandle, 'SQLFreeStmt');
      SQLExecDirect:=GetProcAddress (ODBCDLLHandle, 'SQLExecDirect');
      SQLFetchScroll:=GetProcAddress (ODBCDLLHandle, 'SQLFetchScroll');
      SQLGetDiagRec:=GetProcAddress (ODBCDLLHandle, 'SQLGetDiagRec');
      SQLSetPos:=GetProcAddress (ODBCDLLHandle, 'SQLSetPos');
      SQLSetStmtAttr:=GetProcAddress (ODBCDLLHandle, 'SQLSetStmtAttr');
      SQLNumResultCols:=GetProcAddress (ODBCDLLHandle, 'SQLNumResultCols');
      SQLDescribeCol:=GetProcAddress (ODBCDLLHandle, 'SQLDescribeCol');
      SQLBindCol:=GetProcAddress (ODBCDLLHandle, 'SQLBindCol');
      SQLGetData:=GetProcAddress (ODBCDLLHandle, 'SQLGetData');
      SQLBindParameter:=GetProcAddress (ODBCDLLHandle, 'SQLBindParameter');
      SQLPrepare:=GetProcAddress (ODBCDLLHandle, 'SQLPrepare');
      SQLExecute:=GetProcAddress (ODBCDLLHandle, 'SQLExecute');
      SQLSetParam:=GetProcAddress (ODBCDLLHandle, 'SQLSetParam');
      SQLRowCount:=GetProcAddress (ODBCDLLHandle, 'SQLRowCount');
      SQLFetch:=GetProcAddress (ODBCDLLHandle, 'SQLFetch');
      SQlEndTran := GetProcAddress (ODBCDLLHandle, 'SQLEndTran');
      SQLSetConnectAttr := GetProcAddress (ODBCDLLHandle, 'SQLSetConnectAttr');  //odbc 3.0 - replaces setconnectoptions
      SQLTables := GetProcAddress (ODBCDLLHandle, 'SQLTables');
      SQLDriverConnect := GetProcAddress (ODBCDLLHandle, 'SQLDriverConnect');

      ODBC32LibsLoaded :=
        Assigned (SQLAllocEnv) and
        Assigned (SQLAllocConnect) and
        Assigned (SQLFreeEnv) and
        Assigned (SQLFreeConnect) and
        Assigned (SQLConnect) and
        Assigned (SQLDisconnect) and
        Assigned (SQLAllocStmt) and
        Assigned (SQLFreeStmt) and
        Assigned (SQLExecDirect) and
        Assigned (SQLFetchScroll) and
        Assigned (SQLGetDiagRec) and
        Assigned (SQLSetPos) and
        Assigned (SQLSetStmtAttr) and
        Assigned (SQLNumResultCols) and
        Assigned (SQLDescribeCol) and
        Assigned (SQLBindCol) and
        Assigned (SQLGetData) and
        Assigned (SQLBindParameter) and
        Assigned (SQLPrepare) and
        Assigned (SQLExecute) and
        Assigned (SQLSetParam) and
        Assigned (SQLRowCount) and
        Assigned (SQLFetch) and
        Assigned (SQLEndTran) and
        Assigned (SQLSetConnectAttr) and
        Assigned (SQLTables) and
        Assigned (SQLDriverConnect);
      //avoid (useless) reloading
      ODBC32LoadLibsFailed := not ODBC32LibsLoaded;
    end;
  Result := ODBC32LibsLoaded;
end;

//some constants
//http://www.cs.uofs.edu/~beidler/Ada/win32/win32-sqlext.html

(*
-- $Source$ 
-- $Revision$ $Date$ $Author$ 
-- See end of file for Copyright (c) information.

with Win32.Sql;
with Win32.Windef;

package Win32.Sqlext is

    use type Interfaces.C.Char_Array;

    SQL_MAX_OPTION_STRING_LENGTH   : constant := 256;       -- sqlext.h:25
    SQL_STILL_EXECUTING            : constant := 2;         -- sqlext.h:28
    SQL_NEED_DATA                  : constant := 99;        -- sqlext.h:29
    SQL_DATE                       : constant := 9;         -- sqlext.h:32
    SQL_TIME                       : constant := 10;        -- sqlext.h:33
    SQL_TIMESTAMP                  : constant := 11;        -- sqlext.h:34
    SQL_LONGVARCHAR                : constant := -1;        -- sqlext.h:35
    SQL_BINARY                     : constant := -2;        -- sqlext.h:36
    SQL_VARBINARY                  : constant := -3;        -- sqlext.h:37
    SQL_LONGVARBINARY              : constant := -4;        -- sqlext.h:38
    SQL_BIGINT                     : constant := -5;        -- sqlext.h:39
    SQL_TINYINT                    : constant := -6;        -- sqlext.h:40
    SQL_BIT                        : constant := -7;        -- sqlext.h:41
    SQL_TYPE_DRIVER_START          : constant := -80;       -- sqlext.h:42
    SQL_SIGNED_OFFSET              : constant := -20;       -- sqlext.h:45
    SQL_UNSIGNED_OFFSET            : constant := -22;       -- sqlext.h:46
    SQL_C_DATE                     : constant := 9;         -- sqlext.h:50
    SQL_C_TIME                     : constant := 10;        -- sqlext.h:51
    SQL_C_TIMESTAMP                : constant := 11;        -- sqlext.h:52
    SQL_C_BINARY                   : constant := -2;        -- sqlext.h:53
    SQL_C_BIT                      : constant := -7;        -- sqlext.h:54
    SQL_C_TINYINT                  : constant := -6;        -- sqlext.h:55
    SQL_C_SLONG                    : constant := -16;       -- sqlext.h:57
    SQL_C_SSHORT                   : constant := -15;       -- sqlext.h:58
    SQL_C_STINYINT                 : constant := -26;       -- sqlext.h:59
    SQL_C_ULONG                    : constant := -18;       -- sqlext.h:60
    SQL_C_USHORT                   : constant := -17;       -- sqlext.h:61
    SQL_C_UTINYINT                 : constant := -28;       -- sqlext.h:62
    SQL_C_BOOKMARK                 : constant := -18;       -- sqlext.h:63
    SQL_TYPE_MIN                   : constant := -7;        -- sqlext.h:102
    SQL_ALL_TYPES                  : constant := 0;         -- sqlext.h:103
    SQL_DRIVER_NOPROMPT            : constant := 0;         -- sqlext.h:109
    SQL_DRIVER_COMPLETE            : constant := 1;         -- sqlext.h:110
    SQL_DRIVER_PROMPT              : constant := 2;         -- sqlext.h:111
    SQL_DRIVER_COMPLETE_REQUIRED   : constant := 3;         -- sqlext.h:112
    SQL_NO_TOTAL                   : constant := -4;        -- sqlext.h:115
    SQL_DEFAULT_PARAM              : constant := -5;        -- sqlext.h:119
    SQL_IGNORE                     : constant := -6;        -- sqlext.h:120
    SQL_LEN_DATA_AT_EXEC_OFFSET    : constant := -100;      -- sqlext.h:121
    SQL_API_SQLALLOCCONNECT        : constant := 1;         -- sqlext.h:126
    SQL_API_SQLALLOCENV            : constant := 2;         -- sqlext.h:127
    SQL_API_SQLALLOCSTMT           : constant := 3;         -- sqlext.h:128
    SQL_API_SQLBINDCOL             : constant := 4;         -- sqlext.h:129
    SQL_API_SQLCANCEL              : constant := 5;         -- sqlext.h:130
    SQL_API_SQLCOLATTRIBUTES       : constant := 6;         -- sqlext.h:131
    SQL_API_SQLCONNECT             : constant := 7;         -- sqlext.h:132
    SQL_API_SQLDESCRIBECOL         : constant := 8;         -- sqlext.h:133
    SQL_API_SQLDISCONNECT          : constant := 9;         -- sqlext.h:134
    SQL_API_SQLERROR               : constant := 10;        -- sqlext.h:135
    SQL_API_SQLEXECDIRECT          : constant := 11;        -- sqlext.h:136
    SQL_API_SQLEXECUTE             : constant := 12;        -- sqlext.h:137
    SQL_API_SQLFETCH               : constant := 13;        -- sqlext.h:138
    SQL_API_SQLFREECONNECT         : constant := 14;        -- sqlext.h:139
    SQL_API_SQLFREEENV             : constant := 15;        -- sqlext.h:140
    SQL_API_SQLFREESTMT            : constant := 16;        -- sqlext.h:141
    SQL_API_SQLGETCURSORNAME       : constant := 17;        -- sqlext.h:142
    SQL_API_SQLNUMRESULTCOLS       : constant := 18;        -- sqlext.h:143
    SQL_API_SQLPREPARE             : constant := 19;        -- sqlext.h:144
    SQL_API_SQLROWCOUNT            : constant := 20;        -- sqlext.h:145
    SQL_API_SQLSETCURSORNAME       : constant := 21;        -- sqlext.h:146
    SQL_API_SQLSETPARAM            : constant := 22;        -- sqlext.h:147
    SQL_API_SQLTRANSACT            : constant := 23;        -- sqlext.h:148
    SQL_NUM_FUNCTIONS              : constant := 23;        -- sqlext.h:150
    SQL_EXT_API_START              : constant := 40;        -- sqlext.h:152
    SQL_API_SQLCOLUMNS             : constant := 40;        -- sqlext.h:154
    SQL_API_SQLDRIVERCONNECT       : constant := 41;        -- sqlext.h:155
    SQL_API_SQLGETCONNECTOPTION    : constant := 42;        -- sqlext.h:156
    SQL_API_SQLGETDATA             : constant := 43;        -- sqlext.h:157
    SQL_API_SQLGETFUNCTIONS        : constant := 44;        -- sqlext.h:158
    SQL_API_SQLGETINFO             : constant := 45;        -- sqlext.h:159
    SQL_API_SQLGETSTMTOPTION       : constant := 46;        -- sqlext.h:160
    SQL_API_SQLGETTYPEINFO         : constant := 47;        -- sqlext.h:161
    SQL_API_SQLPARAMDATA           : constant := 48;        -- sqlext.h:162
    SQL_API_SQLPUTDATA             : constant := 49;        -- sqlext.h:163
    SQL_API_SQLSETCONNECTOPTION    : constant := 50;        -- sqlext.h:164
    SQL_API_SQLSETSTMTOPTION       : constant := 51;        -- sqlext.h:165
    SQL_API_SQLSPECIALCOLUMNS      : constant := 52;        -- sqlext.h:166
    SQL_API_SQLSTATISTICS          : constant := 53;        -- sqlext.h:167
    SQL_API_SQLTABLES              : constant := 54;        -- sqlext.h:168
    SQL_API_SQLBROWSECONNECT       : constant := 55;        -- sqlext.h:170
    SQL_API_SQLCOLUMNPRIVILEGES    : constant := 56;        -- sqlext.h:171
    SQL_API_SQLDATASOURCES         : constant := 57;        -- sqlext.h:172
    SQL_API_SQLDESCRIBEPARAM       : constant := 58;        -- sqlext.h:173
    SQL_API_SQLEXTENDEDFETCH       : constant := 59;        -- sqlext.h:174
    SQL_API_SQLFOREIGNKEYS         : constant := 60;        -- sqlext.h:175
    SQL_API_SQLMORERESULTS         : constant := 61;        -- sqlext.h:176
    SQL_API_SQLNATIVESQL           : constant := 62;        -- sqlext.h:177
    SQL_API_SQLNUMPARAMS           : constant := 63;        -- sqlext.h:178
    SQL_API_SQLPARAMOPTIONS        : constant := 64;        -- sqlext.h:179
    SQL_API_SQLPRIMARYKEYS         : constant := 65;        -- sqlext.h:180
    SQL_API_SQLPROCEDURECOLUMNS    : constant := 66;        -- sqlext.h:181
    SQL_API_SQLPROCEDURES          : constant := 67;        -- sqlext.h:182
    SQL_API_SQLSETPOS              : constant := 68;        -- sqlext.h:183
    SQL_API_SQLSETSCROLLOPTIONS    : constant := 69;        -- sqlext.h:184
    SQL_API_SQLTABLEPRIVILEGES     : constant := 70;        -- sqlext.h:185
    SQL_API_SQLDRIVERS             : constant := 71;        -- sqlext.h:189
    SQL_API_SQLBINDPARAMETER       : constant := 72;        -- sqlext.h:190
    SQL_EXT_API_LAST               : constant := 72;        -- sqlext.h:191
    SQL_API_ALL_FUNCTIONS          : constant := 0;         -- sqlext.h:196
    SQL_NUM_EXTENSIONS             : constant := 33;        -- sqlext.h:198
    SQL_API_LOADBYORDINAL          : constant := 199;       -- sqlext.h:200
    SQL_INFO_FIRST                 : constant := 0;         -- sqlext.h:204
    SQL_ACTIVE_CONNECTIONS         : constant := 0;         -- sqlext.h:205
    SQL_ACTIVE_STATEMENTS          : constant := 1;         -- sqlext.h:206
    SQL_DATA_SOURCE_NAME           : constant := 2;         -- sqlext.h:207
    SQL_DRIVER_HDBC                : constant := 3;         -- sqlext.h:208
    SQL_DRIVER_HENV                : constant := 4;         -- sqlext.h:209
    SQL_DRIVER_HSTMT               : constant := 5;         -- sqlext.h:210
    SQL_DRIVER_NAME                : constant := 6;         -- sqlext.h:211
    SQL_DRIVER_VER                 : constant := 7;         -- sqlext.h:212
    SQL_FETCH_DIRECTION            : constant := 8;         -- sqlext.h:213
    SQL_ODBC_API_CONFORMANCE       : constant := 9;         -- sqlext.h:214
    SQL_ODBC_VER                   : constant := 10;        -- sqlext.h:215
    SQL_ROW_UPDATES                : constant := 11;        -- sqlext.h:216
    SQL_ODBC_SAG_CLI_CONFORMANCE   : constant := 12;        -- sqlext.h:217
    SQL_SERVER_NAME                : constant := 13;        -- sqlext.h:218
    SQL_SEARCH_PATTERN_ESCAPE      : constant := 14;        -- sqlext.h:219
    SQL_ODBC_SQL_CONFORMANCE       : constant := 15;        -- sqlext.h:220
    SQL_DBMS_NAME                  : constant := 17;        -- sqlext.h:222
    SQL_DBMS_VER                   : constant := 18;        -- sqlext.h:223
    SQL_ACCESSIBLE_TABLES          : constant := 19;        -- sqlext.h:225
    SQL_ACCESSIBLE_PROCEDURES      : constant := 20;        -- sqlext.h:226
    SQL_PROCEDURES                 : constant := 21;        -- sqlext.h:227
    SQL_CONCAT_NULL_BEHAVIOR       : constant := 22;        -- sqlext.h:228
    SQL_CURSOR_COMMIT_BEHAVIOR     : constant := 23;        -- sqlext.h:229
    SQL_CURSOR_ROLLBACK_BEHAVIOR   : constant := 24;        -- sqlext.h:230
    SQL_DATA_SOURCE_READ_ONLY      : constant := 25;        -- sqlext.h:231
    SQL_DEFAULT_TXN_ISOLATION      : constant := 26;        -- sqlext.h:232
    SQL_EXPRESSIONS_IN_ORDERBY     : constant := 27;        -- sqlext.h:233
    SQL_IDENTIFIER_CASE            : constant := 28;        -- sqlext.h:234
    SQL_IDENTIFIER_QUOTE_CHAR      : constant := 29;        -- sqlext.h:235
    SQL_MAX_COLUMN_NAME_LEN        : constant := 30;        -- sqlext.h:236
    SQL_MAX_CURSOR_NAME_LEN        : constant := 31;        -- sqlext.h:237
    SQL_MAX_OWNER_NAME_LEN         : constant := 32;        -- sqlext.h:238
    SQL_MAX_PROCEDURE_NAME_LEN     : constant := 33;        -- sqlext.h:239
    SQL_MAX_QUALIFIER_NAME_LEN     : constant := 34;        -- sqlext.h:240
    SQL_MAX_TABLE_NAME_LEN         : constant := 35;        -- sqlext.h:241
    SQL_MULT_RESULT_SETS           : constant := 36;        -- sqlext.h:242
    SQL_MULTIPLE_ACTIVE_TXN        : constant := 37;        -- sqlext.h:243
    SQL_OUTER_JOINS                : constant := 38;        -- sqlext.h:244
    SQL_OWNER_TERM                 : constant := 39;        -- sqlext.h:245
    SQL_PROCEDURE_TERM             : constant := 40;        -- sqlext.h:246
    SQL_QUALIFIER_NAME_SEPARATOR   : constant := 41;        -- sqlext.h:247
    SQL_QUALIFIER_TERM             : constant := 42;        -- sqlext.h:248
    SQL_SCROLL_CONCURRENCY         : constant := 43;        -- sqlext.h:249
    SQL_SCROLL_OPTIONS             : constant := 44;        -- sqlext.h:250
    SQL_TABLE_TERM                 : constant := 45;        -- sqlext.h:251
    SQL_TXN_CAPABLE                : constant := 46;        -- sqlext.h:252
    SQL_USER_NAME                  : constant := 47;        -- sqlext.h:253
    SQL_CONVERT_FUNCTIONS          : constant := 48;        -- sqlext.h:255
    SQL_NUMERIC_FUNCTIONS          : constant := 49;        -- sqlext.h:256
    SQL_STRING_FUNCTIONS           : constant := 50;        -- sqlext.h:257
    SQL_SYSTEM_FUNCTIONS           : constant := 51;        -- sqlext.h:258
    SQL_TIMEDATE_FUNCTIONS         : constant := 52;        -- sqlext.h:259
    SQL_CONVERT_BIGINT             : constant := 53;        -- sqlext.h:261
    SQL_CONVERT_BINARY             : constant := 54;        -- sqlext.h:262
    SQL_CONVERT_BIT                : constant := 55;        -- sqlext.h:263
    SQL_CONVERT_CHAR               : constant := 56;        -- sqlext.h:264
    SQL_CONVERT_DATE               : constant := 57;        -- sqlext.h:265
    SQL_CONVERT_DECIMAL            : constant := 58;        -- sqlext.h:266
    SQL_CONVERT_DOUBLE             : constant := 59;        -- sqlext.h:267
    SQL_CONVERT_FLOAT              : constant := 60;        -- sqlext.h:268
    SQL_CONVERT_INTEGER            : constant := 61;        -- sqlext.h:269
    SQL_CONVERT_LONGVARCHAR        : constant := 62;        -- sqlext.h:270
    SQL_CONVERT_NUMERIC            : constant := 63;        -- sqlext.h:271
    SQL_CONVERT_REAL               : constant := 64;        -- sqlext.h:272
    SQL_CONVERT_SMALLINT           : constant := 65;        -- sqlext.h:273
    SQL_CONVERT_TIME               : constant := 66;        -- sqlext.h:274
    SQL_CONVERT_TIMESTAMP          : constant := 67;        -- sqlext.h:275
    SQL_CONVERT_TINYINT            : constant := 68;        -- sqlext.h:276
    SQL_CONVERT_VARBINARY          : constant := 69;        -- sqlext.h:277
    SQL_CONVERT_VARCHAR            : constant := 70;        -- sqlext.h:278
    SQL_CONVERT_LONGVARBINARY      : constant := 71;        -- sqlext.h:279
    SQL_TXN_ISOLATION_OPTION       : constant := 72;        -- sqlext.h:281
    SQL_ODBC_SQL_OPT_IEF           : constant := 73;        -- sqlext.h:282
    SQL_CORRELATION_NAME           : constant := 74;        -- sqlext.h:285
    SQL_NON_NULLABLE_COLUMNS       : constant := 75;        -- sqlext.h:286
    SQL_DRIVER_HLIB                : constant := 76;        -- sqlext.h:290
    SQL_DRIVER_ODBC_VER            : constant := 77;        -- sqlext.h:291
    SQL_LOCK_TYPES                 : constant := 78;        -- sqlext.h:292
    SQL_POS_OPERATIONS             : constant := 79;        -- sqlext.h:293
    SQL_POSITIONED_STATEMENTS      : constant := 80;        -- sqlext.h:294
    SQL_GETDATA_EXTENSIONS         : constant := 81;        -- sqlext.h:295
    SQL_BOOKMARK_PERSISTENCE       : constant := 82;        -- sqlext.h:296
    SQL_STATIC_SENSITIVITY         : constant := 83;        -- sqlext.h:297
    SQL_FILE_USAGE                 : constant := 84;        -- sqlext.h:298
    SQL_NULL_COLLATION             : constant := 85;        -- sqlext.h:299
    SQL_ALTER_TABLE                : constant := 86;        -- sqlext.h:300
    SQL_COLUMN_ALIAS               : constant := 87;        -- sqlext.h:301
    SQL_GROUP_BY                   : constant := 88;        -- sqlext.h:302
    SQL_KEYWORDS                   : constant := 89;        -- sqlext.h:303
    SQL_ORDER_BY_COLUMNS_IN_SELECT : constant := 90;        -- sqlext.h:304
    SQL_OWNER_USAGE                : constant := 91;        -- sqlext.h:305
    SQL_QUALIFIER_USAGE            : constant := 92;        -- sqlext.h:306
    SQL_QUOTED_IDENTIFIER_CASE     : constant := 93;        -- sqlext.h:307
    SQL_SPECIAL_CHARACTERS         : constant := 94;        -- sqlext.h:308
    SQL_SUBQUERIES                 : constant := 95;        -- sqlext.h:309
    SQL_UNION                      : constant := 96;        -- sqlext.h:310
    SQL_MAX_COLUMNS_IN_GROUP_BY    : constant := 97;        -- sqlext.h:311
    SQL_MAX_COLUMNS_IN_INDEX       : constant := 98;        -- sqlext.h:312
    SQL_MAX_COLUMNS_IN_ORDER_BY    : constant := 99;        -- sqlext.h:313
    SQL_MAX_COLUMNS_IN_SELECT      : constant := 100;       -- sqlext.h:314
    SQL_MAX_COLUMNS_IN_TABLE       : constant := 101;       -- sqlext.h:315
    SQL_MAX_INDEX_SIZE             : constant := 102;       -- sqlext.h:316
    SQL_MAX_ROW_SIZE_INCLUDES_LONG : constant := 103;       -- sqlext.h:317
    SQL_MAX_ROW_SIZE               : constant := 104;       -- sqlext.h:318
    SQL_MAX_STATEMENT_LEN          : constant := 105;       -- sqlext.h:319
    SQL_MAX_TABLES_IN_SELECT       : constant := 106;       -- sqlext.h:320
    SQL_MAX_USER_NAME_LEN          : constant := 107;       -- sqlext.h:321
    SQL_MAX_CHAR_LITERAL_LEN       : constant := 108;       -- sqlext.h:322
    SQL_TIMEDATE_ADD_INTERVALS     : constant := 109;       -- sqlext.h:323
    SQL_TIMEDATE_DIFF_INTERVALS    : constant := 110;       -- sqlext.h:324
    SQL_NEED_LONG_DATA_LEN         : constant := 111;       -- sqlext.h:325
    SQL_MAX_BINARY_LITERAL_LEN     : constant := 112;       -- sqlext.h:326
    SQL_LIKE_ESCAPE_CLAUSE         : constant := 113;       -- sqlext.h:327
    SQL_QUALIFIER_LOCATION         : constant := 114;       -- sqlext.h:328
    SQL_OJ_CAPABILITIES            : constant := 65002;     -- sqlext.h:332
    SQL_INFO_LAST                  : constant := 114;       -- sqlext.h:335
    SQL_INFO_DRIVER_START          : constant := 1000;      -- sqlext.h:340
    SQL_CVT_CHAR                   : constant := 16#1#;     -- sqlext.h:344
    SQL_CVT_NUMERIC                : constant := 16#2#;     -- sqlext.h:345
    SQL_CVT_DECIMAL                : constant := 16#4#;     -- sqlext.h:346
    SQL_CVT_INTEGER                : constant := 16#8#;     -- sqlext.h:347
    SQL_CVT_SMALLINT               : constant := 16#10#;    -- sqlext.h:348
    SQL_CVT_FLOAT                  : constant := 16#20#;    -- sqlext.h:349
    SQL_CVT_REAL                   : constant := 16#40#;    -- sqlext.h:350
    SQL_CVT_DOUBLE                 : constant := 16#80#;    -- sqlext.h:351
    SQL_CVT_VARCHAR                : constant := 16#100#;   -- sqlext.h:352
    SQL_CVT_LONGVARCHAR            : constant := 16#200#;   -- sqlext.h:353
    SQL_CVT_BINARY                 : constant := 16#400#;   -- sqlext.h:354
    SQL_CVT_VARBINARY              : constant := 16#800#;   -- sqlext.h:355
    SQL_CVT_BIT                    : constant := 16#1000#;
                                                            -- sqlext.h:356
    SQL_CVT_TINYINT                : constant := 16#2000#;
                                                            -- sqlext.h:357
    SQL_CVT_BIGINT                 : constant := 16#4000#;
                                                            -- sqlext.h:358
    SQL_CVT_DATE                   : constant := 16#8000#;
                                                            -- sqlext.h:359
    SQL_CVT_TIME                   : constant := 16#10000#;
                                                            -- sqlext.h:360
    SQL_CVT_TIMESTAMP              : constant := 16#20000#;
                                                            -- sqlext.h:361
    SQL_CVT_LONGVARBINARY          : constant := 16#40000#;
                                                            -- sqlext.h:362
    SQL_FN_CVT_CONVERT             : constant := 16#1#;     -- sqlext.h:365
    SQL_FN_STR_CONCAT              : constant := 16#1#;     -- sqlext.h:369
    SQL_FN_STR_INSERT              : constant := 16#2#;     -- sqlext.h:370
    SQL_FN_STR_LEFT                : constant := 16#4#;     -- sqlext.h:371
    SQL_FN_STR_LTRIM               : constant := 16#8#;     -- sqlext.h:372
    SQL_FN_STR_LENGTH              : constant := 16#10#;    -- sqlext.h:373
    SQL_FN_STR_LOCATE              : constant := 16#20#;    -- sqlext.h:374
    SQL_FN_STR_LCASE               : constant := 16#40#;    -- sqlext.h:375
    SQL_FN_STR_REPEAT              : constant := 16#80#;    -- sqlext.h:376
    SQL_FN_STR_REPLACE             : constant := 16#100#;   -- sqlext.h:377
    SQL_FN_STR_RIGHT               : constant := 16#200#;   -- sqlext.h:378
    SQL_FN_STR_RTRIM               : constant := 16#400#;   -- sqlext.h:379
    SQL_FN_STR_SUBSTRING           : constant := 16#800#;   -- sqlext.h:380
    SQL_FN_STR_UCASE               : constant := 16#1000#;
                                                            -- sqlext.h:381
    SQL_FN_STR_ASCII               : constant := 16#2000#;
                                                            -- sqlext.h:382
    SQL_FN_STR_CHAR                : constant := 16#4000#;
                                                            -- sqlext.h:383
    SQL_FN_STR_DIFFERENCE          : constant := 16#8000#;
                                                            -- sqlext.h:385
    SQL_FN_STR_LOCATE_2            : constant := 16#10000#;
                                                            -- sqlext.h:386
    SQL_FN_STR_SOUNDEX             : constant := 16#20000#;
                                                            -- sqlext.h:387
    SQL_FN_STR_SPACE               : constant := 16#40000#;
                                                            -- sqlext.h:388
    SQL_FN_NUM_ABS                 : constant := 16#1#;     -- sqlext.h:393
    SQL_FN_NUM_ACOS                : constant := 16#2#;     -- sqlext.h:394
    SQL_FN_NUM_ASIN                : constant := 16#4#;     -- sqlext.h:395
    SQL_FN_NUM_ATAN                : constant := 16#8#;     -- sqlext.h:396
    SQL_FN_NUM_ATAN2               : constant := 16#10#;    -- sqlext.h:397
    SQL_FN_NUM_CEILING             : constant := 16#20#;    -- sqlext.h:398
    SQL_FN_NUM_COS                 : constant := 16#40#;    -- sqlext.h:399
    SQL_FN_NUM_COT                 : constant := 16#80#;    -- sqlext.h:400
    SQL_FN_NUM_EXP                 : constant := 16#100#;   -- sqlext.h:401
    SQL_FN_NUM_FLOOR               : constant := 16#200#;   -- sqlext.h:402
    SQL_FN_NUM_LOG                 : constant := 16#400#;   -- sqlext.h:403
    SQL_FN_NUM_MOD                 : constant := 16#800#;   -- sqlext.h:404
    SQL_FN_NUM_SIGN                : constant := 16#1000#;
                                                            -- sqlext.h:405
    SQL_FN_NUM_SIN                 : constant := 16#2000#;
                                                            -- sqlext.h:406
    SQL_FN_NUM_SQRT                : constant := 16#4000#;
                                                            -- sqlext.h:407
    SQL_FN_NUM_TAN                 : constant := 16#8000#;
                                                            -- sqlext.h:408
    SQL_FN_NUM_PI                  : constant := 16#10000#;
                                                            -- sqlext.h:409
    SQL_FN_NUM_RAND                : constant := 16#20000#;
                                                            -- sqlext.h:410
    SQL_FN_NUM_DEGREES             : constant := 16#40000#;
                                                            -- sqlext.h:412
    SQL_FN_NUM_LOG10               : constant := 16#80000#;
                                                            -- sqlext.h:413
    SQL_FN_NUM_POWER               : constant := 16#100000#;
                                                            -- sqlext.h:414
    SQL_FN_NUM_RADIANS             : constant := 16#200000#;
                                                            -- sqlext.h:415
    SQL_FN_NUM_ROUND               : constant := 16#400000#;
                                                            -- sqlext.h:416
    SQL_FN_NUM_TRUNCATE            : constant := 16#800000#;
                                                            -- sqlext.h:417
    SQL_FN_TD_NOW                  : constant := 16#1#;     -- sqlext.h:422
    SQL_FN_TD_CURDATE              : constant := 16#2#;     -- sqlext.h:423
    SQL_FN_TD_DAYOFMONTH           : constant := 16#4#;     -- sqlext.h:424
    SQL_FN_TD_DAYOFWEEK            : constant := 16#8#;     -- sqlext.h:425
    SQL_FN_TD_DAYOFYEAR            : constant := 16#10#;    -- sqlext.h:426
    SQL_FN_TD_MONTH                : constant := 16#20#;    -- sqlext.h:427
    SQL_FN_TD_QUARTER              : constant := 16#40#;    -- sqlext.h:428
    SQL_FN_TD_WEEK                 : constant := 16#80#;    -- sqlext.h:429
    SQL_FN_TD_YEAR                 : constant := 16#100#;   -- sqlext.h:430
    SQL_FN_TD_CURTIME              : constant := 16#200#;   -- sqlext.h:431
    SQL_FN_TD_HOUR                 : constant := 16#400#;   -- sqlext.h:432
    SQL_FN_TD_MINUTE               : constant := 16#800#;   -- sqlext.h:433
    SQL_FN_TD_SECOND               : constant := 16#1000#;
                                                            -- sqlext.h:434
    SQL_FN_TD_TIMESTAMPADD         : constant := 16#2000#;
                                                            -- sqlext.h:436
    SQL_FN_TD_TIMESTAMPDIFF        : constant := 16#4000#;
                                                            -- sqlext.h:437
    SQL_FN_TD_DAYNAME              : constant := 16#8000#;
                                                            -- sqlext.h:438
    SQL_FN_TD_MONTHNAME            : constant := 16#10000#;
                                                            -- sqlext.h:439
    SQL_FN_SYS_USERNAME            : constant := 16#1#;     -- sqlext.h:444
    SQL_FN_SYS_DBNAME              : constant := 16#2#;     -- sqlext.h:445
    SQL_FN_SYS_IFNULL              : constant := 16#4#;     -- sqlext.h:446
    SQL_FN_TSI_FRAC_SECOND         : constant := 16#1#;     -- sqlext.h:451
    SQL_FN_TSI_SECOND              : constant := 16#2#;     -- sqlext.h:452
    SQL_FN_TSI_MINUTE              : constant := 16#4#;     -- sqlext.h:453
    SQL_FN_TSI_HOUR                : constant := 16#8#;     -- sqlext.h:454
    SQL_FN_TSI_DAY                 : constant := 16#10#;    -- sqlext.h:455
    SQL_FN_TSI_WEEK                : constant := 16#20#;    -- sqlext.h:456
    SQL_FN_TSI_MONTH               : constant := 16#40#;    -- sqlext.h:457
    SQL_FN_TSI_QUARTER             : constant := 16#80#;    -- sqlext.h:458
    SQL_FN_TSI_YEAR                : constant := 16#100#;   -- sqlext.h:459
    SQL_OAC_NONE                   : constant := 16#0#;     -- sqlext.h:464
    SQL_OAC_LEVEL1                 : constant := 16#1#;     -- sqlext.h:465
    SQL_OAC_LEVEL2                 : constant := 16#2#;     -- sqlext.h:466
    SQL_OSCC_NOT_COMPLIANT         : constant := 16#0#;     -- sqlext.h:470
    SQL_OSCC_COMPLIANT             : constant := 16#1#;     -- sqlext.h:471
    SQL_OSC_MINIMUM                : constant := 16#0#;     -- sqlext.h:475
    SQL_OSC_CORE                   : constant := 16#1#;     -- sqlext.h:476
    SQL_OSC_EXTENDED               : constant := 16#2#;     -- sqlext.h:477
    SQL_CB_NULL                    : constant := 16#0#;     -- sqlext.h:481
    SQL_CB_NON_NULL                : constant := 16#1#;     -- sqlext.h:482
    SQL_CB_DELETE                  : constant := 16#0#;     -- sqlext.h:486
    SQL_CB_CLOSE                   : constant := 16#1#;     -- sqlext.h:487
    SQL_CB_PRESERVE                : constant := 16#2#;     -- sqlext.h:488
    SQL_IC_UPPER                   : constant := 16#1#;     -- sqlext.h:492
    SQL_IC_LOWER                   : constant := 16#2#;     -- sqlext.h:493
    SQL_IC_SENSITIVE               : constant := 16#3#;     -- sqlext.h:494
    SQL_IC_MIXED                   : constant := 16#4#;     -- sqlext.h:495
    SQL_TC_NONE                    : constant := 16#0#;     -- sqlext.h:499
    SQL_TC_DML                     : constant := 16#1#;     -- sqlext.h:500
    SQL_TC_ALL                     : constant := 16#2#;     -- sqlext.h:501
    SQL_TC_DDL_COMMIT              : constant := 16#3#;     -- sqlext.h:503
    SQL_TC_DDL_IGNORE              : constant := 16#4#;     -- sqlext.h:504
    SQL_SO_FORWARD_ONLY            : constant := 16#1#;     -- sqlext.h:509
    SQL_SO_KEYSET_DRIVEN           : constant := 16#2#;     -- sqlext.h:510
    SQL_SO_DYNAMIC                 : constant := 16#4#;     -- sqlext.h:511
    SQL_SO_MIXED                   : constant := 16#8#;     -- sqlext.h:512
    SQL_SO_STATIC                  : constant := 16#10#;    -- sqlext.h:514
    SQL_SCCO_READ_ONLY             : constant := 16#1#;     -- sqlext.h:519
    SQL_SCCO_LOCK                  : constant := 16#2#;     -- sqlext.h:520
    SQL_SCCO_OPT_ROWVER            : constant := 16#4#;     -- sqlext.h:521
    SQL_SCCO_OPT_VALUES            : constant := 16#8#;     -- sqlext.h:522
    SQL_FD_FETCH_NEXT              : constant := 16#1#;     -- sqlext.h:526
    SQL_FD_FETCH_FIRST             : constant := 16#2#;     -- sqlext.h:527
    SQL_FD_FETCH_LAST              : constant := 16#4#;     -- sqlext.h:528
    SQL_FD_FETCH_PRIOR             : constant := 16#8#;     -- sqlext.h:529
    SQL_FD_FETCH_ABSOLUTE          : constant := 16#10#;    -- sqlext.h:530
    SQL_FD_FETCH_RELATIVE          : constant := 16#20#;    -- sqlext.h:531
    SQL_FD_FETCH_RESUME            : constant := 16#40#;    -- sqlext.h:532
    SQL_FD_FETCH_BOOKMARK          : constant := 16#80#;    -- sqlext.h:534
    SQL_TXN_READ_UNCOMMITTED       : constant := 16#1#;     -- sqlext.h:539
    SQL_TXN_READ_COMMITTED         : constant := 16#2#;     -- sqlext.h:540
    SQL_TXN_REPEATABLE_READ        : constant := 16#4#;     -- sqlext.h:541
    SQL_TXN_SERIALIZABLE           : constant := 16#8#;     -- sqlext.h:542
    SQL_TXN_VERSIONING             : constant := 16#10#;    -- sqlext.h:543
    SQL_CN_NONE                    : constant := 16#0#;     -- sqlext.h:547
    SQL_CN_DIFFERENT               : constant := 16#1#;     -- sqlext.h:548
    SQL_CN_ANY                     : constant := 16#2#;     -- sqlext.h:549
    SQL_NNC_NULL                   : constant := 16#0#;     -- sqlext.h:553
    SQL_NNC_NON_NULL               : constant := 16#1#;     -- sqlext.h:554
    SQL_NC_HIGH                    : constant := 16#0#;     -- sqlext.h:559
    SQL_NC_LOW                     : constant := 16#1#;     -- sqlext.h:560
    SQL_NC_START                   : constant := 16#2#;     -- sqlext.h:561
    SQL_NC_END                     : constant := 16#4#;     -- sqlext.h:562
    SQL_FILE_NOT_SUPPORTED         : constant := 16#0#;     -- sqlext.h:566
    SQL_FILE_TABLE                 : constant := 16#1#;     -- sqlext.h:567
    SQL_FILE_QUALIFIER             : constant := 16#2#;     -- sqlext.h:568
    SQL_GD_ANY_COLUMN              : constant := 16#1#;     -- sqlext.h:572
    SQL_GD_ANY_ORDER               : constant := 16#2#;     -- sqlext.h:573
    SQL_GD_BLOCK                   : constant := 16#4#;     -- sqlext.h:574
    SQL_GD_BOUND                   : constant := 16#8#;     -- sqlext.h:575
    SQL_AT_ADD_COLUMN              : constant := 16#1#;     -- sqlext.h:579
    SQL_AT_DROP_COLUMN             : constant := 16#2#;     -- sqlext.h:580
    SQL_PS_POSITIONED_DELETE       : constant := 16#1#;     -- sqlext.h:584
    SQL_PS_POSITIONED_UPDATE       : constant := 16#2#;     -- sqlext.h:585
    SQL_PS_SELECT_FOR_UPDATE       : constant := 16#4#;     -- sqlext.h:586
    SQL_GB_NOT_SUPPORTED           : constant := 16#0#;     -- sqlext.h:590
    SQL_GB_GROUP_BY_EQUALS_SELECT  : constant := 16#1#;     -- sqlext.h:591
    SQL_GB_GROUP_BY_CONTAINS_SELECT: constant := 16#2#;     -- sqlext.h:592
    SQL_GB_NO_RELATION             : constant := 16#3#;     -- sqlext.h:593
    SQL_OU_DML_STATEMENTS          : constant := 16#1#;     -- sqlext.h:597
    SQL_OU_PROCEDURE_INVOCATION    : constant := 16#2#;     -- sqlext.h:598
    SQL_OU_TABLE_DEFINITION        : constant := 16#4#;     -- sqlext.h:599
    SQL_OU_INDEX_DEFINITION        : constant := 16#8#;     -- sqlext.h:600
    SQL_OU_PRIVILEGE_DEFINITION    : constant := 16#10#;    -- sqlext.h:601
    SQL_QU_DML_STATEMENTS          : constant := 16#1#;     -- sqlext.h:605
    SQL_QU_PROCEDURE_INVOCATION    : constant := 16#2#;     -- sqlext.h:606
    SQL_QU_TABLE_DEFINITION        : constant := 16#4#;     -- sqlext.h:607
    SQL_QU_INDEX_DEFINITION        : constant := 16#8#;     -- sqlext.h:608
    SQL_QU_PRIVILEGE_DEFINITION    : constant := 16#10#;    -- sqlext.h:609
    SQL_SQ_COMPARISON              : constant := 16#1#;     -- sqlext.h:613
    SQL_SQ_EXISTS                  : constant := 16#2#;     -- sqlext.h:614
    SQL_SQ_IN                      : constant := 16#4#;     -- sqlext.h:615
    SQL_SQ_QUANTIFIED              : constant := 16#8#;     -- sqlext.h:616
    SQL_SQ_CORRELATED_SUBQUERIES   : constant := 16#10#;    -- sqlext.h:617
    SQL_U_UNION                    : constant := 16#1#;     -- sqlext.h:621
    SQL_U_UNION_ALL                : constant := 16#2#;     -- sqlext.h:622
    SQL_BP_CLOSE                   : constant := 16#1#;     -- sqlext.h:626
    SQL_BP_DELETE                  : constant := 16#2#;     -- sqlext.h:627
    SQL_BP_DROP                    : constant := 16#4#;     -- sqlext.h:628
    SQL_BP_TRANSACTION             : constant := 16#8#;     -- sqlext.h:629
    SQL_BP_UPDATE                  : constant := 16#10#;    -- sqlext.h:630
    SQL_BP_OTHER_HSTMT             : constant := 16#20#;    -- sqlext.h:631
    SQL_BP_SCROLL                  : constant := 16#40#;    -- sqlext.h:632
    SQL_SS_ADDITIONS               : constant := 16#1#;     -- sqlext.h:636
    SQL_SS_DELETIONS               : constant := 16#2#;     -- sqlext.h:637
    SQL_SS_UPDATES                 : constant := 16#4#;     -- sqlext.h:638
    SQL_LCK_NO_CHANGE              : constant := 16#1#;     -- sqlext.h:642
    SQL_LCK_EXCLUSIVE              : constant := 16#2#;     -- sqlext.h:643
    SQL_LCK_UNLOCK                 : constant := 16#4#;     -- sqlext.h:644
    SQL_POS_POSITION               : constant := 16#1#;     -- sqlext.h:648
    SQL_POS_REFRESH                : constant := 16#2#;     -- sqlext.h:649
    SQL_POS_UPDATE                 : constant := 16#4#;     -- sqlext.h:650
    SQL_POS_DELETE                 : constant := 16#8#;     -- sqlext.h:651
    SQL_POS_ADD                    : constant := 16#10#;    -- sqlext.h:652
    SQL_QL_START                   : constant := 16#1#;     -- sqlext.h:656
    SQL_QL_END                     : constant := 16#2#;     -- sqlext.h:657
    SQL_OJ_LEFT                    : constant := 16#1#;     -- sqlext.h:662
    SQL_OJ_RIGHT                   : constant := 16#2#;     -- sqlext.h:663
    SQL_OJ_FULL                    : constant := 16#4#;     -- sqlext.h:664
    SQL_OJ_NESTED                  : constant := 16#8#;     -- sqlext.h:665
    SQL_OJ_NOT_ORDERED             : constant := 16#10#;    -- sqlext.h:666
    SQL_OJ_INNER                   : constant := 16#20#;    -- sqlext.h:667
    SQL_OJ_ALL_COMPARISON_OPS      : constant := 16#40#;    -- sqlext.h:668
    SQL_QUERY_TIMEOUT              : constant := 0;         -- sqlext.h:673
    SQL_MAX_ROWS                   : constant := 1;         -- sqlext.h:674
    SQL_NOSCAN                     : constant := 2;         -- sqlext.h:675
    SQL_MAX_LENGTH                 : constant := 3;         -- sqlext.h:676
    SQL_ASYNC_ENABLE               : constant := 4;         -- sqlext.h:677
    SQL_BIND_TYPE                  : constant := 5;         -- sqlext.h:678
    SQL_CURSOR_TYPE                : constant := 6;         -- sqlext.h:680
    SQL_CONCURRENCY                : constant := 7;         -- sqlext.h:681
    SQL_KEYSET_SIZE                : constant := 8;         -- sqlext.h:682
    SQL_ROWSET_SIZE                : constant := 9;         -- sqlext.h:683
    SQL_SIMULATE_CURSOR            : constant := 10;        -- sqlext.h:684
    SQL_RETRIEVE_DATA              : constant := 11;        -- sqlext.h:685
    SQL_USE_BOOKMARKS              : constant := 12;        -- sqlext.h:686
    SQL_GET_BOOKMARK               : constant := 13;        -- sqlext.h:687
    SQL_ROW_NUMBER                 : constant := 14;        -- sqlext.h:688
    SQL_STMT_OPT_MAX               : constant := 14;        -- sqlext.h:689
    SQL_STMT_OPT_MIN               : constant := 0;         -- sqlext.h:694
    SQL_QUERY_TIMEOUT_DEFAULT      : constant := 0;         -- sqlext.h:698
    SQL_MAX_ROWS_DEFAULT           : constant := 0;         -- sqlext.h:701
    SQL_NOSCAN_OFF                 : constant := 0;         -- sqlext.h:704
    SQL_NOSCAN_ON                  : constant := 1;         -- sqlext.h:705
    SQL_NOSCAN_DEFAULT             : constant := 0;         -- sqlext.h:706
    SQL_MAX_LENGTH_DEFAULT         : constant := 0;         -- sqlext.h:709
    SQL_ASYNC_ENABLE_OFF           : constant := 0;         -- sqlext.h:712
    SQL_ASYNC_ENABLE_ON            : constant := 1;         -- sqlext.h:713
    SQL_ASYNC_ENABLE_DEFAULT       : constant := 0;         -- sqlext.h:714
    SQL_BIND_BY_COLUMN             : constant := 0;         -- sqlext.h:717
    SQL_CONCUR_READ_ONLY           : constant := 1;         -- sqlext.h:720
    SQL_CONCUR_LOCK                : constant := 2;         -- sqlext.h:721
    SQL_CONCUR_ROWVER              : constant := 3;         -- sqlext.h:722
    SQL_CONCUR_VALUES              : constant := 4;         -- sqlext.h:723
    SQL_CURSOR_FORWARD_ONLY        : constant := 0;         -- sqlext.h:727
    SQL_CURSOR_KEYSET_DRIVEN       : constant := 1;         -- sqlext.h:728
    SQL_CURSOR_DYNAMIC             : constant := 2;         -- sqlext.h:729
    SQL_CURSOR_STATIC              : constant := 3;         -- sqlext.h:730
    SQL_ROWSET_SIZE_DEFAULT        : constant := 1;         -- sqlext.h:733
    SQL_KEYSET_SIZE_DEFAULT        : constant := 0;         -- sqlext.h:736
    SQL_SC_NON_UNIQUE              : constant := 0;         -- sqlext.h:739
    SQL_SC_TRY_UNIQUE              : constant := 1;         -- sqlext.h:740
    SQL_SC_UNIQUE                  : constant := 2;         -- sqlext.h:741
    SQL_RD_OFF                     : constant := 0;         -- sqlext.h:744
    SQL_RD_ON                      : constant := 1;         -- sqlext.h:745
    SQL_RD_DEFAULT                 : constant := 1;         -- sqlext.h:746
    SQL_UB_OFF                     : constant := 0;         -- sqlext.h:749
    SQL_UB_ON                      : constant := 1;         -- sqlext.h:750
    SQL_UB_DEFAULT                 : constant := 0;         -- sqlext.h:751
    SQL_ACCESS_MODE                : constant := 101;       -- sqlext.h:756
    SQL_AUTOCOMMIT                 : constant := 102;       -- sqlext.h:757
    SQL_LOGIN_TIMEOUT              : constant := 103;       -- sqlext.h:758
    SQL_OPT_TRACE                  : constant := 104;       -- sqlext.h:759
    SQL_OPT_TRACEFILE              : constant := 105;       -- sqlext.h:760
    SQL_TRANSLATE_DLL              : constant := 106;       -- sqlext.h:761
    SQL_TRANSLATE_OPTION           : constant := 107;       -- sqlext.h:762
    SQL_TXN_ISOLATION              : constant := 108;       -- sqlext.h:763
    SQL_CURRENT_QUALIFIER          : constant := 109;       -- sqlext.h:764
    SQL_ODBC_CURSORS               : constant := 110;       -- sqlext.h:766
    SQL_QUIET_MODE                 : constant := 111;       -- sqlext.h:767
    SQL_PACKET_SIZE                : constant := 112;       -- sqlext.h:768
    SQL_CONN_OPT_MAX               : constant := 112;       -- sqlext.h:769
    SQL_CONNECT_OPT_DRVR_START     : constant := 1000;      -- sqlext.h:773
    SQL_CONN_OPT_MIN               : constant := 101;       -- sqlext.h:775
    SQL_MODE_READ_WRITE            : constant := 0;         -- sqlext.h:778
    SQL_MODE_READ_ONLY             : constant := 1;         -- sqlext.h:779
    SQL_MODE_DEFAULT               : constant := 0;         -- sqlext.h:780
    SQL_AUTOCOMMIT_OFF             : constant := 0;         -- sqlext.h:783
    SQL_AUTOCOMMIT_ON              : constant := 1;         -- sqlext.h:784
    SQL_AUTOCOMMIT_DEFAULT         : constant := 1;         -- sqlext.h:785
    SQL_LOGIN_TIMEOUT_DEFAULT      : constant := 15;        -- sqlext.h:788
    SQL_OPT_TRACE_OFF              : constant := 0;         -- sqlext.h:791
    SQL_OPT_TRACE_ON               : constant := 1;         -- sqlext.h:792
    SQL_OPT_TRACE_DEFAULT          : constant := 0;         -- sqlext.h:793
    SQL_OPT_TRACE_FILE_DEFAULT     : constant CHAR_Array := "\SQL.LOG" & Nul;
                                                            -- sqlext.h:794
    SQL_CUR_USE_IF_NEEDED          : constant := 0;         -- sqlext.h:798
    SQL_CUR_USE_ODBC               : constant := 1;         -- sqlext.h:799
    SQL_CUR_USE_DRIVER             : constant := 2;         -- sqlext.h:800
    SQL_CUR_DEFAULT                : constant := 2;         -- sqlext.h:801
    SQL_BEST_ROWID                 : constant := 1;         -- sqlext.h:805
    SQL_ROWVER                     : constant := 2;         -- sqlext.h:806
    SQL_SCOPE_CURROW               : constant := 0;         -- sqlext.h:808
    SQL_SCOPE_TRANSACTION          : constant := 1;         -- sqlext.h:809
    SQL_SCOPE_SESSION              : constant := 2;         -- sqlext.h:810
    SQL_ENTIRE_ROWSET              : constant := 0;         -- sqlext.h:813
    SQL_POSITION                   : constant := 0;         -- sqlext.h:816
    SQL_REFRESH                    : constant := 1;         -- sqlext.h:817
    SQL_UPDATE                     : constant := 2;         -- sqlext.h:819
    SQL_DELETE                     : constant := 3;         -- sqlext.h:820
    SQL_ADD                        : constant := 4;         -- sqlext.h:821
    SQL_LOCK_NO_CHANGE             : constant := 0;         -- sqlext.h:825
    SQL_LOCK_EXCLUSIVE             : constant := 1;         -- sqlext.h:826
    SQL_LOCK_UNLOCK                : constant := 2;         -- sqlext.h:828

    SQL_ODBC_KEYWORDS              : constant CHAR_Array := -- sqlext.h:843
     "ABSOLUTE,ACTION,ADA,ADD,all,ALLOCATE,ALTER,and,ANY,ARE,AS," &
     "ASC,ASSERTION,at,AUTHORIZATION,AVG,begin," &
     "BETWEEN,BIT,BIT_LENGTH,BOTH,BY,CASCADE,CASCADED,case,CAST,CATALOG," &
     "CHAR,CHAR_LENGTH,CHARACTER,CHARACTER_LENGTH,CHECK,CLOSE,COALESCE," &
     "COBOL,COLLATE,COLLATION,COLUMN,COMMIT,CONNECT,CONNECTION,CONSTRAINT," &
     "CONSTRAINTS,CONTINUE,CONVERT,CORRESPONDING,COUNT,CREATE,CROSS,CURRENT," &
     "CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR," &
     "DATE,DAY,DEALLOCATE,DEC,DECIMAL,declare,DEFAULT,DEFERRABLE," &
     "DEFERRED,DELETE,DESC,DESCRIBE,DESCRIPTOR,DIAGNOSTICS,DISCONNECT," &
     "DISTINCT,DOMAIN,DOUBLE,DROP," &
     "else,end,end-EXEC,ESCAPE,EXCEPT,exception,EXEC,EXECUTE," &
     "EXISTS,EXTERNAL,EXTRACT," &
     "FALSE,FETCH,FIRST,FLOAT,for,FOREIGN,FORTRAN,FOUND,FROM,FULL," &
     "GET,GLOBAL,GO,goto,GRANT,GROUP,HAVING,HOUR," &
     "IDENTITY,IMMEDIATE,in,INCLUDE,INDEX,INDICATOR,INITIALLY,INNER," &
     "INPUT,INSENSITIVE,INSERT,INTEGER,INTERSECT,INTERVAL,INTO,is,ISOLATION," &
     "JOIN,KEY,LANGUAGE,LAST,LEADING,LEFT,LEVEL,LIKE,LOCAL,LOWER," &
     "MATCH,MAX,MIN,MINUTE,MODULE,MONTH,MUMPS," &
     "NAMES,NATIONAL,NATURAL,NCHAR,NEXT,NO,NONE,not,null,NULLIF,NUMERIC," &
     "OCTET_LENGTH,of,ON,ONLY,OPEN,OPTION,or,ORDER,OUTER,OUTPUT,OVERLAPS," &
     "PAD,PARTIAL,PASCAL,PLI,POSITION,PRECISION,PREPARE,PRESERVE," &
     "PRIMARY,PRIOR,PRIVILEGES,procedure,PUBLIC," &
     "REFERENCES,RELATIVE,RESTRICT,REVOKE,RIGHT,ROLLBACK,ROWS," &
     "SCHEMA,SCROLL,SECOND,SECTION,select,SEQUENCE,SESSION,SESSION_USER,SET," &
     "SIZE,SMALLINT,SOME,SPACE,SQL,SQLCA,SQLCODE,SQLERROR,SQLSTATE," &
     "SQLWARNING,SUBSTRING,SUM,SYSTEM_USER," &
     "TABLE,TEMPORARY,then,TIME,TIMESTAMP,TIMEZONE_HOUR,TIMEZONE_MINUTE," &
     "TO,TRAILING,TRANSACTION,TRANSLATE,TRANSLATION,TRIM,TRUE," &
     "UNION,UNIQUE,UNKNOWN,UPDATE,UPPER,USAGE,USER,USING," &
     "VALUE,VALUES,VARCHAR,VARYING,VIEW,when,WHENEVER,WHERE,with," &
     "WORK,YEAR" & Nul;

    SQL_FETCH_NEXT                 : constant := 1;         -- sqlext.h:990
    SQL_FETCH_FIRST                : constant := 2;         -- sqlext.h:991
    SQL_FETCH_LAST                 : constant := 3;         -- sqlext.h:992
    SQL_FETCH_PRIOR                : constant := 4;         -- sqlext.h:993
    SQL_FETCH_ABSOLUTE             : constant := 5;         -- sqlext.h:994
    SQL_FETCH_RELATIVE             : constant := 6;         -- sqlext.h:995
    SQL_FETCH_BOOKMARK             : constant := 8;         -- sqlext.h:997
    SQL_ROW_SUCCESS                : constant := 0;         -- sqlext.h:1001
    SQL_ROW_DELETED                : constant := 1;         -- sqlext.h:1002
    SQL_ROW_UPDATED                : constant := 2;         -- sqlext.h:1003
    SQL_ROW_NOROW                  : constant := 3;         -- sqlext.h:1004
    SQL_ROW_ADDED                  : constant := 4;         -- sqlext.h:1006
    SQL_ROW_ERROR                  : constant := 5;         -- sqlext.h:1007
    SQL_CASCADE                    : constant := 0;         -- sqlext.h:1011
    SQL_RESTRICT                   : constant := 1;         -- sqlext.h:1012
    SQL_SET_NULL                   : constant := 2;         -- sqlext.h:1013
    SQL_PARAM_TYPE_UNKNOWN         : constant := 0;         -- sqlext.h:1017
    SQL_PARAM_INPUT                : constant := 1;         -- sqlext.h:1018
    SQL_PARAM_INPUT_OUTPUT         : constant := 2;         -- sqlext.h:1019
    SQL_RESULT_COL                 : constant := 3;         -- sqlext.h:1020
    SQL_PARAM_OUTPUT               : constant := 4;         -- sqlext.h:1022
    SQL_RETURN_VALUE               : constant := 5;         -- sqlext.h:1023
    SQL_PARAM_TYPE_DEFAULT         : constant := 2;         -- sqlext.h:1027
    SQL_SETPARAM_VALUE_MAX         : constant := -1;        -- sqlext.h:1028
    SQL_INDEX_UNIQUE               : constant := 0;         -- sqlext.h:1031
    SQL_INDEX_ALL                  : constant := 1;         -- sqlext.h:1032
    SQL_QUICK                      : constant := 0;         -- sqlext.h:1034
    SQL_ENSURE                     : constant := 1;         -- sqlext.h:1035
    SQL_TABLE_STAT                 : constant := 0;         -- sqlext.h:1038
    SQL_INDEX_CLUSTERED            : constant := 1;         -- sqlext.h:1039
    SQL_INDEX_HASHED               : constant := 2;         -- sqlext.h:1040
    SQL_INDEX_OTHER                : constant := 3;         -- sqlext.h:1041
    SQL_PT_UNKNOWN                 : constant := 0;         -- sqlext.h:1045
    SQL_PT_PROCEDURE               : constant := 1;         -- sqlext.h:1046
    SQL_PT_FUNCTION                : constant := 2;         -- sqlext.h:1047
    SQL_PC_UNKNOWN                 : constant := 0;         -- sqlext.h:1050
    SQL_PC_NOT_PSEUDO              : constant := 1;         -- sqlext.h:1051
    SQL_PC_PSEUDO                  : constant := 2;         -- sqlext.h:1052
    SQL_DATABASE_NAME              : constant := 16;        -- sqlext.h:1211
    SQL_FD_FETCH_PREV              : constant := 16#8#;     -- sqlext.h:1212
    SQL_FETCH_PREV                 : constant := 4;         -- sqlext.h:1213
    SQL_CONCUR_TIMESTAMP           : constant := 3;         -- sqlext.h:1214
    SQL_SCCO_OPT_TIMESTAMP         : constant := 16#4#;     -- sqlext.h:1215
    SQL_CC_DELETE                  : constant := 16#0#;     -- sqlext.h:1216
    SQL_CR_DELETE                  : constant := 16#0#;     -- sqlext.h:1217
    SQL_CC_CLOSE                   : constant := 16#1#;     -- sqlext.h:1218
    SQL_CR_CLOSE                   : constant := 16#1#;     -- sqlext.h:1219
    SQL_CC_PRESERVE                : constant := 16#2#;     -- sqlext.h:1220
    SQL_CR_PRESERVE                : constant := 16#2#;     -- sqlext.h:1221
    SQL_FETCH_RESUME               : constant := 7;         -- sqlext.h:1222
    SQL_SCROLL_FORWARD_ONLY        : constant := 0;         -- sqlext.h:1223
    SQL_SCROLL_KEYSET_DRIVEN       : constant := -1;        -- sqlext.h:1224
    SQL_SCROLL_DYNAMIC             : constant := -2;        -- sqlext.h:1225
    SQL_SCROLL_STATIC              : constant := -3;        -- sqlext.h:1227
    SQL_PC_NON_PSEUDO              : constant := 1;         -- sqlext.h:1228

    type BOOKMARK is new Win32.UINT;                        -- sqlext.h:95

    type DATE_STRUCT;                                       -- sqlext.h:69
    type TIME_STRUCT;                                       -- sqlext.h:76
    type TIMESTAMP_STRUCT;                                  -- sqlext.h:83

    type DATE_STRUCT is                                     -- sqlext.h:69
        record
            year : Win32.Sql.SWORD;                         -- sqlext.h:71
            month: Win32.Sql.UWORD;                         -- sqlext.h:72
            day  : Win32.Sql.UWORD;                         -- sqlext.h:73
        end record;

    type TIME_STRUCT is                                     -- sqlext.h:76
        record
            hour  : Win32.Sql.UWORD;                        -- sqlext.h:78
            minute: Win32.Sql.UWORD;                        -- sqlext.h:79
            second: Win32.Sql.UWORD;                        -- sqlext.h:80
        end record;

    type TIMESTAMP_STRUCT is                                -- sqlext.h:83
        record
            year    : Win32.Sql.SWORD;                      -- sqlext.h:85
            month   : Win32.Sql.UWORD;                      -- sqlext.h:86
            day     : Win32.Sql.UWORD;                      -- sqlext.h:87
            hour    : Win32.Sql.UWORD;                      -- sqlext.h:88
            minute  : Win32.Sql.UWORD;                      -- sqlext.h:89
            second  : Win32.Sql.UWORD;                      -- sqlext.h:90
            fraction: Win32.Sql.UDWORD;                     -- sqlext.h:91
        end record;

    function SQL_LEN_DATA_AT_EXEC (length: Win32.Sql.SDWORD) 
        return Win32.Sql.SDWORD;                            -- sqlext.h:122

    function SQLColumns(hstmt           : Win32.Sql.HSTMT;
                        szTableQualifier: Win32.PUCHAR;
                        cbTableQualifier: Win32.Sql.SWORD;
                        szTableOwner    : Win32.PUCHAR;
                        cbTableOwner    : Win32.Sql.SWORD;
                        szTableName     : Win32.PUCHAR;
                        cbTableName     : Win32.Sql.SWORD;
                        szColumnName    : Win32.PUCHAR;
                        cbColumnName    : Win32.Sql.SWORD)
                                          return Win32.Sql.RETCODE; 
                                                            -- sqlext.h:877

    function SQLDriverConnect(hdbc             : Win32.Sql.HDBC;
                              hwnd             : Win32.Windef.HWND;
                              szConnStrIn      : Win32.PUCHAR;
                              cbConnStrIn      : Win32.Sql.SWORD;
                              szConnStrOut     : Win32.PUCHAR;
                              cbConnStrOutMax  : Win32.Sql.SWORD;
                              pcbConnStrOut    : access Win32.Sql.SWORD;
                              fDriverCompletion: Win32.Sql.UWORD)
                                                 return Win32.Sql.RETCODE;
                                                            -- sqlext.h:888

    function SQLGetConnectOption(hdbc   : Win32.Sql.HDBC;
                                 fOption: Win32.Sql.UWORD;
                                 pvParam: Win32.Sql.PTR)
                                          return Win32.Sql.RETCODE; 
                                                            -- sqlext.h:898

    function SQLGetData(hstmt     : Win32.Sql.HSTMT;
                        icol      : Win32.Sql.UWORD;
                        fCType    : Win32.Sql.SWORD;
                        rgbValue  : Win32.Sql.PTR;
                        cbValueMax: Win32.Sql.SDWORD;
                        pcbValue  : access Win32.Sql.SDWORD)
                                    return Win32.Sql.RETCODE;
                                                            -- sqlext.h:903

    function SQLGetFunctions(hdbc     : Win32.Sql.HDBC;
                             fFunction: Win32.Sql.UWORD;
                             pfExists : Win32.PWSTR)
                                        return Win32.Sql.RETCODE;   
                                                            -- sqlext.h:911

    function SQLGetInfo(hdbc          : Win32.Sql.HDBC;
                        fInfoType     : Win32.Sql.UWORD;
                        rgbInfoValue  : Win32.Sql.PTR;
                        cbInfoValueMax: Win32.Sql.SWORD;
                        pcbInfoValue  : access Win32.Sql.SWORD)
                                        return Win32.Sql.RETCODE;   
                                                            -- sqlext.h:916

    function SQLGetStmtOption(hstmt  : Win32.Sql.HSTMT;
                              fOption: Win32.Sql.UWORD;
                              pvParam: Win32.Sql.PTR)
                                       return Win32.Sql.RETCODE;    
                                                            -- sqlext.h:923

    function SQLGetTypeInfo(hstmt   : Win32.Sql.HSTMT;
                            fSqlType: Win32.Sql.SWORD)
                                      return Win32.Sql.RETCODE;
                                                            -- sqlext.h:928
                                                                
    function SQLParamData(hstmt    : Win32.Sql.HSTMT;           
                          prgbValue: access Win32.Sql.PTR)      
                                     return Win32.Sql.RETCODE;
                                                            -- sqlext.h:932

                                                                
    function SQLPutData(hstmt   : Win32.Sql.HSTMT;              
                        rgbValue: Win32.Sql.PTR;                
                        cbValue : Win32.Sql.SDWORD)             
                                  return Win32.Sql.RETCODE; -- sqlext.h:936

    function SQLSetConnectOption(hdbc   : Win32.Sql.HDBC;
                                 fOption: Win32.Sql.UWORD;
                                 vParam : Win32.Sql.UDWORD)
                                          return Win32.Sql.RETCODE; 
                                                            -- sqlext.h:941

    function SQLSetStmtOption(hstmt  : Win32.Sql.HSTMT;
                              fOption: Win32.Sql.UWORD;
                              vParam : Win32.Sql.UDWORD)
                                       return Win32.Sql.RETCODE;
                                                            -- sqlext.h:946

    function SQLSpecialColumns(hstmt           : Win32.Sql.HSTMT;
                               fColType        : Win32.Sql.UWORD;
                               szTableQualifier: Win32.PUCHAR;
                               cbTableQualifier: Win32.Sql.SWORD;
                               szTableOwner    : Win32.PUCHAR;
                               cbTableOwner    : Win32.Sql.SWORD;
                               szTableName     : Win32.PUCHAR;
                               cbTableName     : Win32.Sql.SWORD;
                               fScope          : Win32.Sql.UWORD;
                               fNullable       : Win32.Sql.UWORD)
                                                 return Win32.Sql.RETCODE;
                                                            -- sqlext.h:951

    function SQLStatistics(hstmt           : Win32.Sql.HSTMT;
                           szTableQualifier: Win32.PUCHAR;
                           cbTableQualifier: Win32.Sql.SWORD;
                           szTableOwner    : Win32.PUCHAR;
                           cbTableOwner    : Win32.Sql.SWORD;
                           szTableName     : Win32.PUCHAR;
                           cbTableName     : Win32.Sql.SWORD;
                           fUnique         : Win32.Sql.UWORD;
                           fAccuracy       : Win32.Sql.UWORD)
                                             return Win32.Sql.RETCODE;
                                                            -- sqlext.h:963

    function SQLTables(hstmt           : Win32.Sql.HSTMT;
                       szTableQualifier: Win32.PUCHAR;
                       cbTableQualifier: Win32.Sql.SWORD;
                       szTableOwner    : Win32.PUCHAR;
                       cbTableOwner    : Win32.Sql.SWORD;
                       szTableName     : Win32.PUCHAR;
                       cbTableName     : Win32.Sql.SWORD;
                       szTableType     : Win32.PUCHAR;
                       cbTableType     : Win32.Sql.SWORD)
                                         return Win32.Sql.RETCODE;  
                                                            -- sqlext.h:974

    function SQLBrowseConnect(hdbc           : Win32.Sql.HDBC;
                              szConnStrIn    : Win32.PUCHAR;
                              cbConnStrIn    : Win32.Sql.SWORD;
                              szConnStrOut   : Win32.PUCHAR;
                              cbConnStrOutMax: Win32.Sql.SWORD;
                              pcbConnStrOut  : access Win32.Sql.SWORD)
                                               return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1059

    function SQLColumnPrivileges(hstmt           : Win32.Sql.HSTMT;
                                 szTableQualifier: Win32.PUCHAR;
                                 cbTableQualifier: Win32.Sql.SWORD;
                                 szTableOwner    : Win32.PUCHAR;
                                 cbTableOwner    : Win32.Sql.SWORD;
                                 szTableName     : Win32.PUCHAR;
                                 cbTableName     : Win32.Sql.SWORD;
                                 szColumnName    : Win32.PUCHAR;
                                 cbColumnName    : Win32.Sql.SWORD)
                                                   return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1067

    function SQLDataSources(henv            : Win32.Sql.HENV;
                            fDirection      : Win32.Sql.UWORD;
                            szDSN           : Win32.PUCHAR;
                            cbDSNMax        : Win32.Sql.SWORD;
                            pcbDSN          : access Win32.Sql.SWORD;
                            szDescription   : Win32.PUCHAR;
                            cbDescriptionMax: Win32.Sql.SWORD;
                            pcbDescription  : access Win32.Sql.SWORD)
                                              return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1078

    function SQLDescribeParam(hstmt     : Win32.Sql.HSTMT;
                              ipar      : Win32.Sql.UWORD;
                              pfSqlType : access Win32.Sql.SWORD;
                              pcbColDef : access Win32.Sql.SWORD;
                              pibScale  : access Win32.Sql.SWORD;
                              pfNullable: access Win32.Sql.SWORD)
                                          return Win32.Sql.RETCODE; 
                                                            -- sqlext.h:1088

    function SQLExtendedFetch(hstmt       : Win32.Sql.HSTMT;
                              fFetchType  : Win32.Sql.UWORD;
                              irow        : Win32.Sql.SDWORD;
                              pcrow       : access Win32.Sql.SWORD;
                              rgfRowStatus: Win32.PWSTR)
                                            return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1096

    function SQLForeignKeys(hstmt             : Win32.Sql.HSTMT;
                            szPkTableQualifier: Win32.PUCHAR;
                            cbPkTableQualifier: Win32.Sql.SWORD;
                            szPkTableOwner    : Win32.PUCHAR;
                            cbPkTableOwner    : Win32.Sql.SWORD;
                            szPkTableName     : Win32.PUCHAR;
                            cbPkTableName     : Win32.Sql.SWORD;
                            szFkTableQualifier: Win32.PUCHAR;
                            cbFkTableQualifier: Win32.Sql.SWORD;
                            szFkTableOwner    : Win32.PUCHAR;
                            cbFkTableOwner    : Win32.Sql.SWORD;
                            szFkTableName     : Win32.PUCHAR;
                            cbFkTableName     : Win32.Sql.SWORD)
        return Win32.Sql.RETCODE;                           -- sqlext.h:1103

    function SQLMoreResults(hstmt: Win32.Sql.HSTMT) 
        return Win32.Sql.RETCODE;                           -- sqlext.h:1118

    function SQLNativeSql(hdbc       : Win32.Sql.HDBC;
                          szSqlStrIn : Win32.PUCHAR;
                          cbSqlStrIn : Win32.Sql.SDWORD;
                          szSqlStr   : Win32.PUCHAR;
                          cbSqlStrMax: Win32.Sql.SDWORD;
                          pcbSqlStr  : access Win32.Sql.SDWORD)
                                       return Win32.Sql.RETCODE;    
                                                            -- sqlext.h:1121

    function SQLNumParams(hstmt: Win32.Sql.HSTMT;
                          pcpar: access Win32.Sql.SWORD)
                                 return Win32.Sql.RETCODE;          
                                                            -- sqlext.h:1129

    function SQLParamOptions(hstmt: Win32.Sql.HSTMT;
                             crow : Win32.Sql.UDWORD;
                             pirow: access Win32.Sql.SWORD)
                                    return Win32.Sql.RETCODE;       
                                                            -- sqlext.h:1133

    function SQLPrimaryKeys(hstmt           : Win32.Sql.HSTMT;
                            szTableQualifier: Win32.PUCHAR;
                            cbTableQualifier: Win32.Sql.SWORD;
                            szTableOwner    : Win32.PUCHAR;
                            cbTableOwner    : Win32.Sql.SWORD;
                            szTableName     : Win32.PUCHAR;
                            cbTableName     : Win32.Sql.SWORD)
                                              return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1138

    function SQLProcedureColumns(hstmt          : Win32.Sql.HSTMT;
                                 szProcQualifier: Win32.PUCHAR;
                                 cbProcQualifier: Win32.Sql.SWORD;
                                 szProcOwner    : Win32.PUCHAR;
                                 cbProcOwner    : Win32.Sql.SWORD;
                                 szProcName     : Win32.PUCHAR;
                                 cbProcName     : Win32.Sql.SWORD;
                                 szColumnName   : Win32.PUCHAR;
                                 cbColumnName   : Win32.Sql.SWORD)
                                                  return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1147

    function SQLProcedures(hstmt          : Win32.Sql.HSTMT;
                           szProcQualifier: Win32.PUCHAR;
                           cbProcQualifier: Win32.Sql.SWORD;
                           szProcOwner    : Win32.PUCHAR;
                           cbProcOwner    : Win32.Sql.SWORD;
                           szProcName     : Win32.PUCHAR;
                           cbProcName     : Win32.Sql.SWORD)
                                            return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1158

    -- not in Microsoft OpenTools
    -- function SQLSetPos(hstmt  : Win32.Sql.HSTMT;
                       -- irow   : Win32.Sql.UWORD;
                       -- fOption: Win32.Sql.UWORD;
                       -- fLock  : Win32.Sql.UWORD)
                                -- return Win32.Sql.RETCODE;-- sqlext.h:1167
                                                                
    -- function SQL_POSITION_TO(hstmt  : Win32.Sql.HSTMT;          
                             -- irow   : Win32.Sql.UWORD)          
                                -- return Win32.Sql.RETCODE;   -- sqlext.h:831
                                                                
    -- function SQL_LOCK_RECORD(hstmt  : Win32.Sql.HSTMT;          
                             -- irow   : Win32.Sql.UWORD;                   
                             -- fLock  : Win32.Sql.UWORD)          
                                -- return Win32.Sql.RETCODE;   -- sqlext.h:832
                                                                
    -- function SQL_REFRESH_RECORD(hstmt  : Win32.Sql.HSTMT;       
                                -- irow   : Win32.Sql.UWORD;       
                                -- fLock  : Win32.Sql.UWORD)       
                                -- return Win32.Sql.RETCODE;   -- sqlext.h:833
                                                                
    -- function SQL_UPDATE_RECORD(hstmt  : Win32.Sql.HSTMT;        
                               -- irow   : Win32.Sql.UWORD)        
                                -- return Win32.Sql.RETCODE;   -- sqlext.h:834
                                                                
    -- function SQL_DELETE_RECORD(hstmt  : Win32.Sql.HSTMT;        
                               -- irow   : Win32.Sql.UWORD)        
                                -- return Win32.Sql.RETCODE;   -- sqlext.h:835

    -- function SQL_ADD_RECORD(hstmt  : Win32.Sql.HSTMT;
                            -- irow   : Win32.Sql.UWORD)
                                -- return Win32.Sql.RETCODE;   -- sqlext.h:836

    function SQLTablePrivileges(hstmt           : Win32.Sql.HSTMT;
                                szTableQualifier: Win32.PUCHAR;
                                cbTableQualifier: Win32.Sql.SWORD;
                                szTableOwner    : Win32.PUCHAR;
                                cbTableOwner    : Win32.Sql.SWORD;
                                szTableName     : Win32.PUCHAR;
                                cbTableName     : Win32.Sql.SWORD)
                                                  return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1173

    function SQLDrivers(henv              : Win32.Sql.HENV;
                        fDirection        : Win32.Sql.UWORD;
                        szDriverDesc      : Win32.PUCHAR;
                        cbDriverDescMax   : Win32.Sql.SWORD;
                        pcbDriverDesc     : access Win32.Sql.SWORD;
                        szDriverAttributes: Win32.PUCHAR;
                        cbDrvrAttrMax     : Win32.Sql.SWORD;
                        pcbDrvrAttr       : access Win32.Sql.SWORD)
                                            return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1185

    function SQLBindParameter(hstmt     : Win32.Sql.HSTMT;
                              ipar      : Win32.Sql.UWORD;
                              fParamType: Win32.Sql.SWORD;
                              fCType    : Win32.Sql.SWORD;
                              fSqlType  : Win32.Sql.SWORD;
                              cbColDef  : Win32.Sql.UDWORD;
                              ibScale   : Win32.Sql.SWORD;
                              rgbValue  : Win32.Sql.PTR;
                              cbValueMax: Win32.Sql.SDWORD;
                              pcbValue  : access Win32.Sql.SDWORD)
                                          return Win32.Sql.RETCODE; 
                                                            -- sqlext.h:1195

    function SQLSetScrollOptions(hstmt       : Win32.Sql.HSTMT;
                                 fConcurrency: Win32.Sql.UWORD;
                                 crowKeyset  : Win32.Sql.SDWORD;
                                 crowRowset  : Win32.Sql.UWORD)
                                               return Win32.Sql.RETCODE;
                                                            -- sqlext.h:1234

private

    pragma Convention(C, DATE_STRUCT);                      -- sqlext.h:69
    pragma Convention(C, TIME_STRUCT);                      -- sqlext.h:76
    pragma Convention(C, TIMESTAMP_STRUCT);                 -- sqlext.h:83

    pragma Inline(SQL_LEN_DATA_AT_EXEC);

    pragma Import(Stdcall, SQLColumns, "SQLColumns");             -- sqlext.h:877
    pragma Import(Stdcall, SQLDriverConnect, "SQLDriverConnect"); -- sqlext.h:888
    pragma Import(Stdcall, SQLGetConnectOption, "SQLGetConnectOption"); 
                                                            -- sqlext.h:898
    pragma Import(Stdcall, SQLGetData, "SQLGetData");             -- sqlext.h:903
    pragma Import(Stdcall, SQLGetFunctions, "SQLGetFunctions");   -- sqlext.h:911
    pragma Import(Stdcall, SQLGetInfo, "SQLGetInfo");             -- sqlext.h:916
    pragma Import(Stdcall, SQLGetStmtOption, "SQLGetStmtOption"); -- sqlext.h:923
    pragma Import(Stdcall, SQLGetTypeInfo, "SQLGetTypeInfo");     -- sqlext.h:928
    pragma Import(Stdcall, SQLParamData, "SQLParamData");         -- sqlext.h:932
    pragma Import(Stdcall, SQLPutData, "SQLPutData");             -- sqlext.h:936
    pragma Import(Stdcall, SQLSetConnectOption, "SQLSetConnectOption"); 
                                                            -- sqlext.h:941
    pragma Import(Stdcall, SQLSetStmtOption, "SQLSetStmtOption"); -- sqlext.h:946
    pragma Import(Stdcall, SQLSpecialColumns, "SQLSpecialColumns");
                                                            -- sqlext.h:951
    pragma Import(Stdcall, SQLStatistics, "SQLStatistics");       -- sqlext.h:963
    pragma Import(Stdcall, SQLTables, "SQLTables");               -- sqlext.h:974
    pragma Import(Stdcall, SQLBrowseConnect, "SQLBrowseConnect"); -- sqlext.h:1059
    pragma Import(Stdcall, SQLColumnPrivileges, "SQLColumnPrivileges"); 
                                                            -- sqlext.h:1067
    pragma Import(Stdcall, SQLDataSources, "SQLDataSources");     -- sqlext.h:1078
    pragma Import(Stdcall, SQLDescribeParam, "SQLDescribeParam"); -- sqlext.h:1088
    pragma Import(Stdcall, SQLExtendedFetch, "SQLExtendedFetch"); -- sqlext.h:1096
    pragma Import(Stdcall, SQLForeignKeys, "SQLForeignKeys");     -- sqlext.h:1103
    pragma Import(Stdcall, SQLMoreResults, "SQLMoreResults");     -- sqlext.h:1118
    pragma Import(Stdcall, SQLNativeSql, "SQLNativeSql");         -- sqlext.h:1121
    pragma Import(Stdcall, SQLNumParams, "SQLNumParams");         -- sqlext.h:1129
    pragma Import(Stdcall, SQLParamOptions, "SQLParamOptions");   -- sqlext.h:1133
    pragma Import(Stdcall, SQLPrimaryKeys, "SQLPrimaryKeys");     -- sqlext.h:1138
    pragma Import(Stdcall, SQLProcedureColumns, "SQLProcedureColumns"); 
                                                            -- sqlext.h:1147
    pragma Import(Stdcall, SQLProcedures, "SQLProcedures");       -- sqlext.h:1158
    -- pragma Import(Stdcall, SQLSetPos, "SQLSetPos");            -- sqlext.h:1167
    pragma Import(Stdcall, SQLTablePrivileges, "SQLTablePrivileges");
                                                            -- sqlext.h:1173
    pragma Import(Stdcall, SQLDrivers, "SQLDrivers");             -- sqlext.h:1185
    pragma Import(Stdcall, SQLBindParameter, "SQLBindParameter"); -- sqlext.h:1195
    pragma Import(Stdcall, SQLSetScrollOptions, "SQLSetScrollOptions"); 
                                                            -- sqlext.h:1234
-------------------------------------------------------------------------------
--
-- THIS FILE AND ANY ASSOCIATED DOCUMENTATION IS PROVIDED WITHOUT CHARGE
-- "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING
-- BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR
-- FITNESS FOR A PARTICULAR PURPOSE.  The user assumes the entire risk as to
-- the accuracy and the use of this file.  This file may be used, copied,
-- modified and distributed only by licensees of Microsoft Corporation's
-- WIN32 Software Development Kit in accordance with the terms of the 
-- licensee's End-User License Agreement for Microsoft Software for the
-- WIN32 Development Kit.
--
-- Copyright (c) Intermetrics, Inc. 1995
-- Portions (c) 1985-1994 Microsoft Corporation with permission.
-- Microsoft is a registered trademark and Windows and Windows NT are
-- trademarks of Microsoft Corporation.
--
-------------------------------------------------------------------------------

end Win32.Sqlext;



*)

end.


