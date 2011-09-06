{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit lazvo; 

interface

uses
  cu_vocatalog, cu_vodata, cu_vodetail, u_voconstant, cu_vo, 
    LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('cu_vo', @cu_vo.Register); 
end; 

initialization
  RegisterPackage('lazvo', @Register); 
end.
