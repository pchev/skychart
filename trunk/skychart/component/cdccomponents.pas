{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit CDCcomponents;

interface

uses
  cdc_version, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('cdc_version', @cdc_version.Register);
end;

initialization
  RegisterPackage('CDCcomponents', @Register);
end.
