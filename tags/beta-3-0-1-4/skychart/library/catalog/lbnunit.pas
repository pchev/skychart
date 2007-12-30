unit lbnunit;
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
LBNrec = record ar,de :longint ;
                area : single;
                num,d1,d2,id : word;
                color,bright : byte;
                name : array[1..8] of char;
                end;
Function IsLBNpath(path : PChar) : Boolean; stdcall;
procedure SetLBNpath(path : PChar); stdcall;
Procedure OpenLBN(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenLBNwin(var ok : boolean); stdcall;
Procedure ReadLBN(var lin : LBNrec; var ok : boolean); stdcall;
procedure CloseLBN ; stdcall;

var
  LBNpath : string;

implementation

var
   flbn : file of LBNrec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;
   chkfile : Boolean = true;

Function IsLBNpath(path : PChar) : Boolean; stdcall;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetLBNpath(path : PChar); stdcall;
begin
LBNpath:=noslash(path);
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(flbn);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=LBNpath+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; chkfile:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(flbn,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(flbn);
ok:=true ;
end;

Procedure OpenLBN(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadLBN(var lin : LBNrec; var ok : boolean); stdcall;
var sm:integer;
begin
ok:=true;
if eof(flbn) then begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;
if ok then  Read(flbn,lin);
end;

procedure CloseLBN ;  stdcall;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenLBNwin(var ok : boolean);  stdcall;
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.

