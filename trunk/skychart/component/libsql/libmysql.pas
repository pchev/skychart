
unit libmysql;

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

// mysql library pascal interface
// rene@dubaron.com

interface

// LibSQL now seems to be compatible with FPC on all supported platforms
// (Win32 and UNIX).
// FPC-compatibility code by Trustmaster (trustware@bk.ru).

uses {$IFNDEF FPC}{$IFDEF MSWINDOWS}Windows{$ELSE}SysUtils{$ENDIF}{$ELSE}Dynlibs{$ENDIF};


//Make sure you link to the correct version of the libmysql.dll/.so library!

//This unit supports 3 versions of mysql:
//* mysql < 3.2x  -- OLD_LIBMYSQL_DLL
//* mysql 3.2x    -- NEW_LIBMYSQL_DLL
//* mysql 4.0x    -- MYSQL4
//* mysql 4.x ?   -- MYSQL4


// Most important thing to check if functionality fails,
// check these compiler switches.
// also, check which .dll or .so is loaded.

//If you're working with mysql 3.2x, comment this out
{$DEFINE MYSQL4}

//UNDEFINE this if you are working with really old libmysql (<<3.2x)
{$DEFINE NEW_LIBMYSQL_DLL}
//(also undefine MYSQL4 then)


{$IFDEF MYSQL4}
{$DEFINE NEW_LIBMYSQL_DLL}
{$ENDIF}

{$IFDEF LINUX}
{$DEFINE NEW_LIBMYSQL_DLL}
// $ DEFINE OLD_LIBMYSQL_DLL
{$ENDIF}



//Created februari 18. 2004
//from: mysql.pas unit (TMyDB)
//you may be be able to replace this by another (lib)mysql.pas unit.

(*
  Original API interface by ZEOS

  Added by Rene:
  Addition API functions
  MySQL 4.0 support

*)




const
{$IFDEF MSWINDOWS}
  //libmysql client
  DEFAULT_DLL_LOCATION = 'libmysql.dll';
  //The embedded mysql daemon
  MYSQLD_DLL_LOCATION = 'libmysqld.dll';
{$ELSE}
{$IFDEF darwin}
  //libmysql client
  DEFAULT_DLL_LOCATION = 'libmysqlclient.dylib';
  //The embedded mysql daemon
  MYSQLD_DLL_LOCATION = 'libmysqld.dylib';
{$ELSE}
  DEFAULT_DLL_LOCATION = 'libmysqlclient.so';
  //embedded mysql on unix, not really sure:
  MYSQLD_DLL_LOCATION = 'libmysqld.so'; // ?
  //you may want to specify a full path like:
  //DEFAULT_DLL_LOCATION = '/usr/local/lib/mysql/libmysqlclient.so';
{$ENDIF}
{$ENDIF}


// What i (rene) did with ZEOS' code (v0.1):
// Cleaned up and re-lay-outed
// Extended it with some additional libmysql functions
// Adjusted the library loading functions.
// Added embedded mysql support

// Got some header stripped from Zeos components.
// Their header is below. Tx pals.

//With many thanx to ZEOS for initial API porting !

{********************************************************}
{                 Zeos Database Objects                  }
{        Delphi plain interface to libmysql.dll          }
{       Copyright (c) 1999-2001 Sergey Seroukhov         }
{    Copyright (c) 1999-2001 Zeos Development Group      }
{********************************************************}

{***************** Plain API Constants definition ****************}

//in fact we can get lost of a lot of this crap.
//it is useless to define, because it'll change with any mysql release.
//i'll leave it in for now
//but unless somebody gives me serious reason to let it in
//i'll remove it later on.

const
{General Declarations}
  MYSQL_ERRMSG_SIZE    = 200;
  MYSQL_PORT           = 3306;
  LOCAL_HOST           = 'localhost';
  NAME_LEN             = 64;
  PROTOCOL_VERSION     = 10;
  FRM_VER              = 6;

{Enum Field Types}
  FIELD_TYPE_DECIMAL   = 0;
  FIELD_TYPE_TINY      = 1;
  FIELD_TYPE_SHORT     = 2;
  FIELD_TYPE_LONG      = 3;
  FIELD_TYPE_FLOAT     = 4;
  FIELD_TYPE_DOUBLE    = 5;
  FIELD_TYPE_NULL      = 6;
  FIELD_TYPE_TIMESTAMP = 7;
  FIELD_TYPE_LONGLONG  = 8;
  FIELD_TYPE_INT24     = 9;
  FIELD_TYPE_DATE      = 10;
  FIELD_TYPE_TIME      = 11;
  FIELD_TYPE_DATETIME  = 12;
  FIELD_TYPE_YEAR      = 13;
  FIELD_TYPE_NEWDATE   = 14;


  FIELD_TYPE_ENUM      = 247;
  FIELD_TYPE_SET       = 248;
  FIELD_TYPE_TINY_BLOB = 249;
  FIELD_TYPE_MEDIUM_BLOB = 250;
  FIELD_TYPE_LONG_BLOB = 251;
  FIELD_TYPE_BLOB      = 252;
  FIELD_TYPE_VAR_STRING = 253;
  FIELD_TYPE_STRING    = 254;
  FIELD_TYPE_GEOMETRY=255;

type enum_field_types = FIELD_TYPE_DECIMAL .. FIELD_TYPE_GEOMETRY;

const
{For Compatibility}
  FIELD_TYPE_CHAR      = FIELD_TYPE_TINY;
  FIELD_TYPE_INTERVAL  = FIELD_TYPE_ENUM;

{ Field's flags }
  NOT_NULL_FLAG          = 1;     { Field can't be NULL }
  PRI_KEY_FLAG           = 2;     { Field is part of a primary key }
  UNIQUE_KEY_FLAG        = 4;     { Field is part of a unique key }
  MULTIPLE_KEY_FLAG      = 8;     { Field is part of a key }
  BLOB_FLAG              = 16;    { Field is a blob }
  UNSIGNED_FLAG          = 32;    { Field is unsigned }
  ZEROFILL_FLAG          = 64;    { Field is zerofill }
  BINARY_FLAG            = 128;   { Field is binary }
  ENUM_FLAG              = 256;   { Field is an enum }
  AUTO_INCREMENT_FLAG    = 512;   { Field is a autoincrement field }
  TIMESTAMP_FLAG         = 1024;  { Field is a timestamp }
  SET_FLAG               = 2048;  { Field is a set }
  NUM_FLAG               = 32768; { Field is num (for clients) }

{Server Administration Refresh Options}
  REFRESH_GRANT	         = 1;     { Refresh grant tables }
  REFRESH_LOG		 = 2;     { Start on new log file }
  REFRESH_TABLES	 = 4;     { close all tables }
  REFRESH_HOSTS	         = 8;     { Flush host cache }
  REFRESH_STATUS         = 16;    { Flush status variables }
  REFRESH_THREADS        = 32;    { Flush status variables }
  REFRESH_SLAVE          = 64;    { Reset master info abd restat slave thread }
  REFRESH_MASTER         = 128;   { Remove all bin logs in the index and truncate the index }
  REFRESH_READ_LOCK      = 16384; { Lock tables for read }
  REFRESH_FAST		 = 32768; { Intern flag }

{ Client Connection Options }
  _CLIENT_LONG_PASSWORD	  = 1;	  { new more secure passwords }
  _CLIENT_FOUND_ROWS	  = 2;	  { Found instead of affected rows }
  _CLIENT_LONG_FLAG	  = 4;	  { Get all column flags }
  _CLIENT_CONNECT_WITH_DB = 8;	  { One can specify db on connect }
  _CLIENT_NO_SCHEMA	  = 16;	  { Don't allow database.table.column }
  _CLIENT_COMPRESS	  = 32;	  { Can use compression protcol }
  _CLIENT_ODBC		  = 64;	  { Odbc client }
  _CLIENT_LOCAL_FILES	  = 128;  { Can use LOAD DATA LOCAL }
  _CLIENT_IGNORE_SPACE	  = 256;  { Ignore spaces before '(' }
  _CLIENT_CHANGE_USER     = 512;  { Support the mysql_change_user() }
  _CLIENT_INTERACTIVE     = 1024; { This is an interactive client }
  _CLIENT_SSL             = 2048; { Switch to SSL after handshake }
  _CLIENT_IGNORE_SIGPIPE  = 4096; { IGNORE sigpipes }
  _CLIENT_TRANSACTIONS    = 8196; { Client knows about transactions }


{****************** Plain API Types definition *****************}

type
   TBOOL =LongBool;
   TInt64=Int64;
  TClientCapabilities = (
    CLIENT_LONG_PASSWORD,
    CLIENT_FOUND_ROWS,
    CLIENT_LONG_FLAG,
    CLIENT_CONNECT_WITH_DB,
    CLIENT_NO_SCHEMA,
    CLIENT_COMPRESS,
    CLIENT_ODBC,
    CLIENT_LOCAL_FILES,
    CLIENT_IGNORE_SPACE
  );

  TSetClientCapabilities = set of TClientCapabilities;

  TRefreshOptions = (
    _REFRESH_GRANT,
    _REFRESH_LOG,
    _REFRESH_TABLES,
    _REFRESH_HOSTS,
    _REFRESH_FAST
  );
  TSetRefreshOptions = set of TRefreshOptions;

  mysql_status = (
    MYSQL_STATUS_READY,
    MYSQL_STATUS_GET_RESULT,
    MYSQL_STATUS_USE_RESULT
  );

  mysql_option = (
    MYSQL_OPT_CONNECT_TIMEOUT,
    MYSQL_OPT_COMPRESS,
    MYSQL_OPT_NAMED_PIPE,
    MYSQL_INIT_COMMAND,
    MYSQL_READ_DEFAULT_FILE,
    MYSQL_READ_DEFAULT_GROUP,
    MYSQL_SET_CHARSET_DIR,
    MYSQL_SET_CHARSET_NAME
    {$IFDEF MYSQL4}
    ,MYSQL_OPT_LOCAL_INFILE
    {$ENDIF}
  );

  PUSED_MEM=^USED_MEM;
  USED_MEM = packed record
    next:       PUSED_MEM;
    left:       Integer;
    size:       Integer;
  end;

  PERR_PROC = ^ERR_PROC;
  ERR_PROC = procedure;

  PMEM_ROOT = ^MEM_ROOT;

  {$IFDEF MYSQL4}
  MEM_ROOT = packed record
    free:          PUSED_MEM;
    used:          PUSED_MEM;
    pre_alloc:     PUSED_MEM;
    min_malloc,
    block_size,
    block_num:     Integer;
    first_block_usage: Integer;
    error_handler: PERR_PROC;
  end;
  {$ELSE}
  MEM_ROOT = packed record
    free:          PUSED_MEM;
    used:          PUSED_MEM;
{$IFDEF NEW_LIBMYSQL_DLL}
    pre_alloc:     PUSED_MEM;
{$ENDIF}
    min_malloc:    Integer;
    block_size:    Integer;
    error_handler: PERR_PROC;
  end;
{$ENDIF}

{$IFDEF MYSQL4}
  NET = packed record
    vio:           Pointer;
    buff:          PChar;
    buff_end:      PChar;
    write_pos:     PChar;
    read_pos:      PChar;
    fd:            Integer;
    max_packet:    Integer;
    max_packet_size: Integer;
    last_errno:    Integer;
    pkt_nr:        Integer;
    compress_pkt_nr: Integer;
    write_timeout,
    read_timeout,
    retry_count:   Integer;
    fcntl:         Integer;
    last_error:    array[01..MYSQL_ERRMSG_SIZE] of Char;
    error:         Char; //unsigned char
    return_errno,
    compress:      TBool;
    remain_in_buf: LongInt;
    length:        LongInt;
    buf_length:    LongInt;
    where_b:       LongInt;
    return_status: Pointer;
    reading_or_writing: Char;
    save_char:     Char;
    no_send_ok:    TBool;
    query_cache_query: PChar; //gptr ??
  end;
{$ELSE}
  NET = packed record
    vio:           Pointer;
    fd:            Integer;
    fcntl:         Integer;
    buff:          PChar;
    buff_end:      PChar;
    write_pos:     PChar;
    read_pos:      PChar;
    last_error:    array[01..MYSQL_ERRMSG_SIZE] of Char;
    last_errno:    Integer;
    max_packet:    Integer;
    timeout:       Integer;
    pkt_nr:        Integer;
{$IFDEF NEW_LIBMYSQL_DLL}
    error:         Char;
{$ELSE}
    error:         TBool;
{$ENDIF}
    return_errno:  TBool;
    compress:      TBool;
{$IFDEF NEW_LIBMYSQL_DLL}
    no_send_ok:    TBool;
{$ENDIF}
    remain_in_buf: LongInt;
    length:        LongInt;
    buf_length:    LongInt;
    where_b:       LongInt;
{$IFDEF NEW_LIBMYSQL_DLL}
    return_status: Pointer;
    reading_or_writing: Char;
{$ELSE}
    more:          TBool;
{$ENDIF}
    save_char:     Char;
  end;
{$ENDIF}

  MYSQL_FIELD = record
    name:       PChar; //Name of column
    table:      PChar; //Table of column if column was a field
    {$IFDEF MYSQL4}
    org_table:  PChar; //Org table name if table was an alias
    db:         PChar; //Database for table
    {$ENDIF}
    def:        PChar;
    {$IFNDEF MYSQL4}
    enum_field_type:      Byte;
    {$ENDIF}
    length:     Integer; //Width of column
    max_length: Integer; //Max width of selected set
    flags:      Integer; //Div flags
    decimals:   Integer; //Number of decimals in field
    {$IFDEF MYSQL4}
    enum_field_type: enum_field_types; //Type of field. Se mysql_com.h for types
    {$ENDIF}
  end;

  PMYSQL_FIELD = ^MYSQL_FIELD;
  MYSQL_FIELDS = array [0..$ff] of MYSQL_FIELD;
  PMYSQL_FIELDS = ^MYSQL_FIELDS;

  MYSQL_FIELD_32 = record
    name:       PChar; //Name of column
    table:      PChar; //Table of column if column was a field
    def:        PChar;
    enum_field_type:      Byte;
    length:     Integer; //Width of column
    max_length: Integer; //Max width of selected set
    flags:      Integer; //Div flags
    decimals:   Integer; //Number of decimals in field
  end;

  PMYSQL_FIELD_32 = ^MYSQL_FIELD_32;

  MYSQL_FIELD_40 = record
    name:       PChar; //Name of column
    table:      PChar; //Table of column if column was a field
    org_table:  PChar; //Org table name if table was an alias
    db:         PChar; //Database for table
    def:        PChar;
    length:     Integer; //Width of column
    max_length: Integer; //Max width of selected set
    flags:      Integer; //Div flags
    decimals:   Integer; //Number of decimals in field
    enum_field_type: enum_field_types; //Type of field. Se mysql_com.h for types
  end;

  PMYSQL_FIELD_40 = ^MYSQL_FIELD_40;

  MYSQL_FIELD_50 = record
    name: PChar;                 //* Name of column */
    org_name: PChar;             //* Original column name, if an alias */
    table: PChar;                //* Table of column if column was a field */
    org_table: PChar;            //* Org table name, if table was an alias */
    db: PChar;                   //* Database for table */
    catalog: PChar;	         //* Catalog for table */
    def: PChar;                  //* Default value (set by mysql_list_fields) */
    length: Integer;             //* Width of column */
    max_length: Integer;         //* Max width of selected set */
    name_length: Integer;
    org_name_length: Integer;
    table_length: Integer;
    org_table_length: Integer;
    db_length: Integer;
    catalog_length: Integer;
    def_length: Integer;
    flags: Integer;              //* Div flags */
    decimals: Integer;           //* Number of decimals in field */
    charsetnr: Integer;          //* Character set */
    enum_field_type: enum_field_types;   //* Type of field. Se mysql_com.h for types */
  end;

  PMYSQL_FIELD_50 = ^MYSQL_FIELD_50;
  PMYSQL_FIELD_41 = ^MYSQL_FIELD_50; //yes, they are identical.

  MYSQL_FIELD_OFFSET = Cardinal;

  //MYSQL_ROW = array[00..$ff] of PChar;
  //just hope this will work on all compilers.
  //if not, uncomment line above and comment next.
  MYSQL_ROW = array[0..0] of PChar;
  PMYSQL_ROW = ^MYSQL_ROW;

  PMYSQL_ROWS = ^MYSQL_ROWS;
  
  MYSQL_ROWS = packed record
    next:       PMYSQL_ROWS;
    data:       PMYSQL_ROW;
  end;

  MYSQL_ROW_OFFSET = PMYSQL_ROWS;

  MYSQL_DATA = packed record
    Rows:       TInt64;
    Fields:     Cardinal;
    Data:       PMYSQL_ROWS;
    Alloc:      MEM_ROOT;
  end;
  PMYSQL_DATA = ^MYSQL_DATA;

type
  _MYSQL_OPTIONS = packed record
    connect_timeout: Integer;
    clientFlag:      Integer;
    {$IFNDEF MYSQL4}
    compress:        TBool;
    named_pipe:      TBool;
    {$ENDIF}
    port:            Integer;
    host:            PChar;
    init_command:    PChar;
    user:            PChar;
    password:        PChar;
    unix_socket:     PChar;
    db:              PChar;
    my_cnf_file:     PChar;
    my_cnf_group:    PChar;
    charset_dir:     PChar;
    charset_name:    PChar;
    {$IFNDEF MYSQL4}
    use_ssl:         TBool;
    {$ENDIF}
    ssl_key:         PChar;
    ssl_cert:        PChar;
    ssl_ca:          PChar;
    ssl_capath:      PChar;
    {$IFDEF MYSQL4}
    ssl_cipher:      PChar;
    max_allowed_packet: Integer;
    use_ssl:         TBool;
    compress:        TBool;
    Named_pipe:      TBool;
{  On connect, find out the replication role of the server, and
   establish connections to all the peers}
    rpl_probe:       TBool;
{  Each call to mysql_real_query() will parse it to tell if it is a read
   or a write, and direct it to the slave or the master}
    rpl_parse:       TBool;
{  If set, never read from a master,only from slave, when doing
   a read that is replication-aware}
    no_master_reads: TBool;
    {$ENDIF}
  end;
  PMYSQL_OPTIONS = ^_MYSQL_OPTIONS;

  PMySQL = ^MYSQL;

{$IFDEF MYSQL4} //Too different
  MYSQL = packed record
    _net:            NET;
    connector_fd:    PChar;
    host:            PChar;
    user:            PChar;
    passwd:          PChar;
    unix_socket:     PChar;
    server_version:  Integer; //PChar;
    host_info:       Integer; //PChar; //what type is this?
    info:            PChar;
    db:              PChar;
    charset:         PChar; //PCharsetInfo
    fields:          PMYSQL_FIELD;
    field_alloc:     MEM_ROOT;
    affected_rows:   TInt64;
    insert_id:       TInt64;
    extra_info:      TInt64;
    thread_id:       LongInt;
    packet_length:   LongInt;
    port:            Integer;
    client_flag:     Integer;
    server_capabilities: Integer;
    protocol_version: Integer;
    field_count:     Integer;
    server_status:   Integer;
    server_language: Integer;
    options:         _mysql_options;
    status:          mysql_status;
    free_me, reconnect: TBool;
    scramble_buff:   array[0..8] of Char;
    rpl_pivot:       TBool;
    master:          Pmysql;
    next_slave:      Pmysql;
    last_used_con:   Pmysql;
    ///some dummy
    dummy:           array[0..8192] of Char;
   end;
{$ELSE}
  MYSQL = packed record
    _net:            NET;
    connector_fd:    PChar;
    host:            PChar;
    user:            PChar;
    passwd:          PChar;
    unix_socket:     PChar;
    server_version:  PChar;
    host_info:       PChar;
    info:            PChar;
    db:              PChar;
    port:            Integer;
    client_flag:     Integer;
    server_capabilities: Integer;
    protocol_version: Integer;
    field_count:     Integer;
{$IFDEF NEW_LIBMYSQL_DLL}
    server_status:   Integer;
{$ENDIF}
    thread_id:       LongInt;
    affected_rows:   TInt64;
    insert_id:       TInt64;
    extra_info:      TInt64;
    packet_length:   LongInt;
    status:          mysql_status;
    fields:          PMYSQL_FIELD;
    field_alloc:     MEM_ROOT;
    free_me, reconnect: TBool;
    options:         _mysql_options;
    scramble_buff:   array[0..8] of Char;
    charset:         PChar;
{$IFDEF NEW_LIBMYSQL_DLL}
    server_language: Integer;
{$ENDIF}
  end;
{$ENDIF}

  MYSQL_RES = record
    row_count:       TInt64;
    {$IFNDEF MYSQL4}
    field_count:     Integer;
    current_field:   Integer;
    {$ENDIF}
    fields:          PMYSQL_FIELD;
    data:            PMYSQL_DATA;
    data_cursor:     PMYSQL_ROWS;
    {$IFDEF MYSQL4}
    lengths:         PLongInt;
    {$ELSE}
    field_alloc:     MEM_ROOT;
    row:             PMYSQL_ROW;
    current_row:     PMYSQL_ROW;
    lengths:         PLongInt;
    {$ENDIF}
    handle:          PMYSQL;
    {$IFDEF MYSQL4}
    field_alloc:     MEM_ROOT;
    field_count:     Integer;
    current_field:   Integer;
    row:             PMYSQL_ROW;
    current_row:     PMYSQL_ROW;
    {$ENDIF}
    eof:             TBool;
  end;
  PMYSQL_RES = ^MYSQL_RES;

  TModifyType = (MODIFY_INSERT, MODIFY_UPDATE, MODIFY_DELETE);
  TQuoteOptions = (QUOTE_STRIP_CR,QUOTE_STRIP_LF);
  TQuoteOptionsSet = set of TQuoteOptions;

  {$IFDEF MYSQL4}
const
  MAX_MYSQL_MANAGER_ERR = 256;
  MAX_MYSQL_MANAGER_MSG = 256;

  MANAGER_OK            = 200;
  MANAGER_INFO          = 250;
  MANAGER_ACCESS        = 401;
  MANAGER_CLIENT_ERR    = 450;
  MANAGER_INTERNAL_ERR  = 500;

type TMYSQL_MANAGER = packed record
                        _NET: NET;
                        host,
                        user,
                        passwd:           PChar;
                        port:             Integer;
                        free_me:          TBool;
                        eof:              TBool;
                        cmd_status:       Integer;
                        last_errno:       Integer;
                        net_buf,
                        net_buf_pos,
                        net_data_end:     PChar;
                        net_buf_size:     Integer;
                        last_error:       Array [0..MAX_MYSQL_MANAGER_ERR - 1] of Char;
                      end;
  {$ENDIF}

//embedded stuff:
const
  SERVER_GROUPS : array [0..3] of PChar = ('test_libmysqld_SERVER'#0,'embedded'#0,'server'#0, nil);

  DEFAULT_PARAMS : array [0..2] of PChar = ('not_used'#0, {$IFDEF MSWINDOWS}'--datadir=.\'#0{$ELSE}'--datadir=./'{$ENDIF}, '--set-variable=key_buffer_size=32M'#0);


{************** Plain API Function types definition *************}
type
  Tmysql_debug = procedure(Debug: PChar);

  Tmysql_dump_debug_info = function(Handle: PMYSQL): Integer;

  Tmysql_init = function(Handle: PMYSQL): PMYSQL;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_connect = function(Handle: PMYSQL; const Host, User, Passwd: PChar):
    PMYSQL; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_real_connect = function(Handle: PMYSQL;
    const Host, User, Passwd, Db: PChar; Port: Cardinal;
    unix_socket: PChar; clientflag: Cardinal): PMYSQL;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_close = procedure(Handle: PMYSQL);
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_query = function(Handle: PMYSQL; const Query: PChar): Integer;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_real_query = function(Handle: PMYSQL; const Query: PChar;
    len: Integer): Integer;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_select_db = function(Handle: PMYSQL; const Db: PChar): Integer;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_create_db = function(Handle: PMYSQL; const Db: PChar): Integer;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_drop_db = function(Handle: PMYSQL; const Db: PChar): Integer;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_shutdown = function(Handle: PMYSQL): Integer;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_refresh = function(Handle: PMYSQL; Options: Cardinal): Integer;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_kill = function(Handle: PMYSQL; Pid: longint): Integer;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_ping = function(Handle: PMYSQL): Integer;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_stat = function(Handle: PMYSQL): PChar;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_options = function(Handle: PMYSQL; Option: mysql_option;
    const Arg: PChar): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_escape_string = function(PTo, PFrom: PChar; Len: Cardinal): Cardinal;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_get_server_info = function(Handle: PMYSQL): PChar;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_get_client_info = function: PChar;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_get_host_info = function(Handle: PMYSQL): PChar;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_get_proto_info = function(Handle: PMYSQL): Cardinal;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_list_dbs = function(Handle: PMYSQL; Wild: PChar): PMYSQL_RES;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_list_tables = function(Handle: PMYSQL; const Wild: PChar): PMYSQL_RES;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_list_fields = function(Handle: PMYSQL; const Table, Wild: PChar):
    PMYSQL_RES; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_list_processes = function(Handle: PMYSQL): PMYSQL_RES;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_store_result = function(Handle: PMYSQL): PMYSQL_RES;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_use_result = function(Handle: PMYSQL): PMYSQL_RES;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_free_result = procedure(Result: PMYSQL_RES);
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_fetch_row = function(Result: PMYSQL_RES): PMYSQL_ROW;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_fetch_lengths = function(Result: PMYSQL_RES): PLongInt;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_fetch_field = function(Result: PMYSQL_RES): PMYSQL_FIELD;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

{$IFNDEF OLD_LIBMYSQL_DLL}
  Tmysql_data_seek = procedure(Result: PMYSQL_RES; Offset: TInt64);
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
{$ELSE}
  Tmysql_data_seek = procedure(Result: PMYSQL_RES; Offset: Cardinal);
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
{$ENDIF}

  Tmysql_row_seek = function(Result: PMYSQL_RES; Row: MYSQL_ROW_OFFSET):
    MYSQL_ROW_OFFSET; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_field_seek = function(Result: PMYSQL_RES; Offset: mysql_field_offset):
    mysql_field_offset; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_thread_id = function(Handle: PMYSQL): cardinal;
    {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  //EOZeos

  //Functions added by ArTee@dubaron.com:
  Tmysql_insert_id = function(Handle: PMYSQL):Int64;          {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  Tmysql_fetch_fields = function(Result: PMYSQL_RES):PMYSQL_FIELDS; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
  Tmysql_num_fields = function(Result: PMYSQL_RES):Integer;   {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  //returns a boolean value indicating weather mysql was compiled thread-safe
  TMySQL_thread_safe = function: Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  //argc = parameter count
  //argv = array of PChar (ending in nil) to options
  //groups =
  //just call with mysql_server_init (0,nil,nil) for default options.
  //returns 0 for ok, 1 for not ok.
  TMySQL_server_init =
    function (argc: Integer; argv: PChar; groups: PChar): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  TMySQL_server_end =
    procedure; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  TMySQL_thread_init =
    function: Integer; {MY_BOOL} {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  TMySQL_thread_end =
    procedure {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  // Functions added by Trustmaster
  Tmysql_num_rows =
    function (Result: PMYSQL_RES): Int64; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_eof =
    function (Result: PMYSQL_RES): Integer; {MY_BOOL} {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_field_count =
    function (Handle: PMYSQL): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
		
  Tmysql_affected_rows =
    function (Handle: PMYSQL): Int64; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
		
  Tmysql_errno =
    function (Handle: PMYSQL): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};
		
  Tmysql_error =
    function (Handle: PMYSQL): PChar; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_info =
    function (Handle: PMYSQL): PChar; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_character_set_name =
    function (Handle: PMYSQL): PChar; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_change_user =
    function (Handle: PMYSQL; const User, Passwd, Db: PChar): Integer; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

  Tmysql_real_escape_string =
    function(Handle: PMYSQL; PTo, PFrom: PChar; Len: Cardinal): Cardinal; {$IFDEF MSWINDOWS}stdcall{$ELSE}cdecl{$ENDIF};

// The function variables:
  TMySQLFunctions = record
    mysql_debug:          Tmysql_debug;
    mysql_dump_debug_info: Tmysql_dump_debug_info;
    mysql_init:           Tmysql_init;
    mysql_connect:        Tmysql_connect;
    mysql_real_connect:   Tmysql_real_connect;
    mysql_close:          Tmysql_close;
    mysql_select_db:      Tmysql_select_db;
    mysql_create_db:      Tmysql_create_db;
    mysql_drop_db:        Tmysql_drop_db;
    mysql_query:          Tmysql_query;
    mysql_real_query:     Tmysql_query;
    mysql_shutdown:       Tmysql_shutdown;
    mysql_refresh:        Tmysql_refresh;
    mysql_kill:           Tmysql_kill;
    mysql_ping:           Tmysql_ping;
    mysql_stat:           Tmysql_stat;
    mysql_options:        Tmysql_options;
    mysql_escape_string:  Tmysql_escape_string;
    mysql_get_server_info: Tmysql_get_server_info;
    mysql_get_client_info: Tmysql_get_client_info;
    mysql_get_host_info:  Tmysql_get_host_info;
    mysql_get_proto_info: Tmysql_get_proto_info;
    mysql_list_dbs:       Tmysql_list_dbs;
    mysql_list_tables:    Tmysql_list_tables;
    mysql_list_fields:    Tmysql_list_fields;
    mysql_list_processes: Tmysql_list_processes;
    mysql_data_seek:      Tmysql_data_seek;
    mysql_row_seek:       Tmysql_row_seek;
    mysql_field_seek:     Tmysql_field_seek;
    mysql_fetch_row:      Tmysql_fetch_row;
    mysql_fetch_lengths:  Tmysql_fetch_lengths;
    mysql_fetch_field:    Tmysql_fetch_field;
    mysql_store_result:   Tmysql_store_result;
    mysql_use_result:     Tmysql_use_result;
    mysql_free_result:    Tmysql_free_result;
    mysql_thread_id:      Tmysql_thread_id;
    //EOZEOS

    //Rene
    mysql_insert_id:      Tmysql_insert_id;
    mysql_fetch_fields:   Tmysql_fetch_fields;
    mysql_num_fields:     Tmysql_num_fields;

    //Embedded functions

    mysql_server_init:    TMySQL_server_init;
    mysql_server_end:     TMySQL_server_end;
    mysql_thread_init:    TMySQL_thread_init;
    mysql_thread_end:     TMySQL_thread_end;

    //Trustmaster
    mysql_num_rows:	Tmysql_num_rows;
    mysql_eof:		Tmysql_eof;
    mysql_field_count:	Tmysql_field_count;
    mysql_affected_rows:	Tmysql_affected_rows;
    mysql_errno:		Tmysql_errno;
    mysql_error:		Tmysql_error;
    mysql_info:		Tmysql_info;
    mysql_character_set_name: Tmysql_character_set_name;
    mysql_change_user:	 Tmysql_change_user;
    mysql_real_escape_string: Tmysql_real_escape_string;
  end;

function MySqlLoadLib (var MyFunc: TMySQLFunctions; var LibraryPath: String; Embedded: Boolean = False): Boolean;

var
     DLL: string;
     DLL_CLIENT: String = DEFAULT_DLL_LOCATION;
     DLL_EMBEDDED: String  = MYSQLD_DLL_LOCATION;

var  hDLL: {$IFDEF FPC}TLibHandle = 0;{$ELSE}THandle = 0;{$ENDIF} //tmp
     hDLLClient: {$IFDEF FPC}TLibHandle = 0;{$ELSE}THandle = 0;{$ENDIF}
     hDLLEmbedded: {$IFDEF FPC}TLibHandle = 0;{$ELSE}THandle = 0;{$ENDIF}
     ClientLoaded: Boolean = False;
     EmbeddedLoaded: Boolean = False;

implementation

{$IFDEF FPC}
//Redeclare the GetProcAddr function
{
function GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC;
begin
  Result := GetProcedureAddress(H, P);
end;
}
{$ENDIF}

var myprocs, myprocse: TMySQLFunctions;
    freeserver: Boolean = False;


// Initialize MySQL dynamic library
function MySqlLoadLib (var MyFunc: TMySQLFunctions; var LibraryPath: String; Embedded: Boolean = False): Boolean;
var LibLoaded: Boolean;
begin
  //Result := False;
  if Embedded then
    begin
      hDLL := hDLLEmbedded;
      DLL := DLL_EMBEDDED;
    end
  else
    begin
      hDLL := hDLLClient;
      DLL := DLL_CLIENT;
    end;

  if LibraryPath <> '' then
    DLL := LibraryPath
  else
    LibraryPath := DLL;

  if hDLL = 0 then
  begin
    //check if library exists
    {$IFNDEF FPC}
    hDLL := GetModuleHandle(PChar(DLL));
    {$ENDIF}
    if hDLL = 0 then
      LibLoaded := False
    else LibLoaded := True;
    if not LibLoaded then
    begin //Now retry with other API
      hDLL := {$IFNDEF FPC}LoadLibrary(PChar(DLL)){$ELSE}LoadLibrary(DLL){$ENDIF};
      {$IFNDEF MSWINDOWS}
         // try version specific library, some distribution do not provide the generic link
         {$IFDEF MYSQL4}
         if hDLL = 0 then
            hDLL := {$IFNDEF FPC}LoadLibrary(PChar(DLL+'.14')){$ELSE}LoadLibrary(DLL+'.14'){$ENDIF}; // mysql 4.1, 5.0
         if hDLL = 0 then
            hDLL := {$IFNDEF FPC}LoadLibrary(PChar(DLL+'.12')){$ELSE}LoadLibrary(DLL+'.12'){$ENDIF}; // mysql 4.0
         {$ELSE}
         if hDLL = 0 then
            hDLL := {$IFNDEF FPC}LoadLibrary(PChar(DLL+'.10')){$ELSE}LoadLibrary(DLL+'.10'){$ENDIF}; // mysql 3.23
         {$ENDIF}
      {$ENDIF}
      if hDLL <> 0 then
        LibLoaded := True;
    end;
    Result := LibLoaded;
    if Embedded then
      begin
        EmbeddedLoaded := Result;
        hDLLEmbedded := hDLL;
      end
    else
      begin
        ClientLoaded := Result;
        hDLLClient := hDLL;
      end;
  end;

  if hDLL <> 0 then
    with MyFunc do
      begin
        mysql_server_init := nil;
        // FPC GetProc Syntax differs a bit:
        {$IFNDEF FPC}
        @mysql_debug           := GetProcAddress(hDLL,'mysql_debug');
        @mysql_dump_debug_info := GetProcAddress(hDLL,'mysql_dump_debug_info');
        @mysql_init            := GetProcAddress(hDLL,'mysql_init');
        @mysql_connect         := GetProcAddress(hDLL,'mysql_connect');
        @mysql_real_connect    := GetProcAddress(hDLL,'mysql_real_connect');
        @mysql_close           := GetProcAddress(hDLL,'mysql_close');
        @mysql_select_db       := GetProcAddress(hDLL,'mysql_select_db');
        @mysql_create_db       := GetProcAddress(hDLL,'mysql_create_db');
        @mysql_drop_db         := GetProcAddress(hDLL,'mysql_drop_db');
        @mysql_query           := GetProcAddress(hDLL,'mysql_query');
        @mysql_real_query      := GetProcAddress(hDLL,'mysql_real_query');
        @mysql_shutdown        := GetProcAddress(hDLL,'mysql_shutdown');
        @mysql_refresh         := GetProcAddress(hDLL,'mysql_refresh');
        @mysql_kill            := GetProcAddress(hDLL,'mysql_kill');
        @mysql_ping            := GetProcAddress(hDLL,'mysql_ping');
        @mysql_stat            := GetProcAddress(hDLL,'mysql_stat');
        @mysql_options         := GetProcAddress(hDLL,'mysql_options');
        @mysql_escape_string   := GetProcAddress(hDLL,'mysql_escape_string');
        @mysql_get_server_info := GetProcAddress(hDLL,'mysql_get_server_info');
        @mysql_get_client_info := GetProcAddress(hDLL,'mysql_get_client_info');
        @mysql_get_host_info   := GetProcAddress(hDLL,'mysql_get_host_info');
        @mysql_get_proto_info  := GetProcAddress(hDLL,'mysql_get_proto_info');
        @mysql_list_fields     := GetProcAddress(hDLL,'mysql_list_fields');
        @mysql_list_processes  := GetProcAddress(hDLL,'mysql_list_processes');
        @mysql_list_dbs        := GetProcAddress(hDLL,'mysql_list_dbs');
        @mysql_list_tables     := GetProcAddress(hDLL,'mysql_list_tables');
        @mysql_data_seek       := GetProcAddress(hDLL,'mysql_data_seek');
        @mysql_row_seek        := GetProcAddress(hDLL,'mysql_row_seek');
        @mysql_field_seek      := GetProcAddress(hDLL,'mysql_field_seek');
        @mysql_fetch_row       := GetProcAddress(hDLL,'mysql_fetch_row');
        @mysql_fetch_lengths   := GetProcAddress(hDLL,'mysql_fetch_lengths');
        @mysql_fetch_field     := GetProcAddress(hDLL,'mysql_fetch_field');
        @mysql_use_result      := GetProcAddress(hDLL,'mysql_use_result');
        @mysql_store_result    := GetProcAddress(hDLL,'mysql_store_result');
        @mysql_free_result     := GetProcAddress(hDLL,'mysql_free_result');
        @mysql_thread_id       := GetProcAddress(hDLL,'mysql_thread_id');

        //Added by rene:
        @mysql_insert_id       := GetProcAddress(hDLL, 'mysql_insert_id');
        @mysql_fetch_fields    := GetProcAddress(hDLL, 'mysql_fetch_fields');
        @mysql_num_fields      := GetProcAddress(hDLL, 'mysql_num_fields');

        //Added by Trustmaster
        @mysql_num_rows	     := GetProcAddress(hDLL, 'mysql_num_rows');
        @mysql_eof						:= GetProcAddress(hDLL, 'mysql_eof');
        @mysql_field_count     := GetProcAddress(hDLL, 'mysql_field_count');
        @mysql_affected_rows   := GetProcAddress(hDLL, 'mysql_affected_rows');
        @mysql_errno	     := GetProcAddress(hDLL, 'mysql_errno');
        @mysql_error	     := GetProcAddress(hDLL, 'mysql_error');
        @mysql_info	     := GetProcAddress(hDLL, 'mysql_info');
        @mysql_character_set_name	:= GetProcAddress(hDLL, 'mysql_character_set_name');
        @mysql_change_user     := GetProcAddress(hDLL, 'mysql_change_user');
        @mysql_real_escape_string	:= GetProcAddress(hDLL, 'mysql_real_escape_string');

        //Embedded types
//        if Embedded then
        //do always, mysql 4.1+ (4.0+??) know these functions. just call them.
          begin
            @mysql_server_init := GetProcAddress(hDLL, 'mysql_server_init');
            @mysql_server_end  := GetProcAddress(hDLL, 'mysql_server_end');
            @mysql_thread_init := GetProcAddress(hDLL, 'mysql_thread_init');
            @mysql_thread_end  := GetProcAddress(hDLL, 'mysql_thread_end');
          end;
  {$ELSE}
        @mysql_debug           := GetProcedureAddress(hDLL,'mysql_debug');
        @mysql_dump_debug_info := GetProcedureAddress(hDLL,'mysql_dump_debug_info');
        @mysql_init            := GetProcedureAddress(hDLL,'mysql_init');
        @mysql_connect         := GetProcedureAddress(hDLL,'mysql_connect');
        @mysql_real_connect    := GetProcedureAddress(hDLL,'mysql_real_connect');
        @mysql_close           := GetProcedureAddress(hDLL,'mysql_close');
        @mysql_select_db       := GetProcedureAddress(hDLL,'mysql_select_db');
        @mysql_create_db       := GetProcedureAddress(hDLL,'mysql_create_db');
        @mysql_drop_db         := GetProcedureAddress(hDLL,'mysql_drop_db');
        @mysql_query           := GetProcedureAddress(hDLL,'mysql_query');
        @mysql_real_query      := GetProcedureAddress(hDLL,'mysql_real_query');
        @mysql_shutdown        := GetProcedureAddress(hDLL,'mysql_shutdown');
        @mysql_refresh         := GetProcedureAddress(hDLL,'mysql_refresh');
        @mysql_kill            := GetProcedureAddress(hDLL,'mysql_kill');
        @mysql_ping            := GetProcedureAddress(hDLL,'mysql_ping');
        @mysql_stat            := GetProcedureAddress(hDLL,'mysql_stat');
        @mysql_options         := GetProcedureAddress(hDLL,'mysql_options');
        @mysql_escape_string   := GetProcedureAddress(hDLL,'mysql_escape_string');
        @mysql_get_server_info := GetProcedureAddress(hDLL,'mysql_get_server_info');
        @mysql_get_client_info := GetProcedureAddress(hDLL,'mysql_get_client_info');
        @mysql_get_host_info   := GetProcedureAddress(hDLL,'mysql_get_host_info');
        @mysql_get_proto_info  := GetProcedureAddress(hDLL,'mysql_get_proto_info');
        @mysql_list_fields     := GetProcedureAddress(hDLL,'mysql_list_fields');
        @mysql_list_processes  := GetProcedureAddress(hDLL,'mysql_list_processes');
        @mysql_list_dbs        := GetProcedureAddress(hDLL,'mysql_list_dbs');
        @mysql_list_tables     := GetProcedureAddress(hDLL,'mysql_list_tables');
        @mysql_data_seek       := GetProcedureAddress(hDLL,'mysql_data_seek');
        @mysql_row_seek        := GetProcedureAddress(hDLL,'mysql_row_seek');
        @mysql_field_seek      := GetProcedureAddress(hDLL,'mysql_field_seek');
        @mysql_fetch_row       := GetProcedureAddress(hDLL,'mysql_fetch_row');
        @mysql_fetch_lengths   := GetProcedureAddress(hDLL,'mysql_fetch_lengths');
        @mysql_fetch_field     := GetProcedureAddress(hDLL,'mysql_fetch_field');
        @mysql_use_result      := GetProcedureAddress(hDLL,'mysql_use_result');
        @mysql_store_result    := GetProcedureAddress(hDLL,'mysql_store_result');
        @mysql_free_result     := GetProcedureAddress(hDLL,'mysql_free_result');
        @mysql_thread_id       := GetProcedureAddress(hDLL,'mysql_thread_id');

        //Added by rene:
        @mysql_insert_id       := GetProcedureAddress(hDLL, 'mysql_insert_id');
        @mysql_fetch_fields    := GetProcedureAddress(hDLL, 'mysql_fetch_fields');
        @mysql_num_fields      := GetProcedureAddress(hDLL, 'mysql_num_fields');
			
        //Added by Trustmaster
        @mysql_num_rows	     := GetProcedureAddress(hDLL, 'mysql_num_rows');
        @mysql_eof	     := GetProcedureAddress(hDLL, 'mysql_eof');
        @mysql_field_count     := GetProcedureAddress(hDLL, 'mysql_field_count');
        @mysql_affected_rows   := GetProcedureAddress(hDLL, 'mysql_affected_rows');
        @mysql_errno	     := GetProcedureAddress(hDLL, 'mysql_errno');
        @mysql_error	     := GetProcedureAddress(hDLL, 'mysql_error');
        @mysql_info	     := GetProcedureAddress(hDLL, 'mysql_info');
        @mysql_character_set_name := GetProcedureAddress(hDLL, 'mysql_character_set_name');
        @mysql_change_user     := GetProcedureAddress(hDLL, 'mysql_change_user');
        @mysql_real_escape_string := GetProcedureAddress(hDLL, 'mysql_real_escape_string');

        //Embedded types
//        if Embedded then
          begin
            @mysql_server_init := GetProcedureAddress(hDLL, 'mysql_server_init');
            @mysql_server_end  := GetProcedureAddress(hDLL, 'mysql_server_end');
            @mysql_thread_init := GetProcedureAddress(hDLL, 'mysql_thread_init');
            @mysql_thread_end  := GetProcedureAddress(hDLL, 'mysql_thread_end');

            //also call mysql_server_init with default parameters ?
            // mysql_server_init (0, nil, nil);
            // let component or user do it.
          end;
  {$ENDIF}
      if Assigned (mysql_server_init) then
        try
//          mysql_server_init(0, nil, nil);
          //freeserver := 0 = mysql_server_init (3, @DEFAULT_PARAMS, @SERVER_GROUPS);
        except end;
      Result := True;
    end
  else
    begin
      {$IFDEF WITH_EXCEPTION}
      raise Exception.Create(Format('Library %s not found',[DLL]));
      {$ENDIF}
      Result := False;
    end;
  if Embedded then
    myprocse := myFunc
  else
    myprocs := myFunc;
end;

initialization

finalization
  if (hDLLClient <> 0) and ClientLoaded then
    try
      if Assigned (myprocs.mysql_server_end) then
        try
          myprocs.mysql_server_end;
        except end;
      {$IFNDEF FPC}
      FreeLibrary(hDLLClient)
      {$ELSE}
      UnloadLibrary(hDLLClient)
      {$ENDIF};
    except //should not happen, but if debugging, find out why.
    end;
  if (hDLLEmbedded <> 0) and EmbeddedLoaded then
    try
      //embedded mysql has unloading issues//
      //temporary fix: just don't unload (...)
      if Assigned (myprocse.mysql_server_end) and freeserver then
        try
          //embeddded mysql 4.0 has issues.
          //embedded mysql 4.1 seems to work just fine.
          myprocse.mysql_server_end;

        except end;
      {$IFNDEF FPC}
      FreeLibrary(hDLLEmbedded);
      {$ELSE}
      UnloadLibrary(hDLLEmbedded)
      {$ENDIF}
    except //should not happen, but if debugging, find out why.
    end;

end.
