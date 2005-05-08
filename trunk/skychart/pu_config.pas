unit pu_config;
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
 Configuration form for Windows VCL application

 DO NOT MODIFY the frame content here !

 Instead change the source of each frame if need.

}
interface

uses Math, u_constant, u_util, jpeg, pngimage, u_projection,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, enhedits,
  FoldrDlg, StrUtils,  cu_fits, cu_catalog, cu_database,
  pr_config_chart, pr_config_observatory, pr_config_time, pr_config_catalog,
  pr_config_system, pr_config_pictures, pr_config_display, pr_config_solsys;

type
  Tf_config = class(TForm)
    PageControl1: TPageControl;
    s_time: TTabSheet;
    s_observatory: TTabSheet;
    s_chart: TTabSheet;
    s_catalog: TTabSheet;
    s_solsys: TTabSheet;
    s_display: TTabSheet;
    s_images: TTabSheet;
    s_system: TTabSheet;
    Panel1: TPanel;
    TreeView1: TTreeView;
    previous: TButton;
    next: TButton;
    Panel2: TPanel;
    Applyall: TCheckBox;
    OKBtn: TButton;
    Apply: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    f_config_observatory1: Tf_config_observatory;
    f_config_chart1: Tf_config_chart;
    f_config_catalog1: Tf_config_catalog;
    f_config_solsys1: Tf_config_solsys;
    f_config_display1: Tf_config_display;
    f_config_pictures1: Tf_config_pictures;
    f_config_system1: Tf_config_system;
    f_config_time1: Tf_config_time;
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure previousClick(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
  private
    { Déclarations privées }
    locktree: boolean;
    Fccat : conf_catalog;
    Fcshr : conf_shared;
    Fcsc  : conf_skychart;
    Fcplot : conf_plot;
    Fcmain : conf_main;
    astpage,compage,dbpage: integer;
    FApplyConfig: TNotifyEvent;
    FDBChange: TNotifyEvent;
    FSaveAndRestart: TNotifyEvent;
    FPrepareAsteroid: TPrepareAsteroid;
    function GetFits: TFits;
    procedure SetFits(value: TFits);
    function GetCatalog: Tcatalog;
    procedure SetCatalog(value: Tcatalog);
    function GetDB: Tcdcdb;
    procedure SetDB(value: Tcdcdb);
    procedure SetCcat(value: conf_catalog);
    procedure SetCshr(value: conf_shared);
    procedure SetCsc(value: conf_skychart);
    procedure SetCplot(value: conf_plot);
    procedure SetCmain(value: conf_main);
    procedure ShowDBSetting(Sender: TObject);
    procedure ShowCometSetting(Sender: TObject);
    procedure ShowAsteroidSetting(Sender: TObject);
    procedure LoadMPCSample(Sender: TObject);
    procedure SysDBChange(Sender: TObject);
    procedure SysSaveAndRestart(Sender: TObject);
    function SolSysPrepareAsteroid(jdt:double; msg:Tstrings):boolean;
  public
    { Déclarations publiques }
    property ccat : conf_catalog read Fccat write SetCcat;
    property cshr : conf_shared read Fcshr write SetCshr;
    property csc  : conf_skychart read Fcsc write SetCsc;
    property cplot : conf_plot read Fcplot write SetCplot;
    property cmain : conf_main read Fcmain write SetCmain;
    property fits : TFits read GetFits write SetFits;
    property catalog : Tcatalog read GetCatalog write SetCatalog;
    property db : Tcdcdb read GetDB write SetDB;
    property onApplyConfig: TNotifyEvent read FApplyConfig write FApplyConfig;
    property onDBChange: TNotifyEvent read FDBChange write FDBChange;
    property onSaveAndRestart: TNotifyEvent read FSaveAndRestart write FSaveAndRestart;
    property onPrepareAsteroid: TPrepareAsteroid read FPrepareAsteroid write FPrepareAsteroid;
  end;

var
  f_config: Tf_config;

implementation

{$R *.dfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config.pas }

// end of common code

end.




