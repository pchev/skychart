unit u_help;

{$mode objfpc}{$H+}

interface

uses gettext, translations, u_constant, u_util,
  Classes, SysUtils, Controls, LazHelpHTML;

procedure Translate(lang : string = '');
procedure SetHelpDB(aHelpDB:THTMLHelpDatabase);
procedure SetHelp(aControl: TControl; helpstr:string);

var HelpDir: string;

resourcestring
  hlpBaseDir = 'en/documentation/';
  hlpSearch = 'advanced_search.html';
  hlpIndex = 'start.html';
  hlpCalAst = 'calendar_asteroid.html';
  hlpCalCom = 'calendar_comet.html';
  hlpCalInput = 'calendar_input_area.html';
  hlpCalLuna = 'calendar_lunar_eclipses.html';
  hlpCalPla = 'calendar_planet.html';
  hlpCalSol = 'calendar_solar_eclipses.html';
  hlpCalTw = 'calendar_twilight.html';
  hlpCatalog = 'catalog.html';
  hlpCfgChart = 'chart_coordinates.html';
  hlpCfgDate = 'date_time.html';
  hlpInfo = 'detailed_information.html';
  hlpCfgDispl = 'display.html';
  hlpCfgInt = 'internet.html';
  hlpBarLeft = 'left_bar.html';
  hlpBarMain = 'main_bar.html';
  hlpMenuChart = 'menuchart.html';
  hlpMenuEdit = 'menuedit.html';
  hlpMenuFile = 'menufile.html';
  hlpMenuHelp = 'menuhelp.html';
  hlpMenuSetup = 'menusetup.html';
  hlpMenuTel = 'menutelescope.html';
  hlpMenuView = 'menuview.html';
  hlpMenuWin = 'menuwindow.html';
  hlpBarObj = 'object_bar.html';
  hlpObjList = 'object_list.html';
  hlpCfgObs = 'observatory.html';
  hlpCfgPict = 'pictures.html';
  hlpPosition = 'position.html';
  hlpBarRight = 'right_bar.html';
  hlpSrvInfo = 'server_information.html';
  hlpSetFov = 'set_fov.html';
  hlpCfgSol = 'solar_system.html';
  hlpBarStatus = 'status_bar.html';
  hlpCfgSys = 'system.html';


implementation

procedure SetHelpDB(aHelpDB:THTMLHelpDatabase);
begin
aHelpDB.BaseURL:='file://'+slash(helpdir)+slash('wiki_doc')+hlpBaseDir;
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

