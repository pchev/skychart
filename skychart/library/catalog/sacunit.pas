unit sacunit;
{
Copyright (C) 2000 Patrick Chevalley

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
  skylibcat, sysutils;

type
SACrec = record
            ar,de,ma,sbr,s1,s2 : single;
            pa : byte;
            i0: byte; nom1 : array [1..17] of char;
            i1: byte; nom2 : array [1..18] of char;
            i2: byte; typ  : array [1..3] of char;
            i3: byte; cons : array [1..3] of char;
            i4: byte; desc : array [1..120] of char;
            i5: byte; clas : array [1..11]of char;
         end;
Function IsSACpath(path : string) : Boolean;
procedure SetSACpath(path : string);
Procedure OpenSAC(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenSACwin(var ok : boolean);
Procedure ReadSAC(var lin : SACrec; var ok : boolean);
procedure CloseSAC ;
procedure OpenSACFileNum(fnum:integer; var ok:boolean);
Procedure ReadSACRec(r: integer; var lin : SACrec; var ok : boolean);


var
  SACpath : string='';

implementation

const CacheNum = 50;

var
   fsac : file of SACrec ;
   curSM : integer;
   SMname,NomFich : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;
   cache : array[1..CacheNum] of array of SACrec;
   cachelst,Imax,Iread : array[1..CacheNum] of integer;
   OnCache : boolean;
   Ncache,Icache : integer;
   lastcache : integer = 0;

Function IsSACpath(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetSACpath(path : string);
var i : integer;
    buf:string;
begin
buf:=noslash(path);
if buf<>SACpath then for i:=1 to CacheNum do cachelst[i]:=0;
SACpath:=buf;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fsac);
end;
{$I+}
end;

Procedure Openfile(nomfich : string; var ok : boolean);
begin
ok:=false;
if not FileExists(nomfich) then begin ; ok:=false ; exit; end;
AssignFile(fsac,nomfich);
FileisOpen:=true;
FileMode:=0;
reset(fsac);
ok:=true;
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg :string;
    i,j : integer;
begin
OnCache:=false;
if UseCache then for i:=1 to CacheNum do if cachelst[i]=s then begin OnCache:=true; Ncache:=i; break; end;
str(S:2,nomreg);
SMname:=nomreg;
Icache:=-1;
if fileisopen then CloseRegion;
nomfich:=SACpath+slashchar+padzeros(nomreg,2)+'.dat';
if not OnCache then begin
OpenFile(nomfich,ok);
if not ok then exit;
if UseCache then begin
   j:=lastcache+1;
   if j>CacheNum then j:=1;
   cachelst[j]:=s;
   Ncache:=j;
   lastcache:=j;
   SetLength(cache[Ncache],1);
   Imax[Ncache]:=filesize(fsac)-1;
   Iread[Ncache]:=0;
   SetLength(cache[Ncache],Imax[Ncache]+2);
end;
end;
ok:=true;
end;

Procedure OpenSAC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure NextSAC( var ok : boolean);
begin
if OnCache then begin
end else begin
  CloseRegion;
end;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;

Procedure ReadSAC(var lin : SACrec; var ok : boolean);
begin
ok:=true;
inc(Icache);
while ok and((OnCache and(Icache>Imax[Ncache]))or((not OnCache) and eof(fsac))) do begin
  dec(Icache);
  NextSAC(ok);
  inc(Icache);
end;
if OnCache then begin
  if ok then begin
     if Icache<=Iread[ncache] then lin:=cache[Ncache,Icache]
     else begin
       if not fileisopen then begin
          OpenFile(nomfich,ok);
          if not ok then exit;
          seek(fsac,Icache);
       end;
       Read(fsac,lin);
       cache[Ncache,Icache]:=lin;
       Iread[ncache]:=Icache;
     end;
  end;
end else begin
  if ok then begin
     Read(fsac,lin);
     if UseCache then begin
        cache[Ncache,Icache]:=lin;
        Iread[ncache]:=Icache;
     end;
  end;
end;
end;

procedure CloseSAC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenSACwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;


procedure OpenSACFileNum(fnum:integer; var ok:boolean);
var nomreg: string;
begin
if fileisopen then CloseRegion;
str(fnum:2,nomreg);
nomfich:=SACpath+slashchar+padzeros(nomreg,2)+'.dat';
OpenFile(nomfich,ok);
end;

Procedure ReadSACRec(r: integer; var lin : SACrec; var ok : boolean);
begin
ok:=false;
Seek(fsac,r);
if not eof(fsac) then begin
   Read(fsac,lin);
   ok:=true;
end;
end;

end.
