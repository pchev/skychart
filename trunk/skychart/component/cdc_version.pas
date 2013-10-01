unit cdc_version;
{
 Component that do nothing except avoiding weird message when installing the cdccomponnent package
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TCdCVersion }

  TCdCVersion = class(TForm)
    Label1: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  CdCVersion: TCdCVersion;

procedure Register;

implementation

{$R *.lfm}
procedure Register;
begin
  RegisterComponents('CDC', [TCdCVersion]);
end;

end.

