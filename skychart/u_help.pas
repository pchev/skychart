unit u_help;

{$mode objfpc}{$H+}

interface

uses gettext, translations, u_constant, u_util,
  Classes, SysUtils, Controls, FileUtil, LazHelpHTML;

procedure Translate(lang : string = '');
procedure SetHelpDB(aHelpDB:THTMLHelpDatabase);
procedure SetHelp(aControl: TControl; helpstr:string);

var HelpDir: string;

resourcestring
  hlpBaseDir = 'en/documentation/';
  hlpSearch = 'advanced_search.html';
  hlpCalAst = 'calendar_asteroid.html';
  hlpCalCom = 'calendar_comet.html';
  hlpCalInput = 'calendar_input_area.html';
  hlpCalLuna = 'calendar_lunar_eclipses.html';
  hlpCalPla = 'calendar_planet.html';
  hlpCalSol = 'calendar_solar_eclipses.html';
  hlpCalTw = 'calendar_twilight.html';
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
  hlpSetFov = 'set_fov.html';
  hlpSoftLic ='software_license.html';
  hlpCfgSol = 'solar_system.html';
  hlpIndex = 'start.html';
  hlpBarStatus = 'status_bar.html';
  hlpCfgSys = 'system.html';

implementation

procedure SetHelpDB(aHelpDB:THTMLHelpDatabase);
var buf:string;
begin
buf:=StringReplace(hlpBaseDir,'/',PathDelim,[rfReplaceAll]);
buf:=StringReplace(buf,'\',PathDelim,[rfReplaceAll]);
aHelpDB.BaseURL:='file://'+SysToUTF8(slash(helpdir)+slash('wiki_doc')+buf);
aHelpDB.KeywordPrefix:='H/';
end;

procedure SetHelp(aControl: TControl; helpstr:string);
begin
aControl.HelpKeyword:='H/'+helpstr;
aControl.HelpType:=htKeyword;
end;

procedure Translate(lang : string = '');
var pofile: string;
begin
 if lang='' then lang:='en';
 pofile:=format(slash(appdir)+slash('data')+slash('language')+'help.%s.po',[lang]);
 if not FileExists(pofile) then
    pofile:=format(slash(appdir)+slash('data')+slash('language')+'help.%s.po',['en']);
 TranslateUnitResourceStrings('u_help',pofile);
end;

end.

