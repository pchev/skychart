{ Ce fichier a été automatiquement créé par Lazarus. Ne pas l'éditer !
  Cette source est seulement employée pour compiler et installer le paquet.
 }

unit bgrabitmappack; 

interface

uses
    BGRAAnimatedGif, BGRABitmap, BGRABitmapTypes, BGRABlend, 
  bgracompressablebitmap, BGRADefaultBitmap, BGRADNetDeserial, BGRAFilters, 
  BGRAGradients, BGRAPaintNet, BGRAPolygon, BGRAResample, LazarusPackageIntf;

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('bgrabitmappack', @Register); 
end.
