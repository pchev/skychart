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
    if Application.HasOption('p', 'project') then begin
       f_catgen.autoproject:=Application.GetOptionValue('p', 'project');
       f_catgen.autorun:=true;
    end;
    if Application.HasOption('i', 'input') then begin
       f_catgen.autoinput:=Application.GetOptionValue('i', 'input');
       f_catgen.autorun:=true;
    end;
    if (ParamCount()>0) and (not f_catgen.autorun) then begin
       f_catgen.autoproject:=ParamStr(1);
    end;
  end;

  Application.Run;
end.

