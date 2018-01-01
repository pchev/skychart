{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit XmlParser; 

interface

uses
  LibXmlParser, LibXmlComps, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('LibXmlComps', @LibXmlComps.Register); 
end; 

initialization
  RegisterPackage('XmlParser', @Register); 
end.
