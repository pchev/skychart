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
  // fix bug with exec-shield enabled kernel > 2.6.8
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
  cu_indiclient in 'cu_indiclient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tf_main, f_main);
  Application.CreateForm(Tf_about, f_about);
  f_about.ShowTimer:=true; f_about.Show;
  Application.CreateForm(Tf_detail, f_detail);
  Application.CreateForm(Tf_info, f_info);
  Application.CreateForm(Tf_printsetup, f_printsetup);
  f_main.Init;
  Application.Run;
end.
