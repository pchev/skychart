  MultiDoc
  A Lazarus component to replace the standard MDI interface.
  
  Copyright (C) 2006 Patrick Chevalley, http://www.ap-i.net

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.
  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.
  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  
  This component permit to write pseudo-MDI application with Lazarus.
  It is not a real implementation of the MDI interface but it give to your 
  application the capability to use many resizable sub-form. 
    
  Converting a MDI application is simplified by the availability of the same 
  component for Delphi. Convert first your application to MultiDoc in Delphi,
  then convert to Lazarus.
  This require some work but among the advantage you avoid the ugly XP border 
  around your child forms.
  
  This component is exclusively derived from high level standard component
  (TPanel, TCustomSplitter, TSpeedButton). It must work on all the Lazarus 
  platform without change.
  Look at the demo and component source for more explanation.
  
