{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit HtmlComp; 

interface

uses
  HtmlCompReg, URLSubs, DitherUnit, FramBrwz, FramView, GDIPL2A,
  HtmlGif1, HTMLGif2, HtmlMisc, Htmlsbs1, Htmlsubs, HTMLUn2, Htmlview, 
  Readhtml, StylePars, StyleUn, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('HtmlCompReg', @HtmlCompReg.Register); 
end; 

initialization
  RegisterPackage('HtmlComp', @Register); 
end.
