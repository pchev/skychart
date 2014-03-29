unit samptest1;

{$mode objfpc}{$H+}

interface

uses cu_sampclient, Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    StatusTimer: TTimer;
    ClientChangeTimer: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ClientChangeTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StatusTimerTimer(Sender: TObject);
  private
    { private declarations }
    samp: TSampClient;
    procedure ClientChange(Sender: TObject);
    procedure coordpointAtsky(ra,dec:double);
    procedure ImageLoadFits(image_name,image_id,url:string);
    procedure TableLoadVotable(table_name,table_id,url:string);
    procedure TableHighlightRow(table_id,url,row:string);
    procedure TableSelectRowlist(table_id,url:string;rowlist:Tstringlist);
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const f3= '0.000';

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 samp:=TSampClient.Create;
 samp.onClientChange:=@ClientChange;
 samp.oncoordpointAtsky:=@coordpointAtsky;
 samp.onImageLoadFits:=@ImageLoadFits;
 samp.onTableLoadVotable:=@TableLoadVotable;
 samp.onTableHighlightRow:=@TableHighlightRow;
 samp.onTableSelectRowlist:=@TableSelectRowlist;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  samp.Free;
end;

procedure TForm1.StatusTimerTimer(Sender: TObject);
begin
  if samp.Connected then label1.Caption:='Connected'
                    else label1.Caption:='Disconnected';
 end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if samp.SampReadProfile then begin
  if not samp.SampHubConnect then memo1.Lines.Add(samp.LastError);
  if samp.Connected then begin
    memo1.Lines.Add('Connected to '+samp.HubUrl);
    if not samp.SampHubSendMetadata then memo1.Lines.Add(samp.LastError);
    if not samp.SampSubscribe then memo1.Lines.Add(samp.LastError);
    Label2.Caption:=inttostr(samp.ListenPort);
  end;
end else begin
    memo1.Lines.Add(samp.LastError);
end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 ClientChange(Sender);
end;

procedure TForm1.ClientChange(Sender: TObject);
begin
  ClientChangeTimer.Enabled:=true;
end;

procedure TForm1.ClientChangeTimerTimer(Sender: TObject);
var i,n: integer;
begin
  ClientChangeTimer.Enabled:=false;
  RadioGroup1.Items.Clear;
  if samp.SampHubGetClientList then begin
     n:=samp.Clients.Count;
     if n=0 then memo1.Lines.Add('No clients')
     else for i:=0 to n-1 do begin
        memo1.Lines.Add(samp.Clients[i]+', '+samp.ClientNames[i]+', '+samp.ClientDesc[i]);
        if coord_pointAt_sky in samp.ClientSubscriptions[i] then RadioGroup1.Items.Add(samp.Clients[i]+', '+samp.ClientNames[i]);
     end;
     if RadioGroup1.Items.Count>0 then RadioGroup1.Items.Add('All');
     RadioGroup1.ItemIndex:=0;
  end
  else memo1.Lines.Add('Error '+inttostr(samp.LastErrorcode)+samp.LastError);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if not samp.SampHubDisconnect then memo1.Lines.Add(samp.LastError);
  if samp.Connected then
     memo1.Lines.Add('Connected to '+samp.HubUrl)
  else
    memo1.Lines.Add('Disconnected');
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if samp.Connected then samp.SampHubDisconnect;
end;

procedure TForm1.Button2Click(Sender: TObject);
var i: integer;
    client:string;
begin
  client:=RadioGroup1.Items[RadioGroup1.ItemIndex];
  i:=pos(',',client);
  if i>0 then client:=trim(copy(client,1,i-1))
         else client:='';
  if samp.SampSendCoord(client,105,10) then
     memo1.Lines.Add('OK')
  else memo1.Lines.Add('Error '+inttostr(samp.LastErrorcode)+samp.LastError);
end;

procedure TForm1.coordpointAtsky(ra,dec:double);
begin
   memo1.Lines.Add('coordpointAtsky '+formatfloat(f3,ra)+' '+formatfloat(f3,dec));
end;

procedure TForm1.ImageLoadFits(image_name,image_id,url:string);
begin
   memo1.Lines.Add('ImageLoadFits '+image_name+chr(13)+image_id+chr(13)+url);
end;

procedure TForm1.TableLoadVotable(table_name,table_id,url:string);
begin
   memo1.Lines.Add('TableLoadVotable '+table_name+chr(13)+table_id+chr(13)+url);
end;

procedure TForm1.TableHighlightRow(table_id,url,row:string);
begin
  memo1.Lines.Add('TableHighlightRow '+table_id+chr(13)+url+chr(13)+row);
end;

procedure TForm1.TableSelectRowlist(table_id,url:string;rowlist:Tstringlist);
var i:integer;
begin
  memo1.Lines.Add('TableSelectRowlist '+table_id+chr(13)+url+chr(13));
  for i:=0 to rowlist.Count-1 do memo1.Lines.Add(rowlist[i]);
end;

end.

