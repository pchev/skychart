unit u_planetrender;
{
Copyright (C) 2004 Patrick Chevalley

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
{
  Interface to libfplanetrender
}
{$mode delphi}{$H+}

interface

Uses
  dynlibs, Graphics, Types;

Type
TSetTexturePath = Procedure (path : shortstring); stdcall;
TRenderMercury = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderVenus = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderMoon = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderMars = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderJupiter = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderSaturn = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderUranus = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderNeptune = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderPluto = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderSun = Procedure (cm,pa,poleincl,mult : double; size : integer; fn:shortstring); stdcall;
TRenderCloselib = Procedure; stdcall;
Var
planetrender: boolean;
Prenderlib : TLibHandle = 0;
UseCount   : Dword = 0;
SetTexturePath : TSetTexturePath;
RenderMercury : TRenderMercury;
RenderVenus : TRenderVenus;
RenderMoon : TRenderMoon;
RenderMars : TRenderMars;
RenderJupiter : TRenderJupiter;
RenderSaturn : TRenderSaturn;
RenderUranus : TRenderUranus;
RenderNeptune : TRenderNeptune;
RenderPluto : TRenderPluto;
RenderSun : TRenderSun;
RenderCloselib : TRenderCloselib;

procedure InitPlanetRender;
procedure ClosePlanetRender;

implementation

procedure ClosePlanetRender;
begin
try
 dec(UseCount);
 if UseCount<=0 then begin
    //if Prenderlib<>0 then RenderCloseLib;
    //UnloadLibrary( Prenderlib );
    Prenderlib:=0;
    UseCount:=0;
 end;
except
end; 
end;

procedure InitPlanetRender;
begin
if Prenderlib=0 then begin
 planetrender:=false;
 {$ifdef win32}
 try
  Prenderlib := LoadLibrary('libFPlanetRender.dll');
  if Prenderlib<>0 then begin
    RenderCloseLib:= TRenderCloseLib(GetProcedureAddress(Prenderlib, 'CloseLib'));
    SetTexturePath:= TSetTexturePath(GetProcedureAddress(Prenderlib, 'SetTexturePath'));
    RenderMercury:= TRenderMercury(GetProcedureAddress(Prenderlib, 'RenderMercury'));
    RenderVenus:= TRenderVenus(GetProcedureAddress(Prenderlib, 'RenderVenus'));
    RenderMoon:= TRenderMoon(GetProcedureAddress(Prenderlib, 'RenderMoon'));
    RenderMars:= TRenderMars(GetProcedureAddress(Prenderlib, 'RenderMars'));
    RenderJupiter:= TRenderJupiter(GetProcedureAddress(Prenderlib, 'RenderJupiter'));
    RenderSaturn:= TRenderSaturn(GetProcedureAddress(Prenderlib, 'RenderSaturn'));
    RenderUranus:= TRenderUranus(GetProcedureAddress(Prenderlib, 'RenderUranus'));
    RenderNeptune:= TRenderNeptune(GetProcedureAddress(Prenderlib, 'RenderNeptune'));
    RenderPluto:= TRenderPluto(GetProcedureAddress(Prenderlib, 'RenderPluto'));
    RenderSun:= TRenderSun(GetProcedureAddress(Prenderlib, 'RenderSun'));
    planetrender:=true;
    inc(UseCount);
  end;
 except
  planetrender:=false;
 end;
{$endif}
end else begin
 inc(UseCount);
end;
end;

end.
