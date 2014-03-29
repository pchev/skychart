unit sqlcomponents;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses Classes, passql, pasmysql, passqlite, pasthreadedsqlite {$IFNDEF WINCE}{$IFNDEF WIN64}, pasodbc{$ENDIF}{$ENDIF} {$IFNDEF FPC}{$IFNDEF UNIX}, pasjansql, lsdatasetbase, lsdatasetquery, lsdatasettable{$ENDIF}{$ENDIF};

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('libsql', [TMyDB, TLiteDB, {$IFNDEF WINCE}{$IFNDEF WIN64}TODBCDB,{$ENDIF}{$ENDIF} {$IFNDEF FPC}{$IFNDEF UNIX}TJanDB, TlsTable, TlsQuery,{$ENDIF}{$ENDIF} TMLiteDB]);
end;


end.
