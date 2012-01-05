unit gscunit;
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
  gscconst,
  skylibcat, sysutils;

  type GSCrec = record
                     ar,de : longint;
                     gscn: word;
                     pe,m,me :smallint;
                     mb,cl : shortint;
                     mult : char;
                     end;

Function IsGSCpath(path : shortstring) : Boolean; stdcall;
procedure SetGSCpath(path : shortstring); stdcall;
Procedure OpenGSC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall;
Procedure OpenGSCwin(var ok : boolean); stdcall;
Procedure ReadGSC(var lin : GSCrec; var SMnum : shortstring ; var ok : boolean); stdcall;
Procedure NextGSC( var ok : boolean); stdcall;
procedure CloseGSC ; stdcall;
Procedure FindGSCnum(SMnum,num :Integer; var ar,de : Double; var ok : boolean); stdcall;

var
  GSCpath: String;

implementation

var
   fgsc : file of GSCrec ;
   lin : GSCrec ;
   curSM : integer;
   SMname : string;
   hemis : char;
   zone,Sm,nSM : integer;
   hemislst : array[1..9537] of char;
   zonelst,SMlst : array[1..9537] of integer;
   FileIsOpen : Boolean = false;

Function IsGSCpath(path : shortstring) : Boolean;
var p : string;
begin
p:=slash(path);
result:=    FileExists(p+'n0000'+slashchar+'0001.dat')
         or FileExists(p+'n0730'+slashchar+'0594.dat')
         or FileExists(p+'n1500'+slashchar+'1178.dat')
         or FileExists(p+'n2230'+slashchar+'1729.dat')
         or FileExists(p+'n3000'+slashchar+'2259.dat')
         or FileExists(p+'n3730'+slashchar+'2781.dat')
         or FileExists(p+'n4500'+slashchar+'3246.dat')
         or FileExists(p+'n5230'+slashchar+'3652.dat')
         or FileExists(p+'n6000'+slashchar+'4014.dat')
         or FileExists(p+'n6730'+slashchar+'4294.dat')
         or FileExists(p+'n7500'+slashchar+'4492.dat')
         or FileExists(p+'n8230'+slashchar+'4615.dat')
         or FileExists(p+'s0000'+slashchar+'4663.dat')
         or FileExists(p+'s0730'+slashchar+'5260.dat')
         or FileExists(p+'s1500'+slashchar+'5838.dat')
         or FileExists(p+'s2230'+slashchar+'6412.dat')
         or FileExists(p+'s3000'+slashchar+'6989.dat')
         or FileExists(p+'s3730'+slashchar+'7523.dat')
         or FileExists(p+'s4500'+slashchar+'8022.dat')
         or FileExists(p+'s5230'+slashchar+'8464.dat')
         or FileExists(p+'s6000'+slashchar+'8840.dat')
         or FileExists(p+'s6730'+slashchar+'9134.dat')
         or FileExists(p+'s7500'+slashchar+'9346.dat')
         or FileExists(p+'s8230'+slashchar+'9490.dat')
end;

procedure SetGSCpath(path : shortstring);
begin
path:=noslash(path);
GSCpath:=path;
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fgsc);
end;
{$I+}
end;

Procedure OpenRegion(hemis : char ;zone,S : integer ; var ok:boolean);
var nomzone,nomreg,nomfich :string;
begin
str(S:4,nomreg);
str(abs(zone):4,nomzone);
nomfich:=GSCpath+slashchar+hemis+padzeros(nomzone,4)+slashchar+padzeros(nomreg,4)+'.dat';
if not FileExists(nomfich) then begin
   ok:=false;
   exit;
end;
if fileisopen then CloseRegion;
AssignFile(fgsc,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(fgsc);
ok:=true;
end;

Procedure OpenGSC(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
curSM:=1;
ar1:=ar1*15; ar2:=ar2*15;
if usecache then FindRegionList(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst)
            else FindRegionAll(ar1,ar2,de1,de2,nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

Procedure ReadGSC(var lin : GSCrec; var SMnum : shortstring ; var ok : boolean);
begin
if eof(fgsc) then NextGSC(ok);
if ok then  Read(fgsc,lin);
SMnum:=SMname;
end;

Procedure NextGSC( var ok : boolean);
begin
  CloseRegion;
  inc(curSM);
  if curSM>nSM then ok:=false
  else begin
    hemis:= hemislst[curSM];
    zone := zonelst[curSM];
    Sm := Smlst[curSM];
    OpenRegion(hemis,zone,Sm,ok);
  end;
end;

procedure CloseGSC ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure FindGSCnum(SMnum,num :Integer; var ar,de : Double; var ok : boolean);
const dirlst : array [0..23,1..5] of char =
      ('s8230','s7500','s6730','s6000','s5230','s4500','s3730','s3000','s2230','s1500','s0730','s0000',
       'n0000','n0730','n1500','n2230','n3000','n3730','n4500','n5230','n6000','n6730','n7500','n8230');
var L1,S1,zone,i,j : integer;
    hemis : char;
begin
ok:=false ;
for i:=0 to 11 do begin
  L1:=lg_reg_x[i,2] ;
  S1:=sm_reg_x[L1,1] ;
  if SMnum>=S1 then begin ok:=true; break; end;
end;
if not ok then begin
for i:=0 to 11 do begin
  j:=23-i;
  L1:=lg_reg_x[j,2] ;
  S1:=sm_reg_x[L1,1] ;
  if SMnum>=S1 then  break;
end;
i:=j;
end;
hemis:=dirlst[i,1];
zone:=strtoint(copy(dirlst[i],2,4));
OpenRegion(hemis,zone,Smnum,ok);
ok:=false;
repeat
    Read(fgsc,lin);
    if lin.gscn=num then begin ok:=true; break; end;
until eof(fgsc);
if ok then begin
  ar:=lin.ar/100000/15;
  de:=lin.de/100000;
end;
Closeregion;
end;

Procedure OpenGSCwin(var ok : boolean);
begin
curSM:=1;
if usecache then FindRegionListWin(nSM,zonelst,SMlst,hemislst)
            else FindRegionAllWin(nSM,zonelst,SMlst,hemislst);
hemis:= hemislst[curSM];
zone := zonelst[curSM];
Sm := Smlst[curSM];
OpenRegion(hemis,zone,Sm,ok);
end;

end.

