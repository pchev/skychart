program u2conv;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type Tu2rec = packed record
              ra2000,dc2000 : integer;
              mag : smallint;
              sigx,sigy, nobs,epos,ncat,cflg : shortint;
              cepx,cepy : smallint;
              pmx,pmy : integer;
              spmx,spmy, rx,ry : shortint;
              id2m : integer;
              j2m,h2m,k2m : smallint;
              ph,cc : shortint;
     end;

var pathz, fnbase, answer, fnzone, fnout : string;
    zn,n : integer;
    u2rec : Tu2rec;
    fu2 : file of Tu2rec;
    ftxt: textfile;
    dec : double;
begin
pathz:='D:\u2\';
fnbase:='u2c';

WRITE ('pathz  = ',pathz,'   ');
READLN (answer);
if (trim(answer)<>'') then pathz := answer;
writeln;
WRITE ('fnbase = ',fnbase,'   ');
READLN (answer);
if (trim(answer)<>'') then fnbase := answer;
writeln;
WRITELN ('exit with zn less equal 0');
repeat
 WRITE ('zn = ');
 READLN (zn);
 if zn <=0 then break;
 fnzone := Format('%sz%3.3d', [pathz,zn]);
 fnout := Format('%s%3.3d', [fnbase,zn]);
 if fileexists(fnzone) then begin
   writeln('Convert '+fnzone);
   filemode:=0;
   assignfile(fu2,fnzone);
   reset(fu2);
   assignfile(ftxt,fnout);
   rewrite(ftxt);
   n:=0;
   repeat
     inc(n);
     read(fu2,u2rec);
     dec:=(pi/180) * u2rec.dc2000 / 3.6E6 ;
     u2rec.pmx:=round(10*(cos(dec)*u2rec.pmx/10));
     writeln(ftxt,format('%10d%11d%5d%4d%4d%3d%3d%3d%3d%6d%6d%8d%6d%4d%4d%4d%4d%11d%6d%6d%6d%4d%4d',
                  [u2rec.ra2000,
                   u2rec.dc2000,
                   u2rec.mag,
                   u2rec.sigx+127,
                   u2rec.sigy+127,
                   u2rec.nobs,
                   u2rec.epos+127,
                   u2rec.ncat,
                   u2rec.cflg,
                   u2rec.cepx,
                   u2rec.cepy,
                   u2rec.pmx,
                   u2rec.pmy,
                   u2rec.spmx+127,
                   u2rec.spmy+127,
                   u2rec.rx+127,
                   u2rec.ry+127,
                   u2rec.id2m,
                   u2rec.j2m,
                   u2rec.h2m,
                   u2rec.k2m,
                   u2rec.ph+127,
                   u2rec.cc+127
                  ]));
   until eof(fu2);
   closefile(ftxt);
   closefile(fu2);
   writeln('Number of stars : '+inttostr(n));
 end else
   WRITELN('File '+fnzone+' not found!');
until false;

end.
