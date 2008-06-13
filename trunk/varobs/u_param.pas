unit u_param;
{
Copyright (C) 2008 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

const
software_version='Skychart VarObs module 3.0 beta http://ap-i.net/skychart';
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

  CR = #$0d;
  LF = #$0a;
  CRLF = CR + LF;


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

