unit pu_addlabel;

{$mode objfpc}{$H+}

interface

uses u_translation, u_constant,
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls;

type

  { Tf_addlabel }

  Tf_addlabel = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    txt: string;
    labelnum:byte;
    Lalign: TLabelAlign;
    procedure SetLang;
  end;

var
  f_addlabel: Tf_addlabel;

implementation

{ Tf_addlabel }

procedure Tf_addlabel.SetLang;
begin
Caption:=rsAddLabel;
Label1.caption:=rsLabel;
Label2.caption:=rsType2;
ComboBox1.items[0]:=rsStar;
ComboBox1.items[1]:=rsVariableStar;
ComboBox1.items[2]:=rsMultipleStar;
ComboBox1.items[3]:=rsNebula;
ComboBox1.items[4]:=rsSolarSystem;
ComboBox1.items[5]:=rsConstellatio;
ComboBox1.items[6]:=rsOtherLabel;
ComboBox1.items[7]:=rsChartInforma;
RadioGroup1.Caption:=rsAlignment;
RadioGroup1.items[0]:=rsLeft;
RadioGroup1.items[1]:=rsCenter;
RadioGroup1.items[2]:=rsRight;
Button1.caption:=rsOk;
Button2.caption:=rsCancel;
end;

procedure Tf_addlabel.Edit1Change(Sender: TObject);
begin
  txt:=edit1.Text;
end;

procedure Tf_addlabel.FormCreate(Sender: TObject);
begin
  SetLang;
end;

procedure Tf_addlabel.FormShow(Sender: TObject);
begin
  txt:=edit1.Text;
  labelnum:=ComboBox1.ItemIndex+1;
  RadioGroup1.ItemIndex:=0;
  Lalign:=laLeft;
end;

procedure Tf_addlabel.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
   0 : Lalign:=laLeft;
   1 : Lalign:=laCenter;
   2 : Lalign:=laRight;
  end;
end;

procedure Tf_addlabel.ComboBox1Select(Sender: TObject);
begin
  labelnum:=ComboBox1.ItemIndex+1;
end;

procedure Tf_addlabel.ComboBox1Change(Sender: TObject);
begin

end;

initialization
  {$I pu_addlabel.lrs}

end.
