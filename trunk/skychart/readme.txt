Main code go here.

For a convenient use of the Delphi directories options create the following structure:

cdc -|                                    < base directory containing the executable 
     |- dev -|                            < local cvsroot 
             |- skychart |                < skychart cvs module
                         |- component     < project component
                         |- library       < project library 
                         |- ...
             |- dcu                       < all compilation .dcu object go here


For a project in its own directory under library the Delphi project option are:

OutputDir=../../../../
UnitOutputDir=../../../dcu




