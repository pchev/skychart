library ds2cdc;

{
   This software is free of any right.
   It can be used or modified as you want at your sole responsibility.

   Program author : Patrick Chevalley
                    Switzerland
                    pch@freesurf.ch
}

{$mode objfpc}{$H+}

uses
  Interfaces,
  Classes,
  Sky_DDE_util,
  SysUtils,
  ds2cdc1;

exports
       DrawChart name 'CDC_DrawChart',
       CenterOnConst name 'CDC_CenterOnConst',
       PlotDSO  name 'CDC_PlotDSO',
       CloseChart name 'CDC_CloseChart',
       CDC_SetObservatory,
       CDC_SetDate,
       CDC_PlotDSS,
       CDC_ShowDSS,
       CDC_PlotVar,
       CDC_CloseVarObs,
       CDC_Redraw;

{$R *.res}

begin
  decimalseparator:='.';
  inittrace;
  ds2c:=Tds2cdc.Create;
  GetSkyChartInfo;
  GetWorkDir;
  ds2c.CielInstalled := cieldir>'';
  ds2c.VarInstalled := vardir>'';
end.

