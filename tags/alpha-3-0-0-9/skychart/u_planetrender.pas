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
  Interface to libplanetrender
}

interface

Uses
{$ifdef mswindows}
   Windows, Graphics,
{$endif}
{$ifdef linux}
   QGraphics,
{$endif}
Types;

Type
TSetTexturePath = Procedure (path : shortstring); stdcall;
TRenderMercury = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderVenus = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderMoon = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderMars = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderJupiter = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderSaturn = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderUranus = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderNeptune = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderPluto = Procedure (cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderSun = Procedure (cm,pa,poleincl,mult : double; size : integer; bmp : tbitmap); stdcall;
TRenderCloselib = Procedure; stdcall;
Var
planetrender: boolean;
Prenderlib : Dword = 0;
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
    if Prenderlib<>0 then RenderCloseLib;
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
 {$ifdef mswindows}
 try
  Prenderlib := LoadLibrary('libplanetrender.dll');
  if Prenderlib<>0 then begin
    RenderCloseLib:= TRenderCloseLib(GetProcAddress(Prenderlib, 'CloseLib'));
    SetTexturePath:= TSetTexturePath(GetProcAddress(Prenderlib, 'SetTexturePath'));
    RenderMercury:= TRenderMercury(GetProcAddress(Prenderlib, 'RenderMercury'));
    RenderVenus:= TRenderVenus(GetProcAddress(Prenderlib, 'RenderVenus'));
    RenderMoon:= TRenderMoon(GetProcAddress(Prenderlib, 'RenderMoon'));
    RenderMars:= TRenderMars(GetProcAddress(Prenderlib, 'RenderMars'));
    RenderJupiter:= TRenderJupiter(GetProcAddress(Prenderlib, 'RenderJupiter'));
    RenderSaturn:= TRenderSaturn(GetProcAddress(Prenderlib, 'RenderSaturn'));
    RenderUranus:= TRenderUranus(GetProcAddress(Prenderlib, 'RenderUranus'));
    RenderNeptune:= TRenderNeptune(GetProcAddress(Prenderlib, 'RenderNeptune'));
    RenderPluto:= TRenderPluto(GetProcAddress(Prenderlib, 'RenderPluto'));
    RenderSun:= TRenderSun(GetProcAddress(Prenderlib, 'RenderSun'));
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
