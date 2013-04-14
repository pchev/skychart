unit pu_imglist;

{$mode objfpc}{$H+}

interface

uses u_translation, cu_fits,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  CheckLst, StdCtrls, Menus;

type

  { Tf_imglist }

  Tf_imglist = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckListBox1: TCheckListBox;
    ViewHeader: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    procedure CheckListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ViewHeaderClick(Sender: TObject);
  private
    { private declarations }
    FFits: TFits;
    ListIndex: integer;
  public
    { public declarations }
    procedure SetLang;
    property Fits: TFits read FFits write FFits;
  end;

var
  f_imglist: Tf_imglist;

implementation

{$R *.lfm}

procedure Tf_imglist.CheckListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  APoint: TPoint;
begin
APoint.X := X;
APoint.Y := Y;
ListIndex := CheckListBox1.ItemAtPos(APoint, True);
if ListIndex>=CheckListBox1.Items.Count then ListIndex:=CheckListBox1.Items.Count-1;
if (ListIndex<0) then exit;
CheckListBox1.Selected[ListIndex];
Application.ProcessMessages;
if Button = mbRight then begin
  PopupMenu1.PopUp;
end;
end;

procedure Tf_imglist.FormShow(Sender: TObject);
begin
  ListIndex:=0;
end;

procedure Tf_imglist.ViewHeaderClick(Sender: TObject);
begin
if ListIndex>=CheckListBox1.Items.Count then ListIndex:=CheckListBox1.Items.Count-1;
if (ListIndex<0) then exit;
FFits.FileName:=CheckListBox1.Items[ListIndex];
FFits.ViewHeaders;
end;

procedure Tf_imglist.SetLang;
begin
Caption:=rsImageList;
Button1.Caption:=rsOK;
Button2.Caption:=rsCancel;
ViewHeader.Caption:=rsViewHeader;
end;

end.

