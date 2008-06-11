unit u_param;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

const
bl='                                         ';
blank=' ';
abrcons=' And Ant Aps Aqr Aql Ara Ari Aur Boo Cae Cam Cnc CVn CMa CMi Cap Car Cas Cen Cep Cet Cha Cir Col Com CrA CrB Crv Crt Cru'
       +' Cyg Del Dor Dra Equ Eri For Gem Gru Her Hor Hya Hyi Ind Lac Leo LMi Lep Lib Lup Lyn Lyr Men Mic Mon Mus Nor Oct Oph Ori'
       +' Pav Peg Per Phe Pic Psc PsA Pup Pyx Ret Sge Sgr Sco Scl Sct Ser Ser Sex Tau Tel Tri TrA Tuc UMa UMi Vel Vir Vol Vul ';

greek : array[1..2,1..24]of string=(('alpha','beta','gamma','delta','epsilon','zeta','eta','theta','iota','kappa','lambda','mu','nu','zi','omicron','pi','rho','sigma','tau','upsilon','phi','chi','psi','omega'),
                          ('alp','bet','gam','del','eps','zet','eta','the','iot','kap','lam','mu','nu','zi','omi','pi','rho','sig','tau','ups','phi','chi','psi','ome'));

pulslist=' ACYG BCEP BCEPS BLBOO CEP CEP(B) CW CWA CWB DCEP DCEPS DSCT DSCTC L LB LC M PVTEL RR RR(B) RRAB RRC RV RVA RVB SR SRA SRB SRC SRD SXPHE ZZ ZZA ZZB ZZO ';
rotlist=' ACV ACVO BY ELL FKCOM PSR SXARI ';
ecllist=' E EA EB EW GS PN RS WD WR AR D DM DS DW K KE KW SD ';

//aavsocharturl='http://www.aavso.org/cgi-bin/shrinkwrap.pl?path=/';
aavsocharturl='http://mira.aavso.org/cgi-bin/vsp.pl?action=render&name=$star&ra=&dec=&charttitle=&chartcomment=&aavsoscale=$scale&fov=$fov&resolution=150&maglimit=$mag&north=$north&east=$east&othervars=gcvs&Submit=Plot+Chart';
aavsochartscale: array[0..13] of string=('A','AR','B','BR','C','CR','D','DR','E','ER','F','FR','G','GR');
aavsochartfov: array[0..13] of string=('900','900','180','180','120','120','60','60','30','30','15','15','7.5','7.5');
aavsochartmag: array[0..13] of string=('9','9','11','11','12','12','14.5','14.5','16.5','16.5','18.5','18.5','20.5','20.5');
aavsochartnorth: array[0..13] of string=('down','up','down','up','down','up','down','up','down','up','down','up','down','up');
aavsocharteast: array[0..1] of string=('right','left');

OpenFileCMD='kfmclient exec';

{$ifdef linux}
      DefaultPrivateDir='~/cartes_du_ciel/varobs';
      Defaultconfigfile='~/.varobs.ini';
      SharedDir='/usr/share/apps/skychart/varobs';
{$endif}
{$ifdef darwin}
      DefaultPrivateDir='~/cartes_du_ciel/varobs';
      Defaultconfigfile='~/.varobs.ini';
      SharedDir='/usr/share/skychart/varobs';
{$endif}
{$ifdef win32}
      DefaultPrivateDir='Cartes du Ciel\VarObs';
      Defaultconfigfile='varobs.ini';
{$endif}


var
  datim,datact,qlurl,qlinfo,afoevurl,afoevinfo,pcobscaption : string;
  lockdate : boolean;
  lockselect : boolean;
  started : boolean;
  AppDir,PrivateDir,ConstDir,ConfigFile,planname : string;
  jdact : double;
  CurrentRow: integer;
  param : Tstringlist;
  StartedByVarobs : boolean;
  NoChart : boolean;
  CielHnd : Thandle;

implementation

end.

