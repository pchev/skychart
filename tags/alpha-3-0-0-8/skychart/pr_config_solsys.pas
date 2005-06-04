unit pr_config_solsys;
{
Copyright (C) 2005 Patrick Chevalley

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

interface

uses  u_constant, u_util, u_projection, cu_database,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Spin, enhedits, Mask, StdCtrls, Buttons, ExtCtrls, ComCtrls, FoldrDlg;

type
  Tf_config_solsys = class(TFrame)
    pa_solsys: TPageControl;
    t_solsys: TTabSheet;
    Label12: TLabel;
    Label131: TLabel;
    PlaParalaxe: TRadioGroup;
    planetdir: TEdit;
    planetdirsel: TBitBtn;
    t_planet: TTabSheet;
    Label5: TLabel;
    Label89: TLabel;
    Label53: TLabel;
    PlanetBox: TCheckBox;
    PlanetMode: TRadioGroup;
    PlanetBox2: TCheckBox;
    PlanetBox3: TCheckBox;
    GRS: TFloatEdit;
    BitBtn37: TBitBtn;
    Edit2: TEdit;
    t_comet: TTabSheet;
    ComPageControl: TPageControl;
    comsetting: TTabSheet;
    GroupBox13: TGroupBox;
    Label154: TLabel;
    Label216: TLabel;
    Label231: TLabel;
    comlimitmag: TFloatEdit;
    showcom: TCheckBox;
    comsymbol: TRadioGroup;
    commagdiff: TFloatEdit;
    comdbset: TButton;
    comload: TTabSheet;
    Label232: TLabel;
    GroupBox14: TGroupBox;
    Label233: TLabel;
    comfile: TEdit;
    Loadcom: TButton;
    comfilebtn: TBitBtn;
    MemoCom: TMemo;
    comdelete: TTabSheet;
    Label238: TLabel;
    GroupBox16: TGroupBox;
    comelemlist: TComboBox;
    DelCom: TButton;
    GroupBox17: TGroupBox;
    Label239: TLabel;
    DelComAll: TButton;
    DelComMemo: TMemo;
    Addsinglecom: TTabSheet;
    Label241: TLabel;
    Label242: TLabel;
    Label243: TLabel;
    Label244: TLabel;
    Label245: TLabel;
    Label246: TLabel;
    Label247: TLabel;
    Label248: TLabel;
    Label249: TLabel;
    Label250: TLabel;
    Label251: TLabel;
    Label253: TLabel;
    Label254: TLabel;
    comid: TEdit;
    comh: TEdit;
    comg: TEdit;
    comep: TEdit;
    comperi: TEdit;
    comnode: TEdit;
    comi: TEdit;
    comec: TEdit;
    comq: TEdit;
    comnam: TEdit;
    comeq: TEdit;
    AddCom: TButton;
    comt: TMaskEdit;
    t_asteroid: TTabSheet;
    AstPageControl: TPageControl;
    astsetting: TTabSheet;
    GroupBox9: TGroupBox;
    Label203: TLabel;
    Label212: TLabel;
    Label213: TLabel;
    astlimitmag: TFloatEdit;
    showast: TCheckBox;
    astsymbol: TRadioGroup;
    astmagdiff: TFloatEdit;
    astdbset: TButton;
    astload: TTabSheet;
    Label206: TLabel;
    GroupBox7: TGroupBox;
    Label204: TLabel;
    Label215: TLabel;
    mpcfile: TEdit;
    astnumbered: TCheckBox;
    LoadMPC: TButton;
    mpcfilebtn: TBitBtn;
    aststoperr: TCheckBox;
    astlimitbox: TCheckBox;
    astlimit: TLongEdit;
    MemoMPC: TMemo;
    astprepare: TTabSheet;
    Label210: TLabel;
    GroupBox8: TGroupBox;
    Label7: TLabel;
    Label207: TLabel;
    aststrtdate: TMaskEdit;
    AstCompute: TButton;
    astnummonth: TSpinEdit;
    prepastmemo: TMemo;
    astdelete: TTabSheet;
    Label211: TLabel;
    GroupBox10: TGroupBox;
    astelemlist: TComboBox;
    delast: TButton;
    GroupBox11: TGroupBox;
    Label209: TLabel;
    delallast: TButton;
    delastMemo: TMemo;
    GroupBox12: TGroupBox;
    Label214: TLabel;
    astdeldate: TMaskEdit;
    deldateast: TButton;
    AddsingleAst: TTabSheet;
    Label217: TLabel;
    Label218: TLabel;
    Label219: TLabel;
    Label220: TLabel;
    Label221: TLabel;
    Label222: TLabel;
    Label223: TLabel;
    Label224: TLabel;
    Label225: TLabel;
    Label226: TLabel;
    Label227: TLabel;
    Label228: TLabel;
    Label229: TLabel;
    Label230: TLabel;
    astid: TEdit;
    asth: TEdit;
    astg: TEdit;
    astep: TEdit;
    astma: TEdit;
    astperi: TEdit;
    astnode: TEdit;
    asti: TEdit;
    astec: TEdit;
    astax: TEdit;
    astref: TEdit;
    astnam: TEdit;
    asteq: TEdit;
    Addast: TButton;
    FolderDialog1: TFolderDialog;
    OpenDialog1: TOpenDialog;
    procedure PlanetDirChange(Sender: TObject);
    procedure PlanetDirSelClick(Sender: TObject);
    procedure PlaParalaxeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PlanetBoxClick(Sender: TObject);
    procedure PlanetModeClick(Sender: TObject);
    procedure GRSChange(Sender: TObject);
    procedure PlanetBox2Click(Sender: TObject);
    procedure PlanetBox3Click(Sender: TObject);
    procedure BitBtn37Click(Sender: TObject);
    procedure showcomClick(Sender: TObject);
    procedure comsymbolClick(Sender: TObject);
    procedure comlimitmagChange(Sender: TObject);
    procedure commagdiffChange(Sender: TObject);
    procedure comfilebtnClick(Sender: TObject);
    procedure LoadcomClick(Sender: TObject);
    procedure DelComClick(Sender: TObject);
    procedure DelComAllClick(Sender: TObject);
    procedure AddComClick(Sender: TObject);
    procedure comdbsetClick(Sender: TObject);
    procedure showastClick(Sender: TObject);
    procedure astsymbolClick(Sender: TObject);
    procedure astlimitmagChange(Sender: TObject);
    procedure astmagdiffChange(Sender: TObject);
    procedure astdbsetClick(Sender: TObject);
    procedure mpcfilebtnClick(Sender: TObject);
    procedure LoadMPCClick(Sender: TObject);
    procedure AstComputeClick(Sender: TObject);
    procedure delastClick(Sender: TObject);
    procedure deldateastClick(Sender: TObject);
    procedure delallastClick(Sender: TObject);
    procedure AddastClick(Sender: TObject);
  private
    { Private declarations }
    FShowDB: TNotifyEvent;
    FPrepareAsteroid: TPrepareAsteroid;
    procedure ShowPlanet;
    procedure ShowComet;
    procedure UpdComList;
    procedure ShowAsteroid;
    procedure UpdAstList;
  public
    { Public declarations }
    cdb: Tcdcdb;
    autoprocess: boolean;
    mycsc : conf_skychart;
    myccat : conf_catalog;
    mycshr : conf_shared;
    mycplot : conf_plot;
    mycmain : conf_main;
    csc : ^conf_skychart;
    ccat : ^conf_catalog;
    cshr : ^conf_shared;
    cplot : ^conf_plot;
    cmain : ^conf_main;
    constructor Create(AOwner:TComponent); override;
    procedure LoadSampleData;
    property onShowDB: TNotifyEvent read FShowDB write FShowDB;
    property onPrepareAsteroid: TPrepareAsteroid read FPrepareAsteroid write FPrepareAsteroid;
  end;

implementation

{$R *.dfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config_solsys.pas}

// end of common code

end.
