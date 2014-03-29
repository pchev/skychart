unit gpnunit;
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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{$mode objfpc}{$H+}
interface

uses
  skylibcat, sysutils;
type
GPNrec = record ar,de :longint ;
                dim,mv,mHb,cs_b,cs_v : smallint;
                ldim,lv,morph,cs_lb,cs_lv : char;
                png : array[1..10] of char;
                pk  : array[1..9] of char;
                name: array[1..13] of char;
                end;
Function IsGPNpath(path : string) : Boolean;
procedure SetGPNpath(path : string);
Procedure OpenGPN(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenGPNwin(var ok : boolean);
Procedure ReadGPN(var lin : GPNrec; var ok : boolean);
procedure CloseGPN ;

var
  GPNpath : string;

implementation

var
   fgpn : file of GPNrec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;

Function IsGPNpath(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetGPNpath(path : string);
var buf:string;
begin
buf:=noslash(path);
GPNpath:=buf;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fgpn);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=GPNpath+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(fgpn,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(fgpn);
ok:=true ;
end;

Procedure OpenGPN(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadGPN(var lin : GPNrec; var ok : boolean);
var sm:integer;
begin
ok:=true;
if eof(fgpn) then begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;
if ok then  Read(fgpn,lin);
end;

procedure CloseGPN ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenGPNwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.

