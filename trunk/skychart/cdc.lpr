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

{ TODO : Print and debug on Win64, remove that in the future }
{$ifdef  win64}
  {$IMAGEBASE $400000}
{$endif}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  InterfaceBase, LCLVersion, // version number
  Forms, Classes, Sysutils, Dialogs, cu_catalog, cu_skychart, cu_plot,
  cu_planet, cu_indiclient, cu_fits, cu_database, cu_telescope, pu_info,
  pu_image, pu_getdss, pu_detail, pu_chart, pu_calendar, pu_zoom, pu_search,
  pu_printsetup, pu_position, pu_manualtelescope, u_projection, u_planetrender,
  u_constant, u_util, MultiDocPackage, enhedit, pu_config_catalog,
  pu_config_system, pu_config_solsys, pu_config_pictures, pu_config_observatory,
  pu_config_display, pu_config_chart, pu_config_internet, libsql, radec,
  XmlParser, zoomimage, CDCjdcalendar, cdccatalog, satxy, Printer4Lazarus,
  downldialog, synapse, pu_catgen, pu_catgenadv, pu_progressbar, mrecsort,
  pu_addlabel, pu_print, u_translation, pu_splash, pu_about, cu_tz,
  uniqueinstance_package, u_help, LCLProc, pu_clock, u_unzip, cu_tcpserver,
  pu_ascomclient, u_satellite, pu_main, pu_observatory_db, bgrabitmappack;
  
var i : integer;
    buf, p, step : string;

{$R *.res}

begin

  {$ifdef trace_debug}
  debugln('Read parameters');
  {$endif}

  Params:=TStringList.Create;
  buf:='';
  for i:=1 to Paramcount do begin
      p:=ParamStr(i);
      if copy(p,1,2)='--' then begin
         if buf<>'' then Params.Add(buf);
         buf:=p;
      end
      else
         buf:=buf+blank+p;
  end;
  if buf<>'' then Params.Add(buf);

  lclver:=lcl_version;
  compile_time:={$I %DATE%}+' '+{$I %TIME%};
  compile_version:='Lazarus '+lcl_version+' Free Pascal '+{$I %FPCVERSION%}+' '+{$I %FPCTARGETOS%}+'-'+{$I %FPCTARGETCPU%}+'-'+LCLPlatformDirNames[WidgetSet.LCLPlatform];
  {$ifdef trace_debug}
  debugln('Program version : '+cdcversion);
  debugln('Program compiled: '+compile_time);
  debugln('Compiler version: '+compile_version);
  {$endif}
  Application.Title:='Cartes du Ciel';
  {$ifdef trace_debug}
  debugln('Initialize');
  {$endif}
  Application.Initialize;
  try
  step:='Create main form';
  {$ifdef trace_debug}
  debugln(step);
  {$endif}
  Application.CreateForm(Tf_main, f_main);
  step:='Create splash';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  if f_main.showsplash then begin
    Application.CreateForm(Tf_splash, f_splash);
    step:='Show splash';
    {$ifdef trace_debug}
     WriteTrace(step);
    {$endif}
    f_splash.Show; f_splash.Invalidate;
    Application.ProcessMessages;
  end;
  step:='Create f_position';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_position, f_position);
  step:='Create f_search';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_search, f_search);
  step:='Create f_zoom';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_zoom, f_zoom);
  step:='Create f_getdss';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_getdss, f_getdss);
  step:='Create f_manualtelescope';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_manualtelescope, f_manualtelescope);
  step:='Create f_detail';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_detail, f_detail);
  step:='Create f_info';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_info, f_info);
  step:='Create f_calendar';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_calendar, f_calendar);
  step:='Create f_printsetup';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_printsetup, f_printsetup);
  step:='Create f_print';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  Application.CreateForm(Tf_print, f_print);
  step:='Main Init';
  {$ifdef trace_debug}
   WriteTrace(step);
  {$endif}
  f_main.init;
  step:='';
  except
  on E: Exception do begin
   WriteTrace(step+': '+E.Message);
   f_splash.Close;
   MessageDlg(step+': '+E.Message+crlf+rsSomethingGoW+crlf
             +rsPleaseTryToR,
             mtError, [mbAbort], 0);
   Halt;
   end;
  end;
  {$ifdef trace_debug}
   WriteTrace('Application Run');
  {$endif}
  Application.Run;

  Params.Free;
end.

