unit fr_config_pictures;
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

uses  u_constant, fu_directory,u_util, cu_fits, cu_database,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QExtCtrls, QButtons;

type
  Tf_config_pictures = class(TFrame)
    pa_images: TPageControl;
    t_images: TTabSheet;
    Label113: TLabel;
    Label265: TLabel;
    Label266: TLabel;
    nimages: TLabel;
    Label267: TLabel;
    imgpath: TEdit;
    BitBtn3: TBitBtn;
    ScanImages: TButton;
    Panel11: TPanel;
    Label268: TLabel;
    Label269: TLabel;
    ImgLumBar: TTrackBar;
    ImgContrastBar: TTrackBar;
    ProgressPanel: TPanel;
    ProgressBar1: TProgressBar;
    ProgressCat: TLabel;
    ShowImagesBox: TCheckBox;
    t_background: TTabSheet;
    Label270: TLabel;
    Label271: TLabel;
    backimginfo: TLabel;
    backimg: TEdit;
    BitBtn5: TBitBtn;
    ShowBackImg: TCheckBox;
    OpenDialog1: TOpenDialog;
    Image1: TImage;
    Panel1: TPanel;
    ImgLumBar2: TTrackBar;
    ImgContrastBar2: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    ImageTimer1: TTimer;
    procedure imgpathChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ScanImagesClick(Sender: TObject);
    procedure ImgLumBarChange(Sender: TObject);
    procedure ImgContrastBarChange(Sender: TObject);
    procedure ShowImagesBoxClick(Sender: TObject);
    procedure backimgChange(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure ShowBackImgClick(Sender: TObject);
    procedure ImgContrastBar2Change(Sender: TObject);
    procedure ImgLumBar2Change(Sender: TObject);
    procedure ImageTimer1Timer(Sender: TObject);
  private
    { Private declarations }
    FFits: TFits;
    procedure ShowImages;
    Procedure RefreshImage;
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
    property Fits: TFits read FFits write FFits;
  end;

var
  f_config_pictures: Tf_config_pictures;

implementation

{$R *.xfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_config_pictures.pas}

// end of common code




end.
