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
  pu_detail in 'pu_detail.pas' {f_detail};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tf_main, f_main);
  Application.CreateForm(Tf_about, f_about);
  Application.CreateForm(Tf_detail, f_detail);
  Application.Run;
end.
