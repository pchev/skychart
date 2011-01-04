{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit HtmlComp; 

interface

uses
HtmlCompReg, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('HtmlCompReg', @HtmlCompReg.Register); 
end; 

initialization
  RegisterPackage('HtmlComp', @Register); 
end.
