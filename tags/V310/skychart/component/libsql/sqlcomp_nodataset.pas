unit sqlcomponents;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses Classes, passql, pasmysql, passqlite, pasthreadedsqlite, pasodbc, pasjansql, lsdatasetbase, lsdatasetquery, lsdatasettable;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('libsql', [TMyDB, TLiteDB, TODBCDB, TJanDB, TMLiteDB]);
end;


end.
