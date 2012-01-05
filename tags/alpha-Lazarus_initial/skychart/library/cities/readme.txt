Date: Fri, 20 Dec 2002 13:45:21 +0100 (MET)
From: Maik Gottschalk <maik.gottschalk@gmx.de>
To: Patrick Chevalley <pch@freesurf.ch>

...

The second topic concerns the possibility to add more locations (i.e.
cities) to the observation selection menu in "Cartes du Ciel".

In about 1998 / 1999 I collected more than 2 million locations of cities
and other "points of interest" from the URL
  http://www.nima.mil/gns/html/

The locations are given for free as you can read on the page just mentioned.
I filtered the data to produce a set of city locations.

...


Date: Tue, 7 Jan 2003 09:04:13 +0100 (MET)
From: Maik Gottschalk <maik.gottschalk@gmx.de>
To: Patrick Chevalley <pch@freesurf.ch>

Hello Patrick,

I just got the "CitiesOfTheWorld" finished, i.e. the binary country files
(233) and source-code incl. library (DLL) for both Linux and Windows. The
country files were "tared" and "bziped" and are 9.1 MB and 9.5 MB in size.
The only country that is missing till the end of this week are the "USA",
since the data are from a another server and thus differently formatted.

Would it be Ok for you to receive such big files per email? If yes, I could
email the files to you starting today. If no, please send me a notice, how
small the files should be, so that I can arrange them to smaller pieces.

Right now I send you the packed sources for a first insight. For unpacking
under Linux I recommend the command

   'tar xvjf [Filename].bz2' (if bzip2 is available under Linux).

Under Windows you could use the "DOS"-executable of "bzip2" ('bzip2'-
Homepage: http://sourceware.cygnus.com/bzip2) and "Winzip" for the
resulting ".tar"-file.

There's a small example program enclosed to illustrate the facilities of
the library. You should be aware of the fact, that the library needs
so-called "MultiByte"-Character-Strings as input, i.e. UTF-8 format (a
kind of Unicode). Also, MultiByte-Strings are returned for the city's
names. Since the original data is in such Unicode-format, too, this is
the only way to write the names correctly. The interconversion of these
formats is possible since the Windows-API offers several conversion-
functions.

A possible job for the library could be as follows:
A user selects a certain country within an appropriate menu. The
corresponding country file is read in immediately and a pointer to the
static list of cities is returned. Maybe it might be possible to offer
this list completely within a ComboBox, but maybe it's to long to do that.
For an incremental search the user's input is send to the library every
time he/she writes one more letter of the city's name. As a result the
index of the first city starting with the name given is returned, so that
the size of "possible" cities will shrink dramatically. Additionally, it's
possible to modify, add and remove a city's entry.

The internal structure of the binary data is an "unsigned int" for the
number of city entries followed by a sequence of a "\0"-terminated name
and two "signed int" values for the coordinates. The binary data consist
of 2816928 cities in total. Entries of the original data with identical
names AND coordinates have been removed.

If you should have problems reading Unicode-formatted texts I can recommend
the editor "yudit" available at www.yudit.org.

I plan a little extension to this version of the library for the future:
If a user (or program result) defines a polygonal area it should be possible
to get a list of all cities lying inside this area. This facility might be
useful to obtain a list of all cities where one is able to see the total
part of an eclipse, for instance. But since there're a lot of security
mechanisms necessary I guess the programming demand of 3 to 5 days. If I
will have time I will focus on the geometric algorithms...

If you should have any problems to use the city library don't hesitate to
contact me!

Best regards,

Maik.


