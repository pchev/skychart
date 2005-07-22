unit fu_zoom;

interface

uses u_util, Math,
  SysUtils, Classes, Variants, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QGrids, QButtons, QMask, QComCtrls;

type
  Tf_zoom = class(TForm)
    TrackBar1: TTrackBar;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    fov,logfov : double;
  end;

var
  f_zoom: Tf_zoom;

implementation

{$R *.xfm}

{$include i_zoom.pas}

end.
