program u4conv;

{$IFDEF MSWINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
{$mode objfpc}{$H+}

//{$define debug}

uses
  {$ifdef unix}
    unix,baseunix,unixutil,
  {$endif}
  SysUtils;

// u4b binary format
type Tu4rec = packed record
            ra,spd : integer;
            magm,maga: smallint;
            sigmag,ojt,dsf,sigra,sigdc, na1,nu1,us1  : shortint;
            cepra,cepdc, pmra2,pmdc2 : smallint;
            sigpmr,sigpmd   : shortint;
            id2m : integer;
            jmag,hmag,kmag : smallint;
            icqflg, q2mflg: array[1..3] of shortint;
            apasm : array[1..5] of smallint;
            apase : array[1..5] of shortint;
            gcflg : shortint;
            mcf : integer;
            leda,x2m : shortint;
            rnm : integer;
            zn2 : smallint;
            rnz : integer;
     end;

// Data from u4i/u4hpm.dat
const dimc = 53;
      dimhpm=25;
      hpmdata: array [1..dimhpm] of string = (
'        1 644 101666   41087   31413 1140226325  463469832 20000',
'        2 644 101659   41558   32586 1140206623  463496356 20000',
'   200137 137 116044  -37758    7655  782744223   98353832 20000',
'   200168 146 160169  -36004    9521  791626208  104986234 20000',
'   200169 146 160173  -36782    4818  791647435  104997687 20000',
'   200229 167 205507   39624  -25374 1191024862  119570494 20000',
'   200400 225   5836   65051  -57308  280508696  161933702 20000',
'   200503 264    113   56347  -23377    4866423  189513494 20000',
'   200530 271 197739   67682   13275 1247280546  194928946 20000',
'   200895 412   5552  -22401  -34203  229744796  296449662 20000',
'   201050 474  68224   -7986  103281  970027471  340896207 20000',
'   201349 569  50655   22819   53694  747943453  409596036 20000',
'   201526 630  46224   -5803  -47659  597002910  453491568 20000',
'   201550 639  46031   40033  -58151  641681541  459787236 20000',
'   201567 644 101660   41683   32691 1140209282  463497987 20000',
'   201633 668  57562  -44099    9416  598928668  480696388 20000',
'   201803 725   9882   34222  -15989   61445925  521713228 20000',
'   249921 368  70335  -10015  -35427  819193958  264731578  9695',
'   249984 369  69354   -9994  -35419  819195820  265032517  9539',
'   268357 477  36219    5713  -36943  402667593  342812144  9453',
' 80118783 361   1858   32962    5639   89121794  259377955 11786',
' 93157181 412   5556  -22393  -34199  229822590  296437779 10151',
'106363470 469  47857  -37060  -11490  734876481  337245686 14457',
'110589580 486  52878  -38420  -27250  590832393  349252344 13155',
'113038183 494  48937   10990  -51230  442763714  355581607 12513');


var cddir, outdir, outdirstrk, fnbase, fnbasestrk, fnzone, fnout, fnoutstrk, buf : string;
    zn,n,i,l,badcount,badmag1,badmag2,hpmcount : integer;
//    fork: boolean;
//    pid: integer;
    u4rec : Tu4rec;
    fu4 : file of Tu4rec;
    ftxt,fs, fstrk: textfile;
    bv,b,v : integer;
    flag: smallint;
//  flag:
//    0 OK
//    1 double (ucac4 combined double star flag is non zero)
//    2 streak, the star is put on a separate directory
//    4 non apass V or ucac magnitude
//    8 dso match ( ucac4 gc flag >= 5 or leda>0 or x2m>0)
    dv : array[1..dimc] of integer;
    hpm : array[1..dimhpm,1..3] of integer;
    streaklist : array [0..100000] of integer;
    streaknum,streakpos : integer;
    isstreak: Boolean;

Function Slash(nom : string) : string;
begin
result:=trim(nom);
if (nom<>'')and(copy(result,length(nom),1)<>PathDelim) then result:=result+PathDelim;
end;

Function NoSlash(nom : string) : string;
begin
result:=trim(nom);
if copy(result,length(nom),1)=PathDelim then result:=copy(result,1,length(nom)-1);
end;

procedure ShowHelp;
begin
     writeln(' ');
     writeln('This program convert UCAC4 DVD binary zone files to formated ASCII files.');
     writeln('To process all the zones run it two time for the two side of the DVD.');
     writeln(' ');
     writeln('The output format is the same as the include u4dump program, with');
     writeln('the resolution of high proper motion, the addition of a single');
     writeln('combined flag, the best available magnitude for the chart,');
     writeln('B-V indice and the star name UCAC4-zzz-nnnnnn.');
     writeln('If the file streaklist.txt is present the streak stars are removed and put');
     writeln('on a separate directory.');
     writeln(' ');
     writeln('Syntax :');
     writeln('    u4conv [--cddir /path/to/cdrom] [--outdir /path/to/textfiles]');
     writeln('Options :');
     writeln('  --cddir    : Read binary files from path /path/to/cdrom');
     writeln('  --outdir   : Write ASCII files to /path/to/textfiles');
//     writeln('  --nofork   : Use only one process (Unix only)');
     writeln(' ');
     Halt(1);
end;

procedure sigpmrecov (i1 : shortint; var i4: integer);
//
//  recover sigma proper motion (I*1 on file) to I*4 (diff.cases)
//  120124 NZ 255 = "no data" set to PM = 50.0,  254 = PM > 40.0 mas/yr
begin
      i4 := i1; //        ! convert I*1 to I*4 (range -128..+127)
      i4 := i4 + 128; //  ! put back into range 0...255

      IF (i4 <= 250) THEN
        exit        //        ! normal case

      ELSE IF (i4 = 255) THEN  //! no data case
        i4 := 500              // ! set to 500 = 50.0 mas/yr
      ELSE IF (i4 = 254) THEN
        i4 := 450              //! >= 400, set to 450
      ELSE IF (i4 = 253) THEN
        i4 := 375              //! between 350 and 399
      ELSE IF (i4 = 252) THEN
        i4 := 325
      ELSE IF (i4 = 251) THEN
        i4 := 275
      ;

END; //  ! subr. <sigpmrecov>

// exclude stars from streaklist.txt
function findstreak(zn,n: integer):boolean;
var num: integer;
begin
 result:=false;
 if streakpos>streaknum then exit;
 num:=zn*1000000+n;
 if streaklist[streakpos]=num then begin
   result:=true;
   inc(streakpos);
 end;
end;

begin
cddir:='';
outdir:='cdc';
//fork:=true;
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
//  else if ParamStr(i)='--nofork' then begin
//     fork:=false;
//  end
  else begin
     ShowHelp;
  end;
  inc(i);
end;

outdirstrk:=trim(noslash(outdir))+'_streak';
if not DirectoryExists(outdir) then ForceDirectories(outdir);
if not DirectoryExists(outdirstrk) then ForceDirectories(outdirstrk);
fnbase:=slash(outdir)+'4uc';
fnbasestrk:=slash(outdirstrk)+'4uc';
//pid:=0;
i:=1;
zn:=0;
// high proper motion
for l:=1 to dimhpm do begin
  buf:=hpmdata[l];
  hpm[l,1]:=strtoint(trim(copy(buf,1,9)));
  hpm[l,2]:=strtoint(trim(copy(buf,23,6)));
  hpm[l,3]:=strtoint(trim(copy(buf,31,6)));
end;
// streak
streaknum:=0;
streakpos:=1;
if FileExists('streaklist.txt') then begin
   AssignFile(fs,'streaklist.txt');
   Reset(fs);
   repeat
     ReadLn(fs,buf);
     if (trim(buf)>'') then begin
       if (buf[1]='#') then writeln(buf) 
       else begin
         inc(streaknum);
         streaklist[streaknum]:=StrToInt(copy(buf,1,3))*1000000+StrToInt(copy(buf,5,6));
       end;
     end;
   until eof(fs);
   CloseFile(fs);
end;
{$ifdef unix} {$ifndef debug}
{ // fork not compatible with streak processing
if fork then begin
  i:=2;
  pid := fpFork;
  if pid = 0 then zn:=-1
             else zn:=0;
end;}
{$endif} {$endif}
badcount:=0;
badmag1:=0;
badmag2:=0;
hpmcount:=0;
// loop for all binary files
repeat
 inc(zn,i);
 fnzone := Format('%s%3.3d', ['z',zn]);
 fnout := Format('%s%3.3d', [fnbase,zn]);
 fnoutstrk := Format('%s%3.3d', [fnbasestrk,zn]);
 if fileexists(slash(cddir)+slash('u4b')+fnzone) then begin
   writeln('Convert '+fnzone);
   sleep(100);
   filemode:=0;
   assignfile(fu4,slash(cddir)+slash('u4b')+fnzone);
   reset(fu4);
   assignfile(ftxt,fnout);
   rewrite(ftxt);
   assignfile(fstrk,fnoutstrk);
   rewrite(fstrk);
   n:=0;
   // read all stars
   repeat
     inc(n);
     read(fu4,u4rec);
        dv[ 1] := u4rec.ra;
        dv[ 2] := u4rec.spd;
        dv[ 3] := u4rec.magm;
        dv[ 4] := u4rec.maga;
        dv[ 5] := u4rec.sigmag;
        dv[ 6] := u4rec.ojt;
        dv[ 7] := u4rec.dsf;
        dv[ 8] := u4rec.sigra;
        dv[ 8] := dv[8] + 128; //   ! recover 0...255 range
        dv[ 9] := u4rec.sigdc; //   !   after conversion I*1 to I*4
        dv[ 9] := dv[9] + 128;
        dv[10] := u4rec.na1;
        dv[11] := u4rec.nu1;
        dv[12] := u4rec.us1;
        dv[13] := u4rec.cepra;
        dv[14] := u4rec.cepdc;
        dv[15] := u4rec.pmra2;
        dv[16] := u4rec.pmdc2;
        sigpmrecov (u4rec.sigpmr,dv[17]);
        sigpmrecov (u4rec.sigpmd,dv[18]);
        dv[19] := u4rec.id2m;
        dv[20] := u4rec.jmag;
        dv[21] := u4rec.hmag;
        dv[22] := u4rec.kmag;
        dv[23] := u4rec.icqflg[1];
        dv[24] := u4rec.icqflg[2];
        dv[25] := u4rec.icqflg[3];
        dv[26] := u4rec.q2mflg[1];
        dv[27] := u4rec.q2mflg[2];
        dv[28] := u4rec.q2mflg[3];
        dv[29] := u4rec.apasm[1];
        dv[30] := u4rec.apasm[2];
        dv[31] := u4rec.apasm[3];
        dv[32] := u4rec.apasm[4];
        dv[33] := u4rec.apasm[5];
        dv[34] := u4rec.apase[1];
        dv[35] := u4rec.apase[2];
        dv[36] := u4rec.apase[3];
        dv[37] := u4rec.apase[4];
        dv[38] := u4rec.apase[5];
        dv[39] := u4rec.gcflg;
        buf:=Format('%9.9d',[u4rec.mcf]);
        for l:=1 to 9 do begin
           dv[39+l]:=strtoint(copy(buf,l,1));
        end;
        dv[49] := u4rec.leda;
        dv[50] := u4rec.x2m;
        dv[51] := u4rec.rnm;
        dv[52] := u4rec.zn2;
        dv[53] := u4rec.rnz;

        flag:=0;

        // get high proper motion
        if (dv[15]=32767)or(dv[16]=32767) then begin
           for l:=1 to dimhpm do begin
             if hpm[l,1]=u4rec.rnm then begin
               dv[15]:=hpm[l,2];
               dv[16]:=hpm[l,3];
               inc(hpmcount);
               break;
             end;
           end;
        end;

        if u4rec.dsf>0 then flag:=flag+1;

        // search for streak
        isstreak:=findstreak(zn,n);
        if isstreak then flag:=flag+2;

        // try to get the best B and V magn to plot the star
        b:=u4rec.apasm[1];  // APASS B
        v:=u4rec.apasm[2];  // APASS V
        if (b<20000) and (v<20000) then begin
           bv:=b-v;
        end
        else begin
           // try alternative magn
           bv:=0;
           if v=20000 then begin
             v:=u4rec.maga;  // UCAC aperture
             if v=20000 then begin
               v:=u4rec.magm;  // UCAC fit model
               if v=20000 then begin
                 flag:=flag+4;
                 badmag1:=badmag1+1;
                 v:=u4rec.apasm[3];  // APASS g
                 if v=20000 then begin
                   v:=u4rec.apasm[1];  // APASS B
                   if v=20000 then begin
                     v:=u4rec.apasm[4];  // APASS r
                     if v=20000 then begin
                       v:=u4rec.apasm[5];  // APASS i
                       if v=20000 then begin
                         badmag2:=badmag2+1;
                         v:=u4rec.jmag;  // 2MASS J
                         if v=20000 then begin
                           v:=u4rec.hmag;  // 2MASS H
                           if v=20000 then begin
                             v:=u4rec.kmag;  // 2MASS K
                             if v=20000 then v:=99000; // CdC no magnitude
                           end;
                         end;
                       end;
                     end;
                   end;
                 end;
               end;
             end;
           end;
           end;

        // is this "star" a DSO ?
        if (u4rec.gcflg>=5)or
           (u4rec.leda>0)or
           (u4rec.x2m>0)
           then flag:=flag+8;

        // write output file
        if isstreak then begin
            // streak case
            writeln(fstrk,format('%10d|%9d|%5d|%5d|%2d|%1d|'+
            '%2d|%3d|%3d|%2d|%2d|%2d|%5d|%5d|'+
            '%6d|%6d|%3d|%3d|%10d|%5d|%5d|%5d|%2d|%2d|%2d|%2d|%2d|%2d|'+
            '%5d|%5d|%5d|%5d|%5d|%3d|%3d|%3d|%3d|%3d|%2d|%1d|%1d|%1d|%1d|%1d|%1d|%1d|%1d|%1d|'+
            '%2d|%2d|%9d|%3d|%6d|'+
            '%2d|%5d|%5d|UCAC4-%3.3d-%6.6d',
            [ dv[1],dv[2],dv[3],dv[4],dv[5],dv[6],dv[7],dv[8],dv[9],
              dv[10],dv[11],dv[12],dv[13],dv[14],dv[15],dv[16],dv[17],dv[18],dv[19],
              dv[20],dv[21],dv[22],dv[23],dv[24],dv[25],dv[26],dv[27],dv[28],dv[29],
              dv[30],dv[31],dv[32],dv[33],dv[34],dv[35],dv[36],dv[37],dv[38],dv[39],
              dv[40],dv[41],dv[42],dv[43],dv[44],dv[45],dv[46],dv[47],dv[48],dv[49],
              dv[50],dv[51],dv[52],dv[53],flag,v,bv,zn,n
            ]));
            inc(badcount);
        end else begin
            // normal output
            writeln(ftxt,format('%10d|%9d|%5d|%5d|%2d|%1d|'+
            '%2d|%3d|%3d|%2d|%2d|%2d|%5d|%5d|'+
            '%6d|%6d|%3d|%3d|%10d|%5d|%5d|%5d|%2d|%2d|%2d|%2d|%2d|%2d|'+
            '%5d|%5d|%5d|%5d|%5d|%3d|%3d|%3d|%3d|%3d|%2d|%1d|%1d|%1d|%1d|%1d|%1d|%1d|%1d|%1d|'+
            '%2d|%2d|%9d|%3d|%6d|'+
            '%2d|%5d|%5d|UCAC4-%3.3d-%6.6d',
            [ dv[1],dv[2],dv[3],dv[4],dv[5],dv[6],dv[7],dv[8],dv[9],
              dv[10],dv[11],dv[12],dv[13],dv[14],dv[15],dv[16],dv[17],dv[18],dv[19],
              dv[20],dv[21],dv[22],dv[23],dv[24],dv[25],dv[26],dv[27],dv[28],dv[29],
              dv[30],dv[31],dv[32],dv[33],dv[34],dv[35],dv[36],dv[37],dv[38],dv[39],
              dv[40],dv[41],dv[42],dv[43],dv[44],dv[45],dv[46],dv[47],dv[48],dv[49],
              dv[50],dv[51],dv[52],dv[53],flag,v,bv,zn,n
            ]));
        end;
   until eof(fu4);
   // end of the zone file
   closefile(ftxt);
   closefile(fstrk);
   closefile(fu4);
   writeln(fnzone+' stars: '+inttostr(n));
 end;
// next zone
until zn>=900;

// write some reassuring statistics
writeln(' streak stars removed : '+inttostr(badcount));
writeln(' no V or UCAC magnitude : '+inttostr(badmag1));
writeln(' using 2MASS magnitude : '+inttostr(badmag2));
writeln(' high proper motion : '+inttostr(hpmcount));

end.
