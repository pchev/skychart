unit pasmysqld;

//Please note:
//Currently TMyDB and TMyEmbeddedDB cannot be used at the same time

{$IFDEF FPC}
{$MODE Delphi}
{$H+}
{ELSE}
  {$IFNDEF LINUX}
  {$DEFINE WIN32}
  {$ENDIF}
{$ENDIF}

interface

uses Classes, SysUtils, passql, pasmysql, libmysql{d};

type
  TMyEmbeddedDB = class (TMyDB)
  public
    constructor Create (AOwner:TComponent); override;
    destructor Destroy; override;
    function Connect (Options:TStrings=nil; DataBase:String=''):Boolean;
    procedure Close; override;

    //circumvent some bugs in embedded mysql 4.0.20
    function CreateDatabase(Database:String):Boolean; override;
  end;

implementation

constructor TMyEmbeddedDB.Create(AOwner: TComponent);
begin
  inherited;
  FLibrary := MYSQLD_DLL_LOCATION;
end;

destructor TMyEmbeddedDB.Destroy;
begin
  if FActive then
    close;
end;


procedure TMyEmbeddedDB.Close;
begin
{ //mysqld.dll has bugs, especially on windows.
  //fix: just don't unload (...)
}
  if FActive then
    try
      mf.mysql_thread_end;
    except end;
  FActive := False;
  inherited;
end;

function TMyEmbeddedDB.Connect(Options: TStrings;
  DataBase: String): Boolean;
var a: Integer;
    b,c:String;
begin
  Result := False;
  //Allow user to change shared library
//  if FLibrary<>'' then
//    DLL_Embedded :=FLibrary;

  //this is critical, so check for it.
  //embedded mysql will _not_ work without it
  //in fact, it will start generating exceptions.

  {$IFDEF WIN32}
  if not fileexists ('c:\my.cnf') then
    //for some reason or another, %sysdir%\mysql.ini is not sufficient
    begin
      FCurrentSet.FLastError := -1;
      FCurrentSet.FLastErrorText := 'File c:\my.cnf does not exist';
      exit;
    end;
  {$ENDIF}


  if (hDLLEmbedded=0) then
    begin
      if not MySQLLoadLib(mf, True) then
        exit;
      FDLLLoaded := True;
      //apperantly this was the first time, call server init
      a :=2;
      b :=#0#0;
      c := #0#0;
      if Assigned (mf.mysql_server_init) then
        Result := 0 = mf.mysql_server_init (3, @DEFAULT_PARAMS, @SERVER_GROUPS)
      else
        exit;
    end
  else
    begin
      FDllLoaded := True;
      Result := True;
    end;

  if not Result then
    exit;

  //Succesfully loaded
  FActive := False;

  if assigned(mf.mysql_thread_init) then
    FActive := mf.mysql_thread_init = 0;
  if not FActive then
    exit;

  FDataBase := DataBase;

  {
  if assigned (mysql_init) then
    FActive := nil <> mysql_init (nil);
  if not FActive then
    exit;
  }
//  mysql_options(PMyHandle, MYSQL_READ_DEFAULT_GROUP, PChar('test_libmysqld_CLIENT'));
//  move (PMyHandle^, MyHandle, SizeOf(MyHandle));
// fpr some reason or another mysql_real_connect won't work.
//  PMyHandle := mysql_real_connect (@MyHandle, nil, nil, nil, PChar(FDataBase), 0, nil, 0);
  mf.mysql_connect (@MyHandle, nil, nil, nil);
  PMyHandle := @MyHandle;
  if FActive and (FDataBase<>'') then
    mf.mysql_select_db(PMyHandle, PChar(FDataBase));

  Result := FActive;

  if FActive and not (csDesigning in ComponentState) then
    begin
      //Fill in some variables:
      try
      if Assigned (mf.mysql_get_server_info) then
        FVersion := mf.mysql_get_server_info (PMyHandle);
      if Assigned (mf.mysql_character_set_name) then
        FEncoding := mf.mysql_character_set_name(PMyHandle);
      if Assigned (mf.mysql_get_host_info) then
        FHostInfo := mf.mysql_get_host_info (PMyHandle);
      if Assigned (mf.mysql_get_proto_info) then
        FInfo := IntToStr (mf.mysql_get_proto_info (PMyHandle));
      if Assigned (mf.mysql_get_client_info) then
        FClientVersion := mf.mysql_get_client_info;
      except
        //Wrong DLL ?. Adjust compiler switches of unit MyDB. :(
      end;
    end;

  if FActive and Assigned(FOnOpen) then
    FOnOpen(Self);
end;

function TMyEmbeddedDB.CreateDatabase(Database: String): Boolean;
begin
//  Result := inherited CreateDatabase (DataBase);
  FormatQuery ('create database %u', [database]);
  Result := FCurrentSet.FHasResult;
end;

end.
