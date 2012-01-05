{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit CDCjdcalendar; 

interface

uses
  jdcalendar, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('jdcalendar', @jdcalendar.Register); 
end; 

initialization
  RegisterPackage('CDCjdcalendar', @Register); 
end.
