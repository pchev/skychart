program catgen;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, pu_catgen, enhedit, radec, mrecsort, cdccatalog
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tf_catgen, f_catgen);

  // process parameters here so this is not done when running from CdC
  if ParamCount()>0 then begin
    f_catgen.autorun:=true;
    if Application.HasOption('p', 'project') then
       f_catgen.autoproject:=Application.GetOptionValue('p', 'project');
    if Application.HasOption('i', 'input') then
       f_catgen.autoinput:=Application.GetOptionValue('i', 'input');
  end;

  Application.Run;
end.

