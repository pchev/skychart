{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit wizardntb; 

interface

uses
  WizardNotebook, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('WizardNotebook', @WizardNotebook.Register); 
end; 

initialization
  RegisterPackage('wizardntb', @Register); 
end.
