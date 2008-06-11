program varobs;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, variables1, aavsochart, detail1,
  ObsUnit, SettingUnit, splashunit, Printer4Lazarus, CDCjdcalendar, u_param,
  downldialog;



{$R manifest.res}

begin
  Application.Initialize;
  Application.CreateForm(TVarForm, VarForm);
  Application.CreateForm(Tsplash, splash);
  splash.SplashTimer:=true;
  splash.Show;
  Application.CreateForm(Tchartform, chartform);
  Application.CreateForm(TDetailForm, DetailForm);
  Application.CreateForm(TObsForm, ObsForm);
  Application.CreateForm(TOptForm, OptForm);
  Application.Run;
end.

