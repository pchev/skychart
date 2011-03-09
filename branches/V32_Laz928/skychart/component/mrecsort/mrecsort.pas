{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit mrecsort; 

interface

uses
  mwFixedRecSort, mwCompFrom, LazarusPackageIntf; 

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('mrecsort', @Register); 
end.
