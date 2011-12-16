unit bscunit;
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
{$mode objfpc}{$H+}
interface

uses
  skylibcat, sysutils;
type
              BSCrec = record hd,bs,ar,de :longint ;
                              pmar,pmde:smallint;
                              mv,b_v   :smallint;
                              cons     : array [1..3] of char;
                              flam     : byte;
                              bayer    : array[1..4]of char;
                              sp       : array[1..20] of char;
                              end;

Function IsBSCpath(path : string) : Boolean;
procedure SetBSCpath(path : string);
Procedure OpenBSC(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenBSCwin(var ok : boolean);
Procedure ReadBSC(var lin : BSCrec; var ok : boolean);
Procedure NextBSC( var ok : boolean);
procedure CloseBSC ;

var
  BSCpath : string ='';

implementation

const CacheNum = 50;

var
   fbsc : file of BSCrec ;
   curSM : integer;
   SMname,NomFich : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;
   cache : array[1..CacheNum] of array of BSCrec;
   cachelst,Imax,Iread : array[1..CacheNum] of integer;
   OnCache : boolean;
   Ncache,Icache : integer;
   lastcache : integer = 0;
   chkfile : Boolean = true;

Function IsBSCpath(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetBSCpath(path : string);
var i : integer;
    buf:string;
begin
buf:=noslash(path);
if buf<>Bscpath then for i:=1 to CacheNum do cachelst[i]:=0;
BSCpath:=buf;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fbsc);
end;
{$I+}
end;
Procedure Openfile(nomfich : string; var ok : boolean);
begin
ok:=false;
if not FileExists(nomfich) then begin ; ok:=false ; chkfile:=false ; exit; end;
AssignFile(fbsc,nomfich);
FileisOpen:=true;
FileMode:=0;
reset(fbsc);
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
nomfich:=BSCpath+slashchar+padzeros(nomreg,2)+'.dat';
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
   Imax[Ncache]:=filesize(fbsc)-1;
   Iread[Ncache]:=0;
   SetLength(cache[Ncache],Imax[Ncache]+2);
end;
end;
ok:=true;
end;

Procedure OpenBSC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadBSC(var lin : BSCrec; var ok : boolean);
begin
ok:=true;
inc(Icache);
while ok and((OnCache and(Icache>Imax[Ncache]))or((not OnCache) and eof(fbsc))) do begin
  dec(Icache);
  NextBSC(ok);
  inc(Icache);
end;
if OnCache then begin
  if ok then begin
     if Icache<=Iread[ncache] then lin:=cache[Ncache,Icache]
     else begin
       if not fileisopen then begin
          OpenFile(nomfich,ok);
          if not ok then exit;
          seek(fbsc,Icache);
       end;
       Read(fbsc,lin);
       cache[Ncache,Icache]:=lin;
       Iread[ncache]:=Icache;
     end;
  end;
end else begin
  if ok then begin
     Read(fbsc,lin);
     if UseCache then begin
        cache[Ncache,Icache]:=lin;
        Iread[ncache]:=Icache;
     end;
  end;
end;
end;

Procedure NextBSC( var ok : boolean);
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

procedure CloseBSC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenBSCwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.
