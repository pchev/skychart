unit cu_vo;

{$mode objfpc}{$H+}

{                                        
Copyright (C) 2005 Patrick Chevalley

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
{
 Virtual Observatory interface.
}

interface

uses cu_vocatalog, cu_vodetail, cu_vodata, 
     LibXmlParser,
     LResources, Classes, SysUtils;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CDC', [TVO_Catalogs,TVO_Detail,TVO_TableData]);
end;

//////////////////////////////////////////////////////////
initialization
  {$I cu_vo.lrs}


end.
