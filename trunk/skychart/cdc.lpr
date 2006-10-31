program cdc;
{
Copyright (C) 2006 Patrick Chevalley

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

{$mode objfpc}{$H+}

uses
  {$ifdef unix}
  cthreads,  // Unix thread support, must be first!
  {$endif}
  Interfaces, // this includes the LCL widgetset
  Forms, cu_catalog, cu_skychart, cu_plot, cu_planet,
  cu_indiclient, cu_fits, cu_database, cu_telescope, pu_info, pu_image,
  pu_getdss, pu_detail, pu_chart, pu_calendar, pu_zoom, pu_search,
  pu_printsetup, pu_position, pu_manualtelescope, u_projection,
  u_planetrender, u_constant, u_util, MultiDocPackage, pu_main,
  TurboPowerIPro, pu_config, enhedit, pu_config_catalog,
  pu_config_system, pu_config_solsys, pu_config_pictures, pu_config_observatory,
  pu_config_display, pu_config_chart, pu_config_internet, libsql,
  radec, XmlParser, zoomimage, JPEGForLazarus, CDCjdcalendar, cdccatalog, satxy,
  series96, elp82, Printer4Lazarus, downldialog, synapse, pu_catgen,
  pu_catgenadv, pu_progressbar, mrecsort, pu_addlabel, pu_print, u_translation,
  pu_splash, pu_about;
  
const compile_t={$I %DATE%}+' '+{$I %TIME%} ;

begin
  compile_time:=compile_t;
  Application.Title:='Cartes du Ciel';
  Application.Initialize;

  Application.CreateForm(Tf_main, f_main);
  Application.CreateForm(Tf_splash, f_splash);
  f_splash.Show; f_splash.Invalidate;
  Application.ProcessMessages;
  Application.CreateForm(Tf_position, f_position);
  Application.CreateForm(Tf_search, f_search);
  Application.CreateForm(Tf_zoom, f_zoom);
  Application.CreateForm(Tf_getdss, f_getdss);
  Application.CreateForm(Tf_manualtelescope, f_manualtelescope);
  Application.CreateForm(Tf_detail, f_detail);
  Application.CreateForm(Tf_info, f_info);
  Application.CreateForm(Tf_calendar, f_calendar);
  Application.CreateForm(Tf_printsetup, f_printsetup);
  Application.CreateForm(Tf_print, f_print);
  Application.CreateForm(Tf_about, f_about);
  f_main.init;
  Application.Run;

end.

