unit libsqlite3;

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

//sqlite3.dll api interface

//initial code by Miha Vrhovnik

// for documentation on these constants and functions, please look at
// http://www.sqlite.org/capi3ref.html

//I only ported functions with support for 16bit-unicode I know that databases
//take much more space if texts in fields are mostly from ASCII table but it's easier to work with
//especialy if you have texts form other languages andy so you don't have to convert to from utf8 string each time
interface

//freepascal compatability
{$IFDEF FPC}
{$DEFINE WTYPES}
{$ENDIF}
//kylix comptabability
{$IFDEF LINUX}
{$DEFINE WTYPES}
{$ENDIF}

uses {$IFNDEF FPC}{$IFDEF MSWINDOWS}Windows{$ELSE}SysUtils{$ENDIF}{$ELSE}Dynlibs{$ENDIF};

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

const SQLITEDLL: PChar  = {$IFDEF LINUX}'libsqlite3.so'{$ENDIF}{$IFDEF MSWINDOWS}'sqlite3.dll'{$ENDIF}{$IFDEF WINCE}'sqlite3.dll'{$ENDIF}{$IFDEF darwin}'libsqlite3.dylib'{$ENDIF};

function LoadLibSqlite3(var libraryName: String): Boolean;

type PSQLite = Pointer;

     TSqlite_Func = record
                      P:Pointer;
                    end;
     PSQLite_Func = ^TSQLite_Func;

     //untested:
     //procProgressCallback = procedure (UserData:Integer); cdecl;
     //untested:
     //Tsqlite_create_function= function (db: Pointer; {const}zName:PChar; nArg: Integer;  xFunc : PSqlite_func{*,int,const char**};
     //  UserData: Integer):Integer; cdecl;

//void *sqlite3_aggregate_context(sqlite3_context*, int nBytes);
(*Aggregate functions use the following routine to allocate a structure for storing their state. The first time this routine is called for a particular aggregate, a new structure of size nBytes is allocated, zeroed, and returned. On subsequent calls (for the same aggregate instance) the same buffer is returned. The implementation of the aggregate can use the returned buffer to accumulate data.

The buffer allocated is freed automatically by SQLite*)
//int sqlite3_aggregate_count(sqlite3_context*);
(*
  The next routine returns the number of calls to xStep for a particular aggregate function instance. The current call to xStep counts so this routine always returns at least 1.
*)

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

type TDestructorProc = procedure (APointer: Pointer);                              //Dak_Alpha
type PDestructorProc = ^TDestructorProc;                                           //Dak_Alpha
const SQLITE_STATIC = PDestructorProc(0);                                          //Dak_Alpha
const SQLITE_TRANSIENT = PDestructorProc(-1);                                      //Dak_Alpha

(*In the SQL strings input to sqlite3_prepare() and sqlite3_prepare16(), one or more literals can be replace by a wildcard "?" or ":N:" where N is an integer. The value of these wildcard literals can be set using these routines.

The first parameter is a pointer to the sqlite3_stmt structure returned from sqlite3_prepare(). The second parameter is the index of the wildcard. The first "?" has an index of 1. ":N:" wildcards use the index N.

The fifth parameter to sqlite3_bind_blob(), sqlite3_bind_text(), and sqlite3_bind_text16() is a destructor used to dispose of the BLOB or text after SQLite has finished with it. If the fifth argument is the special value SQLITE_STATIC, then the library assumes that the information is in static, unmanaged space and does not need to be freed. If the fifth argument has the value SQLITE_TRANSIENT, then SQLite makes its own private copy of the data.

The sqlite3_bind_*() routine must be called after sqlite3_prepare() or sqlite3_reset() and before sqlite3_step(). Bindings are not reset by the sqlite3_reset() routine. Unbound wildcards are interpreted as NULL.
*)
var SQLite3_Bind_Blob: function(hstatement: Pointer; iCol: integer; buf: PAnsiChar; n: integer; DestroyPtr: Pointer): integer; cdecl;  //Dak_Alpha

var SQLite3_BindParameterCount: function(hstatement: Pointer): Integer; cdecl;
var SQLite3_BindParameterName: function(hstatement: Pointer; paramNo: Integer): PChar; cdecl;
var SQLite3_BusyHandler: procedure(db: Pointer; CallbackPtr: Pointer; Sender: TObject); cdecl;
var SQLite3_BusyTimeout: procedure(db: Pointer; TimeOut: Integer); cdecl;
var SQLite3_Changes: function(db: Pointer): Integer; cdecl;
var SQLite3_Close: function (db: Pointer): Integer; cdecl;
//CollationFunction is defined as function ColFunc(pCollNeededArg: Pointer; db: Pointer; eTextRep: Integer; CollSeqName: PChar): Pointer;
//pCollNeededArg <- what is that?
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
{void *sqlite3_commit_hook(sqlite3*, int(*xCallback)(void*), void *pArg);}
(*
 Experimental

Register a callback function to be invoked whenever a new transaction is committed. The pArg argument is passed through to the callback. callback. If the callback function returns non-zero, then the commit is converted into a rollback.

If another function was previously registered, its pArg value is returned. Otherwise NULL is returned.

Registering a NULL function disables the callback. Only a single commit hook callback can be registered at a time.
*)
var SQLite3_Complete: function(const sql: PChar): Integer; cdecl;
var SQLite3_Complete16: function(const sql: PWChar): Integer; cdecl;
//CompareFunction is defined as function ComFunc(pCtx: Pointer; str1Length: Integer; str1: PWChar; str2Length: Integer; str2: PWChar): Pointer;
//pCtx <- what is that?
var SQLite3_Create_Collation: function(db: Pointer; CollName: PChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; cdecl;
var SQLite3_Create_Collation16: function(db: Pointer; CollName: PWChar; eTextRep: Integer; pCtx: Pointer; compareFuncPtr: Pointer): Integer; cdecl;

type TSQLFunction = procedure (sqlite3_context: Pointer; nArg: Integer;sqlite3_value: Pointer); cdecl;
type PSQLFunction = ^TSQLFunction;
var SQLite3_Create_Function: function (db: Pointer;{const} zFunctionName: PAnsiChar; nArg: Integer; eTextRep: Integer; UserData: Pointer; xFunc: PSQLFunction; xStep: Pointer; xFinal: Pointer): Integer; cdecl; //Dak_Alpha
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
(* These two functions are used to add user functions or aggregates implemented in C to the SQL langauge interpreted by SQLite. The difference only between the two is that the second parameter, the name of the (scalar) function or aggregate, is encoded in UTF-8 for sqlite3_create_function() and UTF-16 for sqlite3_create_function16().

The first argument is the database handle that the new function or aggregate is to be added to. If a single program uses more than one database handle internally, then user functions or aggregates must be added individually to each database handle with which they will be used.

The third parameter is the number of arguments that the function or aggregate takes. If this parameter is negative, then the function or aggregate may take any number of arguments.

The sixth, seventh and eighth, xFunc, xStep and xFinal, are pointers to user implemented C functions that implement the user function or aggregate. A scalar function requires an implementation of the xFunc callback only, NULL pointers should be passed as the xStep and xFinal parameters. An aggregate function requires an implementation of xStep and xFinal, but NULL should be passed for xFunc. To delete an existing user function or aggregate, pass NULL for all three function callback. Specifying an inconstent set of callback values, such as an xFunc and an xFinal, or an xStep but no xFinal, SQLITE_ERROR is returned.
*)
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

{char *sqlite3_mprintf(const char*,...);
char *sqlite3_vmprintf(const char*, va_list);
}
(* These routines are variants of the "sprintf()" from the standard C library. The resulting string is written into memory obtained from malloc() so that there is never a possiblity of buffer overflow. These routines also implement some additional formatting options that are useful for constructing SQL statements.

The strings returned by these routines should be freed by calling sqlite3_free().

All of the usual printf formatting options apply. In addition, there is a "%q" option. %q works like %s in that it substitutes a null-terminated string from the argument list. But %q also doubles every '\'' character. %q is designed for use inside a string literal. By doubling each '\'' character it escapes that character and allows it to be inserted into the string.

For example, so some string variable contains text as follows:

  char *zText = "It's a happy day!";


One can use this text in an SQL statement as follows:

  sqlite3_exec_printf(db, "INSERT INTO table VALUES('%q')",
       callback1, 0, 0, zText);


Because the %q format string is used, the '\'' character in zText is escaped and the SQL generated is as follows:

  INSERT INTO table1 VALUES('It''s a happy day!')


This is correct. Had we used %s instead of %q, the generated SQL would have looked like this:

  INSERT INTO table1 VALUES('It's a happy day!');


This second example is an SQL syntax error. As a general rule you should always use %q instead of %s when inserting text into a string literal.
*)
var SQLite3_Open: function(dbName: PChar; var db: Pointer): Integer; cdecl;
var SQLite3_Open16: function(dbName: PWChar; var db: Pointer): Integer; cdecl;
var SQLite3_Prepare: function(db: Pointer; SQLStatement: PChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; cdecl;
var SQLite3_Prepare16: function(db: Pointer; SQLStatement: PWChar; SQLLength: Integer; var hstatement: Pointer; var Tail: pointer): Integer; cdecl;
{void sqlite3_progress_handler(sqlite3*, int, int(*)(void*), void*);}
(* Experimental

This routine configures a callback function - the progress callback - that is invoked periodically during long running calls to sqlite3_exec(), sqlite3_step() and sqlite3_get_table(). An example use for this API is to keep a GUI updated during a large query.

The progress callback is invoked once for every N virtual machine opcodes, where N is the second argument to this function. The progress callback itself is identified by the third argument to this function. The fourth argument to this function is a void pointer passed to the progress callback function each time it is invoked.

If a call to sqlite3_exec(), sqlite3_step() or sqlite3_get_table() results in less than N opcodes being executed, then the progress callback is not invoked.

To remove the progress callback altogether, pass NULL as the third argument to this function.

If the progress callback returns a result other than 0, then the current query is immediately terminated and any database changes rolled back. If the query was part of a larger transaction, then the transaction is not rolled back and remains active. The sqlite3_exec() call returns SQLITE_ABORT.
*)
var SQLite3_Reset: function(hstatement: Pointer): Integer; cdecl;

var SQLite3_Result_Double: procedure(sqlite3_context: Pointer; aDouble: Double); cdecl;      //Dak_Alpha
var SQLite3_Result_Int: procedure(sqlite3_context: Pointer; aInteger: Integer); cdecl;       //Dak_Alpha
var SQLite3_Result_Int64: procedure(sqlite3_context: Pointer; aInt64: Int64); cdecl;         //Dak_Alpha
var SQLite3_Result_Text: procedure(sqlite3_context: Pointer; aChar: PAnsiChar; n: Integer; destr: Pointer); cdecl;  //Dak_Alpha
var SQLite3_Result_Value: procedure(sqlite3_context: Pointer; sqlite3_value: Pointer); cdecl;//Dak_Alpha

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
(*User-defined functions invoke the following routines in order to set their return value. The sqlite3_result_value() routine is used to return an exact copy of one of the parameters to the function.

The operation of these routines is very similar to the operation of sqlite3_bind_blob() and its cousins. Refer to the documentation there for additional information.
*)
{int sqlite3_set_authorizer(
  sqlite3*,
  int (*xAuth)(void*,int,const char*,const char*,const char*,const char*),
  void *pUserData
);
}
(*#define SQLITE_CREATE_INDEX          1   // Index Name      Table Name      
#define SQLITE_CREATE_TABLE          2   // Table Name      NULL            
#define SQLITE_CREATE_TEMP_INDEX     3   // Index Name      Table Name      
#define SQLITE_CREATE_TEMP_TABLE     4   // Table Name      NULL            
#define SQLITE_CREATE_TEMP_TRIGGER   5   // Trigger Name    Table Name      
#define SQLITE_CREATE_TEMP_VIEW      6   // View Name       NULL            
#define SQLITE_CREATE_TRIGGER        7   // Trigger Name    Table Name      
#define SQLITE_CREATE_VIEW           8   // View Name       NULL            
#define SQLITE_DELETE                9   // Table Name      NULL            
#define SQLITE_DROP_INDEX           10   // Index Name      Table Name      
#define SQLITE_DROP_TABLE           11   // Table Name      NULL            
#define SQLITE_DROP_TEMP_INDEX      12   // Index Name      Table Name
#define SQLITE_DROP_TEMP_TABLE      13   // Table Name      NULL            
#define SQLITE_DROP_TEMP_TRIGGER    14   // Trigger Name    Table Name      
#define SQLITE_DROP_TEMP_VIEW       15   // View Name       NULL            
#define SQLITE_DROP_TRIGGER         16   // Trigger Name    Table Name      
#define SQLITE_DROP_VIEW            17   // View Name       NULL            
#define SQLITE_INSERT               18   // Table Name      NULL            
#define SQLITE_PRAGMA               19   // Pragma Name     1st arg or NULL 
#define SQLITE_READ                 20   // Table Name      Column Name     
#define SQLITE_SELECT               21   // NULL            NULL            
#define SQLITE_TRANSACTION          22   // NULL            NULL
#define SQLITE_UPDATE               23   // Table Name      Column Name     
#define SQLITE_ATTACH               24   // Filename        NULL            
#define SQLITE_DETACH               25   // Database Name   NULL            

#define SQLITE_DENY   1   // Abort the SQL statement with an error 
#define SQLITE_IGNORE 2   // Don't allow access, but don't generate an error

This routine registers a callback with the SQLite library. The callback is invoked (at compile-time, not at run-time) for each attempt to access a column of a table in the database. The callback should return SQLITE_OK if access is allowed, SQLITE_DENY if the entire SQL statement should be aborted with an error and SQLITE_IGNORE if the column should be treated as a NULL value.

The second parameter to the access authorization function above will be one of the values below. These values signify what kind of operation is to be authorized. The 3rd and 4th parameters to the authorization function will be parameters or NULL depending on which of the following codes is used as the second parameter. The 5th parameter is the name of the database ("main", "temp", etc.) if applicable. The 6th parameter is the name of the inner-most trigger or view that is responsible for the access attempt or NULL if this access attempt is directly from input SQL code.

The return value of the authorization function should be one of the constants SQLITE_OK, SQLITE_DENY, or SQLITE_IGNORE.

The intent of this routine is to allow applications to safely execute user-entered SQL. An appropriate callback can deny the user-entered SQL access certain operations (ex: anything that changes the database) or to deny access to certain tables or columns within the database.
*)
var SQLite3_Step: function(hstatement: Pointer): Integer; cdecl;
var SQLite3_Total_Changes: function(db: Pointer): Integer; cdecl;
{void *sqlite3_trace(sqlite3*, void(*xTrace)(void*,const char*), void*);
}
(*Register a function that is called at every invocation of sqlite3_exec() or sqlite3_prepare(). This function can be used (for example) to generate a log file of all SQL executed against a database. This is frequently useful when debugging an application that uses SQLite.
 *)
{void *sqlite3_user_data(sqlite3_context*);}
(*The pUserData parameter to the sqlite3_create_function() and sqlite3_create_function16() routines used to register user functions is available to the implementation of the function using this call.
*)

var SQLite3_Value_Blob: function(sqlite3_value: Pointer): Pointer; cdecl;          //Dak_Alpha
var SQLite3_Value_Bytes: function(sqlite3_value: Pointer): Integer; cdecl;         //Dak_Alpha
var SQLite3_Value_Double: function(sqlite3_value: Pointer): Double; cdecl;         //Dak_Alpha
var SQLite3_Value_Int: function(sqlite3_value: Pointer): Integer; cdecl;           //Dak_Alpha
var SQLite3_Value_Int64: function(sqlite3_value: Pointer): Int64; cdecl;           //Dak_Alpha
var SQLite3_Value_Text: function(sqlite3_value: Pointer): PAnsiChar; cdecl;        //Dak_Alpha
var SQLite3_Value_Type: function(sqlite3_value: Pointer): Integer; cdecl;          //Dak_Alpha

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
(*This group of routines returns information about parameters to a user-defined function. Function implementations use these routines to access their parameters. These routines are the same as the sqlite3_column_... routines except that these routines take a single sqlite3_value* pointer instead of an sqlite3_stmt* and an integer column number.

See the documentation under sqlite3_column_blob for additional information.
*)

///////////////////////
  //untested:
  //sqlite_progress_handler: procedure (db: Pointer; VMCyclesPerCallback: Integer; ProgressCallBack: Pointer; UserData: Integer{? Pointer?}); cdecl;

  Libs3Loaded: Boolean=False;
  DLLHandle: THandle;
  MsgNoError: String;


implementation

{$IFDEF FPC}
//FPC Support function helping typecasting:
function GetProcAddress(hModule: HMODULE; lpProcName: PChar): Pointer;
begin
  Result := GetProcedureAddress(hModule, lpProcName);
end;
{$ENDIF}

function LoadLibSqlite3(var libraryName: String): Boolean;
var libname: String;
begin
  Result := Libs3Loaded;
  if Result then //already loaded.
    exit;
    
  if libraryName = '' then
    libname := SQLITEDLL
  else
    libname := libraryName;

//  DLLHandle := GetModuleHandle(PChar(libraryName));
//  DLLHandle := LoadLibrary(PChar(libName));
  {$IFDEF FPC}
  DLLHandle := LoadLibrary(libname);
  {$ELSE}
  DLLHandle := LoadLibrary(PChar(libname));
  {$ENDIF}
  {$IFNDEF MSWINDOWS}
      // try other possible library name
      if DLLHandle = 0 then begin
         libname := libname + '.0';
         {$IFDEF FPC}
         DLLHandle := LoadLibrary(libname);
         {$ELSE}
         DLLHandle := LoadLibrary(PChar(libname));
         {$ENDIF}
      end;
  {$ENDIF}

  if DLLHandle <> 0 then
  begin
    Result := True; //assume everything ok unless..
    libraryName := libname;

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
  @SQLite3_Bind_Blob := GetProcAddress(DLLHandle, 'sqlite3_bind_blob');            //Dak_Alpha
  if not Assigned(@SQLite3_Bind_Blob) then Result := False;                        //Dak_Alpha

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
{void *sqlite3_commit_hook(sqlite3*, int(*xCallback)(void*), void *pArg);}
  @SQLite3_Complete := GetProcAddress(DLLHandle, 'sqlite3_complete');
  if not Assigned(@SQLite3_Complete) then Result := False;
  @SQLite3_Complete16 := GetProcAddress(DLLHandle, 'sqlite3_complete16');
  if not Assigned(@SQLite3_Complete16) then Result := False;
  @SQLite3_Create_Collation := GetProcAddress(DLLHandle, 'sqlite3_create_collation');
  if not Assigned(@SQLite3_Create_Collation) then Result := False;
  @SQLite3_Create_Collation16 := GetProcAddress(DLLHandle, 'sqlite3_create_collation16');
  if not Assigned(@SQLite3_Create_Collation16) then Result := False;
  @SQLite3_Create_Function := GetProcAddress(DLLHandle, 'sqlite3_create_function');//Dak_Alpha
  if not Assigned(@SQLite3_Create_Function) then Result := False;                  //Dak_Alpha
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
{void sqlite3_progress_handler(sqlite3*, int, int(*)(void*), void*);}
  @SQLite3_Reset := GetProcAddress(DLLHandle, 'sqlite3_reset');
  if not Assigned(@SQLite3_Reset) then Result := False;

  @SQLite3_Result_Double := GetProcAddress(DLLHandle, 'sqlite3_result_double');    //Dak_Alpha
  if not Assigned(@SQLite3_Result_Double) then Result := False;                    //Dak_Alpha
  @SQLite3_Result_Int := GetProcAddress(DLLHandle, 'sqlite3_result_int');          //Dak_Alpha
  if not Assigned(@SQLite3_Result_Int) then Result := False;                       //Dak_Alpha
  @SQLite3_Result_Int64 := GetProcAddress(DLLHandle, 'sqlite3_result_int64');      //Dak_Alpha
  if not Assigned(@SQLite3_Result_Int64) then Result := False;                     //Dak_Alpha
  @SQLite3_Result_Text := GetProcAddress(DLLHandle, 'sqlite3_result_text');        //Dak_Alpha
  if not Assigned(@SQLite3_Result_Text) then Result := False;                      //Dak_Alpha
  @SQLite3_Result_Value := GetProcAddress(DLLHandle, 'sqlite3_result_value');      //Dak_Alpha
  if not Assigned(@SQLite3_Result_Value) then Result := False;                     //Dak_Alpha


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
  @SQLite3_Step := GetProcAddress(DLLHandle, 'sqlite3_step');
  if not Assigned(@SQLite3_Step) then Result := False;
  @SQLite3_Total_Changes := GetProcAddress(DLLHandle, 'sqlite3_total_changes');
  if not Assigned(@SQLite3_Total_Changes) then Result := False;
  @SQLite3_LibVersion := GetProcAddress(DLLHandle, 'sqlite3_libversion');
  if not Assigned(@SQLite3_LibVersion) then Result := False;

  @SQLite3_Value_Blob := GetProcAddress(DLLHandle, 'sqlite3_value_blob');          //Dak_Alpha
  if not Assigned(@SQLite3_Value_Blob) then Result := False;                       //Dak_Alpha
  @SQLite3_Value_Bytes := GetProcAddress(DLLHandle, 'sqlite3_value_bytes');        //Dak_Alpha
  if not Assigned(@SQLite3_Value_Bytes) then Result := False;                      //Dak_Alpha
  @SQLite3_Value_Double := GetProcAddress(DLLHandle, 'sqlite3_value_double');      //Dak_Alpha
  if not Assigned(@SQLite3_Value_Double) then Result := False;                     //Dak_Alpha
  @SQLite3_Value_Int := GetProcAddress(DLLHandle, 'sqlite3_value_int');            //Dak_Alpha
  if not Assigned(@SQLite3_Value_Int) then Result := False;                        //Dak_Alpha
  @SQLite3_Value_Int64 := GetProcAddress(DLLHandle, 'sqlite3_value_int64');        //Dak_Alpha
  if not Assigned(@SQLite3_Value_Int64) then Result := False;                      //Dak_Alpha
  @SQLite3_Value_Text := GetProcAddress(DLLHandle, 'sqlite3_value_text');          //Dak_Alpha
  if not Assigned(@SQLite3_Value_Text) then Result := False;                       //Dak_Alpha
  @SQLite3_Value_Type := GetProcAddress(DLLHandle, 'sqlite3_value_type');          //Dak_Alpha
  if not Assigned(@SQLite3_Value_Type) then Result := False;                       //Dak_Alpha

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

    if not (Result) then
      begin
        {$IFDEF FPC}
          UnloadLibrary(DLLHandle);
        {$ELSE}
          FreeLibrary(DLLHandle);
        {$ENDIF}
        DllHandle := 0;
        //todo: nil all vars again...
      end;
  end;
  Libs3Loaded := Result;
end;


initialization
  //LibsLoaded := LoadLibs;
//  MsgNoError := SystemErrorMsg(0);
finalization
  if DLLHandle <> 0 then
    {$IFDEF FPC}
      UnloadLibrary(DLLHandle);
    {$ELSE}
      FreeLibrary(DLLHandle);
    {$ENDIF}

end.

