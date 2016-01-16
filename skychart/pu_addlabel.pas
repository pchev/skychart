unit pu_addlabel;

{$mode objfpc}{$H+}

interface

uses u_help, u_translation, u_constant, UScaleDPI,
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, LazHelpHTML;

type

  { Tf_addlabel }

  Tf_addlabel = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    procedure Button3Click(Sender: TObject);
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
{$R *.lfm}

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
Button3.Caption:=rsHelp;
SetHelp(self,hlpLabel);
end;

procedure Tf_addlabel.Edit1Change(Sender: TObject);
begin
  txt:=edit1.Text;
end;

procedure Tf_addlabel.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self,96);
  SetLang;
end;

procedure Tf_addlabel.FormShow(Sender: TObject);
begin
  txt:=edit1.Text;
  labelnum:=ComboBox1.ItemIndex+1;
  RadioGroup1.ItemIndex:=2;
  Lalign:=laLeft;
end;

procedure Tf_addlabel.RadioGroup1Click(Sender: TObject);
begin
// text alignment to left put text on right of object!
  case RadioGroup1.ItemIndex of
   0 : Lalign:=laRight;
   1 : Lalign:=laCenter;
   2 : Lalign:=laLeft;
  end;
end;

procedure Tf_addlabel.ComboBox1Select(Sender: TObject);
begin
  labelnum:=ComboBox1.ItemIndex+1;
end;

procedure Tf_addlabel.Button3Click(Sender: TObject);
begin
  ShowHelp;
end;

end.

