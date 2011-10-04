unit vocat;

{$mode objfpc}{$H+}

interface

uses  skylibcat, gcatunit, XMLRead, DOM, math, XMLConf,
  Classes, SysUtils; 

procedure SetVOCatpath(path:string);
Procedure OpenVOCat(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenVOCatwin(var ok : boolean);
Procedure ReadVOCat(var lin : GCatrec; var ok : boolean);
Procedure NextVOCat( var ok : boolean);
procedure CloseVOCat ;
function GetVOMagmax: double;

type TFieldData = class(Tobject)
     name, ucd, datatype, units, description : string;
     end;

var
   VOobject, VOname : string;
   VOCatpath : string ='';
   deffile,catfile: string;
   Defsize: integer;
   Defmag: double;
   active,VODocOK: boolean;
   drawtype: integer;
   drawcolor: integer;
   flabels: Tlabellst;
   unit_pmra, unit_pmdec, unit_size: double;
   field_pmra, field_pmdec, field_size : integer;
   catname:string;
   VOcatlist : TStringList;
   VOFields: TStringList;
   Ncat, CurCat, catversion: integer;
   emptyrec : gcatrec;
   VODoc: TXMLDocument;
   VoNode: TDOMNode;

implementation

procedure SetVOCatpath(path:string);
begin
VOCatpath:=noslash(path);
end;

function powerunit(units: string; var u:double): string;   //  power(10,x)
var e,k:string;
begin
k:=trim(units);
if copy(k,1,2)='10' then begin
   e:=Copy(k,3,2);
   k:=Copy(k,5,99);
   u:=StrToFloatDef(e,-99999);
   if u<>-99999 then u:=power(10,(u))
      else u:=0;
end
else begin
    u:=1;
    k:=units;
end;
result:=k;
end;

function angleunits(units: string): double;  // result in radian
var k:string;
    u: double;
begin
  k:=trim(units);
  k:=powerunit(k,u);
  if k='mas' then u:=u/3600/1000
  else if k='arcsec' then u:=u/3600
  else if k='arcmin' then u:=u/60
  else if k='rad' then u:=u*rad2deg
  else if k<>'deg' then u:=0;
  result:=deg2rad*u;
end;

function timeunits(units: string): double;  // result in seconds
var k:string;
    u: double;
begin
k:=trim(units);
k:=powerunit(k,u);
if (k='a') or (k='yr') then u:=u*365.25*86400
else if k='d' then u:=u*86400
else if k='h' then u:=u*3600
else if k='min' then u:=u*60
else if k<>'s' then u:=0;
result:=u;
end;

function pmunits(units: string): double;  // result in radian/year
var e,k,v:string;
    u,y: double;
    i: integer;
begin
  i:=pos('/',units);
  k:=copy(units,1,i-1);
  v:=copy(units,i+1,99);
  u:=angleunits(k);
  y:=timeunits(v)/(365.25*86400);
  if (y=0) then u:=0
     else u:=u/y;
  result:=u;
end;

Procedure InitRec;
var n : integer;
    ucd: string;
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
  emptyrec.options.ShortName:='VO';
  emptyrec.options.LongName:=VOname;
  case emptyrec.options.rectype of
  rtstar : begin
           emptyrec.star.magv:=99;
           emptyrec.star.valid[vsId]:=true;
           emptyrec.star.valid[vsComment]:=true;
           if field_pmra>=0 then emptyrec.star.valid[vsPmra]:=true;
           if field_pmdec>=0 then emptyrec.star.valid[vsPmdec]:=true;
           emptyrec.options.flabel[lOffset+vsMagv]:='No mag';
      end;
  rtneb : begin
          emptyrec.neb.valid[vnId]:=true;
          emptyrec.neb.valid[vnComment]:=true;
          emptyrec.neb.valid[vnNebtype]:=true;
          emptyrec.neb.valid[vnMag]:=true;
          emptyrec.neb.valid[vnDim1]:=true;
          emptyrec.neb.nebtype:=drawtype;
          emptyrec.neb.mag:=Defmag;
          emptyrec.neb.dim1:=Defsize;
          emptyrec.options.flabel[lOffset+vnMag]:='No mag';
          emptyrec.options.flabel[lOffset+vnDim1]:='No size';
      end;
  end;
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
var buf,e,k,v:string;
    u: double;
    i,j: integer;
    fieldnode: TDOMNode;
    fielddata: TFieldData;
    config: TXMLConfig;
begin
result:=false;
VODocOK:=false;
fillchar(EmptyRec,sizeof(GcatRec),0);
unit_pmra:=0;unit_pmdec:=0;unit_size:=0;
field_pmra:=-1;field_pmdec:=-1;field_size:=-1;
catname:=ExtractFileName(catfile);
config:=TXMLConfig.Create(nil);
config.Filename:=deffile;
VOName:=config.GetValue('name','');
VOobject:=config.GetValue('objtype',VOobject);
active:=config.GetValue('active',false);
drawtype:=config.GetValue('drawtype',14);
drawcolor:=config.GetValue('drawcolor',$FF0000);
DefSize:=config.GetValue('defsize',1);
Defmag:=config.GetValue('defmag',10);
config.free;
if active and FileExists(catfile) then begin
try
ReadXMLFile( VODoc, catfile);
VODocOK:=true;
VoNode:=VODoc.DocumentElement.FindNode('RESOURCE');
VoNode:=VoNode.FindNode('TABLE');
VoNode:=VoNode.FirstChild;
VOFields.Clear;
while Assigned(VoNode) do begin
  buf:=VoNode.NodeName;
  if buf='FIELD' then begin
    fielddata:=TFieldData.Create;
    fieldnode:=VoNode.FindNode('DESCRIPTION');
    if fieldnode<>nil then begin
       fielddata.description:=fieldnode.TextContent;
    end;
    fieldnode:=VoNode.Attributes.GetNamedItem('name');
    if fieldnode<>nil then k:=fieldnode.NodeValue;
    fielddata.name:=k;
    fieldnode:=VoNode.Attributes.GetNamedItem('ucd');
    if fieldnode<>nil then fielddata.ucd:=fieldnode.NodeValue;
    fieldnode:=VoNode.Attributes.GetNamedItem('datatype');
    if fieldnode<>nil then fielddata.datatype:=fieldnode.NodeValue;
    fieldnode:=VoNode.Attributes.GetNamedItem('unit');
    if fieldnode<>nil then fielddata.units:=fieldnode.NodeValue;
    j:=VOFields.AddObject(k,fielddata);
    if pos('pos.pm',fielddata.ucd)=1 then begin
      u:=pmunits(fielddata.units);
      if (u>0) and (pos('pos.eq.ra',fielddata.ucd)>0) then begin
          field_pmra:=j;
          unit_pmra:=u;
          flabels[lOffset+vsPmra]:=fielddata.name;
       end
       else if (u>0) and (pos('pos.eq.dec',fielddata.ucd)>0) then begin
          field_pmdec:=j;
          unit_pmdec:=u;
          flabels[lOffset+vsPmdec]:=fielddata.name;
       end;
    end;
    if pos('phys.angSize',fielddata.ucd)=1 then begin
      u:=angleunits(fielddata.units);
      if (u>0) then begin
         field_size:=j;
         unit_size:=u;
      end;
    end;
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
VODocOK:=false;
i:=findfirst(slash(VOCatpath)+'vo_'+VOobject+'_*.xml',0,fs);
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
var cell: TDOMNode;
    buf,recno: string;
    i: integer;
begin
ok:=false;
lin:=emptyrec;
if Assigned(VoNode) then begin
  cell:=VoNode.FirstChild;
  i:=0;
  recno:='*';
  case catversion of
  rtStar: begin
          lin.star.comment:=catname+tab;
          end;
  rtNeb:  begin
          lin.neb.comment:=catname+tab;
          end;
  end;
  while Assigned(cell) do begin
    buf:=cell.TextContent;
    // always ask vizier to add j2000 coordinates.   TODO: process general case coordinates
    if VOFields[i]='_RAJ2000' then lin.ra:=deg2rad*StrToFloatDef(buf,0);
    if VOFields[i]='_DEJ2000' then lin.dec:=deg2rad*StrToFloatDef(buf,0);
    if (buf<>'')and(pos('meta.record',TFieldData(VOFields.Objects[i]).ucd)=1) then recno:=buf;
    case catversion of
    rtStar: begin
            lin.star.comment:=lin.star.comment+VOFields[i]+':'+buf+' '+TFieldData(VOFields.Objects[i]).units+tab;
            if (buf<>'')and(pos('meta.id',TFieldData(VOFields.Objects[i]).ucd)=1) then begin
              if (lin.star.id='')or(pos('meta.main',TFieldData(VOFields.Objects[i]).ucd)>0) then
                  if  pos('meta.id.part',TFieldData(VOFields.Objects[i]).ucd)>0 then begin
                      if lin.star.id='' then lin.star.id:=lin.star.id+buf
                                        else lin.star.id:=lin.star.id+'-'+buf;
                  end else lin.star.id:=buf;
            end;
            if (buf<>'')and(pos('phot.mag',TFieldData(VOFields.Objects[i]).ucd)=1) then begin
              lin.star.valid[vsMagv]:=true;
              if (lin.star.magv=99)or(pos('em.opt.V',TFieldData(VOFields.Objects[i]).ucd)>0) then begin
                 lin.options.flabel[lOffset+vsMagv]:=VOFields[i];
                 lin.star.magv:=StrToFloatDef(buf,99);
              end;
            end;
            if i=field_pmra then lin.star.pmra:=StrToFloatDef(buf,0)*unit_pmra;
            if i=field_pmdec then lin.star.pmdec:=StrToFloatDef(buf,0)*unit_pmdec;
            end;
    rtNeb:  begin
            lin.neb.comment:=lin.neb.comment+VOFields[i]+':'+buf+' '+TFieldData(VOFields.Objects[i]).units+tab;
            if (buf<>'')and(pos('meta.id',TFieldData(VOFields.Objects[i]).ucd)>0) then begin
              if (lin.neb.id='')or(pos('meta.main',TFieldData(VOFields.Objects[i]).ucd)>0) then
                  if  pos('meta.id.part',TFieldData(VOFields.Objects[i]).ucd)>0 then begin
                      if lin.neb.id='' then lin.neb.id:=lin.neb.id+buf
                                        else lin.neb.id:=lin.neb.id+'-'+buf;
                  end else lin.neb.id:=buf;
            end;
            if (buf<>'')and(pos('phot.mag',TFieldData(VOFields.Objects[i]).ucd)=1) then begin
               lin.options.flabel[lOffset+vnMag]:=VOFields[i];
               lin.neb.mag:=StrToFloatDef(buf,Defmag);;
               lin.neb.valid[vnMag]:=true;
            end;
            if i=field_size then begin
               lin.neb.dim1:=StrToFloatDef(buf,Defsize);
               lin.neb.valid[vnDim1]:=true;
            end;
            if pos('src.class',TFieldData(VOFields.Objects[i]).ucd)>0 then begin
               if trim(buf)='Gx'  then lin.neb.nebtype:=1
               else if trim(buf)='OC'  then lin.neb.nebtype:=2
               else if trim(buf)='Gb'  then lin.neb.nebtype:=3
               else if trim(buf)='Pl'  then lin.neb.nebtype:=4
               else if trim(buf)='Nb'  then lin.neb.nebtype:=5
               else if trim(buf)='C+N'  then lin.neb.nebtype:=6
               else if trim(buf)='*'  then lin.neb.nebtype:=7
               else if trim(buf)='D*'  then lin.neb.nebtype:=8
               else if trim(buf)='***'  then lin.neb.nebtype:=9
               else if trim(buf)='Ast'  then lin.neb.nebtype:=10
               else if trim(buf)='Kt'  then lin.neb.nebtype:=11
               else if trim(buf)='?'  then lin.neb.nebtype:=0
               else if trim(buf)=''  then lin.neb.nebtype:=0
               else if trim(buf)='-'  then lin.neb.nebtype:=-1
               else if trim(buf)='PD'  then lin.neb.nebtype:=-1;
            end;
            end;
    end;
    cell:=cell.NextSibling;
    inc(i);
  end;
  case catversion of
  rtStar: if lin.star.id='' then lin.star.id:=recno;
  rtNeb : if lin.neb.id='' then lin.neb.id:=recno;
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
   deffile:=ChangeFileExt(catfile,'.config');
   if (CurCat>0) and VODocOK then VODoc.Free;
   ok:=ReadVOHeader;
   if (not active)or(not ok) then NextVOCat(ok);
end;
end;

procedure CloseVOCat ;
var i: integer;
begin
VOcatlist.Free;
if VODocOK then VODoc.Free;
for i:=0 to VOFields.Count-1 do VOFields.Objects[i].Free;
VOFields.Free;
Ncat:=0;
CurCat:=0;
end;

function GetVOMagmax: double;
var fs: TSearchRec;
    i: integer;
    ok: boolean;
    rec:GCatrec;
    config: TXMLConfig;
    magmax,defmag:double;
begin
result:=0;
ok:=false;
VOcatlist:=TStringList.Create;
VOFields:=TStringList.Create;
Ncat:=0;
VODocOK:=false;
i:=findfirst(slash(VOCatpath)+'vo_star_*.xml',0,fs);
while i=0 do begin
  VOcatlist.Add(fs.Name);
  inc(Ncat);
  i:=findnext(fs);
end;
findclose(fs);
CurCat:=-1;
ok:=false;
inc(CurCat);
if CurCat<Ncat then begin
   catfile:=slash(VOCatpath)+VOcatlist[CurCat];
   deffile:=ChangeFileExt(catfile,'.config');
   if (CurCat>0) and VODocOK then VODoc.Free;
   config:=TXMLConfig.Create(nil);
   config.Filename:=deffile;
   magmax:=config.GetValue('maxmag',-99);
   defmag:=config.GetValue('defmag',10);
   config.free;
   if magmax=-99 then begin
      if (CurCat>0) and VODocOK then VODoc.Free;
      ok:=ReadVOHeader;
      while ok do begin
        ReadVOCat(rec,ok);
        if rec.star.valid[vsMagv] then  magmax:=max(magmax,rec.star.magv);
      end;
      if magmax<defmag then magmax:=defmag;
      config:=TXMLConfig.Create(nil);
      config.Filename:=deffile;
      config.SetValue('maxmag',trunc(magmax));
      config.Flush;
      config.Free;
   end;
   result:=max(result,magmax);
end;
CloseVOCat;
result:=max(result,6);
result:=min(result,20);
end;

end.

