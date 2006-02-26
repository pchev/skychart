unit downloaddialog;
{
Copyright (C) 2006 Patrick Chevalley

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

{$mode objfpc}{$H+}

interface

uses
  LResources, blcksock, HTTPsend, FTPSend,
  Classes, SysUtils, Dialogs, Buttons, Graphics, Forms, Controls, StdCtrls, ExtCtrls;

type
  TDownloadProtocol=(prHttp,prFtp);
  TDownloadProc= procedure of object;
  TDownloadDaemon = class(TThread)
  private
    FonDownloadComplete: TDownloadProc;
    FonProgress: TDownloadProc;
    procedure SockStatus(Sender: TObject; Reason: THookSocketReason; Const Value: string) ;  public
    procedure FTPStatus(Sender: TObject; Response: Boolean; Const Value: string);
  public
    Phttp: ^THTTPSend;
    Pftp : ^TFTPSend;
    protocol:TDownloadProtocol;
    Fsockreadcount,Fsockwritecount : integer;
    Durl,Dftpdir,Dftpfile,progresstext:string;
    ok:boolean;
    Constructor Create;
    procedure Execute; override;
    property onDownloadComplete: TDownloadProc read FonDownloadComplete write FonDownloadComplete;
    property onProgress : TDownloadProc read FonProgress write FonProgress;
  end;

  TDownloadDialog = class(TCommonDialog)
  private
    DownloadDaemon: TDownloadDaemon;
    Furl:string;
    Ffile: string;
    FResponse: string;
    Fproxy,Fproxyport,Fproxyuser,Fproxypass : string;
    FFWMode : Integer;
    FFWpassive : Boolean;
    FFWhost, FFWport, FFWUsername, FFWPassword : string;
    DF:TForm;
    okButton,cancelButton:TButton;
    progress : Tedit;
    http: THTTPSend;
    ftp : TFTPSend;
  protected
    procedure BtnDownload(Sender: TObject);
    procedure BtnCancel(Sender: TObject);
    procedure doCancel(Sender: TObject);
    procedure StartDownload;
    procedure HTTPComplete;
    procedure FTPComplete;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
    procedure progressreport;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
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
  http:=THTTPSend.Create;
  ftp :=TFTPSend.Create;
  HttpProxy:='';
  FFWMode:=0;
  FFWpassive:=true;
end;

destructor TDownloadDialog.Destroy;
begin
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
  DF.OnClose:=@FormClose;

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
    onClick:=@BtnDownload;
    top:=progress.Top+progress.Height+4;
    left:=8;
    Default:=True;
  end;

  cancelButton:=TButton.Create(self);
  with cancelButton do begin
    Parent:=DF;
    Caption:='Cancel';
    onClick:=@BtnCancel;
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

procedure TDownloadDialog.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  doCancel(Sender);
end;

procedure TDownloadDialog.BtnDownload(Sender: TObject);
begin
StartDownload;
end;

procedure TDownloadDialog.BtnCancel(Sender: TObject);
begin
DF.Close;
end;

procedure TDownloadDialog.doCancel(Sender: TObject);
begin
if not okButton.Visible then begin // transfert in progress
  DownloadDaemon.onProgress:=nil;
  DownloadDaemon.onDownloadComplete:=nil;
  if DownloadDaemon.protocol=prHttp then begin
     http.Sock.onStatus:=nil;
     http.Abort;
  end;
  if DownloadDaemon.protocol=prFtp then begin
     ftp.Sock.onStatus:=nil;
     ftp.onStatus:=nil;
     ftp.Abort;
  end;
end;
end;

procedure TDownloadDialog.StartDownload;
var ok: boolean;
    buf,ftpdir,ftpfile: string;
    i: integer;
begin
FResponse:='';
ok:=false;
if copy(Furl,1,4)='http' then begin        // HTTP protocol
  http.Clear;
  if Fproxy<>'' then http.ProxyHost:=Fproxy;
  if Fproxyport<>'' then http.ProxyPort:=Fproxyport;
  if Fproxyuser<>'' then http.ProxyUser :=Fproxyuser;
  if Fproxypass<>'' then http.ProxyPass :=Fproxypass;
  okButton.Visible:=false;
  DownloadDaemon:=TDownloadDaemon.Create;
  DownloadDaemon.Phttp:=@http;
  DownloadDaemon.Durl:=Furl;
  DownloadDaemon.protocol:=prHttp;
  DownloadDaemon.onProgress:=@progressreport;
  DownloadDaemon.onDownloadComplete:=@HTTPComplete;
  DownloadDaemon.Resume;
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
  buf:=copy(buf,i,999);
  i:=LastDelimiter('/',buf);
  ftpdir:=copy(buf,1,i);
  ftpfile:=copy(buf,i+1,999);
  ftp.DirectFile:=true;
  ftp.DirectFileName:=FFile;
  okButton.Visible:=false;
  DownloadDaemon:=TDownloadDaemon.Create;
  DownloadDaemon.Pftp:=@ftp;
  DownloadDaemon.Dftpdir:=ftpdir;
  DownloadDaemon.Dftpfile:=ftpfile;
  DownloadDaemon.protocol:=prFtp;
  DownloadDaemon.onProgress:=@progressreport;
  DownloadDaemon.onDownloadComplete:=@FTPComplete;
  DownloadDaemon.Resume;
end;
end;

procedure TDownloadDialog.HTTPComplete;
var ok:boolean;
begin
 ok:=DownloadDaemon.ok;
 if ok
    and ((http.ResultCode=200)
    or (http.ResultCode=0))
    then begin  // success
      http.Document.Position:=0;
      http.Document.SaveToFile(FFile);
      FResponse:=progress.text;
    end else begin // error
      FResponse:=progress.text+' / Error: '+inttostr(http.ResultCode)+' '+http.ResultString;
      progress.Text:=FResponse;
 end;
 okButton.Visible:=true;
 http.Clear;
 if ok then DF.modalresult:=mrOK
       else DF.modalresult:=mrCancel;
end;

procedure TDownloadDialog.FTPComplete;
var ok:boolean;
begin
 ok:=DownloadDaemon.ok;
 FResponse:=progress.text;
 ftp.logout;
 if not ok then begin
       FResponse:=progress.text+' / Error: '+inttostr(ftp.ResultCode)+' '+ftp.ResultString;
       progress.Text:=FResponse;
       application.processmessages;
       sleep(1000);
 end;
 okButton.Visible:=true;
 if ok then DF.modalresult:=mrOK
       else DF.modalresult:=mrCancel;
end;

procedure TDownloadDialog.progressreport;
begin
  progress.text:=DownloadDaemon.progresstext;
end;

Constructor TDownloadDaemon.Create;
begin
  ok:=false;
  FreeOnTerminate:=true;
  inherited create(true);
end;

procedure TDownloadDaemon.Execute;
begin
Fsockreadcount:=0;
Fsockwritecount:=0;
if protocol=prHttp then begin
  phttp^.Sock.OnStatus:=@SockStatus;
  ok:=phttp^.HTTPMethod('GET', Durl)
end;
if protocol=prFtp then begin
  pftp^.OnStatus:=@FTPStatus;
  pftp^.Sock.OnStatus:=@SockStatus;
  if pftp^.Login then begin
    pftp^.ChangeWorkingDir(Dftpdir);
    ok:=pftp^.RetrieveFile(Dftpfile,false);
  end;
end;
if assigned(FonDownloadComplete) then synchronize(FonDownloadComplete);
end;

procedure TDownloadDaemon.SockStatus(Sender: TObject; Reason: THookSocketReason; Const Value: string) ;
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
if (reasontxt>'')and assigned(FonProgress) then begin
  progresstext:=reasontxt;
  synchronize(FonProgress);
end;
end;


procedure TDownloadDaemon.FTPStatus(Sender: TObject; Response: Boolean; Const Value: string);
begin
if response and assigned(FonProgress) then begin
  progresstext:=value;
  synchronize(FonProgress);
end;
end;

initialization
  {$I downloaddialog.lrs}
end.

