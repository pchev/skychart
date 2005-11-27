unit pu_getdss;
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
{
 Interface to GetDSS to extract DSS images from Realsky CDrom.
}

interface

uses u_constant, u_util, Math,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Buttons;

// GetDss.dll interface
  type
  SImageConfig = record
     pDir : Pchar;
     pDrive : Pchar;
     pImageFile : Pchar;
     DataSource : integer;
     PromptForDisk : boolean;
     SubSample : integer;
     Ra : double;
     De : double;
     Width : double;
     Height : double;
     Sender : Thandle;
     pApplication :Pchar;
     pPrompt1 : Pchar;
     pPrompt2 : Pchar;
  end;
  Plate_data = packed record
   nplate : integer;
   plate_name, gsc_plate_name : array[1..10]of Pchar;
   dist_from_edge, cd_number, is_uk_survey : array[1..10]of integer;
   year_imaged, exposure : array[1..10]of double;
  end;
  PImageConfig = ^SImageConfig;
  PPlate_data = ^Plate_data;

  TImageExtract=function( img : PImageConfig): Integer; cdecl;
  TGetPlateList=function( img : PImageConfig; pl : PPlate_data): Integer; cdecl;
  TImageExtractFromPlate=function( img : PImageConfig; ReqPlateName : Pchar): Integer; cdecl;


type
  Tf_getdss = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    dsslib: Dword;
    Fenabled: boolean;
    ImageExtract: TImageExtract;
    GetPlateList: TGetPlateList;
    ImageExtractFromPlate: TImageExtractFromPlate;
  public
    { Public declarations }
    cfgdss: conf_dss;
    function GetDss(ra,de,fov,ratio:double):boolean;
    property enabled: boolean read Fenabled;
  end;

  Var f_getdss: Tf_getdss;

  Const dsslibname = 'libgetdss.dll';


implementation

{$R *.dfm}

{$include i_getdss.pas}

end.
