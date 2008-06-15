program varobs;
{
Copyright (C) 2008 Patrick Chevalley

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
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this },
  variables1, aavsochart, detail1, uniqueinstance_package,
  ObsUnit, SettingUnit, splashunit, Printer4Lazarus, CDCjdcalendar, u_param,
  downldialog, u_util2;

{$R manifest.res}

begin
  Application.Initialize;
  Application.CreateForm(TVarForm, VarForm);
  Application.CreateForm(Tsplash, splash);
  splash.SplashTimer:=true;
//  splash.Show;
  Application.CreateForm(Tchartform, chartform);
  Application.CreateForm(TDetailForm, DetailForm);
  Application.CreateForm(TObsForm, ObsForm);
  Application.CreateForm(TOptForm, OptForm);
  Application.Run;
end.

