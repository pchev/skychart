unit fu_printsetup;
{
Copyright (C) 2004 Patrick Chevalley

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
 Printer setup form for Linux CLX application
}

interface

uses u_constant, u_util, 
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QPrinters, QExtCtrls, enhedits, QButtons;

type
  Tf_printsetup = class(TForm)
    printmode: TRadioGroup;
    qtoption: TPanel;
    customoption: TPanel;
    qtsetup: TButton;
    printcmd: TComboBox;
    qtprintername: TLabel;
    qtprintresol: TLabel;
    Ok: TButton;
    Cancel: TButton;
    prtres: TLongEdit;
    Label1: TLabel;
    prtcolor: TRadioGroup;
    prtorient: TRadioGroup;
    Label2: TLabel;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    cmdreport: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    savepath: TEdit;
    savepathsel: TBitBtn;
    printcmdsel: TBitBtn;
    procedure qtsetupClick(Sender: TObject);
    procedure printmodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure prtresChange(Sender: TObject);
    procedure printcmdChange(Sender: TObject);
    procedure prtcolorClick(Sender: TObject);
    procedure prtorientClick(Sender: TObject);
    procedure savepathselClick(Sender: TObject);
    procedure savepathChange(Sender: TObject);
    procedure printcmdselClick(Sender: TObject);
  private
    { Private declarations }
    procedure updprtsetup;
  public
    { Public declarations }
    cm: conf_main;
  end;

var
  f_printsetup: Tf_printsetup;

implementation

uses fu_directory;

{$R *.xfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_printsetup.pas}

// end of common code

end.
