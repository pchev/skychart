unit skyunit;
{
Copyright (C) 2000 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

interface

uses
  skylibcat, sysutils;
type
   SKYrec = record ar,de :longint ;
                   mv,b_v,d_m,pmar,pmde :smallint;
                   sep      : word;
                   sp       : array [1..3] of char;
                   dm_cat   : array[1..2]of char;
                   dm     : longint;
                   hd,sao   :longint ;
                   end;
Function IsSKYpath(path : shortstring) : Boolean; stdcall;
procedure SetSKYpath(path : shortstring); stdcall;
Procedure OpenSKY(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenSKYwin(var ok : boolean); stdcall;
Procedure ReadSKY(var lin : SKYrec; var ok : boolean); stdcall;
Procedure NextSKY( var ok : boolean); stdcall;
procedure CloseSKY ; stdcall;

var
  SKYpath: String='';

implementation

const CacheNum = 36;

var
   fsky : file of SKYrec ;
   curSM : integer;
   SMname,NomFich : string;
   Sm,nSM : integer;
   SMlst : array[1..184] of integer;
   FileIsOpen : Boolean = false;
   cache : array[1..CacheNum] of array of SKYrec;
   cachelst,Imax,Iread : array[1..CacheNum] of integer;
   OnCache : boolean;
   Ncache,Icache : integer;
   lastcache : integer = 0;
   chkfile : Boolean = true;

Function IsSKYpath(path : shortstring) : Boolean;
begin
result:= FileExists(slash(path)+'001.dat');
end;

procedure SetSKYpath(path : shortstring);
var i : integer;
begin
path:=noslash(path);
if path<>SKYpath then for i:=1 to CacheNum do cachelst[i]:=0;
SKYpath:=path;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fsky);
end;
{$I+}
end;

Procedure Openfile(nomfich : string; var ok : boolean);
begin
ok:=false;
if not FileExists(nomfich) then begin ; ok:=false ; chkfile:=false ; exit; end;
AssignFile(fsky,nomfich);
FileisOpen:=true;
FileMode:=0;
reset(fsky);
ok:=true;
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg :string;
    i,j : integer;
begin
OnCache:=false;
if UseCache then for i:=1 to CacheNum do if cachelst[i]=s then begin OnCache:=true; Ncache:=i; break; end;
str(S:3,nomreg);
SMname:=nomreg;
Icache:=-1;
if fileisopen then CloseRegion;
nomfich:=SKYpath+slashchar+padzeros(nomreg,3)+'.dat';
if not OnCache then begin
OpenFile(nomfich,ok);
if not ok then  exit;
if UseCache then begin
   j:=lastcache+1;
   if j>CacheNum then j:=1;
   cachelst[j]:=s;
   Ncache:=j;
   lastcache:=j;
   SetLength(cache[Ncache],1);
   Imax[Ncache]:=filesize(fsky)-1;
   Iread[Ncache]:=0;
   SetLength(cache[Ncache],Imax[Ncache]+1);
end;
end;
ok:=true;
end;

Procedure OpenSKY(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
if UseCache then FindRegionList15(ar1,ar2,de1,de2,nSM,SMlst)
            else FindRegionAll15(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadSKY(var lin : SKYrec; var ok : boolean);
begin
ok:=true;
inc(Icache);
while ok and((OnCache and(Icache>Imax[Ncache]))or((not OnCache) and eof(fsky))) do begin
  dec(Icache);
  NextSKY(ok);
  inc(Icache);
end;
if OnCache then begin
  if ok then begin
     if Icache<=Iread[ncache] then lin:=cache[Ncache,Icache]
     else begin
       if not fileisopen then begin
          OpenFile(nomfich,ok);
          if not ok then exit;
          seek(fsky,Icache);
       end;
       Read(fsky,lin);
       cache[Ncache,Icache]:=lin;
       Iread[ncache]:=Icache;
     end;
  end;
end else begin
  if ok then begin
     Read(fsky,lin);
     if UseCache then begin
        cache[Ncache,Icache]:=lin;
        Iread[ncache]:=Icache;
     end;
  end;
end;
end;

Procedure NextSKY( var ok : boolean);
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

procedure CloseSKY ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenSKYwin(var ok : boolean);
begin
curSM:=1;
if UseCache then FindRegionListWin15(nSM,SMlst)
            else FindRegionAllWin15(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.
