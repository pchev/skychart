library PlanetRender;


uses
  SysUtils,
  Classes,
  renderform in 'renderform.pas' {Form1};

{$R *.RES}

{$LIBPREFIX 'libF'}

exports
      CloseLib,
      SetTexturePath ,
      RenderMercury ,
      RenderVenus,
      RenderMoon ,
      RenderMars ,
      RenderJupiter ,
      RenderSaturn ,
      RenderUranus ,
      RenderNeptune ,
      RenderPluto,
      RenderSun;

begin
decimalseparator:='.';
Form1:=Tform1.Create(nil);
end.
