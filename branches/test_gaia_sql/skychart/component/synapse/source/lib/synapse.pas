{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit synapse;

interface

uses
  blcksock, ftpsend, httpsend, synaser, ssl_openssl, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('synapse', @Register);
end.
