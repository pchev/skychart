{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License Version
1.1 (the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at
http://www.mozilla.org/NPL/NPL-1_1Final.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: janSQLStrings.pas, released March 24, 2002.

The Initial Developer of the Original Code is Jan Verhoeven
(jan1.verhoeven@wxs.nl or http://jansfreeware.com).
Portions created by Jan Verhoeven are Copyright (C) 2002 Jan Verhoeven.
All Rights Reserved.

Contributor(s): ___________________.

Last Modified: 24-mar-2002
Current Version: 1.0

Notes: A set of string routines that are just usefull with janSQL

Known Issues:


History:
  1.1 25-mar-2002
      added functions for section strings
  1.0 24-mar-2002 : original release

-----------------------------------------------------------------------------}

unit janSQLStrings;

interface

uses
  Classes,sysUtils{,qstrings};

  function PosStr(const FindString, SourceString: string;
    StartPos: Integer = 1): Integer;
  function PosText(const FindString, SourceString: string;
    StartPos: Integer = 1): Integer;
  function Contains(const value:variant;const aset:string):boolean;
  function Soundex(source : string) : integer;
  procedure SaveString(aFile, aText:string);
  function  LoadString(aFile:string):string;
  procedure ListSections(atext:string;list:TStrings);
  function GetSection(atext,asection:string):string;
  function Easter( nYear: Integer ): TDateTime;
  function DateToSQLString(adate:TDateTime):string;
  function SQLStringToDate(atext:string):TDateTime;
  function Date2Year (const DT: TDateTime): Word;
  function GetFirstDayOfYear (const Year: Word): TDateTime;
  function StartOfWeek (const DT: TDateTime): TDateTime;
  function DaysApart (const DT1, DT2: TDateTime): LongInt;
  function Date2WeekNo (const DT: TDateTime): Integer;

implementation

const
  cr = chr(13)+chr(10);
  tab = chr(9);

  ToUpperChars: array[0..255] of Char =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$0F,
     #$10,#$11,#$12,#$13,#$14,#$15,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$80,#$81,#$82,#$81,#$84,#$85,#$86,#$87,#$88,#$89,#$8A,#$8B,#$8C,#$8D,#$8E,#$8F,
     #$80,#$91,#$92,#$93,#$94,#$95,#$96,#$97,#$98,#$99,#$8A,#$9B,#$8C,#$8D,#$8E,#$8F,
     #$A0,#$A1,#$A1,#$A3,#$A4,#$A5,#$A6,#$A7,#$A8,#$A9,#$AA,#$AB,#$AC,#$AD,#$AE,#$AF,
     #$B0,#$B1,#$B2,#$B2,#$A5,#$B5,#$B6,#$B7,#$A8,#$B9,#$AA,#$BB,#$A3,#$BD,#$BD,#$AF,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF);

  ToLowerChars: array[0..255] of Char =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$0F,
     #$10,#$11,#$12,#$13,#$14,#$15,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
     #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
     #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$90,#$83,#$82,#$83,#$84,#$85,#$86,#$87,#$88,#$89,#$9A,#$8B,#$9C,#$9D,#$9E,#$9F,
     #$90,#$91,#$92,#$93,#$94,#$95,#$96,#$97,#$98,#$99,#$9A,#$9B,#$9C,#$9D,#$9E,#$9F,
     #$A0,#$A2,#$A2,#$BC,#$A4,#$B4,#$A6,#$A7,#$B8,#$A9,#$BA,#$AB,#$AC,#$AD,#$AE,#$BF,
     #$B0,#$B1,#$B3,#$B3,#$B4,#$B5,#$B6,#$B7,#$B8,#$B9,#$BA,#$BB,#$BC,#$BE,#$BE,#$BF,
     #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
     #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$F7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$FF,
     #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
     #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$F7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$FF);


function PosStr(const FindString, SourceString: string; StartPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        PUSH    EDX
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        SUB     EDX,ECX
        JNG     @@qt0
        MOV     EBX,EAX
        XCHG    EAX,EDX
        NOP
        ADD     EDI,ECX
        MOV     ECX,EAX
        MOV     AL,BYTE PTR [ESI]
@@lp1:  CMP     AL,BYTE PTR [EDI]
        JE      @@uu
@@fr:   INC     EDI
        DEC     ECX
        JNZ     @@lp1
@@qt0:  XOR     EAX,EAX
        JMP     @@qt
@@ms:   MOV     AL,BYTE PTR [ESI]
        MOV     EBX,EDX
        JMP     @@fr
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     AL,BYTE PTR [ESI+EBX]
        XOR     AL,BYTE PTR [EDI+EBX]
        JNE     @@ms
        DEC     EBX
        JNE     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        SUB     EAX,[ESP]
@@qt:   POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;


function PosText(const FindString, SourceString: string; StartPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        NOP
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        MOV     ESI,EAX
        MOV     EDI,EDX
        PUSH    EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        PUSH    EAX
        SUB     EDX,ECX
        JNG     @@qtx
        ADD     EDI,ECX
        MOV     ECX,EDX
        MOV     EDX,EAX
        MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
@@lp1:  MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
@@fr:   INC     EDI
        DEC     ECX
        JNE     @@lp1
@@qtx:  ADD     ESP,$08
@@qt0:  XOR     EAX,EAX
        JMP     @@qt
@@ms:   MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOV     EDX,[ESP]
        JMP     @@fr
        NOP
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     BL,BYTE PTR [ESI+EDX]
        MOV     AH,BYTE PTR [EDI+EDX]
        CMP     BL,AH
        JE      @@eq
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOVZX   EBX,AH
        XOR     AL,BYTE PTR [EBX+ToUpperChars]
        JNE     @@ms
@@eq:   DEC     EDX
        JNZ     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        POP     ECX
        SUB     EAX,[ESP]
        POP     ECX
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
end;

function Contains(const value:variant;const aset:string):boolean;
var
  s:string;
  p1,p2,L:integer;
begin
  result:=false;
  s:=value;
  L:=length(aset);
  p1:=postext(s,aset);
  if p1=0 then exit;
  // check before
  p2:=p1+length(s);
  if p1>1 then begin
    if aset[p1-1]<>'''' then begin
      while (p1>0) and (aset[p1]=' ') do
        dec(p1);
      if (p1>0) then
        if aset[p1]<>',' then exit;
    end
  end;
  // check after
  if (p2<=L) then begin
    if aset[p2]<>'''' then begin
      while (p2<=L) and (aset[p2]=' ') do
        inc(p2);
      if (p2<=L) then
        if aset[p2]<>',' then exit;
    end;
  end;
  result:=true;
end;

procedure SaveString(aFile, aText:string);
begin
  with TFileStream.Create(aFile, fmCreate) do try
    writeBuffer(aText[1],length(aText));
    finally free; end;
end;

function  LoadString(aFile:string):string;
var s:string;
begin
  with TFileStream.Create(aFile, fmOpenRead) do try
      SetLength(s, Size);
      ReadBuffer(s[1], Size);
    finally free; end;
  result:=s;
end;

function Soundex(source:string) : integer;
Const
{This table gives the SoundEX SCORE for all characters Upper and Lower Case
hence no need to convert. This is faster than doing an UpCase on the whole input string
The 5 NON Chars in middle are just given 0}

SoundExTable : Array[65..122] Of Byte
//A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ / ] ^ _ '
=(0,1,2,3,0,1,2,0,0,2,2,4,5,5,0,1,2,6,2,3,0,1,0,2,0,2,0,0,0,0,0,0,
//a b c d e f g h i j k l m n o p q r s t u v w x y z
  0,1,2,3,0,1,2,0,0,2,2,4,5,5,0,1,2,6,2,3,0,1,0,2,0,2);

Var
  i, l, s, SO, x : Byte;
  Multiple : Word;
  Name : PChar;
begin
  If source<>''                           //do nothing if nothing is passed
  then begin
    name:=pchar(source);
    Result := Ord(UpCase(Name[0]));       //initialise to first character
    SO := 0;                              //initialise last char as 0
    Multiple := 26;                       //initialise to 26 char of alphabet
    l := Pred(StrLen(Name));              //get into var to save repeating function
    For i := 1 to l do                    //for each char of input str
    begin
      s := Ord(name[i]);                  //*
      If (s > 64) and (s < 123)           //see notes * below
      then begin
        x := SoundExTable[s];             //get soundex value
        If (x > 0)                        //it is a scoring char
        AND (x <> SO)                     //is different from previous char
        then begin
          Result := Result + (x * Multiple); //avoid use of POW as it needs maths unit
          If (Multiple = 26 * 6 * 6)      //we have done enough (NB compiles to a const
           then break;                    //We have done, so leave loop
          Multiple := Multiple * 6;
          SO := x;                        //save for next round
        end;                              // of if a scoring char
      end;                                //of if in range of SoundEx table
    end;                                  //of for loop
  end else result := 0;
end;                                      //of function SoundBts

procedure ListSections(atext:string;list:TStrings);
var
  p1,p2:integer;
begin
  list.clear;
  p1:=1;
  repeat
    p1:=posstr('[',atext,p1);
    if p1>0 then begin
      p2:=posstr(']',atext,p1);
      if p2=0 then
        p1:=0
      else begin
        list.append(copy(atext,p1+1,p2-(p1+1)));
        p1:=p2;
      end;
    end;
  until p1=0;
end;

function GetSection(atext,asection:string):string;
var
  p1,p2:integer;
begin
  result:='';
  p1:=postext('['+asection+']',atext);
  if p1=0 then exit;
  p1:=p1+length('['+asection+']');
  p2:=posstr('[',atext,p1);
  if p2=0 then
    result:=trim(copy(atext,p1,maxint))
  else
    result:=trim(copy(atext,p1,p2-p1));
end;


function Easter( nYear: Integer ): TDateTime;
var
   nMonth, nDay, nMoon, nEpact, nSunday, nGold, nCent, nCorx, nCorz: Integer;
 begin

    { The Golden Number of the year in the 19 year Metonic Cycle }
    nGold := ( ( nYear mod 19 ) + 1  );

    { Calculate the Century }
    nCent := ( ( nYear div 100 ) + 1 );

    { No. of Years in which leap year was dropped in order to keep in step
      with the sun }
    nCorx := ( ( 3 * nCent ) div 4 - 12 );

    { Special Correction to Syncronize Easter with the moon's orbit }
    nCorz := ( ( 8 * nCent + 5 ) div 25 - 5 );

    { Find Sunday }
    nSunday := ( ( 5 * nYear ) div 4 - nCorx - 10 );

    { Set Epact (specifies occurance of full moon }
    nEpact := ( ( 11 * nGold + 20 + nCorz - nCorx ) mod 30 );

    if ( nEpact < 0 ) then
       nEpact := nEpact + 30;

    if ( ( nEpact = 25 ) and ( nGold > 11 ) ) or ( nEpact = 24 ) then
       nEpact := nEpact + 1;

    { Find Full Moon }
    nMoon := 44 - nEpact;

    if ( nMoon < 21 ) then
       nMoon := nMoon + 30;

    { Advance to Sunday }
    nMoon := ( nMoon + 7 - ( ( nSunday + nMoon ) mod 7 ) );

    if ( nMoon > 31 ) then
       begin
         nMonth := 4;
         nDay   := ( nMoon - 31 );
       end
    else
       begin
         nMonth := 3;
         nDay   := nMoon;
       end;

    Result := EncodeDate( nYear, nMonth, nDay );

 end;

function DateToSQLString(adate:TDateTime):string;
var
  ayear,amonth,aday:word;
begin
  decodedate(adate,ayear,amonth,aday);
  result:=format('%.4d',[ayear])+'-'+format('%.2d',[amonth])+'-'+format('%.2d',[aday]);
end;

function SQLStringToDate(atext:string):TDateTime;
begin
  result:=0;
  try
    result:=encodedate(strtoint(copy(atext,1,4)),strtoint(copy(atext,6,2)),strtoint(copy(atext,9,2)));
  except
  end;
end;

function Date2Year (const DT: TDateTime): Word;
var
  D, M: Word;
begin
  DecodeDate (DT, Result, M, D);
end;


function GetFirstDayOfYear (const Year: Word): TDateTime;
begin
  Result := EncodeDate (Year, 1, 1);
end;

function StartOfWeek (const DT: TDateTime): TDateTime;
begin
  Result := DT - DayOfWeek (DT) + 1;
end;

function DaysApart (const DT1, DT2: TDateTime): LongInt;
begin
  Result := Trunc (DT2) - Trunc (DT1);
end;

function Date2WeekNo (const DT: TDateTime): Integer;
var
  Year: Word;
  FirstSunday, StartYear: TDateTime;
  WeekOfs: Byte;
begin
  Year := Date2Year (DT);
  StartYear := GetFirstDayOfYear (Year);
  if DayOfWeek (StartYear) = 0 then
  begin
    FirstSunday := StartYear;
    WeekOfs := 1;
  end
  else
  begin
    FirstSunday := StartOfWeek (StartYear) + 7;
    WeekOfs := 2;
    if DT < FirstSunday then
    begin
      Result := 1;
      Exit;
    end;
  end;
  Result := DaysApart (FirstSunday, StartofWeek (DT)) div 7 + WeekOfs;
end;



end.
