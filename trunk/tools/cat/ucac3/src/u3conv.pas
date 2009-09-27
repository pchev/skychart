program u3conv;

{$APPTYPE CONSOLE}
{$mode objfpc}{$H+}

//{$define debug}

uses
  {$ifdef unix}
    unix,baseunix,unixutil,
  {$endif}
  SysUtils;

type Tu3rec = packed record
            ran,spdn : integer;
            im1,im2,sigmag  : smallint;
            objt,dsf : shortint;
            sigra,sigdc : smallint;
            na1,nu1,us1,cn1 : shortint;
            cepra, cepdc : smallint;
            pmrac,pmdc : integer;
            sigpmr,sigpmd : smallint;
            id : integer;
            jmag ,hmag,kmag : smallint;
            icqflg,e2mpho : array [0..2] of shortint;
            smB,smR2,smI : smallint;
            clbl,qfB,qfR2,qfI : shortint;
            catflg : array [0..9] of shortint;
            g1, c1, leda, x2m : shortint;
            rn : integer;
     end;

var pathz, cddir, outdir, fnbase, answer, fnzone, fnout : string;
    zn,n,nn,i,pid : integer;
    nofilter, fork: boolean;
    u3rec : Tu3rec;
    fu3 : file of Tu3rec;
    ftxt: textfile;
    dec : double;
    bv : smallint;

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if (nom<>'')and(copy(result,length(nom),1)<>PathDelim) then result:=result+PathDelim;
end;

procedure ShowHelp;
begin
     writeln(' ');
     writeln('This program convert UCAC3 DVD binary zone files to formated ASCII files.');
     writeln('To process all the zones run it two time for the two side of the DVD.');
     writeln('The output format is the same as the include u3read program, with ');
     writeln('the addition of an approximate B-V index and the star name 3UCzzz-nnnnnn.');
     writeln('');
     writeln('Syntax :');
     writeln('    iconv [--cddir /cdrom] [--outdir /path/to/textfiles] [--nofilter] [--nofork]');
     writeln('Options :');
     writeln('  --cddir    : Read binary files from path /cdrom');
     writeln('  --outdir   : Write ASCII files to /path/to/textfiles');
     writeln('  --nofilter : Output all stars. Otherwise stars in Tycho2 or');
     writeln('               brighter than magnitude 10 are ignored.');
     writeln('  --nofork   : Use only one process (Unix only)');
     writeln(' ');
     Halt(1);
end;

begin
cddir:='';
outdir:='cdc';
nofilter:=false;
fork:=true;
i:=1;
if Paramcount<1 then ShowHelp;
while i <= Paramcount do begin
  if ParamStr(i)='--cddir' then begin
     inc(i);
     cddir:=ParamStr(i);
  end
  else if ParamStr(i)='--outdir' then begin
     inc(i);
     outdir:=ParamStr(i);
  end
  else if ParamStr(i)='--nofilter' then begin
     nofilter:=true;
  end
  else if ParamStr(i)='--nofork' then begin
     fork:=false;
  end
  else begin
     ShowHelp;
  end;
  inc(i);
end;

if not DirectoryExists(outdir) then ForceDirectories(outdir);
fnbase:=slash(outdir)+'3uc';
pid:=0;
i:=1;
zn:=0;
{$ifdef unix} {$ifndef debug}
if fork then begin
  i:=2;
  pid := fpFork;
  if pid = 0 then zn:=-1
             else zn:=0;
end;
{$endif} {$endif}
repeat
 inc(zn,i);
 fnzone := Format('%s%3.3d', ['z',zn]);
 fnout := Format('%s%3.3d', [fnbase,zn]);
 if fileexists(slash(cddir)+fnzone) then begin
   writeln('Convert '+fnzone);
   sleep(100);
   filemode:=0;
   assignfile(fu3,slash(cddir)+fnzone);
   reset(fu3);
   assignfile(ftxt,fnout);
   rewrite(ftxt);
   n:=0;
   nn:=0;
   repeat
     inc(n);
     read(fu3,u3rec);

     if (u3rec.smB>0)and(u3rec.smB<30000)and(u3rec.smR2>0)and(u3rec.smR2<30000) then begin
       bv:=round(u3rec.smB-(u3rec.smB+u3rec.smR2)/2);
       //bv:=round( 0.556 * (u3rec.smB - u3rec.smR2));
       //bv:=round( 0.625 * (u3rec.smB - u3rec.smR2));
     end
     else begin
       bv:=0;
     end;

     if nofilter or (
        (u3rec.im2>10000) and  // mag > 10
        (u3rec.catflg[1]=0) )  // no Tycho2 match
     then begin
        inc(nn);

    {   (i10,1x,i9,1x,2(i5,1x),i3,1x,i2,1x,
        i1,1x,2(i3,1x),2(i2,1x),2(i3,1x),2(i5,1x),
        2(i6,1x),2(i3,1x),i10,1x,3(i5,1x),3i2.2,1x,3(i3,1x),
        3(i5,1x),4(i2,1x),10i1,1x, 2i1,1x,2(i3,1x),i9)')}

        writeln(ftxt,format('%10d %9d %5d %5d %3d %2d '+
        '%1d %3d %3d %2d %2d %3d %3d %5d %5d '+
        '%6d %6d %3d %3d %10d %5d %5d %5d %2.2d%2.2d%2.2d %3d %3d %3d '+
        '%5d %5d %5d %2d %2d %2d %2d %1d%1d%1d%1d%1d%1d%1d%1d%1d%1d %1d%1d %3d %3d %9d '+
        '%5d 3UC%3.3d-%6.6d ',
        [u3rec.ran,
        u3rec.spdn,
        u3rec.im1,
        u3rec.im2,
        u3rec.sigmag,
        u3rec.objt,
        u3rec.dsf,
        u3rec.sigra,
        u3rec.sigdc,
        u3rec.na1,
        u3rec.nu1,
        u3rec.us1,
        u3rec.cn1,
        u3rec.cepra,
        u3rec.cepdc,
        u3rec.pmrac,
        u3rec.pmdc,
        u3rec.sigpmr,
        u3rec.sigpmd,
        u3rec.id,
        u3rec.jmag,
        u3rec.hmag,
        u3rec.kmag,
        u3rec.icqflg[0],
        u3rec.icqflg[1],
        u3rec.icqflg[2],
        u3rec.e2mpho[0],
        u3rec.e2mpho[1],
        u3rec.e2mpho[2],
        u3rec.smB,
        u3rec.smR2,
        u3rec.smI,
        u3rec.clbl,
        u3rec.qfB,
        u3rec.qfR2,
        u3rec.qfI,
        u3rec.catflg[0],
        u3rec.catflg[1],
        u3rec.catflg[2],
        u3rec.catflg[3],
        u3rec.catflg[4],
        u3rec.catflg[5],
        u3rec.catflg[6],
        u3rec.catflg[7],
        u3rec.catflg[8],
        u3rec.catflg[9],
        u3rec.g1,
        u3rec.c1,
        u3rec.leda,
        u3rec.x2m,
        u3rec.rn,
        bv, zn, n
        ]));
     end;
   until eof(fu3);
   closefile(ftxt);
   closefile(fu3);
   writeln(fnzone+' stars: '+inttostr(nn)+'/'+inttostr(n));
 end;
until zn>=360;

end.
