{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit enhedit; 

interface

uses
  enhedits, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('enhedits', @enhedits.Register); 
end; 

initialization
  RegisterPackage('enhedit', @Register); 
end.
