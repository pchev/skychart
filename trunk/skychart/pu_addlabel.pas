unit pu_addlabel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { Tf_addlabel }

  Tf_addlabel = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure ComboBox1Select(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    txt: string;
    labelnum:byte;
  end; 

var
  f_addlabel: Tf_addlabel;

implementation

{ Tf_addlabel }

procedure Tf_addlabel.Edit1Change(Sender: TObject);
begin
  txt:=edit1.Text;
end;

procedure Tf_addlabel.ComboBox1Select(Sender: TObject);
begin
  labelnum:=ComboBox1.ItemIndex+1;
end;

initialization
  {$I pu_addlabel.lrs}

end.

