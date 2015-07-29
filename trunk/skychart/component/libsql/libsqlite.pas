unit libsqlite;

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

//libsql.dll api interface

//initial code by Ben Hochstrasser
//updated and put in seperate unit by Rene Tegel

(*
  Thanks to Ben Hochstrasser for doing the api interface stuff.
*)

{
simple class interface for SQLite. Hacked in by Ben Hochstrasser (bhoc@surfeu.ch)
Thanks to Roger Reghin (RReghin@scelectric.ca) for his idea to ValueList.
}

// for documentation on these constants and functions, please look at
// http://www.sqlite.org/c_interface.html

interface

uses {$IFNDEF FPC}{$IFDEF MSWINDOWS}Windows{$ELSE}SysUtils{$ENDIF}{$ELSE}Dynlibs{$ENDIF};

const
  SQLITE_OK         =  0;   // Successful result
  SQLITE_ERROR      =  1;   // SQL error or missing database
  SQLITE_INTERNAL   =  2;   // An internal logic error in SQLite
  SQLITE_PERM       =  3;   // Access permission denied
  SQLITE_ABORT      =  4;   // Callback routine requested an abort
  SQLITE_BUSY       =  5;   // The database file is locked
  SQLITE_LOCKED     =  6;   // A table in the database is locked
  SQLITE_NOMEM      =  7;   // A malloc() failed
  SQLITE_READONLY   =  8;   // Attempt to write a readonly database
  SQLITE_INTERRUPT  =  9;   // Operation terminated by sqlite_interrupt()
  SQLITE_IOERR      = 10;   // Some kind of disk I/O error occurred
  SQLITE_CORRUPT    = 11;   // The database disk image is malformed
  SQLITE_NOTFOUND   = 12;   // (Internal Only) Table or record not found
  SQLITE_FULL       = 13;   // Insertion failed because database is full
  SQLITE_CANTOPEN   = 14;   // Unable to open the database file
  SQLITE_PROTOCOL   = 15;   // Database lock protocol error
  SQLITE_EMPTY      = 16;   // (Internal Only) Database table is empty
  SQLITE_SCHEMA     = 17;   // The database schema changed
  SQLITE_TOOBIG     = 18;   // Too much data for one row of a table
  SQLITE_CONSTRAINT = 19;   // Abort due to contraint violation
  SQLITE_MISMATCH   = 20;   // Data type mismatch
//some new types (not supported in real old versions of sqlite)
  SQLITE_MISUSE     = 21;   //* Library used incorrectly */
  SQLITE_NOLFS      = 22;   //* Uses OS features not supported on host */
  SQLITE_AUTH       = 23;   //* Authorization denied */
  SQLITE_ROW        = 100;  //* sqlite_step() has another row ready */
  SQLITE_DONE       = 101;  //* sqlite_step() has finished executing */



  SQLITEDLL: PChar  = {$IFDEF LINUX}'libsqlite.so'{$ENDIF}{$IFDEF FREEBSD}'libsqlite.so'{$ENDIF}{$IFDEF MSWINDOWS}'sqlite.dll'{$ENDIF}{$IFDEF WINCE}'sqlite.dll'{$ENDIF}{$IFDEF darwin}'libsqlite.dylib'{$ENDIF};

function LoadLibSqlite2 (var LibraryPath: String): Boolean;

type PSQLite = Pointer;

     TSqlite_Func = record
                      P:Pointer;
                    end;
     PSQLite_Func = ^TSQLite_Func;

     //untested:
     procProgressCallback = procedure (UserData:Integer); cdecl;
     //untested:
     Tsqlite_create_function= function (db: Pointer; {const}zName:PChar; nArg: Integer;  xFunc : PSqlite_func{*,int,const char**};
       UserData: Integer):Integer; cdecl;

var
  SQLite_Open: function(dbname: PChar; mode: Integer; var ErrMsg: PChar): Pointer; cdecl;
  SQLite_Close: procedure(db: Pointer); cdecl;
  SQLite_Exec: function(db: Pointer; SQLStatement: PChar; CallbackPtr: Pointer; Sender: TObject; var ErrMsg: PChar): integer; cdecl;
  SQLite_Version: function(): PChar; cdecl;
  SQLite_Encoding: function(): PChar; cdecl;
  SQLite_ErrorString: function(ErrNo: Integer): PChar; cdecl;
  SQLite_GetTable: function(db: Pointer; SQLStatement: PChar; var ResultPtr: Pointer; var RowCount: Cardinal; var ColCount: Cardinal; var ErrMsg: PChar): integer; cdecl;
  SQLite_FreeTable: procedure(Table: PChar); cdecl;
  SQLite_FreeMem: procedure(P: PChar); cdecl;
  SQLite_Complete: function(P: PChar): boolean; cdecl;
  SQLite_LastInsertRow: function(db: Pointer): integer; cdecl;
  SQLite_Cancel: procedure(db: Pointer); cdecl;

  SQLite_BusyHandler: procedure(db: Pointer; CallbackPtr: Pointer; Sender: TObject); cdecl;
  SQLite_BusyTimeout: procedure(db: Pointer; TimeOut: integer); cdecl;
  SQLite_Changes: function(db: Pointer): integer; cdecl;

  //untested:
  sqlite_progress_handler: procedure (db: Pointer; VMCyclesPerCallback: Integer; ProgressCallBack: Pointer; UserData: Integer{? Pointer?}); cdecl;

{
int sqlite_compile(
  sqlite *db,              /* The open database */
  const char *zSql,        /* SQL statement to be compiled */
  const char **pzTail,     /* OUT: uncompiled tail of zSql */
  sqlite_vm **ppVm,        /* OUT: the virtual machine to execute zSql */
  char **pzErrmsg          /* OUT: Error message. */
);

int sqlite_step(
  sqlite_vm *pVm,          /* The virtual machine to execute */
  int *pN,                 /* OUT: Number of columns in result */
  const char ***pazValue,  /* OUT: Column data */
  const char ***pazColName /* OUT: Column names and datatypes */
);

int sqlite_finalize(
  sqlite_vm *pVm,          /* The virtual machine to be finalized */
  char **pzErrMsg          /* OUT: Error message */
);
}

  sqlite_compile: function(
    db: Pointer;             //* The open database */
    Sql: PChar;              //* SQL statement to be compiled */
    var Tail: PChar;         //* OUT: uncompiled tail of zSql */
    var Vm: Pointer;         //* OUT: the virtual machine to execute zSql */
    var Errmsg: PChar        //* OUT: Error message. */
  ): Integer; cdecl;

  sqlite_step: function(
    Vm: Pointer;             //* The virtual machine to execute */
    var N: Integer;          //* OUT: Number of columns in result */
    var pazValue: Pointer;     //* OUT: Column data */
    var pazColName: Pointer    //* OUT: Column names and datatypes */
  ): Integer; cdecl;

  sqlite_finalize: function(
    Vm: Pointer;             //* The virtual machine to be finalized */
    var ErrMsg: PChar        //* OUT: Error message */
  ): Integer; cdecl;


  Libs2Loaded: Boolean = False;
  DLLHandle: {$IFDEF FPC}TLibHandle{$ELSE}THandle{$ENDIF};
  MsgNoError: String;


implementation

function LoadLibSqlite2 (var LibraryPath: String): Boolean;
var libname: String;
begin
  Result := Libs2Loaded;
  if Result then //alread loaded
    exit;

  if libraryPath = '' then
    libname := SQLITEDLL
  else
    libname := libraryPath;

  {$IFNDEF FPC}
  //DLLHandle := GetModuleHandle(LibraryPath);
  {$ENDIF}
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
    LibraryPath := LibName;
	// FPC GetProc differs a little
{$IFNDEF FPC}
    @SQLite_Open := GetProcAddress(DLLHandle, 'sqlite_open');
    if not Assigned(@SQLite_Open) then Result := False;
    @SQLite_Close := GetProcAddress(DLLHandle, 'sqlite_close');
    if not Assigned(@SQLite_Close) then Result := False;
    @SQLite_Exec := GetProcAddress(DLLHandle, 'sqlite_exec');
    if not Assigned(@SQLite_Exec) then Result := False;
    @SQLite_Version := GetProcAddress(DLLHandle, 'sqlite_libversion');
    if not Assigned(@SQLite_Version) then Result := False;
    @SQLite_Encoding := GetProcAddress(DLLHandle, 'sqlite_libencoding');
    if not Assigned(@SQLite_Encoding) then Result := False;
    @SQLite_ErrorString := GetProcAddress(DLLHandle, 'sqlite_error_string');
    if not Assigned(@SQLite_ErrorString) then Result := False;
    @SQLite_GetTable := GetProcAddress(DLLHandle, 'sqlite_get_table');
    if not Assigned(@SQLite_GetTable) then Result := False;
    @SQLite_FreeTable := GetProcAddress(DLLHandle, 'sqlite_free_table');
    if not Assigned(@SQLite_FreeTable) then Result := False;
    @SQLite_FreeMem := GetProcAddress(DLLHandle, 'sqlite_freemem');
    if not Assigned(@SQLite_FreeMem) then Result := False;
    @SQLite_Complete := GetProcAddress(DLLHandle, 'sqlite_complete');
    if not Assigned(@SQLite_Complete) then Result := False;
    @SQLite_LastInsertRow := GetProcAddress(DLLHandle, 'sqlite_last_insert_rowid');
    if not Assigned(@SQLite_LastInsertRow) then Result := False;
    @SQLite_Cancel := GetProcAddress(DLLHandle, 'sqlite_interrupt');
    if not Assigned(@SQLite_Cancel) then Result := False;
    @SQLite_BusyTimeout := GetProcAddress(DLLHandle, 'sqlite_busy_timeout');
    if not Assigned(@SQLite_BusyTimeout) then Result := False;
    @SQLite_BusyHandler := GetProcAddress(DLLHandle, 'sqlite_busy_handler');
    if not Assigned(@SQLite_BusyHandler) then Result := False;
    @SQLite_Changes := GetProcAddress(DLLHandle, 'sqlite_changes');
    if not Assigned(@SQLite_Changes) then Result := False;
    sqlite_progress_handler := GetProcAddress (DLLHandle, 'sqlite_progress_handler');

    sqlite_compile := GetProcAddress (DLLHandle, 'sqlite_compile');
    sqlite_step := GetProcAddress (DLLHandle, 'sqlite_step');
    sqlite_finalize := GetProcAddress (DLLHandle, 'sqlite_finalize');
{$ELSE}
		@SQLite_Open := GetProcedureAddress(DLLHandle, 'sqlite_open');
    if not Assigned(@SQLite_Open) then Result := False;
    @SQLite_Close := GetProcedureAddress(DLLHandle, 'sqlite_close');
    if not Assigned(@SQLite_Close) then Result := False;
    @SQLite_Exec := GetProcedureAddress(DLLHandle, 'sqlite_exec');
    if not Assigned(@SQLite_Exec) then Result := False;
    @SQLite_Version := GetProcedureAddress(DLLHandle, 'sqlite_libversion');
    if not Assigned(@SQLite_Version) then Result := False;
    @SQLite_Encoding := GetProcedureAddress(DLLHandle, 'sqlite_libencoding');
    if not Assigned(@SQLite_Encoding) then Result := False;
    @SQLite_ErrorString := GetProcedureAddress(DLLHandle, 'sqlite_error_string');
    if not Assigned(@SQLite_ErrorString) then Result := False;
    @SQLite_GetTable := GetProcedureAddress(DLLHandle, 'sqlite_get_table');
    if not Assigned(@SQLite_GetTable) then Result := False;
    @SQLite_FreeTable := GetProcedureAddress(DLLHandle, 'sqlite_free_table');
    if not Assigned(@SQLite_FreeTable) then Result := False;
    @SQLite_FreeMem := GetProcedureAddress(DLLHandle, 'sqlite_freemem');
    if not Assigned(@SQLite_FreeMem) then Result := False;
    @SQLite_Complete := GetProcedureAddress(DLLHandle, 'sqlite_complete');
    if not Assigned(@SQLite_Complete) then Result := False;
    @SQLite_LastInsertRow := GetProcedureAddress(DLLHandle, 'sqlite_last_insert_rowid');
    if not Assigned(@SQLite_LastInsertRow) then Result := False;
    @SQLite_Cancel := GetProcedureAddress(DLLHandle, 'sqlite_interrupt');
    if not Assigned(@SQLite_Cancel) then Result := False;
    @SQLite_BusyTimeout := GetProcedureAddress(DLLHandle, 'sqlite_busy_timeout');
    if not Assigned(@SQLite_BusyTimeout) then Result := False;
    @SQLite_BusyHandler := GetProcedureAddress(DLLHandle, 'sqlite_busy_handler');
    if not Assigned(@SQLite_BusyHandler) then Result := False;
    @SQLite_Changes := GetProcedureAddress(DLLHandle, 'sqlite_changes');
    if not Assigned(@SQLite_Changes) then Result := False;
    sqlite_progress_handler := GetProcedureAddress (DLLHandle, 'sqlite_progress_handler');

{$ENDIF}
    if not (Result) then
      begin
        {$IFNDEF FPC}FreeLibrary (DllHandle){$ELSE}UnloadLibrary(DllHandle){$ENDIF};
        DllHandle := 0;
        //todo: nil all vars again...
      end;
  end;
end;


initialization
  //Let component or user do it
  //LibsLoaded := LoadLibs;

//  MsgNoError := SystemErrorMsg(0);
finalization
  if DLLHandle <> 0 then
    {$IFNDEF FPC}FreeLibrary (DllHandle){$ELSE}UnloadLibrary(DllHandle){$ENDIF};


end.

{ ToDo : callback functions

typedef struct sqlite_func sqlite_func;

int sqlite_create_function(
  sqlite *db,
  const char *zName,
  int nArg,
  void (*xFunc)(sqlite_func*,int,const char**),
  void *pUserData
);
int sqlite_create_aggregate(
  sqlite *db,
  const char *zName,
  int nArg,
  void (*xStep)(sqlite_func*,int,const char**),
  void (*xFinalize)(sqlite_func*),
  void *pUserData
);

char *sqlite_set_result_string(sqlite_func*,const char*,int);
void sqlite_set_result_int(sqlite_func*,int);
void sqlite_set_result_double(sqlite_func*,double);
void sqlite_set_result_error(sqlite_func*,const char*,int);

void *sqlite_user_data(sqlite_func*);
void *sqlite_aggregate_context(sqlite_func*, int nBytes);
int sqlite_aggregate_count(sqlite_func*);

The sqlite_create_function() interface is used to create regular functions and sqlite_create_aggregate() is used to create new aggregate functions. In both cases, the db parameter is an open SQLite database on which the functions should be registered, zName is the name of the new function, nArg is the number of arguments, and pUserData is a pointer which is passed through unchanged to the C implementation of the function. Both routines return 0 on success and non-zero if there are any errors.

The length of a function name may not exceed 255 characters. Any attempt to create a function whose name exceeds 255 characters in length will result in an error.

For regular functions, the xFunc callback is invoked once for each function call. The implementation of xFunc should call one of the sqlite_set_result_... interfaces to return its result. The sqlite_user_data() routine can be used to retrieve the pUserData pointer that was passed in when the function was registered.

For aggregate functions, the xStep callback is invoked once for each row in the result and then xFinalize is invoked at the end to compute a final answer. The xStep routine can use the sqlite_aggregate_context() interface to allocate memory that will be unique to that particular instance of the SQL function. This memory will be automatically deleted after xFinalize is called. The sqlite_aggregate_count() routine can be used to find out how many rows of data were passed to the aggregate. The xFinalize callback should invoke one of the sqlite_set_result_... interfaces to set the final result of the aggregate.

SQLite now implements all of its built-in functions using this interface. For additional information and examples on how to create new SQL functions, review the SQLite source code in the file func.c.
}


