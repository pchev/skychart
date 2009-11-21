unit sqlsupport;

{$IFDEF FPC}
{$MODE Delphi}
{$H+}
{$ELSE}
  {$IFNDEF LINUX}
  {$DEFINE WIN32}
  {$ENDIF}
{$ENDIF}

interface

uses {$IFDEF MSWINDOWS}Windows, {$ENDIF} Classes, SysUtils{, DateUtils}{, System};
//{$IFDEF FPC}, LCLIntf{$ENDIF};

type
  TDBMajorType = (dbANSI, dbMySQL, dbSQLite, dbODBC, dbJanSQL);
  TDBSubType = (dbDefault, dbSqlite2, dbSqlite3, dbSqlite3W, dbODBC32);

const

  DblQuote: Char    = '"';
  SngQuote: Char    = #39;
  Crlf: String      = #13#10;
  Tab: Char         = #9;

  function FloatToMySQL (Value:Extended):String;
  function DateTimeToMySQL (Value:TDateTime):String;
  function MySQLToDateTime (Value:String):TDateTime;

  function Pas2SQLiteStr(const PasString: string): string;
  function SQLite2PasStr(const SQLString: string): string;
  function AddQuote(const s: string; QuoteChar: Char = #39): string;
  function AddQuoteW(const s: WideString; QuoteChar: WideChar = #39): WideString;

  function UnQuote(const s: string; QuoteChar: Char = #39): string;
  function UnQuoteW(const s: WideString; QuoteChar: WideChar = #39): WideString;

  function SystemErrorMsg(ErrNo: Integer = -1): String;
  function Escape(Value: String): String;
  function UnEscape(Value: String): String;
  function EscapeW(Value: WideString): WideString;
  function UnEscapeW(Value: WideString): WideString;

  function QuoteEscape (Value:String; qt:TDBMajorType):String;
  function QuoteEscapeW (Value:WideString; qt:TDBMajorType):WideString;

  //This is availabse from delhi 7 and up in unit strutils.
  function PosEx (const SubStr, S: string; Offset: Cardinal = 1): Integer;


implementation

//Support functions
function FloatToMySQL (Value:Extended):String;
begin
  Result := StringReplace(FloatToStr(Value), ',', '.', []);
end;

function DateTimeToMySQL (Value:TDateTime):String;
begin
  Result := FormatDateTime ('yyyymmddhhnnss', Value);
end;

function MySQLToDateTime (Value:String):TDateTime;
var ayear, amonth, aday, ahour, aminute, asecond, amillisecond: Word;
begin
  ayear := StrToIntDef (copy (value, 1, 4), 0);
  amonth := StrToIntDef (copy (value, 5, 2), 0);
  aday := StrToIntDef (copy (value, 7,2), 0);
  ahour := StrToIntDef (copy (value, 9, 2), 0);
  aminute := StrToIntDef (copy (value, 11, 2), 0);
  asecond := StrToIntDef (copy (value, 13, 2), 0);
  amillisecond := 0;
  //Result := EncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
  //backward compatability
  Result := EncodeDate (AYear, AMonth, ADay) + EncodeTime (AHour, AMinute, ASecond, AMillisecond);
end;



function Pas2SQLiteStr(const PasString: string): string;
var
  n: integer;
begin
  Result := SQLite2PasStr(PasString);
  n := Length(Result);
  while n > 0 do
  begin
    if Result[n] = SngQuote then
      Insert(SngQuote, Result, n);
    dec(n);
  end;
  Result := AddQuote(Result);
end;

function SQLite2PasStr(const SQLString: string): string;
const
  DblSngQuote: String = #39#39;
var
  p: integer;
begin
  Result := SQLString;
  p := pos(DblSngQuote, Result);
  while p > 0 do
  begin
    Delete(Result, p, 1);
    p := pos(DblSngQuote, Result);
  end;
  Result := UnQuote(Result);
end;

function SystemErrorMsg(ErrNo: Integer = -1): String;
{$IFDEF MSWINDOWS}
var
  buf: PChar;
  size: Integer;
  MsgLen: Integer;
  {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  size := 256;
  GetMem(buf, size);
  If ErrNo = - 1 then
    ErrNo := GetLastError;
  MsgLen := FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, ErrNo, 0, buf, size, nil);
  if MsgLen = 0 then
    Result := 'ERROR'
  else
    Result := buf;
  {$ELSE}
  Result := ''; //unknown
  {$ENDIF}
end;


function AddQuote(const s: string; QuoteChar: Char = #39): string;
begin
  Result := Concat(QuoteChar, s, QuoteChar);
end;

function AddQuoteW(const s: WideString; QuoteChar: WideChar = #39): WideString;
begin
  Result := QuoteChar + s + QuoteChar;
end;

function UnQuote(const s: string; QuoteChar: Char = #39): String;
begin
  Result := s;
  if length(Result) > 1 then
  begin
    if Result[1] = QuoteChar then
      Delete(Result, 1, 1);
    if Result[Length(Result)] = QuoteChar then
      Delete(Result, Length(Result), 1);
  end;
end;

function UnQuoteW(const s: WideString; QuoteChar: WideChar = #39): WideString;
begin
  Result := s;
  if length(Result) > 1 then
  begin
    //this is quite a problem..
    if Result[1] = QuoteChar then
      Delete(Result, 1, 1);
    if Result[Length(Result)] = QuoteChar then
      Delete(Result, Length(Result), 1);
  end;
end;



function Escape(Value: String): String;
var i:Integer;
begin
  for i:=length (Value) downto 1 do
    if Value[i] in ['\', '''', '"', #0, #$14] then
      begin
        if Value[i]=#0 then
          Value[i]:='0';
        //optionally tabs, backspaces, nl etc:
        //if Value[i]=#9 then
        //Value[i]='t';
        //etc

        Insert ('\', Value, i);
      end;
  Result := Value;
end;

function UnEscape(Value: String): String;
var i:Integer;
begin
  for i:=1 to length(Value)-1 do
    if Value[i]='\' then
      begin
        if Value[i+1]='0' then
          Value[i+1]:=#0;
        Delete (Value,i,1);
      end;
  Result := Value;
end;

function EscapeW(Value: WideString): WideString;
var i:Integer;
begin
  for i:=length (Value) downto 1 do
    if Char(Value[i]) in ['\', '''', '"', #0] then
      begin
        if Value[i]=#0 then
          Value[i]:='0';
        //optionally tabs, backspaces, nl etc:
        //if Value[i]=#9 then
        //Value[i]='t';
        //etc

        Insert ('\', Value, i);
      end;
  Result := Value;
end;

function EscapeSqLiteW(Value: WideString): WideString;
var i:Integer;
begin
  for i:=length (Value) downto 1 do
    if Char(Value[i]) in ['\', '''', #0] then
      begin
        if Value[i]=#0 then begin
          Value[i]:='0';
          Insert ('\', Value, i);
        end
        else if Value[i]='\' then begin
          Insert ('\', Value, i);
        end
        else if Value[i]='''' then begin
          Insert ('''', Value, i);
        end;
      end;
  Result := Value;
end;

function UnEscapeW(Value: WideString): WideString;
var i:Integer;
begin
  for i:=1 to length(Value)-1 do
    if Value[i]='\' then
      begin
        if Value[i+1]='0' then
          Value[i+1]:=#0;
        Delete (Value,i,1);
      end;
  Result := Value;
end;


function QuoteEscape (Value:String; qt:TDBMajorType):String;
begin
  case qt of
    dbAnsi, dbMySQL :
      begin
        //mysql finds escaping with backslash sufficient to ignore the next quote
        Value := AddQuote(Escape (Value));
      end;
    dbSQLite, dbODBC :
      begin
        //escape binary chars
        Value := Escape (Value);
        //replace string quotes with double quotes - sqlite needs this apperently
        Value := StringReplace (Value, '''', '''''', [rfReplaceAll]);
        Value := AddQuote (Value);
      end;
  end;
  Result := Value;
end;

function QuoteEscapeW (Value:WideString; qt:TDBMajorType):WideString;
begin
  case qt of
    dbMySQL :
      begin
        //mysql finds escaping with backslash sufficient to ignore the next quote
        Value := AddQuote(Escape (Value));
      end;
    dbSQLite :
      begin
        //escape binary chars
        Value := EscapeSqLiteW (Value);
        Value := AddQuoteW (Value);
      end;
  end;
  Result := Value;
end;

function PosEx (const SubStr, S: string; Offset: Cardinal = 1): Integer;
var i: Integer;
begin
  //by way not the fastest method!
  i := Pos (Substr, copy (S, offset, maxint));
  if i<=0 then
    Result := 0
  else
    Result := i + Offset - 1;
end;


end.
