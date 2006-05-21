{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: janSQLTokenizer.pas, released March 24, 2002.

The Initial Developer of the Original Code is Jan Verhoeven
(jan1.verhoeven@wxs.nl or http://jansfreeware.com).
Portions created by Jan Verhoeven are Copyright (C) 2002 Jan Verhoeven.
All Rights Reserved.

Contributor(s): ___________________.

Last Modified: 25-mar-2002
Current Version: 1.1

Notes: This is a SQL oriented tokenizer.

Known Issues:


History:
  1.1 25-mar-2002
      - TRUNC alias for FIX function
      - added FORMAT function
      - added DATE constant
      - added TIME constant
      - added YEAR function
      - added MONTH function
      - added DAY function
      - added DATEADD function
      - added DATEDIFF function
      - added EASTER function
      - added WEEKNUMBER function
      - added ISNUMERIC function      
      - added ISDATE function
  1.0 24-mar-2002 : original release

-----------------------------------------------------------------------------}

unit janSQLTokenizer;

interface

uses
  Classes,SysUtils,janSQLStrings,dialogs;

const
  delimiters=['+','-','*','/',' ','(',')','=','>','<'];
  numberchars=['0'..'9','.'];
  identchars=['a'..'z','A'..'Z','0'..'9','.','_'];
  alphachars=['a'..'z','A'..'Z'];

type

  TSubExpressionEvent=procedure(sender:Tobject;const subexpression:string;var subexpressionValue:variant;var handled:boolean) of object;

  TTokenKind=(tkKeyword,tkOperator, tkOperand, tkOpen, tkClose,
    tkComma,tkHash);


  TTokenOperator=(toNone,toString,toNumber,toVariable,
     toComma,toOpen,toClose,toHash,
     tosqlCount, tosqlSum, tosqlAvg, tosqlMAX, tosqlMIN, tosqlStdDev,
     toEq,toNe,toGt,toGe,toLt,toLe,
     toAdd,toSubtract,toMultiply,toDivide,
     toAnd,toOr,toNot,toLike,
     tosqlALTER,tosqlTABLE,tosqlCOLUMN,
     tosqlADD,tosqlDROP,tosqlCOMMIT,tosqlCREATE,
     tosqlDELETE,tosqlFROM,tosqlWHERE,
     tosqlINSERT,tosqlINTO,tosqlVALUES,
     tosqlSELECT,tosqlAS,tosqlORDER,tosqlUPDATE,
     tosqlSET,tosqlCONNECT, tosqlASSIGN,
     tosqlSAVETABLE, tosqlRELEASETABLE,
     tosqlGROUP, tosqlASC, tosqlDESC, tosqlHAVING,
     tosqlIN,
     toLOWER,toUPPER,toTRIM,toSoundex,
     toSin, toCos, toSqr, toSqrt,
     toAsNumber,toLeft, toRight, toMid,
     tosubstr_after, tosubstr_before,
     toFormat,
     toDateAdd,
     toYear, toMonth, toDay, toEaster, toWeekNumber,
     toLen, toFix, toCeil, toFloor,
     toIsNumeric, toIsDate,
     toReplace, tosqlROLLBACK);



  TToken=class(TObject)
  private
    Fname: string;
    Ftokenkind: TTokenKind;
    Foperator: TTokenOperator;
    Fvalue: variant;
    Flevel: integer;
    Fexpression: string;
    procedure Setname(const Value: string);
    procedure Setoperator(const Value: TTokenOperator);
    procedure Settokenkind(const Value: TTokenKind);
    procedure Setvalue(const Value: variant);
    procedure Setlevel(const Value: integer);
    procedure Setexpression(const Value: string);
  public
    function copy:TToken;
    property name:string read Fname write Setname;
    property value:variant read Fvalue write Setvalue;
    property tokenkind:TTokenKind read Ftokenkind write Settokenkind;
    property operator: TTokenOperator read Foperator write Setoperator;
    property level:integer read Flevel write Setlevel;
    property expression:string read Fexpression write Setexpression;
  end;

  TjanSQLTokenizer=class(TObject)
  private
    FSource:string;
    FList:TList;
    idx: integer; // scan index
    SL:integer; // source length
    FToken:string;
    FTokenKind:TTokenKind;
    FTokenValue:variant;
    FTokenOperator:TTokenOperator;
    FTokenLevel:integer;
    FTokenExpression:string;
    FonSubExpression: TSubExpressionEvent;
    procedure AddToken(list:TList);
    function GetToken: boolean;
    function IsKeyWord(value: string): boolean;
    function IsFunction(value: string): boolean;
    function LookAhead(var index:integer):string;
    function getTokenCount: integer;
    function getsubExpression:boolean;
    procedure SetonSubExpression(const Value: TSubExpressionEvent);
  public
    function Tokenize(source:string;list:TList):boolean;
    property TokenCount:integer read getTokenCount;
    property onSubExpression:TSubExpressionEvent read FonSubExpression write SetonSubExpression;
  end;


implementation

const
  cr = chr(13)+chr(10);


{ TjanSQLTokenizer }

function TjanSQLTokenizer.Tokenize(source: string; list: TList): boolean;
begin
  result:=true;
  FSource:=source;
  idx:=1;
  SL:=length(source);
  while getToken do AddToken(list);
end;



procedure TjanSQLTokenizer.AddToken(list:TList);
var
  tok:TToken;
begin
  tok:=TToken.Create;
  tok.name:=FToken;
  tok.tokenkind:=FTokenKind;
  tok.value:=FTokenValue;
  tok.operator:=FTokenOperator;
  tok.level:=FtokenLevel;
  tok.expression:=FTokenExpression;
  List.Add(tok);
end;


function TjanSQLTokenizer.GetToken: boolean;
var
  bot:char;

  function sqldatestring:string;
  var
    ayear,amonth,aday:word;
  begin
    decodedate(now,ayear,amonth,aday);
    result:=format('%.4d',[ayear])+'-'+format('%.2d',[amonth])+'-'+format('%.2d',[aday])
  end;

  function sqltimestring:string;
  var
    ahour,amin,asec,amsec:word;
  begin
    decodetime(time,ahour,amin,asec,amsec);
    result:=format('%.2d',[ahour])+':'+format('%.2d',[amin])+':'+format('%.2d',[asec]);
  end;

begin
  result:=false;
  FToken:='';
  while (idx<=SL) and (FSource[idx]=' ') do inc(idx);
  if idx>SL then exit;
  bot:=FSource[idx]; // begin of token
  if bot='''' then begin  // string
    inc(idx);
    while (idx<=SL) and (FSource[idx]<>'''' ) do begin
      FToken:=FToken+Fsource[idx];
      inc(idx);
    end;
    if idx>SL then exit;
    inc(idx);
    FTokenValue:=FToken;
    FTokenKind:=tkOperand;
    FTokenOperator:=toString;
    result:=true;
  end
  else if bot=',' then begin
    FToken:=FToken+Fsource[idx];
    inc(idx);
    FTokenValue:=FToken;
    FTokenKind:=tkComma;
    FTokenOperator:=toComma;
    result:=true;
  end
  else if bot='#' then begin
    FToken:=FToken+Fsource[idx];
    inc(idx);
    FTokenValue:=FToken;
    FTokenKind:=tkHash;
    FTokenOperator:=toHash;
    result:=true;
  end
  else if bot in ['A'..'Z','a'..'z'] then begin  // identifier
    while (idx<=SL) and (FSource[idx] in identchars) do begin
      FToken:=FToken+Fsource[idx];
      inc(idx);
    end;
    if isKeyword(Ftoken) then begin
      result:=true;
    end
    else if lowercase(FToken)='or' then begin
        FTokenKind:=tkOperator;
        FTokenLevel:=0;
        FTokenOperator:=toOr;
    end
    else if lowercase(FToken)='and' then begin
        FTokenKind:=tkOperator;
        FTokenLevel:=0;
        FTokenOperator:=toAnd;
    end
    else if lowercase(FToken)='pi' then begin
        FTokenKind:=tkOperand;
        FTokenValue:=pi;
        FTokenOperator:=toNumber;
    end
    else if lowercase(FToken)='date' then begin
        FTokenKind:=tkOperand;
        FTokenValue:=sqldatestring;
        FTokenOperator:=tostring;
    end
    else if lowercase(FToken)='time' then begin
        FTokenKind:=tkOperand;
        FTokenValue:=sqltimestring;
        FTokenOperator:=tostring;
    end
    else if ISFunction(lowercase(FToken)) then begin
    end
    else begin
        FTokenKind:=tkOperand;
        FTokenOperator:=toVariable;
    end;
    result:=true;
  end
  else if bot in ['0'..'9'] then begin // number
    while (idx<=SL) and (FSource[idx] in numberchars) do begin
      FToken:=FToken+Fsource[idx];
      inc(idx);
    end;
    FTokenKind:=tkOperand;
    try
      FTokenValue:=strtofloat(FToken);
      FTokenOperator:=toNumber;
    except
      exit;
    end;
    result:=true;
  end
  else if bot='(' then begin
    FToken:='(';
    FTokenKind:=tkOpen;
    FTokenOperator:=toOpen;
    FtokenLevel:=1;
    inc(idx);
    result:=true;
  end
  else if bot=')' then begin
    FToken:=')';
    FTokenKind:=tkClose;
    FTokenOperator:=toClose;
    FtokenLevel:=1;
    inc(idx);
    result:=true;
  end
  else if bot in delimiters then begin
    FToken:=FToken+Fsource[idx];
    inc(idx);
    FTokenKind:=tkOperator;
    case bot of
    '=': begin  FTokenOperator:=toEq;;FTokenLevel:=3;end;
    '+': begin  FTokenOperator:=toAdd;FTokenLevel:=4;end;
    '-': begin  FTokenOperator:=toSubtract;FTokenLevel:=3;end;
    '*': begin  FTokenOperator:=toMultiply;FTokenLevel:=6;end;
    '/': begin  FTokenOperator:=toDivide; FtokenLevel:=5;end;
    '>': begin
           if idx>SL then exit;
           FTokenLevel:=3;
           if FSource[idx]='=' then begin
             FToken:=FToken+Fsource[idx];
             inc(idx);
             FTokenOperator:=toGe;
           end
           else
             FTokenOperator:=toGt
         end;
    '<': begin
           if idx>SL then exit;
           FTokenLevel:=3;
           if FSource[idx]='=' then begin
             FToken:=FToken+Fsource[idx];
             inc(idx);
             FTokenOperator:=toLe;
           end
           else if FSource[idx]='>' then begin
             FToken:=FToken+Fsource[idx];
             inc(idx);
             FTokenOperator:=toNe;
           end
           else
             FTokenOperator:=toLt;
         end;
    end;
    result:=true;
  end
  else
    exit;
end;


function TjanSQLTokenizer.IsFunction(value: string): boolean;
begin
  result:=false;
  if value='sin' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=tosin;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='cos' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=tocos;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='sqr' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=tosqr;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='sqrt' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=tosqrt;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='easter' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toEaster;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='weeknumber' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toWeekNumber;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='year' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toyear;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='month' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=tomonth;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='day' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=today;
    FtokenLevel:=7;
    result:=true;
  end

  else if value='soundex' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toSoundex;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='lower' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toLOWER;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='upper' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toUPPER;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='trim' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toTRIM;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='in' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=tosqlIN;
    FtokenLevel:=7;
    result:=getsubexpression;
  end
  else if value='not' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toNot;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='like' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toLike;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='asnumber' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toAsNumber;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='dateadd' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=todateadd;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='left' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toleft;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='right' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toRight;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='mid' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toMid;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='substr_after' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=tosubstr_after;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='substr_before' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=tosubstr_before;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='format' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toFormat;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='length' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toLen;
    FtokenLevel:=7;
    result:=true;
  end
  else if (value='fix') or (value='trunc') then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toFix;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='ceil' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toCeil;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='floor' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toFloor;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='isnumeric' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toIsNumeric;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='isdate' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toIsDate;
    FtokenLevel:=7;
    result:=true;
  end
  else if value='replace' then begin
    FtokenKind:=tkOperator;
    FTokenOperator:=toReplace;
    FtokenLevel:=7;
    result:=true;
  end

end;

function TjanSQLTokenizer.getTokenCount: integer;
begin
  result:=FList.count;
end;

function TjanSQLTokenizer.IsKeyWord(value: string): boolean;
var
  tmp:string;
  i:integer;
begin
  result:=false;
  tmp:=uppercase(value);
  if tmp='SELECT' then begin
    FTokenOperator:=tosqlSELECT;
    result:=true;
  end
  else if tmp='AS' then begin
    FTokenOperator:=tosqlAS;
    result:=true;
  end
  else if tmp='SAVE' then begin
    if uppercase(lookahead(i))<>'TABLE' then exit;
    FTokenOperator:=tosqlSAVETABLE;
    result:=true;
    idx:=i;
  end
  else if tmp='RELEASE' then begin
    if uppercase(lookahead(i))<>'TABLE' then exit;
    FTokenOperator:=tosqlRELEASETABLE;
    result:=true;
    idx:=i;
  end
  else if tmp='ASSIGN' then begin
    if uppercase(lookahead(i))<>'TO' then exit;
    FTokenOperator:=tosqlASSIGN;
    result:=true;
    idx:=i;
  end
  else if tmp='UPDATE' then begin
    FTokenOperator:=tosqlUPDATE;
    result:=true;
  end
  else if tmp='INSERT' then begin
    FTokenOperator:=tosqlINSERT;
    result:=true;
  end
  else if tmp='INTO' then begin
    FTokenOperator:=tosqlINTO;
    result:=true;
  end
  else if tmp='DELETE' then begin
    FTokenOperator:=tosqlDELETE;
    result:=true;
  end
  else if tmp='CONNECT' then begin
    if uppercase(lookahead(i))<>'TO' then exit;
    FTokenOperator:=tosqlCONNECT;
    result:=true;
    idx:=i;
  end
  else if tmp='COMMIT' then begin
    FTokenOperator:=tosqlCOMMIT;
    result:=true;
  end
  else if tmp='ROLLBACK' then begin
    FTokenOperator:=tosqlROLLBACK;
    result:=true;
  end
  else if tmp='FROM' then begin
    FTokenOperator:=tosqlFROM;
    result:=true;
  end
  else if tmp='WHERE' then begin
    FTokenOperator:=tosqlWHERE;
    result:=true;
  end
  else if tmp='ORDER' then begin
    if uppercase(lookahead(i))<>'BY' then exit;
    FTokenOperator:=tosqlORDER;
    result:=true;
    idx:=i;
  end
  else if tmp='ASC' then begin
    FTokenOperator:=tosqlASC;
    result:=true;
  end
  else if tmp='DESC' then begin
    FTokenOperator:=tosqlDESC;
    result:=true;
  end
  else if tmp='SET' then begin
    FTokenOperator:=tosqlSET;
    result:=true;
  end
  else if tmp='VALUES' then begin
    FTokenOperator:=tosqlVALUES;
    result:=true;
  end
  else if tmp='CREATE' then begin
    FTokenOperator:=tosqlCREATE;
    result:=true;
  end
  else if tmp='TABLE' then begin
    FTokenOperator:=tosqlTABLE;
    result:=true;
  end
  else if tmp='DROP' then begin
    FTokenOperator:=tosqlDROP;
    result:=true;
  end
  else if tmp='ALTER' then begin
    FTokenOperator:=tosqlALTER;
    result:=true;
  end
  else if tmp='ADD' then begin
    FTokenOperator:=tosqlADD;
    result:=true;
  end
  else if tmp='COLUMN' then begin
    FTokenOperator:=tosqlCOLUMN;
    result:=true;
  end
  else if tmp='GROUP' then begin
    if uppercase(lookahead(i))<>'BY' then exit;
    FTokenOperator:=tosqlgroup;
    result:=true;
    idx:=i;
  end
  else if tmp='HAVING' then begin
    FTokenOperator:=tosqlHAVING;
    result:=true;
  end;

  if result then begin
    FtokenKind:=tkKeyword;
    FtokenLevel:=0;
  end;
end;

function TjanSQLTokenizer.getsubExpression: boolean;
var
  tmp:string;
  b:boolean;
  i,c,L:integer;
  tokenizer:TjanSQLTokenizer;
  sublist:TList;
  handled:boolean;
  subvalue:variant;
  brackets:integer;

  procedure clearsublist;
  var
    ii,cc:integer;
  begin
    cc:=sublist.count;
    if cc<>0 then
      for ii:=0 to cc-1 do
        TToken(sublist[ii]).free;
    sublist.clear;
  end;
begin
  result:=False;
  while (idx<=SL) and (FSource[idx]=' ') do inc(idx);
  if idx>SL then exit;
  if FSource[idx]<>'(' then exit;
  inc(idx);
  brackets:=1; // keep track of open/close brackets
  while (idx<=SL) do begin
    if FSource[idx]='(' then
      inc(brackets)
    else if FSource[idx]=')' then begin
      dec(brackets);
      if (brackets=0) then break;
    end
    else
      tmp:=tmp+FSource[idx];
    inc(idx);
  end;
  if idx>SL then exit;
  inc(idx);
  tmp:=trim(tmp);
  if postext('select ',tmp)=1 then begin
    if assigned(onSubExpression) then begin
      onSubExpression(self,tmp,subvalue,handled);
      if handled then begin
        FtokenExpression:=subvalue;
        result:=true;
      end;
    end;
    exit;
  end;
  try
    sublist:=TList.create;
    tokenizer:=TjanSQLTokenizer.create;
    b:=tokenizer.Tokenize(tmp,sublist);
  finally
    tokenizer.free;
  end;
  if not b then begin
    clearsublist;
    sublist.free;
    exit;
  end;
  c:=sublist.Count;
  if c>0 then begin
    tmp:='[';
    for i:=0 to c-1 do begin
      if Ttoken(sublist[i]).tokenkind=tkComma then
        tmp:=tmp+']['
      else
        tmp:=tmp+TToken(sublist[i]).name;
    end;
    tmp:=tmp+']';
  end;
  FtokenExpression:=tmp;
  clearsublist;
  sublist.free;
  result:=true;
end;

procedure TjanSQLTokenizer.SetonSubExpression(
  const Value: TSubExpressionEvent);
begin
  FonSubExpression := Value;
end;
// some sql clauses consist of 2 wordes
// eg GROUP BY
function TjanSQLTokenizer.LookAhead(var index:integer): string;
var
  i:integer;
  tmp:string;
begin
  result:='';
  i:=idx;
  //skip spaces
  while (i<=SL) and (FSource[i]=' ') do inc(i);
  if i>SL then exit;
  // only alpha
  if not (Fsource[i] in alphachars) then exit;
  while (i<=SL) and (Fsource[i] in alphachars) do begin
    tmp:=tmp+FSource[i];
    inc(i);
  end;
  if (i>SL) then
    result:=tmp
  else if Fsource[i]=' ' then
    result:=tmp;
  index:=i;
end;

{ TToken }

function TToken.copy: TToken;
begin
  result:=TToken.Create;
  result.name:=name;
  result.value:=value;
  result.tokenkind:=tokenkind;
  result.operator:=operator;
  result.level:=level;
  result.expression:=expression;
end;

procedure TToken.Setexpression(const Value: string);
begin
  Fexpression := Value;
end;

procedure TToken.Setlevel(const Value: integer);
begin
  Flevel := Value;
end;

procedure TToken.Setname(const Value: string);
begin
  Fname := Value;
end;

procedure TToken.Setoperator(const Value: TTokenOperator);
begin
  Foperator := Value;
end;

procedure TToken.Settokenkind(const Value: TTokenKind);
begin
  Ftokenkind := Value;
end;

procedure TToken.Setvalue(const Value: variant);
begin
  Fvalue := Value;
end;




end.
