{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit MultiDocPackage; 

interface

uses
  MultiDoc, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('MultiDoc', @MultiDoc.Register); 
end; 

initialization
  RegisterPackage('MultiDocPackage', @Register); 
end.
