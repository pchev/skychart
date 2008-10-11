UCAC2 for Cartes du Ciel

This programs convert the three cdrom UCAC2 catalog to a format 
suitable for Cartes du Ciel software.

The cdrom are available for free from the USNO but be reasonable and
try to group your request to not overload the USNO with amateur request.
Remember this is an ongoing work and sky coverage is not complete.
This catalog is mainly intended for astrometry application.
For more information about UCAC2 see http://ad.usno.navy.mil/ucac/

The default catalog include RA, Dec, magnitude and proper motion.
The resulting catalog size is 645MB, this is suitable to burn a single cdrom.

Use the following procedure to process :

- Create a new directory on a disk partition with at least 7GB of free space.
  i.e C:\u2

- Create a subdirectory for the resulting catalog. i.e C:\u2\ucac2

- Copy all the content of the zip file to C:\u2

- Edit the file u2cd1.in u2cd2.in u2cd3.in using a text editor (notepad).

- On the first line of each three file replace D: by the drive letter of 
  your cdrom. Do not change any other line of this files.

- Double click u2cd1.bat, when prompted insert the first UCAC2 cdrom then 
  press a key.

- Repeat the same procedure for the second and third cdrom using u2cd2.bat 
  and u2cd3.bat.
  This may take a while to complete, be patient.

- If you use another path than C:\u2 edit the file ucac2.prj and replace all 
  the occurence of C:\u2 by your own path.

- Launch the Catgen software, if you don't already install this software 
  you can get it from http://www.stargazing.net/astropc/download.html

- Click the "Load Project" button, change to C:\u2 directory and select 
  ucac2.prj.

- Click three time the "Next >>" button then click "Build Catalog". 
  Do not change any option if you don't know exactly what your are doing.

- A dialog show you the operation progress, this may take a while to complete 
  ( 30 minutes on my PIII 1200 ).

- Launch Cartes du Ciel, open the catalog property at the "Catalogues" tab.

- Click the "New" button, change to C:\u2\ucac2 directory and select ucac.hdr.

- Click the red button to change to green to activate the catalog. 

- Remember to always use another catalog at the same time to add the bright 
  stars, the UCAC2 start at magnitude 8.
  The Sky2000 or Tycho2 are a good choice, unfortunately some stars near 
  magnitude 8 are missing if using Hipparcos. 

- If your are satisfied by the result and you don't want to run Catgen again 
  you can remove all the u2z* files from the C:\u2 directory.
 

-------------------------------------

Programmer information:

Because of the non standard way the UCAC2 give pmRA I need to rewrite the 
program u2dumpz to multiply pmRA by COS(Dec). 
The Pascal source code of the modified program is u2conv.dpr

Patrick Chevalley
August 12 2003


