unit pu_detail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, StdActns, ActnList;

type
  Tf_detail = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    memo: TRichEdit;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    EditCopy1: TEditCopy;
    PopupMenu1: TPopupMenu;
    SelectAll1: TMenuItem;
    Copy1: TMenuItem;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_detail: Tf_detail;

implementation

{$R *.dfm}

procedure Tf_detail.Button1Click(Sender: TObject);
begin
close;
end;

end.
