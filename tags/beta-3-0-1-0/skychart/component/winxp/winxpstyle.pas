{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit WinXPstyle; 

interface

uses
  WinXP, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('WinXP', @WinXP.Register); 
end; 

initialization
  RegisterPackage('WinXPstyle', @Register); 
end.
