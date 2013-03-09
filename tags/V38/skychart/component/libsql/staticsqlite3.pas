unit staticsqlite3;

//currently windows only
//linking to sqlite .o files on linux should be possible.

{$IFDEF FPC}
{$MODE Delphi}
{$H+}
{$ENDIF}

//sqlite3.dll api interface                        f
interface

uses Windows,SysUtils;

{$DEFINE ALBERTDRENT}
//Binary objects from aducom
//EMail:        a.drent@aducom.com (www.aducom.com/sqlite, sqlite.aducom.com)
//probably coampiled wint msvcc

{$DEFINE WITHUNDERSCORES}

{$IFDEF WTYPES}
type
  PWChar = PWideChar;
{$ENDIF}

const SQLITE_OK         =  0;   // Successful result
const SQLITE_ERROR      =  1;   // SQL error or missing database
const SQLITE_INTERNAL   =  2;   // An internal logic error in SQLite
const SQLITE_PERM       =  3;   // Access permission denied
const SQLITE_ABORT      =  4;   // Callback routine requested an abort
const SQLITE_BUSY       =  5;   // The database file is locked
const SQLITE_LOCKED     =  6;   // A table in the database is locked
const SQLITE_NOMEM      =  7;   // A malloc() failed
const SQLITE_READONLY   =  8;   // Attempt to write a readonly database
const SQLITE_INTERRUPT  =  9;   // Operation terminated by sqlite_interrupt()
const SQLITE_IOERR      = 10;   // Some kind of disk I/O error occurred
const SQLITE_CORRUPT    = 11;   // The database disk image is malformed
const SQLITE_NOTFOUND   = 12;   // (Internal Only) Table or record not found
const SQLITE_FULL       = 13;   // Insertion failed because database is full
const SQLITE_CANTOPEN   = 14;   // Unable to open the database file
const SQLITE_PROTOCOL   = 15;   // Database lock protocol error
const SQLITE_EMPTY      = 16;   // (Internal Only) Database table is empty
const SQLITE_SCHEMA     = 17;   // The database schema changed
const SQLITE_TOOBIG     = 18;   // Too much data for one row of a table
const SQLITE_CONSTRAINT = 19;   // Abort due to contraint violation
const SQLITE_MISMATCH   = 20;   // Data type mismatch
const SQLITE_MISUSE     = 21;   // Library used incorrectly
const SQLITE_NOLFS      = 22;   // Uses OS features not supported on host
const SQLITE_AUTH       = 23;   // Authorization denied
const SQLITE_ROW        = 100;  // sqlite_step() has another row ready
const SQLITE_DONE       = 101;  // sqlite_step() has finished executing

{
These are the allowed values for the eTextRep argument to
sqlite3_create_collation and sqlite3_create_function.
}
const SQLITE_UTF8       = 1;
const SQLITE_UTF16LE    = 2;
const SQLITE_UTF16BE    = 3;
const SQLITE_UTF16      = 4;    // Use native byte order
const SQLITE_ANY        = 5;

//values returned by SQLite3_Column_Type
const SQLITE_INTEGER    = 1;
const SQLITE_FLOAT      = 2;
const SQLITE_TEXT       = 3;
const SQLITE_BLOB       = 4;
const SQLITE_NULL       = 5;


type PSQLite = Pointer;

     TSqlite_Func = record
                      P:Pointer;
                    end;
     PSQLite_Func = ^TSQLite_Func;

{$IFDEF WITHUNDERSCORES}
function _sqlite3_errmsg(db : Pointer): PChar; cdecl; external;
function _sqlite3_errmsg16(db : Pointer): PWChar; cdecl; external ;
function _sqlite3_errcode(db: Pointer): Integer; cdecl; external;
function _sqlite3_bind_parameter_count(hstatement: Pointer): Integer; cdecl; external;
function _sqlite3_Bind_Parameter_Name(hstatement: Pointer; paramNo: Integer): PChar; cdecl; external;
procedure _sqlite3_Busy_Handler(db: Pointer; CallbackPtr: Pointer; Sender: TObject); cdecl; external;
procedure _sqlite3_Busy_Timeout(db: Pointer; TimeOut: Integer); cdecl; external;
function _sqlite3_Get_Table(db: Pointer; SQLStatement: PChar; var ResultPtr: Pointer; var RowCount: Integer; var ColCount: Integer; var ErrMsg: PChar): Integer; cdecl; external;
procedure _sqlite3_Free_Table (Table: PChar); cdecl; external;
function _sqlite3_Last_Insert_RowId(db: Pointer): Int64; cdecl; external;
function _SQlite3_Collation_Needed(db: Pointer; pCollNeededArg: Pointer; CollationFunctionPtr: Pointer): Integer; cdecl; external;
function _SQlite3_Collation_Needed16(db: Pointer; pCollNeededArg: Pointer; CollationFunctionPtr: Pointer): Integer; cdecl; external;

function _sqlite3_Changes(db: Pointer): Integer; cdecl; external;

function _sqlite3_Column_Blob(hstatement: Pointer; iCol: Integer): Pointer; cdecl; external;
function _sqlite3_Column_Bytes(hstatement: Pointer; iCol: Integer): Integer; cdecl; external;
function _sqlite3_Column_Bytes16(hstatement: Pointer; iCol: Integer): Integer; cdecl; external;
function _sqlite3_Column_Count(hstatement: Pointer): Integer; cdecl; external;
function _sqlite3_Column_Double(hstatement: Pointer; iCol: Integer): Double; cdecl; external;
function _sqlite3_Column_Int(hstatement: Pointer; iCol: Integer): Integer; cdecl; external;
function _sqlite3_Column_Int64(hstatement: Pointer; iCol: Integer): Int64; cdecl; external;
function _sqlite3_Column_Text(hstatement: Pointer; iCol: Integer): PChar; cdecl; external;
function _sqlite3_Column_Text16(hstatement: Pointer; iCol: Integer): PWChar; cdecl; external;
function _sqlite3_Column_Type(hstatement: Pointer; iCol: Integer): Integer; cdecl; external;
function _sqlite3_Column_Decltype(hstatement: Pointer; iCol: Integer): PChar; cdecl; external;
function _sqlite3_Column_Decltype16 (hstatement: Pointer; colNo: Integer): PWChar; cdecl; external;
function _sqlite3_Column_Name(hstatement: Pointer; iCol: Integer): PChar; cdecl; external;
function _sqlite3_Column_Name16 (hstatement: Pointer; colNo: Integer): PWChar; cdecl; external;
function _sqlite3_Complete(const sql: PChar): Integer; cdecl; external;
function _sqlite3_Complete16(const sql: PWChar): Integer; cdecl; external;
function _sqlite3_Create_Collation(db: Pointer; CollName: PChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; cdecl; external;
function _sqlite3_Create_Collation16(db: Pointer; CollName: PWChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; cdecl; external;
function _sqlite3_Data_Count(hstatement: Pointer): Integer; cdecl; external;



function _sqlite3_Close (db: Pointer): Integer; cdecl; cdecl; external;
//CollationFunction is defined as function ColFunc(pCollNeededArg: Pointer; db: Pointer; eTextRep: Integer; CollSeqName: PChar): Pointer;
//pCollNeededArg <- what is that?
function _sqlite3_Exec(db: Pointer; SQLStatement: PChar; CallbackPtr: Pointer; Sender: TObject; var ErrMsg: PChar): Integer; cdecl; external;
function _sqlite3_Finalize(hstatement: Pointer): Integer; cdecl; external;
procedure _sqlite3_Free(P: PChar); cdecl; external;
procedure _sqlite3_Interrupt(db : Pointer); cdecl; external;
function _sqlite3_LibVersion(): PChar; cdecl; external ;
function _sqlite3_Open(dbName: PChar; var db: Pointer): Integer; cdecl; external;
function _sqlite3_Open16(dbName: PWChar; var db: Pointer): Integer; cdecl; external;
function _sqlite3_Prepare(db: Pointer; SQLStatement: PChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; cdecl; external;
function _sqlite3_Prepare16(db: Pointer; SQLStatement: PWChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; cdecl; external;
function _sqlite3_Reset(hstatement: Pointer): Integer; cdecl; external;
function _sqlite3_Step(hstatement: Pointer): Integer; cdecl; external;
function _sqlite3_Total_Changes(db: Pointer): Integer; cdecl; external;



//traditional names without underscores:
//those get filled in initialization part
//this is done to avoid diffent names on different compiler (options)
//like trailing underscore etc.

var SQLite3_BindParameterCount: function(hstatement: Pointer): Integer; cdecl;
var SQLite3_BindParameterName: function(hstatement: Pointer; paramNo: Integer): PChar; cdecl;
var SQLite3_BusyHandler: procedure(db: Pointer; CallbackPtr: Pointer; Sender: TObject); cdecl;
var SQLite3_BusyTimeout: procedure(db: Pointer; TimeOut: Integer); cdecl;
var SQLite3_Changes: function(db: Pointer): Integer; cdecl;
var SQLite3_Close: function (db: Pointer): Integer; cdecl;


var SQlite_Collation_Needed: function(db: Pointer; pCollNeededArg: Pointer; CollationFunctionPtr: Pointer): Integer; cdecl;
var SQlite_Collation_Needed16: function(db: Pointer; pCollNeededArg: Pointer; CollationFunctionPtr: Pointer): Integer; cdecl;
var SQLite3_Column_Blob: function(hstatement: Pointer; iCol: Integer): Pointer; cdecl;
var SQLite3_Column_Bytes: function(hstatement: Pointer; iCol: Integer): Integer; cdecl;
var SQLite3_Column_Bytes16: function(hstatement: Pointer; iCol: Integer): Integer; cdecl;
var SQLite3_Column_Count: function(hstatement: Pointer): Integer; cdecl;
var SQLite3_Column_Double: function(hstatement: Pointer; iCol: Integer): Double; cdecl;
var SQLite3_Column_Int: function(hstatement: Pointer; iCol: Integer): Integer; cdecl;
var SQLite3_Column_Int64: function(hstatement: Pointer; iCol: Integer): Int64; cdecl;
var SQLite3_Column_Text: function(hstatement: Pointer; iCol: Integer): PChar; cdecl;
var SQLite3_Column_Text16: function(hstatement: Pointer; iCol: Integer): PWChar; cdecl;
var SQLite3_Column_Type: function(hstatement: Pointer; iCol: Integer): Integer; cdecl;
var SQLite3_Column_Decltype: function(hstatement: Pointer; iCol: Integer): PChar; cdecl;
var SQLite3_Column_Decltype16: function (hstatement: Pointer; colNo: Integer): PWChar; cdecl;
var SQLite3_Column_Name: function(hstatement: Pointer; iCol: Integer): PChar; cdecl;
var SQLite3_Column_Name16: function (hstatement: Pointer; colNo: Integer): PWChar; cdecl;
var SQLite3_Complete: function(const sql: PChar): Integer; cdecl;
var SQLite3_Complete16: function(const sql: PWChar): Integer; cdecl;
var SQLite3_Create_Collation: function(db: Pointer; CollName: PChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; cdecl;
var SQLite3_Create_Collation16: function(db: Pointer; CollName: PWChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; cdecl;
var SQLite3_Data_Count: function(hstatement: Pointer): Integer; cdecl;
var SQLite3_ErrCode: function(db: Pointer): Integer; cdecl;
var SQLite3_ErrorMsg: function(db : Pointer): PChar; cdecl;
var SQLite3_ErrorMsg16: function(db : Pointer): PWChar; cdecl;
var SQLite3_Exec: function(db: Pointer; SQLStatement: PChar; CallbackPtr: Pointer; Sender: TObject; var ErrMsg: PChar): Integer; cdecl;
var SQLite3_Finalize: function(hstatement: Pointer): Integer; cdecl;
var SQLite3_Free: procedure(P: PChar); cdecl;
var SQLite3_GetTable: function(db: Pointer; SQLStatement: PChar; var ResultPtr: Pointer; var RowCount: Integer; var ColCount: Integer; var ErrMsg: PChar): Integer; cdecl;
var SQLite3_FreeTable: procedure(Table: PChar); cdecl;
var SQLite3_Interrupt: procedure(db : Pointer); cdecl;
var SQLite3_LastInsertRowId: function(db: Pointer): Int64; cdecl;
var SQLite3_LibVersion: function(): PChar; cdecl;
var SQLite3_Open: function(dbName: PChar; var db: Pointer): Integer; cdecl;
var SQLite3_Open16: function(dbName: PWChar; var db: Pointer): Integer; cdecl;
var SQLite3_Prepare: function(db: Pointer; SQLStatement: PChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; cdecl;
var SQLite3_Prepare16: function(db: Pointer; SQLStatement: PWChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; cdecl;
var SQLite3_Reset: function(hstatement: Pointer): Integer; cdecl;
var SQLite3_Step: function(hstatement: Pointer): Integer; cdecl;
var SQLite3_Total_Changes: function(db: Pointer): Integer; cdecl;

{$ELSE}
function sqlite3_errmsg(db : Pointer): PChar; cdecl; external;
function sqlite3_errmsg16(db : Pointer): PWChar; cdecl; external ;
function sqlite3_errcode(db: Pointer): Integer; cdecl; external;
function sqlite3_bind_parameter_count(hstatement: Pointer): Integer; cdecl; external;
function sqlite3_Bind_Parameter_Name(hstatement: Pointer; paramNo: Integer): PChar; cdecl; external;
procedure sqlite3_Busy_Handler(db: Pointer; CallbackPtr: Pointer; Sender: TObject); cdecl; external;
procedure sqlite3_Busy_Timeout(db: Pointer; TimeOut: Integer); cdecl; external;
function sqlite3_Get_Table(db: Pointer; SQLStatement: PChar; var ResultPtr: Pointer; var RowCount: Integer; var ColCount: Integer; var ErrMsg: PChar): Integer; cdecl; external;
procedure sqlite3_Free_Table (Table: PChar); cdecl; external;
function sqlite3_Last_Insert_RowId(db: Pointer): Int64; cdecl; external;
function SQlite3_Collation_Needed(db: Pointer; pCollNeededArg: Pointer; CollationFunctionPtr: Pointer): Integer; cdecl; external;
function SQlite3_Collation_Needed16(db: Pointer; pCollNeededArg: Pointer; CollationFunctionPtr: Pointer): Integer; cdecl; external;
function sqlite3_Changes(db: Pointer): Integer; cdecl; external;

function sqlite3_Column_Blob(hstatement: Pointer; iCol: Integer): Pointer; cdecl; external;
function sqlite3_Column_Bytes(hstatement: Pointer; iCol: Integer): Integer; cdecl; external;
function sqlite3_Column_Bytes16(hstatement: Pointer; iCol: Integer): Integer; cdecl; external;
function sqlite3_Column_Count(hstatement: Pointer): Integer; cdecl; external;
function sqlite3_Column_Double(hstatement: Pointer; iCol: Integer): Double; cdecl; external;
function sqlite3_Column_Int(hstatement: Pointer; iCol: Integer): Integer; cdecl; external;
function sqlite3_Column_Int64(hstatement: Pointer; iCol: Integer): Int64; cdecl; external;
function sqlite3_Column_Text(hstatement: Pointer; iCol: Integer): PChar; cdecl; external;
function sqlite3_Column_Text16(hstatement: Pointer; iCol: Integer): PWChar; cdecl; external;
function sqlite3_Column_Type(hstatement: Pointer; iCol: Integer): Integer; cdecl; external;
function sqlite3_Column_Decltype(hstatement: Pointer; iCol: Integer): PChar; cdecl; external;
function sqlite3_Column_Decltype16 (hstatement: Pointer; colNo: Integer): PWChar; cdecl; external;
function sqlite3_Column_Name(hstatement: Pointer; iCol: Integer): PChar; cdecl; external;
function sqlite3_Column_Name16 (hstatement: Pointer; colNo: Integer): PWChar; cdecl; external;
function sqlite3_Complete(const sql: PChar): Integer; cdecl; external;
function sqlite3_Complete16(const sql: PWChar): Integer; cdecl; external;
function sqlite3_Create_Collation(db: Pointer; CollName: PChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; cdecl; external;
function sqlite3_Create_Collation16(db: Pointer; CollName: PWChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; cdecl; external;
function sqlite3_Data_Count(hstatement: Pointer): Integer; cdecl; external;



function sqlite3_Close (db: Pointer): Integer; cdecl; cdecl; external;
//CollationFunction is defined as function ColFunc(pCollNeededArg: Pointer; db: Pointer; eTextRep: Integer; CollSeqName: PChar): Pointer;
//pCollNeededArg <- what is that?
function sqlite3_Exec(db: Pointer; SQLStatement: PChar; CallbackPtr: Pointer; Sender: TObject; var ErrMsg: PChar): Integer; cdecl; external;
function sqlite3_Finalize(hstatement: Pointer): Integer; cdecl; external;
procedure sqlite3_Free(P: PChar); cdecl; external;
procedure sqlite3_Interrupt(db : Pointer); cdecl; external;
function sqlite3_LibVersion(): PChar; cdecl; external ;
function sqlite3_Open(dbName: PChar; var db: Pointer): Integer; cdecl; external;
function sqlite3_Open16(dbName: PWChar; var db: Pointer): Integer; cdecl; external;
function sqlite3_Prepare(db: Pointer; SQLStatement: PChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; cdecl; external;
function sqlite3_Prepare16(db: Pointer; SQLStatement: PWChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; cdecl; external;
function sqlite3_Reset(hstatement: Pointer): Integer; cdecl; external;
function sqlite3_Step(hstatement: Pointer): Integer; cdecl; external;
function sqlite3_Total_Changes(db: Pointer): Integer; cdecl; external;

{$ENDIF}

var
  Libs3Loaded: Boolean=False;  //static, always true, but for compatability
  DLLHandle: THandle;
  MsgNoError: String;

function LoadLibSqlite3(var libraryName: String): Boolean;


implementation



function LoadLibSqlite3(var libraryName: String): Boolean;
begin
  Libs3Loaded := True;
  Result := True;
  libraryName:='<static '+String(sqlite3_LibVersion)+'>';
end;

{$IFDEF ALBERTDRENT}
var __HandlerPtr:Pointer;
  {$L 'OBJASG\sqlite3.OBJ'}
  {$L 'OBJASG\files.OBJ'}
  {$L 'OBJASG\strlen.OBJ'}
  {$L 'OBJASG\assert.OBJ'}
  {$L 'OBJASG\memcmp.OBJ'}
  {$L 'OBJASG\memcpy.OBJ'}
  {$L 'OBJASG\memset.OBJ'}
  {$L 'OBJASG\strcmp.OBJ'}
  {$L 'OBJASG\strcpy.OBJ'}
  {$L 'OBJASG\strcat.OBJ'}
  {$L 'OBJASG\strncmp.OBJ'}
  {$L 'OBJASG\strncpy.OBJ'}
  {$L 'OBJASG\strncat.OBJ'}
  {$L 'OBJASG\sprintf.OBJ'}
  {$L 'OBJASG\fprintf.OBJ'}
  {$L 'OBJASG\_ll.OBJ'}
  {$L 'OBJASG\ltoupper.OBJ'}
  {$L 'OBJASG\ltolower.OBJ'}
  {$L 'OBJASG\atol.OBJ'}
  {$L 'OBJASG\ftol.OBJ'}
  {$L 'OBJASG\longtoa.OBJ'}
  {$L 'OBJASG\hrdir_r.OBJ'}
  {$L 'OBJASG\gmtime.OBJ'}
  {$L 'OBJASG\tzdata.OBJ'}
  {$L 'OBJASG\initcvt.OBJ'}
  {$L 'OBJASG\streams.OBJ'}
  {$L 'OBJASG\scantod.OBJ'}
  {$L 'OBJASG\scanwtod.OBJ'}
  {$L 'OBJASG\allocbuf.OBJ'}
  {$L 'OBJASG\bigctype.OBJ'}
  {$L 'OBJASG\clocale.OBJ'}
  {$L 'OBJASG\clower.OBJ'}
  {$L 'OBJASG\cupper.OBJ'}
  {$L 'OBJASG\fflush.OBJ'}
  {$L 'OBJASG\fputn.OBJ'}
  {$L 'OBJASG\hrdir_s.OBJ'}
  {$L 'OBJASG\mbisspc.OBJ'}
  {$L 'OBJASG\mbsrchr.OBJ'}
  {$L 'OBJASG\realcvt.OBJ'}
  {$L 'OBJASG\realcvtw.OBJ'}
  {$L 'OBJASG\timefunc.OBJ'}
  {$L 'OBJASG\vprinter.OBJ'}
  {$L 'OBJASG\hugeval.OBJ'}
  {$L 'OBJASG\cvtfak.OBJ'}
  {$L 'OBJASG\getinfo.OBJ'}
  {$L 'OBJASG\qmul10.OBJ'}
  {$L 'OBJASG\fuildq.OBJ'}
  {$L 'OBJASG\_pow10.OBJ'}
  {$L 'OBJASG\ldtrunc.OBJ'}
  {$L 'OBJASG\cvtfakw.OBJ'}
  {$L 'OBJASG\wis.OBJ'}
  {$L 'OBJASG\xfflush.OBJ'}
  {$L 'OBJASG\flushout.OBJ'}
  {$L 'OBJASG\lputc.OBJ'}
  {$L 'OBJASG\hrdir_b.OBJ'}
  {$L 'OBJASG\realloc.OBJ'}
  {$L 'OBJASG\mbctype.OBJ'}
  {$L 'OBJASG\xcvt.OBJ'}
  {$L 'OBJASG\xcvtw.OBJ'}
  {$L 'OBJASG\wcscpy.OBJ'}
  {$L 'OBJASG\errno.OBJ'}
  {$L 'OBJASG\ctrl87.OBJ'}
  {$L 'OBJASG\timedata.OBJ'}
  {$L 'OBJASG\int64toa.OBJ'}
  {$L 'OBJASG\cvtentry.OBJ'}
  {$L 'OBJASG\mbyte1.OBJ'}
  {$L 'OBJASG\errormsg.OBJ'}
  {$L 'OBJASG\exit.OBJ'}
  {$L 'OBJASG\iswctype.OBJ'}
  {$L 'OBJASG\heap.OBJ'}
  {$L 'OBJASG\memmove.OBJ'}
  {$L 'OBJASG\fxam.OBJ'}
  {$L 'OBJASG\fuistq.OBJ'}
  {$L 'OBJASG\qdiv10.OBJ'}
  {$L 'OBJASG\wmemset.OBJ'}
  {$L 'OBJASG\wcslen.OBJ'}
  {$L 'OBJASG\_tzset.OBJ'}
  {$L 'OBJASG\deflt87.OBJ'}
  {$L 'OBJASG\mbschr.OBJ'}
  {$L 'OBJASG\mbsrchr.OBJ'}
  {$L 'OBJASG\ermsghlp.OBJ'}
  {$L 'OBJASG\patexit.OBJ'}
  {$L 'OBJASG\initexit.OBJ'}
  {$L 'OBJASG\virtmem.OBJ'}
  {$L 'OBJASG\tzset.OBJ'}
  {$L 'OBJASG\mbisdgt.OBJ'}
  {$L 'OBJASG\mbsnbcpy.OBJ'}
  {$L 'OBJASG\platform.OBJ'}
  {$L 'OBJASG\getenv.OBJ'}
  {$L 'OBJASG\mbisalp.OBJ'}
  {$L 'OBJASG\abort.OBJ'}
  {$L 'OBJASG\signal.OBJ'}
  {$L 'OBJASG\clear87.OBJ'}
  {$L 'OBJASG\abort.OBJ'}
  {$L 'OBJASG\handles.OBJ'}
  {$L 'OBJASG\_cfinfo.OBJ'}
  {$L 'OBJASG\__isatty.OBJ'}
  {$L 'OBJASG\handles.OBJ'}  //duplicato
  {$L 'OBJASG\perror.OBJ'}
  {$L 'OBJASG\fputs.OBJ'}
  {$L 'OBJASG\files2.OBJ'}
  {$L 'OBJASG\handles.OBJ'}  //duplicato 2
  {$L 'OBJASG\ioerror.OBJ'}
  {$L 'OBJASG\perror.OBJ'}   //duplicato
  {$L 'OBJASG\__write.OBJ'}
  {$L 'OBJASG\_write.OBJ'}
  {$L 'OBJASG\__lseek.OBJ'}
  {$L 'OBJASG\ioerror.OBJ'}
  {$L 'OBJASG\setenvp.OBJ'}
  {$L 'OBJASG\calloc.OBJ'}
  {$L 'OBJASG\mbsnbcmp.OBJ'}
  {$L 'OBJASG\mbsnbicm.OBJ'}
  {$L 'OBJASG\is.OBJ'}
  {$L 'OBJASG\isctype.OBJ'}
  {$L 'OBJASG\bigctype.OBJ'}
  {$L 'OBJASG\globals.OBJ'}
  {$L 'OBJASG\hrdir_mf.OBJ'}
  {$L 'OBJASG\fpreset.OBJ'}
  {$L 'OBJASG\ta.OBJ'}
  {$L 'OBJASG\setexc.OBJ'}
  {$L 'OBJASG\defhandl.OBJ'}

function _wsprintfA:integer; external 'user32.dll' name 'wsprintfA';
procedure RtlUnwind; external 'NtDll.dll' name 'RtlUnwind';


{$ELSE}

{$L obj\alter.obj}
{$L obj\analyze.obj}
{$L obj\attach.obj}
{$L obj\auth.obj}
{$L obj\btree.obj}
{$L obj\build.obj}
{$L obj\callback.obj}
{$L obj\complete.obj}
{$L obj\date.obj}
{$L obj\delete.obj}
{$L obj\expr.obj}
{$L obj\func.obj}
{$L obj\hash.obj}
{$L obj\insert.obj}
{$L obj\legacy.obj}
{$L obj\main.obj}
{$L obj\opcodes.obj}
//{$L obj\os_unix.obj}
{$L obj\os_win.obj}
{$L obj\pager.obj}
{$L obj\parse.obj}
{$L obj\pragma.obj}
{$L obj\prepare.obj}
{$L obj\printf.obj}
{$L obj\random.obj}
{$L obj\select.obj}
//shell.obj
{$L obj\table.obj}
{$L obj\tokenize.obj}
{$L obj\trigger.obj}
{$L obj\update.obj}
{$L obj\utf.obj}
{$L obj\util.obj}
{$L obj\vacuum.obj}
{$L obj\vdbe.obj}
{$L obj\vdbeapi.obj}
{$L obj\vdbeaux.obj}
{$L obj\vdbefifo.obj}
{$L obj\vdbemem.obj}
{$L obj\where.obj}


//support functions
  {$L 'OBJASG\files.OBJ'}
  {$L 'OBJASG\strlen.OBJ'}
  {$L 'OBJASG\assert.OBJ'}
  {$L 'OBJASG\memcmp.OBJ'}
  {$L 'OBJASG\memcpy.OBJ'}
  {$L 'OBJASG\memset.OBJ'}
  {$L 'OBJASG\strcmp.OBJ'}
  {$L 'OBJASG\strcpy.OBJ'}
  {$L 'OBJASG\strcat.OBJ'}
  {$L 'OBJASG\strncmp.OBJ'}
  {$L 'OBJASG\strncpy.OBJ'}
  {$L 'OBJASG\strncat.OBJ'}
  {$L 'OBJASG\sprintf.OBJ'}
  {$L 'OBJASG\fprintf.OBJ'}
  {$L 'OBJASG\_ll.OBJ'}
  {$L 'OBJASG\ltoupper.OBJ'}
  {$L 'OBJASG\ltolower.OBJ'}
  {$L 'OBJASG\atol.OBJ'}
  {$L 'OBJASG\ftol.OBJ'}
  {$L 'OBJASG\longtoa.OBJ'}
  {$L 'OBJASG\hrdir_r.OBJ'}
  {$L 'OBJASG\gmtime.OBJ'}
  {$L 'OBJASG\tzdata.OBJ'}
  {$L 'OBJASG\initcvt.OBJ'}
  {$L 'OBJASG\streams.OBJ'}
  {$L 'OBJASG\scantod.OBJ'}
  {$L 'OBJASG\scanwtod.OBJ'}
  {$L 'OBJASG\allocbuf.OBJ'}
  {$L 'OBJASG\bigctype.OBJ'}
  {$L 'OBJASG\clocale.OBJ'}
  {$L 'OBJASG\clower.OBJ'}
  {$L 'OBJASG\cupper.OBJ'}
  {$L 'OBJASG\fflush.OBJ'}
  {$L 'OBJASG\fputn.OBJ'}
  {$L 'OBJASG\hrdir_s.OBJ'}
  {$L 'OBJASG\mbisspc.OBJ'}
  {$L 'OBJASG\mbsrchr.OBJ'}
  {$L 'OBJASG\realcvt.OBJ'}
  {$L 'OBJASG\realcvtw.OBJ'}
  {$L 'OBJASG\timefunc.OBJ'}
  {$L 'OBJASG\vprinter.OBJ'}
  {$L 'OBJASG\hugeval.OBJ'}
  {$L 'OBJASG\cvtfak.OBJ'}
  {$L 'OBJASG\getinfo.OBJ'}
  {$L 'OBJASG\qmul10.OBJ'}
  {$L 'OBJASG\fuildq.OBJ'}
  {$L 'OBJASG\_pow10.OBJ'}
  {$L 'OBJASG\ldtrunc.OBJ'}
  {$L 'OBJASG\cvtfakw.OBJ'}
  {$L 'OBJASG\wis.OBJ'}
  {$L 'OBJASG\xfflush.OBJ'}
  {$L 'OBJASG\flushout.OBJ'}
  {$L 'OBJASG\lputc.OBJ'}
  {$L 'OBJASG\hrdir_b.OBJ'}
  {$L 'OBJASG\realloc.OBJ'}
  {$L 'OBJASG\mbctype.OBJ'}
  {$L 'OBJASG\xcvt.OBJ'}
  {$L 'OBJASG\xcvtw.OBJ'}
  {$L 'OBJASG\wcscpy.OBJ'}
  {$L 'OBJASG\errno.OBJ'}
  {$L 'OBJASG\ctrl87.OBJ'}
  {$L 'OBJASG\timedata.OBJ'}
  {$L 'OBJASG\int64toa.OBJ'}
  {$L 'OBJASG\cvtentry.OBJ'}
  {$L 'OBJASG\mbyte1.OBJ'}
  {$L 'OBJASG\errormsg.OBJ'}
  {$L 'OBJASG\exit.OBJ'}
  {$L 'OBJASG\iswctype.OBJ'}
  {$L 'OBJASG\heap.OBJ'}
  {$L 'OBJASG\memmove.OBJ'}
  {$L 'OBJASG\fxam.OBJ'}
  {$L 'OBJASG\fuistq.OBJ'}
  {$L 'OBJASG\qdiv10.OBJ'}
  {$L 'OBJASG\wmemset.OBJ'}
  {$L 'OBJASG\wcslen.OBJ'}
  {$L 'OBJASG\_tzset.OBJ'}
  {$L 'OBJASG\deflt87.OBJ'}
  {$L 'OBJASG\mbschr.OBJ'}
  {$L 'OBJASG\mbsrchr.OBJ'}
  {$L 'OBJASG\ermsghlp.OBJ'}
  {$L 'OBJASG\patexit.OBJ'}
  {$L 'OBJASG\initexit.OBJ'}
  {$L 'OBJASG\virtmem.OBJ'}
  {$L 'OBJASG\tzset.OBJ'}
  {$L 'OBJASG\mbisdgt.OBJ'}
  {$L 'OBJASG\mbsnbcpy.OBJ'}
  {$L 'OBJASG\platform.OBJ'}
  {$L 'OBJASG\getenv.OBJ'}
  {$L 'OBJASG\mbisalp.OBJ'}
  {$L 'OBJASG\abort.OBJ'}
  {$L 'OBJASG\signal.OBJ'}
  {$L 'OBJASG\clear87.OBJ'}
//  {$L 'OBJASG\abort.OBJ'}
  {$L 'OBJASG\handles.OBJ'}
  {$L 'OBJASG\_cfinfo.OBJ'}
  {$L 'OBJASG\__isatty.OBJ'}
  {$L 'OBJASG\handles.OBJ'}  //duplicato
  {$L 'OBJASG\perror.OBJ'}
  {$L 'OBJASG\fputs.OBJ'}
  {$L 'OBJASG\files2.OBJ'}
  {$L 'OBJASG\handles.OBJ'}  //duplicato 2
  {$L 'OBJASG\ioerror.OBJ'}
  {$L 'OBJASG\perror.OBJ'}   //duplicato
  {$L 'OBJASG\__write.OBJ'}
  {$L 'OBJASG\_write.OBJ'}
  {$L 'OBJASG\__lseek.OBJ'}
  {$L 'OBJASG\ioerror.OBJ'}
  {$L 'OBJASG\setenvp.OBJ'}
  {$L 'OBJASG\calloc.OBJ'}
  {$L 'OBJASG\mbsnbcmp.OBJ'}
  {$L 'OBJASG\mbsnbicm.OBJ'}
  {$L 'OBJASG\is.OBJ'}
  {$L 'OBJASG\isctype.OBJ'}
  {$L 'OBJASG\bigctype.OBJ'}
  {$L 'OBJASG\globals.OBJ'}
  {$L 'OBJASG\hrdir_mf.OBJ'}
  {$L 'OBJASG\fpreset.OBJ'}
  {$L 'OBJASG\ta.OBJ'}
  {$L 'OBJASG\setexc.OBJ'}
  {$L 'OBJASG\defhandl.OBJ'}


{$ENDIF}



//function _sqlite3_bindparameter_count: Integer; external;
//function sqlite3_bindparametercount(hstatement: Pointer): Integer; external;
(*
function SQLite3_BindParameterName(hstatement: Pointer; paramNo: Integer): PChar; external;
procedure SQLite3_BusyHandler(db: Pointer; CallbackPtr: Pointer; Sender: TObject); external;
procedure SQLite3_BusyTimeout(db: Pointer; TimeOut: Integer); external;
function SQLite3_Changes(db: Pointer): Integer; external;
function SQLite3_Close (db: Pointer): Integer; external;
//CollationFunction is defined as function ColFunc(pCollNeededArg: Pointer; db: Pointer; eTextRep: Integer; CollSeqName: PChar): Pointer;
//pCollNeededArg <- what is that?
function SQlite_Collation_Needed(db: Pointer; pCollNeededArg: Pointer; CollationFunctionPtr: Pointer): Integer; external;
function SQlite_Collation_Needed16(db: Pointer; pCollNeededArg: Pointer; CollationFunctionPtr: Pointer): Integer; external;
function SQLite3_Column_Blob(hstatement: Pointer; iCol: Integer): Pointer; external;
function SQLite3_Column_Bytes(hstatement: Pointer; iCol: Integer): Integer; external;
function SQLite3_Column_Bytes16(hstatement: Pointer; iCol: Integer): Integer; external;
function SQLite3_Column_Count(hstatement: Pointer): Integer; external;
function SQLite3_Column_Double(hstatement: Pointer; iCol: Integer): Double; external;
function SQLite3_Column_Int(hstatement: Pointer; iCol: Integer): Integer; external;
function SQLite3_Column_Int64(hstatement: Pointer; iCol: Integer): Int64; external;
function SQLite3_Column_Text(hstatement: Pointer; iCol: Integer): PChar; external;
function SQLite3_Column_Text16(hstatement: Pointer; iCol: Integer): PWChar; external;
function SQLite3_Column_Type(hstatement: Pointer; iCol: Integer): Integer; external;
function SQLite3_Column_Decltype(hstatement: Pointer; iCol: Integer): PChar; external;
function SQLite3_Column_Decltype16 (hstatement: Pointer; colNo: Integer): PWChar; external;
function SQLite3_Column_Name(hstatement: Pointer; iCol: Integer): PChar; external;
function SQLite3_Column_Name16 (hstatement: Pointer; colNo: Integer): PWChar; external;
function SQLite3_Complete(const sql: PChar): Integer; external;
function SQLite3_Complete16(const sql: PWChar): Integer; external;
function SQLite3_Create_Collation(db: Pointer; CollName: PChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; external;
function SQLite3_Create_Collation16(db: Pointer; CollName: PWChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; external;
function SQLite3_Data_Count(hstatement: Pointer): Integer; external;
function SQLite3_ErrCode(db: Pointer): Integer; external;
function SQLite3_ErrorMsg(db : Pointer): PChar; external;
function SQLite3_ErrorMsg16(db : Pointer): PWChar; external;
function SQLite3_Exec(db: Pointer; SQLStatement: PChar; CallbackPtr: Pointer; Sender: TObject; var ErrMsg: PChar): Integer; external;
function SQLite3_Finalize(hstatement: Pointer): Integer; external;
procedure SQLite3_Free(P: PChar); external;
function SQLite3_GetTable(db: Pointer; SQLStatement: PChar; var ResultPtr: Pointer; var RowCount: Integer; var ColCount: Integer; var ErrMsg: PChar): Integer; external;
procedure SQLite3_FreeTable (Table: PChar); external;
procedure SQLite3_Interrupt(db : Pointer); external;
function SQLite3_LastInsertRowId(db: Pointer): Int64; external;
function SQLite3_LibVersion(): PChar; external;
function SQLite3_Open(dbName: PChar; var db: Pointer): Integer; external;
function SQLite3_Open16(dbName: PWChar; var db: Pointer): Integer; external;
function SQLite3_Prepare(db: Pointer; SQLStatement: PChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; external;
function SQLite3_Prepare16(db: Pointer; SQLStatement: PWChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; external;
function SQLite3_Reset(hstatement: Pointer): Integer; external;
function SQLite3_Step(hstatement: Pointer): Integer; external;
function SQLite3_Total_Changes(db: Pointer): Integer; external;
*)


//void *sqlite3_aggregate_context(sqlite3_context*, int nBytes);
{ int sqlite3_bind_blob(sqlite3_stmt*, int, const void*, int n, void(*)(void*));
  int sqlite3_bind_double(sqlite3_stmt*, int, double);
  int sqlite3_bind_int(sqlite3_stmt*, int, int);
  int sqlite3_bind_int64(sqlite3_stmt*, int, long long int);
  int sqlite3_bind_null(sqlite3_stmt*, int);
  int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int n, void(*)(void*));
  int sqlite3_bind_text16(sqlite3_stmt*, int, const void*, int n, void(*)(void*));
  #define SQLITE_STATIC      ((void(*)(void *))0)
  #define SQLITE_TRANSIENT   ((void(*)(void *))-1)
}
(*
  @SQLite3_BindParameterCount := GetProcAddress(DLLHandle, 'sqlite3_bind_parameter_count');
  if not Assigned(@SQLite3_BindParameterCount) then Result := False;

  @SQLite3_BindParameterName := GetProcAddress(DLLHandle, 'sqlite3_bind_parameter_name');
  if not Assigned(@SQLite3_BindParameterName) then Result := False;

  @SQLite3_BusyHandler := GetProcAddress(DLLHandle, 'sqlite3_busy_handler');
  if not Assigned(@SQLite3_BusyHandler) then Result := False;
  @SQLite3_BusyTimeout := GetProcAddress(DLLHandle, 'sqlite3_busy_timeout');
  if not Assigned(@SQLite3_BusyTimeout) then Result := False;
  @SQLite3_Changes := GetProcAddress(DLLHandle, 'sqlite3_changes');
  if not Assigned(@SQLite3_Changes) then Result := False;
  @SQLite3_Close := GetProcAddress(DLLHandle, 'sqlite3_close');
  if not Assigned(@SQLite3_Close) then Result := False;
  @SQlite_Collation_Needed := GetProcAddress(DLLHandle, 'sqlite3_collation_needed');
  if not Assigned(@SQlite_Collation_Needed) then Result := False;
  @SQlite_Collation_Needed16 := GetProcAddress(DLLHandle, 'sqlite3_collation_needed16');
  if not Assigned(@SQlite_Collation_Needed16) then Result := False;
  @SQLite3_Column_Blob := GetProcAddress(DLLHandle, 'sqlite3_column_blob');
  if not Assigned(@SQLite3_Column_Blob) then Result := False;
  @SQLite3_Column_Bytes := GetProcAddress(DLLHandle, 'sqlite3_column_bytes');
  if not Assigned(@SQLite3_Column_Bytes) then Result := False;
  @SQLite3_Column_Bytes16 := GetProcAddress(DLLHandle, 'sqlite3_column_bytes16');
  if not Assigned(@SQLite3_Column_Bytes16) then Result := False;
  @SQLite3_Column_Count := GetProcAddress(DLLHandle, 'sqlite3_column_count');
  if not Assigned(@SQLite3_Column_Count) then Result := False;
  @SQLite3_Column_Double := GetProcAddress(DLLHandle, 'sqlite3_column_double');
  if not Assigned(@SQLite3_Column_Double) then Result := False;
  @SQLite3_Column_Int := GetProcAddress(DLLHandle, 'sqlite3_column_int');
  if not Assigned(@SQLite3_Column_Int) then Result := False;
  @SQLite3_Column_Int64 := GetProcAddress(DLLHandle, 'sqlite3_column_int64');
  if not Assigned(@SQLite3_Column_Int64) then Result := False;
  @SQLite3_Column_Text := GetProcAddress(DLLHandle, 'sqlite3_column_text');
  if not Assigned(@SQLite3_Column_Text) then Result := False;
  @SQLite3_Column_Text16 := GetProcAddress(DLLHandle, 'sqlite3_column_text16');
  if not Assigned(@SQLite3_Column_Text16) then Result := False;
  @SQLite3_Column_Type := GetProcAddress(DLLHandle, 'sqlite3_column_type');
  if not Assigned(@SQLite3_Column_Type) then Result := False;
  @SQLite3_Column_Decltype := GetProcAddress(DLLHandle, 'sqlite3_column_decltype');
  if not Assigned(@SQLite3_Column_Decltype) then Result := False;
  @SQLite3_Column_Decltype16 := GetProcAddress(DLLHandle, 'sqlite3_column_decltype16');
  if not Assigned(@SQLite3_Column_Decltype16) then Result := False;
  @SQLite3_Column_Name := GetProcAddress(DLLHandle, 'sqlite3_column_name');
  if not Assigned(@SQLite3_Column_Name) then Result := False;
  @SQLite3_Column_Name16 := GetProcAddress(DLLHandle, 'sqlite3_column_name16');
  if not Assigned(@SQLite3_Column_Name16) then Result := False;
*)
{void *sqlite3_commit_hook(sqlite3*, int(*xCallback)(void*), void *pArg);}
(*  @SQLite3_Complete := GetProcAddress(DLLHandle, 'sqlite3_complete');
  if not Assigned(@SQLite3_Complete) then Result := False;
  @SQLite3_Complete16 := GetProcAddress(DLLHandle, 'sqlite3_complete16');
  if not Assigned(@SQLite3_Complete16) then Result := False;
  @SQLite3_Create_Collation := GetProcAddress(DLLHandle, 'sqlite3_create_collation');
  if not Assigned(@SQLite3_Create_Collation) then Result := False;
  @SQLite3_Create_Collation16 := GetProcAddress(DLLHandle, 'sqlite3_create_collation16');
  if not Assigned(@SQLite3_Create_Collation16) then Result := False;
*)
{int sqlite3_create_function(
  sqlite3 *,
  const char *zFunctionName,
  int nArg,
  int eTextRep,
  void*,
  void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
  void (*xStep)(sqlite3_context*,int,sqlite3_value**),
  void (*xFinal)(sqlite3_context*)
);}
{int sqlite3_create_function16(
  sqlite3*,
  const void *zFunctionName,
  int nArg,
  int eTextRep,
  void*,
  void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
  void (*xStep)(sqlite3_context*,int,sqlite3_value**),
  void (*xFinal)(sqlite3_context*)
);}
(*
  @SQLite3_Data_Count := GetProcAddress(DLLHandle, 'sqlite3_data_count');
  if not Assigned(@SQLite3_Data_Count) then Result := False;
  @SQLite3_ErrCode := GetProcAddress(DLLHandle, 'sqlite3_errcode');
  if not Assigned(@SQLite3_ErrCode) then Result := False;
  @SQLite3_ErrorMsg := GetProcAddress(DLLHandle, 'sqlite3_errmsg');
  if not Assigned(@SQLite3_ErrorMsg) then Result := False;
  @SQLite3_ErrorMsg16 := GetProcAddress(DLLHandle, 'sqlite3_errmsg16');
  if not Assigned(@SQLite3_ErrorMsg16) then Result := False;
  @SQLite3_Exec := GetProcAddress(DLLHandle, 'sqlite3_exec');
  if not Assigned(@SQLite3_Exec) then Result := False;
  @SQLite3_Finalize := GetProcAddress(DLLHandle, 'sqlite3_finalize');
  if not Assigned(@SQLite3_Finalize) then Result := False;
  @SQLite3_Free := GetProcAddress(DLLHandle, 'sqlite3_free');
  if not Assigned(@SQLite3_Free) then Result := False;
  @SQLite3_GetTable := GetProcAddress(DLLHandle, 'sqlite3_get_table');
  if not Assigned(@SQLite3_GetTable) then Result := False;
  @SQLite3_FreeTable := GetProcAddress(DLLHandle, 'sqlite3_free_table');
  if not Assigned(@SQLite3_FreeTable) then Result := False;
  @SQLite3_Interrupt := GetProcAddress(DLLHandle, 'sqlite3_interrupt');
  if not Assigned(@SQLite3_Interrupt) then Result := False;
  @SQLite3_LastInsertRowId := GetProcAddress(DLLHandle, 'sqlite3_last_insert_rowid');
  if not Assigned(@SQLite3_LastInsertRowId) then Result := False;
{char *sqlite3_mprintf(const char*,...);
char *sqlite3_vmprintf(const char*, va_list);
}
  @SQLite3_Open := GetProcAddress(DLLHandle, 'sqlite3_open');
  if not Assigned(@SQLite3_Open) then Result := False;
  @SQLite3_Open16 := GetProcAddress(DLLHandle, 'sqlite3_open16');
  if not Assigned(@SQLite3_Open16) then Result := False;
  @SQLite3_Prepare := GetProcAddress(DLLHandle, 'sqlite3_prepare');
  if not Assigned(@SQLite3_Prepare) then Result := False;
  @SQLite3_Prepare16 := GetProcAddress(DLLHandle, 'sqlite3_prepare16');
  if not Assigned(@SQLite3_Prepare16) then Result := False;
*)
{void sqlite3_progress_handler(sqlite3*, int, int(*)(void*), void*);}
(*
  @SQLite3_Reset := GetProcAddress(DLLHandle, 'sqlite3_reset');
  if not Assigned(@SQLite3_Reset) then Result := False;
*)
{void sqlite3_result_blob(sqlite3_context*, const void*, int n, void(*)(void*));
void sqlite3_result_double(sqlite3_context*, double);
void sqlite3_result_error(sqlite3_context*, const char*, int);
void sqlite3_result_error16(sqlite3_context*, const void*, int);
void sqlite3_result_int(sqlite3_context*, int);
void sqlite3_result_int64(sqlite3_context*, long long int);
void sqlite3_result_null(sqlite3_context*);
void sqlite3_result_text(sqlite3_context*, const char*, int n, void(*)(void*));
void sqlite3_result_text16(sqlite3_context*, const void*, int n, void(*)(void*));
void sqlite3_result_text16be(sqlite3_context*, const void*, int n, void(*)(void*));
void sqlite3_result_text16le(sqlite3_context*, const void*, int n, void(*)(void*));
void sqlite3_result_value(sqlite3_context*, sqlite3_value*);
}
{int sqlite3_set_authorizer(
  sqlite3*,
  int (*xAuth)(void*,int,const char*,const char*,const char*,const char*),
  void *pUserData
);
}
(*
  @SQLite3_Step := GetProcAddress(DLLHandle, 'sqlite3_step');
  if not Assigned(@SQLite3_Step) then Result := False;
  @SQLite3_Total_Changes := GetProcAddress(DLLHandle, 'sqlite3_total_changes');
  if not Assigned(@SQLite3_Total_Changes) then Result := False;
  @SQLite3_LibVersion := GetProcAddress(DLLHandle, 'sqlite3_libversion');
  if not Assigned(@SQLite3_LibVersion) then Result := False;
*)
{void *sqlite3_trace(sqlite3*, void(*xTrace)(void*,const char*), void*);
}
{const void *sqlite3_value_blob(sqlite3_value*);
int sqlite3_value_bytes(sqlite3_value*);
int sqlite3_value_bytes16(sqlite3_value*);
double sqlite3_value_double(sqlite3_value*);
int sqlite3_value_int(sqlite3_value*);
long long int sqlite3_value_int64(sqlite3_value*);
const unsigned char *sqlite3_value_text(sqlite3_value*);
const void *sqlite3_value_text16(sqlite3_value*);
const void *sqlite3_value_text16be(sqlite3_value*);
const void *sqlite3_value_text16le(sqlite3_value*);
int sqlite3_value_type(sqlite3_value*);
}

    //sqlite_progress_handler := GetProcAddress (DLLHandle, 'sqlite_progress_handler');

initialization
  {$IFDEF ALBERTDRENT}
  @SQLite3_BindParameterCount := @_sqlite3_bind_parameter_count;
  @SQLite3_BindParameterName := @_sqlite3_bind_parameter_name;
  @SQLite3_BusyHandler := @_sqlite3_busy_handler;
  @SQLite3_BusyTimeout := @_sqlite3_busy_timeout;
  @SQLite3_Changes := @_sqlite3_changes;
  @SQLite3_Close := @_sqlite3_close;
  @SQlite_Collation_Needed := @_sqlite3_collation_needed;
  @SQlite_Collation_Needed16 := @_sqlite3_collation_needed16;
  @SQLite3_Column_Blob := @_sqlite3_column_blob;
  @SQLite3_Column_Bytes := @_sqlite3_column_bytes;
  @SQLite3_Column_Bytes16 := @_sqlite3_column_bytes16;
  @SQLite3_Column_Count := @_sqlite3_column_count;
  @SQLite3_Column_Double := @_sqlite3_column_double;
  @SQLite3_Column_Int := @_sqlite3_column_int;
  @SQLite3_Column_Int64 := @_sqlite3_column_int64;
  @SQLite3_Column_Text := @_sqlite3_column_text;
  @SQLite3_Column_Text16 := @_sqlite3_column_text16;
  @SQLite3_Column_Type := @_sqlite3_column_type;
  @SQLite3_Column_Decltype := @_sqlite3_column_decltype;
  @SQLite3_Column_Decltype16 := @_sqlite3_column_decltype16;
  @SQLite3_Column_Name := @_sqlite3_column_name;
  @SQLite3_Column_Name16 := @_sqlite3_column_name16;
  @SQLite3_Complete := @_sqlite3_complete;
  @SQLite3_Complete16 := @_sqlite3_complete16;
  @SQLite3_Create_Collation := @_sqlite3_create_collation;
  @SQLite3_Create_Collation16 := @_sqlite3_create_collation16;
  @SQLite3_Data_Count := @_sqlite3_data_count;
  @SQLite3_ErrCode := @_sqlite3_errcode;
  @SQLite3_ErrorMsg := @_sqlite3_errmsg;
  @SQLite3_ErrorMsg16 := @_sqlite3_errmsg16;
  @SQLite3_Exec := @_sqlite3_exec;
  @SQLite3_Finalize := @_sqlite3_finalize;
  @SQLite3_Free := @_sqlite3_free;
  @SQLite3_GetTable := @_sqlite3_get_table;
  @SQLite3_FreeTable := @_sqlite3_free_table;
  @SQLite3_Interrupt := @_sqlite3_interrupt;
  @SQLite3_LastInsertRowId := @_sqlite3_last_insert_rowid;
  @SQLite3_Open := @_sqlite3_open;
  @SQLite3_Open16 := @_sqlite3_open16;
  @SQLite3_Prepare := @_sqlite3_prepare;
  @SQLite3_Prepare16 := @_sqlite3_prepare16;
  @SQLite3_Reset := @_sqlite3_reset;
  @SQLite3_Step := @_sqlite3_step;
  @SQLite3_Total_Changes := @_sqlite3_total_changes;
  @SQLite3_LibVersion := @_sqlite3_libversion;
  {$ENDIF}
end.















































































































































