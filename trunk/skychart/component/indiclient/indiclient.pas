{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit indiclient;

interface

uses
  indibaseclient, indiapi, indicom, pu_indigui, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('indiclient', @Register);
end.
