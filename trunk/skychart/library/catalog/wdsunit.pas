unit wdsunit;

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
WDSrec = record ar,de,dm :longint ;
                date1,date2,pa1,pa2,sep1,sep2,ma,mb : smallint;
                id : array[1..7] of char;
                comp : array[1..5] of char;
                sp : array[1..9] of char;
                note : array[1..2] of char;
                end;
Function IsWDSpath(path : string) : Boolean;
procedure SetWDSpath(path : string);
Procedure OpenWDS(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenWDSwin(var ok : boolean);
Procedure ReadWDS(var lin : WDSrec; var ok : boolean);
Procedure NextWDS( var ok : boolean);
procedure CloseWDS ;

var
  WDSpath : string;

implementation

var
   fwds : file of WDSrec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;

Function IsWDSpath(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetWDSpath(path : string);
begin
WDSpath:=noslash(path);
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fwds);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=WDSpath+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(fwds,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(fwds);
ok:=true;
end;

Procedure OpenWDS(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadWDS(var lin : WDSrec; var ok : boolean);
begin
ok:=true;
if eof(fwds) then NextWDS(ok);
if ok then  Read(fwds,lin);
end;

Procedure NextWDS( var ok : boolean);
begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;

procedure CloseWDS ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenWDSwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.

