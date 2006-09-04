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
  ExtCtrls, LResources, Buttons;

type

  { Tf_about }

  Tf_about = class(TForm)
    Button1: TButton;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Notebook1: TNotebook;
    Page1: TPage;
    Page2: TPage;
    Page3: TPage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel0: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Panell1Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang;
  end;

var
  f_about: Tf_about;

implementation

procedure Tf_about.SetLang;
begin
Caption:=rsAbout;
if rsSkyCharts='Cartes du Ciel' then  Label5.caption:=''
   else Label5.caption:=rsSkyCharts;
Label7.caption:=rsThisProgramI;
Button1.Caption:=rsClose;
Label8.caption:=cdccpy;
Label3.caption:=rsPleaseReport;
page1.Caption:=rsAbout;
page2.Caption:=rsAuthors;
page3.Caption:=rsLicenseAgree;
end;

procedure Tf_about.FormCreate(Sender: TObject);
begin
SetLang;
{$ifdef win32}
 ScaleForm(self,Screen.PixelsPerInch/96);
{$endif}
 panel1.caption:=URL_WebHome;
 panel5.caption:=URL_BugTracker;
 label2.caption:=cdcversion+blank+compile_time;
 memo1.Text:=rsProgrammer+crlf+cdcauthors+crlf+crlf+rsTranslator+crlf+rsCDCTranslator+crlf+crlf;
end;

procedure Tf_about.Panell1Click(Sender: TObject);
begin
  ExecuteFile(URL_WebHome);
end;

procedure Tf_about.Panel5Click(Sender: TObject);
begin
  ExecuteFile(URL_BugTracker);
end;

initialization
  {$i pu_about.lrs}

end.
 
