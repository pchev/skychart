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
if not assigned(FGetTCPinfo) then exit;
try
stringgrid1.RowCount:=Maxwindow;
for i:=1 to Maxwindow do begin
   FGetTCPinfo(i,buf);
   stringgrid1.Cells[0,i-1]:=buf;
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
if (RowClick>=0) and assigned(FKillTCP) then
   FKillTCP(RowClick+1);
end;

procedure Tf_info.FormShow(Sender: TObject);
begin
case Pagecontrol1.ActivepageIndex of
0: begin
   Button2Click(self);
   Timer1.enabled:=CheckBox1.Checked;
   end;
1: begin
   memo1.setfocus;
   memo1.SelStart:=0;
   memo1.SelLength:=0;
   end;
end;   
end;

procedure Tf_info.setpage(n:integer);
var i:integer;
begin
Pagecontrol1.ActivepageIndex:=n;
for i:=0 to Pagecontrol1.pagecount-1 do begin
  Pagecontrol1.pages[i].tabvisible:=(i=n);
end;
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


procedure Tf_info.Button3Click(Sender: TObject);
var
{$ifdef linux}
line,col:integer;
{$endif}
{$ifdef mswindows}
pos:integer;
{$endif}
begin
{$ifdef linux}
if memo1.HasSelection then begin
  line:=memo1.Selection.Line2;
  col:=memo1.Selection.Col2;
end else begin
  line:=0;
  col:=0;
end;
if not memo1.Search(edit1.Text,false,true,false,false,line,col) then
   showmessage(edit1.text+' Not Found!');
{$endif}
{$ifdef mswindows}
pos:=memo1.selstart+memo1.sellength;
pos:=memo1.Findtext(Edit1.text,pos,length(memo1.text),[]);
if pos<0 then begin
  memo1.SelStart:=0;
  memo1.SelLength:=0;
  showmessage(edit1.text+' Not Found!');
end else begin
  memo1.setfocus;
  memo1.SelStart:=pos;
  memo1.SelLength:=length(edit1.text);
end;
{$endif}
end;

procedure Tf_info.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=key_cr then Button3Click(sender);
end;

procedure Tf_info.Button5Click(Sender: TObject);
var tmpstr:Tstringlist;
begin
tmpstr:=Tstringlist.Create;
try
screen.cursor:=crhourglass;
tmpstr.assign(memo1.lines);
tmpstr.Sort;
memo1.clear;
memo1.Lines.beginupdate;
memo1.Lines.Assign(tmpstr);
memo1.Lines.endupdate;
finally
screen.cursor:=crdefault;
tmpstr.Free;
end;
end;

procedure Tf_info.Button6Click(Sender: TObject);
begin
try
{$ifdef linux}
Printmemo(memo1);
{$endif}
{$ifdef mswindows}
if assigned(FPrintSetup) then FPrintSetup(Sender);
memo1.Print(' ');
{$endif}
except
end;
end;

{$ifdef linux}
procedure Tf_info.PrintMemo(MemoName : TMemo);
var
  P : TextFile;   { The text file}
  i : integer;     { Loop counter }
begin
Printer.Executesetup;
Printer.Canvas.Font.Name:='courier';
Printer.Canvas.Font.Color:=clBlack;
Printer.Canvas.Font.size:=10;
Printer.Canvas.Font.pitch:=fpFixed;
with AssignPrn(P,Printer) do begin  {unit QPrinters Assign text file to PRN }
  Rewrite(P);      { Open it    }
  try
    try
     for i := 0 to MemoName.Lines.Count - 1 do
         Writeln(P,stringreplace(MemoName.Lines[i],tab,blank,[rfReplaceAll]));
    except on E:EInOutError do
      MessageDlg('Can Not Print error: ' + IntToStr(E.ErrorCode), mtError, [mbOK], 0);
    end;
  finally
    system.CloseFile(P);
  end;
end;
end;
{$endif}

procedure Tf_info.Button7Click(Sender: TObject);
begin
try
Savedialog1.DefaultExt:='.csv';
Savedialog1.filter:='Tab Separated File (*.csv)|*.csv';
Savedialog1.Initialdir:=privatedir;
if SaveDialog1.Execute then
   memo1.Lines.SavetoFile(savedialog1.Filename);
finally
ChDir(appdir);
end;
end;

{$ifdef mswindows}
procedure Tf_info.Memo1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{$endif}
{$ifdef linux}
procedure Tf_info.Memo1DblClick(Sender: TObject);
{$endif}
 var linnum,p : integer;
    ra,dec : double;
    buf,s,desc,nm : string;
begin
{$ifdef mswindows}
linnum:=memo1.CaretPos.y;
{$endif}
{$ifdef linux}
linnum:=memo1.CaretPos.line;
{$endif}
desc:=memo1.Lines[linnum];
p:=pos(tab,desc);
if p>0 then begin
   buf:=copy(desc,2,9999);
   ra:=strtofloat(copy(buf,1,2))+strtofloat(copy(buf,4,2))/60+strtofloat(copy(buf,7,5))/3600;
   delete(buf,1,p-1);
   s:=copy(buf,1,1);
   dec:=strtofloat(s+copy(buf,2,2))+strtofloat(s+copy(buf,4+length(ldeg),2))/60+strtofloat(s+copy(buf,6+length(ldeg)+length(lmin),4))/3600;
   p:=pos(tab,buf); delete(buf,1,p);
   p:=pos(tab,buf); delete(buf,1,p);
   p:=pos(tab,buf);
   nm:=copy(buf,1,p-1);
   if assigned(Fdetailinfo) then Fdetailinfo(source_chart,deg2rad*ra*15,deg2rad*dec,nm,desc);
end;
end;


