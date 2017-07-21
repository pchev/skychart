{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit downldialog;

interface

uses
  downloaddialog, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('downloaddialog', @downloaddialog.Register);
end;

initialization
  RegisterPackage('downldialog', @Register);
end.
