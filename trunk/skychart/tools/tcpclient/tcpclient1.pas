unit tcpclient1;
{                                        
Copyright (C) 2003 Patrick Chevalley

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
  Example of a TCP/IP client for Cartes du Ciel
}

interface

uses cu_tcpclient,
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QExtCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    Button3: TButton;
    Label3: TLabel;
    Memo1: TMemo;
    ComboBox1: TComboBox;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Combobox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    client : TClientThrd;
    procedure ShowInfo(Sender: TObject; const messagetext:string);
    procedure ReceiveData(Sender : TObject; const data : string);
  end;

var
  Form1: TForm1;

implementation

{$R *.xfm}

procedure TForm1.ShowInfo(Sender: TObject; const messagetext:string);
begin
// process here socket status message.
  edit3.Text:=messagetext;
  edit3.Invalidate;
end;

procedure TForm1.ReceiveData(Sender : TObject; const data : string);
begin
// process here unattended message from Cartes du Ciel.
  memo1.Lines.Add(Data);
end;

procedure TForm1.Button1Click(Sender: TObject);
// connect button
begin
if (client=nil)or(client.Terminated) then
   client:=TClientThrd.Create
   else exit;
client.TargetHost:=edit1.Text;
client.TargetPort:=edit2.Text;
client.Timeout := 500;    // tcp/ip timeout [ms] also act as a delay before to send command
client.CmdTimeout := 10;  // cdc response timeout [seconds]
client.onShowMessage:=ShowInfo;
client.onReceiveData:=ReceiveData;
client.Resume;
end;

procedure TForm1.Button2Click(Sender: TObject);
// disconnect button
var resp:string;
begin
if (client<>nil)and(not client.Terminated) then begin
   resp:=client.Send('quit');
   memo1.lines.add(resp);
   client.terminate;
end;
end;

procedure TForm1.Button3Click(Sender: TObject);
// send command button
var resp:string;
begin
if (client<>nil)and(not client.Terminated) then begin
   resp:=client.Send(combobox1.Text);
   memo1.lines.add(resp);
end;
end;

procedure TForm1.Combobox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key=4100)or(key=13) then Button3Click(sender);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if client<>nil then begin
   client.terminate;
end;
end;

procedure TForm1.Button4Click(Sender: TObject);
// example of chained command with process of the result
var resp,cname:string;
    i : integer;
begin
if (client<>nil)and(not client.Terminated) then begin
  cname:='tcpcli';
  resp:=client.Send('NEWCHART '+cname);
  i:=pos(' ',resp);
  if i>0 then begin
    cname:=copy(resp,i+1,999);
    resp:=copy(resp,1,i-1);
  end;
  if resp<>msgOK then raise exception.Create('Cannot create new chart');
  resp:=client.Send('SELECTCHART '+cname);
  if resp<>msgOK then raise exception.Create('Cannot activate '+cname);
  memo1.lines.add(resp+', new chart name is '+cname);
end;
end;

end.
