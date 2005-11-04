unit demo1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, cu_MultiForm, cu_MultiFormChild, Menus, ToolWin,
  ComCtrls, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    NewChild1: TMenuItem;
    SendText1: TMenuItem;
    Window1: TMenuItem;
    TopPanel: TPanel;
    ToolBar1: TToolBar;
    ChildControl: TPanel;
    BtnCloseChild: TBitBtn;
    BtnRestoreChild: TBitBtn;
    MultiForm1: TMultiForm;
    Cascade1: TMenuItem;
    Tile1: TMenuItem;
    N1: TMenuItem;
    Tile2: TMenuItem;
    procedure Close1Click(Sender: TObject);
    procedure NewChild1Click(Sender: TObject);
    procedure CloseChildClick(Sender: TObject);
    procedure SendText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RestoreChildClick(Sender: TObject);
    procedure MultiForm1Maximize(Sender: TObject);
    procedure MultiForm1ActiveChildChange(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure Tile2Click(Sender: TObject);
  private
    { Private declarations }
    basecaption: string;
    procedure SetChildFocus(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

Uses demo_child;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
 basecaption:=caption;
 MultiForm1.WindowList:=Window1;
 MultiForm1.onActiveChildChange:=MultiForm1ActiveChildChange;
 MultiForm1.onMaximize:=MultiForm1Maximize;
 ChildControl.visible:=false;
 BtnCloseChild.Glyph.LoadFromResourceName(HInstance,'CLOSE');
 BtnRestoreChild.Glyph.LoadFromResourceName(HInstance,'RESTORE');
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.NewChild1Click(Sender: TObject);
var Child: TChildPanel;
    f : Tf_child;
begin
  Child:=MultiForm1.NewChild;
  f:=Tf_child.Create(Child);
  f.onWantFocus:=SetChildFocus;
  Child.DockedPanel:=f.Panel1;
  Child.Caption:='demo child '+inttostr(MultiForm1.ChildCount);
  caption:=basecaption+' - '+MultiForm1.ActiveChild.Caption;
end;

procedure TForm1.CloseChildClick(Sender: TObject);
begin
if MultiForm1.ActiveObject is Tf_child then
   MultiForm1.ActiveChild.close;
end;

procedure TForm1.SendText1Click(Sender: TObject);
begin
if MultiForm1.ActiveObject is Tf_child then
   with MultiForm1.ActiveObject as Tf_child do
      Edit1.text:='Text from main';
end;


procedure TForm1.RestoreChildClick(Sender: TObject);
begin
   MultiForm1.Maximized:=not MultiForm1.Maximized;
end;

procedure TForm1.MultiForm1Maximize(Sender: TObject);
begin
 ChildControl.visible:=MultiForm1.Maximized;
end;

procedure TForm1.MultiForm1ActiveChildChange(Sender: TObject);
begin
if MultiForm1.ActiveChild<>nil then
   caption:=basecaption+' - '+MultiForm1.ActiveChild.Caption
else
   caption:=basecaption;
end;

procedure TForm1.SetChildFocus(Sender: TObject);
var i:integer;
begin
for i:=0 to MultiForm1.ChildCount-1 do
   if MultiForm1.Childs[i].DockedObject=Sender then
      MultiForm1.setActiveChild(i);

end;

procedure TForm1.Cascade1Click(Sender: TObject);
begin
 MultiForm1.Cascade;
end;

procedure TForm1.Tile1Click(Sender: TObject);
begin
 MultiForm1.TileVertical;
end;

procedure TForm1.Tile2Click(Sender: TObject);
begin
  MultiForm1.TileHorizontal;
end;

end.
