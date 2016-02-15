unit detail1;

{$MODE Delphi}

{
Copyright (C) 2008 Patrick Chevalley

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

interface

uses Clipbrd, Printers, FileCtrl, UScaleDPI,
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, StdCtrls, Buttons, Menus, ExtDlgs, LResources, u_param,
  downloaddialog, cu_voreader, u_util2;

type

  { TDetailForm }

  TDetailForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    DownloadDialog1: TDownloadDialog;
    Edit1: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel2: TPanel;
    ColorDialog1: TColorDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Panel3: TPanel;
    SaveasBMP1: TMenuItem;
    SaveDialog1: TSaveDialog;
    GetQuickLook: TMenuItem;
    Shape1: TShape;
    Shape10: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    RefreshTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape8MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape9MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape10MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox3Click(Sender: TObject);
    procedure SaveasBMP1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure GetQuickLookClick(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetOnlineButtons;
  public
    { Public declarations }
  end;

Type Tfileformat = (fixed,token,voxml);

var
  DetailForm: TDetailForm;
  mx,my,xmin,ymin,xmax,ymax,current,vartyp : integer;
  m1,m2,m3,t1,t2,t3,t4,t5,t10,t11,Ax,Ay,per,ris : double;
  Bx,By,Xp,Yp : integer;
  magact,visualcomment,starname,stardesign,qlfn,qldir,vsfn,vsdir,vsname,afoevdir,afoevname,afoevfn : string;
  tokensep, saveobs:string;
  savecheckbox1,skipsavebox1,movecursor : boolean;
  jdpos,magpos,nampos,obspos,codpos : array[1..2] of integer;
  dateformat : integer;
  fileformat : Tfileformat;
  initialized : boolean =false;
  voreader:TVO_Reader;
  vorow: TStringList;

implementation
{$R *.lfm}

Uses variables1,SettingUnit;

const AllChar='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      AllNum='0123456789';
      nonvisual=' CCD CCDB CCDI CCDO CCDR PTG ';


function  Rmod(x,y:Double):Double;
BEGIN
    Rmod := x - Int(x/y) * y ;
END  ;

Function VSNETname(buf : string):string;
var nam,con : string;
    p,i : integer;
begin
buf := trim(buf);
p:=pos(' ',buf);
if p>0 then begin
   nam:=trim(copy(buf,1,p));
   if (uppercase(copy(nam,1,1))='V')and IsNumber(copy(nam,2,99)) then begin
      nam:='V'+inttostr(strtoint(copy(nam,2,99)));
   end;
   for i:=1 to 24 do if nam=greek[2,i] then nam:=greek[1,i];
   con:=uppercase(trim(copy(buf,p+1,99)));
   if pos(con,uppercase(abrcons))>0 then result:=uppercase(con+nam)
                                    else result:=uppercase(nam+con);
   end
   else result:=uppercase(buf);
end;

Procedure AFOEVnam(buf : string; var con,nam : string);
var p : integer;
begin
buf := trim(buf);    // star name
p:=pos(' ',buf);
if p>0 then begin
   nam:=lowercase(trim(copy(buf,1,p)));
   if (copy(nam,1,1)='v')and IsNumber(copy(nam,2,99)) then begin
      nam:='v'+inttostr(strtoint(copy(nam,2,99)));
   end;
   con:=lowercase(trim(copy(buf,p+1,99)));
   end
else begin
  con:='UNK';
  nam:=buf;
end;
end;

Procedure InitGraph;
var dx : integer;
begin
mx:=60;
with DetailForm.Image1.ClientRect do begin
  xmin := left; xmax := right;
  ymin := top; ymax := bottom;
end;
DetailForm.Image1.Picture.Bitmap.Width:=DetailForm.Image1.Width;
DetailForm.Image1.Picture.Bitmap.Height:=DetailForm.Image1.Height;
Ax:=(xmax-xmin-2*mx)/(t5-t1);
Bx:=xmin+mx;
Ay:=(ymax-ymin-2*my)/(m2-m1);
By:=ymin+my;
with DetailForm.Image1.Picture.Bitmap.Canvas do begin
  Brush.style:=bsSolid;
  Pen.mode := pmCopy;
  Pen.Width := 3;
  Pen.Color := DetailForm.Shape1.brush.color;     // Background
  Brush.Color := DetailForm.Shape1.brush.color;
  Rectangle(xmin,ymin,xmax,ymax);
  font.color:=DetailForm.Shape2.brush.color;
  dx:=trunc((xmax-xmin)/5);
  textout(xmin+20,ymax-20,datef(t1));
  textout(xmin+20+dx,ymax-20,datef(t2));
  textout(xmin+20+2*dx,ymax-20,datef(t3));
  textout(xmin+20+3*dx,ymax-20,datef(t4));
  textout(xmin+20+4*dx,ymax-20,datef(t5));
  textout(xmin+20,ymin+20,detailform.edit1.text);
end;
movecursor:=false;
end;

Procedure FillBox(varstar : integer);
var buf : string;
    varinfo : Tvarinfo;
begin
varinfo:=Tvarinfo(varform.Grid1.Objects[0,varstar]);
m1:=varinfo.i[1];
m2:=varinfo.i[2];
m3:=varinfo.i[3];
per:=varinfo.i[9];
ris:=per*varinfo.i[10]/100;
vartyp:=round(varinfo.i[11]);
with detailform do begin
 starname:=trim(varform.Grid1.Cells[0,varstar]);
 stardesign:=trim(varform.Grid1.Cells[1,varstar]);
 edit1.text:=starname+' '+stardesign;
 edit2.text:=varform.Grid1.Cells[2,varstar];
 edit3.text:=varform.Grid1.Cells[3,varstar];
 edit4.text:=varform.Grid1.Cells[4,varstar];
 magact:=trim(varform.Grid1.Cells[5,varstar]);
 str(varinfo.i[9]:4:4,buf);
 edit5.text:=buf;
 if frac(varinfo.i[10])>0 then str(varinfo.i[10]:4:2,buf)
                          else str(varinfo.i[10]:2:0,buf);
 edit6.text:=buf+'%';
 edit12.text:=datact;
 edit13.text:=magact;
 Caption:='Schematic light curve for '+edit1.text;
 if varinfo.i[11]=0 then begin
    skipsavebox1:=true;
    Detailform.checkbox1.checked:=false;
    Detailform.checkbox1.enabled:=false;
 end else begin
    Detailform.checkbox1.checked:=savecheckbox1;
    Detailform.checkbox1.enabled:=true;
 end;
 skipsavebox1:=false;
end;
end;

Procedure DrawAxis(varstar:integer);
begin
with DetailForm.Image1.Picture.Bitmap.Canvas do begin
  Pen.mode := pmCopy;
  Pen.Width:=1;
  Pen.Color:=DetailForm.Shape2.brush.color;     // Axis
  Font.color:=DetailForm.Shape2.brush.color;
  moveto(xmin+mx,ymax-my);
  lineto(xmax-mx,ymax-my);
  moveto(xmin+mx,ymax-my);
  lineto(xmin+mx,ymin+my);
  textout(xmin+5,ymax-my-5,varform.Grid1.Cells[4,varstar]);
  textout(xmin+5,ymin+my-5,varform.Grid1.Cells[3,varstar]);
  moveto(round(Bx),ymax-my);
  lineto(round(Bx),ymax-my+8);
  moveto(round(Ax*(t2-t1)+Bx),ymax-my);
  lineto(round(Ax*(t2-t1)+Bx),ymax-my+8);
  moveto(round(Ax*(t3-t1)+Bx),ymax-my);
  lineto(round(Ax*(t3-t1)+Bx),ymax-my+8);
  moveto(round(Ax*(t4-t1)+Bx),ymax-my);
  lineto(round(Ax*(t4-t1)+Bx),ymax-my+8);
  moveto(round(Ax*(t5-t1)+Bx),ymax-my);
  lineto(round(Ax*(t5-t1)+Bx),ymax-my+8);
end;
end;

Procedure DrawPulsCurve(varstar:integer);
begin
with DetailForm.Image1.Picture.Bitmap.Canvas do begin
  Pen.Color:=DetailForm.Shape4.brush.color;      // Light Curve
  moveto(xmin+mx,ymax-my);
  lineto(round(Ax*(t2-t1)+Bx),round(Ay*(m1-m1)+By));
  lineto(round(Ax*(t3-t1)+Bx),round(Ay*(m2-m1)+By));
  lineto(round(Ax*(t4-t1)+Bx),round(Ay*(m1-m1)+By));
  lineto(round(Ax*(t5-t1)+Bx),round(Ay*(m2-m1)+By));
  Pen.Color:=DetailForm.Shape3.brush.color;      // Actual date
  textout(round(Ax*(jdact-t1)+Bx-30),round(Ay*(m2-m1)+By+10),datact);
  moveto(round(Ax*(jdact-t1)+Bx),round(Ay*(m2-m1)+By));
  lineto(round(Ax*(jdact-t1)+Bx),round(Ay*(m1-m1)+By));
  textout(xmin+35,round(Ay*(m3-m1)+By-5),magact);
  moveto(Bx,round(Ay*(m3-m1)+By));
  lineto(round(Ax*(t5-t1)+Bx),round(Ay*(m3-m1)+By));
end;
end;

Procedure DrawEcliCurve(varstar:integer);
begin
with DetailForm.Image1.Picture.Bitmap.Canvas do begin
  Pen.Color:=DetailForm.Shape4.brush.color;    // Light Curve
  moveto(xmin+mx,ymax-my);
  lineto(round(Ax*(t10-t1)+Bx),round(Ay*(m1-m1)+By));
  lineto(round(Ax*(t2-t1)+Bx),round(Ay*(m1-m1)+By));
  lineto(round(Ax*(t3-t1)+Bx),round(Ay*(m2-m1)+By));
  lineto(round(Ax*(t4-t1)+Bx),round(Ay*(m1-m1)+By));
  lineto(round(Ax*(t11-t1)+Bx),round(Ay*(m1-m1)+By));
  lineto(round(Ax*(t5-t1)+Bx),round(Ay*(m2-m1)+By));
  moveto(round(Ax*((t2-t10)/2+t10-t1)+Bx),round(Ay*(m1-m1)+By+5));
  lineto(round(Ax*((t2-t10)/2+t10-t1)+Bx),round(Ay*(m1-m1)+By));
  moveto(round(Ax*((t11-t4)/2+t4-t1)+Bx),round(Ay*(m1-m1)+By+5));
  lineto(round(Ax*((t11-t4)/2+t4-t1)+Bx),round(Ay*(m1-m1)+By));
  Pen.Color:=DetailForm.Shape3.brush.color;      // Actual date
  textout(round(Ax*(jdact-t1)+Bx-30),round(Ay*(m2-m1)+By+10),datact);
  moveto(round(Ax*(jdact-t1)+Bx),round(Ay*(m2-m1)+By));
  lineto(round(Ax*(jdact-t1)+Bx),round(Ay*(m1-m1)+By));
  textout(xmin+35,round(Ay*(m3-m1)+By-5),magact);
  moveto(Bx,round(Ay*(m3-m1)+By));
  lineto(round(Ax*(t5-t1)+Bx),round(Ay*(m3-m1)+By));
end;
end;

Procedure OpenAFOEV(var f:textfile; var sname : string; var ok : boolean);
var nam,con,dir,fn,buf : string;
    p : integer;
begin
ok:=false;
buf := trim(starname);    // star name
p:=pos(' ',buf);
if p>0 then begin
   nam:=uppercase(trim(copy(buf,1,p)));
   if (copy(nam,1,1)='V')and IsNumber(copy(nam,2,99)) then begin
      nam:='V'+inttostr(strtoint(copy(nam,2,99)));
   end;
   con:=uppercase(trim(copy(buf,p+1,99)));
   fn:=nam;
   dir:=con;
   end
   else exit;
fn:=slash(OptForm.DirectoryEdit3.Text)+slash(dir)+fn;
if fileexists(fn) then begin
   filemode:=0;
   assignfile(f,fn);
   reset(f);
   sname:='';             // no name in file
   nampos[1]:=0;
   nampos[2]:=0;
   jdpos[1]:=4;
   jdpos[2]:=10;
   magpos[1]:=15;
   magpos[2]:=5;
   codpos[1]:=14;
   codpos[2]:=1;
   obspos[1]:=1;
   obspos[2]:=3;
   dateformat:=1;
   Fileformat:=fixed;
   visualcomment:=' AHN';
   ok:=true;
end;
end;

Procedure OpenAAVSOVIS(var f:textfile;var sname : string; var ok : boolean);
var nam,con,fn,buf : string;
    p : integer;
begin
ok:=false;
buf := trim(starname);      // star name
p:=pos(' ',buf);
 if p>0 then begin                        // remove extra space in name
   nam:=uppercase(trim(copy(buf,1,p)));
   if (copy(nam,1,1)='V')and IsNumber(copy(nam,2,99)) then begin
      nam:='V'+inttostr(strtoint(copy(nam,2,99)));
   end;
   con:=uppercase(trim(copy(buf,p+1,99)));
   sname:=nam+' '+con;
   end
   else sname:=uppercase(buf);
fn:=OptForm.FilenameEdit0.Text;
if fileexists(fn) then begin
   filemode:=0;
   assignfile(f,fn);
   reset(f);
   nampos[1]:=1;
   nampos[2]:=0;
   jdpos[1]:=2;
   jdpos[2]:=0;
   magpos[1]:=3;
   magpos[2]:=0;
   obspos[1]:=0;
   obspos[2]:=0;
   codpos[1]:=4;
   codpos[2]:=0;
   dateformat:=1;
   Fileformat:=token;
   tokensep:=',';
   visualcomment:=' Vis';
   saveobs:='';
   ok:=true;
end;
end;

Procedure OpenAAVSOSUM(var f:textfile;var sname : string; var ok : boolean);
var nam,con,fn,buf : string;
    p : integer;
begin
ok:=false;
buf := trim(starname);      // star name
p:=pos(' ',buf);
if p>0 then begin                        // remove extra space in name
   nam:=uppercase(trim(copy(buf,1,p)));
   if (copy(nam,1,1)='V')and IsNumber(copy(nam,2,99)) then begin
      nam:='V'+inttostr(strtoint(copy(nam,2,99)));
   end;
   con:=uppercase(trim(copy(buf,p+1,99)));
   sname:=nam+' '+con;
   end
   else sname:=uppercase(buf);
fn:=OptForm.FilenameEdit1.Text;
if fileexists(fn) then begin
   filemode:=0;
   assignfile(f,fn);
   reset(f);
   nampos[1]:=9;
   nampos[2]:=10;
   jdpos[1]:=19;
   jdpos[2]:=12;
   magpos[1]:=31;
   magpos[2]:=6;
   codpos[1]:=37;
   codpos[2]:=7;
   obspos[1]:=63;
   obspos[2]:=5;
   dateformat:=1;
   Fileformat:=fixed;
   visualcomment:=' '+AllChar;
   ok:=true;
end;
end;

Procedure OpenQuickLook(var f:textfile;var sname : string; var ok : boolean);
var fn : string;
    i:integer;
const
    colfilter=' name jd magnitude observer band ';
begin
ok:=false;
sname:='*';
fn:=qlfn;
if fileexists(fn) then begin
  voreader:=TVO_Reader.Create(nil);
  vorow:=TStringList.Create;
  ok:=voreader.OpenVO(fn);
  for i:=0 to voreader.fieldname.Count-1 do begin
   if pos(' '+voreader.fieldname[i]+' ',colfilter)=0 then voreader.UseField[i]:=false;
  end;
  dateformat:=1;
  Fileformat:=voxml;
  visualcomment:=' Vis.';
end;
end;


Procedure OpenVSNET(var f:textfile; var sname : string; var ok : boolean);
var fn : string;
begin
ok:=false;
sname:=vsnetname(starname);
fn:=OptForm.FilenameEdit2.Text;
if fileexists(fn) then begin
   filemode:=0;
   assignfile(f,fn);
   reset(f);
   nampos[1]:=1;
   nampos[2]:=0;
   jdpos[1]:=2;
   jdpos[2]:=0;
   magpos[1]:=3;
   magpos[2]:=0;
   obspos[1]:=4;
   obspos[2]:=0;
   codpos[1]:=5;
   codpos[2]:=0;
   dateformat:=2;
   Fileformat:=token;
   tokensep:=' ';
   visualcomment:=' Vv';
   ok:=true;
end;
end;

Procedure OpenAFOEVftp(var f:textfile; var sname : string; var ok : boolean);
var fn : string;
begin
ok:=false;
sname:=afoevname;
fn:=afoevfn;
if fileexists(fn) then begin
   filemode:=0;
   assignfile(f,fn);
   reset(f);
   sname:='';             // no name in file
   nampos[1]:=0;
   nampos[2]:=0;
   jdpos[1]:=4;
   jdpos[2]:=10;
   magpos[1]:=15;
   magpos[2]:=5;
   codpos[1]:=14;
   codpos[2]:=1;
   obspos[1]:=1;
   obspos[2]:=3;
   dateformat:=1;
   Fileformat:=fixed;
   visualcomment:=' AHN';
   ok:=true;
end;
end;

Procedure OpenFreeFile(var f:textfile; var sname : string; var ok : boolean);
var nam,con,fn,buf : string;
    p : integer;
begin
ok:=false;
buf := trim(starname);      // star name
p:=pos(' ',buf);
if p>0 then begin                        // remove extra space in name
   nam:=uppercase(trim(copy(buf,1,p)));
   if (copy(nam,1,1)='V')and IsNumber(copy(nam,2,99)) then begin
      nam:='V'+inttostr(strtoint(copy(nam,2,99)));
   end;
   con:=uppercase(trim(copy(buf,p+1,99)));
   sname:=nam+' '+con;
   end
   else sname:=uppercase(buf);
fn:=OptForm.FilenameEdit4.Text;
if fileexists(fn) then begin
   filemode:=0;
   assignfile(f,fn);
   reset(f);
   case OptForm.RadioGroup3.ItemIndex of
   0 : begin                              // variable format
       nampos[1]:=strtointdef(Optform.edit1.text,1);
       nampos[2]:=0;
       jdpos[1]:=strtointdef(Optform.edit2.text,2);
       jdpos[2]:=0;
       magpos[1]:=strtointdef(Optform.edit3.text,3);
       magpos[2]:=0;
       obspos[1]:=0;
       obspos[2]:=0;
       codpos[1]:=0;
       codpos[2]:=0;
       dateformat:=OptForm.RadioGroup2.ItemIndex+1;
       Fileformat:=token;
       tokensep:=' ';
       end;
   1 : begin                              // fixed format
       buf:=Optform.edit1.text;
       p:=pos('.',buf);
       nampos[1]:=strtointdef(copy(buf,1,p-1),1);
       nampos[2]:=strtointdef(copy(buf,p+1,99),2)-nampos[1]+1;
       buf:=Optform.edit2.text;
       p:=pos('.',buf);
       jdpos[1]:=strtointdef(copy(buf,1,p-1),1);
       jdpos[2]:=strtointdef(copy(buf,p+1,99),2)-jdpos[1]+1;
       buf:=Optform.edit3.text;
       p:=pos('.',buf);
       magpos[1]:=strtointdef(copy(buf,1,p-1),1);
       magpos[2]:=strtointdef(copy(buf,p+1,99),2)-magpos[1]+1;
       obspos[1]:=0;
       obspos[2]:=0;
       codpos[1]:=0;
       codpos[2]:=0;
       dateformat:=OptForm.RadioGroup2.ItemIndex+1;
       Fileformat:=fixed;
       end;
   end;
   visualcomment:=' '+AllChar;
   ok:=true;
end;
end;

Procedure CloseObs(var f : textfile);
begin
case fileformat of
  fixed : closefile(f);
  token : closefile(f);
  voxml : begin
          voreader.CloseVO;
          voreader.Free;
          vorow.Free;
          end;
end;
end;

Procedure ReadObs(var f : textfile; sname : string; var jdt,ma : double; var um : char;var sm,obsname : string; var feof,ok : boolean);
var buf,lin,tmpbuf : string;
    p,n : integer;
    c : char;
const magnum='01234567989.:<?';
begin
ok:=false;
try
case fileformat of
voxml : begin
      if voreader.ReadVORow(vorow) then begin
        feof:=voreader.EOF;
        buf:=stringreplace(trim(vorow[1]),',','.',[]);
        case dateformat of
        1 : begin                                    // JD
            p:=pos('.',buf)-1;
            if p=-1 then p:=length(buf);
            if p=5 then buf:='24'+buf;
            jdt:=strtofloat(buf);
            end;
        end;
        buf:=stringreplace(trim(vorow[2]),',','.',[]);    // mag.
        buf:=stringreplace(buf,'&lt;','<',[]);
        if buf='' then exit;
        um:=' ';
        p:=pos('<',buf);                             // fainter-than
        if p>0 then begin
           um:='<';
           buf:=copy(buf,1,p-1)+copy(buf,p+1,99);
        end;
        val(buf,ma,n);
        if n<>0 then ma:=0;

        obsname:=vorow[3]; // observer

        sm:=vorow[4];  // band
        if sm='' then sm:=' ';
        ok:=true;
      end;
      feof:=voreader.EOF;
      end;
fixed : begin
      readln(f,lin);
      feof:=eof(f);
      buf:=uppercase(trim(copy(lin,nampos[1],nampos[2])));    // name
      if (sname<>'*') and (buf<>sname) then exit;
      buf:=trim(copy(lin,jdpos[1],jdpos[2]));      // date
      if buf='' then exit;
      buf:=RemoveLastDot(buf);
      case dateformat of
      1 : begin                                    // JD
          p:=pos('.',buf)-1;
          if p=-1 then p:=length(buf);
          if p=5 then buf:='24'+buf;
          jdt:=strtofloat(buf);
          end;
      2 : begin                                    // decimal UT
          p:=pos('.',buf)-1;
          if p=-1 then p:=length(buf);
          if p=6 then buf:='19'+buf;               // ??? Y2K
          jdt:=jd(strtoint(copy(buf,1,4)),strtoint(copy(buf,5,2)),strtoint(copy(buf,7,2)),strtofloat(copy(buf,9,99))*24);
          end;
      end;
      buf:=trim(copy(lin,magpos[1],magpos[2]));    // mag.
      if buf='' then exit;
      um:=' ';
      p:=pos(':',buf);                             // uncertain
      if p>0 then begin
         um:=':';
         buf:=copy(buf,1,p-1)+copy(buf,p+1,99);
      end;
      p:=pos('<',buf);                             // fainter-than
      if p>0 then begin
         um:='<';
         buf:=copy(buf,1,p-1)+copy(buf,p+1,99);
      end;
      p:=pos('?',buf);                             // very uncertain
      if p>0 then begin
         um:='?';
         buf:=copy(buf,1,p-1)+copy(buf,p+1,99);
      end;
      val(buf,ma,n);
      if n<>0 then ma:=0;
      p:=pos('.',buf);
      if p=0 then ma:=ma/10;                       // max in tenth

      if (codpos[1]>0)and(codpos[2]>0) then sm:=trim(copy(lin,codpos[1],codpos[2]))  // comment
                  else sm:=' ';
      if sm='' then sm:=' ';
      obsname:=trim(copy(lin,obspos[1],obspos[2]));
      ok:=true;
      end;
token : begin
      readln(f,lin);
      feof:=eof(f);
      if (tokensep=',')and(copy(lin,1,9)='#OBSCODE=') then saveobs:=trim(copy(lin,10,99));
      if copy(lin,1,1)='#' then exit; //comments
      buf:=uppercase(trim(words(lin,'',nampos[1],1,tokensep)));        // name
      if (sname<>'*') and (buf<>sname) then exit;
      buf:=trim(words(lin,'',jdpos[1],1,tokensep));         // date
      if buf='' then exit;
      case dateformat of
      1 : begin                                    // JD
          p:=pos('.',buf)-1;
          if p=-1 then p:=length(buf);
          if p=5 then buf:='24'+buf;
          jdt:=strtofloat(buf);
          end;
      2 : begin                                    // decimal UT
          p:=pos('.',buf)-1;
          if p=-1 then p:=length(buf);
          if p=6 then buf:='19'+buf;               // ??? Y2K
          jdt:=jd(strtoint(copy(buf,1,4)),strtoint(copy(buf,5,2)),strtoint(copy(buf,7,2)),strtofloat(copy(buf,9,99))*24);
          end;
      end;
      tmpbuf:=trim(words(lin,'',magpos[1],1,tokensep));        // mag.
      if tmpbuf='' then exit;
      sm:=' '; buf:='';
      for p:=1 to length(tmpbuf) do begin
        c:=tmpbuf[p];
        if pos(c,magnum)=0 then begin if sm=' ' then sm:=c end
        else buf:=buf+c;
      end;
      um:=' ';
      p:=pos(':',buf);                             // uncertain
      if p>0 then begin
         um:=':';
         buf:=copy(buf,1,p-1)+copy(buf,p+1,99);
      end;
      p:=pos('<',buf);                             // fainter-than
      if p>0 then begin
         um:='<';
         buf:=copy(buf,1,p-1)+copy(buf,p+1,99);
      end;
      p:=pos('?',buf);                             // very uncertain
      if p>0 then begin
         um:='?';
         buf:=copy(buf,1,p-1)+copy(buf,p+1,99);
      end;
      ma:=strtofloat(buf);
      p:=pos('.',buf);
      if p=0 then ma:=ma/10;                       // max in tenth
      if codpos[1]>0 then begin                       // comment
          sm:=trim(words(lin,'',codpos[1],1,tokensep))+' ';
      end else sm:=' ';
      if (tokensep=',') then obsname:=saveobs
          else obsname:=trim(words(lin,'',obspos[1],1,tokensep));
      ok:=true;
      end;
end;
except
ok:=false;
//showmessage('Invalid data : '+lin);
end;
end;

Procedure DrawObservation(typeobs : integer);
var f : textfile;
    sname,obsname,sm,buf : string;
    x,y,i : integer;
    jdt,ma,jd0 : double;
    um : char;
    ok,feof,visualobs : boolean;
begin
case typeobs of
0 : OpenAAVSOVIS(f,sname,ok);
1 : OpenAAVSOSUM(f,sname,ok);
2 : OpenVSNET(f,sname,ok);
3 : OpenAFOEV(f,sname,ok);
4 : OpenFreeFile(f,sname,ok);
97: OpenAFOEVftp(f,sname,ok);
98: OpenQuickLook(f,sname,ok);
end;
if not ok then exit;
with DetailForm.Image1.Picture.Bitmap.Canvas do begin
   Pen.mode := pmCopy;
   Pen.Width:=1;
   try
   jd0:=rmod(t1,per);
   repeat
      readobs(f,sname,jdt,ma,um,sm,obsname,feof,ok);
      if not ok then continue;
      if detailform.checkbox5.checked then jdt:=rmod(jdt-jd0,per)+t1;
      if (jdt>t1)and(jdt<t5) then begin
         Pen.Color:=DetailForm.Shape6.brush.color;
         Brush.Color:=DetailForm.Shape6.brush.color;
         case um of
         ' ' : begin Pen.Color:=DetailForm.Shape6.brush.color; Brush.Color:=DetailForm.Shape6.brush.color; end;
         ':' : begin Pen.Color:=DetailForm.Shape9.brush.color; Brush.Color:=DetailForm.Shape9.brush.color; end;
         '?' : begin Pen.Color:=DetailForm.Shape9.brush.color; Brush.Color:=DetailForm.Shape9.brush.color; end;
         '<' : begin Pen.Color:=DetailForm.Shape8.brush.color; Brush.Color:=DetailForm.Shape8.brush.color; end;
         end;
         if length(sm)<=1 then visualobs := (pos(sm,visualcomment)>0)
         else begin
            i:=1;
            visualobs:=true;
            repeat
              buf:=' '+trim(words(sm,'',i,1))+' ';
              visualobs := visualobs and (pos(buf,nonvisual)=0);
              inc(i);
            until buf='  ';
         end;
         if not visualobs then begin Pen.Color:=DetailForm.Shape10.brush.color; Brush.Color:=DetailForm.Shape10.brush.color;end;
         x:=round(Ax*(jdt-t1)+Bx);
         y:=round(Ay*(ma-m1)+By);
         if y<1 then begin
            y:=2;
            Pen.Color:=DetailForm.Shape5.brush.color;
            Brush.Color:=DetailForm.Shape5.brush.color;
         end;
         if y>ymax-1 then begin
            y:=ymax-2;
            Pen.Color:=DetailForm.Shape5.brush.color;
            Brush.Color:=DetailForm.Shape5.brush.color;
         end;
         if detailform.checkbox3.checked
            and(obsname=trim(OptForm.edit4.text))
            and(obsname<>'') then begin
               Pen.Color:=DetailForm.Shape7.brush.color;
               Brush.Color:=DetailForm.Shape7.brush.color;
         end;
         rectangle(x-2,y-2,x+2,y+2);
      end;
   until feof;
   finally
   CloseObs(f);
   end;
end;
end;

Procedure PlotObservation;
begin
// quicklook
case OptForm.radiogroup6.ItemIndex of
0 : begin
  qldir:=slash(privatedir)+slash('quicklook');
  qlfn:=qldir+uppercase(trim(starname))+'.xml';
  if detailform.checkbox4.checked and fileexists(qlfn) then begin
     DrawObservation(98);
  end;
  end;
1 : begin
  AFOEVnam(starname,afoevdir,afoevname);
  afoevfn:=slash(privatedir)+slash('afoevdata')+slash(afoevdir)+afoevname;
  if detailform.checkbox4.checked and fileexists(afoevfn) then begin
     DrawObservation(97);
  end;
  end;
end;
// own observation file
if detailform.checkbox2.checked then DrawObservation(OptForm.RadioGroup1.ItemIndex);
end;

Procedure DrawGraph(varstar : integer);
begin
try
FillBox(varstar);
InitGraph;
DrawAxis(varstar);
case vartyp of
1 : DrawPulsCurve(varstar);
2 : DrawEcliCurve(varstar);
end;
if DetailForm.checkbox2.checked or DetailForm.checkbox4.checked then PlotObservation;
finally
end;
end;

procedure TDetailForm.FormShow(Sender: TObject);
var varinfo : Tvarinfo;
begin
my:=50;
varinfo:=Tvarinfo(varform.Grid1.Objects[0,current]);
initialized:=true;
t1:=varinfo.i[4];
t2:=varinfo.i[5];
t3:=varinfo.i[6];
t4:=varinfo.i[7];
t5:=varinfo.i[8];
t10:=varinfo.i[12];
t11:=varinfo.i[13];
SetOnlineButtons;
//force a resize event
width:=width+1;
width:=width-1;
end;

procedure TDetailForm.FormResize(Sender: TObject);
begin
 if started then RefreshTimer.Enabled:=true;
end;

procedure TDetailForm.FormCreate(Sender: TObject);
begin
   ScaleDPI(Self);
end;

procedure TDetailForm.SetOnlineButtons;
begin
case Optform.RadioGroup6.ItemIndex of
0 : begin
    GetQuickLook.caption:='Get online AAVSO QuickLook data';
    Bitbtn5.caption:='Get QuickLook';
    CheckBox4.Caption:='Plot QuickLook';
    MenuItem2.Checked:=true;
    MenuItem3.Checked:=false;
    end;
1 : begin
    GetQuickLook.caption:='Get online AFOEV data';
    Bitbtn5.caption:='Get AFOEV data';
    CheckBox4.Caption:='Plot AFOEV data';
    MenuItem2.Checked:=false;
    MenuItem3.Checked:=true;
    end;
end;
end;

procedure TDetailForm.MenuItem2Click(Sender: TObject);
begin
Optform.RadioGroup6.ItemIndex:=0;
SetOnlineButtons;
if started then DrawGraph(current);
end;

procedure TDetailForm.MenuItem3Click(Sender: TObject);
begin
Optform.RadioGroup6.ItemIndex:=1;
SetOnlineButtons;
if started then DrawGraph(current);
end;

procedure TDetailForm.RefreshTimerTimer(Sender: TObject);
begin
RefreshTimer.Enabled:=false;
if started then DrawGraph(current);
end;


Procedure InitCursor(X,Y :integer);
var jdt,ma : double;
    buf : string;
begin
with DetailForm.Image1.Canvas do begin
  Pen.color:=clWhite;
  Pen.mode:=pmXor;
  jdt:=(X-Bx)/Ax + t1;
  if DetailForm.checkbox1.checked then begin
     ma:=0;
     case vartyp of
     1 : begin
         if jdt<t2 then ma:=m2-(jdt-t1)*(m2-m1)/ris
         else if jdt<t3 then ma:=m1+(jdt-t2)*(m2-m1)/(per-ris)
         else if jdt<t4 then ma:=m2-(jdt-t3)*(m2-m1)/ris
         else {if jdt<t5 then} ma:=m1+(jdt-t4)*(m2-m1)/(per-ris);
         end;
     2 : begin
         if (jdt<t10) then ma:=m2-(jdt-t1)*(m2-m1)/ris*2
         else if (jdt<t2) then ma:=m1
         else if (jdt<t3) then ma:=m1+(jdt-t2)*(m2-m1)/ris*2
         else if (jdt<t4) then ma:=m2-(jdt-t3)*(m2-m1)/ris*2
         else if (jdt<t11) then ma:=m1
         else ma:=m1+(jdt-t11)*(m2-m1)/ris*2;
         end;
     end;
     Yp:=round(Ay*(ma-m1)+By);
     Xp:=X;
  end else begin
     Xp:=X;
     Yp:=Y;
     ma:=(Yp-By)/Ay + m1;
  end;
  movecursor:=true;
  moveto(Xp,ymax);
  lineto(Xp,0);
  moveto(Xp-5,Yp);
  lineto(Xp+5,Yp);
  DetailForm.edit12.text:=datef(jdt);
  str(ma:4:1,buf);
  DetailForm.edit13.text:=buf;
  screen.cursor:=crNone;
end;
end;

Procedure CloseCursor(X,Y : integer);
begin
with DetailForm.Image1.Canvas do begin
  screen.cursor:=crDefault;
  Pen.color:=clWhite;
  Pen.mode:=pmXor;
  moveto(Xp,ymax);
  lineto(Xp,0);
  moveto(Xp-5,Yp);
  lineto(Xp+5,Yp);
  movecursor:=false;
  DetailForm.edit12.text:=datact;
  DetailForm.edit13.text:=magact;
end;
end;

procedure TDetailForm.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var jdt,ma : double;
    buf : string;
begin
if movecursor and (shift=[ssLeft])and(X>Bx)and(X<(xmax-mx)) then with DetailForm.Image1.Canvas do begin
  Pen.color:=clWhite;
  Pen.mode:=pmXor;
  moveto(Xp,ymax);
  lineto(Xp,0);
  moveto(Xp-5,Yp);
  lineto(Xp+5,Yp);
  jdt:=(X-Bx)/Ax + t1;
  if checkbox1.checked then begin
     ma:=0;
     case vartyp of
     1 : begin
         if jdt<t2 then ma:=m2-(jdt-t1)*(m2-m1)/ris
         else if jdt<t3 then ma:=m1+(jdt-t2)*(m2-m1)/(per-ris)
         else if jdt<t4 then ma:=m2-(jdt-t3)*(m2-m1)/ris
         else {if jdt<t5 then} ma:=m1+(jdt-t4)*(m2-m1)/(per-ris);
         end;
     2 : begin
         if (jdt<t10) then ma:=m2-(jdt-t1)*(m2-m1)/ris*2
         else if (jdt<t2) then ma:=m1
         else if (jdt<t3) then ma:=m1+(jdt-t2)*(m2-m1)/ris*2
         else if (jdt<t4) then ma:=m2-(jdt-t3)*(m2-m1)/ris*2
         else if (jdt<t11) then ma:=m1
         else ma:=m1+(jdt-t11)*(m2-m1)/ris*2;
         end;
     end;
     Yp:=round(Ay*(ma-m1)+By);
     Xp:=X;
  end else begin
     Xp:=X;
     Yp:=Y;
     ma:=(Yp-By)/Ay + m1;
  end;
  moveto(Xp,ymax);
  lineto(Xp,0);
  moveto(Xp-5,Yp);
  lineto(Xp+5,Yp);
  edit12.text:=datef(jdt);
  str(ma:4:1,buf);
  edit13.text:=buf;
end;
if movecursor and((X<=Bx)or(X>=(xmax-mx))) then CloseCursor(X,Y);
if (not movecursor) and (shift=[ssLeft])and(X>Bx)and(X<(xmax-mx)) then InitCursor(X,Y);
end;

procedure TDetailForm.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if (shift=[ssLeft])and(X>Bx)and(X<(xmax-mx)) then InitCursor(X,Y);
end;

procedure TDetailForm.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if movecursor and(X>Bx)and(X<(xmax-mx)) then CloseCursor(X,Y);
end;

procedure TDetailForm.CheckBox2Click(Sender: TObject);
begin
if started then DrawGraph(current);
end;

procedure TDetailForm.CheckBox1Click(Sender: TObject);
begin
if skipsavebox1 then begin skipsavebox1:=false; exit ;end;
savecheckbox1:=checkbox1.checked;
end;

procedure TDetailForm.BitBtn2Click(Sender: TObject);
begin
t1:=t1-per;
t2:=t2-per;
t3:=t3-per;
t4:=t4-per;
t5:=t5-per;
t10:=t10-per;
t11:=t11-per;
DrawGraph(current);
end;

procedure TDetailForm.BitBtn3Click(Sender: TObject);
begin
t1:=t1+per;
t2:=t2+per;
t3:=t3+per;
t4:=t4+per;
t5:=t5+per;
t10:=t10+per;
t11:=t11+per;
DrawGraph(current);
end;

procedure TDetailForm.BitBtn4Click(Sender: TObject);
var varinfo : Tvarinfo;
begin
varinfo:=Tvarinfo(varform.Grid1.Objects[0,current]);
t1:=varinfo.i[4];
t2:=varinfo.i[5];
t3:=varinfo.i[6];
t4:=varinfo.i[7];
t5:=varinfo.i[8];
t10:=varinfo.i[12];
t11:=varinfo.i[13];
DrawGraph(current);
end;

procedure TDetailForm.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape1.Brush.color;
if colordialog1.execute then begin
  shape1.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;
end;

procedure TDetailForm.Shape2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape2.Brush.color;
if colordialog1.execute then begin
  shape2.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;

end;

procedure TDetailForm.Shape3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape3.Brush.color;
if colordialog1.execute then begin
  shape3.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;

end;

procedure TDetailForm.Shape4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape4.Brush.color;
if colordialog1.execute then begin
  shape4.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;

end;

procedure TDetailForm.Shape5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape5.Brush.color;
if colordialog1.execute then begin
  shape5.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;

end;

procedure TDetailForm.Shape6MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape6.Brush.color;
if colordialog1.execute then begin
  shape6.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;

end;

procedure TDetailForm.Shape7MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape7.Brush.color;
if colordialog1.execute then begin
  shape7.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;

end;

procedure TDetailForm.Shape8MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape8.Brush.color;
if colordialog1.execute then begin
  shape8.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;

end;

procedure TDetailForm.Shape9MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape9.Brush.color;
if colordialog1.execute then begin
  shape9.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;

end;

procedure TDetailForm.Shape10MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
colordialog1.color:=shape10.Brush.color;
if colordialog1.execute then begin
  shape10.Brush.Color:=colordialog1.color;
  DrawGraph(current);
end;

end;

procedure TDetailForm.CheckBox3Click(Sender: TObject);
begin
if initialized then DrawGraph(current);
end;


procedure TDetailForm.SaveasBMP1Click(Sender: TObject);
var curdir : string;
begin
  GetDir(0,curdir);
  Savedialog1.filename:=starname+'.bmp';
  try
  if SaveDialog1.Execute then
     Image1.Picture.Bitmap.SaveTofile(savedialog1.Filename);
  finally
    ChDir(curdir);
  end;
end;

procedure TDetailForm.Close1Click(Sender: TObject);
begin
bitbtn1.click;
end;

Function CleanName(nom : string):string;
begin
result:=stringreplace(nom,'+','%2B',[rfReplaceAll]);
result:=stringreplace(result,' ','%20',[rfReplaceAll]);
end;

procedure CleanXML(nom : string);
var f: textfile;
    buf:Tstringlist;
    i:integer;
begin
buf:=Tstringlist.Create;
buf.LoadFromFile(nom);
assignfile(f,nom);
rewrite(f);
for i:=0 to buf.Count-1 do begin
   if (trim(buf[i])<>'')and(copy(buf[i],1,19)<>'Astro::VO::VOTable:') then
      writeln(f,buf[i]);
end;
closefile(f);
buf.free;
end;

procedure TDetailForm.GetQuickLookClick(Sender: TObject);
begin
case OptForm.radiogroup6.itemindex of
0 : begin
    CreateDir(qldir);
    DownloadDialog1.URL:=StringReplace(OptForm.qlurl.Text,'$star',CleanName(starname),[]) ;
    DownloadDialog1.SaveToFile:=qlfn;
    DownloadDialog1.Title:='AAVSO QuickLook';
    if DownloadDialog1.Execute then begin;
       CleanXML(qlfn);
       CheckBox4.checked:=true;
       if started then DrawGraph(current);
    end;
    end;
1 : begin
    CreateDir(ExtractFilePath(afoevfn));
    DownloadDialog1.URL:=OptForm.afoevurl.Text+afoevdir+'/'+afoevname;
    DownloadDialog1.SaveToFile:=afoevfn;
    DownloadDialog1.Title:='AFOEV data archive';
    DownloadDialog1.FtpUserName:='anonymous';
    DownloadDialog1.FtpPassword:='varobs@';
    if DownloadDialog1.Execute then begin;
       CheckBox4.checked:=true;
       if started then DrawGraph(current);
    end;
    end;
end;
end;


procedure TDetailForm.CheckBox4Click(Sender: TObject);
begin
if started then DrawGraph(current);
end;

procedure TDetailForm.BitBtn6Click(Sender: TObject);
begin
if my=50 then my:=100 else my:=50;
if started then DrawGraph(current);
end;

procedure TDetailForm.CheckBox5Click(Sender: TObject);
begin
if started then DrawGraph(current);
end;

end.
