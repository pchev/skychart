{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }
{
Copyright (C) 2014 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}
{
   Pascal Indi client library freely inspired by libindiclient.
   See: http://www.indilib.org/
}

unit indiclient;

interface

uses
  indibaseclient, indiapi, indicom, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('indiclient', @Register);
end.
