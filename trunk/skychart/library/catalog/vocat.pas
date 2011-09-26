unit vocat;

{$mode objfpc}{$H+}

interface

uses  skylibcat, gcatunit, XMLRead, DOM,
  Classes, SysUtils; 

procedure SetVOCatpath(path:string);
Procedure OpenVOCat(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenVOCatwin(var ok : boolean);
Procedure ReadVOCat(var lin : GCatrec; var ok : boolean);
Procedure NextVOCat( var ok : boolean);
procedure CloseVOCat ;

type TFieldData = class(Tobject)
     name, ucd, datatype, units : string;
     end;

var
   VOobject : string;
   VOCatpath : string ='';
   deffile,catfile: string;
   Defsize: integer;
   Defmag: double;
   flabels: Tlabellst;
   catname:string;
   VOcatlist : TStringList;
   VOFields: TStringList;
   NFields, Ncat, CurCat, catversion: integer;
   emptyrec : gcatrec;
   VODoc: TXMLDocument;
   VoNode: TDOMNode;

implementation

procedure SetVOCatpath(path:string);
begin
VOCatpath:=noslash(path);
end;

Procedure InitRec;
var n : integer;
begin
  emptyrec.options.rectype:=catversion;
  emptyrec.options.Equinox:=2000;
  emptyrec.options.EquinoxJD:=jd2000;
  JDCatalog:=emptyrec.options.EquinoxJD;
  emptyrec.options.Epoch:=2000;
  emptyrec.options.MagMax:=20;
  emptyrec.options.Size:=Defsize;
  emptyrec.options.Units:=60;
  emptyrec.options.ObjType:=1;
  emptyrec.options.LogSize:=0;
  emptyrec.options.UsePrefix:=0;
  for n:=1 to 10 do emptyrec.options.altname[n]:=false;
  emptyrec.options.flabel:=flabels;
  emptyrec.options.flabel[lOffset+vsComment]:='File';
  emptyrec.options.ShortName:='';
  emptyrec.star.magv:=-99;
{  case emptyrec.options.rectype of
  rtstar : begin  // Star 1
      if catheader.flen[3]>0 then emptyrec.star.valid[vsId]:=true;
      if catheader.flen[4]>0 then emptyrec.star.valid[vsMagV]:=true;
      if catheader.flen[5]>0 then emptyrec.star.valid[vsB_V]:=true;
      if catheader.flen[6]>0 then emptyrec.star.valid[vsMagB]:=true;
      if catheader.flen[7]>0 then emptyrec.star.valid[vsMagR]:=true;
      if catheader.flen[8]>0 then emptyrec.star.valid[vsSp]:=true;
      if catheader.flen[9]>0 then emptyrec.star.valid[vsPmra]:=true;
      if catheader.flen[10]>0 then emptyrec.star.valid[vsPmdec]:=true;
      if catheader.flen[11]>0 then emptyrec.star.valid[vsEpoch]:=true;
      if catheader.flen[12]>0 then emptyrec.star.valid[vsPx]:=true;
      if catheader.flen[13]>0 then emptyrec.star.valid[vsComment]:=true;
      end;
  rtneb : begin  // nebulae 1
      if catheader.flen[3]>0 then emptyrec.neb.valid[vnId]:=true;
      if catheader.flen[4]>0 then emptyrec.neb.valid[vnNebtype]:=true;
      if catheader.flen[5]>0 then emptyrec.neb.valid[vnMag]:=true;
      if catheader.flen[6]>0 then emptyrec.neb.valid[vnSbr]:=true;
      if catheader.flen[7]>0 then emptyrec.neb.valid[vnDim1]:=true;
      if catheader.flen[8]>0 then emptyrec.neb.valid[vnDim2]:=true;
      if catheader.flen[9]>0 then emptyrec.neb.valid[vnNebunit]:=true;
      if catheader.flen[10]>0 then emptyrec.neb.valid[vnPa]:=true;
      if catheader.flen[11]>0 then emptyrec.neb.valid[vnRv]:=true;
      if catheader.flen[12]>0 then emptyrec.neb.valid[vnMorph]:=true;
      if catheader.flen[13]>0 then emptyrec.neb.valid[vnComment]:=true;
      end;
  end; }
{  if catheader.flen[16]>0 then emptyrec.vstr[1]:=true;
  if catheader.flen[17]>0 then emptyrec.vstr[2]:=true;
  if catheader.flen[18]>0 then emptyrec.vstr[3]:=true;
  if catheader.flen[19]>0 then emptyrec.vstr[4]:=true;
  if catheader.flen[20]>0 then emptyrec.vstr[5]:=true;
  if catheader.flen[21]>0 then emptyrec.vstr[6]:=true;
  if catheader.flen[22]>0 then emptyrec.vstr[7]:=true;
  if catheader.flen[23]>0 then emptyrec.vstr[8]:=true;
  if catheader.flen[24]>0 then emptyrec.vstr[9]:=true;
  if catheader.flen[25]>0 then emptyrec.vstr[10]:=true;
  if catheader.flen[26]>0 then emptyrec.vnum[1]:=true;
  if catheader.flen[27]>0 then emptyrec.vnum[2]:=true;
  if catheader.flen[28]>0 then emptyrec.vnum[3]:=true;
  if catheader.flen[29]>0 then emptyrec.vnum[4]:=true;
  if catheader.flen[30]>0 then emptyrec.vnum[5]:=true;
  if catheader.flen[31]>0 then emptyrec.vnum[6]:=true;
  if catheader.flen[32]>0 then emptyrec.vnum[7]:=true;
  if catheader.flen[33]>0 then emptyrec.vnum[8]:=true;
  if catheader.flen[34]>0 then emptyrec.vnum[9]:=true;
  if catheader.flen[35]>0 then emptyrec.vnum[10]:=true;  }
end;

Procedure Getkeyword(s: string; var k,v:string);
var p: integer;
begin
p:=pos('=',s);
if p=0 then
  v:=s
else begin
  k:=trim(copy(s,1,p-1));
  v:=trim(copy(s,p+1,999));
end;
end;

Function ReadVOHeader: boolean;
var f: textfile;
    buf,k,v:string;
    fieldnode: TDOMNode;
    fielddata: TFieldData;
begin
result:=false;
fillchar(EmptyRec,sizeof(GcatRec),0);
catname:=ExtractFileName(catfile);
if FileExists(deffile) then begin
   AssignFile(f,deffile);
   reset(f);
   repeat
     readln(f,buf);
     Getkeyword(buf,k,v);
     if k='objtype' then VOobject:=v;
     if k='defsize' then Defsize:=StrToIntDef(v,60);
     if k='defmag' then Defmag:=StrToFloatDef(v,10);
   until eof(f);
   CloseFile(f);
end;
if FileExists(catfile) then begin
  try
  ReadXMLFile( VODoc, catfile);
  VoNode:=VODoc.DocumentElement.FindNode('RESOURCE');
  VoNode:=VoNode.FindNode('TABLE');
  VoNode:=VoNode.FirstChild;
  NFields:=0;
  VOFields.Clear;
  while Assigned(VoNode) do begin
    buf:=VoNode.NodeName;
    if buf='FIELD' then begin
      fielddata:=TFieldData.Create;
      fieldnode:=VoNode.Attributes.GetNamedItem('name');
      if fieldnode<>nil then k:=fieldnode.NodeValue;
      fielddata.name:=k;
      fieldnode:=VoNode.Attributes.GetNamedItem('ucd');
      if fieldnode<>nil then fielddata.ucd:=fieldnode.NodeValue;
      fieldnode:=VoNode.Attributes.GetNamedItem('datatype');
      if fieldnode<>nil then fielddata.datatype:=fieldnode.NodeValue;
      fieldnode:=VoNode.Attributes.GetNamedItem('unit');
      if fieldnode<>nil then fielddata.units:=fieldnode.NodeValue;
      VOFields.AddObject(k,fielddata);
    end;
    if buf='DATA' then break;
    VoNode:=VoNode.NextSibling;
  end;
  VoNode:=VoNode.FirstChild;   // TABLEDATA
  VoNode:=VoNode.FirstChild;   // first TR
  if Assigned(VoNode) then begin
    buf:=VoNode.NodeName;
    if buf='TR' then begin
      result:=true;
      if VOobject='star' then catversion:=rtStar;
      if VOobject='dso'  then catversion:=rtNeb;
      InitRec;
    end;
  end;
  except
    result:=false;
  end;
end;
end;

Procedure OpenVOCat(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
OpenVOCatwin(ok);
end;

Procedure OpenVOCatwin(var ok : boolean);
var fs: TSearchRec;
    i: integer;
begin
ok:=false;
VOcatlist:=TStringList.Create;
VOFields:=TStringList.Create;
Ncat:=0;
i:=findfirst(slash(VOCatpath)+'vo_table_'+VOobject+'_*.xml',0,fs);
while i=0 do begin
  VOcatlist.Add(fs.Name);
  inc(Ncat);
  i:=findnext(fs);
end;
findclose(fs);
CurCat:=-1;
NextVOCat(ok);
end;

Procedure ReadVOCat(var lin : GCatrec; var ok : boolean);
var row: TDOMNode;
    buf: string;
    i: integer;
begin
ok:=false;
lin:=emptyrec;
if Assigned(VoNode) then begin
  row:=VoNode.FirstChild;
  i:=0;
  case catversion of
  rtStar: begin
          lin.star.comment:=catname+tab;
          lin.star.valid[vsComment]:=true;
          end;
  rtNeb:  begin
          lin.neb.comment:=catname+tab;
          lin.neb.valid[vsComment]:=true;
          end;
  end;
  while Assigned(row) do begin
    buf:=row.TextContent;
    if VOFields[i]='_RAJ2000' then lin.ra:=deg2rad*StrToFloatDef(buf,0);
    if VOFields[i]='_DEJ2000' then lin.dec:=deg2rad*StrToFloatDef(buf,0);
    case catversion of
    rtStar: begin
            lin.star.comment:=lin.star.comment+VOFields[i]+':'+buf+tab;
            if pos('phot.mag',TFieldData(VOFields.Objects[i]).ucd)>0 then begin
              lin.star.valid[vsMagv]:=true;
              if (lin.star.magv=-99)or(pos('em.opt.V',TFieldData(VOFields.Objects[i]).ucd)>0) then begin
                 lin.options.flabel[lOffset+vsMagv]:=VOFields[i];
                 lin.star.magv:=StrToFloatDef(buf,99);
              end;
            end;
            if (buf<>'')and(pos('meta.id',TFieldData(VOFields.Objects[i]).ucd)>0) then begin
              lin.star.valid[vsId]:=true;
              if (lin.star.id='')or(pos('meta.main',TFieldData(VOFields.Objects[i]).ucd)>0) then
                  lin.star.id:=buf;
            end;
            end;
    rtNeb:  begin
            lin.neb.comment:=lin.neb.comment+VOFields[i]+':'+buf+tab;
            if pos('phot.mag',TFieldData(VOFields.Objects[i]).ucd)>0 then lin.neb.mag:=StrToFloatDef(buf,99);;
            if pos('phys.angSize',TFieldData(VOFields.Objects[i]).ucd)>0 then lin.neb.dim1:=StrToFloatDef(buf,99);
            if (buf<>'')and(pos('meta.id',TFieldData(VOFields.Objects[i]).ucd)>0) then begin
              lin.neb.valid[vsId]:=true;
              if (lin.neb.id='')or(pos('meta.main',TFieldData(VOFields.Objects[i]).ucd)>0) then
                  lin.neb.id:=buf;
            end;
            end;
    end;
    row:=row.NextSibling;
    inc(i);
  end;
  VoNode:=VoNode.NextSibling;
  ok:=true;
end;
if not ok then begin
   NextVOCat(ok);
   if ok then ReadVOCat(lin,ok);
end;
end;

Procedure NextVOCat( var ok : boolean);
begin
ok:=false;
inc(CurCat);
if CurCat<Ncat then begin
   catfile:=slash(VOCatpath)+VOcatlist[CurCat];
   deffile:=ChangeFileExt(catfile,'.def');
   ok:=ReadVOHeader;
   if (not ok) then NextVOCat(ok);
end;
end;

procedure CloseVOCat ;
var i: integer;
begin
VOcatlist.Free;
VODoc.Free;
for i:=0 to VOFields.Count-1 do VOFields.Objects[i].Free;
VOFields.Free;
Ncat:=0;
CurCat:=0;
end;

end.

