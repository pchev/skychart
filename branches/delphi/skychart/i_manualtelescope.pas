
procedure Tf_manualtelescope.SetTurn(txt:string);
var i:integer;
begin
  i:=pos(tab,txt);
  if i=0 then exit;
  label1.Caption:=copy(txt,1,i-1);
  delete(txt,1,i);
  i:=pos(tab,txt);
  if i=0 then exit;
  label2.Caption:=copy(txt,1,i-1);
  delete(txt,1,i);
  i:=pos(tab,txt);
  if i=0 then exit;
  label2.Caption:=label2.Caption+' '+copy(txt,1,i-1);
  delete(txt,1,i);
  i:=pos(tab,txt);
  if i=0 then exit;
  label4.Caption:=copy(txt,1,i-1);
  delete(txt,1,i);
  i:=pos(tab,txt);
  if i=0 then exit;
  label5.Caption:=copy(txt,1,i-1);
  delete(txt,1,i);
end;

procedure Tf_manualtelescope.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
startpoint:=clienttoscreen(point(X,Y));
moving:=true;
lockmove:=false;
end;

procedure Tf_manualtelescope.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var P: Tpoint;
begin
if moving and (not lockmove) then begin
  lockmove:=true;
  P:=clienttoscreen(Point(X,Y));
  top:=top+P.Y-startpoint.Y;
  if top<0 then top:=0;
  if top>(screen.Height-Height) then top:=screen.Height-Height;
  left:=left+P.X-startpoint.X;
  if left<0 then left:=0;
  if left>(screen.Width-Width) then left:=screen.Width-Width;
  startpoint:=P;
  application.ProcessMessages;
  lockmove:=false;
end;
end;

procedure Tf_manualtelescope.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
moving:=false;
end;

procedure Tf_manualtelescope.Panel1DblClick(Sender: TObject);
begin
moving:=false;
Hide;
end;
 
