{
Copyright (C) 2005 Patrick Chevalley

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
 Set the FOV using a log cursor.
}

procedure Tf_zoom.TrackBar1Change(Sender: TObject);
begin
logfov:=TrackBar1.Position;
fov:=power(10,logfov/100);
fov:=minvalue([360,fov]);
if fov>3 then fov:=round(fov);
Edit1.text:=DeMtoStr(fov);
end;

procedure Tf_zoom.FormShow(Sender: TObject);
begin
logfov:=100*log10(fov);
TrackBar1.Position := Round(logfov);
Edit1.text:=DeMtoStr(fov);
{$ifdef mswindows}
TrackBar1.SetTick(-78);
TrackBar1.SetTick(0);
TrackBar1.SetTick(100);
TrackBar1.SetTick(200);
{$endif}
end;

