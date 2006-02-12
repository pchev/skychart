program cdc;

{$mode objfpc}{$H+}

uses
  {$ifdef unix}
  cthreads,  // Unix thread support, must be first!
  {$endif}
  Interfaces, // this includes the LCL widgetset
  Forms, cu_catalog, cu_skychart, cu_plot, cu_planet,
  cu_indiclient, cu_fits, cu_database, cu_telescope, pu_info, pu_image,
  pu_getdss, pu_detail, pu_chart, pu_calendar, pu_zoom, pu_about, pu_search,
  pu_printsetup, pu_position, pu_manualtelescope, u_projection,
  u_planetrender, u_constant, u_util, MultiDocPackage, pu_main,
  TurboPowerIPro, pu_config, wizardntb, enhedit, pu_config_catalog,
  pu_config_system, pu_config_solsys, pu_config_pictures, pu_config_observatory,
  pu_config_display, pu_config_chart, pu_config_time, libsql,
  radec, XmlParser, zoomimage, JPEGForLazarus, CDCjdcalendar, cdccatalog, satxy,
  series96, elp82, Printer4Lazarus, downldialog, synapse;

begin
  Application.Title:='Cartes du Ciel';
  Application.Initialize;

  f_about := Tf_about.Create(nil);
  f_about.ShowTimer:=true; f_about.Show; f_about.Paint;
  Application.ProcessMessages;

  Application.CreateForm(Tf_main, f_main);
  Application.CreateForm(Tf_position, f_position);
  Application.CreateForm(Tf_search, f_search);
  Application.CreateForm(Tf_zoom, f_zoom);
  Application.CreateForm(Tf_getdss, f_getdss);
  Application.CreateForm(Tf_manualtelescope, f_manualtelescope);
  Application.CreateForm(Tf_detail, f_detail);
  Application.CreateForm(Tf_info, f_info);
  Application.CreateForm(Tf_calendar, f_calendar);
  Application.CreateForm(Tf_printsetup, f_printsetup);
  f_main.init;
  Application.Run;
  f_about.free;
end.

