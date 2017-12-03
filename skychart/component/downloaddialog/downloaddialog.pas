unit downloaddialog;

{
Copyright (C) 2006 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

{$mode objfpc}{$H+}

interface

uses
  LResources, blcksock, HTTPsend, FTPSend, FileUtil, ssl_openssl,
  Classes, SysUtils, LazUTF8, Dialogs, Buttons, Graphics, Forms,
  Controls, StdCtrls, ExtCtrls;

type

  TDownloadProtocol = (prHttp, prFtp);
  TDownloadProc = procedure of object;
  TDownloadFeedback = procedure(txt: string) of object;

  TDownloadDaemon = class(TThread)
  private

    FFileSize: int64;

    FonDownloadComplete: TDownloadProc;
    FonProgress: TDownloadProc;

    FMillis: cardinal; // passed ms

    procedure SockStatus(Sender: TObject; Reason: THookSocketReason;
      const Value: string);
    procedure SockMonitor(Sender: TObject; Writing: boolean;
      const Buffer: Pointer; Len: integer);
    //const Buffer: TMemory; Len: Integer);

  public

    procedure FTPStatus(Sender: TObject; Response: boolean; const Value: string);
    procedure UpdateSizeText(ASize: int64);

  public
    Phttp: ^THTTPSend;
    Pftp: ^TFTPSend;
    protocol: TDownloadProtocol;

    Fsockreadcount, Fsockwritecount: integer;

    Durl, Dftpdir, Dftpfile, progresstext: string;
    ok: boolean;

    constructor Create;
    procedure Execute; override;
    property onDownloadComplete: TDownloadProc
      read FonDownloadComplete write FonDownloadComplete;
    property onProgress: TDownloadProc read FonProgress write FonProgress;

    //SZ Add if needed
    //property FileSize: int64 read FFileSize;

  end;

  TDownloadDialog = class(TCommonDialog)
  private
    DownloadDaemon: TDownloadDaemon;
    FDownloadFeedback: TDownloadFeedback;
    Furl, Ffirsturl: string;
    Ffile: string;
    FResponse: string;
    Fproxy, Fproxyport, Fproxyuser, Fproxypass: string;
    FSocksproxy, FSockstype: string;
    FTimeout: integer;
    FFWMode: integer;
    FFWpassive: boolean;
    FUsername, FPassword, FFWhost, FFWport, FFWUsername, FFWPassword: string;
    FDownloadFile, FCopyfrom, Ftofile, FDownload, FCancel: string;
    FConfirmDownload: boolean;
    FQuickCancel: boolean;
    DF: TForm;
    okButton, cancelButton: TButton;
    progress: Tedit;
    http: THTTPSend;
    ftp: TFTPSend;
    Timer1: TTimer;
  protected
    procedure BtnDownload(Sender: TObject);
    procedure BtnCancel(Sender: TObject);
    procedure doCancel(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StartDownload;
    procedure HTTPComplete;
    procedure FTPComplete;
    procedure progressreport;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: boolean; override;
    property msgDownloadFile: string read FDownloadFile write FDownloadFile;
    property msgCopyfrom: string read FCopyfrom write FCopyfrom;
    property msgtofile: string read Ftofile write Ftofile;
    property msgDownloadBtn: string read FDownload write FDownload;
    property msgCancelBtn: string read FCancel write FCancel;
  published
    property URL: string read Furl write Furl;
    property SaveToFile: string read Ffile write Ffile;
    property ResponseText: string read FResponse;
    property Timeout: integer read FTimeout write FTimeout;
    property HttpProxy: string read Fproxy write Fproxy;
    property HttpProxyPort: string read Fproxyport write Fproxyport;
    property HttpProxyUser: string read Fproxyuser write Fproxyuser;
    property HttpProxyPass: string read Fproxypass write Fproxypass;
    property SocksProxy: string read FSocksproxy write FSocksproxy;
    property SocksType: string read FSockstype write FSockstype;
    property FtpUserName: string read FUsername write FUsername;
    property FtpPassword: string read FPassword write FPassword;
    property FtpFwMode: integer read FFWMode write FFWMode;
    property FtpFwPassive: boolean read FFWpassive write FFWpassive;
    property FtpFwHost: string read FFWhost write FFWhost;
    property FtpFwPort: string read FFWport write FFWport;
    property FtpFwUserName: string read FFWUsername write FFWUsername;
    property FtpFwPassword: string read FFWPassword write FFWPassword;
    property ConfirmDownload: boolean read FConfirmDownload write FConfirmDownload;
    property QuickCancel: boolean read FQuickCancel write FQuickCancel;
    property onFeedback: TDownloadFeedback read FDownloadFeedback
      write FDownloadFeedback;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CDC', [TDownloadDialog]);
end;

procedure FormPos(form: TForm; x, y: integer);
const
  bot = 36; //minimal distance from screen bottom
begin

  with Form do
  begin
    left := x;
    if left + Width > Screen.Width then
      left := Screen.Width - Width;
    if left < 0 then
      left := 0;
    top := y;
    if top + Height > (Screen.Height - bot) then
      top := Screen.Height - Height - bot;
    if top < 0 then
      top := 0;
  end;

end;

constructor TDownloadDialog.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  http := THTTPSend.Create;
  http.UserAgent := 'Wget/1.16.1 (linux-gnu)';
  ftp := TFTPSend.Create;
  Timer1 := TTimer.Create(self);
  Timer1.Enabled := False;
  Timer1.Interval := 2000;
  Timer1.OnTimer := @Timer1Timer;
  FTimeout := 90000;
  FQuickCancel := False;
  Fproxy := '';
  FSocksproxy := '';
  FFWMode := 0;
  FFWpassive := True;
  FConfirmDownload := True;
  FDownloadFile := 'Download File';
  FCopyfrom := 'Copy from:';
  Ftofile := 'to file:';
  FDownload := 'Download';
  FCancel := 'Cancel';

end;

destructor TDownloadDialog.Destroy;
begin
  http.Free;
  ftp.Free;
  Timer1.Free;

  inherited Destroy;
end;

function TDownloadDialog.Execute: boolean;
var
  urltxt, filetxt: TLabeledEdit;
  pos: TPoint;
  i: integer;
begin
  FResponse := '';
  Ffirsturl := Furl;
  DF := TForm.Create(Self);
  DF.Caption := FDownloadFile;
  DF.BorderStyle := bsDialog;
  DF.AutoSize := False;
  pos := mouse.CursorPos;
  FormPos(DF, pos.x, pos.y);
  DF.OnClose := @FormClose;

  urltxt := TLabeledEdit.Create(self);
  with urltxt do
  begin
    Parent := DF;
    Width := 400;
    Text := Furl;
    EditLabel.Caption := ' ' + FCopyfrom;
    top := Editlabel.Height + 4;
    left := 8;
    ReadOnly := True;
    color := clBtnFace;
    selstart := 1;
    sellength := 0;
  end;

  filetxt := TLabeledEdit.Create(self);
  with filetxt do
  begin
    Parent := DF;
    Width := 400;
    Text := systoutf8(Ffile);
    EditLabel.Caption := ' ' + Ftofile;
    top := Editlabel.Height + urltxt.Top + urltxt.Height + 4;
    left := 8;
    ReadOnly := True;
    color := clBtnFace;
  end;

  progress := TEdit.Create(self);
  with progress do
  begin
    Parent := DF;
    Width := 400;
    Text := '';
    top := filetxt.Top + filetxt.Height + 4;
    left := 8;
    ReadOnly := True;
    color := clBtnFace;
  end;

  okButton := TButton.Create(self);
  with okButton do
  begin
    Parent := DF;
    AutoSize := True;
    Caption := FDownload;
    onClick := @BtnDownload;
    top := progress.Top + progress.Height + 4;
    left := 8;
    Default := True;
  end;

  cancelButton := TButton.Create(self);
  with cancelButton do
  begin
    Parent := DF;
    AutoSize := True;
    Caption := FCancel;
    onClick := @BtnCancel;
    top := okButton.top;
    left := progress.Width - cancelButton.Width - 8;
    Cancel := True;
  end;

  DF.Width := urltxt.Width + 16;
  DF.Height := okButton.Top + okButton.Height + 8;

  if not FConfirmDownload then
  begin
    //  DF.OnShow:=@BtnDownload;
    DF.modalresult := mrNone;
    Timer1.Enabled := True;
    BtnDownload(nil);
    repeat
      i := DF.modalresult;
      application.ProcessMessages;
    until i <> mrNone;
    Timer1.Enabled := False;
    Result := DF.modalresult = mrOk;
  end
  else
  begin
    Result := DF.ShowModal = mrOk;
  end;

  FreeAndNil(urltxt);
  FreeAndNil(filetxt);
  FreeAndNil(progress);
  FreeAndNil(okButton);
  FreeAndNil(cancelButton);
  FreeAndNil(DF);
end;

procedure TDownloadDialog.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if FQuickCancel then
    BtnCancel(nil)
  else
    DF.ShowModal;
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
  DF.ModalResult := mrCancel;
  DF.Close;
end;

procedure TDownloadDialog.doCancel(Sender: TObject);
begin

  if not okButton.Visible then
  begin // transfert in progress
    DownloadDaemon.onProgress := nil;
    DownloadDaemon.onDownloadComplete := nil;

    if DownloadDaemon.protocol = prHttp then
    begin
      http.Sock.onStatus := nil;
      http.Sock.OnMonitor := nil;
      http.Abort;
      http.Sock.AbortSocket;
    end;

    if DownloadDaemon.protocol = prFtp then
    begin
      ftp.DSock.onStatus := nil;
      ftp.DSock.OnMonitor := nil;
      ftp.onStatus := nil;
      ftp.Abort;
      ftp.Sock.AbortSocket;
    end;

  end;

end;

procedure TDownloadDialog.StartDownload;
var
  buf, ftpdir, ftpfile: string;
  i: integer;
begin

  FResponse := '';
  if copy(Furl, 1, 4) = 'http' then
  begin        // HTTP protocol
    http.Clear;
    http.Timeout := FTimeout;
    http.Sock.SocksIP := '';
    http.ProxyHost := '';

    if FSocksproxy <> '' then
    begin
      http.Sock.SocksIP := FSocksproxy;
      if Fproxyport <> '' then
        http.Sock.SocksPort := Fproxyport;
      if FSockstype = 'Socks4' then
        http.Sock.SocksType := ST_Socks4
      else
        http.Sock.SocksType := ST_Socks5;
      if Fproxyuser <> '' then
        http.Sock.SocksUsername := Fproxyuser;
      if Fproxypass <> '' then
        http.Sock.SocksPassword := Fproxypass;
    end
    else if Fproxy <> '' then
    begin
      http.ProxyHost := Fproxy;
      if Fproxyport <> '' then
        http.ProxyPort := Fproxyport;
      if Fproxyuser <> '' then
        http.ProxyUser := Fproxyuser;
      if Fproxypass <> '' then
        http.ProxyPass := Fproxypass;
    end;

    okButton.Visible := False;

    DownloadDaemon := TDownloadDaemon.Create;
    DownloadDaemon.Phttp := @http;
    DownloadDaemon.Durl := Furl;
    DownloadDaemon.protocol := prHttp;
    DownloadDaemon.onProgress := @progressreport;
    DownloadDaemon.onDownloadComplete := @HTTPComplete;
    DownloadDaemon.Start;
  end
  else
  begin                // FTP protocol
    if copy(Furl, 1, 3) <> 'ftp' then
      exit;
    i := pos('://', Furl);
    buf := copy(Furl, i + 3, 999);
    i := pos('/', buf);
    ftp.Targethost := copy(buf, 1, i - 1);
    ftp.PassiveMode := FFWpassive;
    ftp.UserName := FUserName;
    ftp.Password := FPassword;
    ftp.FWMode := FFWMode;
    if FFWhost <> '' then
      ftp.FWHost := FFWHost;
    if FFWport <> '' then
      ftp.FWPort := FFWPort;
    if FFWUsername <> '' then
      ftp.FWUsername := FFWUsername;
    if FFWPassword <> '' then
      ftp.FWPassword := FFWPassword;
    buf := copy(buf, i, 999);
    i := LastDelimiter('/', buf);
    ftpdir := copy(buf, 1, i);
    ftpfile := copy(buf, i + 1, 999);
    ftp.DirectFile := True;
    ftp.DirectFileName := FFile;
    okButton.Visible := False;

    DownloadDaemon := TDownloadDaemon.Create;
    DownloadDaemon.Pftp := @ftp;
    DownloadDaemon.Dftpdir := ftpdir;
    DownloadDaemon.Dftpfile := ftpfile;
    DownloadDaemon.protocol := prFtp;
    DownloadDaemon.onProgress := @progressreport;
    DownloadDaemon.onDownloadComplete := @FTPComplete;
    DownloadDaemon.Start;
  end;
end;

function StripHTML(S: string): string;
var
  TagBegin, TagEnd, TagLength: integer;
begin
  TagBegin := Pos('<', S);      // search position of first <

  while (TagBegin > 0) do
  begin  // while there is a < in S
    TagEnd := Pos('>', S);              // find the matching >
    TagLength := TagEnd - TagBegin + 1;
    Delete(S, TagBegin, TagLength);     // delete the tag
    TagBegin := Pos('<', S);            // search for next <
  end;

  Result := S;                   // give the result
end;


procedure TDownloadDialog.HTTPComplete;
var
  ok: boolean;
  i: integer;
  newurl: string;
  abuf: string;
begin

  ok := DownloadDaemon.ok;

  if ok and ((http.ResultCode = 200) or (http.ResultCode = 0)) then
  begin  // success
    http.Document.Position := 0;
    http.Document.SaveToFile(FFile);

    //SZ Update exact size
    DownloadDaemon.UpdateSizeText(http.Document.Size);
    progressreport;

    FResponse := 'Finished: ' + progress.Text;
  end
  else if (http.ResultCode = 301) or (http.ResultCode = 302) or (http.ResultCode = 307) then
  begin

    for i := 0 to http.Headers.Count - 1 do
    begin
      if UpperCase(copy(http.Headers[i], 1, 9)) = 'LOCATION:' then
      begin
        newurl := trim(copy(http.Headers[i], 10, 9999));
        if (newurl = Furl) or (newurl = Ffirsturl) then
          ok := False
        else
        begin
          progress.Text := 'Redirect to: ' + newurl;
          if assigned(FDownloadFeedback) then
            FDownloadFeedback(progress.Text);
          Furl := newurl;
          StartDownload;
          exit;
        end;
      end;
    end;

    ok := False;

  end
  else if (http.ResultCode = 300) then
  begin
    ok := False;
    FResponse := 'Error 300: ';
    http.Document.Position := 0;
    SetString(abuf, http.Document.Memory, http.Document.Size);
    abuf := StripHTML(abuf);
    FResponse := FResponse + abuf;
  end
  else
  begin // error
    ok := False;
    if http.ResultCode = 0 then
      FResponse := 'Finished: ' + progress.Text + ' / Error: Timeout ' + http.ResultString
    else
      FResponse := 'Finished: ' + progress.Text + ' / Error: ' + IntToStr(
        http.ResultCode) + ' ' + http.ResultString + ' ' + http.Sock.LastErrorDesc;

    progress.Text := FResponse;
  end;

  if assigned(FDownloadFeedback) then
    FDownloadFeedback(FResponse);

  okButton.Visible := True;
  http.Clear;

  if ok then
    DF.modalresult := mrOk
  else
    DF.modalresult := mrCancel;
end;

procedure TDownloadDialog.FTPComplete;
var
  ok: boolean;
begin

  ok := DownloadDaemon.ok;
  FResponse := progress.Text;

  if ok then
  begin

    //SZ Update exact size

    if ftp.DirectFile then
      DownloadDaemon.UpdateSizeText(FileSize(ftp.DirectFileName))
    else
      DownloadDaemon.UpdateSizeText(ftp.DataStream.Size);

    progressreport;


    ftp.DSock.onStatus := nil;
    ftp.DSock.OnMonitor := nil;
    ftp.onStatus := nil;
    ftp.logout;
  end
  else
  begin
    ftp.DSock.onStatus := nil;
    ftp.DSock.OnMonitor := nil;
    ftp.onStatus := nil;
    ftp.abort;
    progress.Text := FResponse;
  end;

  okButton.Visible := True;

  if ok then
    DF.modalresult := mrOk
  else
    DF.modalresult := mrCancel;

end;

procedure TDownloadDialog.progressreport;
begin

  progress.Text := DownloadDaemon.progresstext;

  if assigned(FDownloadFeedback) then
    FDownloadFeedback(progress.Text);

end;

constructor TDownloadDaemon.Create;
begin
  ok := False;
  FreeOnTerminate := True;
  inherited Create(True);
end;


//SZ Update size  and text
procedure TDownloadDaemon.UpdateSizeText(ASize: int64);
begin
  FSockreadcount := ASize;

  progresstext := format('Read Bytes: %.0n', [1.0 * FSockreadcount]);

  if FFileSize > 0 then
    progresstext := progresstext +
      format(' of %.0n (%5.2f%%)', [1.0 * FFileSize, FSockreadcount * 100 / FFileSize]);

end;


function HTTP_FileSize(AHTTP: THTTPSend; AURL: string): int64;
{
  //SZ To get size of the file on HTTP request

  AHTTP - HTTP instance
  AURL  - URL of the file
}

var
  head: string;
  i: integer;
  Size: int64;
begin

  Size := 0;

  try

    AHTTP.Headers.Clear;
    AHTTP.Document.Clear;

    AHTTP.HTTPMethod('HEAD', AURL);
    head := AHTTP.Headers.Text;

    i := pos('content-length', LowerCase(head));

    if i > 0 then
    begin

      Inc(i, 14);

      // Skip colon and white space chars
      while i <= length(head) do
      begin

        if not (head[i] in [' ', ':', #9, #10, #13]) then
          break;

        Inc(i);

      end;

      while i <= length(head) do
      begin

        if head[i] in ['0'..'9'] then
          Size := Size * 10 + Ord(head[i]) - 48
        else
          break;

        Inc(i);

      end;

    end;

    AHTTP.Headers.Clear;
    AHTTP.Document.Clear;

  finally
  end;

  Result := Size;

end;

procedure TDownloadDaemon.Execute;
begin
  Fsockreadcount := 0;
  Fsockwritecount := 0;

  FFileSize := 0;

  if protocol = prHttp then
  begin
    phttp^.Sock.OnStatus := @SockStatus;
    phttp^.sock.OnMonitor := @SockMonitor;

    //SZ Added code to retrieve file size for download progress
    FFileSize := HTTP_FileSize(phttp^, Durl);

    FSockreadcount := 0;

    ok := phttp^.HTTPMethod('GET', Durl);

  end
  else
  if protocol = prFtp then
  begin

    pftp^.OnStatus := @FTPStatus;
    //pftp^.DSock.OnStatus:=@SockStatus;
    pftp^.DSock.OnStatus := nil;
    pftp^.Dsock.OnMonitor := @SockMonitor;

    if pftp^.Login then
    begin
      pftp^.ChangeWorkingDir(Dftpdir);

      FFileSize := pftp^.FileSize(Dftpfile);

      FSockreadcount := 0;

      ok := pftp^.RetrieveFile(Dftpfile, False);

    end;

  end;

  if Assigned(FonDownloadComplete) then
    Synchronize(FonDownloadComplete);

end;

procedure TDownloadDaemon.SockStatus(Sender: TObject; Reason: THookSocketReason;
  const Value: string);
var
  reasontxt: string;
begin

  reasontxt := '';

  case reason of
    HR_ResolvingBegin: reasontxt := 'Resolving ' + Value;
    HR_Connect: reasontxt := 'Connect ' + Value;
    HR_Accept: reasontxt := 'Accept ' + Value;
    HR_ReadCount: ; //SZ Dummy

    HR_WriteCount:
      begin
        FSockwritecount := FSockwritecount + StrToInt(Value);
        reasontxt := 'Request sent, waiting response';
      end;

    else
      reasontxt := '';
  end;

  if (reasontxt <> '') and assigned(FonProgress) then
  begin
    progresstext := reasontxt;
    synchronize(FonProgress);
  end;

end;

procedure TDownloadDaemon.SockMonitor(Sender: TObject; Writing: boolean;
  const Buffer: Pointer; Len: integer);

begin

  if not Writing then
  begin

    FSockreadcount := FSockreadcount + len;

    //SZ Update text every second

    if abs(GetTickCount - FMillis) > 1000 then
    begin
      FMillis := GetTickCount;

      // SZ Added percentage

      UpdateSizeText(FSockreadcount);

      FMillis := GetTickCount;

      if (progresstext <> '') and assigned(FonProgress) then
        synchronize(FonProgress);

    end;

  end;

end;

procedure TDownloadDaemon.FTPStatus(Sender: TObject; Response: boolean;
  const Value: string);
begin

  if response and assigned(FonProgress) then
  begin
    progresstext := Value;
    synchronize(FonProgress);
  end;

end;

initialization
  {$I downloaddialog.lrs}
end.
