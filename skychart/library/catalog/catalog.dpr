library catalog;
{
Copyright (C) 2000 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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

uses
  SysUtils,
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

{$R *.res}

exports
       setbscpath   {$ifdef mswindows} index  130   {$endif} ,
       openbsc      {$ifdef mswindows} index  129   {$endif} ,
       openbscwin   {$ifdef mswindows} index  128   {$endif} ,
       readbsc      {$ifdef mswindows} index  127   {$endif} ,
       nextbsc      {$ifdef mswindows} index  126   {$endif} ,
       closebsc     {$ifdef mswindows} index  125   {$endif} ,

       setskypath   {$ifdef mswindows} index  124   {$endif} ,
       opensky      {$ifdef mswindows} index  123   {$endif} ,
       openskywin   {$ifdef mswindows} index  122   {$endif} ,
       readsky      {$ifdef mswindows} index  121   {$endif} ,
       nextsky      {$ifdef mswindows} index  120   {$endif} ,
       closesky     {$ifdef mswindows} index  119   {$endif} ,

       settycpath   {$ifdef mswindows} index   118  {$endif} ,
       opentyc       {$ifdef mswindows} index  117  {$endif} ,
       opentycwin    {$ifdef mswindows} index  116   {$endif} ,
       readtyc       {$ifdef mswindows} index  115   {$endif} ,
       nexttyc       {$ifdef mswindows} index  114   {$endif} ,
       closetyc      {$ifdef mswindows} index  113   {$endif} ,

       setty2path   {$ifdef mswindows} index   112  {$endif} ,
       openty2       {$ifdef mswindows} index  111   {$endif} ,
       openty2win    {$ifdef mswindows} index  110   {$endif} ,
       readty2       {$ifdef mswindows} index  109   {$endif} ,
       nextty2       {$ifdef mswindows} index  108   {$endif} ,
       closety2      {$ifdef mswindows} index  107   {$endif} ,

       setticpath   {$ifdef mswindows} index   106  {$endif} ,
       opentic       {$ifdef mswindows} index  105   {$endif} ,
       openticwin    {$ifdef mswindows} index  104   {$endif} ,
       readtic       {$ifdef mswindows} index  103   {$endif} ,
       nexttic       {$ifdef mswindows} index  102   {$endif} ,
       closetic      {$ifdef mswindows} index  101   {$endif} ,

       setgscpath   {$ifdef mswindows} index   100  {$endif} ,
       opengsc       {$ifdef mswindows} index   99  {$endif} ,
       opengscwin    {$ifdef mswindows} index   98  {$endif} ,
       readgsc       {$ifdef mswindows} index   97  {$endif} ,
       nextgsc       {$ifdef mswindows} index   96  {$endif} ,
       closegsc      {$ifdef mswindows} index   95  {$endif} ,

       setgscfpath   {$ifdef mswindows} index   94  {$endif} ,
       opengscf       {$ifdef mswindows} index  93   {$endif} ,
       opengscfwin    {$ifdef mswindows} index  92   {$endif} ,
       readgscf       {$ifdef mswindows} index  91   {$endif} ,
       closegscf      {$ifdef mswindows} index  90   {$endif} ,

       setgsccpath   {$ifdef mswindows} index   89  {$endif} ,
       opengscc       {$ifdef mswindows} index  88   {$endif} ,
       opengsccwin    {$ifdef mswindows} index  87   {$endif} ,
       readgscc       {$ifdef mswindows} index  86   {$endif} ,
       nextgscc       {$ifdef mswindows} index  85   {$endif} ,
       closegscc      {$ifdef mswindows} index  84   {$endif} ,

       setusnoapath   {$ifdef mswindows} index 83    {$endif} ,
       openusnoa     {$ifdef mswindows} index  82   {$endif} ,
       openusnoawin  {$ifdef mswindows} index  81   {$endif} ,
       readusnoa     {$ifdef mswindows} index  80   {$endif} ,
       closeusnoa    {$ifdef mswindows} index  79   {$endif} ,

       setmctpath   {$ifdef mswindows} index  78   {$endif} ,
       openmct     {$ifdef mswindows} index   77  {$endif} ,
       openmctwin  {$ifdef mswindows} index   76  {$endif} ,
       readmct     {$ifdef mswindows} index   75  {$endif} ,
       closemct    {$ifdef mswindows} index   74  {$endif} ,

       setgcvpath   {$ifdef mswindows} index   73  {$endif} ,
       opengcv       {$ifdef mswindows} index  72   {$endif} ,
       opengcvwin    {$ifdef mswindows} index  71   {$endif} ,
       readgcv       {$ifdef mswindows} index  70   {$endif} ,
       nextgcv       {$ifdef mswindows} index  69   {$endif} ,
       closegcv      {$ifdef mswindows} index  68   {$endif} ,

       setwdspath   {$ifdef mswindows} index   67  {$endif} ,
       openwds       {$ifdef mswindows} index  66   {$endif} ,
       openwdswin    {$ifdef mswindows} index  65   {$endif} ,
       readwds       {$ifdef mswindows} index  64   {$endif} ,
       nextwds       {$ifdef mswindows} index  63   {$endif} ,
       closewds      {$ifdef mswindows} index  62   {$endif} ,

       setsacpath   {$ifdef mswindows} index   61  {$endif} ,
       opensac       {$ifdef mswindows} index  60   {$endif} ,
       opensacwin    {$ifdef mswindows} index  59   {$endif} ,
       readsac       {$ifdef mswindows} index  58   {$endif} ,
       closesac      {$ifdef mswindows} index  57   {$endif} ,

       setngcpath   {$ifdef mswindows} index   56  {$endif} ,
       openngc       {$ifdef mswindows} index  55   {$endif} ,
       openngcwin    {$ifdef mswindows} index  54   {$endif} ,
       readngc       {$ifdef mswindows} index  53   {$endif} ,
       closengc      {$ifdef mswindows} index  52   {$endif} ,

       setlbnpath   {$ifdef mswindows} index   51  {$endif} ,
       openlbn       {$ifdef mswindows} index  50   {$endif} ,
       openlbnwin    {$ifdef mswindows} index  49   {$endif} ,
       readlbn       {$ifdef mswindows} index  48   {$endif} ,
       closelbn      {$ifdef mswindows} index  47   {$endif} ,

       setrc3path   {$ifdef mswindows} index   46  {$endif} ,
       openrc3       {$ifdef mswindows} index  45   {$endif} ,
       openrc3win    {$ifdef mswindows} index  44   {$endif} ,
       readrc3       {$ifdef mswindows} index  43   {$endif} ,
       closerc3      {$ifdef mswindows} index  42   {$endif} ,

       setpgcpath   {$ifdef mswindows} index   41  {$endif} ,
       openpgc       {$ifdef mswindows} index  40   {$endif} ,
       openpgcwin    {$ifdef mswindows} index  39   {$endif} ,
       readpgc       {$ifdef mswindows} index  38   {$endif} ,
       closepgc      {$ifdef mswindows} index  37   {$endif} ,

       setoclpath   {$ifdef mswindows} index   36  {$endif} ,
       openocl       {$ifdef mswindows} index  35   {$endif} ,
       openoclwin    {$ifdef mswindows} index  34   {$endif} ,
       readocl       {$ifdef mswindows} index  33   {$endif} ,
       closeocl      {$ifdef mswindows} index  32   {$endif} ,

       setgcmpath   {$ifdef mswindows} index  31   {$endif} ,
       opengcm       {$ifdef mswindows} index  30   {$endif} ,
       opengcmwin    {$ifdef mswindows} index  29   {$endif} ,
       readgcm       {$ifdef mswindows} index  28   {$endif} ,
       closegcm      {$ifdef mswindows} index  27   {$endif} ,

       setdspath   {$ifdef mswindows} index    146  {$endif} ,
       opendstyc      {$ifdef mswindows} index   145  {$endif} ,
       opendstycwin   {$ifdef mswindows} index   144  {$endif} ,
       readdstyc      {$ifdef mswindows} index   143  {$endif} ,
       nextdstyc      {$ifdef mswindows} index   142  {$endif} ,
       closedstyc     {$ifdef mswindows} index   141  {$endif} ,
       opendsgsc      {$ifdef mswindows} index   140  {$endif} ,
       opendsgscwin   {$ifdef mswindows} index   139  {$endif} ,
       readdsgsc      {$ifdef mswindows} index   138  {$endif} ,
       nextdsgsc      {$ifdef mswindows} index   137  {$endif} ,
       closedsgsc     {$ifdef mswindows} index   136  {$endif} ,
       opendsbase      {$ifdef mswindows} index  135   {$endif} ,
       opendsbasewin   {$ifdef mswindows} index  134   {$endif} ,
       readdsbase      {$ifdef mswindows} index  133   {$endif} ,
       closedsbase     {$ifdef mswindows} index  132   {$endif} ,

       setgcatpath    {$ifdef mswindows} index  147   {$endif} ,
       opengcat       {$ifdef mswindows} index  148   {$endif} ,
       opengcatwin    {$ifdef mswindows} index  149   {$endif} ,
       readgcat       {$ifdef mswindows} index  150   {$endif} ,
       closegcat      {$ifdef mswindows} index  151   {$endif} ,
       getgcatinfo    {$ifdef mswindows} index  152   {$endif} ,
       readgcat2      {$ifdef mswindows} index  176   {$endif} ,
       nextgcat       {$ifdef mswindows} index  177   {$endif} ,

       setgpnpath   {$ifdef mswindows} index   26  {$endif} ,
       opengpn       {$ifdef mswindows} index  25   {$endif} ,
       opengpnwin    {$ifdef mswindows} index  24   {$endif} ,
       readgpn       {$ifdef mswindows} index  23   {$endif} ,
       closegpn      {$ifdef mswindows} index  22   {$endif} ,
       findnumngc    {$ifdef mswindows} index  21   {$endif} ,
       findnumic     {$ifdef mswindows} index  20   {$endif} ,
       findnummessier {$ifdef mswindows} index  19   {$endif} ,
       findnumgcvs   {$ifdef mswindows} index  18   {$endif} ,
       findnumgsc    {$ifdef mswindows} index  17   {$endif} ,
       findnumgscf   {$ifdef mswindows} index  16   {$endif} ,
       findnumgscc   {$ifdef mswindows} index  15   {$endif} ,
       findnumgc     {$ifdef mswindows} index  14   {$endif} ,
       findnumhr     {$ifdef mswindows} index  13   {$endif} ,
       findnumbayer  {$ifdef mswindows} index  12   {$endif} ,
       findnumflam   {$ifdef mswindows} index  11   {$endif} ,
       findnumhd     {$ifdef mswindows} index  10   {$endif} ,
       findnumsao    {$ifdef mswindows} index  9   {$endif} ,
       findnumbd     {$ifdef mswindows} index  8   {$endif} ,
       findnumcd     {$ifdef mswindows} index  7   {$endif} ,
       findnumcpd    {$ifdef mswindows} index  6   {$endif} ,
       findnumpgc    {$ifdef mswindows} index  5   {$endif} ,
       findnumsac    {$ifdef mswindows} index  4   {$endif} ,
       findnumwds    {$ifdef mswindows} index  131   {$endif} ,
       findnumgcat   {$ifdef mswindows} index  178  {$endif} ,
       findnumtyc2   {$ifdef mswindows} index  179  {$endif} ,
       initcat      {$ifdef mswindows} index  3   {$endif} ,
       SetCatLang   {$ifdef mswindows} index  2  {$endif} ,
       initcatwin   {$ifdef mswindows} index  1   {$endif} ,

       isbscpath   {$ifdef mswindows} index  153   {$endif} ,
       isskypath   {$ifdef mswindows} index  154  {$endif} ,
       istycpath   {$ifdef mswindows} index   155  {$endif} ,
       isty2path   {$ifdef mswindows} index   156  {$endif} ,
       isticpath   {$ifdef mswindows} index   157  {$endif} ,
       isgscpath   {$ifdef mswindows} index   158  {$endif} ,
       isgscfpath   {$ifdef mswindows} index  159  {$endif} ,
       isgsccpath   {$ifdef mswindows} index  160  {$endif} ,
       isusnoapath   {$ifdef mswindows} index 161   {$endif} ,
       ismctpath   {$ifdef mswindows} index   162 {$endif} ,
       isgcvpath   {$ifdef mswindows} index   163 {$endif} ,
       iswdspath   {$ifdef mswindows} index   164 {$endif} ,
       issacpath   {$ifdef mswindows} index   165 {$endif} ,
       isngcpath   {$ifdef mswindows} index   166 {$endif} ,
       islbnpath   {$ifdef mswindows} index   167 {$endif} ,
       isrc3path   {$ifdef mswindows} index   168 {$endif} ,
       ispgcpath   {$ifdef mswindows} index   169 {$endif} ,
       isoclpath   {$ifdef mswindows} index   170 {$endif} ,
       isgcmpath   {$ifdef mswindows} index   171 {$endif} ,
       isgpnpath   {$ifdef mswindows} index   172 {$endif} ,
       isdsbasepath   {$ifdef mswindows} index    173 {$endif} ,
       isdstycpath   {$ifdef mswindows} index    174 {$endif} ,
       isdsgscpath   {$ifdef mswindows} index    175 {$endif};


begin
decimalseparator:='.';
end.
