unit pu_scriptconfig;

{$mode objfpc}{$H+}

interface

uses  u_translation, fu_script, u_constant, u_util,
  Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, Grids, StdCtrls, ExtCtrls, Menus;

type

  TIntFunct = procedure(val:integer) of object;

  { Tf_scriptconfig }

  Tf_scriptconfig = class(TForm)
    Button1: TButton;
    MenuItemSelect: TMenuItem;
    MenuItemDelete: TMenuItem;
    MenuItemOpen: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    SelectPopup: TPopupMenu;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure MenuItemSelectClick(Sender: TObject);
    procedure MenuItemDeleteClick(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
    FScriptSelect: TIntFunct;
    CurCol,CurRow:integer;
  public
    { public declarations }
    Fscript: array of Tf_script;
    procedure SetLang;
    Procedure LoadScript(row:integer; fn:string);
    Procedure SelectFile(row:integer);
    Procedure MenuSelectClick(Sender: TObject);
    Procedure OpenFile(row:integer);
    property onScriptSelect : TIntFunct read FScriptSelect write FScriptSelect;
  end;

var
  f_scriptconfig: Tf_scriptconfig;

implementation

const numscript=8;

{$R *.lfm}

{ Tf_scriptconfig }

procedure Tf_scriptconfig.SetLang;
begin
caption:=rsManageToolbo;
button1.Caption:=rsClose;
StringGrid1.Cells[0, 0]:=rsKey;
StringGrid1.Cells[1,0]:=rsName;
StringGrid1.Cells[2,0]:=rsScript;
MenuItemSelect.Caption:=rsSelectScript;
MenuItemOpen.Caption:=rsOpenScript;
MenuItemDelete.Caption:=rsDelete;
end;

procedure Tf_scriptconfig.FormCreate(Sender: TObject);
var i: integer;
begin
  StringGrid1.ColWidths[1]:=150;
  StringGrid1.ColWidths[2]:=350;
  StringGrid1.RowCount:=numscript+1;
  for i:=1 to numscript do StringGrid1.Cells[0,i]:='F'+inttostr(i);
  SetLang;
end;

procedure Tf_scriptconfig.FormShow(Sender: TObject);
var i: integer;
begin
for i:=0 to numscript-1 do begin
  StringGrid1.Cells[1,i+1]:=Fscript[i].ScriptTitle;
  StringGrid1.Cells[2,i+1]:=Fscript[i].ScriptFilename;
end;
end;

Procedure Tf_scriptconfig.LoadScript(row:integer;fn:string);
var i: integer;
begin
 if FileExistsUTF8(fn) and (row>0) and (row<StringGrid1.RowCount) then begin
   for i:=1 to StringGrid1.RowCount-1 do begin
     if i=row then continue;
      if StringGrid1.Cells[2,i]=fn then begin
       if MessageDlg(Format(rsScriptIsAlre, ['F'+inttostr(i)+crlf, 'F'+inttostr(row)]),mtConfirmation, mbYesNo, 0)=mrNo then exit;
       break;
     end;
   end;
   Fscript[row-1].ScriptFilename:=fn;
   Fscript[row-1].Loadfile;
   StringGrid1.Cells[1,row]:=Fscript[row-1].ScriptTitle;
   StringGrid1.Cells[2,row]:=Fscript[row-1].ScriptFilename;
   if Assigned(FScriptSelect) then FScriptSelect(row-1);
 end;
end;

Procedure Tf_scriptconfig.SelectFile(row:integer);
var fl:TStringList;
    fs: TSearchRec;
    i,n:integer;
    mf:TMenuItem;
begin
fl:=TStringList.Create;
i:=FindFirstUTF8(slash(ScriptDir)+'*.cdcps',faAnyFile,fs);
while i=0 do begin
  fl.Add(slash(ScriptDir)+fs.Name);
  i:=FindNextUTF8(fs);
end;
FindCloseUTF8(fs);
i:=FindFirstUTF8(slash(PrivateScriptDir)+'*.cdcps',faAnyFile,fs);
while i=0 do begin
  fl.Add(slash(PrivateScriptDir)+fs.Name);
  i:=FindNextUTF8(fs);
end;
FindCloseUTF8(fs);
if fl.Count>0 then begin
  for i:=SelectPopup.Items.Count-1 downto 0 do  SelectPopup.Items.Delete(i);
  for i:=0 to fl.Count-1 do begin
    mf:=TMenuItem.Create(self);
    mf.Caption:=fl[i];
    mf.Tag:=row;
    mf.OnClick:=@MenuSelectClick;
    SelectPopup.Items.Add(mf);
  end;
  SelectPopup.PopUp(mouse.cursorpos.x,mouse.cursorpos.y);
end;
fl.Free;
end;

Procedure Tf_scriptconfig.MenuSelectClick(Sender: TObject);
var fn:string;
    row:integer;
begin
  fn:=TMenuItem(Sender).Caption;
  row:=TMenuItem(Sender).Tag;
  LoadScript(row,fn);
end;

Procedure Tf_scriptconfig.OpenFile(row:integer);
var fn:string;
begin
fn:=StringGrid1.Cells[2,row];
OpenDialog1.FileName:='';
if fn='' then OpenDialog1.InitialDir:=ScriptDir
         else OpenDialog1.InitialDir:=ExtractFilePath(fn);
if OpenDialog1.Execute then begin
   LoadScript(row,OpenDialog1.FileName);
end;
end;

procedure Tf_scriptconfig.MenuItemSelectClick(Sender: TObject);
begin
if (CurRow>0) then begin
  SelectFile(CurRow);
end;
end;

procedure Tf_scriptconfig.MenuItemOpenClick(Sender: TObject);
begin
if (CurRow>0) then begin
  OpenFile(CurRow);
end;
end;

procedure Tf_scriptconfig.MenuItemDeleteClick(Sender: TObject);
begin
Fscript[CurRow-1].ScriptFilename:='';
Fscript[CurRow-1].Loadfile;
StringGrid1.Cells[1,CurRow]:=Fscript[CurRow-1].ScriptTitle;
StringGrid1.Cells[2,CurRow]:=Fscript[CurRow-1].ScriptFilename;
if Assigned(FScriptSelect) then FScriptSelect(CurRow-1);
end;

procedure Tf_scriptconfig.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
StringGrid1.MouseToCell(X, Y, CurCol, CurRow);
end;

procedure Tf_scriptconfig.StringGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i,col,row:integer;
begin
StringGrid1.MouseToCell(X, Y, Col, Row);
if (row>0)and(col=2) then begin
  SelectFile(row);
end
else if (row>0)and(col<2) then begin
  if Assigned(FScriptSelect) then FScriptSelect(row-1);
end;
end;

end.

