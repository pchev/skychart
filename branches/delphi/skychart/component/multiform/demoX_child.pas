unit demoX_child;

interface

uses
  SysUtils, Variants, Classes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QExtCtrls, QMenus;

type
  Tf_child = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Panel2: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
    FonWantFocus: TNotifyEvent;
  public
    { Public declarations }
    Property onWantFocus : TNotifyEvent read FonWantFocus write FonWantFocus;
  end;

var
  f_child: Tf_child;

implementation

{$R *.xfm}

procedure Tf_child.Button1Click(Sender: TObject);
begin
edit1.Text:=Button1.Caption;
end;

procedure Tf_child.RadioGroup1Click(Sender: TObject);
begin
edit1.Text:=RadioGroup1.Items[RadioGroup1.itemindex];
end;

procedure Tf_child.Image1Click(Sender: TObject);
begin
edit1.Text:='image';
if Assigned(FonWantFocus) then FonWantFocus(self);
end;

end.
