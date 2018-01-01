// This component is made by Violin Iliev for Lazarus
// Use this under Windows only.
// This will make your app with a WinXP Style
// To change the icon of your app replace "mainicon.ico" 
// and then run "remake.bat"
unit WinXP;

interface

{$R WINXP.RES}

uses
  Classes, Windows, Messages, SysUtils, Forms, LResources;

type
  TWinXP = class(TComponent)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
  published
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Misc', [TWinXP]);
end;

constructor TWinXP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if not (AOwner is TForm) then
    raise Exception.Create('You must place this on a form!');
end;



end.
 
