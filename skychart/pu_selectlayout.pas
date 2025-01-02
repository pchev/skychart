unit pu_selectlayout;

{$mode objfpc}{$H+}

interface

uses  u_translation,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, ExtCtrls;

type

  { Tf_selectlayout }

  Tf_selectlayout = class(TForm)
    ButtonCancel: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseEnter(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButtonMouseLeave(Sender: TObject);
    procedure SpeedButton2MouseEnter(Sender: TObject);
  private

  public
    procedure SetLang;
    procedure ShowCancel(onoff: boolean);
  end;

var
  f_selectlayout: Tf_selectlayout;

implementation

{$R *.lfm}

{ Tf_selectlayout }

procedure Tf_selectlayout.FormCreate(Sender: TObject);
begin
  SetLang;
end;

procedure Tf_selectlayout.SetLang;
begin
  Caption:=rsSkyCharts;
  Panel1.Caption:=rsSelectYourPr;
  Panel4.Caption:=rsThisLayoutCa;
  ButtonCancel.Caption:=rsCancel;
end;

procedure Tf_selectlayout.ShowCancel(onoff: boolean);
begin
  ButtonCancel.Visible:=onoff;
end;

procedure Tf_selectlayout.SpeedButton1MouseEnter(Sender: TObject);
begin
  panel2.Caption:=rsMoreButtonsF;
end;

procedure Tf_selectlayout.SpeedButton2MouseEnter(Sender: TObject);
begin
  panel2.Caption:=rsFewerButtons;
end;

procedure Tf_selectlayout.SpeedButtonMouseLeave(Sender: TObject);
begin
  panel2.Caption:='';
end;

procedure Tf_selectlayout.SpeedButton1Click(Sender: TObject);
begin
  ModalResult:=mrYes;
end;

procedure Tf_selectlayout.SpeedButton2Click(Sender: TObject);
begin
  ModalResult:=mrNo;
end;

end.

