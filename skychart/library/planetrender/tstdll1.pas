unit tstdll1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

  Procedure RenderMercury(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';
  Procedure RenderVenus(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';
  Procedure RenderMoon(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';
  Procedure RenderMars(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';
  Procedure RenderJupiter(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';
  Procedure RenderSaturn(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';
  Procedure RenderUranus(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';
  Procedure RenderNeptune(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';
  Procedure RenderPluto(cm,phase,pa,poleincl,sunincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';
  Procedure RenderSun(cm,pa,poleincl,mult : double; size : integer; bmp : tbitmap); stdcall;external 'libplanetrender.dll';


var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var cm,phase,pa,pole,sun,zoom : double;
begin
cm:=strtofloat(edit1.text);
phase:=strtofloat(edit2.text);
pa:=strtofloat(edit3.text);
pole:=strtofloat(edit4.text);
sun:=strtofloat(edit5.text);
zoom:=strtofloat(edit6.text);
image1.Picture.Bitmap.Height:=image1.Height;
image1.Picture.Bitmap.Width:=image1.Picture.Bitmap.Height;
image1.Picture.Bitmap.pixelformat:=pf24bit;
case radiogroup1.ItemIndex of
0 : RenderMercury(cm,phase,pa,pole,sun,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
1 : RenderVenus(cm,phase,pa,pole,sun,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
2 : RenderMoon(cm,phase,pa,pole,sun,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
3 : RenderMars(cm,phase,pa,pole,sun,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
4 : RenderJupiter(cm-90,phase,pa,pole,sun,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
5 : RenderSaturn(cm,phase,pa,pole,sun,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
6 : RenderUranus(cm,phase,pa,pole,sun,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
7 : RenderNeptune(cm,phase,pa,pole,sun,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
8 : RenderPluto(cm,phase,pa,pole,sun,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
9 : RenderSun(cm,pa,pole,zoom,image1.Picture.Bitmap.Width,image1.Picture.Bitmap);
end;
image1.Invalidate;
end;

end.
