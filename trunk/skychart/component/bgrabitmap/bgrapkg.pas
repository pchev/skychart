{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit bgrapkg; 

interface

uses
  BGRAAnimatedGif, BGRABitmap, BGRABitmapTypes, BGRABlend, 
  bgracompressablebitmap, BGRADefaultBitmap, BGRADNetDeserial, BGRAFilters, 
  BGRAPaintNet, BGRAPolygon, bgraresample, LazarusPackageIntf;

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('bgrapkg', @Register); 
end.
