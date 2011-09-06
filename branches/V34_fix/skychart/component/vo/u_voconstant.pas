unit u_voconstant;

{$MODE Delphi}

{
Copyright (C) 2002 Patrick Chevalley

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

  const
  tab=#09;
  vo_list: array [Tvo_source] of string = ('vo_vizier_list.xml','vo_nvo_list.xml');
  vo_types: array [Tvo_source] of Tvo_type=(VizierMeta,ConeSearch);
  vo_meta = 'vo_meta.xml';
  vo_data = 'vo_data.xml';
  vo_maxurl=10;
  vo_url: array [Tvo_source,1..vo_maxurl,1..2] of string = ((
  ('http://vizier.u-strasbg.fr/cgi-bin/votable?-source=*&-meta&-meta.max=100000&-out.form=XML-VOTable(XSL)','VizieR at CDS - Strasbourg, France'),
  ('http://vizier.nao.ac.jp/viz-bin/votable?-source=*&-meta&-meta.max=100000&-out.form=XML-VOTable(XSL)','VizieR at ADAC - Tokyo, Japan'),
  ('http://vizier.hia.nrc.ca/viz-bin/votable?-source=*&-meta&-meta.max=100000&-out.form=XML-VOTable(XSL)','VizieR at CADC - Canada'),
  ('http://archive.ast.cam.ac.uk/viz-bin/votable?-source=*&-meta&-meta.max=100000&-out.form=XML-VOTable(XSL)','VizieR at Cambridge - UK'),
  ('http://urania.iucaa.ernet.in/viz-bin/votable?-source=*&-meta&-meta.max=100000&-out.form=XML-VOTable(XSL)','VizieR at IUCAA - Pune, India'),
  ('http://data.bao.ac.cn/viz-bin/votable?-source=*&-meta&-meta.max=100000&-out.form=XML-VOTable(XSL)','VizieR at Bejing Obs. - China'),
  ('http://vizier.cfa.harvard.edu/viz-bin/votable?-source=*&-meta&-meta.max=100000&-out.form=XML-VOTable(XSL)','VizieR at CFA Harvard - USA'),
  ('http://www.ukirt.jach.hawaii.edu/viz-bin/votable?-source=*&-meta&-meta.max=100000&-out.form=XML-VOTable(XSL)','VizieR at JAC, Hawaii - USA'),
  ('',''),
  ('','')
  ),(
  ('http://nvo.stsci.edu/VORegistry/registry.asmx/QueryVOResource?predicate=ResourceType%20like%20''CONE''','NVO at STSCI'),
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