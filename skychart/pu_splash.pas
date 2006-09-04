unit pu_splash;

{$MODE Delphi}{$H+}

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
 startup splash screen
}

interface

uses u_translation, u_constant, u_util,
  LCLIntf, Classes, Graphics, Forms, Controls, StdCtrls,
  ExtCtrls, LResources, Buttons, SynEdit;

type

  { Tf_splash }

  Tf_splash = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelDate: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure logoDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ShowTimer: Boolean;
    procedure SetLang;
  end;

var
  f_splash: Tf_splash;

implementation

procedure Tf_splash.SetLang;
begin
Caption:=rsAbout;
if rsSkyCharts='Cartes du Ciel' then  Label1.caption:=''
   else Label1.caption:=rsSkyCharts;
Label3.caption:=cdccpy;
Label4.caption:=rsThisProgramI;
end;

procedure Tf_splash.FormCreate(Sender: TObject);
begin
label2.caption:=cdcversion;
if pos('svn',cdcversion)>0 then begin
   LabelDate.caption:=compile_time;
   LabelDate.Left:=label2.Left+label2.Canvas.TextWidth(cdcversion)+8;
   LabelDate.Visible:=true;
end else
   LabelDate.Visible:=false;
SetLang;
{$ifdef win32}
 ScaleForm(self,Screen.PixelsPerInch/96);
{$endif}
 ShowTimer:=false;
end;

procedure Tf_splash.FormShow(Sender: TObject);
begin
if ShowTimer then begin
   Timer1.Enabled:=true;
end else begin
   Timer1.Enabled:=false;
   BorderStyle:=bsToolWindow;
end;
end;

procedure Tf_splash.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=false;
ShowTimer:=false;
BorderStyle:=bsToolWindow;
Close;
end;

procedure Tf_splash.logoDblClick(Sender: TObject);
begin
Timer1Timer(Sender);
end;

initialization
  {$i pu_splash.lrs}

end.
 
