unit test1;

{$mode objfpc}{$H+}

interface

uses indibaseclient, indibasedevice, indiapi, indicom,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    client: TIndiBaseClient;
    procedure NewDevice(dp: Basedevice);
    procedure NewMessage(msg: string);
    procedure NewProperty(indiProp: IndiProperty);
    procedure NewNumber(nvp: INumberVectorProperty);
    procedure NewText(tvp: ITextVectorProperty);
    procedure NewSwitch(svp: ISwitchVectorProperty);
    procedure NewLight(lvp: ILightVectorProperty);
    procedure NewBlob(bp: IBLOB);
    procedure ServerConnected(Sender: TObject);
    procedure ServerDisconnected(Sender: TObject);
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure Isleep(milli:integer);
var tx: double;
begin
  tx:=now+milli/1000/3600/24;
  repeat
    sleep(10);
    Application.ProcessMessages;
  until now>tx;
end;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (client=nil)or(client.Terminated) then begin
    client:=TIndiBaseClient.Create;
    client.onNewDevice:=@NewDevice;
    client.onNewMessage:=@NewMessage;
    client.onNewProperty:=@NewProperty;
    client.onNewNumber:=@NewNumber;
    client.onNewText:=@NewText;
    client.onNewSwitch:=@NewSwitch;
    client.onNewLight:=@NewLight;
    client.onNewBlob:=@NewBlob;
    client.onServerConnected:=@ServerConnected;
    client.onServerDisconnected:=@ServerDisconnected;
  end else begin
    memo1.Lines.Add('Already connected');
    exit;
  end;
  client.SetServer(Edit1.Text,Edit2.Text);
  client.watchDevice('Telescope Simulator');
  client.watchDevice('CCD Simulator');
  client.ConnectServer;
end;

procedure TForm1.Button2Click(Sender: TObject);
var dp:basedevice;
    nvp:INumberVectorProperty;
    np:INumber;
begin
   dp:=client.getDevice('CCD Simulator');
   nvp:=dp.getNumber('CCD_EXPOSURE');
   np:=IUFindNumber(nvp,'CCD_EXPOSURE_VALUE');
   np.value:=2;
   client.sendNewNumber(nvp);
end;

procedure TForm1.Button3Click(Sender: TObject);
var dp:basedevice;
    svp:ISwitchVectorProperty;
    s:ISwitch;
    nvp:INumberVectorProperty;
    np:INumber;
begin
 dp:=client.getDevice('Telescope Simulator');
 svp:=dp.getSwitch('ON_COORD_SET');
 IUResetSwitch(svp);
 s:=IUFindSwitch(svp,'SLEW');
 s.s:=ISS_ON;
 client.sendNewSwitch(svp);
 nvp:=dp.getNumber('EQUATORIAL_EOD_COORD');
 np:=IUFindNumber(nvp,'RA');
 np.value:=StrToFloat(Edit3.Text);
 np:=IUFindNumber(nvp,'DEC');
 np.value:=StrToFloat(Edit4.Text);
 client.sendNewNumber(nvp);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if client<>nil then client.DisconnectServer;
  Isleep(500);
  CloseAction:=caFree;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DefaultFormatSettings.DecimalSeparator:='.';
end;

procedure TForm1.ServerConnected(Sender: TObject);
begin
  memo1.Lines.Add('Server connected');
  client.connectDevice('Telescope Simulator');
  client.connectDevice('CCD Simulator');
  client.setBLOBMode(B_ALSO,'CCD Simulator');
end;

procedure TForm1.ServerDisconnected(Sender: TObject);
begin
  memo1.Lines.Add('Server disconnected');
end;

procedure TForm1.NewDevice(dp: Basedevice);
begin
  memo1.Lines.Add('Newdev: '+dp.getDeviceName);
end;

procedure TForm1.NewMessage(msg: string);
begin
  memo1.Lines.Add('Message: '+msg);
end;

procedure TForm1.NewProperty(indiProp: IndiProperty);
begin
  memo1.Lines.Add('Newprop: '+indiProp.getDeviceName+' '+indiProp.getName+' '+indiProp.getLabel);
end;

procedure TForm1.NewNumber(nvp: INumberVectorProperty);
var n: INumber;
begin
  memo1.Lines.Add('NewNumber: '+nvp.name+' '+FloatToStr(nvp.np[0].value));
  if nvp.name='EQUATORIAL_EOD_COORD' then begin
     n:=IUFindNumber(nvp,'RA');
     Label1.Caption:=FloatToStr(n.value);
     n:=IUFindNumber(nvp,'DEC');
     Label2.Caption:=FloatToStr(n.value);
  end;
end;

procedure TForm1.NewText(tvp: ITextVectorProperty);
begin
  memo1.Lines.Add('NewText: '+tvp.name+' '+tvp.tp[0].text);
end;

procedure TForm1.NewSwitch(svp: ISwitchVectorProperty);
begin
  memo1.Lines.Add('NewSwitch: '+svp.name);
end;

procedure TForm1.NewLight(lvp: ILightVectorProperty);
begin
  memo1.Lines.Add('NewLight: '+lvp.name);
end;

procedure TForm1.NewBlob(bp: IBLOB);
var //str:TStringStream;
    //mem:TMemoryStream;
    f: textfile;
begin
 memo1.Lines.Add('NewBlob: '+bp.name);
 if bp.bloblen>0 then begin
{   str:=TStringStream.Create(bp.blob);
   mem:=TMemoryStream.Create;
   mem.CopyFrom(str,str.Size);
   mem.SaveToFile('/tmp/testindi.fits');
   mem.free;
   str.free;}
   AssignFile(f,'/tmp/testindi.fits');
   rewrite(f);
   Write(f,bp.blob);
   closefile(f);
 end;
end;

end.

