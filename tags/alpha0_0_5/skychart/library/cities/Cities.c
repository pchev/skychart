#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Cities.h"

#ifndef _WIN32
#include <unistd.h>
#else
BOOL APIENTRY DllMain (HANDLE hModule,
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved)
{
    switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			break;
    }
    return TRUE;
}
#endif


/*-----------------------------------------------------------------------------------------*
 *  - - - - - - -                                                                          *
 *   m_Filename                                                                            *
 *  - - - - - - -                                                                          *
 *                                                                                         *
 *  'COUNTRIES' times filenames for each country. If you change anything here you must     *
 *  also adjust the 'Country' arrary in the header file!                                   *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
static const char *m_Filename[COUNTRIES] =
{
	"Afghanistan",
	"Albania",
	"Algeria",
	"Andorra",
	"Angola",
	"Anguilla",
	"Antigua_and_Barbuda",
	"Argentina",
	"Armenia",
	"Aruba",
	"Australia",
	"Austria",
	"Azerbaijan",
	"Bahamas",
	"Bahrain",
	"Bangladesh",
	"Barbados",
	"Belarus",
	"Belgium",
	"Belize",
	"Benin",
	"Bermuda",
	"Bhutan",
	"Bolivia",
	"Bosnia_and_Herzegovina",
	"Botswana",
	"Brazil",
	"British_Virgin_Islands",
	"Brunei",
	"Bulgaria",
	"Burkina_Faso",
	"Burma",
	"Burundi",
	"Cambodia",
	"Cameroon",
	"Canada",
	"Cap_Verde",
	"Cayman_Islands",
	"Central_African_Republic",
	"Chad",
	"Chile",
	"China",
	"Chistmas_Island",
	"Cocos_Islands",
	"Colombia",
	"Comoros",
	"Congo",
	"Congo_Democratic_Republic",
	"Cook_Islands",
	"Costa_Rica",
	"Cote_d_Ivoire",
	"Croatia",
	"Cuba",
	"Cyprus",
	"Czech_Republic",
	"Denmark",
	"Djibouti",
	"Dominica",
	"Dominican_Republic",
	"East_Timor",
	"Ecuador",
	"Egypt",
	"El_Salvador",
	"Equatorial_Guinea",
	"Eritrea",
	"Estonia",
	"Ethiopia",
	"Falkland_Islands",
	"Faroe_Islands",
	"Fiji",
	"Finland",
	"France",
	"French_Guiana",
	"French_Polynesia",
	"French_Southern_and_Antarctic_Lands",
	"Gabon",
	"Gambia",
	"Gaza_Strip",
	"Georgia",
	"Germany",
	"Ghana",
	"Gibraltar",
	"Greece",
	"Greenland",
	"Grenada",
	"Guadeloupe",
	"Guatemala",
	"Guernsey",
	"Guinea",
	"Guinea-Bisseau",
	"Guyana",
	"Haiti",
	"Honduras",
	"Hong_Kong",
	"Hungary",
	"Iceland",
	"India",
	"Indonesia",
	"Iran",
	"Iraq",
	"Ireland",
	"Isle_of_Man",
	"Israel",
	"Italy",
	"Jamaica",
	"Japan",
	"Jersey",
	"Jordan",
	"Kazakhstan",
	"Kenya",
	"Kiribati",
	"Kuwait",
	"Kyrgyzstan",
	"Laos",
	"Latvia",
	"Lebanon",
	"Lesotho",
	"Liberia",
	"Libya",
	"Liechtenstein",
	"Lithuania",
	"Luxembourg",
	"Macau",
	"Macedonia",
	"Madagascar",
	"Malawi",
	"Malaysia",
	"Maldives",
	"Mali",
	"Malta",
	"Marshall_Islands",
	"Martinique",
	"Mauritania",
	"Mauritius",
	"Mayotte",
	"Mexico",
	"Micronesia",
	"Moldova",
	"Monaco",
	"Mongolia",
	"Montserrat",
	"Morocco",
	"Mozambique",
	"Namibia",
	"Nauru",
	"Nepal",
	"Netherlands",
	"Netherlands_Antilles",
	"New_Caledonia",
	"New_Zealand",
	"Nicaragua",
	"Niger",
	"Nigeria",
	"Niue",
	"No_Mans_Land",
	"Norfolk_Island",
	"North_Korea",
	"Norway",
	"Oman",
	"Pakistan",
	"Palau",
	"Panama",
	"Papua_New_Guinea",
	"Paraguay",
	"Peru",
	"Philippines",
	"Pitcairn_Islands",
	"Poland",
	"Portugal",
	"Qatar",
	"Reunion",
	"Romania",
	"Russia",
	"Rwanda",
	"Saint_Helena",
	"Saint_Kitts_and_Nevis",
	"Saint_Lucia",
	"Saint_Pierre_and_Miquelon",
	"Saint_Vincent_and_the_Grenadines",
	"Samoa",
	"San_Marino",
	"Sao_Tome_and_Principe",
	"Saudi_Arabia",
	"Senegal",
	"Seychelles",
	"Sierra_Leone",
	"Singapore",
	"Slovakia",
	"Slovenia",
	"Solomon_Islands",
	"Somalia",
	"South_Africa",
	"South_Georgia_and_The_South_Sandwich_Islands",
	"South_Korea",
	"Spain",
	"Spratly_Islands",
	"Sri_Lanka",
	"Sudan",
	"Suriname",
	"Svalbard",
	"Swaziland",
	"Sweden",
	"Switzerland",
	"Syria",
	"Taiwan",
	"Tajikistan",
	"Tanzania",
	"Thailand",
	"Togo",
	"Tokelau",
	"Tonga",
	"Trinidad_and_Tobago",
	"Tunisia",
	"Turkey",
	"Turkmenistan",
	"Turks_and_Caicos_Islands",
	"Tuvalu",
	"Uganda",
	"Ukraine",
	"United_Arab_Emirates",
	"United_Kingdom",
	"USA",
	"Uruguay",
	"Uzbekistan",
	"Vanuatu",
	"Venezuela",
	"Vietnam",
	"Wallis_and_Futuna",
	"West_Bank",
	"Western_Sahara",
	"Yemen",
	"Yugoslavia",
	"Zambia",
	"Zimbabwe"
};


// directory where the country files are located
static char m_Directory[200];

// all cities contained in one country file
static struct City *m_Cities = NULL;


// temporary array of city names
typedef wchar_t CityName[MAX_CITY_LENGTH];
static CityName *m_CityNames = NULL;


// city name to be searched for converted to wchar_t
static CityName m_CityName;


// index of the selected country
static int m_Country = -1;


// entries of 'struct city' contained in the selected file
static size_t m_Entries;


// indicates wether a city entry was modified
// if '1' (true) saving is necessary
static int m_CityModified = 0;


// defines UTF-8 locale needed for the conversion to wide-chars
#ifdef _WIN32
	static const char* m_Locale = "English_USA.65001";
#else
//	static const char* m_Locale = "en_US.utf8";
	static const char* m_Locale = "en_US.UTF-8";
#endif


// saves name of current locale
static char m_Saved_Locale[100];


DLL_FUNC void SetDirectory (const char* dir)
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - - -                                                                        *
 *   SetDirectory                                                                          *
 *  - - - - - - - -                                                                        *
 *                                                                                         *
 *  Intended to set the directory where the country files are located.                     *
 *                                                                                         *
 *  Input:                                                                                 *
 *     dir (const char*)                                                                   *
 *        directory of the country files                                                   *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	size_t len = strlen (dir);
	char   slash;

#ifdef _WIN32
	slash = '\\';
#else
	slash = '/';
#endif

	memset (&m_Directory, '\0', sizeof (m_Directory));

	strcpy (m_Directory, dir);

	if (m_Directory[len-1] != slash)
	{
		m_Directory[len]   = slash;
		m_Directory[len+1] = '\0';
	}
	printf ("%s\n",m_Directory);
}


DLL_FUNC int ReadCountryFile (const char* country, struct City **cities, char cfile[200])
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - - - -                                                                      *
 *   ReadCountryFile                                                                       *
 *  - - - - - - - - -                                                                      *
 *                                                                                         *
 *  This function reads in the cities for a given country.                                 *
 *                                                                                         *
 *  Input:                                                                                 *
 *     country (const char*)                                                               *
 *        country of the array 'Country' of the header file                                *
 *                                                                                         *
 *  Output:                                                                                *
 *     cities (struct City**)                                                              *
 *        pointer to the 'struct City' array containing the cities of the file read in
 *     cfile  country file name
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *        >=0  =  number of cities read in (success)                                       *
 *        -1   =  GetCountryIndex() failed                                                 *
 *        -2   =  unable to open file                                                      *
 *        -3   =  allocation of memory for m_Cities, m_CityNames failed                    *
 *        -4   =  ConvertCitiesToWChar() failed                                            *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	FILE  *File;
	char  filename[200];

	int    index = GetCountryIndex (country);
	size_t i, j;

	if (index == -1)
		return -1;

	// only read in data if not yet done
	if (m_Country == index)
		return m_Entries;

	if (m_Cities != NULL)
	{
		free (m_Cities);
		free (m_CityNames);
	}

	// construct file name
	strcpy (filename, m_Directory);
	strcat (filename, m_Filename[index]);

    strcpy (cfile, filename);

	File = fopen (filename, "rb");

	if (! File)
		return -2;

	fread (&m_Entries, sizeof (unsigned int), 1, File);

	// allocate memory for 'm_Entries' times City structs and CityNames
	m_Cities    = (struct City*) calloc (m_Entries, sizeof (struct City));
	m_CityNames = (CityName*)    calloc (m_Entries, sizeof (CityName));

	// allocation successfull?
	if (m_Cities == NULL || m_CityNames == NULL)
		return -3;

	for (i = 0; i < m_Entries; i++)
	{
		for (j = 0;; j++)
		{
			m_Cities[i].m_Name[j] = fgetc (File);

			if (m_Cities[i].m_Name[j] == 0)
				break;
		}

		fread (m_Cities[i].m_Coord, sizeof (int), 2, File);
	}

	fclose (File);

	if (ConvertCitiesToWChar () != 1)
	{
		free (m_Cities);
		free (m_CityNames);
		m_Cities    = NULL;
		m_CityNames = NULL;
		m_Country   = -1;
		return -4;
	}

	m_Country = index;

	*cities = m_Cities;

	return m_Entries;
}


DLL_FUNC int SaveFile ()
/*-----------------------------------------------------------------------------------------*
 *  - - - - - -                                                                            *
 *   SaveFile                                                                              *
 *  - - - - - -                                                                            *
 *                                                                                         *
 *  This function saves the file for a country selected before.                            *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *         1  =  success                                                                   *
 *        -1  =  SetLocale() failed                                                        *
 *        -2  =  mbsrtowcs() failed                                                        *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	size_t i;
	char   filename[200], tmp_filename[200];
	FILE  *File;

    // construct file names
    strcpy (filename, m_Directory);
    strcat (filename, m_Filename[m_Country]);
    strcpy (tmp_filename, filename);
    strcat (tmp_filename, ".tmp");

	// create backup file first
    File = fopen (tmp_filename, "wb");

    if (! File)
        return -2;

	fwrite (&m_Entries, sizeof (unsigned int), 1, File);

    for (i = 0; i < m_Entries; i++)
    {
		fwrite (m_Cities[i].m_Name,  strlen (m_Cities[i].m_Name) + 1, 1, File);
        fwrite (m_Cities[i].m_Coord, sizeof (int),                    2, File);
	 }

	// creation of temporary file successfull?
	if (ferror (File) != 0)
	{
		fclose (File);
		unlink (tmp_filename);
		return -1;
	}

	fclose (File);

	// creation of temporary file successfull
	// => delete original file and rename temporary file
	unlink (filename);
	rename (tmp_filename, filename);

	return 1;
}


DLL_FUNC int AddCity (const struct City *city)
/*-----------------------------------------------------------------------------------------*
 *  - - - - -                                                                              *
 *   AddCity                                                                               *
 *  - - - - -                                                                              *
 *                                                                                         *
 *  This function adds a given city to a country file.                                     *
 *                                                                                         *
 *  Input:                                                                                 *
 *     country (const struct City*)                                                        *
 *        city to add                                                                      *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *         1        =  success                                                             *
 *        -1,-2,-3  =  errors from SearchCity()                                            *
 *        -4        =  city to add already in the country file                             *
 *        -5        =  reallocation of memory for m_Cities, m_CityNames failed             *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	// get index where to insert new city
	int index = SearchCity (city->m_Name);

	if (index < 0)
		return index;

	// city to add already there?
	if (wcscoll (m_CityName, m_CityNames[index]) == 0)
		return -4;

	m_Entries++;

	// rearrange memory
	m_Cities    = (struct City*) realloc (m_Cities,    m_Entries * sizeof (struct City));
	m_CityNames = (CityName*)    realloc (m_CityNames, m_Entries * sizeof (CityName));

	if (m_Cities == NULL || m_CityNames == NULL)
		return -5;

	memmove (&m_Cities[index+1], &m_Cities[index],
			 (m_Entries-index-1) * sizeof (struct City));

	memmove (&m_CityNames[index+1], &m_CityNames[index],
			 (m_Entries-index-1) * sizeof (CityName));

    // insert entry in 'm_CityNames' array
    wcscpy (m_CityNames[index], m_CityName);

    // insert entry in 'struct City' array
    strcpy (m_Cities[index].m_Name, city->m_Name);
    m_Cities[index].m_Coord[0] = city->m_Coord[0];
    m_Cities[index].m_Coord[1] = city->m_Coord[1];

    // set "file-saving" to true
    m_CityModified = 1;

	return 1;
}


DLL_FUNC int ModifyCity (int index, const struct City *city)
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - -                                                                          *
 *   ModifyCity                                                                            *
 *  - - - - - - -                                                                          *
 *                                                                                         *
 *  This function modifies a city entry.                                                   *
 *                                                                                         *
 *  Input:                                                                                 *
 *     index (int)                                                                         *
 *        index of the city inside the 'm_Cities' array                                    *
 *     city (const struct City*)                                                           *
 *        city to modify                                                                   *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *         1     =  success                                                                *
 *        -1,-2  =  errors from ConvertStringToWChar()                                     *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	// change entry in 'm_CityNames' array
	int error = ConvertStringToWChar (city->m_Name);

    if (error < 0)
        return error;

	// change entry in 'm_CityNames' array
	wcscpy (m_CityNames[index], m_CityName);

	// change entry in 'struct City' array
	strcpy (m_Cities[index].m_Name, city->m_Name);
    m_Cities[index].m_Coord[0] = city->m_Coord[0];
    m_Cities[index].m_Coord[1] = city->m_Coord[1];

	// set "file-saving" to true
	m_CityModified = 1;

	return 1;
}


DLL_FUNC int RemoveCity (int index, const struct City *city)
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - -                                                                          *
 *   RemoveCity                                                                            *
 *  - - - - - - -                                                                          *
 *                                                                                         *
 *  This function removes a city entry.                                                    *
 *                                                                                         *
 *  Input:                                                                                 *
 *     index (int)                                                                         *
 *        index of the city inside the 'm_Cities' array                                    *
 *     city (const struct City*)                                                           *
 *        city to remove                                                                   *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *         1  =  success                                                                   *
 *        -1  =  reallocation of memory for m_Cities, m_CityNames failed                   *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
    m_Entries--;

    // rearrange memory
    memmove (&m_Cities[index], &m_Cities[index+1],
             (m_Entries-index) * sizeof (struct City));

    memmove (&m_CityNames[index], &m_CityNames[index+1],
             (m_Entries-index) * sizeof (CityName));

    m_Cities    = (struct City*) realloc (m_Cities,    m_Entries * sizeof (struct City));
    m_CityNames = (CityName*)    realloc (m_CityNames, m_Entries * sizeof (CityName));

    if (m_Cities == NULL || m_CityNames == NULL)
        return -1;

    // set "file-saving" to true
    m_CityModified = 1;

    return 1;
}


DLL_FUNC int SearchCity (const char* str)
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - -                                                                          *
 *   SearchCity                                                                            *
 *  - - - - - - -                                                                          *
 *                                                                                         *
 *  This function returns the index of the first city of the 'struct City' array beginning *
 *  with "str".                                                                            *
 *                                                                                         *
 *  Input:                                                                                 *
 *     str (const char*)                                                                   *
 *        city to search for                                                               *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *        >=0    =  success                                                                *
 *        -1,-2  =  errors from GetCityIndex(), ConvertStringToWChar()                     *
 *        -3     =  error from ConvertStringToWChar(): mbsrtowcs() failed                  *
 *                                                                                         *
 *  Notes:                                                                                 *
 *     If "str" is NULL a pointer to 'struct City'[0] is returned.                         *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	int index;

	if (str == NULL)
		return 0;

	// convert 'str' to wchar_t
	index = ConvertStringToWChar (str);
	if (index == -1)
		return -1;
	else if (index == -2)
		return -3;

	// get index of 'str' of m_Cities
	index = GetCityIndex ();

	return index;
}


DLL_FUNC int ReleaseCities ()
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - - -                                                                        *
 *   ReleaseCities                                                                         *
 *  - - - - - - - -                                                                        *
 *                                                                                         *
 *  This function deallocates memory for city arrays and resets global variables.          *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *        errors from SaveFile()                                                           *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	int error = 1;

	if (m_CityModified)
		error = SaveFile ();

    free (m_Cities);
    free (m_CityNames);

	m_Cities       = NULL;
	m_CityNames    = NULL;
	m_Country      = -1;
	m_Entries      = 0;
	m_CityModified = 0;

	return error;
}


int SetLocale ()
/*-----------------------------------------------------------------------------------------*
 *  - - - - - -                                                                            *
 *   SetLocale                                                                             *
 *  - - - - - -                                                                            *
 *                                                                                         *
 *  This function temporarily changes the current locale to one with UTF-8 (multibye)      *
 *  support.                                                                               *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *        1   success                                                                      *
 *       -1   call of setlocale() (to get the actual or to set a new locale) failed        *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
    // get the name of the current locale
	strcpy (m_Saved_Locale, setlocale (LC_ALL, NULL));

    if (m_Saved_Locale == NULL)
        return -1;

    // change the locale to UTF-8
    if (setlocale (LC_ALL, m_Locale) == NULL)
        return -1;

	return 1;
}


int ConvertCitiesToWChar ()
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - - - - - - -                                                                *
 *   ConvertCitiesToWChar                                                                  *
 *  - - - - - - - - - - - -                                                                *
 *                                                                                         *
 *  This function converts the cities names from UTF-8 (multibyte) format to type wchar_t. *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *         1  =  success                                                                   *
 *        -1  =  SetLocale() failed                                                        *
 *        -2  =  mbsrtowcs() failed                                                        *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	size_t      i;
	mbstate_t   state;
	const char* inbufPtr;

	// temporarily change current locale
	if (SetLocale () == -1)
		return -1;

	for (i = 0; i < m_Entries; i++)
	{
		// initialize the state
		memset (&state, '\0', sizeof (state));

		inbufPtr = m_Cities[i].m_Name;

		if (mbsrtowcs (m_CityNames[i], &inbufPtr, strlen (m_Cities[i].m_Name), &state) ==
			(size_t) -1)
			return -2;
	}

	// restore original locale
	setlocale (LC_ALL, m_Saved_Locale);

	return 1;
}


int ConvertStringToWChar (const char* str)
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - - - - - - -                                                                *
 *   ConvertStringToWChar                                                                  *
 *  - - - - - - - - - - - -                                                                *
 *                                                                                         *
 *  This function converts a given string from UTF-8 (multibyte) format to type 'wchar_t'. *
 *  The converted string is saved globally in 'm_CityName'.                                *
 *                                                                                         *
 *  Input:                                                                                 *
 *     str (const char*)                                                                   *
 *        string to convert in UTF-8 (multibyte) format                                    *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *         1  =  success                                                                   *
 *        -1  =  SetLocale() failed                                                        *
 *        -2  =  mbsrtowcs() failede                                                       *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	mbstate_t state;

	// temporarily change current locale
    if (SetLocale () == -1)
        return -1;

	// initialize the state
	memset (&state, '\0', sizeof (state));

	if (mbsrtowcs (m_CityName, &str, strlen (str) + 1, &state) == (size_t) -1)
		return -2;

	// restore the original locale
	setlocale (LC_ALL, m_Saved_Locale);

	return 1;
}



int GetCountryIndex (const char* str)
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - - - -                                                                      *
 *   GetCountryIndex                                                                       *
 *  - - - - - - - - -                                                                      *
 *                                                                                         *
 *  This function returns the index of a country's name of the country array 'm_Filename'  *
 *  beginning with "str". A binary search algorithm is used.                               *
 *                                                                                         *
 *  Input:                                                                                 *
 *     str (const char*)                                                                   *
 *        country to search for                                                            *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *        >=0  =  success                                                                  *
 *        -1   =  no suitable country entry found (this error should'nt occur!)            *
 *                Verify the entries in the 'Country' and 'm_Filename' arrays!             *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	int low  = 0;
	int high = COUNTRIES;
	int middle, cmp;

	while (low <= high)
	{
		middle = (low + high) / 2;

		cmp = strcmp (str, Country[middle]);

		if (cmp == 0)
			return middle;
		else if (cmp < 0)
			high = middle - 1;
		else
			low  = middle + 1;
	}

	return -1;
}


int GetCityIndex ()
/*-----------------------------------------------------------------------------------------*
 *  - - - - - - - -                                                                        *
 *   GetCityIndex                                                                          *
 *  - - - - - - - -                                                                        *
 *                                                                                         *
 *  This function returns the index of a city's name of the 'struct City' array 'm_Cities' *
 *  beginning with "m_CityName". A binary search algorithm is used.                        *
 *                                                                                         *
 *  Returns:                                                                               *
 *     (int)                                                                               *
 *        >=0  =  success                                                                  *
 *        -1   =  SetLocale() failed                                                       *
 *        -2   =  no suitable city entry found (this error should'nt occur!)               *
 *                                                                                         *
 *-----------------------------------------------------------------------------------------*/
{
	int            low  = 0;
	int            high = m_Entries;
    int            cmp1, cmp2;
    static int     middle;
#ifdef DEBUG
	char        ostr[90];
	char        cstr1[90], cstr2[90];
	int         i, count = 1;
	size_t len = wcslen (str);

	memset (ostr, '\0', sizeof (ostr));

	for (i = 0; i < len; i++)
		ostr[i] = str[i];
#endif

    // temporarily change current locale
    if (SetLocale () == -1)
        return -1;

    while (low <= high)
    {
        middle = (low + high) / 2;

		if (middle == 0)
		{
		    setlocale (LC_ALL, m_Saved_Locale);
			return 0;
		}

#ifdef DEBUG
		memset (cstr1, '\0', sizeof (cstr1));
		memset (cstr2, '\0', sizeof (cstr2));

		for (i = 0; i < wcslen (m_CityNames[middle]); i++)
			cstr1[i] = m_CityNames[middle][i];

		for (i = 0; i < wcslen (m_CityNames[middle-1]); i++)
			cstr2[i] = m_CityNames[middle-1][i];
#endif

        cmp1 = wcscoll (m_CityName, m_CityNames[middle]);
        cmp2 = wcscoll (m_CityName, m_CityNames[middle-1]);

        if (cmp1 == 0)
		{
			if (cmp2 > 0)
			{
			    setlocale (LC_ALL, m_Saved_Locale);
        	    return middle;
			}
	        else
            	high = middle - 1;
		}
        else if (cmp1 < 0)
		{
			if (cmp2 > 0)
			{
			    setlocale (LC_ALL, m_Saved_Locale);
        	    return middle;
			}
			else
	            high = middle - 1;
		}
        else
            low = middle + 1;
    }

    // restore the original locale
    setlocale (LC_ALL, m_Saved_Locale);

    return -2;
}
