unit pu_search;

{$MODE Delphi}{$H+}

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
 Search dialog for different object type.
}

interface

uses u_constant, u_util,
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, LResources;

type

  { Tf_search }

  Tf_search = class(TForm)
    RadioGroup1: TRadioGroup;
    IDPanel: TPanel;
    Button1: TButton;
    Button2: TButton;
    Id: TEdit;
    NumPanel: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    Label1: TLabel;
    NebPanel: TPanel;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    StarPanel: TPanel;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    VarPanel: TPanel;
    SpeedButton21: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton29: TSpeedButton;
    DblPanel: TPanel;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    PlanetPanel: TPanel;
    PlanetBox: TComboBox;
    Label2: TLabel;
    NebNamePanel: TPanel;
    Label3: TLabel;
    NebNameBox: TComboBox;
    StarNamePanel: TPanel;
    Label4: TLabel;
    StarNameBox: TComboBox;
    ConstPanel: TPanel;
    Label5: TLabel;
    ConstBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure NumButtonClick(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CatButtonClick(Sender: TObject);
    procedure IdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Init;
    procedure InitPlanet;
    procedure InitConst;
    procedure InitStarName;
    procedure InitNebName;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    NebNameAR : array of single;
    NebNameDE : array of single;
    numNebName : integer;
    Fnightvision:boolean;
  public
    { Public declarations }
    Num : string;
    ra,de: double;
    SearchKind : integer;
    cfgshr: conf_shared;
  end;

var
  f_search: Tf_search;

implementation


procedure Tf_search.FormShow(Sender: TObject);
begin
{$ifdef WIN32}
if Fnightvision<>nightvision then begin
   SetFormNightVision(self,nightvision);
   Fnightvision:=nightvision;
end;
{$endif}
end;

procedure Tf_search.CatButtonClick(Sender: TObject);
begin
with sender as TspeedButton do begin
  Id.text:=caption;
end;
Id.SelStart:=length(Id.Text);
end;

procedure Tf_search.NumButtonClick(Sender: TObject);
begin
with sender as TspeedButton do begin
  Id.text:=Id.text+caption;
end;
Id.SelStart:=length(Id.Text);
end;

procedure Tf_search.FormCreate(Sender: TObject);
begin
  Fnightvision:=false;
end;


procedure Tf_search.SpeedButton11Click(Sender: TObject);
var buf : string;
begin
buf:=Id.text;
delete(buf,length(buf),1);
Id.text:=buf;
Id.SelStart:=length(Id.Text);
end;

procedure Tf_search.SpeedButton13Click(Sender: TObject);
begin
Id.text:='';
end;

procedure Tf_search.Button1Click(Sender: TObject);
begin
searchkind:=RadioGroup1.itemindex;
case searchkind of
  1 : begin
      num:=NebNameBox.Text;
      ra:=NebNameAR[NebNameBox.itemindex];
      de:=NebNameDE[NebNameBox.itemindex];
      end;
  3 : num:='HR'+inttostr(cfgshr.StarNameHR[starnamebox.itemindex]);
  8 : num:=PlanetBox.Text;
  9 : num:=ConstBox.Text;
  else num:=Id.text;
end;
if trim(num)='' then ShowMessage('Please enter an object identifier.')
                else ModalResult := mrOk;
end;

procedure Tf_search.IdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=key_cr then Button1.Click;
end;

procedure Tf_search.RadioGroup1Click(Sender: TObject);
begin
case RadioGroup1.itemindex of
  0 : begin                      //neb
      IDPanel.Visible:=true;
      NumPanel.Visible:=true;
      NebPanel.Visible:=true;
      StarPanel.Visible:=false;
      VarPanel.Visible:=false;
      DblPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      end;
  1 : begin                      //neb name
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=true;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      end;
  2 : begin                      //star
      IDPanel.Visible:=true;
      NumPanel.Visible:=true;
      NebPanel.Visible:=false;
      StarPanel.Visible:=true;
      VarPanel.Visible:=false;
      DblPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      end;
  3 : begin                      //star name
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=true;
      ConstPanel.Visible:=false;
      end;
  4 : begin                      //var
      IDPanel.Visible:=true;
      NumPanel.Visible:=true;
      NebPanel.Visible:=false;
      StarPanel.Visible:=false;
      VarPanel.Visible:=true;
      DblPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      end;
  5 : begin                      //dbl
      IDPanel.Visible:=true;
      NumPanel.Visible:=true;
      NebPanel.Visible:=false;
      StarPanel.Visible:=false;
      VarPanel.Visible:=false;
      DblPanel.Visible:=true;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      end;
  6 : begin                      //comet
      IDPanel.Visible:=true;
      NumPanel.Visible:=false;
      NebPanel.Visible:=false;
      StarPanel.Visible:=false;
      VarPanel.Visible:=false;
      DblPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      end;
  7 : begin                      //asteroid
      IDPanel.Visible:=true;
      NumPanel.Visible:=false;
      NebPanel.Visible:=false;
      StarPanel.Visible:=false;
      VarPanel.Visible:=false;
      DblPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      end;
  8 : begin                      //planet
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=true;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      end;
  9 : begin                      //const
      IDPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=true;
      end;
  10 : begin                      //Other Line Catalog , not active at the moment as Catgen do not allow to create the index for line cat. 
      IDPanel.Visible:=true;
      NumPanel.Visible:=false;
      NebPanel.Visible:=false;
      StarPanel.Visible:=false;
      VarPanel.Visible:=false;
      DblPanel.Visible:=false;
      PlanetPanel.Visible:=false;
      NebNamePanel.Visible:=false;
      StarNamePanel.Visible:=false;
      ConstPanel.Visible:=false;
      end;
end;
end;

procedure Tf_search.Init;
begin
InitPlanet;
InitConst;
InitNebName;
InitStarName;
end;

procedure Tf_search.InitPlanet;
var i : integer;
begin
PlanetBox.Clear;
for i:=1 to 11 do begin
  if i=3 then continue;
  PlanetBox.Items.Add(pla[i]);
end;
PlanetBox.ItemIndex:=0;
end;

procedure Tf_search.InitConst;
var i : integer;
begin
ConstBox.Clear;
for i:=0 to cfgshr.ConstelNum-1 do
  ConstBox.Items.Add(cfgshr.ConstelName[i,2]);
if ConstBox.items.Count=0 then
   ConstBox.items.add(blank);
ConstBox.ItemIndex:=0;
end;

procedure Tf_search.InitStarName;
var
    i : integer;
begin
starnamebox.Clear;
for i:=0 to cfgshr.StarNameNum-1 do
   starnamebox.items.Add(cfgshr.StarName[i]);
if starnamebox.items.Count=0 then
   starnamebox.items.add(blank);
starnamebox.itemindex:=0;
end;

procedure Tf_search.InitNebName;
var
    n,fn : string;
    buf : string;
    f : textfile;
    i,p : integer;
begin
try
NebNameBox.Clear;
i:=0;
fn:=slash(appdir)+slash('data')+slash('common_names')+'NebulaNames.txt';
numNebName:=100;
setlength(NebNameAR,numNebName);
setlength(NebNameDE,numNebName);
if FileExists(fn) then begin
  AssignFile(f,fn);
  FileMode:=0;
  reset(f);
  repeat
    if i>=numNebName then begin
       numNebName:=numNebName+50;
       setlength(NebNameAR,numNebName);
       setlength(NebNameDE,numNebName);
    end;
    Readln(f,buf);
    p:=pos(';',buf);
    if p=0 then continue;
    if not isnumber(trim(copy(buf,1,p-1))) then continue;
    NebNameAR[i]:=deg2rad*15*strtofloat(trim(copy(buf,1,p-1)));
    delete(buf,1,p);
    p:=pos(';',buf);
    if p=0 then continue;
    NebNameDE[i]:=deg2rad*strtofloat(trim(copy(buf,1,p-1)));
    delete(buf,1,p);
    n:=trim(buf);
    NebNameBox.items.Add(n);
    inc(i);
  until eof(f);
  numNebName:=i-1;
  CloseFile(f);
end;
finally
if NebNameBox.items.Count=0 then begin
  NebNameBox.items.add(blank);
end;
NebNameBox.ItemIndex:=0;
end;
end;

initialization
  {$i pu_search.lrs}

end.
