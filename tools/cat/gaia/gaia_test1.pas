unit gaia_test1;

{$mode objfpc}{$H+}

interface

uses chealpix, math, libsql, passql, passqlite, Classes, SysUtils, FileUtil,
  Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

const
  ndb=7;
  magl: array[0..ndb-1] of integer =(8,14,16,17,18,19,99);

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnSearch: TButton;
    EditMag: TEdit;
    EditRA: TEdit;
    EditDEC: TEdit;
    EditFOV: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure BtnSearchClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    db: array [0..ndb-1] of TSqlDB;
    currentlevel,maxlevel,currentrow: integer;
    GaiaSql: string;
    GaiaFov: array[0..6] of double;

    procedure Init;
    procedure ComputeGaiaFov;
    procedure GetGaiaFov(fov:double; out level:integer);
    procedure GetGaiaMag(mag:double; out level: integer);
    function  OpenGaia(ra,de,fov,maxmag: double):boolean;
    function  NextGaiaLevel:boolean;
    procedure CloseGaia;
    function  ReadGaia(out buf:string):boolean;

  public

  end;

var
  Form1: TForm1;


const
  rad2deg = 180/pi;
  deg2rad = pi/180;
  tab = chr(9);

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ComputeGaiaFov;
var i: integer;
    nside: LongInt;
    pixarea,pixwidth: double;
begin
  for i:=0 to 6 do begin
    nside:=round(2**i);
    pixarea:=4*pi/nside2npix(nside);
    pixwidth:=sqrt(pixarea);
    pixwidth:=rad2deg*pixwidth;
    GaiaFov[i]:=pixwidth;
  end;
end;

procedure TForm1.GetGaiaFov(fov:double; out level:integer);
var i: integer;
begin
  level:=-1;
  for i:=0 to 6 do begin
    if fov<GaiaFov[i] then level:=i;
  end;
end;

procedure TForm1.GetGaiaMag(mag:double; out level: integer);
var i: integer;
begin
  level:=6;
  for i:=ndb-1 downto 0 do begin
    if trunc(mag)<=magl[i] then level:=i;
  end;
end;

procedure TForm1.Init;
var i: integer;
begin
  ComputeGaiaFov;
  for i:=0 to ndb-1 do begin
    db[i] := TLiteDB.Create(nil);
    db[i].Use('gaiadr1_'+inttostr(i));
  end;
end;

function TForm1.OpenGaia(ra,de,fov,maxmag: double):boolean;
var theta,phi,minra,maxra,minra2,maxra2,minde,maxde: double;
    racrosszero:boolean;
    level,dblevel,nside:integer;
    ipix,filter: Int64;
begin
  racrosszero:=false;
  minra:=ra-fov/2;
  if minra<0 then begin
    racrosszero:=true;
    minra2:=360+minra;
    maxra2:=360;
    minra:=0;
  end;
  maxra:=ra+fov/2;
  if maxra>360 then begin
    racrosszero:=true;
    minra2:=0;
    maxra2:=maxra-360;
    maxra:=360;
  end;
  minde:=de-fov/2;
  if minde<-90 then minde:=-90;
  maxde:=de+fov/2;
  if maxde>90 then maxde:=90;
                            //17/20   14/5   7/120  16/120     22/0.5
  GetGaiaMag(maxmag,dblevel);//   3      1       0       2           6
  GetgaiaFov(2*fov,level);   //   1      3      -1      -1           6
  if (level<dblevel) then
     dblevel:=level;         //   1      1      -1      -1           6
  if dblevel<0 then
     dblevel:=0;             //   1      1       0       0           6
  nside:=round(2**level);
  theta:=deg2rad*(90-de);
  phi:=deg2rad*ra;
  GaiaSql:='select source_id,ra,de,phot_g_mean_mag,parallax,pmra,pmdec from gaia';
  if level>=0 then begin
    ipix:=0;
    ang2pix_nest64(nside,theta,phi,ipix);
    filter:=round((2**35)*(4**(12 - level)));
    GaiaSql:=GaiaSql+' '+
         'where (source_id / '+inttostr(filter)+')='+inttostr(ipix)+' '+
         'and phot_g_mean_mag<'+formatfloat('0.00',maxmag);
  end
  else begin
    GaiaSql:=GaiaSql+' '+
         'where phot_g_mean_mag<'+formatfloat('0.00',maxmag);
  end;
  if racrosszero then begin
    GaiaSql:=GaiaSql+' '+
         'and ('+
         '(ra>'+formatfloat('0.00',minra)+' and ra<'+formatfloat('0.00',maxra)+') or '+
         '(ra>'+formatfloat('0.00',minra2)+' and ra<'+formatfloat('0.00',maxra2)+')'+
         ') '+
         'and de>'+formatfloat('0.00',minde)+' and de<'+formatfloat('0.00',maxde);
  end
  else begin
    GaiaSql:=GaiaSql+' '+
         'and ra>'+formatfloat('0.00',minra)+' and ra<'+formatfloat('0.00',maxra)+' '+
         'and de>'+formatfloat('0.00',minde)+' and de<'+formatfloat('0.00',maxde);
  end;
  GaiaSql:=GaiaSql+' order by phot_g_mean_mag asc';
  currentlevel:=-1;
  maxlevel:=dblevel;
  result:=NextGaiaLevel;
end;

function  TForm1.NextGaiaLevel:boolean;
begin
  result:=False;
  Inc(currentlevel);
  if currentlevel>maxlevel then exit;
  db[currentlevel].Query(GaiaSql);
  currentrow:=-1;
  result:=(db[currentlevel].RowCount>0);
end;

function  TForm1.ReadGaia(out buf:string):boolean;
begin
  inc(currentrow);
  if currentrow<db[currentlevel].RowCount then begin
    buf:=db[currentlevel].Results[currentrow][0]+tab+
         db[currentlevel].Results[currentrow][1]+tab+
         db[currentlevel].Results[currentrow][2]+tab+
         db[currentlevel].Results[currentrow][3]+tab+
         db[currentlevel].Results[currentrow][4]+tab+
         db[currentlevel].Results[currentrow][5]+tab+
         db[currentlevel].Results[currentrow][6];
    result:=true;
  end
  else begin
    result:=NextGaiaLevel;
    if result then
       result:=ReadGaia(buf);
  end;
end;

procedure TForm1.CloseGaia;
begin
 currentlevel:=-1;
 maxlevel:=-1;
 currentrow:=-1;
end;

procedure TForm1.BtnSearchClick(Sender: TObject);
var ra,de,fov,mag,st,et: double;
    list:TStringList;
    buf: string;
begin
  list:=TStringList.Create;
  ra:=StrToFloat(EditRA.Text);
  de:=StrToFloat(EditDEC.Text);
  fov:=StrToFloat(EditFOV.Text);
  mag:=StrToFloat(EditMag.Text);
  st:=now;
  OpenGaia(ra,de,fov,mag);
  while ReadGaia(buf) do
    list.Add(buf);
  CloseGaia;
  et:=now;
  label4.Caption:=formatfloat('0.000',(et-st)*24*3600);
  label5.Caption:=IntToStr(list.Count);
  memo1.clear;
  memo1.Lines.Assign(list);
  list.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var level: integer;
    filter: Int64;
begin
  // make a list of filter to create the indexes
  for level := 0 to 12 do begin
   filter:=round((2**35)*(4**(12 - level)));
   writeln(inttostr(level)+chr(9)+FormatFloat('0.000',GaiaFov[level])+chr(9)+inttostr(filter));
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
var i: integer;
begin
  for i:=0 to ndb-1 do
    db[i].Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Init;
end;

end.

