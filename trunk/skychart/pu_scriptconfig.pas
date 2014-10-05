unit pu_scriptconfig;

{$mode objfpc}{$H+}

interface

uses  u_translation, fu_script, u_constant, Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, Grids, StdCtrls, ExtCtrls;

type

  TIntFunct = procedure(val:integer) of object;

  { Tf_scriptconfig }

  Tf_scriptconfig = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
    FScriptSelect: TIntFunct;
  public
    { public declarations }
    Fscript: array of Tf_script;
    procedure SetLang;
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
caption:=rsConfigureToo;
button1.Caption:=rsClose;
StringGrid1.Cells[0, 0]:=rsKey;
StringGrid1.Cells[1,0]:=rsName;
StringGrid1.Cells[2,0]:=rsScript;
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


procedure Tf_scriptconfig.StringGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i,col,row:integer;
    fn:string;
begin
StringGrid1.MouseToCell(X, Y, Col, Row);
if (row>0)and(col=2) then begin
  fn:=StringGrid1.Cells[2,row];
  OpenDialog1.FileName:='';
  if fn='' then OpenDialog1.InitialDir:=PrivateScriptDir
           else OpenDialog1.InitialDir:=ExtractFilePath(fn);
  if OpenDialog1.Execute then begin
     fn:=OpenDialog1.FileName;
     if FileExistsUTF8(fn) then begin
       Fscript[row-1].ScriptFilename:=fn;
       Fscript[row-1].Loadfile;
       StringGrid1.Cells[1,row]:=Fscript[row-1].ScriptTitle;
       StringGrid1.Cells[2,row]:=Fscript[row-1].ScriptFilename;
       if Assigned(FScriptSelect) then FScriptSelect(row-1);
     end;
  end;
end
else if (row>0)and(col<2) then begin
  if Assigned(FScriptSelect) then FScriptSelect(row-1);
end;
end;

end.

