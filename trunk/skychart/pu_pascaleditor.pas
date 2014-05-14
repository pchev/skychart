unit pu_pascaleditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, SynMemo, SynHighlighterPas, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { Tf_pascaleditor }

  Tf_pascaleditor = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    SynEdit1: TSynEdit;
    SynPasSyn1: TSynPasSyn;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_pascaleditor: Tf_pascaleditor;

implementation

{$R *.lfm}

end.

