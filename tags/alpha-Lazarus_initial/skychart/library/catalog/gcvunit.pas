unit gcvunit;
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
    GCVrec =  record ar,de,num :longint ;
                period : single;
                max,min : smallint;
                lmax,lmin,mcode : char;
                gcvs,vartype : array[1..10] of char;
                end;
Function IsGCVpath(path : PChar) : Boolean; stdcall;
procedure SetGCVpath(path : PChar); stdcall;
Procedure OpenGCV(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenGCVwin(var ok : boolean); stdcall;
Procedure ReadGCV(var lin : GCVrec; var ok : boolean); stdcall;
Procedure NextGCV( var ok : boolean); stdcall;
procedure CloseGCV ; stdcall;

var
  GCVpath : string;

implementation

var
   fgcv : file of GCVrec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;
   chkfile : Boolean = true;

Function IsGCVpath(path : PChar) : Boolean; stdcall;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetGCVpath(path : PChar); stdcall;
var buf:string;
begin
buf:=noslash(path);
GCVpath:=buf;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fgcv);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=GCVpath+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; chkfile:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(fgcv,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(fgcv);
ok:=true;
end;

Procedure OpenGCV(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
begin
JDCatalog:=jd2000;
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadGCV(var lin : GCVrec; var ok : boolean);stdcall;
begin
ok:=true;
if eof(fgcv) then NextGCV(ok);
if ok then  Read(fgcv,lin);
end;

Procedure NextGCV( var ok : boolean); stdcall;
begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;

procedure CloseGCV ; stdcall;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenGCVwin(var ok : boolean); stdcall;
begin
JDCatalog:=jd2000;
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.
