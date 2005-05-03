unit fr_config_system;
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

uses u_constant, fu_directory,  passql, pasmysql,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QExtCtrls, QStdCtrls, QButtons, enhedits, QComCtrls;

type
  Tf_config_system = class(TFrame)
    pa_system: TPageControl;
    t_system: TTabSheet;
    Label84: TLabel;
    GroupBox6: TGroupBox;
    dbname: TEdit;
    dbport: TLongEdit;
    dbhost: TEdit;
    Label141: TLabel;
    Label142: TLabel;
    Label143: TLabel;
    dbuser: TEdit;
    dbpass: TEdit;
    Label144: TLabel;
    Label145: TLabel;
    chkdb: TButton;
    credb: TButton;
    dropdb: TButton;
    AstDB: TButton;
    CometDB: TButton;
    GroupBoxDir: TGroupBox;
    Label73: TLabel;
    Label74: TLabel;
    prgdir: TEdit;
    persdir: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBoxLinux: TGroupBox;
    LinuxDesktopBox: TComboBox;
    LinuxCmd: TEdit;
    Label272: TLabel;
    t_server: TTabSheet;
    Label54: TLabel;
    GroupBox3: TGroupBox;
    UseIPserver: TCheckBox;
    ipaddr: TEdit;
    Label55: TLabel;
    Label85: TLabel;
    ipport: TEdit;
    keepalive: TCheckBox;
    t_telescope: TTabSheet;
    Label13: TLabel;
    GroupBox15: TGroupBox;
    Label68: TLabel;
    IndiServerHost: TEdit;
    Label86: TLabel;
    IndiServerPort: TEdit;
    IndiAutostart: TCheckBox;
    Label258: TLabel;
    IndiServerCmd: TEdit;
    Label259: TLabel;
    IndiDriver: TEdit;
    IndiDev: TComboBox;
    Label260: TLabel;
    Label261: TLabel;
    IndiPort: TEdit;
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
    procedure LinuxDesktopBoxChange(Sender: TObject);
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
    procedure FormShow(Sender: TObject);
    procedure prgdirChange(Sender: TObject);
    procedure persdirChange(Sender: TObject);
    procedure LinuxCmdChange(Sender: TObject);
    procedure AstDBClick(Sender: TObject);
    procedure CometDBClick(Sender: TObject);
  private
    { Private declarations }
    db:TmyDB;
    FShowAsteroid: TNotifyEvent;
    FShowComet: TNotifyEvent;
    FLoadMPCSample: TNotifyEvent;
    procedure ShowSYS;
    procedure ShowServer;
    procedure ShowTelescope;
  public
    { Public declarations }
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
  end;

var
  f_config_system: Tf_config_system;

implementation

{$R *.xfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config_system.pas}

// end of common code

end.
