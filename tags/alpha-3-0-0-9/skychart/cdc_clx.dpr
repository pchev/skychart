program cdc_clx;
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
  Linux CLX application
}

uses
  execshieldfix,
  QForms,
  fu_main in 'fu_main.pas' {f_main},
  fu_directory in 'fu_directory.pas' {f_directory},
  fu_chart in 'fu_chart.pas' {f_chart},
  fu_about in 'fu_about.pas' {f_about},
  cu_catalog in 'cu_catalog.pas',
  cu_skychart in 'cu_skychart.pas',
  cu_plot in 'cu_plot.pas',
  u_projection in 'u_projection.pas',
  u_constant in 'u_constant.pas',
  u_util in 'u_util.pas',
  fu_config in 'fu_config.pas' {f_config},
  libcatalog in 'library/catalog/libcatalog.pas',
  cu_planet in 'cu_planet.pas',
  fu_detail in 'fu_detail.pas' {f_detail},
  fu_info in 'fu_info.pas' {f_info},
  fu_printsetup in 'fu_printsetup.pas' {f_printsetup},
  cu_indiclient in 'cu_indiclient.pas',
  cu_fits in 'cu_fits.pas',
  fu_image in 'fu_image.pas' {f_image},
  fu_calendar in 'fu_calendar.pas' {f_calendar},
  fr_config_time in 'fr_config_time.pas' {f_config_time: TFrame},
  fr_config_catalog in 'fr_config_catalog.pas' {f_config_catalog: TFrame},
  fr_config_chart in 'fr_config_chart.pas' {f_config_chart: TFrame},
  fr_config_display in 'fr_config_display.pas' {f_config_display: TFrame},
  fr_config_observatory in 'fr_config_observatory.pas' {f_config_observatory: TFrame},
  fr_config_pictures in 'fr_config_pictures.pas' {f_config_pictures: TFrame},
  fr_config_solsys in 'fr_config_solsys.pas' {f_config_solsys: TFrame},
  fr_config_system in 'fr_config_system.pas' {f_config_system: TFrame},
  cu_database in 'cu_database.pas',
  fu_search in 'fu_search.pas' {f_search},
  fu_position in 'fu_position.pas' {f_position},
  fu_getdss in 'fu_getdss.pas' {f_getdss},
  fu_zoom in 'fu_zoom.pas' {f_zoom},
  u_bitmap in 'u_bitmap.pas',
  fu_manualtelescope in 'fu_manualtelescope.pas' {f_manualtelescope};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tf_main, f_main);
  Application.CreateForm(Tf_about, f_about);
  Application.CreateForm(Tf_position, f_position);
  Application.CreateForm(Tf_zoom, f_zoom);
  Application.CreateForm(Tf_manualtelescope, f_manualtelescope);
  f_about.ShowTimer:=true; f_about.Show;
  Application.CreateForm(Tf_detail, f_detail);
  Application.CreateForm(Tf_printsetup, f_printsetup);
  f_main.Init;
  Application.Run;
end.
