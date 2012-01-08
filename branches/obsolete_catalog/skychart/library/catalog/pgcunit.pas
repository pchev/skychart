unit pgcunit;
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
PGCrec = record
                pgc,ar,de,hrv   : Longint;
                nom   : array [1..16] of char;
                typ   : array [1..4] of char;
                pa    : byte;
                maj,min,mb : smallint;
                end;
Function IsPGCpath(path : string) : Boolean;
procedure SetPGCpath(path : string);
Procedure OpenPGC(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenPGCwin(var ok : boolean);
Procedure ReadPGC(var lin : PGCrec; var ok : boolean);
procedure ClosePGC ;

var
  PGCpath : string;

implementation

var
   f : file of PGCrec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;
   chkfile : Boolean = true;

Function IsPGCpath(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetPGCpath(path : string);
begin
PGCpath:=noslash(path);
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(f);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=PGCpath+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; chkfile:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(f,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(f);
ok:=true;
end;

Procedure OpenPGC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadPGC(var lin : PGCrec; var ok : boolean);
var sm:integer;
begin
ok:=true;
if eof(f) then begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;
if ok then  Read(f,lin);
end;

procedure ClosePGC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenPGCwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.

