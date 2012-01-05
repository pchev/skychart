unit mkposxy1;

//
// MKPOSXY1
//
// Original program by Patrick Chevalley
// Modified 02-Sep-2000, J. Burton
//
// Modified program to allow the user to use either high or low precision
// coefficients to build the elsat.pas and ixsat.pas modules that will be
// compiled into the satxy.dll.
//
// The original data files from JPL have been modified in the following
// manner(s);
//
//      Low Precision Files:
//      --------------------
//      uranus.xxxx  -  Removed the extra 2 characters from the first record.
//
//      High Precision Files:
//      ---------------------
//      mars.xxxx    -  Removed the extra character from the first record.
//
// The program expects to find the low precision data files in the \lowprec
// folder under the application folder and the high precision files in the
// \higprec folder under the application folder.  These folder names are
// stored in the prec[] array.
//

interface

uses  //elsat,ixsat,
     Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ExtCtrls;

type
     TForm1 = class(TForm)
          Button1: TButton;
          Panel1: TPanel;
          RadioGroup1: TRadioGroup;
          GroupBox1: TGroupBox;
          lblProgress: TLabel;
          opLowPrec: TRadioButton;
          opHighPrec: TRadioButton;

procedure Button1Click(Sender: TObject);

     private
          { Private declarations }
     public
          { Public declarations }
     end;

var
     Form1: TForm1;

implementation

{$R *.DFM}

type
     Tsatel = record
          t0  : double;
          cmx : array [1..6] of single;
          cfx : array [1..4] of single;
          cmy : array [1..6] of single;
          cfy : array [1..4] of single;
          end;

     Tsatix = record
          idn : array [1..8] of integer;
          freq : array [1..8] of double;
          dellt : array [1..8] of double;
          djori : double;
          ienrf : integer;    // nb. elem.
          ixa : integer;      // debut dans elem.
          end;

     Tinrec = record
          isat : char;
          idx :  array[1..3]of char;
          ldat1: array[1..8]of char;
          ldat2: array[1..8]of char;
          t0  : array[1..9]of char;
          cmx : array [1..6,1..17] of char;
          cfx : array [1..4,1..17] of char;
          cmy : array [1..6,1..17] of char;
          cfy : array [1..4,1..17] of char;
          end;

function words(str,sep : string; p,n : integer) : string;

var
     i,j : Integer;

begin
     result:='';
     str:=trim(str);

     for i:=1 to p-1 do begin
          j:=pos(' ',str);
          if j=0 then j:=length(str)+1;
          str:=trim(copy(str,j,length(str)));
     end;

     for i:=1 to n do begin
          j:=pos(' ',str);
          if j=0 then j:=length(str)+1;
          result:=result+trim(copy(str,1,j))+sep;
          str:=trim(copy(str,j,length(str)));
     end;
end;

procedure TForm1.Button1Click(Sender: TObject);

const
     lrecl = 370;
     nompla : array [1..4] of string = ('mars','jupiter','saturne','uranus');
     prec : array [1..2] of string = ('higprec','lowprec');
     nsat : array [1..4] of integer =(2,4,8,5);
     datefin = 2020;

var
     lin : array [1..lrecl] of char;
     yy,ipla,n,i,curelm,DateRange,datedeb : integer;
     f : file;
     ix : tsatix;
     el : tsatel;
     ixf,elf : textfile;
     outl, WorkFile : string;
     inrec : Tinrec;
     scmx : array [1..6] of string;
     scfx : array [1..4] of string;
     scmy : array [1..6] of string;
     scfy : array [1..4] of string;

begin

     //
     // If using the high-precision data files, set the starting date to 1995
     // or 1997 if using the low precision data.
     //
     if ophighprec.checked = true then
          datedeb:=1995
     else
          datedeb:=1997;

     assignfile(ixf,'ixsat.pas');
     assignfile(elf,'elsat.pas');

     rewrite(ixf);
     rewrite(elf);

     writeln(ixf,'unit ixsat;');
     writeln(ixf,'interface');
     writeln(ixf,'Type Tsatix = record');
     writeln(ixf,'          idn : array [1..8] of integer;');
     writeln(ixf,'          freq : array [1..8] of double;');
     writeln(ixf,'          dellt : array [1..8] of double;');
     writeln(ixf,'          djori : double;');
     writeln(ixf,'          ienrf : integer; // nb. elem.');
     writeln(ixf,'          ixa : integer; // debut dans elem.');
     writeln(ixf,'end;');
     writeln(ixf,'const');

     //
     // Check the range from the start year to finish year and write the
     // correct number of elements in the array declaration.
     //
     DateRange:=(datefin-datedeb)+1;
     writeln(ixf,'ixelem : array[1..4,1..'+inttostr(daterange)+'] of Tsatix = (');

     writeln(elf,'unit elsat;');
     writeln(elf,'interface');
     writeln(elf,'type Tsatel = record');
     writeln(elf,'                 t0  : double;');
     writeln(elf,'                 cmx : array [1..6] of single;');
     writeln(elf,'                 cfx : array [1..4] of single;');
     writeln(elf,'                 cmy : array [1..6] of single;');
     writeln(elf,'                 cfy : array [1..4] of single;');
     writeln(elf,'     end;');
     writeln(elf,'const');

     //
     // Based on which version of the data being used, insert the default
     // number of elements for the array.  The total is still commented at
     // the end of the file.
     //
     if ophighprec.checked=true then
          writeln(elf,'elem : array[1..21058] of Tsatel = (')
     else
          writeln(elf,'elem : array[1..6456] of Tsatel = (');

     curelm:=0;

     for ipla := 1 to 4 do begin
          outl:='(';
          writeln(ixf,outl);
          for yy:=datedeb to datefin do begin
               lblprogress.caption:='Processing file: '+nompla[ipla]+' '+inttostr(yy);
               form1.refresh;
               filemode:=0;
               WorkFile:=nompla[ipla]+'.'+inttostr(yy);

               //
               // Choose the folder and filename for the appropriate data file.
               //
               if ophighprec.checked = true then
                    Assignfile(f,'.\'+prec[1]+'\'+WorkFile)
               else
                    Assignfile(f,'.\'+prec[2]+'\'+WorkFile);

               reset(f,1);
               blockread(f,lin,lrecl,n);

               for i:=1 to nsat[ipla] do ix.idn[i] := strtoint(words(lin,'',i+2,1));
               for i:=1 to nsat[ipla] do ix.freq[i] := strtofloat(words(lin,'',i+2+nsat[ipla],1));
               for i:=1 to nsat[ipla] do ix.dellt[i] := strtofloat(words(lin,'',i+2+2*nsat[ipla],1));

               ix.ienrf := strtoint(words(lin,'',1+2+3*nsat[ipla],1));
               ix.djori := strtofloat(words(lin,'',2+2+3*nsat[ipla],1));
               ix.ixa :=curelm;

               if nsat[ipla]<8 then for i:=nsat[ipla]+1 to 8 do ix.idn[i] := 0;
               if nsat[ipla]<8 then for i:=nsat[ipla]+1 to 8 do ix.freq[i] := 0;
               if nsat[ipla]<8 then for i:=nsat[ipla]+1 to 8 do ix.dellt[i] := 0;

               outl:='(idn : (';

               for i:=1 to 8 do begin
                    outl:=outl+inttostr(ix.idn[i]);
                    if i=8 then
                         outl:=outl+'); freq : ('
                    else
                         outl:=outl+',';
               end;

               for i:=1 to 8 do begin
                    outl:=outl+floattostr(ix.freq[i]);
                    if i=8 then
                         outl:=outl+'); dellt : ('
                    else
                         outl:=outl+',';
               end;

               for i:=1 to 8 do begin
                    outl:=outl+floattostr(ix.dellt[i]);
                    if i=8 then
                         outl:=outl+'); '
                    else
                         outl:=outl+',';
               end;

               outl:=outl+' djori : '+floattostr(ix.djori)+'; ';
               outl:=outl+' ienrf : '+inttostr(ix.ienrf)+'; ';
               outl:=outl+' ixa : '+inttostr(ix.ixa);

               if yy=datefin then
                    if ipla=4 then
                         outl:=outl+'))'
                    else
                         outl:=outl+')),'
               else
                    outl:=outl+'),';

               writeln(ixf,'// '+WorkFile);
               writeln(ixf,outl);

               writeln(elf,'// '+WorkFile);

               repeat
                    inc(curelm);
                    blockread(f,lin,lrecl,n);
                    move(lin,inrec,sizeof(inrec));
                    el.t0 := strtofloat(inrec.t0);

                    for i:=1 to 6 do scmx[i] :=StringReplace(inrec.cmx[i],'D','E',[]);
                    for i:=1 to 4 do scfx[i] :=StringReplace(inrec.cfx[i],'D','E',[]);
                    for i:=1 to 6 do scmy[i] :=StringReplace(inrec.cmy[i],'D','E',[]);
                    for i:=1 to 4 do scfy[i] :=StringReplace(inrec.cfy[i],'D','E',[]);

                    for i:=1 to 6 do el.cmx[i] :=strtofloat(scmx[i]);
                    for i:=1 to 4 do el.cfx[i] :=strtofloat(scfx[i]);
                    for i:=1 to 6 do el.cmy[i] :=strtofloat(scmy[i]);
                    for i:=1 to 4 do el.cfy[i] :=strtofloat(scfy[i]);

                    outl:='( t0 : '+inrec.t0+' ; cmx : (';

                    for i:=1 to 6 do begin
                         outl:=outl+scmx[i];
                         if i=6 then
                              outl:=outl+'); cfx : ('
                         else
                              outl:=outl+',';
                    end;

                    for i:=1 to 4 do begin
                         outl:=outl+scfx[i];
                         if i=4 then
                              outl:=outl+'); cmy : ('
                         else
                              outl:=outl+',';
                    end;

                    for i:=1 to 6 do begin
                         outl:=outl+scmy[i];
                         if i=6 then
                              outl:=outl+'); cfy : ('
                         else
                              outl:=outl+',';
                    end;

                    for i:=1 to 4 do begin
                         outl:=outl+scfy[i];
                         if i=4 then
                              outl:=outl+')'
                         else
                              outl:=outl+',';
                    end;

                    if eof(f) then
                         if (yy=datefin) and (ipla=4) then
                              outl:=outl+'));'
                         else
                              outl:=outl+'),'
                    else
                         outl:=outl+'),';

                    writeln(elf,outl);

               until eof(f);

               closefile(f);
          end;
     end;

     writeln(ixf,');');
     writeln(ixf,'implementation');
     writeln(ixf,'end.');

     writeln(elf,'// Total elements ='+inttostr(curelm));
     writeln(elf,'implementation');
     writeln(elf,'end.');

     closefile(ixf);
     closefile(elf);

     lblprogress.caption:='Processing Complete...';

     end;

end.
