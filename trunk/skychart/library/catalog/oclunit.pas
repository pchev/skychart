unit oclunit;
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
OCLrec = record ar,de :longint ;
                cat,num,ocl,dim,dist,age,ms,mt,b_v,ns : smallint;
                conc,range,rich,neb : char;
                end;
Function IsOCLpath(path : string) : Boolean;
procedure SetOCLpath(path : string);
Procedure OpenOCL(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenOCLwin(var ok : boolean);
Procedure ReadOCL(var lin : OCLrec; var ok : boolean);
procedure CloseOCL ;

var
  OCLpath : string;

implementation

var
   focl : file of OCLrec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;

Function IsOCLpath(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetOCLpath(path : string);
begin
OCLpath:=noslash(path);
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(focl);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=OCLpath+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(focl,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(focl);
ok:=true ;
end;

Procedure OpenOCL(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadOCL(var lin : OCLrec; var ok : boolean);
var sm:integer;
begin
ok:=true;
if eof(focl) then begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;
if ok then  Read(focl,lin);
end;

procedure CloseOCL ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenOCLwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.

