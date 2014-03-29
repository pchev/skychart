unit tstdde1;

interface

uses Sky_DDE_Util,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DdeMan, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button2: TButton;
    DdeClientConv1: TDdeClientConv;
    DdeClientItem1: TDdeClientItem;
    Edit2: TEdit;
    Button1: TButton;
    Edit3: TEdit;
    Button3: TButton;
    Timer1: TTimer;
    Edit4: TEdit;
    Button5: TButton;
    Button6: TButton;
    Edit5: TEdit;
    Label1: TLabel;
    Button4: TButton;
    Edit6: TEdit;
    Button7: TButton;
    Edit7: TEdit;
    Button8: TButton;
    Edit8: TEdit;
    Edit9: TEdit;
    Button9: TButton;
    procedure DdeClientItem1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
GetSkyChartInfo;  // initialize skychart value
end;

Function InitConv : boolean;
begin
result:=false;
with Form1 do if ddeclientconv1.SetLink(cdc,'DdeSkyChart') then begin   // initialize conversation
 ddeclientitem1.DdeItem:='DdeData';                  // if ready initialize items
 result:=true;
end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
skychartok := SkyChartRunning;     // is app already running
if not SkyChartok then begin
       StartSkyChart(edit4.text);  // if not start it with parameters
       Timer1.Enabled:=true;       // wait app start
       end
else begin
   skychartok:=Initconv;         // otherwise start communication directely
   if not skychartok then Timer1.Enabled:=true else button3.enabled:=false;   // if not ok restart timer
end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=false;                            // stop timer to avoid multiple call
if SkyChartRunning then begin                     // is app running
   sleep(2000);                                   // a litle more time to initialize
   skychartok:=Initconv;                          // start communication
   if not skychartok then Timer1.Enabled:=true else button3.enabled:=false;   // if not ok restart timer
end
else Timer1.Enabled:=true;
end;

procedure TForm1.DdeClientItem1Change(Sender: TObject);
begin
if ddeclientitem1.lines=nil then exit;
if ddeclientitem1.lines.count>1 then edit1.text:=ddeclientitem1.lines[1]; // position change
if ddeclientitem1.lines.count>2 then edit2.text:=ddeclientitem1.lines[2]; // info about selected object
if ddeclientitem1.lines.count>3 then edit5.text:=ddeclientitem1.lines[3]; // date/time change
if ddeclientitem1.lines.count>4 then edit6.text:=ddeclientitem1.lines[4]; // location change
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
ddeClientConv1.PokeData('DdeData',Pchar('MOVE '+edit1.text));  // set new position
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
ddeClientConv1.PokeData('DdeData',Pchar('FIND '+edit3.text));   // locate an object
{ Catalog id are the following :
Cat. Name              Catid
Messier                 1 
NGC                     2 
IC                      3 
GCVS                    4 
GC                      5 
GSC                     6 
SAO                     7 
HD                      8 
BD                      9 
CD                     10 
CPD                    11 
HR                     12 
Comet                  13 
Planet                 14 
Asteroid               15 
Constelation           16 
HR (star name)         17 
Bayer                  18 
Flamsteed              19 
}
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
ddeClientConv1.PokeData('DdeData',Pchar('DATE '+edit5.text));   // Change date/time
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
ddeClientConv1.PokeData('DdeData',Pchar('OBSL '+edit6.text));   // Change location
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
PostMessage(findwindow(nil,Pchar(skychartcaption)),WM_CLOSE,0,0);   // close skychart (use WM_QUIT to bypass close prompt)
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
ddeClientConv1.PokeData('DdeData',Pchar('SBMP '+edit7.text));   // Change location
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
ddeClientConv1.PokeData('DdeData',Pchar('SGIF '+edit8.text));   // Change location
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
ddeClientConv1.PokeData('DdeData',Pchar(edit9.text));
end;

end.
