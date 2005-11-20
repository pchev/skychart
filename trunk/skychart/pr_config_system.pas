unit pr_config_system;
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

uses u_constant, u_util, cu_database,
  StrUtils, Dialogs, FoldrDlg,
  Controls, Buttons, enhedits, ComCtrls, Classes,
  Windows, Messages, SysUtils, Graphics, Forms,
  ExtCtrls, StdCtrls;

type
  Tf_config_system = class(TFrame)
    pa_system: TPageControl;
    t_system: TTabSheet;
    Label153: TLabel;
    MysqlBox: TGroupBox;
    Label77: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label133: TLabel;
    dbname: TEdit;
    dbport: TLongEdit;
    dbhost: TEdit;
    dbuser: TEdit;
    dbpass: TEdit;
    GroupBoxDir: TGroupBox;
    Label156: TLabel;
    Label157: TLabel;
    prgdir: TEdit;
    persdir: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    t_server: TTabSheet;
    GroupBox3: TGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    UseIPserver: TCheckBox;
    ipaddr: TEdit;
    ipport: TEdit;
    keepalive: TCheckBox;
    t_telescope: TTabSheet;
    Label13: TLabel;
    INDI: TGroupBox;
    Label75: TLabel;
    Label130: TLabel;
    Label258: TLabel;
    Label259: TLabel;
    Label260: TLabel;
    Label261: TLabel;
    IndiServerHost: TEdit;
    IndiServerPort: TEdit;
    IndiAutostart: TCheckBox;
    IndiServerCmd: TEdit;
    IndiDriver: TEdit;
    IndiDev: TComboBox;
    IndiPort: TComboBox;
    TelescopeSelect: TRadioGroup;
    TelescopePlugin: TGroupBox;
    Label155: TLabel;
    telescopepluginlist: TComboBox;
    FolderDialog1: TFolderDialog;
    GroupBox1: TGroupBox;
    chkdb: TButton;
    credb: TButton;
    dropdb: TButton;
    CometDB: TButton;
    AstDB: TButton;
    SqliteBox: TGroupBox;
    Label1: TLabel;
    dbnamesqlite: TEdit;
    DBtypeGroup: TRadioGroup;
    Label2: TLabel;
    PanelCmd: TEdit;
    TelescopeManual: TGroupBox;
    Label7: TLabel;
    EquatorialMount: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    TurnsRa: TFloatEdit;
    TurnsDec: TFloatEdit;
    RevertTurnsRa: TCheckBox;
    RevertTurnDec: TCheckBox;
    ManualMountType: TRadioGroup;
    AltAzMount: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    TurnsAz: TFloatEdit;
    TurnsAlt: TFloatEdit;
    RevertTurnsAz: TCheckBox;
    RevertTurnsAlt: TCheckBox;
    procedure dbnameChange(Sender: TObject);
    procedure dbhostChange(Sender: TObject);
    procedure dbportChange(Sender: TObject);
    procedure dbuserChange(Sender: TObject);
    procedure dbpassChange(Sender: TObject);
    procedure chkdbClick(Sender: TObject);
    procedure credbClick(Sender: TObject);
    procedure dropdbClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure UseIPserverClick(Sender: TObject);
    procedure keepaliveClick(Sender: TObject);
    procedure ipaddrChange(Sender: TObject);
    procedure ipportChange(Sender: TObject);
    procedure IndiServerHostChange(Sender: TObject);
    procedure IndiServerPortChange(Sender: TObject);
    procedure IndiAutostartClick(Sender: TObject);
    procedure IndiServerCmdChange(Sender: TObject);
    procedure IndiDevChange(Sender: TObject);
    procedure IndiDriverChange(Sender: TObject);
    procedure IndiPortChange(Sender: TObject);
    procedure TelescopeSelectClick(Sender: TObject);
    procedure telescopepluginlistChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure prgdirChange(Sender: TObject);
    procedure persdirChange(Sender: TObject);
    procedure AstDBClick(Sender: TObject);
    procedure CometDBClick(Sender: TObject);
    procedure FrameExit(Sender: TObject);
    procedure DBtypeGroupClick(Sender: TObject);
    procedure dbnamesqliteChange(Sender: TObject);
    procedure PanelCmdChange(Sender: TObject);
    procedure TurnsRaChange(Sender: TObject);
    procedure TurnsDecChange(Sender: TObject);
    procedure ManualMountTypeClick(Sender: TObject);
    procedure TurnsAzChange(Sender: TObject);
    procedure TurnsAltChange(Sender: TObject);
  private
    { Private declarations }
    FShowAsteroid: TNotifyEvent;
    FShowComet: TNotifyEvent;
    FLoadMPCSample: TNotifyEvent;
    FDBChange: TNotifyEvent;
    FSaveAndRestart: TNotifyEvent;
    dbchanged,skipDBtypeGroupClick: boolean;
    procedure ShowSYS;
    procedure ShowServer;
    procedure ShowTelescope;
  public
    { Public declarations }
    cdb:Tcdcdb;
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
    property onShowAsteroid: TNotifyEvent read FShowAsteroid write FShowAsteroid;
    property onShowComet: TNotifyEvent read FShowComet write FShowComet;
    property onLoadMPCSample: TNotifyEvent read FLoadMPCSample write FLoadMPCSample;
    property onDBChange: TNotifyEvent read FDBChange write FDBChange;
    property onSaveAndRestart: TNotifyEvent read FSaveAndRestart write FSaveAndRestart;
  end;

implementation

{$R *.dfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config_system.pas}

// end of common code

// windows vcl specific code:

procedure Tf_config_system.telescopepluginlistChange(Sender: TObject);
begin
csc.ScopePlugin:=telescopepluginlist.text;
end;

// end of windows vcl specific code:

end.

