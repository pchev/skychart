unit pu_pascaleditor;

{$mode objfpc}{$H+}

{
Copyright (C) 2014 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

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
 Pascal script editor and debugger.
 The debugger is based on the example in lazarus/components/PascalScript/Samples/Debug/
}

interface

uses  u_translation, u_help, Classes, SysUtils, FileUtil, SynEdit, SynMemo,
  SynHighlighterPas, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, ActnList, StdActns, Buttons, ComCtrls, uPSComponent, uPSDebugger,
  uPSRuntime, SynGutterBase, SynEditMarks, SynEditMarkupSpecialLine,
  SynEditTypes;

type

  { Tf_pascaleditor }

  Tf_pascaleditor = class(TForm)
    ActionList1: TActionList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    ImageList1: TImageList;
    DebugMemo: TMemo;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelDebug: TPanel;
    PopupMenu1: TPopupMenu;
    SynEdit1: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure ButtonPauseClick(Sender: TObject);
    procedure ButtonRunClick(Sender: TObject);
    procedure ButtonStepIntoClick(Sender: TObject);
    procedure ButtonStepOverClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SynEdit1GutterClick(Sender: TObject; X, Y, Line: integer;
      mark: TSynEditMark);
    procedure SynEdit1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SynEdit1SpecialLineColors(Sender: TObject; Line: integer;
      var Special: boolean; var FG, BG: TColor);
    procedure SynEdit1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure ButtonRemoveBreakpoints(Sender: TObject);
  private
    { private declarations }
    Fdbgscr: TPSScriptDebugger;
    FDebugResume: Boolean;
    FActiveLine: Cardinal;
    FScriptName: string;
    procedure SetScriptName(value:string);
    procedure DebugLineInfo(Sender: TObject; const fn: String; Pos, Row, Col: Cardinal);
    procedure DebugBreakpoint(Sender: TObject; const fn: String; Pos, Row, Col: Cardinal);
    procedure DebugIdle(Sender: TObject);
    procedure Startdebug;
  public
    { public declarations }
    procedure SetLang;
    property DebugScript: TPSScriptDebugger read Fdbgscr write Fdbgscr;
    property ScriptName: string read FScriptName write SetScriptName;
  end;

var
  f_pascaleditor: Tf_pascaleditor;

implementation

const
  isRunningOrPaused = [isRunning, isPaused];

{$R *.lfm}

procedure Tf_pascaleditor.FormCreate(Sender: TObject);
begin
  FDebugResume:=false;
  SetLang;
end;

procedure Tf_pascaleditor.FormShow(Sender: TObject);
begin
Fdbgscr.OnLineInfo:=@DebugLineInfo;
Fdbgscr.OnBreakpoint:=@DebugBreakpoint;
Fdbgscr.OnIdle:=@DebugIdle;
FActiveLine := 0;
SynEdit1.Modified:=False;
end;

procedure Tf_pascaleditor.SetLang;
begin
  Caption:=rsScriptEditor;
  Button1.Caption:=rsSave;
  Button2.Caption:=rsCancel;
  Button3.Caption:=rsHelp;
  SetHelp(self,hlpScriptEditor);
end;

procedure Tf_pascaleditor.SetScriptName(value:string);
begin
  if FScriptName<>value then ButtonRemoveBreakpoints(nil);
  FScriptName:=value;
  Caption:=rsScriptEditor+': '+FScriptName;
end;

function GetErrorRowCol(const inStr: string): TPoint;
var
  Row:string;
  Col:string;
  p1,p2,p3:integer;
begin
  p1:=Pos('(',inStr);
  p2:=Pos(':',inStr);
  p3:=Pos(')',inStr);
  if (p1>0) and (p2>p1) and (p3>p2) then
  begin
    Row := Copy(inStr, p1+1,p2-p1-1);
    Col := Copy(inStr, p2+1,p3-p2-1);
    Result.X := StrToInt(Trim(Col));
    Result.Y := StrToInt(Trim(Row));
  end
  else
  begin
    Result.X := 1;
    Result.Y := 1;
  end
end;

procedure Tf_pascaleditor.Startdebug;
var i: integer;
   ok: boolean;
begin
paneldebug.Visible:=true;
paneldebug.BringToFront;
DebugMemo.Clear;
Fdbgscr.Script.Assign(SynEdit1.Lines);
ok:=Fdbgscr.Compile;
if ok then begin
  DebugMemo.Lines.Add('running');
  Application.ProcessMessages;
  Fdbgscr.Exec.DebugEnabled:=true;
  Fdbgscr.StepInto;
  Fdbgscr.Execute;
  paneldebug.Visible:=false;
  FActiveLine := 0;
  SynEdit1.Refresh;
end else begin
  for i:=0 to Fdbgscr.CompilerMessageCount-1 do begin
     DebugMemo.Lines.Add('Error: '+ Fdbgscr.CompilerErrorToStr(i));
     if i=0 then begin
       SynEdit1.CaretXY := GetErrorRowCol(Fdbgscr.CompilerErrorToStr(0));
       FActiveLine:=SynEdit1.CaretY;
       SynEdit1.Refresh;
     end;
  end;
end;
end;

procedure Tf_pascaleditor.ButtonRunClick(Sender: TObject);
begin
if Fdbgscr.Running then
 FDebugResume:=true
else Startdebug;
end;

procedure Tf_pascaleditor.ButtonPauseClick(Sender: TObject);
begin
if Fdbgscr.Exec.Status = isRunning then
  begin
  Fdbgscr.Pause;
  Fdbgscr.StepInto;
  end;
end;

procedure Tf_pascaleditor.ButtonStepIntoClick(Sender: TObject);
begin
if Fdbgscr.Exec.Status in isRunningOrPaused then
  Fdbgscr.StepInto
else
begin
  Startdebug;
end;
end;

procedure Tf_pascaleditor.ButtonStepOverClick(Sender: TObject);
begin
if Fdbgscr.Exec.Status in isRunningOrPaused then
  Fdbgscr.StepOver
else
begin
  Startdebug;
end;
end;

procedure Tf_pascaleditor.ButtonStopClick(Sender: TObject);
begin
if Fdbgscr.Exec.Status in isRunningOrPaused then
  Fdbgscr.Stop;
end;

procedure Tf_pascaleditor.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
if SynEdit1.Modified and (ModalResult<>mrOK) then begin
   CanClose:=(MessageDlg('Abandon your changes?',mtConfirmation,mbYesNo,0)=mrYes);
end;
end;

procedure Tf_pascaleditor.ButtonRemoveBreakpoints(Sender: TObject);
var i,l: integer;
begin
  for i:=0 to SynEdit1.Marks.Count-1 do begin
    l:=SynEdit1.Marks[i].Line;
    if Fdbgscr.HasBreakPoint('',l) then Fdbgscr.ClearBreakPoint('',l);
    SynEdit1.Marks[i].Visible:=false;
  end;
end;

procedure Tf_pascaleditor.SynEdit1GutterClick(Sender: TObject; X, Y, Line: integer; mark: TSynEditMark);
var  m: TSynEditMark;
begin
  if SynEdit1.Marks.Line[Line]<>nil then m:=SynEdit1.Marks.Line[Line][0] else m:=nil;
  if m=nil then begin
    m := TSynEditMark.Create(SynEdit1);
    m.Line := Line;
    m.ImageList := ImageList1;
    m.Visible := false;
    SynEdit1.Marks.Add(m);
  end;
  if m.Visible then begin
    m.Visible := false;
    if Fdbgscr.HasBreakPoint('',Line) then Fdbgscr.ClearBreakPoint('',Line);
  end else begin
    m.ImageIndex := 0;
    m.Visible := true;
    Fdbgscr.SetBreakPoint('',Line);
  end;
end;

procedure Tf_pascaleditor.SynEdit1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var pt:Tpoint;
    str,val:string;
begin
if Fdbgscr.Exec.Status in isRunningOrPaused then begin
  if SynEdit1.SelText<>'' then
    str:=SynEdit1.SelText
  else begin
    pt:=SynEdit1.PixelsToRowColumn(point(x,y));
    str:=SynEdit1.GetWordAtRowCol(pt);
  end;
  if str<>'' then begin
    val:=Fdbgscr.GetVarContents(str);
    DebugMemo.Lines.Add(str+' = '+val);
    DebugMemo.SelStart:=length(DebugMemo.Text);
  end;
end;
end;

procedure Tf_pascaleditor.SynEdit1SpecialLineColors(Sender: TObject;
  Line: integer; var Special: boolean; var FG, BG: TColor);
begin
  if Fdbgscr.Exec.Status in isRunningOrPaused then begin
    if Fdbgscr.HasBreakPoint('', Line) then
    begin
      Special := True;
      if Line = FActiveLine then
      begin
        BG := clRed;
        FG := clWhite;
      end else
      begin
        BG := clWindow;
        FG := clWindowText;
      end;
    end else
    if Line = FActiveLine then
    begin
      Special := True;
      BG := clBlue;
      FG := clWhite;
    end else Special := False;
  end else if Line = FActiveLine then
  begin
    Special := True;
    BG := clYellow;
    FG := clWindowText;
  end else Special := False;
end;

procedure Tf_pascaleditor.SynEdit1StatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  label1.Caption := IntToStr(SynEdit1.CaretY)+':'+IntToStr(SynEdit1.CaretX)
end;

procedure Tf_pascaleditor.DebugLineInfo(Sender: TObject; const fn: String; Pos, Row, Col: Cardinal);
begin
  if (Fdbgscr.Exec.DebugMode <> dmRun) and (Fdbgscr.Exec.DebugMode <> dmStepOver) then
  begin
    FActiveLine := Row;
    if (FActiveLine < SynEdit1.TopLine +2) or (FActiveLine > SynEdit1.TopLine + SynEdit1.LinesInWindow -2) then
    begin
      SynEdit1.TopLine := FActiveLine - (SynEdit1.LinesInWindow div 2);
    end;
    SynEdit1.CaretY := FActiveLine;
    SynEdit1.CaretX := 1;
    SynEdit1.Refresh;
  end
  else
    Application.ProcessMessages;
end;

procedure Tf_pascaleditor.DebugBreakpoint(Sender: TObject; const fn: String; Pos, Row, Col: Cardinal);
begin
 FDebugResume:=false;
 Fdbgscr.Pause;
 DebugMemo.Lines.Add('break row:'+inttostr(row)+' col:'+inttostr(col));
 FActiveLine := Row;
 if (FActiveLine < SynEdit1.TopLine +2) or (FActiveLine > SynEdit1.TopLine + SynEdit1.LinesInWindow -2) then
 begin
   SynEdit1.TopLine := FActiveLine - (SynEdit1.LinesInWindow div 2);
 end;
 SynEdit1.CaretY := FActiveLine;
 SynEdit1.CaretX := 1;
 SynEdit1.Refresh;
 Application.ProcessMessages;
end;

procedure Tf_pascaleditor.DebugIdle(Sender: TObject);
begin
Application.ProcessMessages;
if FDebugResume then begin
   FDebugResume:=false;
   Fdbgscr.Resume;
   FActiveLine := 0;
   SynEdit1.Refresh;
end;
end;

end.

