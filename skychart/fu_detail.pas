unit fu_detail;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QExtCtrls, QMenus, QStdActns, QActnList;

type
  Tf_detail = class(TForm)
    Panel1: TPanel;
    memo: TTextBrowser;
    Button1: TButton;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    EditCopy1: TEditCopy;
    PopupMenu1: TPopupMenu;
    SelectAll1: TMenuItem;
    Copy1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure EditSelectAll1Execute(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_detail: Tf_detail;

implementation

{$R *.xfm}

procedure Tf_detail.Button1Click(Sender: TObject);
begin
close;
end;

procedure Tf_detail.EditSelectAll1Execute(Sender: TObject);
begin
memo.SelectAll;
end;

procedure Tf_detail.EditCopy1Execute(Sender: TObject);
begin
memo.CopyToClipboard;
end;

end.
