unit fu_about;
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
 About form for Linux CLX application
}

interface

uses u_constant,
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QTypes;

type
  Tf_about = class(TForm)
    logo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Timer1: TTimer;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure logoDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ShowTimer: Boolean;
  end;

var
  f_about: Tf_about;

implementation

{$R *.xfm}

procedure Tf_about.FormCreate(Sender: TObject);
begin
 ShowTimer:=false;
 label2.caption:=cdcversion;
end;

procedure Tf_about.FormShow(Sender: TObject);
begin
if ShowTimer then begin
   BorderStyle:=fbsNone;
   Timer1.Enabled:=true;
end else begin
   BorderStyle:=fbsToolWindow;
   Timer1.Enabled:=false;
end;
end;

procedure Tf_about.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=false;
ShowTimer:=false;
Close;
end;

procedure Tf_about.logoDblClick(Sender: TObject);
begin
Timer1Timer(Sender);
end;

end.
