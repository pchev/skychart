program cdc_xhip;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, Math;

const sep='|';
      blank='                    ';
      hipmax=125000;
      hdmax=360000;
      hrmax=10000;
var bufin, bufout, buf : string;
    fmain,fphot,fbib,fout : textfile;
    hipn,hdn,hrn,i,n,maxname:integer;
    hd: array[0..hipmax]of integer;
    bd: array[0..hipmax]of string;
    hr: array[0..hdmax]of smallint;
    fl: array[0..hdmax]of smallint;
    bayer: array[0..hdmax]of string;
    cst: array[0..hdmax]of string;
    starname: array[0..hrmax] of string;

function copyp(t1: string; first,last:integer):string;
begin
  result:=copy(t1,first,last-first+1);
end;

function capitalize(txt:string):string;
var i: integer;
    up: boolean;
    c: string;
begin
result:='';
up:=true;
for i:=1 to length(txt) do begin
  c:=copy(txt,i,1);
  if up then c:=UpperCase(c)
        else c:=LowerCase(c);
  result:=result+c;
  up:=(c=' ')or(c='-');
end;
end;                        

procedure gethdbd;
var hipmain: textfile;
    hip: integer;
begin
  for hip:=0 to hipmax do begin
    hd[hip]:=0;
    bd[hip]:='';
  end;
  AssignFile(hipmain,'hip_main.dat');
  reset(hipmain);
  while not eof(hipmain) do begin
    readln(hipmain,bufin);
    hip:=strtoint(trim(copyp(bufin,9,14))); // HIP
    buf:=copyp(bufin,391,396); // HD
    hd[hip]:=strtointdef(trim(buf),0);
    buf:='BD'+copyp(bufin,399,407); // BD
    if trim(buf)='BD' then
       buf:='CD'+copyp(bufin,410,418); // CD
    if trim(buf)='CD' then
       buf:='CP'+copyp(bufin,421,429); // CP
    if trim(buf)='CP' then buf:='';
    bd[hip]:=buf;
  end;
  closefile(hipmain);
end;

procedure getcrossid;
var crossid: textfile;
    hdid:integer;
begin
  for hdid:=0 to hdmax do begin
    fl[hdid]:=0;
    bayer[hdid]:='';
    cst[hdid]:='';
  end;
  AssignFile(crossid,'crossid_catalog.dat');
  reset(crossid);
  while not eof(crossid) do begin
    readln(crossid,bufin);
    hdid:=strtoint(trim(copyp(bufin,1,6)));      //HD
    fl[hdid]:=strtointdef(trim(copyp(bufin,65,67)),0);  //Flamsteed
    buf:=trim(copyp(bufin,69,73)); //Bayer
    buf:=StringReplace(buf,'alf','alp',[]);
    bayer[hdid]:=capitalize(buf); 
    cst[hdid]:=trim(copyp(bufin,75,77));   //Constellation
  end;
  closefile(crossid);
end;

procedure getHR;
var bsc: textfile;
    hdid:integer;
begin
  for hdid:=0 to hdmax do begin
    hr[hdid]:=0;
  end;
  AssignFile(bsc,'bsc_catalog.dat');
  reset(bsc);
  while not eof(bsc) do begin
    readln(bsc,bufin);
    buf:=trim(copyp(bufin,26,31));                      //HD
    if buf<>'' then begin
      hdid:=strtoint(buf);
      hr[hdid]:=strtointdef(trim(copyp(bufin,1,4)),0);  //HR
    end;
  end;
  closefile(bsc);
end;

procedure getStarName;
var st: textfile;
    hr,p:integer;
begin
maxname:=0;
  for hr:=0 to hrmax do begin
    starname[hr]:='';
  end;
  AssignFile(st,'starsname.dat');
  reset(st);
  while not eof(st) do begin
    readln(st,bufin);
    buf:=trim(copyp(bufin,1,6));                      //HR
    if buf<>'' then begin
      hr:=strtoint(buf);
      buf:=trim(copy(bufin,10,999));    //name
      p:=pos(';',buf);
      if p>0 then buf:=copy(buf,1,p-1);
      starname[hr]:=capitalize(buf); 
      maxname:=max(maxname,length(starname[hr]));
    end;
  end;
  closefile(st);
end;

procedure writeheader;
function copy1(t1: string; first,last:integer):string;
begin
  result:=copy(t1+blank,1,last-first+1);
end;
begin
    bufout:='';
    buf:=copyp('HIP'+blank,1,6); //HIP
    bufout:=bufout+buf+sep;
    buf:=copy('HD'+blank,1,6); //HD
    bufout:=bufout+buf+sep;
    buf:=copy('BD'+blank,1,11); //BD
    bufout:=bufout+buf+sep;
    buf:=copy('HR'+blank,1,4); //HR
    bufout:=bufout+buf+sep;
    buf:=copy('Fl'+blank,1,3); //Flamsteed
    bufout:=bufout+buf+sep;
    buf:=copy('Bayer'+blank,1,5); // Bayer
    bufout:=bufout+buf+sep;
//    buf:=copy('Cst',1,3); // Constellation
//    bufout:=bufout+buf+sep;
    buf:=copy1('Comp',8,13); //Comp
    bufout:=bufout+buf+sep;
    buf:=copy1('RA',59,70); //RA ICRS J1991.25
    bufout:=bufout+buf+sep;
    buf:=copy1('Dec',72,83); //DEC ICRS J1991.25
    bufout:=bufout+buf+sep;
    buf:=copy1('Px',85,90); //Px
    bufout:=bufout+buf+sep;
    buf:=copy1('pmRA',92,99); //pmRA
    bufout:=bufout+buf+sep;
    buf:=copy1('pmDe',101,108); //pmDe
    bufout:=bufout+buf+sep;
    buf:=copy1('SpType',238,263); //sptype
    bufout:=bufout+buf+sep;
    buf:=copy1('RV',271,277); //RV
    bufout:=bufout+buf+sep;
//    buf:=copy1('Per',37,42); //Var per
//    bufout:=bufout+buf+sep;
    buf:=copy1('mB',53,58); //mB
    bufout:=bufout+buf+sep;
    buf:=copy1('mV',60,64); //mV
    bufout:=bufout+buf+sep;
//    buf:=copy1('mR',66,70); //mR
//    bufout:=bufout+buf+sep;
    buf:=copy1('mI',72,77); //mI
    bufout:=bufout+buf+sep;
//    buf:=copy1('mJ',79,84); //mJ
//    bufout:=bufout+buf+sep;
//    buf:=copy1('mH',86,91); //mH
//    bufout:=bufout+buf+sep;
//    buf:=copy1('mK',93,98); //mK
//    bufout:=bufout+buf+sep;
    buf:=copy1('B-V',140,145); //B-V
    bufout:=bufout+buf+sep;
    buf:=copy1('Cst',8,10); //Const
    bufout:=bufout+buf+sep;
//    buf:=copy1('Name'+blank+blank,28,75); //Name
//    bufout:=bufout+buf+sep;
//    buf:=copy1('CompId',184,199); //CompId
//    bufout:=bufout+buf+sep;
    buf:=copy('Star name'+blank+blank,1,maxname); //star  name
    bufout:=bufout+buf+sep;
    writeln(fout,bufout);
end;

begin
  try
  writeln('Load hip_main.dat');
  gethdbd;
  writeln('Load crossid_catalog.dat');
  getcrossid;
  writeln('Load bsc_catalog.dat');
  gethr;
  writeln('Load starsname.dat');
  getStarName;
  AssignFile(fout,'cdc_xhip.dat');
  Rewrite(fout);
  writeheader;
  AssignFile(fmain,'xhip_main.dat');
  reset(fmain);
  AssignFile(fphot,'xhip_photo.dat');
  reset(fphot);
  AssignFile(fbib,'xhip_biblio.dat');
  reset(fbib);
  writeln('Process xhip_main.dat');
  n:=0;
  while not eof(fmain) do begin
    inc(n);
    if (n mod 10000)=0 then write('.');
    bufout:='';
    readln(fmain,bufin);
    buf:=copyp(bufin,1,6); //HIP
    bufout:=bufout+buf+sep;
    hipn:=strtoint(trim(buf));
    // cross identification
    hdn:=hd[hipn];
    if hdn>0 then buf:=inttostr(hdn) else buf:='';
    buf:=copy(buf+blank,1,6); //HD
    bufout:=bufout+buf+sep;
    buf:=copy(bd[hipn]+blank,1,11); //BD
    bufout:=bufout+buf+sep;
    i:=hr[hdn];
    if i>0 then buf:=inttostr(i) else buf:='';
    buf:=copy(buf+blank,1,4); //HR
    hrn:=i;
    bufout:=bufout+buf+sep;
    i:=fl[hdn];
    if i>0 then buf:=inttostr(i) else buf:='';
    buf:=copy(buf+blank,1,3); //Flamsteed
    bufout:=bufout+buf+sep;
    buf:=copy(bayer[hdn]+blank,1,5); // Bayer
    bufout:=bufout+buf+sep;
//    buf:=copy(cst[hdn]+blank,1,3); // Constellation
//    bufout:=bufout+buf+sep;
    //
    buf:=copyp(bufin,8,13); //Comp
    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,59,70); //RA ICRS J1991.25
    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,72,83); //DEC ICRS J1991.25
    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,85,90); //Px
    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,92,99); //pmRA
    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,101,108); //pmDe
    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,238,263); //sptype
    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,271,277); //RV
    bufout:=bufout+buf+sep;
    readln(fphot,bufin);
//    buf:=copyp(bufin,37,42); //Var per
//    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,53,58); //mB
    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,60,64); //mV
    bufout:=bufout+buf+sep;
//    buf:=copyp(bufin,66,70); //mR
//    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,72,77); //mI
    bufout:=bufout+buf+sep;
//    buf:=copyp(bufin,79,84); //mJ
//    bufout:=bufout+buf+sep;
//    buf:=copyp(bufin,86,91); //mH
//    bufout:=bufout+buf+sep;
//    buf:=copyp(bufin,93,98); //mK
//    bufout:=bufout+buf+sep;
    buf:=copyp(bufin,140,145); //B-V
    bufout:=bufout+buf+sep;
    readln(fbib,bufin);
    buf:=copyp(bufin,8,10); //Const
    bufout:=bufout+buf+sep;
//    buf:=copyp(bufin,28,75); //Name
//    bufout:=bufout+buf+sep;
//    buf:=copyp(bufin,184,199); //CompId
//    bufout:=bufout+buf+sep;
    buf:=copy(Starname[hrn]+blank+blank,1,maxname); //star  name
    bufout:=bufout+buf+sep;
    writeln(fout,bufout);
  end;
  writeln;
  CloseFile(fout);
  CloseFile(fmain);
  CloseFile(fphot);
  CloseFile(fbib);
  writeln('Finished, '+inttostr(n)+' records');
  except
    on E: Exception do begin
     writeln;
     Writeln('Line '+inttostr(n)+' Error: '+E.Message);
     WriteLn(bufin);
    end;
  end;
end.

