unit sqlcomponents;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses Classes, passql, pasmysql, passqlite, pasthreadedsqlite, pasodbc {$IFNDEF UNIX}, pasjansql, lsdatasetbase, lsdatasetquery, lsdatasettable{$ENDIF};

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('libsql', [TMyDB, TLiteDB, TODBCDB, {$IFNDEF UNIX}TJanDB, TlsTable, TlsQuery,{$ENDIF} TMLiteDB]);
end;


end.
