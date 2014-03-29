library catalog;
{
Copyright (C) 2000 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

{$mode objfpc}{$H+}

uses
  Classes, SysUtils,
  bscunit in 'bscunit.pas',
  gcvunit in 'gcvunit.pas',
  gpnunit in 'gpnunit.pas',
  dscat in 'dscat.pas',
  gscfits in 'gscfits.pas',
  gscunit in 'gscunit.pas',
  lbnunit in 'lbnunit.pas',
  ngcunit in 'ngcunit.pas',
  sacunit in 'sacunit.pas',
  oclunit in 'oclunit.pas',
  pgcunit in 'pgcunit.pas',
  gcmunit in 'gcmunit.pas',
  skylibcat in 'skylibcat.pas',
  gscconst in 'gscconst.pas',
  wdsunit in 'wdsunit.pas',
  ticunit in 'ticunit.pas',
  tycunit in 'tycunit.pas',
  usnoaunit in 'usnoaunit.pas',
  skyunit in 'skyunit.pas',
  rc3unit in 'rc3unit.pas',
  findunit in 'findunit.pas',
  microcat in 'microcat.pas',
  tyc2unit in 'tyc2unit.pas',
  gscc in 'gscc.pas',
  gcatunit in 'gcatunit.pas';

{$LIBPREFIX 'lib'}

exports
       SetBSCpath   {$ifdef mswindows} index  130   {$endif} ,
       OpenBSC      {$ifdef mswindows} index  129   {$endif} ,
       OpenBSCwin   {$ifdef mswindows} index  128   {$endif} ,
       ReadBSC      {$ifdef mswindows} index  127   {$endif} ,
       NextBSC      {$ifdef mswindows} index  126   {$endif} ,
       CloseBSC     {$ifdef mswindows} index  125   {$endif} ,

       SetSKYpath   {$ifdef mswindows} index  124   {$endif} ,
       OpenSKY      {$ifdef mswindows} index  123   {$endif} ,
       OpenSKYwin   {$ifdef mswindows} index  122   {$endif} ,
       ReadSKY      {$ifdef mswindows} index  121   {$endif} ,
       NextSKY      {$ifdef mswindows} index  120   {$endif} ,
       CloseSKY     {$ifdef mswindows} index  119   {$endif} ,

       SetTYCpath   {$ifdef mswindows} index   118  {$endif} ,
       OpenTYC       {$ifdef mswindows} index  117  {$endif} ,
       OpenTYCwin    {$ifdef mswindows} index  116   {$endif} ,
       ReadTYC       {$ifdef mswindows} index  115   {$endif} ,
       NextTYC       {$ifdef mswindows} index  114   {$endif} ,
       CloseTYC      {$ifdef mswindows} index  113   {$endif} ,

       SetTY2path   {$ifdef mswindows} index   112  {$endif} ,
       OpenTY2       {$ifdef mswindows} index  111   {$endif} ,
       OpenTY2win    {$ifdef mswindows} index  110   {$endif} ,
       ReadTY2       {$ifdef mswindows} index  109   {$endif} ,
       NextTY2       {$ifdef mswindows} index  108   {$endif} ,
       CloseTY2      {$ifdef mswindows} index  107   {$endif} ,

       SetTICpath   {$ifdef mswindows} index   106  {$endif} ,
       OpenTIC       {$ifdef mswindows} index  105   {$endif} ,
       OpenTICwin    {$ifdef mswindows} index  104   {$endif} ,
       ReadTIC       {$ifdef mswindows} index  103   {$endif} ,
       NextTIC       {$ifdef mswindows} index  102   {$endif} ,
       CloseTIC      {$ifdef mswindows} index  101   {$endif} ,

       SetGSCpath   {$ifdef mswindows} index   100  {$endif} ,
       OpenGSC       {$ifdef mswindows} index   99  {$endif} ,
       OpenGSCwin    {$ifdef mswindows} index   98  {$endif} ,
       ReadGSC       {$ifdef mswindows} index   97  {$endif} ,
       NextGSC       {$ifdef mswindows} index   96  {$endif} ,
       CloseGSC      {$ifdef mswindows} index   95  {$endif} ,

       SetGSCFpath   {$ifdef mswindows} index   94  {$endif} ,
       OpenGSCF       {$ifdef mswindows} index  93   {$endif} ,
       OpenGSCFwin    {$ifdef mswindows} index  92   {$endif} ,
       ReadGSCF       {$ifdef mswindows} index  91   {$endif} ,
       CloseGSCF      {$ifdef mswindows} index  90   {$endif} ,

       SetGSCCpath   {$ifdef mswindows} index   89  {$endif} ,
       OpenGSCC       {$ifdef mswindows} index  88   {$endif} ,
       OpenGSCCwin    {$ifdef mswindows} index  87   {$endif} ,
       ReadGSCC       {$ifdef mswindows} index  86   {$endif} ,
       NextGSCC       {$ifdef mswindows} index  85   {$endif} ,
       CloseGSCC      {$ifdef mswindows} index  84   {$endif} ,

       SetUSNOApath   {$ifdef mswindows} index 83    {$endif} ,
       OpenUSNOA     {$ifdef mswindows} index  82   {$endif} ,
       OpenUSNOAwin  {$ifdef mswindows} index  81   {$endif} ,
       ReadUSNOA     {$ifdef mswindows} index  80   {$endif} ,
       CloseUSNOA    {$ifdef mswindows} index  79   {$endif} ,

       SetMCTpath   {$ifdef mswindows} index  78   {$endif} ,
       OpenMCT     {$ifdef mswindows} index   77  {$endif} ,
       OpenMCTwin  {$ifdef mswindows} index   76  {$endif} ,
       ReadMCT     {$ifdef mswindows} index   75  {$endif} ,
       CloseMCT    {$ifdef mswindows} index   74  {$endif} ,

       SetGCVpath   {$ifdef mswindows} index   73  {$endif} ,
       OpenGCV       {$ifdef mswindows} index  72   {$endif} ,
       OpenGCVwin    {$ifdef mswindows} index  71   {$endif} ,
       ReadGCV       {$ifdef mswindows} index  70   {$endif} ,
       NextGCV       {$ifdef mswindows} index  69   {$endif} ,
       CloseGCV      {$ifdef mswindows} index  68   {$endif} ,

       SetWDSpath   {$ifdef mswindows} index   67  {$endif} ,
       OpenWDS       {$ifdef mswindows} index  66   {$endif} ,
       OpenWDSwin    {$ifdef mswindows} index  65   {$endif} ,
       ReadWDS       {$ifdef mswindows} index  64   {$endif} ,
       NextWDS       {$ifdef mswindows} index  63   {$endif} ,
       CloseWDS      {$ifdef mswindows} index  62   {$endif} ,

       SetSACpath   {$ifdef mswindows} index   61  {$endif} ,
       OpenSAC       {$ifdef mswindows} index  60   {$endif} ,
       OpenSACwin    {$ifdef mswindows} index  59   {$endif} ,
       ReadSAC       {$ifdef mswindows} index  58   {$endif} ,
       CloseSAC      {$ifdef mswindows} index  57   {$endif} ,

       SetNGCpath   {$ifdef mswindows} index   56  {$endif} ,
       OpenNGC       {$ifdef mswindows} index  55   {$endif} ,
       OpenNGCwin    {$ifdef mswindows} index  54   {$endif} ,
       ReadNGC       {$ifdef mswindows} index  53   {$endif} ,
       CloseNGC      {$ifdef mswindows} index  52   {$endif} ,

       SetLBNpath   {$ifdef mswindows} index   51  {$endif} ,
       OpenLBN       {$ifdef mswindows} index  50   {$endif} ,
       OpenLBNwin    {$ifdef mswindows} index  49   {$endif} ,
       ReadLBN       {$ifdef mswindows} index  48   {$endif} ,
       CloseLBN      {$ifdef mswindows} index  47   {$endif} ,

       SetRC3path   {$ifdef mswindows} index   46  {$endif} ,
       OpenRC3       {$ifdef mswindows} index  45   {$endif} ,
       OpenRC3win    {$ifdef mswindows} index  44   {$endif} ,
       ReadRC3       {$ifdef mswindows} index  43   {$endif} ,
       CloseRC3      {$ifdef mswindows} index  42   {$endif} ,

       SetPGCpath   {$ifdef mswindows} index   41  {$endif} ,
       OpenPGC       {$ifdef mswindows} index  40   {$endif} ,
       OpenPGCwin    {$ifdef mswindows} index  39   {$endif} ,
       ReadPGC       {$ifdef mswindows} index  38   {$endif} ,
       ClosePGC      {$ifdef mswindows} index  37   {$endif} ,

       SetOCLpath   {$ifdef mswindows} index   36  {$endif} ,
       OpenOCL       {$ifdef mswindows} index  35   {$endif} ,
       OpenOCLwin    {$ifdef mswindows} index  34   {$endif} ,
       ReadOCL       {$ifdef mswindows} index  33   {$endif} ,
       CloseOCL      {$ifdef mswindows} index  32   {$endif} ,

       SetGCMpath   {$ifdef mswindows} index  31   {$endif} ,
       OpenGCM       {$ifdef mswindows} index  30   {$endif} ,
       OpenGCMwin    {$ifdef mswindows} index  29   {$endif} ,
       ReadGCM       {$ifdef mswindows} index  28   {$endif} ,
       CloseGCM      {$ifdef mswindows} index  27   {$endif} ,

       SetDSpath   {$ifdef mswindows} index    146  {$endif} ,
       OpenDSTYC      {$ifdef mswindows} index   145  {$endif} ,
       OpenDSTYCwin   {$ifdef mswindows} index   144  {$endif} ,
       ReadDSTYC      {$ifdef mswindows} index   143  {$endif} ,
       NextDSTYC      {$ifdef mswindows} index   142  {$endif} ,
       CloseDSTYC     {$ifdef mswindows} index   141  {$endif} ,
       OpenDSGSC      {$ifdef mswindows} index   140  {$endif} ,
       OpenDSGSCwin   {$ifdef mswindows} index   139  {$endif} ,
       ReadDSGSC      {$ifdef mswindows} index   138  {$endif} ,
       NextDSGSC      {$ifdef mswindows} index   137  {$endif} ,
       CloseDSGSC     {$ifdef mswindows} index   136  {$endif} ,
       OpenDSbase      {$ifdef mswindows} index  135   {$endif} ,
       OpenDSbasewin   {$ifdef mswindows} index  134   {$endif} ,
       ReadDSbase      {$ifdef mswindows} index  133   {$endif} ,
       CloseDSbase     {$ifdef mswindows} index  132   {$endif} ,

       SetGCatpath    {$ifdef mswindows} index  147   {$endif} ,
       OpenGCat       {$ifdef mswindows} index  148   {$endif} ,
       OpenGCatwin    {$ifdef mswindows} index  149   {$endif} ,
       ReadGCat       {$ifdef mswindows} index  150   {$endif} ,
       CloseGCat      {$ifdef mswindows} index  151   {$endif} ,
       GetGCatInfo    {$ifdef mswindows} index  152   {$endif} ,
       ReadGCat2      {$ifdef mswindows} index  176   {$endif} ,
       NextGCat       {$ifdef mswindows} index  177   {$endif} ,

       SetGPNpath   {$ifdef mswindows} index   26  {$endif} ,
       OpenGPN       {$ifdef mswindows} index  25   {$endif} ,
       OpenGPNwin    {$ifdef mswindows} index  24   {$endif} ,
       ReadGPN       {$ifdef mswindows} index  23   {$endif} ,
       CloseGPN      {$ifdef mswindows} index  22   {$endif} ,
       FindNumNGC    {$ifdef mswindows} index  21   {$endif} ,
       FindNumIC     {$ifdef mswindows} index  20   {$endif} ,
       FindNumMessier {$ifdef mswindows} index  19   {$endif} ,
       FindNumGCVS   {$ifdef mswindows} index  18   {$endif} ,
       FindNumGSC    {$ifdef mswindows} index  17   {$endif} ,
       FindNumGSCF   {$ifdef mswindows} index  16   {$endif} ,
       FindNumGSCC   {$ifdef mswindows} index  15   {$endif} ,
       FindNumGC     {$ifdef mswindows} index  14   {$endif} ,
       FindNumHR     {$ifdef mswindows} index  13   {$endif} ,
       FindNumBayer  {$ifdef mswindows} index  12   {$endif} ,
       FindNumFlam   {$ifdef mswindows} index  11   {$endif} ,
       FindNumHD     {$ifdef mswindows} index  10   {$endif} ,
       FindNumSAO    {$ifdef mswindows} index  9   {$endif} ,
       FindNumBD     {$ifdef mswindows} index  8   {$endif} ,
       FindNumCD     {$ifdef mswindows} index  7   {$endif} ,
       FindNumCPD    {$ifdef mswindows} index  6   {$endif} ,
       FindNumPGC    {$ifdef mswindows} index  5   {$endif} ,
       FindNumSAC    {$ifdef mswindows} index  4   {$endif} ,
       FindNumWDS    {$ifdef mswindows} index  131   {$endif} ,
       FindNumGcat   {$ifdef mswindows} index  178  {$endif} ,
       FindNumTYC2   {$ifdef mswindows} index  179  {$endif} ,
       InitCat      {$ifdef mswindows} index  3   {$endif} ,
       InitCatWin   {$ifdef mswindows} index  1   {$endif} ,

       IsBSCpath   {$ifdef mswindows} index  153   {$endif} ,
       IsSKYpath   {$ifdef mswindows} index  154  {$endif} ,
       IsTYCpath   {$ifdef mswindows} index   155  {$endif} ,
       IsTY2path   {$ifdef mswindows} index   156  {$endif} ,
       IsTICpath   {$ifdef mswindows} index   157  {$endif} ,
       IsGSCpath   {$ifdef mswindows} index   158  {$endif} ,
       IsGSCFpath   {$ifdef mswindows} index  159  {$endif} ,
       IsGSCCpath   {$ifdef mswindows} index  160  {$endif} ,
       IsUSNOApath   {$ifdef mswindows} index 161   {$endif} ,
       IsMCTpath   {$ifdef mswindows} index   162 {$endif} ,
       IsGCVpath   {$ifdef mswindows} index   163 {$endif} ,
       IsWDSpath   {$ifdef mswindows} index   164 {$endif} ,
       IsSACpath   {$ifdef mswindows} index   165 {$endif} ,
       IsNGCpath   {$ifdef mswindows} index   166 {$endif} ,
       IsLBNpath   {$ifdef mswindows} index   167 {$endif} ,
       IsRC3path   {$ifdef mswindows} index   168 {$endif} ,
       IsPGCpath   {$ifdef mswindows} index   169 {$endif} ,
       IsOCLpath   {$ifdef mswindows} index   170 {$endif} ,
       IsGCMpath   {$ifdef mswindows} index   171 {$endif} ,
       IsGPNpath   {$ifdef mswindows} index   172 {$endif} ,
       IsDSbasepath   {$ifdef mswindows} index    173 {$endif} ,
       IsDStycpath   {$ifdef mswindows} index    174 {$endif} ,
       IsDSgscpath   {$ifdef mswindows} index    175 {$endif};


begin
decimalseparator:='.';
end.

