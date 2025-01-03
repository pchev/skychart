unit u_grappavar;

{
  This program is based on example code by Marc Serrau.
  It access an extract of the GAIA DR3 variability table formated for easy access by Marc Serrau
  Please read: http://www.astrosurf.com/noctambule/GRAPPA3E_FrEn.html

  The GRAPPAVar.dat file contains 9543807 records under a compact form with informations which
  permit to know if a source is seen as variable after Gaia analysis.
  TGRAPPAVar below describe this record.
}

{$mode ObjFPC}{$H+}

interface

uses  u_util,
  Classes, SysUtils;

const
   nf_GRAPPAvar = 'GRAPPAvar.dat';
   nf_GrappaRRlyrae = 'GRAPPA_RRLyrae.dat';
   nf_GrappaCepheides = 'GRAPPA_Cepheides.dat';
   nf_Log             ='GRAPPAVar_Extracteur.log';
   max_GRAPPAVar = 9543807;
   smax_GRAPPAVar = '9543807';

   max_classe = 25;
   vari_class : Array[1..max_classe] of string = ('"ACV|CP|MCP|ROAM|ROAP|SXARI"','"ACYG"','"AGN"','"BCEP"',
                              '"BE|GCAS|SDOR|WR"','"CEP"','"CV"','"DSCT|GDOR|SXPHE"',
                              '"ECL"','"ELL"','"EP"','"LPV"','"MICROLENSING"','"RCB"','"RR"',
                              '"RS"','"S"','"SDB"','"SN"','"SOLAR_LIKE"','"SPB"','"SYST"','"WD"',
                              '"YSO"','"GALAXY"');

   procedure OpenGrappavar(dir: string);
   procedure CloseGrappavar;
   function ReadGrappavar(gaiaid: string; out info: TStringlist): boolean;

implementation

type

   TGRAPPAVar = bitpacked record
                           //         Size
                           // Unit   (byte) Definition
      Source_ID : QWord;   //          8    Unique within a particular Data Release. See https://dms.cosmos.esa.int/COSMOS/doc_fetch.php?id=2779219
      RA        : int32;   // mas      4    R.A.truncated to 1mas precision truncation: +10.123 = 10
      DEC       : int32;   // mas      4    Declination+90° truncated 1 mas precision truncation: +10.123 = 10
      in_vari_classifier_result,   // 1/8   Set if present in vari_clssifier_result table
      in_vari_rrlyrae,             // 1/8   Set if present in vari_rrlyrae table
      in_vari_cepheid,             // 1/8   Set if present in vari_cepheid table
      in_vari_planetary_transit,   // 1/8   Set if present in vari_planetary_transit table
      in_vari_short_time_scale,    // 1/8   Set if present in vari_short_time_scale table
      in_vari_long_period_variable,// 1/8   Set if present in vari_long_period_variable table
      in_vari_eclipsing_binary,    // 1/8   Set if present in vari_eclipsing_binary table
      in_vari_rotation_modulation, // 1/8   Set if present in vari_rotation_modulation table
      in_vari_ms_ocillator,        // 1/8   Set if present in vari_ms_ocillator table
      in_vari_agn,                 // 1/8   Set if present in vari_agn table
      in_vari_microlens,           // 1/8   Set if present in vari_microlens table
      in_vari_compact_companion,   // 1/8   Set if present in vari_compact_companion table
      dummy1,dummy2,dummy3,dummy4   : boolean;

      num_selected_g_fov,
      min_mag_g_fov,max_mag_g_fov,mean_mag_g_fov,median_mag_g_fov,    // magnitude*1000
      num_selected_bp,
      min_mag_bp,max_mag_bp,mean_mag_bp,median_mag_bp,                // magnitude*1000
      num_selected_rp,
      min_mag_rp,max_mag_rp,mean_mag_rp,median_mag_rp  : smallint;    // magnitude*1000

      best_class_score : byte;
      best_class_name  : shortInt;

   end;

var
   RRLyrae_ok,Cepheides_ok : boolean;
   GrappavarOpen : boolean = false;
   fGRAPPAVar : file of TGRAPPAVar;
   GRAPPAVar : TGRAPPAVar;

procedure OpenGrappavar(dir: string);
// parameter is the directory where to find the file
begin
try
  if GrappavarOpen then exit;

  RRLyrae_ok:=false;
  Cepheides_ok:=false;

  // Open the file for direct record access
  if FileExists(slash(dir)+nf_GrappaVar) then begin
    Assignfile(fGRAPPAVar,slash(dir)+nf_GrappaVar);
    reset(fGRAPPAVar);
    GrappavarOpen:=true;
  end;
except
  GrappavarOpen:=false;
end;
end;

procedure CloseGrappavar;
begin
try
  if GrappavarOpen then begin
    CloseFile(fGRAPPAVar);
    GrappavarOpen:=false;
  end;
except
  GrappavarOpen:=false;
end;
end;

function ReadGrappavar(gaiaid: string; out info: TStringlist): boolean;
var
   Source_ID         : QWord;
   code,k            : integer;
   index,deb,fin     : longint;
   trouve            : boolean;
   sIndex,sRA,sDEC,sScore,
   s1,s2,s3,s4,s5,table    : string;
begin
try
  result:=false;
  if not GrappavarOpen then
    exit;
  trouve:=false;
  Val(gaiaid,Source_id,code);
  if code<>0 then
     exit
  else
  begin
     index:=1;
     // Read directly from the file to not use too much memory
     Seek(fGRAPPAVar,index-1);
     read(fGrappaVar,GRAPPAVar);
     if source_ID=GRAPPAVar.Source_ID then trouve:=true
     else
     begin
        index:=max_GRAPPAVar;
        Seek(fGRAPPAVar,index-1);
        read(fGrappaVar,GRAPPAVar);
        if source_ID=GRAPPAVar.Source_ID then trouve:=true
        else
        // On effectue une recherche par dicotomie :
        begin
           deb:=1; fin:=max_GRAPPAVar;
           k:=0;
           repeat
              index:=(deb+fin) div 2;
              Seek(fGRAPPAVar,index-1);
              read(fGrappaVar,GRAPPAVar);
              if source_ID=GRAPPAVar.Source_ID then trouve:=true
              else
              begin
                 if GRAPPAVar.Source_ID<Source_id then deb:=index
                 else fin:=index;
                 inc(k);
              end;
           until trouve or (k>25);;
        end;
     end;
     Str(Index,sIndex);
     if trouve then
     with GRAPPAVar do
     begin
        info:=TStringlist.Create; // will be free by caller
        //  Do not return the coordinates already known by CdC
        //   Str(RA/3600000:11:6,sRA);
        //   Str((DEC/3600000-90):11:7,sDEC);
        //   info.Append('Source_ID : '+gaiaid{+' trouvé à la position n°'+sIndex});
        //   info.Append('');
        //   info.Append('RA = '+sRA+'  DEC = '+sDEC);
        //   info.Append('');

        // the variable classification
        Str(best_class_score/255:5:3,SScore);
        info.Append('Classification : '+Vari_Class[best_class_name]+' score : '+sScore);

        // the GAIA photometry, return an HTML table for display in CdC
        table:='<table>';
        table:=table+'<tr><th> </th><th>nb_obs</th><th>min</th><th>max</th><th>mean</th><th>median</th></tr>';
        Str(num_selected_g_fov:3,s1);
        Str(min_mag_g_fov/1000:6:3,s2);
        Str(max_mag_g_fov/1000:6:3,s3);
        Str(mean_mag_g_fov/1000:6:3,s4);
        Str(median_mag_g_fov/1000:6:3,s5);
        table:=table+'<tr><th>G mag</th><td>'+s1+'</td><td>'+s2+'</td><td>'+s3+'</td><td>'+s4+'</td><td>'+s5+'</td></tr>';
        Str(num_selected_bp:3,s1);
        Str(min_mag_bp/1000:6:3,s2);
        Str(max_mag_bp/1000:6:3,s3);
        Str(mean_mag_bp/1000:6:3,s4);
        Str(median_mag_bp/1000:6:3,s5);
        table:=table+'<tr><th>BP mag</th><td>'+s1+'</td><td>'+s2+'</td><td>'+s3+'</td><td>'+s4+'</td><td>'+s5+'</td></tr>';
        Str(num_selected_rp:3,s1);
        Str(min_mag_rp/1000:6:3,s2);
        Str(max_mag_rp/1000:6:3,s3);
        Str(mean_mag_rp/1000:6:3,s4);
        Str(median_mag_rp/1000:6:3,s5);
        table:=table+'<tr><th>RP mag</th><td>'+s1+'</td><td>'+s2+'</td><td>'+s3+'</td><td>'+s4+'</td><td>'+s5+'</td></tr>';
        table:=table+'</table>';
        info.Append(table);

        // flags
        if in_vari_classifier_result     then info.Append('in_vari_classifier_result');
        if in_vari_rrlyrae               then info.Append('in_vari_rrlyrae');
        if in_vari_cepheid               then info.Append('in_vari_cepheid');
        if in_vari_planetary_transit     then info.Append('in_vari_planetary_transit');
        if in_vari_short_time_scale      then info.Append('in_vari_short_time_scale');
        if in_vari_long_period_variable  then info.Append('in_vari_long_period_variable');
        if in_vari_eclipsing_binary      then info.Append('in_vari_eclipsing_binary');
        if in_vari_rotation_modulation   then info.Append('in_vari_rotation_modulation');
        if in_vari_ms_ocillator          then info.Append('in_vari_ms_ocillator');
        if in_vari_agn                   then info.Append('in_vari_agn');
        if in_vari_microlens             then info.Append('in_vari_microlens');
        if in_vari_compact_companion     then info.Append('in_vari_compact_companion');

        result:=true;

     end;
  end;
except
  result:=false;
end;
end;

end.

