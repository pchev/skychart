{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: janSQLExpression2.pas, released March 24, 2002.

The Initial Developer of the Original Code is Jan Verhoeven
(jan1.verhoeven@wxs.nl or http://jansfreeware.com).
Portions created by Jan Verhoeven are Copyright (C) 2002 Jan Verhoeven.
All Rights Reserved.

Contributor(s): ___________________.

Last Modified: 24-mar-2002
Current Version: 1.0

Notes: This is a very fast expression compiler and evaluator

Known Issues:

History:
  1.1 26-mar-2002
      - added functions:
      - FORMAT, FORMATDATE, FORMATTIME
      - YEAR, MONTH, DAY
      - DATEADD, EASTER
      - WEEKNUMBER
      - ISNUMERIC, ISDATE function
      - REPLACE function
      - added constants:
      - DATE, TIME
  1.0 24-mar-2002 : original release


-----------------------------------------------------------------------------}


unit janSQLExpression2;

interface

uses
  Classes,SysUtils,Math,janSQLStrings,dialogs,janSQLTokenizer;

const
  delimiters=['+','-','*','/',' ','(',')','=','>','<'];
  numberchars=['0'..'9','.'];
  identchars=['a'..'z','A'..'Z','0'..'9','.','_'];
  null = '';

type
  TVariableEvent=procedure(sender:Tobject;const VariableName:string;var VariableValue:variant;var handled:boolean) of object;




  TjanSQLExpression2=class(TObject)
  private
    FInFix:TList;
    FPostFix:TList;
    FStack:TList;
    Fsource: string;
    VStack:array[0..100] of variant;
    SP:integer;
    idx: integer; // scan index
    SL:integer; // source length
    FToken:string;
    FTokenKind:TTokenKind;
    FTokenValue:variant;
    FTokenOperator:TTokenOperator;
    FTokenLevel:integer;
    FTokenExpression:string;
    FPC:integer;
    FonGetVariable: TVariableEvent;
    procedure Setsource(const Value: string);
    function Parse:boolean;
    procedure AddToken;
    procedure ClearInfix;
    procedure ClearPostFix;
    procedure ClearStack;
    function InFixToStack(index:integer):boolean;
    function InfixToPostFix(index:integer):boolean;
    function StackToPostFix:boolean;
    function ConvertInFixToPostFix:boolean;
    procedure procString;
    procedure procNumber;
    procedure procVariable;
    procedure procEq;
    procedure procNe;
    procedure procGt;
    procedure procGe;
    procedure procLt;
    procedure procLe;
    procedure procAdd;
    procedure procSubtract;
    procedure procMultiply;
    procedure procDivide;
    procedure procAnd;
    procedure procOr;
    procedure procNot;
    procedure procLike;
// numerical functions
    procedure procSin;
    procedure procCos;
    procedure procSqr;
    procedure procSqrt;
    procedure procCeil;
    procedure procFloor;
    procedure procIsNumeric;
    procedure procIsDate;
    procedure procsqlIn;
// string functions
    procedure procUPPER;
    procedure procLOWER;
    procedure procTRIM;
    procedure procSoundex;
    procedure procLeft;
    procedure procRight;
    procedure procMid;
    procedure procsubstr_after;
    procedure procsubstr_before;
    procedure procReplace;
    procedure procLen;
    procedure procFix;
    procedure procFormat;
    procedure procYear;
    procedure procMonth;
    procedure procDay;
    procedure procDateAdd;
    procedure procEaster;
    procedure procWeekNumber;
    // conversion functions
    procedure procAsNumber;
    function CloseStackToPostFix: boolean;
    function OperatorsToPostFix(Level:integer): boolean;
    function FlushStackToPostFix: boolean;
    function runpop:variant;
    procedure runpush(value:variant);
    procedure SetonGetVariable(const Value: TVariableEvent);
    function IsLike(v1,v2:variant):boolean;
    procedure runOperator(op: TTokenOperator);
  public
    constructor Create;
    destructor  Destroy; override;
    procedure Clear;
    procedure getInFix(list:TStrings);
    procedure getPostFix(list:TStrings);
    function Evaluate:variant;
    procedure GetTokenList(list:TList;from,till:integer);
    property Expression:string read Fsource write Setsource;
    property onGetVariable:TVariableEvent read FonGetVariable write SetonGetVariable;
  end;

implementation


{ TjanSQLExpression2 }


procedure TjanSQLExpression2.AddToken;
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
  FInFix.Add(tok);
end;

procedure TjanSQLExpression2.Clear;
begin
  ClearInfix;
  ClearPostFix;
  ClearStack;
end;

procedure TjanSQLExpression2.ClearInfix;
var
  i,c:integer;
begin
  c:=FInFix.Count;
  if c=0 then exit;
  for i:=c-1 downto 0 do
    TObject(FInFix.items[i]).free;
  FInFix.clear;
end;

procedure TjanSQLExpression2.ClearPostFix;
var
  i,c:integer;
begin
  c:=FPostFix.Count;
  if c=0 then exit;
  for i:=c-1 downto 0 do
    TObject(FPostFix.items[i]).free;
  FPostFix.clear;
end;

procedure TjanSQLExpression2.ClearStack;
var
  i,c:integer;
begin
  c:=FStack.Count;
  if c=0 then exit;
  for i:=c-1 downto 0 do
    TObject(FStack.items[i]).free;
  FStack.clear;
end;
{
For each token in INPUT do the following:

If the token is an operand, enqueue it in OUTPUT.

If the token is an open bracket - push it on STACK.

If the token is a closing bracket:
  - pop operators off STACK and enqueue them in OUTPUT,
  until you encounter an open bracket.
  Discard the opening bracket. If you reach the bottom of STACK without seeing an open bracket this indicates that the parentheses in the infix expression do not match, and so you should indicate an error.

If the token is an operator - pop operators off STACK and enqueue them in OUTPUT, until one of the following occurs:
- STACK is empty
- the operator at the top of STACK has lower precedence than the token
- the operator at the top of the stack has the same precedence as the token and the token is right associative.
Once you have done that push the token on STACK.

When INPUT becomes empty pop any remaining operators from STACK and enqueue them in OUTPUT. If one of the operators on STACK happened to be an open bracket, that means that its closing bracket never came, so an an error should be indicated.
}
function TjanSQLExpression2.ConvertInFixToPostFix: boolean;
var
  i,c,level:integer;
  tok:TToken;
begin
  result:=false;
  c:=FInfix.count;
  if c=0 then exit;
  for i:=0 to c-1 do begin
    tok:=TToken(FInfix[i]);
    case tok.tokenkind of
    tkOperand: if not InFixToPostFix(i) then exit;
    tkOpen: if not InFixToStack(i) then exit;
    tkClose: if not CloseStackToPostFix then exit;
    tkOperator:
      begin
        if not OperatorsToPostFix(tok.level) then exit;
        InFixToStack(i);
      end;
    end;
  end;
  result:=FlushStackToPostFix;
end;

{
If the token is a closing bracket:
  - pop operators off STACK and enqueue them in OUTPUT,
  until you encounter an open bracket.
  Discard the opening bracket. If you reach the bottom of STACK without seeing an open bracket this indicates that the parentheses in the infix expression do not match, and so you should indicate an error.

}
function TjanSQLExpression2.CloseStackToPostFix: boolean;
begin
  result:=false;
  while (FStack.count<>0) and (TToken(Fstack[FStack.count-1]).tokenkind<>tkOpen) do
    StackToPostFix;
  if FStack.count<>0 then begin
    TToken(FStack[FStack.count-1]).free;
    Fstack.Delete(FStack.count-1);
    result:=true;
  end;
end;

{
If the token is an operator - pop operators off STACK and enqueue them in OUTPUT, until one of the following occurs:
- STACK is empty
- the operator at the top of STACK has lower precedence than the token
- the operator at the top of the stack has the same precedence as the token and the token is right associative.
Once you have done that push the token on STACK.
}
function TjanSQLExpression2.OperatorsToPostFix(Level:integer): boolean;
begin
  while (FStack.count<>0) and (TToken(Fstack[FStack.count-1]).level>=level) do
    StackToPostFix;
  result:=true;
end;

{
When INPUT becomes empty pop any remaining operators from STACK and enqueue them in OUTPUT. If one of the operators on STACK happened to be an open bracket, that means that its closing bracket never came, so an an error should be indicated.
}
function TjanSQLExpression2.FlushStackToPostFix: boolean;
begin
  result:=false;
  while (FStack.count<>0) and (TToken(Fstack[FStack.count-1]).tokenkind<>tkOpen) do
    StackToPostFix;
  result:=FStack.count=0;
end;

constructor TjanSQLExpression2.Create;
begin
  FInFix:=TList.create;
  FPostFix:=TList.create;
  FStack:=TList.create;
end;

destructor TjanSQLExpression2.Destroy;
begin
  Clear;
  FInFix.free;
  FPostFix.free;
  Fstack.free;
  inherited;
end;

procedure TjanSQLExpression2.getInFix(list: TStrings);
var
  i,c:integer;
begin
  list.Clear;
  c:=FInFix.Count;
  if c=0 then exit;
  for i:=0 to c-1 do begin
    list.append(TToken(FInFix[i]).name);
  end;
end;

procedure TjanSQLExpression2.getPostFix(list:Tstrings);
var
  i,c:integer;
begin
  list.Clear;
  c:=FPostFix.Count;
  if c=0 then exit;
  for i:=0 to c-1 do begin
    list.append(TToken(FPostFix[i]).name);
  end;
end;



function TjanSQLExpression2.InfixToPostFix(index: integer): boolean;
begin
  result:=false;
  if (index<0) or (index>=FInFix.count) then exit;
  FPostFix.add(TToken(FInfix[index]).copy);
  result:=true;
end;


function TjanSQLExpression2.InFixToStack(index: integer): boolean;
begin
  result:=false;
  if (index<0) or (index>=FInFix.count) then exit;
  FStack.add(TToken(FInfix[index]).copy);
  result:=true;
end;

function TjanSQLExpression2.Parse;
var
  tokenizer:TjanSQLTokenizer;
begin
  clear;
  try
    tokenizer:=TjanSQLTokenizer.create;
    result:=Tokenizer.Tokenize(FSource,FInfix);
  finally
    tokenizer.free;
  end;
end;

procedure TjanSQLExpression2.procAdd;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2 + v1);
end;

procedure TjanSQLExpression2.procAnd;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2 and v1);
end;

procedure TjanSQLExpression2.procDivide;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2/v1);
end;

procedure TjanSQLExpression2.procEq;
var
  v1,v2:variant;
  b:boolean;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2=v1);
end;

procedure TjanSQLExpression2.procGe;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2>=v1);
end;

procedure TjanSQLExpression2.procGt;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2>v1);
end;

procedure TjanSQLExpression2.procLe;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2<=v1);
end;

procedure TjanSQLExpression2.procLt;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2<v1);
end;

procedure TjanSQLExpression2.procMultiply;
begin
  runpush(runpop* runpop);
end;

procedure TjanSQLExpression2.procNe;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2<>v1);
end;

procedure TjanSQLExpression2.procNumber;
begin
  runpush(TToken(FPostFix[FPC]).value);
end;

procedure TjanSQLExpression2.procOr;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2 or v1);
end;

procedure TjanSQLExpression2.procString;
begin
  runpush(TToken(FPostFix[FPC]).value);

end;

procedure TjanSQLExpression2.procSubtract;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(v2-v1);
end;

procedure TjanSQLExpression2.Setsource(const Value: string);
begin
  Fsource := Value;
  SL:=length(FSource);
  parse;
  ConvertInFixToPostFix;
end;

function TjanSQLExpression2.StackToPostFix: boolean;
var
  tok:TToken;
begin
  result:=false;
  if FStack.count=0 then exit;
  tok:=TToken(FStack[FStack.count-1]);
  FPostFix.Add(tok);
  FStack.Delete(FStack.count-1);
  result:=true;
end;

procedure TjanSQLExpression2.runOperator(op:TTokenOperator);
begin
  case op of
    toString: procString;
    toNumber: procNumber;
    toVariable: procVariable;
    toEq: procEq;
    toNe: procNe;
    toGt: procGt;
    toGe: procGe;
    toLt: procLt;
    toLe: procLe;
    toAdd: procAdd;
    toSubtract: procSubtract;
    toMultiply: procMultiply;
    toDivide: procDivide;
    toAnd: procAnd;
    toOr: procOr;
    toNot: procNot;
    toLike: procLike;
    toSin: procSin;
    toCos: procCos;
    toSqr: procSqr;
    toSqrt: procSqrt;
    tosqlIN: procsqlIN;
    toUPPER: procUPPER;
    toLOWER: procLOWER;
    toTRIM: procTRIM;
    toSoundex: procSoundex;
    toLeft:procLeft;
    toRight:procRight;
    toMid:procMid;
    toLen:procLen;
    toFix:procFix;
    toCeil:procCeil;
    toFloor:procFloor;
    toAsNumber: procAsNumber;
    toFormat: procFormat;
    toYear: procYear;
    toMonth: procMonth;
    toDay: procDay;
    toDateAdd: procDateAdd;
    toEaster: procEaster;
    toWeekNumber:procWeekNumber;
    toIsNumeric: procIsNumeric;
    toIsDate: procIsDate;
    toReplace:procReplace;
    toSubstr_After:procSubstr_After;
    toSubstr_Before:procSubstr_Before;
  end;
end;

function TjanSQLExpression2.Evaluate: variant;
var
  i,c:integer;
  op:TTokenOperator;
begin
  result:=null;
  c:=FPostFix.Count;
  if c=0 then exit;
  SP:=0;
  for i:=0 to c-1 do begin
    FPC:=i;
    op:=TToken(FPostFix[i]).operator;
    try
      runoperator(op);
    except
      exit;
    end;
  end;
  result:=runpop;
end;



function TjanSQLExpression2.runpop: variant;
begin
  if SP=0 then
    result:=null
  else begin
    dec(SP);
    result:=Vstack[sp];
  end;

end;

procedure TjanSQLExpression2.runpush(value: variant);
begin
  VStack[SP]:=value;
  inc(SP);
end;

procedure TjanSQLExpression2.procVariable;
var
  VariableName:string;
  VariableValue:Variant;
  handled:boolean;
begin
  VariableName:=TToken(FPostFix[FPC]).name;
  if assigned(onGetVariable) then begin
    handled:=false;
    ongetvariable(self,VariableName,VariableValue,handled);
    if not handled then
     VariableValue:=VariableName;
  end
  else
    VariableValue:=VariableName;
  runpush(VariableValue);
end;

procedure TjanSQLExpression2.SetonGetVariable(const Value: TVariableEvent);
begin
  FonGetVariable := Value;
end;


procedure TjanSQLExpression2.procSin;
var
  v1:variant;
begin
  v1:=runpop;
  runpush(sin(v1));
end;

procedure TjanSQLExpression2.procNot;
var
  v1:variant;
begin
  v1:=runpop;
  runpush(not(v1));
end;

procedure TjanSQLExpression2.procLike;
var
  v1,v2:variant;
begin
  v1:=runpop;
  v2:=runpop;
  runpush(IsLike(v1,v2));
end;

function TjanSQLExpression2.IsLike(v1, v2: variant): boolean;
var
  p1,p2:integer;
  s1,s2:string;
begin
  s1:=v1;
  s2:=v2;
  if posstr('%',s1)=0 then begin
    result:=ansisametext(s1,s2)
  end
  else if (copy(s1,1,1)='%') and (copy(s1,length(s1),1)='%') then begin
    s1:=copy(s1,2,length(s1)-2);
    result:=postext(s1,s2)>0;
  end
  else if (copy(s1,1,1)='%') then begin
    s1:=copy(s1,2,maxint);
    p1:=postext(s1,s2);
    result:=p1=length(s2)-length(s1)+1;
  end
  else if (copy(s1,length(s1),1)='%') then begin
    s1:=copy(s1,1,length(s1)-1);
    result:=postext(s1,s2)=1;
  end;
end;





procedure TjanSQLExpression2.procsqlIn;
var
  v1:variant;
  se,s2:string;
  b:boolean;
  p1,p2,L,L2:integer;
begin
  v1:=runpop;
  s2:=v1;
  se:=TToken(FPostFix[FPC]).expression;
  runpush(postext('['+s2+']',se)>0);
end;

procedure TjanSQLExpression2.GetTokenList(list: TList; from,
  till: integer);
var
  tok:TToken;
  i:integer;

begin
  Clear;
  for i:=from to till do
    FInFix.Add(TToken(list[i]).copy);
  ConvertInFixToPostFix;
end;

procedure TjanSQLExpression2.procLOWER;
var
  v1:variant;
  s1:string;
begin
  v1:=runpop;
  s1:=v1;
  runpush(lowercase(s1));
end;

procedure TjanSQLExpression2.procTRIM;
var
  v1:variant;
  s1:string;
begin
  v1:=runpop;
  s1:=v1;
  runpush(trim(s1));
end;

procedure TjanSQLExpression2.procUPPER;
var
  v1:variant;
  s1:string;
begin
  v1:=runpop;
  s1:=v1;
  runpush(uppercase(s1));
end;

procedure TjanSQLExpression2.procSoundex;
var
  v1:variant;
  s1:string;
begin
  v1:=runpop;
  s1:=v1;
  runpush(soundex(s1));
end;

procedure TjanSQLExpression2.procAsNumber;
var
  v1:variant;
  s1:string;
  d1:double;
begin
  v1:=runpop;
  try
    s1:=v1;
    v1:=strtofloat(s1);
  except
    v1:=0;
  end;
  s1:=v1;
  runpush(v1);
end;

procedure TjanSQLExpression2.procLeft;
var
  asize,atext:variant;
  s1:string;
  p:integer;
begin
  asize:=runpop;
  atext:=runpop;
  s1:=atext;
  p:=asize;
  s1:=copy(s1,1,p);
  runpush(s1);
end;

procedure TjanSQLExpression2.procRight;
var
  asize,atext:variant;
  s1:string;
  p:integer;
begin
  asize:=runpop;
  atext:=runpop;
  s1:=atext;
  p:=asize;
  s1:=copy(s1,length(s1)-p+1,p);
  runpush(s1);
end;

procedure TjanSQLExpression2.procMid;
var
  vcount,vfrom,vtext:variant;
  s1:string;
  p,c:integer;
begin
  vcount:=runpop;
  vfrom:=runpop;
  vtext:=runpop;
  s1:=vtext;
  p:=vfrom;
  c:=vcount;
  s1:=copy(s1,p,c);
  runpush(s1);
end;

procedure TjanSQLExpression2.procCos;
var
  v1:variant;
begin
  v1:=runpop;
  runpush(cos(v1));
end;

procedure TjanSQLExpression2.procSqr;
var
  v1:variant;
begin
  v1:=runpop;
  runpush(sqr(v1));
end;



procedure TjanSQLExpression2.procSqrt;
var
  v1:variant;
begin
  v1:=runpop;
  runpush(sqrt(v1));
end;

procedure TjanSQLExpression2.procLen;
var
  v1:variant;
  s1:string;
begin
  v1:=runpop;
  s1:=v1;
  runpush(length(s1));
end;

procedure TjanSQLExpression2.procFix;
var
  vfloat,vdecimals:variant;
  s1,s2:string;
  d1:double;
begin
  vdecimals:=runpop;
  vfloat:=runpop;
  s1:=vfloat;
  s2:=vdecimals;
  try
    d1:=strtofloat(s1);
    s1:=format('%.'+s2+'f',[d1]);
  except
  end;
  runpush(s1);
end;

procedure TjanSQLExpression2.procCeil;
var
  v1:variant;
begin
  v1:=runpop;
  runpush(ceil(v1));
end;

procedure TjanSQLExpression2.procFloor;
var
  v1:variant;
begin
  v1:=runpop;
  runpush(floor(v1));
end;

procedure TjanSQLExpression2.procFormat;
var
  vfloat,vformat:variant;
  s1,s2:string;
  d1:double;
  i1:integer;
begin
  vformat:=runpop;
  vfloat:=runpop;
  s1:=vfloat;
  s2:=vformat;
  if s2='' then begin
    runpush(s1);
    exit;
  end;
  if s2[length(s2)] in ['d','x'] then
  try
    i1:=strtoint(s1);
    s1:=format(s2,[i1]);
  except
  end
  else if s2[length(s2)] in ['s'] then
  try
    s1:=format(s2,[s1]);
  except
  end
  else
  try
    d1:=strtofloat(s1);
    s1:=format(s2,[d1]);
  except
  end;
  runpush(s1);
end;


procedure TjanSQLExpression2.procDay;
{return the day part as integer from a 'yyyy-mm-dd' string}
var
  v1:variant;
  s1:string;
  i1:integer;
begin
  v1:=runpop;
  s1:=v1;
  i1:=strtointdef(copy(s1,9,2),0);
  runpush(i1);
end;

procedure TjanSQLExpression2.procMonth;
{return the month part as integer from a 'yyyy-mm-dd' string}
var
  v1:variant;
  s1:string;
  i1:integer;
begin
  v1:=runpop;
  s1:=v1;
  i1:=strtointdef(copy(s1,6,2),0);
  runpush(i1);
end;

procedure TjanSQLExpression2.procYear;
{return the year part as integer from a 'yyyy-mm-dd' string}
var
  v1:variant;
  s1:string;
  i1:integer;
begin
  v1:=runpop;
  s1:=v1;
  i1:=strtointdef(copy(s1,1,4),0);
  runpush(i1);
end;

procedure TjanSQLExpression2.procDateAdd;
{add number of intervals to date}
var
  vinterval,vnumber,vdate:variant;
  ayear,amonth,aday:word;
  adate:TDateTime;
  sinterval,sdate:string;
  inumber:integer;
begin
  vdate:=runpop;
  vnumber:=runpop;
  vinterval:=runpop;
  sinterval:=lowercase(vinterval);
  inumber:=vnumber;
  sdate:=vdate;
  try
    ayear:=strtoint(copy(sdate,1,4));
    amonth:=strtoint(copy(sdate,6,2));
    aday:=strtoint(copy(sdate,9,2));
    adate:=encodedate(ayear,amonth,aday);
    if sinterval='d' then
      adate:=adate+1
    else if sinterval='m' then
      adate:=incmonth(adate,inumber)
    else if sinterval='y' then
      adate:=encodedate(ayear+inumber,amonth,aday)
    else if sinterval='w' then
      adate:=adate+7*inumber
    else if sinterval='q' then
      adate:=incmonth(adate,inumber*3);
    decodedate(adate,ayear,amonth,aday);
    sdate:=format('%.4d',[ayear])+'-'+format('%.2d',[amonth])+'-'+format('%.2d',[aday]);
  except
  end;
  runpush(sdate);
end;


procedure TjanSQLExpression2.procEaster;
// returns the easter date of a given year
var
  vyear:variant;
  ayear:integer;
  s1:string;
  adate:TDateTime;
begin
  vyear:=runpop;
  s1:='';
  try
    ayear:=vyear;
    s1:=datetosqlstring(easter(ayear));
  except
  end;
  runpush(s1);
end;

procedure TjanSQLExpression2.procWeekNumber;
var
  v1:variant;
  s1:string;
  i1:integer;
  d1:TDateTime;
begin
  v1:=runpop;
  i1:=0;
  try
    s1:=v1;
    d1:=SQLStringToDate(s1);
    i1:=Date2WeekNo(d1);
  except
  end;
  runpush(i1);
end;

procedure TjanSQLExpression2.procIsNumeric;
var
  v1:variant;
  s1:string;
  d1:extended;
begin
  v1:=runpop;
  s1:=v1;
  try
    d1:=strtofloat(s1);
    runpush(true)
  except
    runpush(false)
  end;
end;

procedure TjanSQLExpression2.procIsDate;
var
  v1:variant;
  s1:string;
  d1:extended;
begin
  v1:=runpop;
  s1:=v1;
  runpush(SQLStringToDate(s1)<>0);
end;

procedure TjanSQLExpression2.procReplace;
// replace(source, oldpattern, newpattern)
var
  vsource, vold, vnew:variant;
  ssource, sold, snew:string;
begin
  vnew:=runpop;
  vold:=runpop;
  vsource:=runpop;
  ssource:=vsource;
  sold:=vold;
  snew:=vnew;
  ssource:=stringreplace(ssource,sold,snew,[rfreplaceall,rfignorecase]);
  runpush(ssource);
end;

procedure TjanSQLExpression2.procsubstr_after;
var
  vsource,vsubstr:variant;
  ssubstr,ssource,s1:string;
  p:integer;
begin
  vsubstr:=runpop;
  vsource:=runpop;
  ssubstr:=vsubstr;
  ssource:=vsource;
  p:=postext(ssubstr,ssource);
  if p>0 then
    s1:=copy(ssource,p+length(ssubstr),maxint)
  else
    s1:='';
  runpush(s1);
end;

procedure TjanSQLExpression2.procsubstr_before;
var
  vsource,vsubstr:variant;
  ssubstr,ssource,s1:string;
  p:integer;
begin
  vsubstr:=runpop;
  vsource:=runpop;
  ssubstr:=vsubstr;
  ssource:=vsource;
  p:=postext(ssubstr,ssource);
  if p>0 then
    s1:=copy(ssource,1,p-1)
  else
    s1:='';
  runpush(s1);
end;

end.
