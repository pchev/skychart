Hi,

Thanks for using libsql.

Libsql is the merge between TMyDB and TLiteDB. In 2005, ODBC support is added.
This means documentation has also merged.. Query interface for both databases is identical.

Please look at the website http://libsql.sourceforge.net/ for documentation. There is a yahoo group to discuss libsql http://groups.yahoo.com/group/libsql/

Installation
Make sure the appropiate dll files are in your path or can be found by the application. You will need sqlite.dll or libmysql.dll on windows, or sqlite.so or libmysqlclient.so on linux. Those files should be included with this distribution. You are encouraged to download the newest libraries from the sqlite or mysql website. libmysql.dll comes with the mysql server installation.

Installation as components:
Please select 'install new component' from delphi's component menu, and select the 'vclcomponent.pas' file. This will install TMyDB and TLiteDB on your component palette. In this case, make sure you put the dll files somewhere in your system path, for example, in c:\windows or c:\winnt, or any place where delphi can always find them!

Puth the sqlite library files in delphi's library path
Optionally you can choose to install them as components, select the file 'vclcomponents' that is in the library.

Compatability:
libsql is now compatible with Kylix and with Freepascal for windows.
Freepascal is limited supported, libsql compiles but there may be issues

Embedded MySQL
As of version 0.31 i implemented embedded mysql. There are definitively some issues. One of those issues is that the embedded mysql library also seems experimental, i encountered some bugs which i cannot help. Like the mysql_create_database api succeeding if the database does not yet exist, but generating an Access Violation (!) if the database already exists.. You can circumvent that be just doing a query like 'create database somebase', but that is of course only a workaround.
Anyhow, the library works with current (4.0.18) production version on windows. haven't test unix platforms.
Another thingy is the library loading. Currently i use the same unit for that, because all api's are almost identical. I do not really feel like copying the unit, so i have to find another way. For the momemt being, you just cannot just mysql client and embedded mysql simultaniously. Ideas for fixes welcome, i have some ideas myself but have to think it over.

License
LibSQL is distributed under Modified Artistic Licensing conditions, allowing (legal) usage in almost any type of application, from open-source and GPL to closed source. GPL applications are allowed to modify the license to GPL itself if desired, look at the MAL license regarding License Forking.

--Short docs--

TMyDB and TLiteDB are the base classes to work with.

Add passqlite or pasmysql to you uses clause.

uses passqlite;

Create an instance to the DB:

DB := TLiteDB.Create (nil);

mysql, connect to the database:

DB := TMyDB.Create;
DB.Connect (host, user, pass [, database]);

Specify a database to use:

DB.Use ('some_database');

Perform your query:

DB.Query ('select 1+1');

or use formatquery:

DB.FormatQuery ('select %d+%d', [1,1]);


Fetch your results wioth the result set:

ShowMessage (DB.Results[0][0]);

or:
var i: Integer;
    d: double;

i := DB.Results[0].Format[0].AsInteger;
d := DB.Results[0].Format[0].AsFLoat;

Results [n] returns a TResultRow;
Results[n][m] returns a string
results[n].Format[m] returns a TResultCell

you can easily test if a field is NULL by:

Results[n].IsNull[m]


For questions, please contact me at the yahoo group.

Have fun.
