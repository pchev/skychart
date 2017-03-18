program testDE;

{ Pascal version of the ephemeris test program
  This program can be used to test the computation using a testpo.xxx file
}

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp,
  uDE ;

type

  { TtestDE }

  TtestDE = class(TCustomApplication)
  protected
    procedure DoRun; override;
  private
    defn,testfn: string;
    reportall,reportquiet,reportpause: boolean;
    reporteach: integer;
    testf: TextFile;
    buf,den,dat,jed,t,c,x,coord,rcoord,errt: string;
    et,vcoord,err,err2: double;
    i,ntarg, ncent,nx, nok, nerr: integer;
    rrd: Array_5D;
  public
    procedure WriteHelp; virtual;
  end;

const  tab=chr(9);
       tolerance=1e-14;

{ TtestDE }

procedure TtestDE.DoRun;
begin
  try
  reportall:=false;
  reportquiet:=false;
  reportpause:=true;
  reporteach:=MaxInt;

  // DE file first
  defn:=ParamStr(1);
  if not FileExists(defn) then begin
    WriteHelp;
    Exit;
  end;
  testfn:=ExtractFilePath(defn)+'testpo'+ExtractFileExt(defn);

  // other parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Exit;
  end;
  if HasOption('a', 'all') then begin
    reportall:=true;
  end;
  if HasOption('q', 'quiet') then begin
    reportquiet:=true;
  end;
  if HasOption('f', 'f') then begin
    buf:=GetOptionValue('f', 'f');
    val(buf,reporteach,i);
    if i<>0 then begin
      writeln('Invalid value: ',buf);
      WriteHelp;
      Exit;
    end;
  end;
  if HasOption('t', 'testfile') then begin
    testfn:=GetOptionValue('t', 'testfile');
  end;
  if not FileExists(testfn) then begin
    writeln('File not found: ',testfn);
    WriteHelp;
    Exit;
  end;

  // Open files
  AssignFile(testf,testfn);
  reset(testf);
  init_de_file(defn);
  nok:=0;
  nerr:=0;
  // skip header
  repeat
     ReadLn(testf,buf);
     buf:=copy(buf,1,3);
  until eof(testf) or (buf='EOT');
  // main loop
  repeat
     ReadLn(testf,buf);
     // parse reference values
     den:=Copy(buf,1,3);
     Delete(buf,1,3);
     dat:=Copy(buf,1,12);
     Delete(buf,1,12);
     jed:=Copy(buf,1,10);
     Delete(buf,1,10);
     t:=Copy(buf,1,3);
     Delete(buf,1,3);
     c:=Copy(buf,1,3);
     Delete(buf,1,3);
     x:=Copy(buf,1,3);
     Delete(buf,1,3);
     coord:=buf;
     et:=StrToFloat(trim(jed));
     ntarg:=StrToInt(trim(t));
     ncent:=StrToInt(trim(c));
     nx:=StrToInt(trim(x));
     vcoord:=StrToFloat(trim(coord));
     if ntarg=15 then ncent:=0;
     // process ephemeris
     jpl_pleph(@de_eph, @de_iinfo,et,ntarg,ncent,rrd,true);
     rcoord:=format('%6.20f',[rrd[nx-1]]);
     // check value
     err:=(rrd[nx-1]-vcoord);                                   // offset error detection
     err2:=abs(rrd[nx-1]-vcoord)/(abs(rrd[nx-1])+abs(vcoord));  // % error detection
     // show error
     if (abs(err)>=tolerance)and(err2>tolerance) then begin
        inc(nerr);
        if (nerr=1)or reportall then begin
          errt:='ERROR! '+FloatToStr(err);
          writeln(jed+t+c+x+tab+coord+tab+rcoord+tab+FloatToStr(err)+tab+errt);
          if reportpause then begin
            write('[]/c/q ?');
            readln(buf);
            if buf='c' then begin reportpause:=false; reportall:=true;end;
            if buf='q' then reportall:=false;
          end;
        end;
     end
     // show OK
     else begin
       if (nok mod reporteach) = 0 then begin
          writeln(jed+t+c+x+tab+coord+tab+rcoord+tab+FloatToStr(err));
       end;
       inc(nok);
     end;
  until eof(testf);
  // close files
  close_de_file;
  CloseFile(testf);
  // final stats
  writeln('Tolerance: '+FloatToStr(tolerance));
  writeln('Test OK : '+inttostr(nok));
  writeln('Test ERR : '+inttostr(nerr));

  finally
    Terminate;
  end;
end;

procedure TtestDE.WriteHelp;
begin
  writeln;
  writeln('Usage: testDE <ephemeris file> <options>');
  writeln;
  writeln('''testDE'' requires the name of the JPL ephemeris file as a command');
  writeln('line argument.  It then looks for a ''testpo'' (test positions) file');
  writeln('in the same folder with the same extension,  and checks the positions');
  writeln('against those computed from the ephemeris.');
  writeln;
  writeln('Options:');
  writeln('   -h       Print this text');
  writeln('   -a       Report all errors,  not just the first incidence.');
  writeln('   -q       Do not report anything, only final count.');
  writeln('   -fN      Report each Nth result.  Default is to report only the first.');
  writeln('   -tFILE   Get test input data from FILE instead of the default ''testpo''.');
  writeln;
  writeln('After an error you can enter the following response:');
  writeln('   ''''  : continue, and pause at the next error if -a was given');
  writeln('   ''c'' : continue, print all errors without pause');
  writeln('   ''q'' : continue, do no print more error');
  writeln;
end;

var
  Application: TtestDE;
begin
  Application:=TtestDE.Create(nil);
  Application.Title:='testDE';
  Application.Run;
  Application.Free;
end.

