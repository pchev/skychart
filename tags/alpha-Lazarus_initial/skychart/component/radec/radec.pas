{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit radec; 

interface

uses
  cu_radec, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('cu_radec', @cu_radec.Register); 
end; 

initialization
  RegisterPackage('radec', @Register); 
end.
