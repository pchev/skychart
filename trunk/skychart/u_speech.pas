unit u_speech;
{
Copyright (C) 2016 Patrick Chevalley

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

{$mode objfpc}{$H+}

interface

uses
 {$ifdef mswindows}
   ComObj, Variants,
 {$endif}
  u_util, u_constant,
  Classes, SysUtils;

procedure setlang;
procedure speak(text: string);


implementation

var
  SpVoice: Variant;
  spLang: string='';


{$ifdef mswindows}
procedure speak(text: string);
var
    SavedCW: Word;
begin
 try
   if VarIsEmpty(SpVoice) then
      SpVoice := CreateOleObject('SAPI.SpVoice');
   if not VarIsEmpty(SpVoice) then begin
      SavedCW := Get8087CW;
      try
      Set8087CW(SavedCW or $4);
      SpVoice.Speak(text, 0);
      finally
      Set8087CW(SavedCW);
      end;
   end;
 except
 end;
end;
{$endif}

{$ifdef linux}
procedure GetLang;
var ll:TStringList;
    sl,buf,buf1:string;
    i,p:integer;
begin
 spLang:='en';
 sl:=Lang;
 p:=pos('-',sl);
 if p>0 then sl:=copy(sl,1,p-1);
 ll:=TStringList.Create;
 try
 ExecProcess('espeak --voices',ll);
 for i:=0 to ll.Count-1 do begin
   buf:=words(ll[i],'',2,1);
   if buf=Lang then begin
      spLang:=buf;
      break;
   end;
   if buf=sl then begin
      spLang:=buf;
   end;
   p:=pos('-',buf);
   if p>0 then begin
      buf1:=copy(buf,1,p-1);
      if buf1=sl then begin
         spLang:=buf;
      end;
   end;
 end;
 finally
  ll.Free;
 end;
end;

procedure speak(text: string);
begin
 if splang='' then GetLang;
 ExecNoWait('espeak -v '+spLang+' "'+text+'"');
end;
{$endif}

{$ifdef darwin}
procedure speak(text: string);
begin
 ExecNoWait('osascript -e ''say "' + text + '"''');
end;
{$endif}

procedure setlang;
begin
 spLang:='';
 SpVoice:=Unassigned;
end;

end.

