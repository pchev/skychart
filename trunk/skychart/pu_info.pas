unit pu_info;

{$MODE Delphi}{$H+}

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
 Information Form (TCP/IP Server, Object list, ...)
}

interface

uses u_help, u_translation, u_constant, u_util,
  SysUtils, Types, Classes, Controls, Forms, Printers, Graphics,
  Dialogs, StdCtrls, Grids, ComCtrls, ExtCtrls, Menus, StdActns, ActnList,
  LResources, Buttons, SynEdit, LazHelpHTML;

type
  Tistrfunc = procedure(i:integer; var txt:string) of object;
  Tint1func = procedure(i:integer) of object;
  Tdetinfo  = procedure(chart:string;ra,dec:double;nm,desc:string) of object;

  { Tf_info }

  Tf_info = class(TForm)
    Button4: TButton;
    InfoMemo: TMemo;
    Page1: TPanel;
    Page2: TPanel;
    Page3: TPanel;
    Page4: TPanel;
    TitlePanel: TPanel;
    serverinfo: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TSynEdit;
    StringGrid1: TStringGrid;
    Panel2: TPanel;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    closeconnection: TMenuItem;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    Panel3: TPanel;
    Button3: TButton;
    Edit1: TEdit;
    Button5: TButton;
    PopupMenu2: TPopupMenu;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    EditCopy1: TEditCopy;
    outslectionner1: TMenuItem;
    Copier1: TMenuItem;
    Button6: TButton;
    Button7: TButton;
    SaveDialog1: TSaveDialog;
    ProgressMemo: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure closeconnectionClick(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
    FGetTCPinfo : Tistrfunc;
    FKillTCP : Tint1func;
    FPrintSetup: TNotifyEvent;
    Fdetailinfo: Tdetinfo;
    RowClick,ColClick :integer;
    Fnightvision:boolean;
    ActivePage:Integer;
  public
    { Public declarations }
    source_chart:string;
    procedure setpage(n:integer);
    procedure SetLang;
    property OnGetTCPinfo: Tistrfunc read FGetTCPinfo write FGetTCPinfo;
    property OnKillTCP: Tint1func read FKillTCP write FKillTCP;
    property OnPrintSetup: TNotifyEvent read FPrintSetup write FPrintSetup;
    property OnShowDetail: Tdetinfo read Fdetailinfo write Fdetailinfo;
  end;

var
  f_info: Tf_info;

implementation

procedure Tf_info.SetLang;
begin
Caption:=rsInfo;
Button2.caption:=rsRefresh;
CheckBox1.caption:=rsAutoRefresh;
Button3.caption:=rsSearch;
Button4.caption:=rsHelp;
Button5.caption:=rsSortByRA;
Button6.caption:=rsPrint;
Button7.caption:=rsSave;
Button1.caption:=rsClose;
closeconnection.caption:=rsCloseConnect;
outslectionner1.caption:=rsSelectAll;
Copier1.caption:=rsCopy;
end;

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

procedure Tf_info.Button4Click(Sender: TObject);
begin
  ShowHelp;
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

procedure Tf_info.EditCopy1Execute(Sender: TObject);
begin
 memo1.CopyToClipboard;
end;

procedure Tf_info.EditSelectAll1Execute(Sender: TObject);
begin
 memo1.SelectAll;
end;

procedure Tf_info.FormCreate(Sender: TObject);
begin
 page1.Align:=alClient;
 page2.Align:=alClient;
 page3.Align:=alClient;
 page4.Align:=alClient;
 SetLang;
 Fnightvision:=false;
end;

procedure Tf_info.Memo1DblClick(Sender: TObject);
 var linnum,p : integer;
    ra,dec : double;
    buf,s,desc,nm : string;
begin
linnum:=memo1.CaretY-1;
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

procedure Tf_info.FormShow(Sender: TObject);
var
  i: Integer;
begin
{$ifdef mswindows}
if Fnightvision<>nightvision then begin
   SetFormNightVision(self,nightvision);
   Fnightvision:=nightvision;
end;
{$endif}
case Activepage of
0: begin
   panel1.visible:=true;
   Button2Click(self);
   Timer1.enabled:=CheckBox1.Checked;
   SetHelp(self,hlpSrvInfo);
   end;
1: begin
   panel1.visible:=true;
   for i:=memo1.Lines.Count to memo1.LinesInWindow do memo1.Lines.Add(' ');
   memo1.setfocus;
   memo1.SelStart:=0;
   memo1.SelEnd:=0;
   SetHelp(self,hlpObjList);
   end;
2: begin
   panel1.visible:=false;
   f_info.ProgressMemo.clear;
   SetHelp(self,hlpIndex);
   end;
3: begin
   panel1.visible:=true;
   SetHelp(self,hlpIndex);
   end;
end;
end;

procedure Tf_info.setpage(n:integer);
begin
if n<>3 then Button1.caption:=rsClose;
Activepage:=n;
Page1.Visible:=(n=0);
Page2.Visible:=(n=1);
Page3.Visible:=(n=2);
Page4.Visible:=(n=3);
case ActivePage of
 0: TitlePanel.Caption:=rsTCPIPConnect;
 1: TitlePanel.Caption:=rsObjectList;
 2: TitlePanel.Caption:=rsProgressMess;
 3: TitlePanel.Caption:=rsProgramInfor;
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
begin
if memo1.SearchReplace(Edit1.text,'',[])=0
   then showmessage(Format(rsNotFound, [Edit1.text]));
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
memo1.Lines.clear;
memo1.Lines.beginupdate;
memo1.Lines.Assign(tmpstr);
memo1.Lines.endupdate;
finally
screen.cursor:=crdefault;
tmpstr.Free;
end;
end;

procedure Tf_info.Button6Click(Sender: TObject);
var i: integer;
    list:TStringList;
    buf:string;
begin
list:=TStringList.create;
for i:=0 to memo1.Lines.count-1 do begin
  buf:=memo1.Lines[i];
  buf:=StringReplace(buf,tab,blank,[]); // remove first two tabs
  buf:=StringReplace(buf,tab,blank,[]); // because coordinates are fixed column
  buf:=ExpandTab(buf,memo1.TabWidth);
  list.add(buf);
end;
PrintStrings(list, 'CdC', rsObjectList, '', poLandscape);
list.free;
end;

procedure Tf_info.Button7Click(Sender: TObject);
begin
try
Savedialog1.DefaultExt:='.csv';
Savedialog1.filter:='Tab Separated File (*.csv)|*.csv';
Savedialog1.Title:=rsSaveToFile;
Savedialog1.Initialdir:=privatedir;
if SaveDialog1.Execute then
   memo1.Lines.SavetoFile(savedialog1.Filename);
finally
ChDir(appdir);
end;
end;

initialization
  {$i pu_info.lrs}

end.
