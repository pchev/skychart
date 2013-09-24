{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit vosamp;

interface

uses
  cu_sampclient, cu_sampserver, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('vosamp', @Register);
end.
