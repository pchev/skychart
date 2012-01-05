unit rc3unit;
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
RC3rec = record ar,de,vgsr :longint ;
                pgc   : array[1..8] of char;
                nom   : array [1..14] of char;
                typ   : array [1..7] of char;
                pa    : byte;
                stage,lumcl,d25,r25,Ae,mb,b_vt,b_ve,m25,me : smallint;
                end;
Function IsRC3path(path : shortstring) : Boolean; stdcall;
procedure SetRC3path(path : shortstring); stdcall;
Procedure OpenRC3(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenRC3win(var ok : boolean); stdcall;
Procedure ReadRC3(var lin : RC3rec; var ok : boolean); stdcall;
procedure CloseRC3 ; stdcall;

var
  RC3path : string;

implementation

var
   frc3 : file of RC3rec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..50] of integer;
   FileIsOpen : Boolean = false;
   chkfile : Boolean = true;

Function IsRC3path(path : shortstring) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetRC3path(path : shortstring);
begin
path:=noslash(path);
RC3path:=path;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(frc3);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=RC3path+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; chkfile:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(frc3,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(frc3);
ok:=true;
end;

Procedure OpenRC3(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
FindRegionList30(ar1,ar2,de1,de2,nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadRC3(var lin : RC3rec; var ok : boolean);
var sm:integer;
begin
ok:=true;
if eof(frc3) then begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    Sm := Smlst[curSM];
    OpenRegion(Sm,ok);
  end;
end;
if ok then  Read(frc3,lin);
end;

procedure CloseRC3 ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenRC3win(var ok : boolean);
begin
curSM:=1;
FindRegionListWin30(nSM,SMlst);
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

end.
