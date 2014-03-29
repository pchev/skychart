{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit zoomimage; 

interface

uses
  cu_zoomimage, u_bitmap, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('cu_zoomimage', @cu_zoomimage.Register); 
end; 

initialization
  RegisterPackage('zoomimage', @Register); 
end.
