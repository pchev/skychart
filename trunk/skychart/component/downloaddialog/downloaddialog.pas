unit downloaddialog;

{$mode objfpc}{$H+}

interface

uses LResources, blcksock, HTTPsend, FTPSend,
  Classes, SysUtils, Dialogs, Buttons, Graphics, Forms, Controls, StdCtrls, ExtCtrls;

type

  TDownloadDialog = class(TCommonDialog)
  private
    Furl:string;
    Ffile: string;
    FResponse: string;
    Fsockreadcount,Fsockwritecount : integer;
    Fproxy,Fproxyport,Fproxyuser,Fproxypass : string;
    FFWMode : Integer;
    FFWpassive : Boolean;
    FFWhost, FFWport, FFWUsername, FFWPassword : string;
    DF:TForm;
    okButton,cancelButton:TButton;
    progress : Tedit;
    http: THTTPSend;
    ftp : TFTPSend;
    Timer1 : TTimer;
  protected
    procedure doDownload(Sender: TObject);
    procedure doCancel(Sender: TObject);
    procedure StartDownload(Sender: TObject);
    procedure SockStatus(Sender: TObject; Reason: THookSocketReason; Const Value: string) ;  public
    procedure FTPStatus(Sender: TObject; Response: Boolean; Const Value: string);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
  published
    property URL : string read Furl write Furl;
    property SaveToFile : string read Ffile write Ffile;
    property ResponseText : string read FResponse;
    property HttpProxy : string read Fproxy  write Fproxy ;
    property HttpProxyPort : string read Fproxyport  write Fproxyport ;
    property HttpProxyUser : string read Fproxyuser  write Fproxyuser ;
    property HttpProxyPass : string read Fproxypass  write Fproxypass ;
    property FtpFwMode : integer read FFWMode write FFWMode ;
    property FtpFwPassive : Boolean read FFWpassive write FFWpassive ;
    property FtpFwHost : string read FFWhost  write FFWhost  ;
    property FtpFwPort : string read FFWport  write FFWport  ;
    property FtpFwUserName : string read FFWUsername  write FFWUsername ;
    property FtpFwPassword : string read FFWPassword  write FFWPassword ;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CDC',[TDownloadDialog]);
end;

constructor TDownloadDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Timer1:=TTimer.Create(self);
  Timer1.Enabled:=false;
  Timer1.OnTimer:=@StartDownload;
  Timer1.Interval:=100;
  http:=THTTPSend.Create;
  ftp :=TFTPSend.Create;
  HttpProxy:='';
  FFWMode:=0;
  FFWpassive:=true;
end;

destructor TDownloadDialog.Destroy;
begin
  Timer1.Free;
  http.Free;
  ftp.Free;
  inherited Destroy;
end;

function TDownloadDialog.Execute:boolean;
var urltxt,filetxt: TLabeledEdit;
    pos: TPoint;
begin
  DF:=TForm.Create(Self);
  DF.Caption:='Download File';
  DF.FormStyle:=fsStayOnTop;
  DF.BorderStyle:=bsDialog;
  DF.AutoSize:=true;
  pos:=mouse.CursorPos;
  DF.Left:=pos.x;
  DF.Top:=pos.y;

  urltxt:=TLabeledEdit.Create(self);
  with urltxt do begin
    Parent:=DF;
    width:=300;
    text:=Furl;
    EditLabel.Caption:='Copy from:';
    top:=Editlabel.Height+4;
    left:=8;
    readonly:=true;
    color:=clBtnFace;
  end;

  filetxt:=TLabeledEdit.Create(self);
  with filetxt do begin
    Parent:=DF;
    width:=300;
    text:=Ffile;
    EditLabel.Caption:='to file:';
    top:=Editlabel.Height+urltxt.Top+urltxt.Height+4;
    left:=8;
    readonly:=true;
    color:=clBtnFace;
  end;

  progress:=TEdit.Create(self);
  with progress do begin
    Parent:=DF;
    width:=300;
    text:='';
    top:=filetxt.Top+filetxt.Height+4;
    left:=8;
    readonly:=true;
    color:=clBtnFace;
  end;

  okButton:=TButton.Create(self);
  with okButton do begin
    Parent:=DF;
    Caption:='Download';
    onClick:=@doDownload;
    top:=progress.Top+progress.Height+4;
    left:=8;
    Default:=True;
  end;

  cancelButton:=TButton.Create(self);
  with cancelButton do begin
    Parent:=DF;
    Caption:='Cancel';
    onClick:=@doCancel;
    top:=okButton.top;
    left:=DF.ClientWidth-cancelButton.Width-8;
    Cancel:=True;
  end;

  Result:=DF.ShowModal=mrOK;

  FreeAndNil(urltxt);
  FreeAndNil(filetxt);
  FreeAndNil(progress);
  FreeAndNil(okButton);
  FreeAndNil(cancelButton);
  FreeAndNil(DF);
end;

procedure TDownloadDialog.doDownload(Sender: TObject);
begin
Timer1.Enabled:=true;
end;

procedure TDownloadDialog.doCancel(Sender: TObject);
begin
if not okButton.Visible then begin // transfert in progress
if copy(Furl,1,4)='http' then http.Sock.CloseSocket
                         else ftp.abort;
application.ProcessMessages;
end;
DF.modalresult:=mrCancel;
end;

procedure TDownloadDialog.StartDownload(Sender: TObject);
var ok: boolean;
    buf,ftpdir,ftpfile: string;
    i: integer;
begin
Timer1.Enabled:=false;
FResponse:='';
ok:=false;
if copy(Furl,1,4)='http' then begin        // HTTP protocol
  http.Clear;
  http.Timeout:=300000;
  Fsockreadcount:=0;
  Fsockwritecount:=0;
  if Fproxy<>'' then http.ProxyHost:=Fproxy;
  if Fproxyport<>'' then http.ProxyPort:=Fproxyport;
  if Fproxyuser<>'' then http.ProxyUser :=Fproxyuser;
  if Fproxypass<>'' then http.ProxyPass :=Fproxypass;
  http.Sock.OnStatus:=@SockStatus;
  try
    okButton.Visible:=false;
    if http.HTTPMethod('GET', Furl)
       and ((http.ResultCode=200)
         or (http.ResultCode=0))
    then begin  // success
      http.Document.Position:=0;
      http.Document.SaveToFile(FFile);
      FResponse:=progress.text;
      ok:=true;
    end else begin // error
      FResponse:=progress.text+' / Error: '+inttostr(http.ResultCode)+' '+http.ResultString;
      progress.Text:=FResponse;
      application.processmessages;
      sleep(1000);
    end;
  finally
    okButton.Visible:=true;
    http.Clear;
  end;

end else begin                // FTP protocol
  if copy(Furl,1,3)<>'ftp' then exit;
  i:=pos('://',Furl);
  buf:=copy(Furl,i+3,999);
  i:=pos('/',buf);
  ftp.Targethost:=copy(buf,1,i-1);
  ftp.PassiveMode:=FFWpassive;
  ftp.FWMode:=FFWMode;
  if FFWhost<>'' then ftp.FWHost:=FFWHost;
  if FFWport<>'' then ftp.FWPort:=FFWPort;
  if FFWUsername<>'' then ftp.FWUsername:=FFWUsername;
  if FFWPassword<>'' then ftp.FWPassword:=FFWPassword;
  ftp.OnStatus:=@FTPStatus;
  Fsockreadcount:=0;
  Fsockwritecount:=0;
  ftp.Sock.OnStatus:=@SockStatus;
  buf:=copy(buf,i,999);
  i:=LastDelimiter('/',buf);
  ftpdir:=copy(buf,1,i);
  ftpfile:=copy(buf,i+1,999);
  okButton.Visible:=false;
  try
  if ftp.Login then begin
    ftp.ChangeWorkingDir(ftpdir);
    ftp.DirectFile:=true;
    ftp.DirectFileName:=FFile;
    ok:=ftp.RetrieveFile(ftpfile,false);
    FResponse:=progress.text;
    ftp.logout;
    if not ok then begin
       FResponse:=progress.text+' / Error: '+inttostr(ftp.ResultCode)+' '+ftp.ResultString;
       progress.Text:=FResponse;
       application.processmessages;
       sleep(1000);
    end;
  end;
  finally
    okButton.Visible:=true;
  end;
end;
if ok then DF.modalresult:=mrOK
      else DF.modalresult:=mrCancel;
end;


procedure TDownloadDialog.SockStatus(Sender: TObject; Reason: THookSocketReason; Const Value: string) ;
var reasontxt:string;
begin
case reason of
HR_ResolvingBegin : reasontxt:='Resolving '+value;
HR_Connect        : reasontxt:='Connect '+value;
HR_Accept         : reasontxt:='Accept '+value;
HR_ReadCount      : begin
                    FSockreadcount:=FSockreadcount+strtoint(value);
                    reasontxt:='Read Bytes: '+inttostr(FSockreadcount);
                    end;
HR_WriteCount     : begin
                    FSockwritecount:=FSockwritecount+strtoint(value);
                    reasontxt:='Request sent, waiting response';
                    end;
else reasontxt:='';
end;
if reasontxt>'' then begin
  progress.text:=reasontxt;
  application.processmessages;
end;
end;

procedure TDownloadDialog.FTPStatus(Sender: TObject; Response: Boolean; Const Value: string);
begin
if response then progress.text:=value;
application.processmessages;
end;


initialization
  {$I downloaddialog.lrs}
end.

