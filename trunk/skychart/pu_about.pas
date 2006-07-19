unit pu_about;

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
 About form for Windows VCL application
}

interface

uses u_translation, u_constant, u_util,
  LCLIntf, Classes, Graphics, Forms, Controls, StdCtrls,
  ExtCtrls, LResources;

type

  { Tf_about }

  Tf_about = class(TForm)
    DateLabel: TLabel;
    logo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure logoDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    compile_time:string;
    ShowTimer: Boolean;
    procedure SetLang;
  end;

var
  f_about: Tf_about;

implementation

procedure Tf_about.SetLang;
begin
Caption:=rsAbout;
Label1.caption:=rsSkyCharts;
Label4.caption:=rsThisProgramI;
end;

procedure Tf_about.FormCreate(Sender: TObject);
begin
SetLang;
{$ifdef win32}
 ScaleForm(self,Screen.PixelsPerInch/96);
{$endif}
 ShowTimer:=false;
 label2.caption:=cdcversion;
end;

procedure Tf_about.FormShow(Sender: TObject);
begin
DateLabel.Caption:=compile_time;
if ShowTimer then begin
   Timer1.Enabled:=true;
end else begin
   Timer1.Enabled:=false;
end;
end;

procedure Tf_about.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=false;
ShowTimer:=false;
BorderStyle:=bsToolWindow;
ClientHeight:=253;
Close;
end;

procedure Tf_about.logoDblClick(Sender: TObject);
begin
Timer1Timer(Sender);
end;

initialization
  {$i pu_about.lrs}

end.
 
