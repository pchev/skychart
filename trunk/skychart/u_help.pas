unit u_help;

{$mode objfpc}{$H+}

interface

uses u_translation, u_constant, u_util,
  Classes, SysUtils, Controls, FileUtil, LazHelpHTML;

procedure SetLang;
procedure SetHelpDB(aHelpDB:THTMLHelpDatabase);
procedure SetHelp(aControl: TControl; helpstr:string);

var HelpDir: string;
    UseOnlineHelp: Boolean;
    hlpBaseDir: string = 'en/documentation/';

const
  hlpSearch = 'advanced_search.html';
  hlpCalAst = 'calendar_asteroid.html';
  hlpCalCom = 'calendar_comet.html';
  hlpCalInput = 'calendar_input_area.html';
  hlpCalLuna = 'calendar_lunar_eclipses.html';
  hlpCalPla = 'calendar_planet.html';
  hlpCalSol = 'calendar_solar_eclipses.html';
  hlpCalTw = 'calendar_twilight.html';
  hlpCalSat = 'artificial_satellites.html';
  hlpCatalog = 'catalog.html';
  hlpCatgen ='catgen.html';
  hlpCfgChart = 'chart_coordinates.html';
  hlpCfgDate = 'date_time.html';
  hlpInfo = 'detailed_information.html';
  hlpCfgDispl = 'display.html';
  hlpDocLic ='documentation_license.html';
  hlpFaq ='faq.html';
  hlpInstSrc ='install_and_compile_the_source_code.html';
  hlpInstCat ='install_new_catalogs.html';
  hlpInstFreeB ='install_on_freebsd.html';
  hlpInstLinux ='install_on_linux_debian.html';
  hlpInstMac ='install_on_mac_os_x.html';
  hlpInstWin ='install_on_windows.html';
  hlpCfgInt = 'internet.html';
  hlpKb ='keyboard_shortcut.html';
  hlpLabel ='labels.html';
  hlpBarLeft = 'left_bar.html';
  hlpCmdline ='line_commands.html';
  hlpBarMain = 'main_bar.html';
  hlpMenuChart = 'menuchart.html';
  hlpMenuEdit = 'menuedit.html';
  hlpMenuFile = 'menufile.html';
  hlpMenuHelp = 'menuhelp.html';
  hlpPopup ='menupop_up.html';
  hlpMenuSetup = 'menusetup.html';
  hlpMenuTel = 'menutelescope.html';
  hlpMenuView = 'menuview.html';
  hlpMenuWin = 'menuwindow.html';
  hlpBarObj = 'object_bar.html';
  hlpObjList = 'object_list.html';
  hlpCfgObs = 'observatory.html';
  hlpCfgPict = 'pictures.html';
  hlpPosition = 'position.html';
  hlpQSchart ='quick_start_chart.html';
  hlpQSds ='quick_start_deep_sky.html';
  hlpQSguide ='quick_start_guide.html';
  hlpQSsrv ='quick_start_server.html';
  hlpQSsol ='quick_start_solar_system.html';
  hlpQStel ='quick_start_telescope.html';
  hlpBarRight = 'right_bar.html';
  hlpSrvCmd ='server_commands.html';
  hlpSrvInfo = 'server_information.html';
  hlpSetFov = 'menuview.html#set_fov';
  hlpSoftLic ='software_license.html';
  hlpCfgSol = 'solar_system.html';
  hlpIndex = 'start.html';
  hlpBarStatus = 'status_bar.html';
  hlpCfgSys = 'system.html';
  hlpLX200 = 'telescope_lx200.html';
  hlpEncoder = 'telescope_encoder.html';
  hlpASCOM =  'telescope_ascom.html';
  hlpINDI =  'telescope_indi.html';
  hlpObslist = 'observing_list.html';
  hlpSAMP = 'vo_samp.html';
  hlpImgList = 'image_list.html';
  hlpToolbarEditor = 'toolbar_editor.html';
  hlpToolbox = 'toolbox.html';
  hlpToolboxEditor = 'toolbox_editor.html';
  hlpScriptReference = 'script_reference.html';

implementation

procedure SetHelpDB(aHelpDB:THTMLHelpDatabase);
var buf,hdir:string;
begin
buf:=StringReplace(hlpBaseDir,'/',PathDelim,[rfReplaceAll]);
buf:=StringReplace(buf,'\',PathDelim,[rfReplaceAll]);
hdir:=SysToUTF8(slash(helpdir)+slash('wiki_doc')+buf);
if DirectoryExistsUTF8(hdir) then begin
   aHelpDB.BaseURL:='file://'+hdir;
   UseOnlineHelp:=false;
end else begin
   hlpBaseDir:='en/documentation/';
   buf:=StringReplace(hlpBaseDir,'/',PathDelim,[rfReplaceAll]);
   buf:=StringReplace(buf,'\',PathDelim,[rfReplaceAll]);
   hdir:=SysToUTF8(slash(helpdir)+slash('wiki_doc')+buf);
   if DirectoryExistsUTF8(hdir) then begin
      aHelpDB.BaseURL:='file://'+hdir;
      UseOnlineHelp:=false;
   end else begin
     aHelpDB.BaseURL:='http://www.ap-i.net/static/skychart/'+buf;
     UseOnlineHelp:=true;
   end;
end;
aHelpDB.KeywordPrefix:='H/';
end;

procedure SetHelp(aControl: TControl; helpstr:string);
begin
if UseOnlineHelp then helpstr:=ExtractFileNameWithoutExt(helpstr);
aControl.HelpKeyword:='H/'+helpstr;
aControl.HelpType:=htKeyword;
end;

procedure SetLang;
begin
 hlpBaseDir:=rsHelpBaseDir;
end;

end.

