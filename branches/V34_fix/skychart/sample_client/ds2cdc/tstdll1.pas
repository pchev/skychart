unit tstdll1;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button11: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    Edit46: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button2: TButton;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Button3: TButton;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Button4: TButton;
    Edit20: TEdit;
    Label20: TLabel;
    Edit21: TEdit;
    Label21: TLabel;
    Edit22: TEdit;
    Label22: TLabel;
    Button5: TButton;
    Edit23: TEdit;
    Label23: TLabel;
    Button6: TButton;
    Edit24: TEdit;
    Label24: TLabel;
    Edit25: TEdit;
    Edit26: TEdit;
    Label25: TLabel;
    Label26: TLabel;
    Edit27: TEdit;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Button7: TButton;
    Bevel1: TBevel;
    Label35: TLabel;
    Edit28: TEdit;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Button8: TButton;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Button9: TButton;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Label46: TLabel;
    Label47: TLabel;
    Edit40: TEdit;
    Edit41: TEdit;
    Label48: TLabel;
    Label49: TLabel;
    Edit42: TEdit;
    Label50: TLabel;
    Edit43: TEdit;
    Label51: TLabel;
    Edit44: TEdit;
    Label52: TLabel;
    Edit45: TEdit;
    Label53: TLabel;
    Button10: TButton;
    procedure Button11Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
Procedure CDC_DrawChart(rah,ram,Decd,decm : Double; FOV,Comport,LX200Delay : smallint;
                    TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring; forceBW,MW : Byte) ;stdcall; external 'ds2cdc.dll';
Procedure CDC_CenterOnConst(conname,TCaption,DSappname,HGCPath,STychoPath,ScopeType : ansistring;
                        Comport,LX200Delay : integer; forceBW,MW : Byte) ;stdcall; external 'ds2cdc.dll';
Procedure CDC_PlotDSO(rah,ram,Decd,decm : Double; DecSign,ObjType : byte; ObjSize : smallint;
                  DSOLabel,DSODesc,DSONotes,ChartImagePath : ansistring; Observed,LastObject : Byte); stdcall; external 'ds2cdc.dll';
Procedure CDC_CloseChart; stdcall; external 'ds2cdc.dll';
Procedure CDC_SetObservatory(Latitude,Longitude,TimeZone : Double; ObsName : AnsiString); stdcall; external 'ds2cdc.dll';
Procedure CDC_SetDate(Year,Month,Day,Hour,Minute : SmallInt); stdcall; external 'ds2cdc.dll';
Procedure CDC_PlotDSS(DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte); stdcall; external 'ds2cdc.dll';
Procedure CDC_Redraw; stdcall; external 'ds2cdc.dll';
Procedure CDC_ShowDSS(rah,ram,Decd,decm,FOV : Double; DssDir,ImagePath,ImageName : ansistring; UseExistingImage : byte); stdcall; external 'ds2cdc.dll';
Procedure CDC_PlotVar(VarName,VarType : ansistring; MagMax, MagMin, Epoch, Period, RiseTime : Double; LastObject : byte); stdcall; external 'ds2cdc.dll';
Procedure CDC_CloseVarObs; stdcall; external 'ds2cdc.dll';

procedure TForm1.Button1Click(Sender: TObject);
begin
CDC_SetObservatory(strtofloat(edit1.text),strtofloat(edit2.text),strtofloat(edit4.text),edit3.text);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  CDC_CenterOnConst(edit46.Text,'','','','','',0,0,0,0);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
CDC_SetDate(strtoint(edit5.text),strtoint(edit6.text),strtoint(edit7.text),strtoint(edit8.text),strtoint(edit9.text));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
CDC_DrawChart(strtofloat(edit10.text),strtofloat(edit11.text),strtofloat(edit12.text),strtofloat(edit13.text),strtoint(edit14.text),0,0,'','','','','',0,0);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
CDC_PlotDSO(strtofloat(edit15.text),strtofloat(edit16.text),strtofloat(edit17.text),strtofloat(edit18.text),0,strtoint(edit19.text),strtoint(edit20.text),edit21.text,edit22.text,'','',0,strtoint(edit23.text));
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
CDC_CloseChart;
CDC_CloseVarObs;
form1.close;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
CDC_PlotDSS(edit24.text,edit25.text,edit26.text,strtoint(edit27.text));
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
edit28.text:='CDC_DrawChart';
form1.refresh;
CDC_DrawChart(strtofloat(edit10.text),strtofloat(edit11.text),strtofloat(edit12.text),strtofloat(edit13.text),strtoint(edit14.text),0,0,'','','','','',0,0);
sleep(500);
edit28.text:='CDC_SetObservatory';
form1.refresh;
CDC_SetObservatory(strtofloat(edit1.text),strtofloat(edit2.text),strtofloat(edit4.text),edit3.text);
sleep(500);
edit28.text:='CDC_SetDate';
form1.refresh;
CDC_SetDate(strtoint(edit5.text),strtoint(edit6.text),strtoint(edit7.text),strtoint(edit8.text),strtoint(edit9.text));
sleep(500);
edit28.text:='CDC_PlotDSO';
form1.refresh;
CDC_PlotDSO(strtofloat(edit15.text),strtofloat(edit16.text),strtofloat(edit17.text),strtofloat(edit18.text),0,strtoint(edit19.text),strtoint(edit20.text),edit21.text,edit22.text,'','',0,strtoint(edit23.text));
sleep(500);
edit28.text:='CDC_PlotDSS';
form1.refresh;
CDC_PlotDSS(edit24.text,edit25.text,edit26.text,strtoint(edit27.text));
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
CDC_ShowDSS(strtofloat(edit29.text),strtofloat(edit30.text),strtofloat(edit31.text),strtofloat(edit32.text),strtofloat(edit33.text),edit34.text,edit35.text,edit36.text,strtoint(edit37.text));
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
CDC_PlotVar(edit38.text,edit39.text,strtofloat(edit40.text),strtofloat(edit41.text),strtofloat(edit42.text),strtofloat(edit43.text),strtofloat(edit44.text),strtoint(edit45.text));
end;

end.
