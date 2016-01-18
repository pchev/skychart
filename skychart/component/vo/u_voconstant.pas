unit u_voconstant;

{$MODE Delphi}

{
Copyright (C) 2002 Patrick Chevalley

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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 Type and constant declaration
}

interface

Uses Classes;

type
  TStringListArray = array of Tstringlist;
  TStringArray = array of string;
  TIntegerArray = array of integer;
  TBoolArray = array of boolean;
  Tvo_source=(Vizier,NVO);
  Tvo_type=(VizierMeta,ConeSearch);

type
  TDownloadFeedback = procedure (txt:string) of object;

  const
  tab=#09;
  //vo_fullmaxrecord = 50000;
  vo_list: array [Tvo_source] of string = ('vo_vizier_list.xml','');
  vo_types: array [Tvo_source] of Tvo_type=(VizierMeta,ConeSearch);
  vo_meta = 'vo_meta.xml';
  vo_maxurl=10;
//      http://vizier.u-strasbg.fr/viz-bin/votable?-source=*&-meta&-meta.max=100000
  vo_url: array [Tvo_source,1..vo_maxurl,1..2] of string = ((
  ('http://vizier.u-strasbg.fr/viz-bin/votable?','VizieR at CDS - Strasbourg, France'),
  ('http://vizier.cfa.harvard.edu/viz-bin/votable?','VizieR at CFA Harvard - USA'),
  ('http://vizier.hia.nrc.ca/viz-bin/votable?','VizieR at CADC - Canada'),
  ('http://vizier.nao.ac.jp/viz-bin/votable?','VizieR at ADAC - Tokyo, Japan'),
  ('http://urania.iucaa.ernet.in/viz-bin/votable?','VizieR at IUCAA - Pune, India'),
  ('http://data.bao.ac.cn/viz-bin/votable?','VizieR at Bejing Obs. - China'),
  ('http://archive.ast.cam.ac.uk/viz-bin/votable?','VizieR at Cambridge - UK'),
  ('http://www.ukirt.jach.hawaii.edu/viz-bin/votable?','VizieR at JAC, Hawaii - USA'),
  ('http://vizier.inasan.ru/viz-bin/votable?','VizieR at INASAN, Moscow, Russia'),
  ('','')
  ),(
  ('',''),
  ('',''),
  ('',''),
  ('',''),
  ('',''),
  ('',''),
  ('',''),
  ('',''),
  ('',''),
  ('','')
  )
  );

implementation

end.
