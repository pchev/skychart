unit pu_config_calendar;

{$mode objfpc}{$H+}

interface

uses  u_help, u_translation, u_constant, u_util,  UScaleDPI,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, fu_config_calendar;

type

  { Tf_configcalendar }

  Tf_configcalendar = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button7: TButton;
    f_config_calendar1: Tf_config_calendar;
    Panel1: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure SetLang;
  end;

var
  f_configcalendar: Tf_configcalendar;

implementation

{$R *.lfm}

procedure Tf_configcalendar.SetLang;
begin
Caption:=rsDateTime;
Button1.caption:=rsOK;
Button2.caption:=rsApply;
Button3.caption:=rsCancel;
Button7.caption:=rsHelp;
SetHelp(self,hlpCfgDate);
end;

procedure Tf_configcalendar.Button2Click(Sender: TObject);
begin
  if assigned(f_config_calendar1.onApplyConfig) then f_config_calendar1.onApplyConfig(f_config_calendar1);
end;

procedure Tf_configcalendar.Button7Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_configcalendar.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  f_config_calendar1.Lock;
end;

procedure Tf_configcalendar.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self,96);
  SetLang;
end;

procedure Tf_configcalendar.FormShow(Sender: TObject);
begin
  f_config_calendar1.Init;
end;

end.

