program cdc_vcl;
{
Copyright (C) 2002 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
  Windows VCL application 
}

uses
  Forms,
  pu_main in 'pu_main.pas' {f_main},
  pu_chart in 'pu_chart.pas' {f_chart},
  pu_about in 'pu_about.pas' {f_about},
  u_util in 'u_util.pas',
  cu_plot in 'cu_plot.pas',
  cu_skychart in 'cu_skychart.pas',
  u_constant in 'u_constant.pas',
  u_projection in 'u_projection.pas',
  cu_catalog in 'cu_catalog.pas',
  pu_config in 'pu_config.pas' {f_config},
  cu_planet in 'cu_planet.pas',
  pu_detail in 'pu_detail.pas' {f_detail},
  pu_info in 'pu_info.pas' {f_info},
  pu_printsetup in 'pu_printsetup.pas' {f_printsetup},
  u_planetrender in 'u_planetrender.pas',
  cu_indiclient in 'cu_indiclient.pas',
  cu_telescope in 'cu_telescope.pas',
  cu_fits in 'cu_fits.pas',
  u_bitmap in 'u_bitmap.pas',
  pu_calendar in 'pu_calendar.pas' {f_calendar},
  pu_image in 'pu_image.pas' {f_image},
  pr_config_time in 'pr_config_time.pas' {f_config_time: TFrame},
  pr_config_catalog in 'pr_config_catalog.pas' {f_config_catalog: TFrame},
  pr_config_chart in 'pr_config_chart.pas' {f_config_chart: TFrame},
  pr_config_display in 'pr_config_display.pas' {f_config_display: TFrame},
  pr_config_observatory in 'pr_config_observatory.pas' {f_config_observatory: TFrame},
  pr_config_pictures in 'pr_config_pictures.pas' {f_config_pictures: TFrame},
  pr_config_solsys in 'pr_config_solsys.pas' {f_config_solsys: TFrame},
  pr_config_system in 'pr_config_system.pas' {f_config_system: TFrame},
  cu_database in 'cu_database.pas',
  pu_position in 'pu_position.pas' {f_position},
  pu_search in 'pu_search.pas' {f_search},
  pu_zoom in 'pu_zoom.pas' {f_zoom},
  pu_getdss in 'pu_getdss.pas' {f_getdss};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tf_main, f_main);
  Application.CreateForm(Tf_about, f_about);
  Application.CreateForm(Tf_position, f_position);
  Application.CreateForm(Tf_search, f_search);
  Application.CreateForm(Tf_zoom, f_zoom);
  Application.CreateForm(Tf_getdss, f_getdss);
  f_about.ShowTimer:=true; f_about.Show;
  Application.CreateForm(Tf_detail, f_detail);
  Application.CreateForm(Tf_info, f_info);
  Application.CreateForm(Tf_calendar, f_calendar);
  Application.CreateForm(Tf_printsetup, f_printsetup);
  f_main.Init;
  Application.Run;
end.
