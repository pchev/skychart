unit libcatalog;

{
  I am sorry for the French comment in this unit.
  Anyone can translate this ?
}

interface

{$ifdef linux}
const lib_catalog='libcatalog.so';
{$endif}
{$ifdef win32}
const lib_catalog='libcatalog.dll';
{$endif}

{  Initialisation de la librarie
   et indication de l'utilisation du cache de donnee (recommander si >=32 MB memoire}
Procedure InitCat(hnd : Cardinal ;Cache : boolean); stdcall; external lib_catalog;

{ Initialisation de la fenetre d'ecran pour utiliser OpenXXXWin
 Il n'est pas necessaire d'appeler cette fonction pour OpenXXX
 Cette fonction est utilisee en interne par Cartes du Ciel}
Procedure InitCatWin(ax,ay,bx,by,st,ct,ac,dc,azc,hc,jdt,jdc,sidt,lat : double; pjp,xs,ys,xi,xa,yi,ya : integer; projt : char; np,sp : boolean); stdcall; external lib_catalog;

{ Pour tout les catalogues l'utilisation des procedure est la meme :

 SetXXXPath   Initialise le chemin vers les fichiers du catalogue
 OpenXXX      Ouvre les fichiers pour une fenetre comprise entre ar1 et ar2 et de1 et de2
 OpenXXXwin   Ouvre les fichiers pour une fenetre definie par InitCatWin (pour Cartes du Ciel uniquement)
 ReadXXX      Lit un enregistrement
 NextXXX      Force le passage au fichier suivant
 CloseXXX     Ferme les fichiers
}
// Bright Stars Catalog
const EpochBSC : Double = 2000.0;
type
BSCrec = record
         hd,bs,ar,de :longint ;
         pmar,pmde:smallint;
         mv,b_v   :smallint;
         cons     : array [1..3] of char;
         flam     : byte;
         bayer    : array[1..4]of char;
         sp       : array[1..20] of char;
         end;
{
- hd	: numéro du catalogue HD
- bs	: numéro du catalog Bright Star
- ar	: ascension droite J2000 en degrés * 100'000
- de	: declinaison J2000 * 100'000
- pmar  : mouvement propre en AR en milli-arcsecondes
- pmde  : mouvement propre en DE en milli-arcsecondes
- mv	: magnitude visuelle * 100
- b_v	: indice de couleur B-V * 100
- cons	: constelation
- flam	: numéro de Flamsteed
- bayer	: lettre de Bayer
- sp	: classe spectrale
}
Function  IsBSCpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetBSCpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenBSC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenBSCwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadBSC(var lin : BSCrec; var ok : boolean); stdcall; external lib_catalog;
Procedure NextBSC( var ok : boolean); stdcall; external lib_catalog;
procedure CloseBSC ; stdcall; external lib_catalog;

// Sky2000 Master Catalog
const EpochSKY : Double = 2000.0;
type
SKYrec = record ar,de :longint ;
         mv,b_v,d_m,pmar,pmde :smallint;
         sep      : word;
         sp       : array [1..3] of char;
         dm_cat   : array[1..2]of char;
         dm     : longint;
         hd,sao   :longint ;
         end;
{
- ar	: ascension droite J2000 en degrés * 100'000
- de	: declinaison J2000 * 100'000
- pmar  : mouvement propre en AR en milli-arcsecondes
- pmde  : mouvement propre en DE en milli-arcsecondes
- mv	: magnitude visuelle * 100
- b_v	: indice de couleur B-V * 100
- d_m	: différence de magnitude ( double ) * 100
- sep	: separation en seconde ( double ) * 100
- sp	: classe spectrale
- dm_cat: catalogue BD
- dm 	: numéro BD
- hd	: numéro du catalogue HD
- sao	: numéro du catalogue SAO
}
Function  IsSKYpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetSKYpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenSKY(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenSKYwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadSKY(var lin : SKYrec; var ok : boolean); stdcall; external lib_catalog;
Procedure NextSKY( var ok : boolean); stdcall; external lib_catalog;
procedure CloseSKY ; stdcall; external lib_catalog;

// Tycho catalog
const EpochTYC : double =1991.25;
type
TYCrec = record
         ar,de : longint;
         gscz: word;
         gscn: word;
         tycn: word;
         bt,vt,b_v,pmar,pmde :smallint;
         end;
{
- ar	: ascension droite ICRS (J2000) en degrés * 100'000
- de	: declinaison ICRS (J2000) * 100'000
- gscz	: région GSC
- gscn  : numéro de l'étoile dans la région GSC
- tycn	: numéro du composant
- bt	: magnitude BT moyenne * 100
- vt	: magnitude VT moyenne * 100
- b_v	: indice de couleur b-v * 100
- pmar  : mouvement propre en AR en milli-arcsecondes
- pmde  : mouvement propre en DE en milli-arcsecondes
}
Function  IsTYCpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetTYCpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenTYC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenTYCwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadTYC(var lin : TYCrec; var SMnum : shortstring ; var ok : boolean); stdcall; external lib_catalog;
Procedure NextTYC( var ok : boolean); stdcall; external lib_catalog;
procedure CloseTYC ; stdcall; external lib_catalog;

// Tycho-2 catalog
const EpochTY2 : double =2000.0;
type  TY2rec = record
               ar,de : double;
               gscz: word;
               gscn: word;
               tycn: word;
               bt,vt,pmar,pmde :double;
               end;
{
- ar	: ascension droite ICRS (J2000) en degrés
- de	: declinaison ICRS (J2000)
- gscz	: région GSC
- gscn  : numéro de l'étoile dans la région GSC
- tycn	: numéro du composant
- bt	: magnitude BT
- vt	: magnitude VT
- pmar  : mouvement propre en AR en milli-arcsecondes
- pmde  : mouvement propre en DE en milli-arcsecondes
}
Function  IsTY2path(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetTY2path(path : shortstring); stdcall; external lib_catalog;
{ Parametre supplementaire pour OPEN de Tycho-2 en format binaire:
  ncat=1 : uniquement le fichier jusqu'a magnitude 11 (tyc2a.cat)
  ncat=2 : toute les etoiles (tyc2a.cat + tyc2b.cat)  }
Procedure OpenTY2(ar1,ar2,de1,de2: double ;ncat :integer; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenTY2win(ncat :integer;var ok : boolean); stdcall; external lib_catalog;
Procedure ReadTY2(var lin : TY2rec; var SMnum : shortstring ; var ok : boolean); stdcall; external lib_catalog;
Procedure NextTY2( var ok : boolean); stdcall; external lib_catalog;
procedure CloseTY2 ; stdcall; external lib_catalog;

// Tycho Input catalog
type
TICrec = record
       ar,de : longint;
       gscz: word;
       gscn: word;
       mb,mv :smallint;
       end;
{
- ar	: ascension droite J2000 en degrés * 100'000
- de	: declinaison J2000 * 100'000
- gscz	: région GSC
- gscn  : numéro de l'étoile dans la région GSC
- mb	: magnitude B * 100 + flag16 * 10000
- mv	: magnitude V * 100
}
Function  IsTICpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetTICpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenTIC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenTICwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadTIC(var lin : TICrec; var SMnum : shortstring ; var ok : boolean); stdcall; external lib_catalog;
Procedure NextTIC( var ok : boolean); stdcall; external lib_catalog;
procedure CloseTIC ; stdcall; external lib_catalog;

// Guide Star catalog (version produite par convgsc.exe)
type
GSCrec = record
       ar,de : longint;
       gscn: word;
       pe,m,me :smallint;
       mb,cl : shortint;
       mult : char;
       end;
{
- ar	: ascension droite J2000 en degrés * 100'000
- de	: declinaison J2000 * 100'000
- gscn  : numéro de l'étoile dans la région
- pe	: erreur de position * 10
- m	: magnitude * 100
- me	: erreur de magnitude * 100
- mb	: bande passantes de magnitude
- cl 	: classe d'objet
- mult	: étoile multiple
}
Function  IsGSCpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetGSCpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenGSC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenGSCwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadGSC(var lin : GSCrec; var SMnum : shortstring ; var ok : boolean); stdcall; external lib_catalog;
Procedure NextGSC( var ok : boolean); stdcall; external lib_catalog;
procedure CloseGSC ; stdcall; external lib_catalog;

// Guide Star catalog (version originale FITS)
type
GSCFrec = packed record
        ar,de : double;
        gscn: integer;
        pe,m,me :double;
        mb,cl : integer;
        plate,mult : shortstring;
        end;
{
- ar	: ascension droite J2000 en degrés
- de	: declinaison J2000
- gscn  : numéro de l'étoile dans la région
- pe	: erreur de position
- m	: magnitude
- me	: erreur de magnitude
- mb	: bande passantes de magnitude
- cl 	: classe d'objet
- plate : nom de la plaque
- mult	: étoile multiple
}
Function  IsGSCFpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetGSCFpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenGSCF(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenGSCFwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadGSCF(var lin : GSCFrec; var SMnum : shortstring ; var ok : boolean); stdcall; external lib_catalog;
procedure CloseGSCF ; stdcall; external lib_catalog;

// Guide Star catalog (version compacte du CDS)
type
GSCCrec = GSCFrec;
{
- ar	: ascension droite J2000 en degrés
- de	: declinaison J2000
- gscn  : numéro de l'étoile dans la région
- pe	: erreur de position
- m	: magnitude
- me	: erreur de magnitude
- mb	: bande passantes de magnitude
- cl 	: classe d'objet
- plate : nom de la plaque
- mult	: étoile multiple
}
Function  IsGSCCpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetGSCCpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenGSCC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenGSCCwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadGSCC(var lin : GSCCrec; var SMnum : shortstring ; var ok : boolean); stdcall; external lib_catalog;
Procedure NextGSCC( var ok : boolean); stdcall; external lib_catalog;
procedure CloseGSCC ; stdcall; external lib_catalog;

// US Naval Observatory USNO-A1,SA1,A2,SA2 catalog
Type
USNOArec = record
         id  : shortstring;
         ar  : double;
         de  : double;
         mb  : double;
         mr  : double;
         field,q,s: integer;
         end;
{
- id    : numéro de l'étoile
- ar	: ascension droite J2000 en heure
- de	: declinaison J2000
- mb	: magnitude "bleu"
- mr    : magnitude "rouge"
- field : numéros de plaque
- q     : qualité photométrique
- s     : -1 = figure dans le catalogue de calibration (GSC ou ACT)
}
Function  IsUSNOApath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetUSNOApath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenUSNOAwin(var ok : boolean); stdcall; external lib_catalog;
Procedure OpenUSNOA(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure ReadUSNOA(var lin : USNOArec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseUSNOA ; stdcall; external lib_catalog;

// MicroCat
Type
MCTrec = record
         ar  : double;
         de  : double;
         mb  : double;
         mr  : double;
         end;
{
- ar	: ascension droite J2000 en heure
- de	: declinaison J2000
- mb	: magnitude "bleu"
- mr    : magnitude "rouge"
}
Function  IsMCTpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetMCTpath(path : shortstring); stdcall; external lib_catalog;
{ Parametre supplementaire pour OPEN de MicroCat :
  ncat=1 : catalog Tycho
  ncat=2 : catalog Tycho + GSC
  ncat=3 : catalog Tycho + GSC + USNO }
Procedure OpenMCTwin(ncat : integer;var ok : boolean); stdcall; external lib_catalog;
Procedure OpenMCT(ar1,ar2,de1,de2: double ;ncat : integer; var ok : boolean); stdcall; external lib_catalog;
Procedure ReadMCT(var lin : MCTrec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseMCT ; stdcall; external lib_catalog;

// SAGUARO ASTRONOMY CLUB DATABASE  V7
type
SACrec = record
            ar,de,ma,sbr,s1,s2 : single;
            pa : byte;
            nom1 : string[17];
            nom2 : string[18];
            typ,cons  : string[3];
            desc : string[120];
            clas : string[11];
         end;
{
- ar	: ascension droite 2000 en degrés
- de	: declinaison 2000
- ma	: magnitude
- sbr   : magnitude de surface
- s1    : plus grande dimension en minutes
- s2    : plus petite dimension en minutes
- pa    : angle de position du grand axe
- nom1  : nom
- nom2  : autre nom
- typ	: type d'objet
- cons	: constellation
- desc	: description
- clas  : divers classes
}
Function  IsSACpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetSACpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenSAC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenSACwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadSAC(var lin : SACrec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseSAC ; stdcall; external lib_catalog;

// NGC 2000
type
NGCrec = record
       ar,de :longint ;
       id    : word;
       ic    : char;
       typ   : array [1..3] of char;
       l_dim : char;
       n_ma  : char;
       ma,dim:smallint;
       cons  : array [1..3] of char;
       desc  : array[1..50] of char;
       end;
{
- ar	: ascension droite 2000 en degrés * 100'000
- de	: declinaison 2000 * 100'000
- id 	: numéro NGC ou IC
- ic	: I pour IC , blanc pour NGC
- typ	: type d'objet
- l_dim	: limite de la taille
- n_mag : p si magnitude photographique
- ma	: magnitude * 100
- dim	: plus grande dimension en minutes * 10
- cons	: constellation
- desc	: description
}
Function  IsNGCpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetNGCpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenNGC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenNGCwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadNGC(var lin : NGCrec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseNGC ; stdcall; external lib_catalog;

// Lynds' Catalogue of Bright Nebulae
type
LBNrec = record
       ar,de :longint ;
       area : single;
       num,d1,d2,id : word;
       color,bright : byte;
       name : array[1..8] of char;
       end;
{
- ar	: ascension droite 2000 en degrés * 100'000
- de	: declinaison 2000 * 100'000
- area	: surface de la nébuleuse en degrés carré
- num	: numéro de sequence
- d1	: plus grande dimension en minutes
- d2	: plus petite dimension en minutes
- id	: identification de la région
- color	: indice de couleur
- bright: indice de luminosité
- name	: nom
}
Function  IsLBNpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetLBNpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenLBN(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenLBNwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadLBN(var lin : LBNrec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseLBN ; stdcall; external lib_catalog;

// Third Reference Cat. of Bright Galaxies (RC3)
type
RC3rec = record
       ar,de,vgsr :longint ;
       pgc   : array[1..8] of char;
       nom   : array [1..14] of char;
       typ   : array [1..7] of char;
       pa    : byte;
       stage,lumcl,d25,r25,Ae,mb,b_vt,b_ve,m25,me : smallint;
       end;
{
- ar	: ascension droite 2000 en degrés * 100'000
- de	: declinaison 2000 * 100'000
- vgsr	: vitesse radiale moyenne
- pgc	: numéro du catalogue PGC
- nom	: autres noms
- typ	: type morphologique
- pa	: angle de position du grand axe
- stage	: Hubble stage * 10
- lumcl	: classe de luminosité * 10
- d25	: log du grand axes à l'isophote 25/'2 * 100
- r25	: log du rapport grand axe / petit axe  * 100
- Ae	: log de l'ouverture effective * 100
- mb	: magnitude B ou photographique totale * 100
- b_vt	: indice de couleur b-v total * 100
- b_ve	: indice de couleur b-v dans l'ouverture effective * 100
- m25	: magnitude / minute carrée moyenne * 100
- me	: magnitude / minute carrée dans l'ouverture effective * 100
}
Function  IsRC3path(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetRC3path(path : shortstring); stdcall; external lib_catalog;
Procedure OpenRC3(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenRC3win(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadRC3(var lin : RC3rec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseRC3 ; stdcall; external lib_catalog;

// Catalogue of Principal Galaxies (PGC)
type
PGCrec = record
       pgc,ar,de,hrv   : Longint;
       nom   : array [1..16] of char;
       typ   : array [1..4] of char;
       pa    : byte;
       maj,min,mb : smallint;
       end;
{
- pgc	: numéro du catalogue PGC
- ar	: ascension droite 2000 en degrés * 100'000
- de	: declinaison 2000 * 100'000
- hrv	: vitesse radiale héliocentrique
- nom	: autres noms
- typ	: type morphologique
- pa	: angle de position du grand axe
- maj	: grand axe à l'isophote 25/'2 * 100
- min	: petit axe à l'isophote 25/'2 * 100
- mb	: magnitude B * 100
}
Function  IsPGCpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetPGCpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenPGC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenPGCwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadPGC(var lin : PGCrec; var ok : boolean); stdcall; external lib_catalog;
procedure ClosePGC ; stdcall; external lib_catalog;

// Open Cluster Data
type
OCLrec = record
       ar,de :longint ;
       cat,num,ocl,dim,dist,age,ms,mt,b_v,ns : smallint;
       conc,range,rich,neb : char;
       end;
{
- ar	: ascension droite 2000 en degrés * 100'000
- de	: declinaison 2000 * 100'000
- cat	: numéro du catalogue
- num	: numéro de sequence dans le catalogue
- ocl	: numéro OCL
- dim	: dimension en minutes * 10
- dist	: distance en parsec
- age	: log de l'age de l'amas * 100
- ms	: magnitude de l'étoile la plus brillante * 100
- mt	: magnitude totale * 100
- b_v	: indice de couleur b-v total * 100
- ns	: nombre d'étoile
- conc	: classe de concentration de Trumpler
- range	: échelle de Trumpler
- rich	: classe de richesse de Trumpler
- neb	: classe de nébulosité de Trumpler
}
Function  IsOCLpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetOCLpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenOCL(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenOCLwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadOCL(var lin : OCLrec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseOCL ; stdcall; external lib_catalog;

// Globular Clusters in the Milky Way
type
GCMrec = record
       ar,de :longint ;
       Rsun,Vt,B_Vt,c,Rc,Rh,muV : smallint;
       id   : array[1..9] of char;
       name : array[1..11] of char;
       SpT  : array[1..4] of char;
       end;
{
- ar	: ascension droite 2000 en degrés * 100'000
- de	: declinaison 2000 * 100'000
- Rsun	: distance au soleil en kpc *10
- Vt	: magnitude V integrée * 100
- B_Vt	: indice de couleur B-V * 100
- c	: concentration centrale * 100
- Rc	: rayon du noyau * 100
- Rh	: rayon de demi-masse * 100
- muV	: luminosité de surface centrale * 100
- id	: numéros de l'amas
- name	: autre nom
- SpT	: classe spectrale integrée
}
Function  IsGCMpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetGCMpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenGCM(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenGCMwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadGCM(var lin : GCMrec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseGCM ; stdcall; external lib_catalog;

// Strasbourg-ESO Catalogue of Galactic Planetary Nebulae
type
GPNrec = record
       ar,de :longint ;
       dim,mv,mHb,cs_b,cs_v : smallint;
       ldim,lv,morph,cs_lb,cs_lv : char;
       png : array[1..10] of char;
       pk  : array[1..9] of char;
       name: array[1..13] of char;
       end;
{
- ar	: ascension droite 2000 en degrés * 100'000
- de	: declinaison 2000 * 100'000
- dim	: dimmension en arcsec * 10
- mv	: magnitude visuelle * 100
- mHb	: magnitude Hbeta * 100 ( 10+2.5(-10-FluxHbeta) )
- cs_b	: magnitude B de l'étoile centrale * 100
- cs_v	: magnitude V de l'étoile centrale * 100
- ldim	: limite de dimension
- lv	: limite de magnitude visuelle
- morph : indice morphologique
- cs_lb	: limite de magnitude B de l'étoile centrale
- cs_lv	: limite de magnitude V de l'étoile centrale
- png	: identification de la nébuleuse planétaire
- pk	: identification Perek-Kohoutek
- name	: autre nom de la nébuleuse planétaire
}
Function  IsGPNpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetGPNpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenGPN(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenGPNwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadGPN(var lin : GPNrec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseGPN ; stdcall; external lib_catalog;

//  Washington Visual Double Star Catalog
type
WDSrec = record
       ar,de,dm :longint ;
       date1,date2,pa1,pa2,sep1,sep2,ma,mb : smallint;
       id : array[1..7] of char;
       comp : array[1..5] of char;
       sp : array[1..9] of char;
       note : array[1..2] of char;
       end;
{
- ar	: ascension droite 2000 en degrés * 100'000
- de	: declinaison 2000 * 100'000
- dm	: zone et numéro BD
- date1	: date de la première observation
- date2	: date de la deuxième observation
- pa1	: angle de position pour date1
- pa2	: angle de position pour date2
- sep1	: séparation en secondes pour date1 * 10
- sep2	: séparation en secondes pour date2 * 10
- ma	: magnitude du premier composent * 100
- mb	: magnitude du second composent * 100
- id	: identification de l'étoile
- comp	: identification des composents
- sp	: classe spectrale
- note	: Notes
}
Function  IsWDSpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetWDSpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenWDS(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenWDSwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadWDS(var lin : WDSrec; var ok : boolean); stdcall; external lib_catalog;
Procedure NextWDS( var ok : boolean); stdcall; external lib_catalog;
procedure CloseWDS ; stdcall; external lib_catalog;

// General Catalog of Variable Stars (+NSV +EVS)
type
GCVrec = record
       ar,de,num :longint ;
       period : single;
       max,min : smallint;
       lmax,lmin,mcode : char;
       gcvs,vartype : array[1..10] of char;
       end;
{
- ar	: ascension droite 2000 en degrés * 100'000
- de	: declinaison 2000 * 100'000
- num	: numéro de constelation et d'étoile
- period: periode de variation en jours
- max	: magnitude maximum * 100
- min	: magnitude minimum * 100
- lmax	: limite de magnitude maximum
- lmin	: limite de magnitude minimum
- mcode : système photométrique
- gcvs	: identification de l'étoile variable
- vartype: type de variable + année de nova
}
Function  IsGCVpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetGCVpath(path : shortstring); stdcall; external lib_catalog;
Procedure OpenGCV(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenGCVwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadGCV(var lin : GCVrec; var ok : boolean); stdcall; external lib_catalog;
Procedure NextGCV( var ok : boolean); stdcall; external lib_catalog;
procedure CloseGCV ; stdcall; external lib_catalog;

// Deepsky 2000 Super Tycho and HGS
type
DSRec = record
                  RA  : double;
                  Dec : double;
                  Mag : double;
              end;
{
- ar	: ascension droite 2000 en heure
- de	: declinaison 2000
- mag   : magnitude
}
Function  IsDSbasepath(path : shortstring):boolean; stdcall; external lib_catalog;
Function  IsDStycpath(path : shortstring):boolean; stdcall; external lib_catalog;
Function  IsDSgscpath(path : shortstring):boolean; stdcall; external lib_catalog;
procedure SetDSpath(path,tycpath,gscpath : shortstring); stdcall; external lib_catalog;
Procedure OpenDSTYC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenDSTYCwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadDSTYC(var dslin : DSrec; var ok : boolean); stdcall; external lib_catalog;
Procedure NextDSTYC( var ok : boolean); stdcall; external lib_catalog;
procedure CloseDSTYC ; stdcall; external lib_catalog;
Procedure OpenDSGSC(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenDSGSCwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadDSGSC(var dslin : DSrec; var ok : boolean); stdcall; external lib_catalog;
Procedure NextDSGSC( var ok : boolean); stdcall; external lib_catalog;
procedure CloseDSGSC ; stdcall; external lib_catalog;
Procedure OpenDSbase(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenDSbasewin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadDSbase(var dslin : DSrec; var ok : boolean); stdcall; external lib_catalog;
procedure CloseDSbase ; stdcall; external lib_catalog;

//  Custom catalog
const
 rtStar = 1;  rtVar  = 2; rtDbl  = 3; rtNeb  = 4; rtlin   = 5;
 vsId=1; vsMagv=2; vsB_v=3; vsMagb=4; vsMagr=5; vsSp=6; vsPmra=7; vsPmdec=8; vsEpoch=9; vsPx=10; vsComment=11; vsGreekSymbol=12;
 vvId=1; vvMagmax=2; vvMagmin=3; vvPeriod=4; vvVartype=5; vvMaxepoch=6; vvRisetime=7;  vvSp=8; vvMagcode=9; vvComment=10;
 vdId=1; vdMag1=2; vdMag2=3; vdSep=4; vdPa=5; vdEpoch=6; vdCompname=7; vdSp1=8; vdSp2=9; vdComment=10;
 vnId=1; vnNebtype=2; vnMag=3; vnSbr=4; vnDim1=5; vnDim2=6; vnNebunit=7; vnPa=8; vnRv=9; vnMorph=10; vnComment=11;
 vlId=1; vlLinecolor=2; vlLineoperation=3; vlLinewidth=4; vlLinetype=5; vlComment=6;
 lOffset=2;
Type
TVstar = array[1..12] of boolean;
TVvar  = array[1..10] of boolean;
TVdbl  = array[1..10] of boolean;
TVneb  = array[1..11] of boolean;
TVlin  = array[1..6] of boolean;
TValid = array[1..10] of boolean;
Tlabellst = array[1..35,0..10] of char;
TSname = array[0..3] of char;
Tstar =   packed record
          magv,b_v,magb,magr,pmra,pmdec,epoch,px : double;
          id,sp,comment,greeksymbol : shortstring;
          valid : TVstar;
          end;
Tvariable=packed record
          magmax,magmin,period,maxepoch,risetime : double;
          id,vartype,sp,magcode,comment : shortstring;
          valid : TVvar;
          end;
Tdouble = packed record
          mag1,mag2,sep,pa,epoch : double;
          id,compname,sp1,sp2,comment : shortstring;
          valid : TVdbl;
          end;
Tneb    = packed record
          mag,sbr,dim1,dim2,pa,rv : double;
          nebunit : Smallint;
          nebtype : ShortInt;
          id,morph,comment : shortstring;
          messierobject : boolean;
          valid : TVneb;
          end;
Toutlines = packed record
          linecolor : LongWord;
          lineoperation,linewidth,linetype : byte;
          id,comment : shortstring;
          valid : TVlin;
          end;
TCatOption = packed record
          ShortName: TSname;
          rectype  : integer;
          Equinox  : double;
          EquinoxJD: double;
          Epoch    : double;
          MagMax   : double;
          Size     : Integer;
          Units    : Integer;
          ObjType  : Integer;
          LogSize  : Integer;
          UsePrefix: byte;
          altname  : Tvalid;
          flabel   : Tlabellst;
          end;
GCatrec = packed record
          ra,dec   : double ;
          star     : Tstar;
          variable : Tvariable;
          double   : Tdouble;
          neb      : Tneb;
          outlines : Toutlines;
          str      : array[1..10] of shortstring;
          num      : array[1..10] of double;
          vstr,vnum: Tvalid;
          options  : TCatoption;
          end;
Type TCatHeader = packed record
                 hdrl     : Integer;
                 version  : array[0..7] of char;
                 ShortName: TSname;
                 LongName : array[0..49] of char;
                 reclen   : Integer;
                 FileNum  : Integer;
                 Equinox  : double;
                 Epoch    : double;
                 MagMax   : double;
                 Size     : Integer;
                 Units    : Integer;
                 ObjType  : Integer;
                 LogSize  : Integer;
                 UsePrefix: byte;
                 IxKeylen : byte;
                 AltName  : array[1..10] of byte;
                 Spare1   : array[1..20] of integer;
                 fpos     : array[1..35] of integer;
                 Spare2   : array[1..20] of integer;
                 flen     : array[1..35] of integer;
                 Spare3   : array[1..20] of integer;
                 flabel   : Tlabellst;
                 Spare4   : array[1..20,0..10] of char;
                 end;

procedure SetGCatpath(path,catshortname : shortstring); stdcall; external lib_catalog;
procedure GetGCatInfo(var h : TCatHeader; var version : integer; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenGCat(ar1,ar2,de1,de2: double ; var ok : boolean); stdcall; external lib_catalog;
Procedure OpenGCatwin(var ok : boolean); stdcall; external lib_catalog;
Procedure ReadGCat(var lin : GCatrec; var ok : boolean); stdcall; external lib_catalog;
Procedure ReadGCat2(var lin : GCatrec; var ok : boolean); stdcall; external lib_catalog;
Procedure NextGCat( var ok : boolean); stdcall; external lib_catalog;
procedure CloseGCat ; stdcall; external lib_catalog;

// Recherche de la position d'un objet  ( ne pas oublier d'appeller la procedure SetPathXXX corespondante)
Procedure FindNumNGC(id:Integer ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumIC(id:Integer ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumMessier(id:Integer ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumWDS(id:Shortstring ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumGCVS(id:shortstring ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumGSC(id : ShortString ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumGSCF(id : ShortString ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumGSCC(id : ShortString ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumGC(id:Integer ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumHR(id:Integer ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumBayer(id:Shortstring ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumFlam(id:Shortstring ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumHD(id:Integer ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumSAO(id:Integer ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumBD(id:ShortString ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumCD(id:ShortString ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumCPD(id:ShortString ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumPGC(id:Integer ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumSAC(id:ShortString ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumGcat(path,catshortname,id : ShortString ; keylen : integer; var ar,de:double; var ok:boolean); stdcall; external lib_catalog;
Procedure FindNumTYC2(id : ShortString ;var ar,de:double; var ok:boolean); stdcall; external lib_catalog;

implementation

end.
   