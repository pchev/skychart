program cdc;
{
Copyright (C) 2006 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

{$mode objfpc}{$H+}


uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  {$ifdef mswindows}
  Windows,
  {$endif}
  Forms, Classes, Sysutils, Dialogs, LResources, cu_catalog, cu_skychart,
  cu_plot, cu_planet, cu_fits, cu_database, pu_info, pu_image, pu_getdss,
  pu_detail, fu_chart, pu_calendar, pu_zoom, pu_search, pu_printsetup,
  pu_position, pu_manualtelescope, u_projection, u_constant, u_util, enhedit,
  pu_config_catalog, pu_config_system, pu_config_solsys, pu_config_pictures,
  pu_config_observatory, pu_config_display, pu_config_chart, pu_config_internet,
  libsql, radec, XmlParser, zoomimage, CDCjdcalendar, cdccatalog,
  Printer4Lazarus, lazcontrols, pascalscript, downldialog, laz_synapse, pu_catgen, pu_obslist,
  pu_catgenadv, pu_progressbar, mrecsort, pu_addlabel, pu_print, u_translation,
  pu_splash, pu_about, cu_tz, uniqueinstance_package, u_help, LCLProc, pu_clock,
  u_unzip, cu_tcpserver, pu_indiclient, u_satellite, pu_main, pu_observatory_db,
  pu_ascomclient, uDE, pu_voconfig, pr_vodetail,
  lazvo, multiframepackage, fu_config_time, fu_config_catalog,
  fu_config_chart, fu_config_display, fu_config_internet, fu_config_observatory,
  fu_config_pictures, fu_config_solsys, fu_config_system, fu_config_calendar,
  pu_config_calendar, pu_planetinfo, pu_imglist, cu_plansat, cu_smallsat,
  pu_fov, pu_edittoolbar, fu_script, pu_scriptengine, pu_pascaleditor,
  uPSI_CheckLst, upsi_translation, u_scriptsocket, pu_scriptconfig, pu_tour,
  UScaleDPI, u_ccdconfig, u_orbits, u_speech, cu_healpix, cu_ascomrest, pu_mosaic, pu_prepoint, calceph, cu_calceph;
  
var i : integer;
    buf, p, step : string;

{$R *.res}

begin
  {$ifdef mswindows}
  {$ifdef cpui386}
  // allow to use more than 2GB of memory
  {$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}
  {$endif}
  {$endif}

  if LazarusResources.Find('sortasc')<>nil then LazarusResources.Find('sortasc').Name:='lcl_sortasc';
  if LazarusResources.Find('sortdesc')<>nil then LazarusResources.Find('sortdesc').Name:='lcl_sortdesc';
  {$I grid_images.lrs}

(* // To stdout by default, uncomment to write to file
  {$ifdef USEHEAPTRC}
  DeleteFile('/tmp/skychart_heap.trc');
  SetHeapTraceOutput('/tmp/skychart_heap.trc');
  {$endif}
*)

  Params:=TStringList.Create;
  for i:=1 to ParamCount() do begin
      p:=ParamStr(i);
      if p='--verbose' then
        VerboseMsg:=true
      else
        Params.Add(p);
  end;

  Application.Title:='Skychart';
  Application.Initialize;
  try
  step:='Create main form';
  Application.CreateForm(Tf_main, f_main);
  if not Application.Terminated then begin
    step:='Create splash';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_splash, f_splash);
    if f_main.showsplash then begin
      step:='Show splash';
      if VerboseMsg then WriteTrace(step);
      f_splash.Show; f_splash.Invalidate;
      Application.ProcessMessages;
    end;
    step:='Create f_position';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_position, f_position);
    step:='Create f_search';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_search, f_search);
    step:='Create f_zoom';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_zoom, f_zoom);
    step:='Create f_getdss';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_getdss, f_getdss);
    step:='Create f_manualtelescope';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_manualtelescope, f_manualtelescope);
    step:='Create f_detail';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_detail, f_detail);
    step:='Create f_info';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_info, f_info);
    step:='Create f_calendar';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_calendar, f_calendar);
    step:='Create f_printsetup';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_printsetup, f_printsetup);
    step:='Create f_print';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_print, f_print);
    step:='Create f_obslist';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_obslist, f_obslist);
    step:='Create f_edittoolbar';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_edittoolbar, f_edittoolbar);
    step:='Create f_mosaic';
    if VerboseMsg then WriteTrace(step);
    Application.CreateForm(Tf_mosaic, f_mosaic);
    Application.CreateForm(Tf_prepoint, f_prepoint);
    step:='Main Init';
    if VerboseMsg then WriteTrace(step);
    f_main.init;
    step:='';
  end;
  except
  on E: Exception do begin
   DebugLn(step+': '+E.Message);
   if f_splash<>nil then f_splash.Close;
   MessageDlg(step+': '+E.Message+crlf+rsSomethingGoW+crlf
             +rsPleaseTryToR,
             mtError, [mbAbort], 0);
   Halt;
   end;
  end;
  if not Application.Terminated then begin
    if VerboseMsg then WriteTrace('Application Run');
    Application.Run;
  end;

  Params.Free;
end.

