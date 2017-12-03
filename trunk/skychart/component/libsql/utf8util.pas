unit utf8util;

interface
// RFC 2279

function EncodeUTF8 (S: WideString): String;
function DecodeUTF8 (S: String): WideString;

//                                  ***                                  //
// Created:                                                              //
// October 2. 2004                                                       //
// By R.M. Tegel                                                         //
//                                                                       //
// Discription:                                                          //
// UTF8 Encode and Decode functions                                      //
// Encode and Decode UTF to and from WideString                          //
//                                                                       //
// Limitations:                                                          //
// 4-byte UTF decoding not supported.                                    //
// No effort is done to mask 4-byte UTF character to two-byte WideChar   //
// 4-byte characters will be replace by space (#32)                      //
// This should not affect further decoding.                              //
//                                                                       //
// Background:                                                           //
// Created as independant UTF8 unit to support libsql                    //
// Targeted to be more effective than borland's implementation in D7+    //
// especially on large strings.                                          //
//                                                                       //
// License:                                                              //
// Modified Artistic License                                             //
// The MAL license is compatible with almost any open-source license     //
// Especially including but no limited to GPL, LGPL and BSD              //
// Main issues about this licese:                                        //
// You may use this unit for any legal purpose you see fit               //
// You may freely modify and redistribute this unit as long as           //
// you leave author(s) name(s) as contributor / original creator         //
// You may use this unit in closed-source commercial applications        //
// You may include this unit in your projects' source distribution       //
// You may re-license this unit as GPL or BSD if needed for your project //
//                                                                       //
// Happy Programming ;)                                                  //
// Rene                                                                  //
//                                  ***                                  //

implementation

function EncodeUTF8(S: WideString): String;
var rl: Integer;
  procedure Plus (c: byte);
  begin
    inc (rl);
    //pre-allocation to improve performance:
    if rl>length(Result) then
      SetLength (Result, length(Result)+2048);
    Result[rl] := char(c);
  end;
var i: Integer;
    c: Word;
begin
  //alter this to length(S) * 2 if you expect a _lot_ ('only') of non-ascii
  //for max speed.
  SetLength (Result, 20+round (length(S) * 1.2));
  rl := 0;
  for i:=1 to length (S) do
    begin
      c := Word(S[i]);
      if c<=$7F then //single byte in valid ascii range
        Plus (c)
      else
      if c<$7FF then //two-byte unicode needed
        begin
          Plus ($C0 or (c shr 6));
          Plus ($80 or (c and $3F));
        end
      else
        begin //three byte unicode needed
              //Note: widestring specifies only 2 bytes
              //so, there is no need for encoding up to 4 bytes.
          Plus ($E0 or (c shr 12));
          Plus ($80 or ((c and $FFF) shr 6));
          Plus ($80 or (c and $3F));
        end;
    end;
  SetLength (Result, rl);
end;

function DecodeUTF8 (S: String): WideString;
var rl: Integer;
  procedure Plus (c: word);
  begin
    inc (rl);
    if (rl>length(Result)) then //alloc some extra mem
      SetLength (Result, length(Result)+512);
    Result[rl] := WideChar(c);
  end;
var b,c,d: byte;
    i,l: Integer;
begin
  //Result := '';
  SetLength (Result, length(S));
  rl := 0;
  i := 1;
  l := length(S);
  while i<=l do
    begin
      b := byte(S[i]);
      if (b and $80)=0 then //7-bit
        Plus (b)
      else
      if (b and $E0)=$C0 then //11-bit
        begin
          if i<l then //range check
            c:=byte(S[i+1])
          else
            c:=$80;
          if (c and $C0)<>$80 then
            c := $80; //error. tag with zero. sorry.
          b:=b and $1F;
          c:=c and $3F;
          plus (b shl 6 or c);
          inc (i);
        end
      else
      if (b and $F0) = $E0 then //16-bit
        begin
          if i<l then
            c := byte(S[i+1])
          else
            c := $80;
          if i<l-1 then
            d := byte (S[i+2])
          else
            d := $80;
          if (c and $C0)<>$80 then
            c := $80; //error. tag with zero. sorry.
          if (d and $C0)<>$80 then
            d := $80; //error. tag with zero. sorry.
          b := b and $0F;
          c := c and $3F;
          d := d and $3F;
          plus ((b shl 12) or (c shl 6) or d);
          inc (i,2);
        end
      else
        begin //we have a problem here. a value > 16 bit was encoded
              //obviously, this doesn't fit in a widestring..
              //fix: leave blank ('space'). sorry.
          Plus (ord(' '));
          b := b shl 1;
          repeat
            b := b shl 1;
            inc (i);
          until (b and $80)=0;
        end;
      inc (i);
    end;
  SetLength (Result, rl);
end;

end.
