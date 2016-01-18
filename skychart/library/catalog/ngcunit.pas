unit ngcunit;
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
    NGCrec = record ar,de :longint ;
                    id    : word;
                    ic    : char;
                    typ   : array [1..3] of char;
                    l_dim : char;
                    n_ma  : char;
                    ma,dim:smallint;
                    cons  : array [1..3] of char;
                    desc  : array[1..50] of char;
                 end;
Function IsNGCpath(path : string) : Boolean;
procedure SetNGCpath(path : string);
Procedure OpenNGC(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenNGCwin(var ok : boolean);
Procedure ReadNGC(var lin : NGCrec; var ok : boolean);
procedure CloseNGC ;

var
  NGCpath : string;

implementation

var
   fngc : file of NGCrec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;

Function IsNGCpath(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetNGCpath(path : string);
begin
NGCpath:=noslash(path);
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fngc);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=NGCpath+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(fngc,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(fngc);
ok:=true;
end;

Procedure OpenNGC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadNGC(var lin : NGCrec; var ok : boolean);
var sm:integer;
begin
ok:=true;
if eof(fngc) then begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;
if ok then  Read(fngc,lin);
end;

procedure CloseNGC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenNGCwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.

