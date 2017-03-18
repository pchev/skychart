unit param;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

var
  datim,datact,qlurl,qlmethode,qlinfo,vsurl,vsmethode,vsinfo,afoevurl,afoevmethode,afoevinfo,pcobscaption : string;
  lockdate : boolean;
  lockselect : boolean;
  started : boolean;
  AppDir,planname : string;
  maxvar : integer;
  jdact : double;
  CurrentRow: integer;
  param : Tstringlist;
  StartedByVarobs : boolean;
  NoChart : boolean;
  CielHnd : Thandle;

implementation

end.

