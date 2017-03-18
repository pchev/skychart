{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit MultiFramePackage;

interface

uses
  MultiFrame, ChildFrame, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('MultiFrame', @MultiFrame.Register);
end;

initialization
  RegisterPackage('MultiFramePackage', @Register);
end.
