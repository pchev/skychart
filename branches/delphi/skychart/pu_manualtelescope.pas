unit pu_manualtelescope;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  Tf_manualtelescope = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1DblClick(Sender: TObject);
  private
    { Private declarations }
    startpoint: TPoint;
    moving, lockmove: boolean;
  public
    { Public declarations }
    procedure SetTurn(txt:string);
  end;

var
  f_manualtelescope: Tf_manualtelescope;

implementation

uses u_constant;

{$R *.dfm}

{$include i_manualtelescope.pas}


end.
