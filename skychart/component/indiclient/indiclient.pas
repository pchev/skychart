{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit indiclient;

{$warn 5023 off : no warning about unused units}
interface

uses
  indibaseclient, indiapi, indicom, pu_indigui, indiblobclient, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('indiclient', @Register);
end.
