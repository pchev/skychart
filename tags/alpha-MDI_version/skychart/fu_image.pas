unit fu_image;
{
Copyright (C) 2005 Patrick Chevalley

http://www.astrosurf.com/avl
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

uses Math, SysUtils, Classes, QForms,Types,
  QStdCtrls, QControls, QGraphics, QExtCtrls, QButtons,
  QDialogs, cu_zoomimage;
  
type
  Tf_image = class(TForm)
    Image1: TZoomImage;
    Panel1: TPanel;
    VScrollBar: TScrollBar;
    HScrollBar: TScrollBar;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure HScrollBarChange(Sender: TObject);
    procedure VScrollBarChange(Sender: TObject);
  private
    { Private declarations }
    scrollw, scrollh : integer;
    ScrollLock: boolean;
    procedure SetScrollBar;
  public
    { Public declarations }
    titre,labeltext: string;
    imagewidth,imageheight: integer;
    Procedure LoadImage(f : string);
    Procedure ZoomN(n:double);
    Procedure Zoomplus;
    Procedure Zoommoins;
    Procedure Init;
  end;

var
  f_image: Tf_image;

implementation

{$R *.xfm}

// include all cross-platform common code.
// you can temporarily copy the file content here
// to use the IDE facilities

{$include i_image.pas}

// end of common code

end.
