unit pu_pascaleditor;

{$mode objfpc}{$H+}

interface

uses  u_translation, u_help,
  Classes, SysUtils, FileUtil, SynEdit, SynMemo, SynHighlighterPas, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Menus, ActnList, StdActns;

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
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    SynEdit1: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure SetLang;
  end;

var
  f_pascaleditor: Tf_pascaleditor;

implementation

{$R *.lfm}

procedure Tf_pascaleditor.FormCreate(Sender: TObject);
begin
  SetLang;
end;

procedure Tf_pascaleditor.SetLang;
begin
  Caption:=rsScriptEditor;
  Button1.Caption:=rsSave;
  Button2.Caption:=rsCancel;
  Button3.Caption:=rsHelp;
  SetHelp(self,hlpScriptEditor);
end;

end.

