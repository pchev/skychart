{
Copyright (C) 2003 Patrick Chevalley

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
 Cross-platform common code for Info form.
}

procedure Tf_info.Button1Click(Sender: TObject);
begin
close;
end;

procedure Tf_info.Button2Click(Sender: TObject);
var i : integer;
    buf:string;
begin
try
stringgrid1.RowCount:=Maxwindow;
if (f_main.TCPDaemon<>nil) then
 with f_main.TCPDaemon do begin
 for i:=1 to Maxwindow do
   if (not f_main.TCPDaemon.ThrdActive[i])
     or(TCPThrd[i]=nil)
     or(TCPThrd[i].sock=nil)
     or(TCPThrd[i].terminated)
     then begin
       buf:=inttostr(i)+' not connected.';
       stringgrid1.Cells[0,i-1]:=buf;
     end
     else begin
       buf:=inttostr(i)+' connected from '+TCPThrd[i].RemoteIP+blank+TCPThrd[i].RemotePort+', using chart '+TCPThrd[i].active_chart+', connect time:'+datetimetostr(TCPThrd[i].connecttime);
       stringgrid1.Cells[0,i-1]:=buf;
     end;
end;
except
end;
end;

procedure Tf_info.StringGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then begin
   stringgrid1.MouseToCell(X, Y, ColClick, RowClick);
   if (ColClick>=0)and(RowClick>=0) then begin
     stringgrid1.Col:=ColClick;
     stringgrid1.Row:=RowClick;
   end;
end;
end;

procedure Tf_info.closeconnectionClick(Sender: TObject);
begin
if (RowClick>=0)
   and(f_main.TCPDaemon.ThrdActive[RowClick+1])
   and(f_main.TCPDaemon<>nil)
   and(f_main.TCPDaemon.TCPThrd[RowClick+1]<>nil)
   then f_main.TCPDaemon.TCPThrd[RowClick+1].Terminate;
end;

procedure Tf_info.FormShow(Sender: TObject);
begin
Button2Click(self);
Timer1.enabled:=CheckBox1.Checked;
end;

procedure Tf_info.CheckBox1Click(Sender: TObject);
begin
Timer1.enabled:=CheckBox1.Checked;
end;

procedure Tf_info.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Timer1.enabled:=false;
end;

procedure Tf_info.Timer1Timer(Sender: TObject);
begin
Timer1.enabled:=false;
try
Button2Click(self);
finally
Timer1.enabled:=CheckBox1.Checked;
end;
end;


