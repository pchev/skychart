program cdc_xhip_hr;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  Math;

const
  sep = '|';
  blank = '                    ';
  hipmax = 125000;
  hdmax = 360000;
  hrmax = 10000;
  maxmissing = 263;

var
  bufin, bufout, bufhr, buf, buffl, bufbay: string;
  fmain, fphot, fbib, fout: textfile;
  hipn, hdn, hrn, i, n, maxname, nextmissing: integer;
  hd: array[0..hipmax] of integer;
  bd: array[0..hipmax] of string;
  hr: array[0..hdmax] of smallint;
  fl: array[0..hdmax] of smallint;
  bayer: array[0..hdmax] of string;
  cst: array[0..hdmax] of string;
  starname: array[0..hrmax] of string;

const
  hip2_missing_id: array[1..maxmissing] of
    integer = (421, 1338, 1902, 2189, 3158, 3482, 3856,
    5502, 6132, 7635, 8538, 8713, 8781, 9429, 9867,
    10270, 10659, 10689, 11692, 11829, 12103, 13235, 14275,
    14277, 14951, 16216, 16218, 17201, 18045, 18377, 18404,
    19424, 19708, 20488, 21185, 22992, 23299, 24042, 24078,
    24360, 24539, 24648, 25050, 25105, 25836, 27262, 27464,
    27981, 28121, 29119, 31067, 31132, 31153, 31157, 31437,
    31500, 31825, 31999, 32000, 32340, 32914, 34226, 34467,
    34716, 34836, 35195, 35311, 35571, 35964, 36007, 36109,
    36609, 36642, 36649, 37417, 38256, 38398, 38562, 38821,
    39753, 40272, 41110, 41397, 41405, 41884, 43283, 43329,
    43344, 43708, 43820, 43946, 44039, 44197, 45108, 45109,
    45205, 45792, 46500, 47386, 48307, 48645, 48665, 50572,
    50640, 50751, 51426, 51496, 51588, 52021, 52585, 52800,
    53310, 53573, 54144, 54171, 54353, 54812, 54948, 55203,
    55622, 55826, 56934, 57037, 58999, 59018, 59154, 59189,
    59273, 59963, 60178, 60450, 61062, 61200, 61231, 62292,
    62295, 62622, 62719, 62937, 62947, 62967, 63447, 64354,
    65863, 65908, 66187, 66677, 66747, 67616, 68059, 68588,
    68820, 69192, 69782, 70878, 70958, 71228, 72588, 72860,
    73533, 75865, 75901, 76059, 76316, 76462, 76640, 78411,
    78528, 78727, 79592, 79729, 80579, 80630, 80796, 80880,
    81402, 81538, 81694, 82021, 82899, 82904, 84915, 85778,
    86257, 86261, 86405, 87122, 87343, 87816, 88444, 88639,
    88734, 88759, 90518, 91256, 91724, 91924, 92536, 92584,
    92836, 92897, 93018, 93538, 93563, 95493, 95672, 95723,
    95811, 96005, 96073, 96108, 96410, 96569, 97202, 97237,
    97570, 98625, 98713, 98790, 98811, 98909, 99261, 99861,
    100006, 100086, 100109, 100245, 100304, 100364, 103180, 103992,
    103995, 103996, 104240, 104243, 104645, 105230, 105296, 106124,
    108291, 108802, 111277, 111293, 111432, 111606, 111858, 112316,
    112465, 112469, 112856, 114349, 115125, 115269, 117643, 120159,
    120212, 120229, 120411, 120412, 120413, 120414, 120415, 120416);

  function copyp(t1: string; First, last: integer): string;
  begin
    Result := copy(t1, First, last - First + 1);
  end;

  function copy1(t1: string; First, last: integer): string;
  begin
   Result := copy(t1 + blank, 1, last - First + 1);
  end;

  function capitalize(txt: string): string;
  var
    i: integer;
    up: boolean;
    c: string;
  begin
    Result := '';
    up := True;
    for i := 1 to length(txt) do
    begin
      c := copy(txt, i, 1);
      if up then
        c := UpperCase(c)
      else
        c := LowerCase(c);
      Result := Result + c;
      up := (c = ' ') or (c = '-');
    end;
  end;

  procedure gethdbd;
  var
    hipmain: textfile;
    hip: integer;
  begin
    for hip := 0 to hipmax do
    begin
      hd[hip] := 0;
      bd[hip] := '';
    end;
    AssignFile(hipmain, 'hip_main.dat');
    reset(hipmain);
    while not EOF(hipmain) do
    begin
      readln(hipmain, bufin);
      hip := StrToInt(trim(copyp(bufin, 9, 14))); // HIP
      buf := copyp(bufin, 391, 396); // HD
      hd[hip] := strtointdef(trim(buf), 0);
      buf := 'BD' + copyp(bufin, 399, 407); // BD
      if trim(buf) = 'BD' then
        buf := 'CD' + copyp(bufin, 410, 418); // CD
      if trim(buf) = 'CD' then
        buf := 'CP' + copyp(bufin, 421, 429); // CP
      if trim(buf) = 'CP' then
        buf := '';
      bd[hip] := buf;
    end;
    closefile(hipmain);
  end;

  procedure getcrossid;
  var
    crossid: textfile;
    hdid: integer;
  begin
    for hdid := 0 to hdmax do
    begin
      fl[hdid] := 0;
      bayer[hdid] := '';
      cst[hdid] := '';
    end;
    AssignFile(crossid, 'crossid_catalog.dat');
    reset(crossid);
    while not EOF(crossid) do
    begin
      readln(crossid, bufin);
      hdid := StrToInt(trim(copyp(bufin, 1, 6)));      //HD
      fl[hdid] := strtointdef(trim(copyp(bufin, 65, 67)), 0);  //Flamsteed
      buf := trim(copyp(bufin, 69, 73)); //Bayer
      buf := StringReplace(buf, 'alf', 'alp', []);
      bayer[hdid] := capitalize(buf);
      cst[hdid] := trim(copyp(bufin, 75, 77));   //Constellation
    end;
    closefile(crossid);
  end;

  procedure getHR;
  var
    bsc: textfile;
    hdid: integer;
  begin
    for hdid := 0 to hdmax do
    begin
      hr[hdid] := 0;
    end;
    AssignFile(bsc, 'bsc_catalog.dat');
    reset(bsc);
    while not EOF(bsc) do
    begin
      readln(bsc, bufin);
      buf := trim(copyp(bufin, 26, 31));                      //HD
      if buf <> '' then
      begin
        hdid := StrToInt(buf);
        hr[hdid] := strtointdef(trim(copyp(bufin, 1, 4)), 0);  //HR
      end;
    end;
    closefile(bsc);
  end;

  procedure getStarName;
  var
    st: textfile;
    hr, p: integer;
  begin
    maxname := 0;
    for hr := 0 to hrmax do
    begin
      starname[hr] := '';
    end;
    AssignFile(st, 'starsname.dat');
    reset(st);
    while not EOF(st) do
    begin
      readln(st, bufin);
      buf := trim(copyp(bufin, 1, 6));                      //HR
      if buf <> '' then
      begin
        hr := StrToInt(buf);
        buf := trim(copy(bufin, 10, 999));    //name
        p := pos(';', buf);
        if p > 0 then
          buf := copy(buf, 1, p - 1);
        starname[hr] := capitalize(buf);
        maxname := max(maxname, length(starname[hr]));
      end;
    end;
    closefile(st);
  end;

  procedure writeheader;
  begin
    bufout := '';
    buf := copyp('HIP' + blank, 1, 6); //HIP
    bufout := bufout + buf + sep;
    buf := copy('HD' + blank, 1, 6); //HD
    bufout := bufout + buf + sep;
    buf := copy('BD' + blank, 1, 11); //BD
    bufout := bufout + buf + sep;
    buf := copy('HR' + blank, 1, 4); //HR
    bufout := bufout + buf + sep;
    buf := copy('Fl' + blank, 1, 3); //Flamsteed
    bufout := bufout + buf + sep;
    buf := copy('Bayer' + blank, 1, 5); // Bayer
    bufout := bufout + buf + sep;
    //    buf:=copy('Cst',1,3); // Constellation
    //    bufout:=bufout+buf+sep;
    buf := copy1('Comp', 8, 13); //Comp
    bufout := bufout + buf + sep;
    buf := copy1('RA', 59, 70); //RA ICRS J1991.25
    bufout := bufout + buf + sep;
    buf := copy1('Dec', 72, 83); //DEC ICRS J1991.25
    bufout := bufout + buf + sep;
    buf := copy1('Px', 85, 90); //Px
    bufout := bufout + buf + sep;
    buf := copy1('pmRA', 92, 99); //pmRA
    bufout := bufout + buf + sep;
    buf := copy1('pmDe', 101, 108); //pmDe
    bufout := bufout + buf + sep;
    buf := copy1('SpType', 238, 263); //sptype
    bufout := bufout + buf + sep;
    buf := copy1('RV', 271, 277); //RV
    bufout := bufout + buf + sep;
    //    buf:=copy1('Per',37,42); //Var per
    //    bufout:=bufout+buf+sep;
    buf := copy1('mB', 53, 58); //mB
    bufout := bufout + buf + sep;
    buf := copy1('mV', 60, 64); //mV
    bufout := bufout + buf + sep;
    //    buf:=copy1('mR',66,70); //mR
    //    bufout:=bufout+buf+sep;
    buf := copy1('mI', 72, 77); //mI
    bufout := bufout + buf + sep;
    //    buf:=copy1('mJ',79,84); //mJ
    //    bufout:=bufout+buf+sep;
    //    buf:=copy1('mH',86,91); //mH
    //    bufout:=bufout+buf+sep;
    //    buf:=copy1('mK',93,98); //mK
    //    bufout:=bufout+buf+sep;
    buf := copy1('B-V', 140, 145); //B-V
    bufout := bufout + buf + sep;
    buf := copy1('Cst', 8, 10); //Const
    bufout := bufout + buf + sep;
    //    buf:=copy1('Name'+blank+blank,28,75); //Name
    //    bufout:=bufout+buf+sep;
    //    buf:=copy1('CompId',184,199); //CompId
    //    bufout:=bufout+buf+sep;
    buf := copy('Star name' + blank + blank, 1, maxname); //star  name
    bufout := bufout + buf + sep;
    buf := 'FlN    ' + sep + 'BaN      ';
    bufout := bufout + buf + sep;
    writeln(fout, bufout);
  end;

procedure Add_Missing;
// complete hip2 missing stars (Xi UMA...)
const fra='000.00000000';
      fde='+00.00000000;-00.00000000';
      fmag='00.00';
var
    hipmain: textfile;
    hip,k: integer;
    x:double;
begin
  AssignFile(hipmain, 'hip_main.dat');
  reset(hipmain);
  while not EOF(hipmain) do
    begin
      readln(hipmain, bufin);
      hip := StrToInt(trim(copyp(bufin, 9, 14))); // HIP
      for k:=1 to maxmissing do
        if hip=hip2_missing_id[k] then begin
          bufout:='';
          bufhr := '';
          if hip=55203 then
            writeln;
          hipn:=hip;
          buf:=copyp(bufin, 9, 14);   // HIP
          bufout := bufout + buf + sep;
          // cross identification
          hdn := hd[hipn];
          if hdn > 0 then
            buf := IntToStr(hdn)
          else
            buf := '';
          buf := copy(buf + blank, 1, 6); //HD
          bufout := bufout + buf + sep;
          buf := copy(bd[hipn] + blank, 1, 11); //BD
          bufout := bufout + buf + sep;
          i := hr[hdn];
          if i > 0 then
            buf := IntToStr(i)
          else
            buf := '';
	  
	  if buf='' then break; // only HR
	  
          buf := copy(buf + blank, 1, 4); //HR
          hrn := i;
          bufout := bufout + buf + sep;
          i := fl[hdn];
          if i > 0 then
            buf := IntToStr(i)
          else
            buf := '';
          buf := copy(buf + blank, 1, 3); //Flamsteed
          buffl := buf;
          bufout := bufout + buf + sep;
          buf := copy(bayer[hdn] + blank, 1, 5); // Bayer
          bufbay := buf;
          bufout := bufout + buf + sep;
          buf := copy1(blank, 8, 13); //Comp
          bufout := bufout + buf + sep;

          x:=StrToFloat(copyp(bufin,18,19));
          x:=x+StrToFloat(copyp(bufin,21,22))/60;
          x:=x+StrToFloat(copyp(bufin,24,28))/3600;
          x:=15*x;
          buf := formatfloat(fra,x); //RA ICRS J1991.25
          bufout := bufout + buf + sep;

          x:=StrToFloat(copyp(bufin,31,32));
          x:=x+StrToFloat(copyp(bufin,34,35))/60;
          x:=x+StrToFloat(copyp(bufin,37,40))/3600;
          if copy(bufin,30,1)='-' then x:=-x;
          buf := formatfloat(fde,x); //DEC ICRS J1991.25
          bufout := bufout + buf + sep;

          buf := copy1(blank, 85, 90); //Px
          bufout := bufout + buf + sep;
          buf := copy1(blank, 92, 99); //pmRA
          bufout := bufout + buf + sep;
          buf := copy1(blank, 101, 108); //pmDe
          bufout := bufout + buf + sep;
          buf := copy1(blank, 238, 263); //sptype
          bufout := bufout + buf + sep;
          buf := copy1(blank, 271, 277); //RV
          bufout := bufout + buf + sep;
          buf := copy1(blank, 53, 58); //mB
          bufout := bufout + buf + sep;

          buf := copyp(bufin,42,46); //mV
          bufout := bufout + buf + sep;

          buf := copy1(blank, 72, 77); //mI
          bufout := bufout + buf + sep;
          buf := copy1(blank, 140, 145); //B-V
          bufout := bufout + buf + sep;
          buf:=copy(cst[hdn]+blank,1,3);         //Const
          bufout := bufout + buf + sep;
          if hrn > 0 then
          begin
            bufbay := stringreplace(bufbay, '.', ' ', []);
            if trim(buffl) > '' then
            begin
              buffl := copy(stringreplace(buffl + buf, ' ', '', [rfreplaceall]) + '       ', 1, 7);
              bufhr := bufhr + buffl + sep;
            end
            else
              bufhr := bufhr + '       ' + sep;
            if trim(bufbay) > '' then
            begin
              bufbay := copy(stringreplace(bufbay + buf, ' ', '', [rfreplaceall]) + '         ', 1, 9);
              bufhr := bufhr + bufbay + sep;
            end
            else
              bufhr := bufhr + '         ' + sep;
          end
          else
            bufhr := bufhr + '       ' + sep + '         ' + sep;
          buf := copy(Starname[hrn] + blank + blank, 1, maxname); //star  name
          bufout := bufout + buf + sep;
          bufout := bufout + bufhr;
          writeln(fout, bufout);
          break;
        end;
  end;
  closefile(hipmain);
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
    AssignFile(fout, 'cdc_xhip_hr.dat');
    Rewrite(fout);
    writeheader;
    AssignFile(fmain, 'xhip_main.dat');
    reset(fmain);
    AssignFile(fphot, 'xhip_photo.dat');
    reset(fphot);
    AssignFile(fbib, 'xhip_biblio.dat');
    reset(fbib);
    writeln('Process xhip_main.dat');
    n := 0;
    while not EOF(fmain) do
    begin
      Inc(n);
      if (n mod 10000) = 0 then
        Write('.');
      bufout := '';
      bufhr := '';
      readln(fmain, bufin);
      buf := copyp(bufin, 1, 6); //HIP
      bufout := bufout + buf + sep;
      hipn := StrToInt(trim(buf));
      // cross identification
      hdn := hd[hipn];
      if hdn > 0 then
        buf := IntToStr(hdn)
      else
        buf := '';
      buf := copy(buf + blank, 1, 6); //HD
      bufout := bufout + buf + sep;
      buf := copy(bd[hipn] + blank, 1, 11); //BD
      bufout := bufout + buf + sep;
      i := hr[hdn];
      if i > 0 then
        buf := IntToStr(i)
      else
        buf := '';
      
      if buf='' then continue;  // only HR
      
      buf := copy(buf + blank, 1, 4); //HR
      hrn := i;
      bufout := bufout + buf + sep;
      //    if hrn>0 then bufhr:=bufhr+'HR'+buf+sep;
      i := fl[hdn];
      if i > 0 then
        buf := IntToStr(i)
      else
        buf := '';
      buf := copy(buf + blank, 1, 3); //Flamsteed
      buffl := buf;
      bufout := bufout + buf + sep;
      buf := copy(bayer[hdn] + blank, 1, 5); // Bayer
      bufbay := buf;
      bufout := bufout + buf + sep;
      buf := copyp(bufin, 8, 13); //Comp
      bufout := bufout + buf + sep;
      buf := copyp(bufin, 59, 70); //RA ICRS J1991.25
      bufout := bufout + buf + sep;
      //    if hrn>0 then bufhr:=bufhr+buf+sep;
      buf := copyp(bufin, 72, 83); //DEC ICRS J1991.25
      bufout := bufout + buf + sep;
      //    if hrn>0 then bufhr:=bufhr+buf+sep;
      buf := copyp(bufin, 85, 90); //Px
      bufout := bufout + buf + sep;
      buf := copyp(bufin, 92, 99); //pmRA
      bufout := bufout + buf + sep;
      buf := copyp(bufin, 101, 108); //pmDe
      bufout := bufout + buf + sep;
      buf := copyp(bufin, 237, 262); //sptype
      bufout := bufout + buf + sep;
      buf := copyp(bufin, 270, 276); //RV
      bufout := bufout + buf + sep;
      readln(fphot, bufin);
      //    buf:=copyp(bufin,37,42); //Var per
      //    bufout:=bufout+buf+sep;
      buf := copyp(bufin, 53, 58); //mB
      bufout := bufout + buf + sep;
      buf := copyp(bufin, 60, 64); //mV
      bufout := bufout + buf + sep;
      //    buf:=copyp(bufin,66,70); //mR
      //    bufout:=bufout+buf+sep;
      buf := copyp(bufin, 72, 77); //mI
      bufout := bufout + buf + sep;
      //    buf:=copyp(bufin,79,84); //mJ
      //    bufout:=bufout+buf+sep;
      //    buf:=copyp(bufin,86,91); //mH
      //    bufout:=bufout+buf+sep;
      //    buf:=copyp(bufin,93,98); //mK
      //    bufout:=bufout+buf+sep;
      buf := copyp(bufin, 140, 145); //B-V
      bufout := bufout + buf + sep;
      readln(fbib, bufin);
      buf := copyp(bufin, 15, 17); //Const
      bufout := bufout + buf + sep;
      if hrn > 0 then
      begin
        bufbay := stringreplace(bufbay, '.', ' ', []);
        if trim(buffl) > '' then
        begin
          buffl := copy(stringreplace(buffl + buf, ' ', '', [rfreplaceall]) + '       ', 1, 7);
          bufhr := bufhr + buffl + sep;
        end
        else
          bufhr := bufhr + '       ' + sep;
        if trim(bufbay) > '' then
        begin
          bufbay := copy(stringreplace(bufbay + buf, ' ', '', [rfreplaceall]) + '         ', 1, 9);
          bufhr := bufhr + bufbay + sep;
        end
        else
          bufhr := bufhr + '         ' + sep;
      end
      else
        bufhr := bufhr + '       ' + sep + '         ' + sep;
      //    buf:=copyp(bufin,28,75); //Name
      //    bufout:=bufout+buf+sep;
      //    buf:=copyp(bufin,184,199); //CompId
      //    bufout:=bufout+buf+sep;
      buf := copy(Starname[hrn] + blank + blank, 1, maxname); //star  name
      bufout := bufout + buf + sep;
      bufout := bufout + bufhr;
      writeln(fout, bufout);
    end;
    // complete hip2 missing stars (Xi UMA...)
    writeln;
    writeln('Add 263 stars missing from HIP2');
    Add_Missing;
    CloseFile(fout);
    CloseFile(fmain);
    CloseFile(fphot);
    CloseFile(fbib);
    writeln('Finished, ' + IntToStr(n) + ' records');
  except
    on E: Exception do
    begin
      writeln;
      Writeln('Line ' + IntToStr(n) + ' Error: ' + E.Message);
      WriteLn(bufin);
    end;
  end;
end.
