unit fu_main;
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
 Main form for Linux CLX application
}

interface

uses cu_catalog, u_constant, u_util,
     SysUtils, Classes, QForms, QImgList, QStdActns, QActnList, QDialogs,
     QMenus, QTypes, QComCtrls, QControls, QExtCtrls, QGraphics,  QPrinters,
     QStdCtrls, IniFiles, Types;

type
  Tf_main = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileItem2: TMenuItem;
    WindowClose1: TWindowClose;
    WindowTile1: TWindowTile;
    ImageList1: TImageList;
    starshape: TImage;
    OpenConfig: TAction;
    Print1: TAction;
    Configuration1: TMenuItem;
    Setup1: TMenuItem;
    Print2: TMenuItem;
    PrintSetup1: TAction;
    PrintSetup2: TMenuItem;
    N2: TMenuItem;
    HelpContents1: THelpContents;
    Search1: TAction;
    ViewBar: TAction;
    PanelTop: TPanel;
    PanelLeft: TPanel;
    PanelRight: TPanel;
    PanelBottom: TPanel;
    ToolBar1: TToolBar;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    FlipButtonX: TToolButton;
    ToolBar3: TToolBar;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    PPanels0: TPanel;
    LPanels0: TLabel;
    PPanels1: TPanel;
    LPanels1: TLabel;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    zoomplus: TAction;
    zoomminus: TAction;
    ToolButton7: TToolButton;
    quicksearch: TComboBox;
    Copy1: TMenuItem;
    Flipx: TAction;
    Flipy: TAction;
    FlipButtonY: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OpenConfigExecute(Sender: TObject);
    procedure Print1Execute(Sender: TObject);
    procedure PrintSetup1Execute(Sender: TObject);
    procedure ViewBarExecute(Sender: TObject);
    procedure zoomplusExecute(Sender: TObject);
    procedure zoomminusExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure quicksearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure quicksearchClick(Sender: TObject);
    procedure FlipxExecute(Sender: TObject);
    procedure FlipyExecute(Sender: TObject);
    procedure SetFOVExecute(Sender: TObject);
  private
    { Private declarations }
    procedure CreateMDIChild(const Name: string);
    procedure RefreshAllChild;
  public
    { Public declarations }
    cfgm : conf_main;
    def_cfgsc : conf_skychart;
    def_cfgplot : conf_plot;
    catalog : Tcatalog;
    procedure ReadDefault;
    procedure SaveDefault;
    procedure SetDefault;
    Procedure InitFonts;
    Procedure SetLPanel1(txt:string);
    Procedure SetLPanel0(txt:string);
    Procedure UpdateBtn(fx,fy:integer);
  end;

var
  f_main: Tf_main;

implementation

{$R *.xfm}

uses fu_chart, fu_about, fu_config ;

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_main.pas}

// end of common code


// Specific CLX code:

procedure Tf_main.PrintSetup1Execute(Sender: TObject);
begin
Printer.executesetup;
end;

end.

