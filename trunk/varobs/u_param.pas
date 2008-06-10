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

aavsocharturl='http://www.aavso.org/cgi-bin/shrinkwrap.pl?path=/';

OpenFileCMD='kfmclient exec';

var
  datim,datact,qlurl,qlmethode,qlinfo,vsurl,vsmethode,vsinfo,afoevurl,afoevmethode,afoevinfo,pcobscaption : string;
  lockdate : boolean;
  lockselect : boolean;
  started : boolean;
  AppDir,planname : string;
  jdact : double;
  CurrentRow: integer;
  param : Tstringlist;
  StartedByVarobs : boolean;
  NoChart : boolean;
  CielHnd : Thandle;

implementation

end.

