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
  QForms,
  fu_main in 'fu_main.pas' {f_main},
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
  fu_directory in 'fu_directory.pas' {f_directory};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tf_main, f_main);
  Application.CreateForm(Tf_about, f_about);
  Application.CreateForm(Tf_config, f_config);
  Application.CreateForm(Tf_directory, f_directory);
  Application.Run;
end.
