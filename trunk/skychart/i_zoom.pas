
procedure Tf_zoom.TrackBar1Change(Sender: TObject);
begin
logfov:=TrackBar1.Position;
fov:=power(10,logfov/100);
fov:=minvalue([360,fov]);
if fov>3 then fov:=round(fov);
Edit1.text:=DeMtoStr(fov);
end;

procedure Tf_zoom.FormShow(Sender: TObject);
begin
logfov:=100*log10(fov);
TrackBar1.Position := Round(logfov);
Edit1.text:=DeMtoStr(fov);
{$ifdef mswindows}
TrackBar1.SetTick(-78);
TrackBar1.SetTick(0);
TrackBar1.SetTick(100);
TrackBar1.SetTick(200);
{$endif}
end;

