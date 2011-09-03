unit sqlcomponentsK3;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses Classes, passql, pasmysql, passqlite, pasodbc;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('libsql', [TMyDB, TLiteDB, TODBCDB]);
end;


end.
