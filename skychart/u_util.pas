unit u_util;

{
Copyright (C) 2002 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 Utility functions
}

{$mode delphi}{$H+}

interface

uses
  {$ifdef mswindows}
  Windows, Registry,
  {$endif}

  {$ifdef unix}
  unix, baseunix, unixutil,
  {$endif}

  Math, SysUtils, Classes, u_constant,
  LazUTF8, LCLType, LazFileUtils, Controls, Process, MTPCPU,
  MaskEdit, enhedits, Menus, Spin, CheckLst, Buttons, ExtCtrls, ActnList,
  Forms, Graphics, StdCtrls, ComCtrls, Dialogs, Grids, PrintersDlgs, Printers;

function rmod(x, y: double): double;
function NormRA(ra: double): double;
function sgn(x: double): double;
function PadZeros(x: string; l: integer): string;
function mm2pi(l, PrinterResolution: single): integer;
function Slash(nom: string): string;
function NoSlash(nom: string): string;
function IsNumber(n: string): boolean;
function IsInteger(n: string): boolean;
function AddColor(c1, c2: Tcolor): Tcolor;
function SubColor(c1, c2: Tcolor): Tcolor;
function roundF(x: double; n: integer): double;
procedure InitTrace;
procedure WriteTrace(buf: string);
procedure Splitarg(buf, sep: string; var arg: TStringList);
procedure SplitRec(buf, sep: string; var arg: TStringList);
procedure SplitCmd(S: string; List: TStringList);
function ExpandTab(str: string; tabwidth: integer): string;
function striphtml(html: string): string;
function words(str, sep: string; p, n: integer; isep: char = blank): string;
function wordspace(str: string): string;
function nospace(str: string): string;
function validfilename(str: string): string;
function validsqlname(str: string): string;
function pos2(sub, str: string; i: integer): integer;
function InvertI16(X: word): smallint;
function InvertI32(X: longword): longint;
function InvertI64(X: int64): int64;
function InvertF32(X: longword): single;
function InvertF64(X: int64): double;
procedure DToS(t: double; var h, m, s: integer);
function DEToStr(de: double): string;
function ARtoStr(ar: double): string;
function ARToStrShort(ar: double; digits: integer = 1): string;
function DEToStrShort(de: double; digits: integer = 1): string;
function DEmToStr(de: double): string;
function DEdToStr(de: double): string;
function DEToStrmin(de: double): string;
function ARmtoStr(ar: double): string;
function DEpToStr(de: double; precision: integer = 1): string;
function ARptoStr(ar: double; precision: integer = 1): string;
function TimToStr(tim: double; sep: string = ':'; showsec: boolean = True): string;
function StrToTim(tim: string; sep: string = ':'): double;
function YearADBC(year: integer): string;
function Date2Str(y, m, d: integer; yadbc: boolean = True): string;
function ARToStr2(ar: double; var d, m, s: string): string;
function ARToStr3(ar: double): string;
function ARToStr4(ar: double; f: string; var d, m, s: string): string;
function Str3ToAR(dms: string): double;
function DEToStr2(de: double; var d, m, s: string): string;
function DEToStr3(de: double): string;
function Str3ToDE(dms: string): double;
function DEToStr4(de: double): string;
procedure Str2RaDec(txt: string; out ra,de: double);
function isodate(a, m, d: integer): string;
function LeapYear(Year: longint): boolean;
function DayofYear(y, m, d: integer): integer;
procedure iso2date(dt: string; out a, m, d: integer);
function datejd(dt:string): double;
function jddate(jd: double): string;
function jddate2(jd: double): string;
function jddatetime(jd: double; fy, fm, fd, fh, fn, fs: boolean): string;
function DateTimetoJD(Date: Tdatetime): double;
function LONmToStr(l: double): string;
function LONToStr(l: double): string;
function SetCurrentTime(cfgsc: Tconf_skychart): boolean;
function DTminusUT(year, month, day: integer; c: Tconf_skychart): double;
function DTminusUTComp(year, month, day: integer; c: Tconf_skychart): double;
function DTminusUTError(year, month, day: integer; c: Tconf_skychart): double;
function DTminusUTErrorComp(year, month, day: integer; c: Tconf_skychart): double;
procedure FormPos(form: TForm; x, y: integer; safemargin: boolean = True);
function ExecProcess(cmd: string; output: TStringList;
  ShowConsole: boolean = False): integer;
function Exec(cmd: string; hide: boolean = True): integer;
procedure ExecNoWait(cmd: string; title: string = ''; hide: boolean = True);
function decode_mpc_date(s: string; var y, m, d: integer; var hh: double): boolean;
function encode_mpc_date(y, m, d: integer; hh: double; var s: string): boolean;
function GreekLetter(gr: shortstring): shortstring;
function GetId(str: string): integer;
procedure GetPrinterResolution(var Name: string; var resol: integer);
function GetPrinterIndex: integer;
function ExecuteFile(const FileName: string): integer;
procedure PrintStrings(str: TStrings; PrtTitle, PrtText, PrtTextDate: string;
  orient: TPrinterOrientation);
procedure PrtGrid(Grid: TStringGrid; PrtTitle, PrtText, PrtTextDate: string;
  orient: TPrinterOrientation);
function EncryptStr(Str, Pwd: string; Encode: boolean = True): string;
function DecryptStr(Str, Pwd: string): string;
function strtohex(str: string): string;
function hextostr(str: string): string;
//procedure GetTranslationString(form: TForm; var f: textfile);
function CondUTF8Decode(v: string): string;
function CondUTF8Encode(v: string): string;
function GreekSymbolUtf8(v: string): string;
function SafeUTF8ToSys(v: string): string;
function GetSerialPorts(var c: TComboBox): boolean;
function TzGMT2UTC(gmttz: string): string;
function TzUTC2GMT(utctz: string): string;
function ExtractSubPath(basepath, path: string): string;
function RoundInt(x: double): integer;
function GetThreadCount: integer;
function capitalize(txt: string): string;
function isANSIstr(str: string): boolean;
function GetXPlanetVersion: string;
procedure GetXplanet(Xplanetversion, originfile, searchdir, bsize, outfile: string;
  ipla: integer; pa, grsl, jd: double; var irc: integer; var r: TStringList);
function VisibleControlCount(obj: TWinControl): integer;
procedure SetMenuAccelerator(Amenu: TMenuItem; level: integer;
  var AccelList: array of string);
procedure ISleep(milli: integer);
function CompareVersion(v1, v2: string): integer;
function strim(const S: string): string;
procedure DeleteFilesInDir(dir: string);
function ShowModalForm(f: TForm; SetFocus: boolean = False): TModalResult;
function prepare_IAU_designation(rax,decx :double):string;
function TruncDecimal(val: Extended; decimal: byte): Extended;
procedure Wait(wt:single=5);
function CleanName(fn:string):string;
function MessageDlgCenter(const aCaption, aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): TModalResult;

{$ifdef unix}
function ExecFork(cmd: string; p1: string = ''; p2: string = ''; p3: string = '';
  p4: string = ''; p5: string = ''): integer;
function CdcSigAction(const action: pointer): boolean;
{$endif}

{$ifdef mswindows}
function FindWOW64: boolean;
function ScreenBPP: integer;
{$endif}

var
  traceon: boolean;

implementation

uses
  u_projection;

var
  dummy_ext: extended;
  dummy_int: integer;
  ftrace: textfile;

{$ifdef lclgtk2} {$define cdcutf8} {$define greekutf8} {$endif}
{$ifdef lclqt} {$define cdcutf8} {$define greekutf8} {$endif}
{$ifdef lclqt5} {$define cdcutf8} {$define greekutf8} {$endif}
{$ifdef lclcarbon} {$define cdcutf8} {$define greekutf8} {$endif}
{$ifdef lclcocoa} {$define cdcutf8} {$define greekutf8} {$endif}
{$ifdef lclwin32} {$define cdcutf8} {$endif}
{$ifdef lclwin64} {$define cdcutf8} {$endif}

function CondUTF8Decode(v: string): string;
begin
  {$ifdef cdcutf8}
  Result := v;
  {$else}
  Result := UTF8Decode(v);
  {$endif}
end;

function CondUTF8Encode(v: string): string;
begin
  {$ifdef cdcutf8}
  Result := v;
  {$else}
  Result := UTF8Encode(v);
  {$endif}
end;

function GreekSymbolUtf8(v: string): string;
{$ifdef greekutf8}
var
  c, n: string;
  i: integer;
{$endif}
begin
  {$ifdef greekutf8}
  c := lowercase(trim(copy(v, 1, 1)));
  n := trim(copy(v, 2, 1));
  Result := v;

  for i := 1 to maxgreek do
  begin
    if c = greeksymbol[2, i] then
    begin
      Result := chr(hi(greekUTF8[i])) + chr(lo(greekUTF8[i])) + n;
      break;
    end;
  end;

  {$else}
  Result := v;
  {$endif}
end;

function SafeUTF8ToSys(v: string): string;
begin
  Result := UTF8ToSys(v);

  if Result = '' then
    Result := v;
end;

function GetSerialPorts(var c: TComboBox): boolean;
var
  p: TStringList;
  i: integer;
  buf: string;
  {$ifdef mswindows}
  reg: TRegistry;
  l: TStringList;
  n: integer;
  {$else}
  fs: TSearchRec;
  {$endif}
begin
  p := TStringList.Create;
  p.Clear;

  {$WARN SYMBOL_PLATFORM OFF}

  {$ifdef linux}
  i := findfirst('/dev/ttyS*', faSysFile, fs);

  while i = 0 do
  begin
    p.Add('/dev/' + fs.Name);
    i := findnext(fs);
  end;

  findclose(fs);
  i := findfirst('/dev/ttyUSB*', faSysFile, fs);

  while i = 0 do
  begin
    p.Add('/dev/' + fs.Name);
    i := findnext(fs);
  end;
  findclose(fs);
  {$endif}

  {$ifdef freebsd}
  i := findfirst('/dev/cua*', faSysFile, fs);
  while i = 0 do
  begin
    p.Add('/dev/' + fs.Name);
    i := findnext(fs);
  end;
  findclose(fs);
  {$endif}

  {$ifdef darwin}
  i := findfirst('/dev/cu.usbserial*', faSysFile, fs);
  while i = 0 do
  begin
    p.Add('/dev/' + fs.Name);
    i := findnext(fs);
  end;
  findclose(fs);

  i := findfirst('/dev/cu.serial*', faSysFile, fs);
  while i = 0 do
  begin
    p.Add('/dev/' + fs.Name);
    i := findnext(fs);
  end;
  findclose(fs);

  i := findfirst('/dev/tty.usbserial*', faSysFile, fs);
  while i = 0 do
  begin
    p.Add('/dev/' + fs.Name);
    i := findnext(fs);
  end;
  findclose(fs);

  i := findfirst('/dev/tty.serial*', faSysFile, fs);
  while i = 0 do
  begin
    p.Add('/dev/' + fs.Name);
    i := findnext(fs);
  end;
  findclose(fs);
  {$endif}

  {$ifdef mswindows}
  l := TStringList.Create;
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('\HARDWARE\DEVICEMAP\SERIALCOMM', False);
  reg.GetValueNames(l);

  for n := 0 to l.Count - 1 do
    p.Add(reg.ReadString(l[n]));

  reg.Free;
  l.Free;
  {$endif}

  {$WARN SYMBOL_PLATFORM ON}

  p.Sort;
  buf := c.Text;

  try
    if p.Count > 0 then
    begin
      c.Clear;

      for i := 0 to p.Count - 1 do
        c.Items.Add(p[i]);
    end;

  finally
    c.Text := buf;
    p.Free;
  end;

  Result := True;
end;

function mm2pi(l, PrinterResolution: single): integer;
begin
  Result := round(l * PrinterResolution / 25.4);
end;

function PadZeros(x: string; l: integer): string;
const
  zero = '000000000000';
var
  p: integer;
begin
  x := trim(x);
  p := l - length(x);
  Result := copy(zero, 1, p) + x;
end;

function Rmod(x, y: double): double;
begin
  Rmod := x - Int(x / y) * y;
end;

function NormRA(ra: double): double;
begin
  Result := rmod(ra + pi4, pi2);
end;

function sgn(x: double): double;
begin
  // sign function with zero positive
  if x < 0 then
    sgn := -1
  else
    sgn := 1;
end;

function NoSlash(nom: string): string;
begin
  Result := trim(nom);

  if copy(Result, length(nom), 1) = PathDelim then
    Result := copy(Result, 1, length(nom) - 1);
end;

function Slash(nom: string): string;
begin
  Result := trim(nom);

  if copy(Result, length(nom), 1) <> PathDelim then
    Result := Result + PathDelim;
end;

function IsNumber(n: string): boolean;
begin
  Result := TextToFloat(PChar(n), Dummy_ext);
end;

function IsInteger(n: string): boolean;
begin
  Result := TryStrToInt(n, dummy_int);
end;

function roundF(x: double; n: integer): double;
var
  y: double;
begin
  y := intpower(10, n);
  Result := round(x * y) / y;
end;

procedure InitTrace;
begin

  try
    traceon := True;

    if tracefile <> '' then
      tracefile := expandfilename(tracefile);

    Filemode := 2;
    assignfile(ftrace, tracefile);
    rewrite(ftrace);
    writeln(ftrace, FormatDateTime(dateiso, Now) + '  Start trace');

    if tracefile <> '' then
      closefile(ftrace);

  except
    {$I-}
    traceon := False;
    closefile(ftrace);
    IOResult;
    {$I+}
  end;

end;

procedure WriteTrace(buf: string);
begin

  try

    if traceon then
    begin

      if tracefile <> '' then
      begin
        Filemode := 2;
        assignfile(ftrace, tracefile);
        append(ftrace);
      end;

      writeln(ftrace, FormatDateTime(dateiso, Now) + '  ' + UTF8ToSys(buf));

      if tracefile <> '' then
        closefile(ftrace);

    end;

  except
    {$I-}
    traceon := False;
    closefile(ftrace);
    IOResult;
    {$I+}
  end;

end;

function AddColor(c1, c2: Tcolor): Tcolor;
var
  max, r, v, b: integer;
  f: double;
begin
  r := (c1 and $000000ff) + (c2 and $000000ff);
  v := ((c1 and $0000ff00) + (c2 and $0000ff00)) shr 8;
  b := ((c1 and $00ff0000) + (c2 and $00ff0000)) shr 16;

  max := maxintvalue([r, v, b]);

  if max > 255 then
  begin
    f := 255 / max;
    r := trunc(f * r);
    v := trunc(f * v);
    b := trunc(f * b);
  end;

  Result := r + 256 * v + 65536 * b;
end;

function SubColor(c1, c2: Tcolor): Tcolor;
var
  min, r, v, b: integer;
  f: double;
begin
  r := (c1 and $000000ff) - (c2 and $000000ff);
  v := ((c1 and $0000ff00) - (c2 and $0000ff00)) shr 8;
  b := ((c1 and $00ff0000) - (c2 and $00ff0000)) shr 16;

  min := minintvalue([r, v, b]);

  if min < 0 then
  begin
    f := 255 / (255 - min);
    r := trunc(f * (r - min));
    v := trunc(f * (v - min));
    b := trunc(f * (b - min));
  end;

  Result := r + 256 * v + 65536 * b;
end;

// same as SplitRec but remove empty strings
procedure Splitarg(buf, sep: string; var arg: TStringList);
var
  i, j, k, l: integer;
begin

  arg.Clear;
  l := length(sep);

  while copy(buf, 1, l) = sep do
    Delete(buf, 1, 1);

  while pos(sep, buf) <> 0 do
  begin

    for i := 1 to length(buf) do
    begin

      if copy(buf, i, l) = sep then
      begin

        if copy(buf, i + l, l) = sep then
          continue;

        if copy(buf, 1, 1) = '"' then
        begin
          j := length(buf);
          for k := 2 to length(buf) do
          begin
            if copy(buf, k, 1) = '"' then
            begin
              j := k;
              break;
            end;
          end;

          arg.Add(copy(buf, 2, j - 2));
          Delete(buf, 1, j);

          while copy(buf, 1, l) = sep do
            Delete(buf, 1, 1);

          break;

        end
        else
        begin
          arg.add(copy(buf, 1, i - 1));
          Delete(buf, 1, i - 1 + l);
          break;
        end;

      end;

    end;

  end;

  if buf > '' then
    arg.add(buf);

end;

// same as SplitArg but keep empty strings
procedure SplitRec(buf, sep: string; var arg: TStringList);
var
  i, l: integer;
begin

  arg.Clear;
  l := length(sep);

  while pos(sep, buf) <> 0 do
  begin
    for i := 1 to length(buf) do
    begin

      if copy(buf, i, l) = sep then
      begin
        arg.add(copy(buf, 1, i - 1));
        Delete(buf, 1, i - 1 + l);
        break;
      end;

    end;

  end;

  arg.add(buf);
end;

// handle more separator automativally. Copied from TProcess CommandToList
procedure SplitCmd(S: string; List: TStringList);

  function GetNextWord: string;
  const
    WhiteSpace = [' ', #9, #10, #13];
    Literals = ['"', ''''];
  var
    Wstart, wend: integer;
    InLiteral: boolean;
    LastLiteral: char;
  begin
    WStart := 1;

    while (WStart <= Length(S)) and (S[WStart] in WhiteSpace) do
      Inc(WStart);

    WEnd := WStart;
    InLiteral := False;
    LastLiteral := #0;

    while (Wend <= Length(S)) and (not (S[Wend] in WhiteSpace) or InLiteral) do
    begin
      if S[Wend] in Literals then
        if InLiteral then
          InLiteral := not (S[Wend] = LastLiteral)
        else
        begin
          InLiteral := True;
          LastLiteral := S[Wend];
        end;

      Inc(wend);
    end;

    Result := Copy(S, WStart, WEnd - WStart);

    if (Length(Result) > 0) and (Result[1] = Result[Length(Result)]) and
      // if 1st char = last char and..
      (Result[1] in Literals) // it's one of the literals, then
    then
      Result := Copy(Result, 2, Length(Result) - 2);
    //delete the 2 (but not others in it)

    while (WEnd <= Length(S)) and (S[Wend] in WhiteSpace) do
      Inc(Wend);

    Delete(S, 1, WEnd - 1);
  end;

var
  W: string;
begin

  while Length(S) > 0 do
  begin
    W := GetNextWord;

    if (W <> '') then
      List.Add(W);
  end;

end;

function ExpandTab(str: string; tabwidth: integer): string;
const
  tab = #09;

var
  i, j, k: integer;
  c: char;
begin

  Result := '';
  i := 0;

  for j := 1 to length(str) do
  begin
    c := str[j];

    if c = tab then
    begin
      k := i mod tabwidth;
      Result := Result + StringOfChar(blank, tabwidth - k);
      i := i + tabwidth - k;
    end
    else
    begin
      Result := Result + c;
      Inc(i);
    end;

  end;

end;

function nospace(str: string): string;
begin
  Result := StringReplace(str, ' ', '', [rfReplaceAll]);
end;

function validfilename(str: string): string;
const invalidchar='/\<>":|?*';
var i: integer;
begin
  result:='';
  for i:=1 to length(str) do begin
     if pos(str[i],invalidchar)=0 then
       result:=result+str[i]
     else
       result:=result+'';
  end;
end;

function validsqlname(str: string): string;
const invalidchar='|*/%+-<>&=!~';
var i: integer;
begin
  result:='';
  for i:=1 to length(str) do begin
     if pos(str[i],invalidchar)=0 then
       result:=result+str[i]
     else
       result:=result+'_';
  end;
end;

function wordspace(str: string): string;
var
  i: integer;
  c: char;
begin
  c := blank;
  Result := '';

  for i := 1 to length(str) do
  begin
    if str[i] = blank then
    begin
      if c <> blank then
        Result := Result + str[i];

    end
    else
      Result := Result + str[i];

    c := str[i];
  end;

end;

function words(str, sep: string; p, n: integer; isep: char = blank): string;
var
  i, j: integer;
begin

  Result := '';
  str := trim(str);

  for i := 1 to p - 1 do
  begin
    j := pos(isep, str);
    if j = 0 then
      j := length(str) + 1;
    str := trim(copy(str, j + 1, length(str)));
  end;

  for i := 1 to n do
  begin
    j := pos(isep, str);

    if j = 0 then
      j := length(str) + 1;

    Result := Result + trim(copy(str, 1, j - 1)) + sep;
    str := trim(copy(str, j + 1, length(str)));
  end;

end;

function striphtml(html: string): string;
var
  i: integer;
  c: char;
  intag: boolean;
  tag: string;
begin

  Result := '';

  intag := False;
  tag := '';

  for i := 1 to length(html) do
  begin
    c := html[i];

    case c of
      '<':
      begin
        intag := True;
        tag := '';
      end;

      '>':
      begin
        intag := False;
        if tag = 'p' then
          Result := Result + crlf;
        if tag = 'br' then
          Result := Result + crlf;
      end;

      else
      begin
        if intag then
          tag := tag + c
        else
          Result := Result + c;
      end;

    end;

  end;

  Result := StringReplace(Result, '&nbsp;', ' ', [rfReplaceAll]);
end;

function pos2(sub, str: string; i: integer): integer;
begin
  Result := pos(sub, copy(str, i, length(str)));

  if Result > 0 then
    Result := Result + i - 1;
end;

function InvertI16(X: word): smallint;
var
  P: PbyteArray;
  temp: word;
begin
  P := @X;
  temp := (P[0] shl 8) or (P[1]);
  move(temp, Result, 2);
end;

function InvertI32(X: longword): longint;
var
  P: PbyteArray;
begin
  P := @X;
  Result := (P[0] shl 24) or (P[1] shl 16) or (P[2] shl 8) or (P[3]);
end;

function InvertI64(X: int64): int64;
var
  P: PbyteArray;
begin
  P := @X;
  Result := 4294967296 * ((P[0] shl 24) or (P[1] shl 16) or (P[2] shl 8) or (P[3])) +
    ((P[4] shl 24) or (P[5] shl 16) or (P[6] shl 8) or (P[7]));
end;

function InvertF32(X: longword): single;
var
  P: PbyteArray;
  temp: longword;
begin
  P := @X;

  if (P[0] = $7F) or (P[0] = $FF) then
    Result := 0   // IEEE-754 NaN
  else
  begin
    temp := (P[0] shl 24) or (P[1] shl 16) or (P[2] shl 8) or (P[3]);
    move(temp, Result, 4);
  end;

end;

function InvertF64(X: int64): double;
var
  P: PbyteArray;
  temp: int64;
begin
  P := @X;

  if (P[0] = $7F) or (P[0] = $FF) then
    Result := 0   // IEEE-754 NaN
  else
  begin
    temp := 4294967296 * ((P[0] shl 24) or (P[1] shl 16) or (P[2] shl 8) or (P[3])) +
      ((P[4] shl 24) or (P[5] shl 16) or (P[6] shl 8) or (P[7]));
    move(temp, Result, 8);
  end;

end;

procedure DToS(t: double; var h, m, s: integer);
var
  dd, min1, min, sec: double;
begin
  dd := Int(t);
  min1 := abs(t - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(t);
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.95 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  h := round(dd);
  m := round(min);
  s := round(sec);
end;

function DEToStr(de: double): string;
var
  dd, min1, min, sec: double;
  d, m, s: string;
begin

  dd := Int(de);
  min1 := abs(de - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(de);
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.5 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;

  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 2: 0, s);

  if abs(sec) < 9.5 then
    s := '0' + trim(s);

  Result := d + ldeg + m + lmin + s + lsec;
end;

function DEToStr3(de: double): string;
var
  dd, min1, min, sec: double;
  d, m, s: string;
begin
  dd := Int(de);
  min1 := abs(de - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(de);
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.5 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;

  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 2: 0, s);

  if abs(sec) < 9.5 then
    s := '0' + trim(s);

  Result := d + 'd' + m + 'm' + s + 's';
end;

function DEToStr4(de: double): string;
var
  dd, min1, min, sec: double;
  d, m, s: string;
begin
  dd := Int(de);
  min1 := abs(de - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(de);
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.5 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;

  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 2: 0, s);

  if abs(sec) < 9.5 then
    s := '0' + trim(s);

  Result := d + '°' + m + '''' + s + '"';
end;

function TimToStr(tim: double; sep: string = ':'; showsec: boolean = True): string;
var
  dd, min1, min, sec: double;
  d, m, s: string;
begin

  dd := Int(tim);
  min1 := abs(tim - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(tim);
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.5 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 2: 0, s);

  if abs(sec) < 9.5 then
    s := '0' + trim(s);

  if showsec then
    Result := d + sep + m + sep + s
  else
    Result := d + sep + m;

end;

function StrToTim(tim: string; sep: string = ':'): double;
var
  s, p: integer;
  t: string;
begin

  try

    tim := StringReplace(tim, blank, '0', [rfReplaceAll]);

    if copy(tim, 1, 1) = '-' then
      s := -1
    else
      s := 1;

    p := pos(sep, tim);

    if p = 0 then
      Result := StrToFloatDef(tim, -99)
    else
    begin
      t := copy(tim, 1, p - 1);
      Delete(tim, 1, p);
      Result := StrToIntDef(t, 0);
      p := pos(sep, tim);

      if p = 0 then
        Result := Result + s * StrToIntDef(tim, 0) / 60
      else
      begin
        t := copy(tim, 1, p - 1);
        Delete(tim, 1, p);
        Result := Result + s * StrToIntDef(t, 0) / 60;
        Result := Result + s * StrToFloatDef(tim, 0) / 3600;
      end;

    end;

  except
    Result := 0;
  end;

end;

function Date2Str(y, m, d: integer; yadbc: boolean = True): string;
var
  buf: string;
begin

  if yadbc then
    Result := YearADBC(y)
  else
    Result := IntToStr(y);

  str(m: 2, buf);

  if m < 10 then
    buf := '0' + trim(buf);

  Result := Result + '-' + buf;
  str(d: 2, buf);

  if d < 10 then
    buf := '0' + trim(buf);

  Result := Result + '-' + buf;
end;

function YearADBC(year: integer): string;
begin

  if year > 0 then
    Result := IntToStr(year)
  else
    Result := 'BC' + IntToStr(-year + 1);

end;

function ARToStr(ar: double): string;
var
  dd, min1, min, sec: double;
  d, m, s: string;
begin

  dd := Int(ar);
  min1 := abs(ar - dd) * 60;

  if min1 >= 59.999166667 then
  begin
    dd := dd + sgn(ar);

    if dd = 24 then
      dd := 0;

    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.95 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(dd: 3: 0, d);
  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 4: 1, s);

  if abs(sec) < 9.95 then
    s := '0' + trim(s);

  Result := d + 'h' + m + 'm' + s + 's';
end;

function ARToStrShort(ar: double; digits: integer = 1): string;
var
  dd, min1, min, sec: double;
  sg, d, m, s: string;
begin

  if ar >= 0 then
    sg := ''
  else
    sg := '-';

  ar := abs(ar);
  dd := Int(ar);
  min1 := abs(ar - dd) * 60;

  if min1 >= 59.999166667 then
  begin
    dd := dd + sgn(ar);

    if dd = 24 then
      dd := 0;

    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.95 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(dd: 3: 0, d);
  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 4: digits, s);

  if abs(sec) < 9.95 then
    s := '0' + trim(s);

  Result := sg;

  if dd <> 0 then
    Result := Result + d + 'h';

  if min <> 0 then
    Result := Result + m + 'm';

  Result := Result + s + 's';
end;

function DEToStrShort(de: double; digits: integer = 1): string;
var
  dd, min1, min, sec: double;
  sg, d, m, s: string;
begin

  if de >= 0 then
    sg := ''
  else
    sg := '-';

  de := abs(de);
  dd := Int(de);
  min1 := abs(de - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(de);
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.5 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;

  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 2: digits, s);

  if abs(sec) < 9.5 then
    s := '0' + trim(s);

  Result := sg;

  if dd <> 0 then
    Result := Result + d + ldeg;

  if min <> 0 then
    Result := Result + m + lmin;

  Result := Result + s + lsec;
end;


function DEpToStr(de: double; precision: integer = 1): string;
var
  dd, min1, min, sec, p, pmin, psec: double;
  d, m, s: string;
begin

  case precision of
    0: p := 0.5;
    1: p := 0.95;
    2: p := 0.995;
    else
    begin
      precision := 1;
      p := 0.995;
    end;

  end;

  psec := 59 + p;
  pmin := 59 + psec / 60;
  dd := Int(de);
  min1 := abs(de - dd) * 60;

  if min1 >= pmin then
  begin
    dd := dd + sgn(de);
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= psec then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;

  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 4: precision, s);

  if abs(sec) < 9.95 then
    s := '0' + trim(s)
  else
    s:=trim(s);

  Result := d + ldeg + m + lmin + s + lsec;
end;

function ARpToStr(ar: double; precision: integer = 1): string;
var
  dd, min1, min, sec, p, pmin, psec: double;
  d, m, s: string;
begin

  case precision of
    0: p := 0.95;
    1: p := 0.995;
    2: p := 0.9995;
    else
    begin
      precision := 1;
      p := 0.995;
    end;

  end;

  psec := 59 + p;
  pmin := 59 + psec / 60;
  dd := Int(ar);
  min1 := abs(ar - dd) * 60;

  if min1 >= pmin then
  begin
    dd := dd + sgn(ar);

    if dd = 24 then
      dd := 0;

    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= psec then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  if ar < 0 then
    d := '-' + d
  else
    d := blank + d;

  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 5: precision + 1, s);

  if abs(sec) < 9.995 then
    s := '0' + trim(s)
  else
    s:=trim(s);

  Result := d + 'h' + m + 'm' + s + 's';
end;

function DEmToStr(de: double): string;
var
  dd, min: double;
  d, m: string;
begin
  dd := Int(de);
  min := abs(de - dd) * 60;

  if min >= 59.5 then
  begin
    dd := dd + sgn(de);
    min := 0.0;
  end;

  min := Round(min);
  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;

  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  Result := d + ldeg + m + lmin;
end;

function DEdToStr(de: double): string;
var
  dd: double;
  d: string;
begin
  dd := round(de);
  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;

  Result := d + ldeg;
end;

function DEToStrmin(de: double): string;
var
  dd: double;
  d: string;
begin

  if de <= 0 then
    Result := '0'
  else
  if de < 1 then
  begin
    str((de * 60): 2: 0, d);
    Result := d + lmin;
  end
  else
  begin
    dd := round(de);
    str(dd: 2: 0, d);
    Result := d;
  end;

end;

function ARmToStr(ar: double): string;
var
  dd, min: double;
  d, m: string;
begin
  dd := Int(ar);
  min := abs(ar - dd) * 60;

  if min >= 59.5 then
  begin
    dd := dd + sgn(ar);

    if dd = 24 then
      dd := 0;

    min := 0.0;
  end;

  min := Round(min);
  str(dd: 3: 0, d);
  str(min: 2: 0, m);

  if abs(min) < 9.5 then
    m := '0' + trim(m);

  Result := d + 'h' + m + 'm';
end;

function DEToStr2(de: double; var d, m, s: string): string;
var
  dd, min1, min, sec: double;
begin
  dd := Int(de);
  min1 := abs(de - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(de);
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.5 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(abs(dd): 2: 0, d);

  if abs(dd) < 10 then
    d := '0' + trim(d);

  if de < 0 then
    d := '-' + d
  else
    d := '+' + d;

  str(min: 2: 0, m);

  if abs(min) < 10 then
    m := '0' + trim(m);

  str(sec: 2: 0, s);

  if abs(sec) < 9.5 then
    s := '0' + trim(s);

  Result := d + ldeg + m + lmin + s + lsec;
end;

function ARToStr2(ar: double; var d, m, s: string): string;
var
  dd, min1, min, sec: double;
begin

  dd := Int(ar);
  min1 := abs(ar - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(ar);
    if dd = 24 then
      dd := 0;
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.95 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(dd: 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  str(min: 2: 0, m);
  if abs(min) < 10 then
    m := '0' + trim(m);
  str(sec: 2: 0, s);
  if abs(sec) < 9.5 then
    s := '0' + trim(s);
  Result := d + 'h' + m + 'm' + s + 's';
end;

function ARToStr4(ar: double; f: string; var d, m, s: string): string;
var
  dd, min1, min, sec: double;
begin

  dd := Int(ar);
  min1 := abs(ar - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(ar);
    if dd = 24 then
      dd := 0;
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.95 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(dd: 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  str(min: 2: 0, m);
  if abs(min) < 10 then
    m := '0' + trim(m);
  s := FormatFloat(f, sec);
  Result := d + 'h' + m + 'm' + s + 's';
end;

function ARToStr3(ar: double): string;
var
  dd, min1, min, sec: double;
  d, m, s: string;
begin
  dd := Int(ar);
  min1 := abs(ar - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(ar);
    if dd = 24 then
      dd := 0;
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.5 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(dd: 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  str(min: 2: 0, m);
  if abs(min) < 10 then
    m := '0' + trim(m);
  str(sec: 2: 0, s);
  if abs(sec) < 9.5 then
    s := '0' + trim(s);
  Result := d + 'h' + m + 'm' + s + 's';
end;

function Str3ToAR(dms : string): double;
type tseplist=array[1..3] of string;
var s,p : integer;
    t : string;
    sep: tseplist;
const
    sep1: tseplist = ('h','m','s');
    sep2: tseplist = (':',':',':');
    sep3: tseplist = (' ',' ',' ');
begin
try
  if copy(dms,1,1)='-' then s:=-1 else s:=1;
  sep:=sep1;
  p:=pos(sep[1],dms);
  if p=0 then begin
    sep:=sep2;
    p:=pos(sep[1],dms);
  end;
  if p=0 then begin
    sep:=sep3;
    p:=pos(sep[1],dms);
  end;
  if p=0 then
    result:=StrToFloatDef(trim(dms),-9999)
  else begin
    t:=copy(dms,1,p-1); delete(dms,1,p);
    result:=StrToFloatDef(trim(t),0);
    p:=pos(sep[2],dms);
    if p=0 then
      result:=result+ s * StrToFloatDef(trim(dms),0) / 60
    else begin
      t:=copy(dms,1,p-1); delete(dms,1,p);
      result:=result+ s * StrToFloatDef(trim(t),0) / 60;
      dms:=StringReplace(dms,' ','',[rfReplaceAll]);
      p:=pos(sep[3],dms);
      if p=0 then
        t:=dms
      else
        t:=copy(dms,1,p-1);
      result:=result+ s * StrToFloatDef(trim(t),0) / 3600;
    end;
  end;
except
result:=-9999;
end;
end;

function Str3ToDE(dms : string): double;
type tseplist=array[1..3] of string;
var s,p,d1 : integer;
    t : string;
    sep: tseplist;
const
    sep1: tseplist = ('d','m','s');
    sep2: tseplist = ('°','''','"');
    sep3: tseplist = (#176,'''','"');
    sep4: tseplist = (':',':',':');
    sep5: tseplist = (' ',' ',' ');
begin
try
  dms:=StringReplace(dms,ldeg,'d',[]);
  dms:=StringReplace(dms,lmin,'m',[]);
  dms:=StringReplace(dms,lsec,'s',[]);
  if copy(dms,1,1)='-' then s:=-1 else s:=1;
  sep:=sep1;
  d1:=length(sep[1])-1;
  p:=pos(sep[1],dms);
  if p=0 then begin
    sep:=sep2;
    d1:=length(sep[1])-1;
    p:=pos(sep[1],dms);
  end;
  if p=0 then begin
    sep:=sep3;
    d1:=length(sep[1])-1;
    p:=pos(sep[1],dms);
  end;
  if p=0 then begin
    sep:=sep4;
    d1:=length(sep[1])-1;
    p:=pos(sep[1],dms);
  end;
  if p=0 then begin
    sep:=sep5;
    d1:=length(sep[1])-1;
    p:=pos(sep[1],dms);
  end;
  if p=0 then
    result:=StrToFloatDef(trim(dms),-9999)
  else begin
    t:=copy(dms,1,p-1); delete(dms,1,p+d1);
    result:=StrToFloatDef(trim(t),0);
    p:=pos(sep[2],dms);
    if p=0 then
      result:=result+ s * StrToFloatDef(trim(dms),0) / 60
    else begin
      t:=copy(dms,1,p-1); delete(dms,1,p);
      result:=result+ s * StrToFloatDef(trim(t),0) / 60;
      p:=pos(sep[3],dms);
      if p=0 then
        t:=dms
      else
        t:=copy(dms,1,p-1);
      result:=result+ s * StrToFloatDef(trim(t),0) / 3600;
    end;
  end;
except
 result:=-9999;
end;
end;

function NumericStr(txt:string):string;
var i,n: integer;
    c: char;
begin
  // keep only numeric character, keep space between number
  // 'RA center: 20h32m53s.10' -> '20 32 53 .10'
  result:='';
  for i:=1 to length(txt) do begin
    c:=txt[i];
    if ((c>='0')and(c<='9'))or(c='.')or(c='+')or(c='-') then
      result:=result+c
    else
      result:=result+' ';
  end;
  result:=wordspace(result);
end;

procedure Str2RaDec(txt: string; out ra,de: double);
var buf,buf1,buf2: string;
    i,p,s: integer;
    lst: TStringList;
begin
//  Format example:
//  RA: 02h53m29.7s DE:+16°11'49.5"
//  11h22m33.3s +30°10'20"
//  +30°10'20" 11h22m33.3s
//  11:22:33.3 +30:10:20
//  11 22 33.3 +30 10 20
//  11:22 +30:10
//  11 22 +30 10
//  11.5 -30.1
//  11 30 -30.1

  lst:=TStringList.Create;
  try
  txt:=trim(NumericStr(txt));
  buf1:='';
  buf2:='';
  Splitarg(txt,' ',lst);
  if lst.Count=2 then begin // ra dec in two words
    buf1:=trim(lst[0]);
    buf2:=trim(lst[1]);
    if (copy(buf1,1,1)='+')or(copy(buf1,1,1)='-') then begin // dec first
      buf:=buf1;
      buf1:=buf2;
      buf2:=buf;
    end;
  end
  else begin
    s:=-1;
    for i:=1 to lst.Count-1 do begin  // skip first word, this cannot work with dec first
       if (copy(lst[i],1,1)='+') or (copy(lst[i],1,1)='-') then s:=i; // word with sign is first of dec
    end;
    if s<0 then
      s:=lst.Count div 2; // no sign, assume same number of word for ra and dec
    for i:=0 to s-1 do
      buf1:=buf1+' '+lst[i];
    for i:=s to lst.Count-1 do
      buf2:=buf2+' '+lst[i];
  end;

  ra:=Str3ToAR(trim(buf1));
  de:=Str3ToDE(trim(buf2));

  finally
   lst.free
  end;
end;

function isodate(a, m, d: integer): string;
begin
  Result :=
    padzeros(IntToStr(a), 4) + '-' + padzeros(IntToStr(m), 2) + '-' +
    padzeros(IntToStr(d), 2);
end;

procedure iso2date(dt: string; out a, m, d: integer);
begin
  a:=StrToIntDef(copy(dt,1,4),0);
  m:=StrToIntDef(copy(dt,6,2),0);
  d:=StrToIntDef(copy(dt,9,2),0);
end;

function jddatetime(jd: double; fy, fm, fd, fh, fn, fs: boolean): string;
var
  a, m, d: integer;
  h: double;
  hd, hm, hs, sep: string;
begin

  djd(jd, a, m, d, h);
  ARToStr2(h, hd, hm, hs);

  Result := '';
  sep := '';

  if fy then
  begin
    Result := Result + padzeros(IntToStr(a), 4);
    sep := '-';
  end;
  if fm then
  begin
    Result := Result + sep + padzeros(IntToStr(m), 2);
    sep := '-';
  end;
  if fd then
    Result := Result + sep + padzeros(IntToStr(d), 2);
  if Result > '' then
    sep := blank;
  if fh then
  begin
    Result := Result + sep + hd;
    sep := ':';
  end;
  if fn then
  begin
    Result := Result + sep + hm;
    sep := ':';
  end;
  if fs then
    Result := Result + sep + hs;
end;

function jddate(jd: double): string;
var
  a, m, d: integer;
  h: double;
begin
  djd(jd, a, m, d, h);
  Result := isodate(a, m, d);
end;

function datejd(dt:string): double;
var
  a, m, d: integer;
begin
  iso2date(dt, a, m, d);
  result:=jd(a, m, d, 0);
end;

function jddate2(jd: double): string;
var
  a, m, d: integer;
  h: double;
begin
  djd(jd, a, m, d, h);

  Result := IntToStr(a) + padzeros(IntToStr(m), 2) + padzeros(IntToStr(d), 2) +
    '.' + TimToStr(h, '');
end;

function LeapYear(Year: longint): boolean;
begin
  if Year > 1582 then
    Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0))
  else
    Result := (Year mod 4 = 0);
end;

function DayofYear(y, m, d: integer): integer;
var
  k: integer;
begin

  if LeapYear(y) then
    k := 1
  else
    k := 2;

  Result := floor(275 * m / 9) - k * floor((m + 9) / 12) + d - 30;
end;

function DateTimetoJD(date: Tdatetime): double;
var
  Year, Month, Day: word;
begin
  DecodeDate(Date, Year, Month, Day);
  Result := jd(Year, Month, Day, frac(date) * 24);
end;

function LONToStr(l: double): string;
var
  dd, min1, min, sec: double;
  d, m, s: string;
begin
  dd := Int(l);
  min1 := abs(l - dd) * 60;

  if min1 >= 59.99166667 then
  begin
    dd := dd + sgn(l);
    if dd = 360 then
      dd := 0;
    min1 := 0.0;
  end;

  min := Int(min1);
  sec := (min1 - min) * 60;

  if sec >= 59.5 then
  begin
    min := min + 1;
    sec := 0.0;
  end;

  str(abs(dd): 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  if l < 0 then
    d := '-' + d;
  str(min: 2: 0, m);
  if abs(min) < 10 then
    m := '0' + trim(m);
  str(sec: 2: 0, s);
  if abs(sec) < 9.5 then
    s := '0' + trim(s);
  Result := d + ldeg + m + lmin + s + lsec;
end;

function LONmToStr(l: double): string;
var
  dd, min: double;
  d, m: string;
begin

  dd := Int(l);
  min := abs(l - dd) * 60;

  if min >= 59.5 then
  begin
    dd := dd + sgn(l);
    if dd = 360 then
      dd := 0;
    min := 0.0;
  end;

  min := Round(min);
  str(abs(dd): 2: 0, d);
  if abs(dd) < 10 then
    d := '0' + trim(d);
  if l < 0 then
    d := '-' + d;
  str(min: 2: 0, m);
  if abs(min) < 10 then
    m := '0' + trim(m);
  Result := d + ldeg + m + lmin;
end;

function SetCurrentTime(cfgsc: Tconf_skychart): boolean;
var
  y, m, d: word;
  n: TDateTime;
begin
  n := cfgsc.tz.NowLocalTime;
  decodedate(n, y, m, d);
  cfgsc.CurYear := y;
  cfgsc.CurMonth := m;
  cfgsc.CurDay := d;
  cfgsc.CurTime := frac(n) * 24;
  cfgsc.TimeZone := cfgsc.tz.SecondsOffset / 3600;
  Result := True;
end;

function DTminusUT(year, month, day: integer; c: Tconf_skychart): double;
var
  i: integer;
  y, u, v, t, jdd: double;
begin
  c.ObsXP:=0;
  c.ObsYP:=0;
  if c.Force_DT_UT then
    Result := c.DT_UT_val
  else
  begin
    y := year + (month - 1) / 12 + (day - 1) / 365.25;
    if (numdeltat=0)or(y<deltat[0,0])or(y>=deltat[numdeltat-1,0]) then
       result:=DTminusUTComp(year, month, day, c)
    else begin
       jdd:=jd(year,month,day,23.9999999-c.TimeZone);
       if (numleapseconds>0)and(leapsecondexpires>0)and(jdd>leapseconds[0,0])and(jdd<leapsecondexpires) then begin
         for i:=numleapseconds-1 downto 0 do begin
           result:=leapseconds[i,1];
           if jdd>leapseconds[i,0] then break;
         end;
         jdd:=trunc(jd(year,month,day,0));
         if (numiers>0)and(jdd>=iers[0,0])and(jdd<=iers[numiers-1,0]) then begin
           i:=round(jdd-iers[0,0]);
           result:=result-iers[i,1];
           c.ObsXP:=iers[i,2];
           c.ObsYP:=iers[i,3];
         end;
         result:=(result+32.184)/3600;
       end
       else begin
         for i:=0 to numdeltat-1 do begin
           if y<deltat[i,0] then begin
              u:=(y-deltat[i-1,0])/(deltat[i,0]-deltat[i-1,0]);
              v:=deltat[i,1]-deltat[i-1,1];
              result:=(deltat[i-1,1]+v*u)/3600;
              break;
           end;
         end;
       end;
    end;
  end;
end;

function DTminusUTError(year, month, day: integer; c: Tconf_skychart): double;
var
  i: integer;
  y, u, v, t, jdd: double;
begin
  y := year + (month - 1) / 12 + (day - 1) / 365.25;
  if (numdeltat=0)or(y<deltat[0,0])or(y>=deltat[numdeltat-1,0]) then
     result:=DTminusUTErrorComp(year, month, day, c)
  else begin
    jdd:=jd(year,month,day,23.9999999-c.TimeZone);
    if (numleapseconds>0)and(leapsecondexpires>0)and(jdd>leapseconds[0,0])and(jdd<leapsecondexpires) then begin
      result:=0;
    end
    else begin
     for i:=0 to numdeltat-1 do begin
       if y<deltat[i,0] then begin
          result:=deltat[i-1,2];
          break;
       end;
     end;
    end;
  end;
end;

function DTminusUTComp(year, month, day: integer; c: Tconf_skychart): double;
// This function is used only out of the interval of the deltat file
// currently available from 1657 to 2027
var
  y, u, t: double;
  i,n: integer;
const
 // These coefficients reproduce the spline approximation discussed by
 // L.V. Morrison, F.R. Stephenson, C.Y. Hohenkerk and M. Zawilski, Addendum 2020 to Measurement of the Earth's Rotation: 720 BC to AD 2015
 // published in the Royal Society Proceedings A, 478, 2021, see https://doi.org/10.1098/rspa.2020.0776
  tl = 58;
  pc : array[1..tl,1..6] of double = (
   (-720.0 ,  -100.0 , 20371.848 , -9999.586 ,   776.247 ,   409.160),
   (-100.0 ,   400.0 , 11557.668 , -5822.270 ,  1303.151 ,  -503.433),
   ( 400.0 ,  1000.0 ,  6535.116 , -5671.519 ,  -298.291 ,  1085.087),
   (1000.0 ,  1150.0 ,  1650.393 ,  -753.210 ,   184.811 ,   -25.346),
   (1150.0 ,  1300.0 ,  1056.647 ,  -459.628 ,   108.771 ,   -24.641),
   (1300.0 ,  1500.0 ,   681.149 ,  -421.345 ,    61.953 ,   -29.414),
   (1500.0 ,  1600.0 ,   292.343 ,  -192.841 ,    -6.572 ,    16.197),
   (1600.0 ,  1650.0 ,   109.127 ,   -78.697 ,    10.505 ,     3.018),
   (1650.0 ,  1720.0 ,    43.952 ,   -68.089 ,    38.333 ,    -2.127),
   (1720.0 ,  1800.0 ,    12.068 ,     2.507 ,    41.731 ,   -37.939),
   (1800.0 ,  1810.0 ,    18.367 ,    -3.481 ,    -1.126 ,     1.918),
   (1810.0 ,  1820.0 ,    15.678 ,     0.021 ,     4.629 ,    -3.812),
   (1820.0 ,  1830.0 ,    16.516 ,    -2.157 ,    -6.806 ,     3.250),
   (1830.0 ,  1840.0 ,    10.804 ,    -6.018 ,     2.944 ,    -0.096),
   (1840.0 ,  1850.0 ,     7.634 ,    -0.416 ,     2.658 ,    -0.539),
   (1850.0 ,  1855.0 ,     9.338 ,     1.642 ,     0.261 ,    -0.883),
   (1855.0 ,  1860.0 ,    10.357 ,    -0.486 ,    -2.389 ,     1.558),
   (1860.0 ,  1865.0 ,     9.040 ,    -0.591 ,     2.284 ,    -2.477),
   (1865.0 ,  1870.0 ,     8.255 ,    -3.456 ,    -5.148 ,     2.720),
   (1870.0 ,  1875.0 ,     2.371 ,    -5.593 ,     3.011 ,    -0.914),
   (1875.0 ,  1880.0 ,    -1.126 ,    -2.314 ,     0.269 ,    -0.039),
   (1880.0 ,  1885.0 ,    -3.210 ,    -1.893 ,     0.152 ,     0.563),
   (1885.0 ,  1890.0 ,    -4.388 ,     0.101 ,     1.842 ,    -1.438),
   (1890.0 ,  1895.0 ,    -3.884 ,    -0.531 ,    -2.474 ,     1.871),
   (1895.0 ,  1900.0 ,    -5.017 ,     0.134 ,     3.138 ,    -0.232),
   (1900.0 ,  1905.0 ,    -1.977 ,     5.715 ,     2.443 ,    -1.257),
   (1905.0 ,  1910.0 ,     4.923 ,     6.828 ,    -1.329 ,     0.720),
   (1910.0 ,  1915.0 ,    11.142 ,     6.330 ,     0.831 ,    -0.825),
   (1915.0 ,  1920.0 ,    17.479 ,     5.518 ,    -1.643 ,     0.262),
   (1920.0 ,  1925.0 ,    21.617 ,     3.020 ,    -0.856 ,     0.008),
   (1925.0 ,  1930.0 ,    23.789 ,     1.333 ,    -0.831 ,     0.127),
   (1930.0 ,  1935.0 ,    24.418 ,     0.052 ,    -0.449 ,     0.142),
   (1935.0 ,  1940.0 ,    24.164 ,    -0.419 ,    -0.022 ,     0.702),
   (1940.0 ,  1945.0 ,    24.426 ,     1.645 ,     2.086 ,    -1.106),
   (1945.0 ,  1950.0 ,    27.050 ,     2.499 ,    -1.232 ,     0.614),
   (1950.0 ,  1953.0 ,    28.932 ,     1.127 ,     0.220 ,    -0.277),
   (1953.0 ,  1956.0 ,    30.002 ,     0.737 ,    -0.610 ,     0.631),
   (1956.0 ,  1959.0 ,    30.760 ,     1.409 ,     1.282 ,    -0.799),
   (1959.0 ,  1962.0 ,    32.652 ,     1.577 ,    -1.115 ,     0.507),
   (1962.0 ,  1965.0 ,    33.621 ,     0.868 ,     0.406 ,     0.199),
   (1965.0 ,  1968.0 ,    35.093 ,     2.275 ,     1.002 ,    -0.414),
   (1968.0 ,  1971.0 ,    37.956 ,     3.035 ,    -0.242 ,     0.202),
   (1971.0 ,  1974.0 ,    40.951 ,     3.157 ,     0.364 ,    -0.229),
   (1974.0 ,  1977.0 ,    44.244 ,     3.199 ,    -0.323 ,     0.172),
   (1977.0 ,  1980.0 ,    47.291 ,     3.069 ,     0.193 ,    -0.192),
   (1980.0 ,  1983.0 ,    50.361 ,     2.878 ,    -0.384 ,     0.081),
   (1983.0 ,  1986.0 ,    52.936 ,     2.354 ,    -0.140 ,    -0.165),
   (1986.0 ,  1989.0 ,    54.984 ,     1.577 ,    -0.637 ,     0.448),
   (1989.0 ,  1992.0 ,    56.373 ,     1.648 ,     0.708 ,    -0.276),
   (1992.0 ,  1995.0 ,    58.453 ,     2.235 ,    -0.121 ,     0.110),
   (1995.0 ,  1998.0 ,    60.678 ,     2.324 ,     0.210 ,    -0.313),
   (1998.0 ,  2001.0 ,    62.898 ,     1.804 ,    -0.729 ,     0.109),
   (2001.0 ,  2004.0 ,    64.083 ,     0.674 ,    -0.402 ,     0.199),
   (2004.0 ,  2007.0 ,    64.553 ,     0.466 ,     0.194 ,    -0.017),
   (2007.0 ,  2010.0 ,    65.197 ,     0.804 ,     0.144 ,    -0.084),
   (2010.0 ,  2013.0 ,    66.061 ,     0.839 ,    -0.109 ,     0.128),
   (2013.0 ,  2016.0 ,    66.920 ,     1.007 ,     0.277 ,    -0.095),
   (2016.0 ,  2019.0 ,    68.109 ,     1.277 ,    -0.007 ,    -0.139)
    );
begin
    { Reference  :
    NASA TP-2006-214141
    Five Millennium Canon of Solar Eclipses: -1999 to +3000 (2000 BCE to 3000 CE)
    Fred Espenak and Jean Meeus
    }

    y := year + (month - 1) / 12 + (day - 1) / 365.25;

    case year of

      minyeardt.. -721:
      begin    // parabola from Espenak and JPL Horizon
        u := (y - 1820) / 100;
        Result := (-20 + 32 * u * u) / 3600;
      end;

      -720 .. 2018:
      //L.V. Morrison, F.R. Stephenson, C.Y. Hohenkerk and M. Zawilski, Addendum 2020 to Measurement of the Earth's Rotation: 720 BC to AD 2015
      //published in the Royal Society Proceedings A, 478, 2021, see https://doi.org/10.1098/rspa.2020.0776
      begin
        for i:=1 to tl do begin
          if (year>=pc[i,1]) and (year<pc[i,2]) then begin
            n:=i;
            break;
          end;
        end;
        t := (y - pc[n,1]) / (pc[n,2] - pc[n,1]);
        Result := (pc[n,3] + pc[n,4]*t + pc[n,5]*t**2 + pc[n,6]*t**3) / 3600;
      end;

      2019..2021:
      begin
        Result := 69.18 / 3600;
      end;

      2022..2026:
      begin
        t := y - 2022;                // 2022.0 -> 69.18
        Result := (69.18 + t * 0.8) / 3600;  // (73-69)/5 = 0.8
      end;

      2027..2049:
      begin
        t := y - 2000;                // 2027.0 -> 73.32
        //2005-2050: result:=(62.92+t*(0.32217+t*(0.005589)))/3600;
        // > 2027 : 62.92+(0.32217*25)+(0.005589*25^2)=75.69
        // 62.92-75.69+73 = 60.23
        Result := (60.23 + t * (0.32217 + t * (0.005589))) / 3600;
      end;

      2050..2149:
      begin
        u := (y - 1820) / 100;
        t := 2150 - y;
        Result := (-20 + 32 * u * u - 0.5788 * t) / 3600;
      end;

      2150..maxyeardt:
      begin    // parabola from Espenak and JPL Horizon
        u := (y - 1820) / 100;
        Result := (-20 + 32 * u * u) / 3600;
      end;

      else
        Result := 0;
        // we don't need deltat for very distant epoch as there is no available ephemeris
    end;

end;

function DTminusUTErrorComp(year, month, day: integer; c: Tconf_skychart): double;
const
  M = 2500;
  Q = 0.058;
var
  n, y: double;

begin

  y := year + (month - 1) / 12 + (day - 1) / 365.25;

  case year of

    minyeardt.. -501:
    begin
      n := abs(y + 500);
      Result := 365.25 * n * sqrt((n * Q / 3) * (1 + n / M)) / 1000;
    end;
    -500..1800:
    begin
      n := abs(y - 1820) / 100;
      Result := 0.8 * n * n;
    end;

    1801..2026:
    begin
      Result := 0;
    end;

    2027..maxyeardt:
    begin
      n := abs(y - 2000);
      Result := 365.25 * n * sqrt((n * Q / 3) * (1 + n / M)) / 1000;
    end;

    else
      Result := 0;
  end;

end;

function RotateBits(C: char; Bits: integer): char;
var
  SI: word;
begin
  Bits := Bits mod 8;
  // Are we shifting left?
  if Bits < 0 then
  begin
    // Put the data on the right half of a Word (2 bytes)
    SI := word(C);
    //      SI := MakeWord(Byte(C),0);
    // Now shift it left the appropriate number of bits
    SI := SI shl Abs(Bits);
  end
  else
  begin
    // Put the data on the left half of a Word (2 bytes)
    SI := word(C) shl 8;
    //      SI := MakeWord(0,Byte(C));
    // Now shift it right the appropriate number of bits
    SI := SI shr Abs(Bits);
  end;
  // Finally, Swap the bytes
  SI := Swap(SI);
  // And OR the two halves together
  SI := Lo(SI) or Hi(SI);
  Result := Chr(SI);
end;

function EncryptStr(Str, Pwd: string; Encode: boolean = True): string;
var
  a, PwdChk, Direction, ShiftVal, PasswordDigit: integer;
begin

  if Encode then
    str := str + blank15;

  PasswordDigit := 1;
  PwdChk := 0;

  for a := 1 to Length(Pwd) do
    Inc(PwdChk, Ord(Pwd[a]));
  Result := Str;

  if Encode then
    Direction := -1
  else
    Direction := 1;
  for a := 1 to Length(Result) do
  begin
    if Length(Pwd) = 0 then
      ShiftVal := a
    else
      ShiftVal := Ord(Pwd[PasswordDigit]);

    if Odd(A) then
      Result[A] := RotateBits(Result[A], -Direction * (ShiftVal + PwdChk))
    else
      Result[A] := RotateBits(Result[A], Direction * (ShiftVal + PwdChk));

    Inc(PasswordDigit);

    if PasswordDigit > Length(Pwd) then
      PasswordDigit := 1;
  end;
end;

function DecryptStr(Str, Pwd: string): string;
begin
  Result := trim(EncryptStr(Str, Pwd, False));
end;

function strtohex(str: string): string;
var
  i: integer;
begin

  Result := '';

  if str = '' then
    exit;

  for i := 1 to length(str) do
    Result := Result + inttohex(Ord(str[i]), 2);
end;

function hextostr(str: string): string;
var
  i, k: integer;
begin

  Result := '';

  if str = '' then
    exit;

  for i := 0 to (length(str) - 1) div 2 do
  begin

    k := strtointdef('$' + str[2 * i + 1] + str[2 * i + 2], -1);

    if k > 0 then
      Result := Result + char(k)
    else
    begin
      Result := str;   // if not numeric default to the input string
      break;
    end;

  end;

end;

procedure FormPos(form: TForm; x, y: integer; safemargin: boolean = True);
var
  margin: integer; //minimal distance from screen border
begin
  if safemargin then
    margin:=60
  else
    margin:=0;
  with Form do
  begin
    if x > margin then
      left := x
    else
      left := margin;

    if left + Width > (Screen.Width - margin) then
      left := Screen.Width - Width - margin;
    if left < 0 then
      left := 0;

    if y > margin then
      top := y
    else
      top := margin;

    if top + Height > (Screen.Height - margin) then
      top := Screen.Height - Height - margin;
    if top < 0 then
      top := 0;
  end;

end;

function ExecProcess(cmd: string; output: TStringList;
  ShowConsole: boolean = False): integer;
const
  READ_BYTES = 2048;
var
  M: TMemoryStream;
  P: TProcess;
  param: TStringList;
  n: longint;
  BytesRead: longint;
begin

  M := TMemoryStream.Create;
  P := TProcess.Create(nil);

  param := TStringList.Create;
  Result := 1;

  try
    BytesRead := 0;
    {$IF (FPC_VERSION = 2) and (FPC_RELEASE < 5)}
    P.CommandLine := cmd;
    {$ELSE}
    SplitCmd(cmd, param);
    cmd := param[0];
    param.Delete(0);
    P.Executable := cmd;
    P.Parameters := param;
    {$ENDIF}

    if ShowConsole then
    begin
      P.ShowWindow := swoShowNormal;
      P.StartupOptions := [suoUseShowWindow];
    end
    else
      P.ShowWindow := swoHIDE;

    P.Options := [poUsePipes, poStdErrToOutPut];
    P.Execute;

    while P.Running do
    begin
      Application.ProcessMessages;
      if P.Output <> nil then
      begin
        M.SetSize(BytesRead + READ_BYTES);
        n := P.Output.Read((M.Memory + BytesRead)^, READ_BYTES);
        if n > 0 then
          Inc(BytesRead, n);
      end;
    end;

    Result := P.ExitStatus;
    if (Result <> 127) and (P.Output <> nil) then
      repeat
        M.SetSize(BytesRead + READ_BYTES);
        n := P.Output.Read((M.Memory + BytesRead)^, READ_BYTES);

        if n > 0 then
          Inc(BytesRead, n);

      until (n <= 0) or (P.Output = nil);

    M.SetSize(BytesRead);
    output.LoadFromStream(M);

    P.Free;
    M.Free;
    param.Free;

  except
    on E: Exception do
    begin
      Result := -1;
      output.add(E.Message);
      P.Free;
      M.Free;
      param.Free;
    end;

  end;

end;

{$ifdef unix}
function Exec(cmd: string; hide: boolean = True): integer;
begin
  Result := fpSystem(cmd);
end;

{$endif}

{$ifdef mswindows}
function Exec(cmd: string; hide: boolean = True): integer;
var
  bchExec: array[0..1024] of char;
  pchEXEC: PChar;
  si: TStartupInfo;
  pi: TProcessInformation;
  res: cardinal;
begin
  pchExec := @bchExec;
  StrPCopy(pchExec, cmd);
  FillChar(si, sizeof(si), 0);
  FillChar(pi, sizeof(pi), 0);
  si.dwFlags := STARTF_USESHOWWINDOW;

  if hide then
    si.wShowWindow := SW_HIDE
  else
    si.wShowWindow := SW_SHOWNORMAL;
  si.cb := sizeof(si);

  try
    if CreateProcess(nil, pchExec, nil, nil, False, CREATE_NEW_CONSOLE or
      NORMAL_PRIORITY_CLASS, nil, nil, si, pi) = True then
    begin
      WaitForSingleObject(pi.hProcess, INFINITE);
      GetExitCodeProcess(pi.hProcess, Res);
      Result := res;
    end
    else
      Result := GetLastError;

  except
    Result := GetLastError;
  end;
end;

{$endif}

{$ifdef unix}
procedure ExecNoWait(cmd: string; title: string = ''; hide: boolean = True);
begin
  fpSystem(cmd + ' &');
end;

{$endif}

{$ifdef mswindows}
procedure ExecNoWait(cmd: string; title: string = ''; hide: boolean = True);
var
  bchExec: array[0..1024] of char;
  pchEXEC: PChar;
  si: TStartupInfo;
  pi: TProcessInformation;
begin
  pchExec := @bchExec;
  StrPCopy(pchExec, cmd);
  FillChar(si, sizeof(si), 0);
  FillChar(pi, sizeof(pi), 0);
  si.dwFlags := STARTF_USESHOWWINDOW;
  if title <> '' then
    si.lpTitle := PChar(title);
  if hide then
    si.wShowWindow := SW_SHOWMINIMIZED
  else
    si.wShowWindow := SW_SHOWNORMAL;
  si.cb := sizeof(si);
  writetrace('Try to launch ' + cmd);

  try
    CreateProcess(nil, pchExec, nil, nil, False, CREATE_NEW_CONSOLE or
      NORMAL_PRIORITY_CLASS, nil, nil, si, pi);
  except;
    writetrace('Could not launch ' + cmd);
  end;

end;

{$endif}

{$ifdef mswindows}
function ExecuteFile(const FileName: string): integer;
var
  zFileName, zParams, zDir: array[0..255] of char;
begin
  writetrace('Try to launch: ' + FileName);
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, ''),
    StrPCopy(zDir, ''), SW_SHOWNOACTIVATE);
end;

{$endif}

{$ifdef unix}
function ExecuteFile(const FileName: string): integer;
var
  cmd, p1, p2, p3, p4: string;
begin
  writetrace('Try to launch: ' + FileName);
  cmd := trim(words(OpenFileCMD, blank, 1, 1));
  p1 := trim(words(OpenFileCMD, blank, 2, 1));
  p2 := trim(words(OpenFileCMD, blank, 3, 1));
  p3 := trim(words(OpenFileCMD, blank, 4, 1));
  p4 := trim(words(OpenFileCMD, blank, 5, 1));

  if p1 = '' then
    Result := ExecFork(cmd, FileName)
  else if p2 = '' then
    Result := ExecFork(cmd, p1, FileName)
  else if p3 = '' then
    Result := ExecFork(cmd, p1, p2, FileName)
  else if p4 = '' then
    Result := ExecFork(cmd, p1, p2, p3, FileName)
  else
    Result := ExecFork(cmd, p1, p2, p3, p4, FileName);

end;

{$endif}

{$ifdef unix}
function ExecFork(cmd: string; p1: string = ''; p2: string = ''; p3: string = '';
  p4: string = ''; p5: string = ''): integer;
var
  parg: array[1..7] of PChar;
begin
  Result := fpFork;
  if Result = 0 then
  begin
    parg[1] := PChar(cmd);
    if p1 = '' then
      parg[2] := nil
    else
      parg[2] := PChar(p1);
    if p2 = '' then
      parg[3] := nil
    else
      parg[3] := PChar(p2);
    if p3 = '' then
      parg[4] := nil
    else
      parg[4] := PChar(p3);
    if p4 = '' then
      parg[5] := nil
    else
      parg[5] := PChar(p4);
    if p5 = '' then
      parg[6] := nil
    else
      parg[6] := PChar(p5);
    parg[7] := nil;
    writetrace('Try to launch ' + cmd + blank + p1 + blank + p2 + blank + p3 + blank + p4 + blank + p5);
    if fpExecVP(cmd, PPChar(@parg[1])) = -1 then
    begin
      writetrace('Could not launch ' + cmd);
    end;
  end;
end;

{$endif}

{$ifdef unix}
function CdcSigAction(const action: pointer): boolean;
var
  oa, na: psigactionrec;
begin
  Result := False;
  new(oa);
  new(na);
  na^.sa_Handler := SigActionHandler(action);
  fillchar(na^.Sa_Mask, sizeof(na^.sa_mask), #0);
  na^.Sa_Flags := 0;

  {$ifdef Linux}
  na^.Sa_Restorer := nil;
  {$endif}

  fpSigAction(SIGHUP, na, oa);

  if fpSigAction(SIGTerm, na, oa) <> 0 then
    Result := True;

  Dispose(oa);
  Dispose(na);
end;

{$endif}

function decode_mpc_date(s: string; var y, m, d: integer; var hh: double): boolean;
var
  c: char;
begin

  try

    c := s[1];

    case c of
      'I': y := 1800;
      'J': y := 1900;
      'K': y := 2000;
    end;

    y := y + StrToInt(copy(s, 2, 2));
    c := s[4];

    if c <= '9' then
      m := StrToInt(c)
    else
      m := Ord(c) - 55;

    c := s[5];

    if c <= '9' then
      d := StrToInt(c)
    else
      d := Ord(c) - 55;

    s := trim(copy(s, 6, 999));

    if s > '' then
      hh := strtofloat(trim(s))
    else
      hh := 0;

    Result := True;

  except
    Result := False;
  end;

end;

function encode_mpc_date(y, m, d: integer; hh: double; var s: string): boolean;
var
  buf: string;
  c: char;
begin

  result:=false;
  try
    buf:=inttostr(y);
    if copy(buf,1,2)='18' then s:='I'+copy(buf,3,2)
    else if copy(buf,1,2)='19' then s:='J'+copy(buf,3,2)
    else if copy(buf,1,2)='20' then s:='K'+copy(buf,3,2)
    else exit;

    if m<9 then s:=s+inttostr(m)
           else s:=s+chr(55+m);

    if d<9 then s:=s+inttostr(d)
           else s:=s+chr(55+d);

    if hh<>0 then s:=s+inttostr(trunc(frac(hh/24)*1000000));

    Result := True;

  except
    Result := False;
  end;

end;

function GreekLetter(gr: shortstring): shortstring;
var
  i: integer;
  buf, num: shortstring;
begin
  Result := '';

  i := pos('0', gr);

  if i = 0 then
  begin
    buf := copy(gr, 1, 3);
    num := copy(gr, 4, 1);
  end
  else
  begin
    buf := copy(gr, 1, i - 1);
    num := copy(gr, i + 1, 9);
  end;

  buf := lowercase(trim(copy(buf, 1, 3)));
  buf := StringReplace(buf, '.', '', []);

  for i := 1 to maxgreek do
  begin
    if buf = greeksymbol[1, i] then
    begin
      Result := greeksymbol[2, i] + num; // ome2 -> w2
      break;
    end;
  end;

end;

function GetId(str: string): integer;
var
  buf: shortstring;
  i, k: integer;
  v, w: extended;
begin
  buf := trim(str);
  k := length(buf);
  v := 0;

  for i := 0 to k - 1 do
    v := v + intpower(10, i) * Ord(buf[i]);

  w := 255 * intpower(10, k - 1) / maxint;

  if w > 1 then
    Result := trunc(v / w)
  else
    Result := trunc(v);
end;

procedure GetPrinterResolution(var Name: string; var resol: integer);
begin
  if GetPrinterIndex >= 0 then
  begin
    Name := Printer.Printers[Printer.PrinterIndex];
    resol := Printer.XDPI;
  end
  else
  begin
    Name := '';
    resol := 72;
  end;
end;

function GetPrinterIndex: integer;
begin
  try
    result := Printer.PrinterIndex; // may crash on some case
  except
    result := -1;
  end;
end;

procedure PrintStrings(str: TStrings; PrtTitle, PrtText, PrtTextDate: string;
  orient: TPrinterOrientation);
var
  pw, ph, marg: integer;
  r: longint;
  y: integer;
  MargeLeft, Margetop, MargeRight: integer;
  StrDate: string;
  TextDown: integer;

  procedure PrintRow(r: longint);
  begin
    with Printer.Canvas do
    begin
      TextOut(MargeLeft, y + 10, str.Strings[r]);
      Inc(y, TextDown);
      //MoveTo(MargeLeft,y); LineTo(MargeRight,y);
    end;
  end;

  procedure Entete;
  begin
    with Printer.Canvas do
    begin
      Font.Style := [fsBold];
      TextOut(MargeLeft, MargeTop, PrtText);
      TextOut(MargeRight - TextWidth(StrDate), MargeTop, StrDate);
      y := MargeTop + TextDown;
      MoveTo(MargeLeft, y);
      LineTo(MargeRight, y);
      Inc(y, TextDown);
      Font.Style := [];
    end;
  end;

begin
  y := 0;
  StrDate := PrtTextDate + DateToStr(Date);

  if (Printer<>nil) and (GetPrinterIndex >= 0) then with Printer do
  begin
    Title := PrtTitle;
    Orientation := orient;

    if Orientation = poLandscape then
      marg := 50
    else
      marg := 25;

   {$ifdef mswindows}
    pw := XDPI * PageWidth div 254;
    ph := YDPI * PageHeight div 254;
   {$endif}

   {$ifdef unix}
    pw := PageWidth;
    ph := PageHeight;
   {$endif}

    BeginDoc;
    with Canvas do
    begin
      Font.Name := 'courier';
      Font.Pitch := fpFixed;
      Font.Size := 8;

    {$ifdef unix}
      Font.Size := 6;
    {$endif}

      Font.Color := clBlack;
      Pen.Color := clBlack;
      TextDown := TextHeight(StrDate) * 3 div 2;
    end;

    MargeLeft := pw div marg;
    MargeTop := ph div marg;
    MargeRight := pw - MargeLeft;
    Entete;

    for r := 0 to str.Count - 1 do
    begin
      PrintRow(r);

      if y >= (ph - MargeTop) then
      begin
        NewPage;
        Entete;
      end;

    end;

    EndDoc;

  end;

end;

{ By Paul Toth tothpaul@multimania.com }
{ http://www.multimania.com/tothpaul  }
{ Just a little Unit to print a Grid :) }
procedure PrtGrid(Grid: TStringGrid; PrtTitle, PrtText, PrtTextDate: string;
  orient: TPrinterOrientation);
type
  TCols = array[0..20] of integer;
var
  Rapport, pw, ph, marg: integer;
  r, c: longint;
  cols: ^TCols;
  y: integer;
  MargeLeft, Margetop, MargeRight: integer;
  StrDate: string;
  TextDown: integer;

  procedure VerticalLines;
  var
    c: longint;
  begin
    with Printer.Canvas do
    begin
      for c := 0 to Grid.ColCount - 1 do
      begin
        MoveTo(Cols^[c], MargeTop + TextDown);
        LineTo(Cols^[c], y);
      end;
      MoveTo(MargeRight, MargeTop + TextDown);
      LineTo(MargeRight, y);
    end;
  end;

  procedure PrintRow(r: longint);
  var
    c: longint;
  begin
    with Printer.Canvas do
    begin
      for c := 0 to Grid.ColCount - 1 do
        TextOut(Cols^[c] + 10, y + 10, Grid.Cells[c, r]);

      Inc(y, TextDown);
      MoveTo(MargeLeft, y);
      LineTo(MargeRight, y);
    end;
  end;

  procedure Entete;
  var
    rr: longint;
  begin
    with Printer.Canvas do
    begin
      Font.Style := [fsBold];

      TextOut(MargeLeft, MargeTop, PrtText);
      TextOut(MargeRight - TextWidth(StrDate), MargeTop, StrDate);
      y := MargeTop + TextDown;

      Brush.Color := clSilver;
      FillRect(Classes.Rect(MargeLeft, y, MargeRight, y + TextDown * Grid.FixedRows));
      MoveTo(MargeLeft, y);
      LineTo(MargeRight, y);

      for rr := 0 to Grid.FixedRows - 1 do
        PrintRow(rr);

      Brush.Color := clWhite;
      Font.Style := [];
    end;
  end;

begin
  y := 0;
  GetMem(Cols, Grid.ColCount * SizeOf(integer));
  StrDate := PrtTextDate + DateToStr(Date);

  if (Printer<>nil) and (GetPrinterIndex >= 0) then with Printer do
  begin
    Title := PrtTitle;
    Orientation := orient;

    if Orientation = poLandscape then
      marg := 50
    else
      marg := 25;

    {$ifdef mswindows}
    pw := XDPI * PageWidth div 254;
    ph := YDPI * PageHeight div 254;
    {$endif}

    {$ifdef unix}
    pw := PageWidth;
    ph := PageHeight;
    {$endif}

    MargeLeft := pw div marg;
    MargeTop := ph div marg;
    MargeRight := pw - MargeLeft;
    Rapport := (MargeRight) div Grid.GridWidth;

    BeginDoc;

    with Canvas do
    begin
      Font.Name := Grid.Font.Name;
      Font.Height := Grid.Font.Height * Rapport;
      if Font.Height = 0 then
        Font.Height := 11 * Rapport;
      Font.Color := clBlack;
      Pen.Color := clBlack;
      TextDown := TextHeight(StrDate) * 3 div 2;
    end;
    { calcul des Cols }
    Cols^[0] := MargeLeft;

    for c := 1 to Grid.ColCount - 1 do
    begin
      Cols^[c] := round(Cols^[c - 1] + Grid.ColWidths[c - 1] * Rapport);
    end;

    Entete;

    for r := Grid.FixedRows to Grid.RowCount - 1 do
    begin
      PrintRow(r);
      if y >= (ph - MargeTop) then
      begin
        VerticalLines;
        NewPage;
        Entete;
      end;
    end;

    VerticalLines;
    EndDoc;
  end;

  FreeMem(Cols, Grid.ColCount * SizeOf(integer));
end;

{$ifdef mswindows}
function FindWOW64: boolean;
type
  TIsWow64Process = function(Handle: THandle; var IsWow64: BOOL): BOOL; stdcall;
var
  hKernel32: HINST;
  IsWow64Process: TIsWow64Process;
  IsWow64: BOOL;
begin
  Result := False;
  hKernel32 := LoadLibrary('kernel32.dll');
  if (hKernel32 = 0) then
    exit;
  @IsWow64Process := GetProcAddress(hkernel32, 'IsWow64Process');
  if Assigned(IsWow64Process) then
  begin
    IsWow64 := False;
    if (IsWow64Process(GetCurrentProcess, IsWow64)) then
      Result := IsWow64;
  end;
  FreeLibrary(hKernel32);
end;

function ScreenBPP: integer;
var
  screendc: HDC;
begin
  screendc := GetDC(0);
  Result := GetDeviceCaps(screendc, BITSPIXEL);
  ReleaseDC(0, screendc);
end;

{$endif}

// one time use function to extract all text to translate from component object
//uses pu_addlabel, pu_catgen, pu_catgenadv, pu_config_chart, pu_config_internet, pu_config_solsys, pu_config_system,pu_image, pu_progressbar,
(*procedure GetTranslationString(form: TForm; var f: textfile);
var
  i, j: integer;
  cname, cprop, ctext: string;
begin

  with form do
  begin
    writeln(f);
    writeln(f, 'Form: ' + Name);

    for i := 0 to ComponentCount - 1 do
    begin
      cname := '';
      cprop := '';
      ctext := '';

      if (Components[i] is TPageControl) then
        with (Components[i] as TPageControl) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TTabSheet) then
        with (Components[i] as TTabSheet) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TButton) then
        with (Components[i] as TButton) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TLabel) then
        with (Components[i] as TLabel) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TToolButton) then
        with (Components[i] as TToolButton) do
        begin
          cname := Name;
          cprop := 'hint';
          ctext := hint;
        end;

      if (Components[i] is TBitBtn) then
        with (Components[i] as TBitBtn) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TSpeedButton) then
        with (Components[i] as TSpeedButton) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TMemo) then
        with (Components[i] as TMemo) do
        begin
          cname := Name;
          cprop := 'text';
          ctext := Text;
        end;

      if (Components[i] is TEdit) then
        with (Components[i] as TEdit) do
        begin
          cname := Name;
          cprop := 'text';
          ctext := Text;
        end;

      if (Components[i] is TMaskEdit) then
        with (Components[i] as TMaskEdit) do
        begin
          cname := Name;
          cprop := 'text';
          ctext := Text;
        end;

      if (Components[i] is TStringGrid) then
        with (Components[i] as TStringGrid) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TCombobox) then
        with (Components[i] as TCombobox) do
        begin

          for j := 0 to Items.Count - 1 do
          begin
            cname := Name + '.items[' + IntToStr(j) + ']';
            ctext := Items[j];
            writeln(f, cname + ':=''' + ctext + ''';');
          end;

          ctext := '';
        end;

      if (Components[i] is TMenuItem) then
        with (Components[i] as TMenuItem) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TSpinEdit) then
        with (Components[i] as TSpinEdit) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TTreeView) then
        with (Components[i] as TTreeView) do
        begin
          for j := 0 to Items.Count - 1 do
          begin
            cname := Name + '.items[' + IntToStr(j) + '].text';
            ctext := Items[j].Text;
            writeln(f, cname + ':=''' + ctext + ''';');
          end;
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TListBox) then
        with (Components[i] as TListBox) do
        begin
          for j := 0 to Items.Count - 1 do
          begin
            cname := Name + '.items[' + IntToStr(j) + ']';
            ctext := Items[j];
            writeln(f, cname + ':=''' + ctext + ''';');
          end;
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TCheckListbox) then
        with (Components[i] as TCheckListbox) do
        begin
          for j := 0 to Items.Count - 1 do
          begin
            cname := Name + '.items[' + IntToStr(j) + ']';
            ctext := Items[j];
            writeln(f, cname + ':=''' + ctext + ''';');
          end;
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TGroupBox) then
        with (Components[i] as TGroupBox) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TRadioGroup) then
        with (Components[i] as TRadioGroup) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TCheckGroup) then
        with (Components[i] as TCheckGroup) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TCheckBox) then
        with (Components[i] as TCheckBox) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (Components[i] is TRadioButton) then
        with (Components[i] as TRadioButton) do
        begin
          cname := Name;
          cprop := 'caption';
          ctext := Caption;
        end;

      if (ctext <> '') and (ctext <> '-') and (ctext <> cname) and
        (not IsNumber(ctext)) then
        writeln(f, cname + '.' + cprop + ':=''' + ctext + ''';');
    end;

  end;

end; *)

function TzGMT2UTC(gmttz: string): string;
var
  buf: string;
begin

  //  Etc/GMT+5 -> UTC-5
  if copy(gmttz, 1, 7) = 'Etc/GMT' then
  begin

    buf := StringReplace(gmttz, 'Etc/GMT', 'UTC', []);
    if pos('+', buf) > 0 then
      buf := StringReplace(buf, '+', '-', [])
    else
      buf := StringReplace(buf, '-', '+', []);
    Result := buf;

  end
  //  GMT+5 -> UTC-5
  else if copy(gmttz, 1, 3) = 'GMT' then
  begin

    buf := StringReplace(gmttz, 'GMT', 'UTC', []);
    if pos('+', buf) > 0 then
      buf := StringReplace(buf, '+', '-', [])
    else
      buf := StringReplace(buf, '-', '+', []);
    Result := buf;

  end
  else
    Result := gmttz;

end;

function TzUTC2GMT(utctz: string): string;
var
  buf: string;
begin

  //  UTC-5 -> Etc/GMT+5
  if copy(utctz, 1, 3) = 'UTC' then
  begin
    buf := StringReplace(utctz, 'UTC', 'Etc/GMT', []);

    if pos('+', buf) > 0 then
      buf := StringReplace(buf, '+', '-', [])
    else
      buf := StringReplace(buf, '-', '+', []);

    Result := buf;
  end
  else
    Result := utctz;

end;

function ExtractSubPath(basepath, path: string): string;
begin

  if basepath = '' then
    Result := path
  else
    Result := StringReplace(path, slash(basepath), '', []);

end;

function RoundInt(x: double): integer;
const
  maxi = MaxInt / 2;
begin
  Result := round(sgn(x) * MinValue([maxi, abs(x)]));
end;

function GetThreadCount: integer;
begin
  Result := GetSystemThreadCount;
end;

function capitalize(txt: string): string;
var
  i: integer;
  up: boolean;
  c: string;
begin
  Result := '';
  up := True;

  for i := 1 to length(txt) do
  begin
    c := copy(txt, i, 1);

    if up then
      c := UpperCase(c)
    else
      c := LowerCase(c);

    Result := Result + c;

    up := (c = ' ') or (c = '-');
  end;

end;

function GetXPlanetVersion: string;
var
  p: TProcess;
  r: TStringList;
  buf: string;
  i: integer;
  ok: boolean;
begin
  Result := '0.0.0';

  p := TProcess.Create(nil);
  r := TStringList.Create;

  try

    {$ifdef linux}
    p.Environment.Add('LC_ALL=C');
    p.Executable := 'xplanet';
    {$endif}

    {$ifdef freebsd}
    p.Environment.Add('LC_ALL=C');
    p.Executable := 'xplanet';
    {$endif}

    {$ifdef darwin}
    p.Environment.Add('LC_ALL=C');
    p.Executable := slash(appdir) + slash(xplanet_dir) + 'xplanet';
    {$endif}

    {$ifdef mswindows}
    p.Executable := slash(appdir) + slash(xplanet_dir) + 'xplanet.exe';
    {$endif}

    p.Parameters.Add('--version');
    p.Options := [poWaitOnExit, poUsePipes, poNoConsole, poStdErrToOutput];

    try
      ok := True;
      p.Execute;
    except
      ok := False;
    end;

    if ok and (p.ExitStatus = 0) then
    begin

      r.LoadFromStream(p.Output);

      if r.Count > 0 then
      begin

        for i := 0 to r.Count - 1 do
        begin
          buf := r[i];

          if copy(buf, 1, 7) = 'Xplanet' then
          begin
            Result := trim(words(buf, '', 2, 1));
            break;
          end;

        end;
      end;

    end;

  finally
    p.Free;
    r.Free;
  end;

end;

procedure GetXplanet(Xplanetversion, originfile, searchdir, bsize, outfile: string;
  ipla: integer; pa, grsl, jd: double; var irc: integer; var r: TStringList);
var
  p: TProcess;
  {$ifdef mswindows}
  shorttmp: array[0..1024] of char;
  {$endif}
begin
  p := TProcess.Create(nil);
  {$ifdef linux}
  p.Environment.Add('LC_ALL=C');
  p.Executable := 'xplanet';
  {$endif}
  {$ifdef freebsd}
  p.Environment.Add('LC_ALL=C');
  p.Executable := 'xplanet';
  {$endif}
  {$ifdef darwin}
  p.Environment.Add('LC_ALL=C');
  p.Executable := slash(appdir) + slash(xplanet_dir) + 'xplanet';
  {$endif}
  {$ifdef mswindows}
  p.Executable := slash(appdir) + slash(xplanet_dir) + 'xplanet.exe';
  if not isANSItmpdir then
  begin
    GetShortPathName(PChar(UTF8ToWinCP(TempDir)), @shorttmp, 1024);
    outfile := slash(shorttmp) + extractfilename(outfile);
    if (originfile <> '') and FileExists(originfile) then
      originfile := slash(shorttmp) + extractfilename(originfile);
  end;
  {$endif}
  p.Parameters.Add('-origin');
  p.Parameters.Add('earth');
  if (originfile <> '') and FileExists(originfile) then
  begin
    p.Parameters.Add('-origin_file');
    p.Parameters.Add(originfile);
  end;
  p.Parameters.Add('-body');
  p.Parameters.Add(LowerCase(trim(epla[ipla])));
  p.Parameters.Add('-rotate');
  p.Parameters.Add(formatfloat(f1, pa));
  p.Parameters.Add('-light_time');
  p.Parameters.Add('-tt');
  p.Parameters.Add('-num_times');
  p.Parameters.Add('1');
  p.Parameters.Add('-jd');
  p.Parameters.Add(formatfloat(f5, jd));
  p.Parameters.Add('-searchdir');
  p.Parameters.Add(searchdir);
  p.Parameters.Add('-config');
  p.Parameters.Add('xplanet.config');
  p.Parameters.Add('-verbosity');
  p.Parameters.Add('-1');
  p.Parameters.Add('-radius');
  p.Parameters.Add('50');
  p.Parameters.Add('-geometry');
  p.Parameters.Add(bsize);
  p.Parameters.Add('-output');
  p.Parameters.Add(outfile);

  if ipla = 5 then
  begin
    p.Parameters.Add('-grs_longitude');
    p.Parameters.Add(formatfloat(f1, grsl));
  end;

  if (de_type > 0) and (Xplanetversion >= '1.3.0') then
  begin
    p.Parameters.Add('-ephemeris_file');
    p.Parameters.Add(de_filename);
  end;

  DeleteFileUTF8(SysToUTF8(outfile));
  p.Options := [poWaitOnExit, poUsePipes, poNoConsole, poStdErrToOutput];

  try
    p.Execute;
    if (p.ExitStatus <> 0) and (de_type > 0) and (Xplanetversion >= '1.3.0') then
    begin
      p.Parameters.Delete(p.Parameters.Count - 1);
      p.Parameters.Delete(p.Parameters.Count - 1);
      p.Execute;
    end;
  except
  end;

  r.LoadFromStream(p.Output);
  irc := p.ExitStatus;
  p.Free;

end;

function isANSIstr(str: string): boolean;
var
  c: char;
begin

  Result := True;

  for c in str do
    if Ord(c) > 127 then
    begin
      Result := False;
      break;
    end;

end;

function VisibleControlCount(obj: TWinControl): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to obj.ControlCount - 1 do
    if obj.Controls[i].Visible then
      Inc(Result);
end;

procedure SetMenuAccelerator(Amenu: TMenuItem; level: integer;
  var AccelList: array of string);
var
  k, p: integer;
  txt, c: string;
begin

  if level > MaxMenulevel then
    exit;

  txt := StringReplace(Amenu.Caption, '&', '', [rfReplaceAll]);

  if (txt <> '') and (txt <> '-') then
  begin
    p := 1;
    c := UpperCase(copy(txt, p, 1));
    while (pos(c, AccelList[level]) > 0) or (c < 'A') or (c > 'Z') do
    begin
      Inc(p);
      if p >= length(txt) then
      begin
        p := 1;
        c := UpperCase(copy(txt, p, 1));
        break;
      end;
      c := UpperCase(copy(txt, p, 1));
    end;

    if Amenu.Action <> nil then
      TAction(Amenu.Action).Caption := copy(txt, 1, p - 1) + '&' + copy(txt, p, 999)
    else
      Amenu.Caption := copy(txt, 1, p - 1) + '&' + copy(txt, p, 999);

    AccelList[level] := AccelList[level] + c;
  end;

  AccelList[level + 1] := '';

  for k := 0 to Amenu.Count - 1 do
    SetMenuAccelerator(Amenu[k], level + 1, AccelList);

end;

procedure ISleep(milli: integer);
var
  tx: double;
begin
  tx := now + milli / 1000 / 3600 / 24;
  repeat
    sleep(10);
    Application.ProcessMessages;
  until now > tx;
end;

function CompareVersion(v1, v2: string): integer;
  // +1 if v2>v1
  //  0 if v2=v1
  // -1 if v2<v1
var
  i: integer;
  major1, minor1, rev1: double;
  beta1: boolean;
  major2, minor2, rev2: double;
  beta2: boolean;

  function NextNum(var str: string; sep: char): double;
  var
    p: integer;
    txt: string;
  begin
    p := Pos(sep, str);
    if p > 0 then
    begin
      txt := Copy(str, 1, p - 1);
      Delete(str, 1, p);
      Result := StrToFloatDef(txt, 0.0);
    end
    else
      Result := 0.0;
  end;

begin
  beta1 := Pos('-svn-', v1) > 0;
  beta2 := Pos('-svn-', v2) > 0;

  if beta1 then
    v1 := StringReplace(v1, '-svn-', '-', []);
  if beta2 then
    v2 := StringReplace(v2, '-svn-', '-', []);

  major1 := NextNum(v1, '.');
  minor1 := NextNum(v1, '-');
  i:=pos('-',v1);
  if i>0 then v1:=copy(v1,1,i-1);
  rev1 := StrToFloatDef(v1, 0.0);
  major2 := NextNum(v2, '.');
  minor2 := NextNum(v2, '-');
  i:=pos('-',v2);
  if i>0 then v2:=copy(v2,1,i-1);
  rev2 := StrToFloatDef(v2, 0.0);

  if (major2 > major1) then
    Result := 1
  else if (major2 < major1) then
    Result := -1
  else if (minor2 > minor1) then
    Result := 1
  else if (minor2 < minor1) then
    Result := -1
  else if (rev2 > rev1) then
    Result := 1
  else if (rev2 < rev1) then
    Result := -1
  else
    Result := 0;

end;

function strim(const S: string): string;
begin
  Result := string(trim(s));
end;

procedure DeleteFilesInDir(dir: string);
var
  i: integer;
  fs: TSearchRec;
begin

  i := findfirst(slash(dir) + '*', 0, fs);
  while i = 0 do
  begin
    DeleteFileUTF8(slash(dir) + fs.Name);
    i := findnext(fs);
  end;

  findclose(fs);
end;

function ShowModalForm(f: TForm; SetFocus: boolean = False): TModalResult;
begin
  Result := f.ShowModal;
end;

Function LeadingZero(w : integer) : String;
  var
    s : String;
  begin
    Str(w:0,s);
    if Length(s) = 1 then
      s := '0' + s;
    LeadingZero := s;
  end;

function prepare_IAU_designation(rax,decx :double):string;{radialen to text hhmmss.s+ddmmss  format}
  var
    hh,mm,ss,ds  :integer;
    g,m,s  :integer;
    sign   : char;
begin
   {RA}
   rax:=rax+pi*2*0.05/(24*60*60); {add 1/10 of half second to get correct rounding and not 7:60 results as with round}
   rax:=rax*12/pi; {make hours}
   hh:=trunc(rax);
   mm:=trunc((rax-hh)*60);
   ss:=trunc((rax-hh-mm/60)*3600);
   ds:=trunc((rax-hh-mm/60-ss/3600)*36000);

   {DEC}
   if decx<0 then sign:='-' else sign:='+';
   decx:=abs(decx)+pi*2*0.5/(360*60*60); {add half second to get correct rounding and not 7:60 results as with round}
   decx:=decx*180/pi; {make degrees}
   g:=trunc(decx);
   m:=trunc((decx-g)*60);
   s:=trunc((decx-g-m/60)*3600);

   result:=leadingzero(hh)+leadingzero(mm)+leadingzero(ss)+'.'+char(ds+48)+sign+leadingzero(g)+leadingzero(m)+leadingzero(s);
end;

function TruncDecimal(val: Extended; decimal: byte): Extended;
var x, xfrac: Extended;
begin
  x := trunc(val);
  xfrac := frac(val);
  Result := x + trunc(xfrac*10**decimal)/10**decimal;
end;

procedure Wait(wt:single=5);
var endt: TDateTime;
begin
  endt:=now+wt/secday;
  while now<endt do begin
    Sleep(100);
    if GetCurrentThreadId=MainThreadID then Application.ProcessMessages;
  end;
end;

function CleanName(fn:string):string;
begin
  result:=fn;
  result:=StringReplace(result,'/','',[rfReplaceAll]);
  result:=StringReplace(result,'\','',[rfReplaceAll]);
  result:=StringReplace(result,':','',[rfReplaceAll]);
  result:=StringReplace(result,'.','',[rfReplaceAll]);
  result:=StringReplace(result,';','',[rfReplaceAll]);
  result:=StringReplace(result,',','',[rfReplaceAll]);
  result:=StringReplace(result,'=','',[rfReplaceAll]);
  result:=StringReplace(result,'''','',[rfReplaceAll]);
  result:=StringReplace(result,'"','',[rfReplaceAll]);
  result:=StringReplace(result,'$','',[rfReplaceAll]);
  result:=StringReplace(result,'*','',[rfReplaceAll]);
  result:=StringReplace(result,'@','',[rfReplaceAll]);
  result:=StringReplace(result,'>','',[rfReplaceAll]);
  result:=StringReplace(result,'<','',[rfReplaceAll]);
end;

function MessageDlgCenter(const aCaption, aMsg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): TModalResult;
var f : TForm;
begin
   f := CreateMessageDialog(aCaption, aMsg, DlgType, Buttons);
   f.Position := poOwnerFormCenter;
   result := f.ShowModal;
   f.Free;
end;

end.
