#ifndef Cities_h
#define Cities_h

#include <wchar.h>

#ifdef _WIN32
#include <windows.h>
#define DLL_FUNC __declspec(dllexport)
#else
#define DLL_FUNC
#endif

#define COUNTRIES       234  // number of countries
#define MAX_CITY_LENGTH 120  // length of longest city name (including '\0')

// defines one single city entry
struct City
{
	char m_Name[MAX_CITY_LENGTH]; // city name
	int  m_Coord[2];              // geogr. latitude and longitude
};


/*-------------------------------------------------------------------------------------*
 *  - - - - -                                                                          *
 *   Country                                                                           *
 *  - - - - -                                                                          *
 *                                                                                     *
 *  'COUNTRIES' times the names for each country. If you change anything here you must *
 *  also adjust the 'm_Filename' arrary in the implementation file!                    *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
char *Country[COUNTRIES] =
{
	"Afghanistan",
	"Albania",
	"Algeria",
	"Andorra",
	"Angola",
	"Anguilla",
	"Antigua and Barbuda",
	"Argentina",
	"Armenia",
	"Aruba",
	"Australia",
	"Austria",
	"Azerbaijan",
	"Bahamas, The",
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
	"Bosnia and Herzegovina",
	"Botswana",
	"Brazil",
	"British Virgin Islands",
	"Brunei",
	"Bulgaria",
	"Burkina Faso",
	"Burma",
	"Burundi",
	"Cambodia",
	"Cameroon",
	"Canada",
	"Cap Verde",
	"Cayman Islands",
	"Central African Republic",
	"Chad",
	"Chile",
	"China",
	"Chistmas Island",
	"Cocos (Keeling) Islands",
	"Colombia",
	"Comoros",
	"Congo",
	"Congo, Democratic Republic of The",
	"Cook Islands",
	"Costa Rica",
	"Cote d'Ivoire",
	"Croatia",
	"Cuba",
	"Cyprus",
	"Czech Republic",
	"Denmark",
	"Djibouti",
	"Dominica",
	"Dominican Republic",
	"East Timor",
	"Ecuador",
	"Egypt",
	"El Salvador",
	"Equatorial Guinea",
	"Eritrea",
	"Estonia",
	"Ethiopia",
	"Falkland Islands",
	"Faroe Islands",
	"Fiji",
	"Finland",
	"France",
	"French Guiana",
	"French Polynesia",
	"French Southern and Antarctic Lands",
	"Gabon",
	"Gambia, The",
	"Gaza Strip",
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
	"Hong Kong",
	"Hungary",
	"Iceland",
	"India",
	"Indonesia",
	"Iran",
	"Iraq",
	"Ireland",
	"Isle of Man",
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
	"Macedonia, The Former Yugoslav Republic of",
	"Madagascar",
	"Malawi",
	"Malaysia",
	"Maldives",
	"Mali",
	"Malta",
	"Marshall Islands",
	"Martinique",
	"Mauritania",
	"Mauritius",
	"Mayotte",
	"Mexico",
	"Micronesia, Federated States of",
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
	"Netherlands Antilles",
	"New Caledonia",
	"New Zealand",
	"Nicaragua",
	"Niger",
	"Nigeria",
	"Niue",
	"No Man's Land",
	"Norfolk Island",
	"North Korea",
	"Norway",
	"Oman",
	"Pakistan",
	"Palau",
	"Panama",
	"Papua New Guinea",
	"Paraguay",
	"Peru",
	"Philippines",
	"Pitcairn Islands",
	"Poland",
	"Portugal",
	"Qatar",
	"Reunion",
	"Romania",
	"Russia",
	"Rwanda",
	"Saint Helena",
	"Saint Kitts and Nevis",
	"Saint Lucia",
	"Saint Pierre and Miquelon",
	"Saint Vincent and the Grenadines",
	"Samoa",
	"San Marino",
	"Sao Tome and Principe",
	"Saudi Arabia",
	"Senegal",
	"Seychelles",
	"Sierra Leone",
	"Singapore",
	"Slovakia",
	"Slovenia",
	"Solomon Islands",
	"Somalia",
	"South Africa",
	"South Georgia and The South Sandwich Islands",
	"South Korea",
	"Spain",
	"Spratly Islands",
	"Sri Lanka",
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
	"Trinidad and Tobago",
	"Tunisia",
	"Turkey",
	"Turkmenistan",
	"Turks and Caicos Islands",
	"Tuvalu",
	"Uganda",
	"Ukraine",
	"United Arab Emirates",
	"United Kingdom",
	"United States of America",
	"Uruguay",
	"Uzbekistan",
	"Vanuatu",
	"Venezuela",
	"Vietnam",
	"Wallis and Futuna",
	"West Bank",
	"Western Sahara",
	"Yemen",
	"Yugoslavia",
	"Zambia",
	"Zimbabwe"
};


/*-------------------------------------------------------------------------------------*
 *  - - - - - - - -                                                                    *
 *   SetDirectory                                                                      *
 *  - - - - - - - -                                                                    *
 *                                                                                     *
 *  Intended to set the directory where the country files are located.                 *
 *                                                                                     *
 *  Input:                                                                             *
 *     dir (const char*)                                                               *
 *        directory of the country files                                               *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
DLL_FUNC void SetDirectory (const char* dir);


/*-------------------------------------------------------------------------------------*
 *  - - - - - - - - -                                                                  *
 *   ReadCountryFile                                                                   *
 *  - - - - - - - - -                                                                  *
 *                                                                                     *
 *  This function reads in the cities for a given country.                             *
 *                                                                                     *
 *  Input:                                                                             *
 *     country (const char*)                                                           *
 *        country of the array 'Country' of the header file                            *
 *                                                                                     *
 *  Output:                                                                            *
 *     cities (struct City**)                                                          *
 *        pointer to the 'struct City' array containing the cities of the file read in *
 *     cfile  country file name
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *        >=0  =  number of cities read in (success)                                   *
 *        -1   =  GetCountryIndex() failed                                             *
 *        -2   =  unable to open file                                                  *
 *        -3   =  allocation of memory for m_Cities, m_CityNames failed                *
 *        -4   =  ConvertCitiesToWChar() failed                                        *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
DLL_FUNC int ReadCountryFile (const char* country, struct City **cities, char cfile[200]);


/*-------------------------------------------------------------------------------------*
 *  - - - - - -                                                                        *
 *   SaveFile                                                                          *
 *  - - - - - -                                                                        *
 *                                                                                     *
 *  This function saves the file for a country selected before.                        *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *         1  =  success                                                               *
 *        -1  =  SetLocale() failed                                                    *
 *        -2  =  mbsrtowcs() failed                                                    *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
DLL_FUNC int SaveFile ();


/*-------------------------------------------------------------------------------------*
 *  - - - - -                                                                          *
 *   AddCity                                                                           *
 *  - - - - -                                                                          *
 *                                                                                     *
 *  This function adds a given city to a country file.                                 *
 *                                                                                     *
 *  Input:                                                                             *
 *     country (const struct City*)                                                    *
 *        city to add                                                                  *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *         1        =  success                                                         *
 *        -1,-2,-3  =  errors from SearchCity()                                        *
 *        -4        =  city to add already in the country file                         *
 *        -5        =  reallocation of memory for m_Cities, m_CityNames failed         *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
DLL_FUNC int AddCity (const struct City *city);


/*-------------------------------------------------------------------------------------*
 *  - - - - - - -                                                                      *
 *   ModifyCity                                                                        *
 *  - - - - - - -                                                                      *
 *                                                                                     *
 *  This function modifies a city entry.                                               *
 *                                                                                     *
 *  Input:                                                                             *
 *     index (int)                                                                     *
 *        index of the city inside the 'm_Cities' array                                *
 *     city (const struct City*)                                                       *
 *        city to modify                                                               *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *         1     =  success                                                            *
 *        -1,-2  =  errors from ConvertStringToWChar()                                 *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
DLL_FUNC int ModifyCity (int index, const struct City *city);


/*-------------------------------------------------------------------------------------*
 *  - - - - - - -                                                                      *
 *   RemoveCity                                                                        *
 *  - - - - - - -                                                                      *
 *                                                                                     *
 *  This function removes a city entry.                                                *
 *                                                                                     *
 *  Input:                                                                             *
 *     index (int)                                                                     *
 *        index of the city inside the 'm_Cities' array                                *
 *     city (const struct City*)                                                       *
 *        city to remove                                                               *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *         1  =  success                                                               *
 *        -1  =  reallocation of memory for m_Cities, m_CityNames failed               *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
DLL_FUNC int RemoveCity (int index, const struct City *city);


/*-------------------------------------------------------------------------------------*
 *  - - - - - - - -                                                                    *
 *   ReleaseCities                                                                     *
 *  - - - - - - - -                                                                    *
 *                                                                                     *
 *  This function deallocates memory for city arrays and resets global variables.      *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *        errors from SaveFile()                                                       *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
DLL_FUNC int ReleaseCities ();


/*-------------------------------------------------------------------------------------*
 *  - - - - - - -                                                                      *
 *   SearchCity                                                                        *
 *  - - - - - - -                                                                      *
 *                                                                                     *
 *  This function returns the index of the first city of the 'struct City' array       *
 *  beginning with "str".                                                              *
 *                                                                                     *
 *  Input:                                                                             *
 *     str (const char*)                                                               *
 *        city to search for                                                           *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *        >=0    =  success                                                            *
 *        -1,-2  =  errors from GetCityIndex(), ConvertStringToWChar()                 *
 *        -3     =  error from ConvertStringToWChar(): mbsrtowcs() failed              *
 *                                                                                     *
 *  Notes:                                                                             *
 *     If "str" is NULL a pointer to 'struct City'[0] is returned.                     *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
DLL_FUNC int SearchCity (const char* str);


/*-------------------------------------------------------------------------------------*
 *  - - - - - -                                                                        *
 *   SetLocale                                                                         *
 *  - - - - - -                                                                        *
 *                                                                                     *
 *  This function temporarily changes the current locale to one with UTF-8 (multibye)  *
 *  support.                                                                           *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *        1   success                                                                  *
 *       -1   call of setlocale() (to get the actual or to set a new locale) failed    *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
int SetLocale ();


/*-------------------------------------------------------------------------------------*
 *  - - - - - - - -                                                                    *
 *   GetCityIndex                                                                      *
 *  - - - - - - - -                                                                    *
 *                                                                                     *
 *  This function returns the index of a city's name of the 'struct City' array        *
 *  'm_Cities' beginning with "m_CityName". A binary search algorithm is used.         *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *        >=0  =  success                                                              *
 *        -1   =  SetLocale() failed                                                   *
 *        -2   =  no suitable city entry found (this error should'nt occur!)           *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
int GetCityIndex ();


/*-------------------------------------------------------------------------------------*
 *  - - - - - - - - -                                                                  *
 *   GetCountryIndex                                                                   *
 *  - - - - - - - - -                                                                  *
 *                                                                                     *
 *  This function returns the index of a country's name of the country array           *
 *  'm_Filename' beginning with "str". A binary search algorithm is used.              *
 *                                                                                     *
 *  Input:                                                                             *
 *     str (const char*)                                                               *
 *        country to search for                                                        *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *        >=0  =  success                                                              *
 *        -1   =  no suitable country entry found (this error should'nt occur!)        *
 *                Verify the entries in the 'Country' and 'm_Filename' arrays!         *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
int GetCountryIndex (const char* str1);


/*-------------------------------------------------------------------------------------*
 *  - - - - - - - - - - - -                                                            *
 *   ConvertCitiesToWChar                                                              *
 *  - - - - - - - - - - - -                                                            *
 *                                                                                     *
 *  This function converts the cities names from UTF-8 (multibyte) format to type      *
 *  'wchar_t'.                                                                         *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *         1  =  success                                                               *
 *        -1  =  SetLocale() failed                                                    *
 *        -2  =  mbsrtowcs() failed                                                    *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
int ConvertCitiesToWChar ();


/*-------------------------------------------------------------------------------------*
 *  - - - - - - - - - - - -                                                            *
 *   ConvertStringToWChar                                                              *
 *  - - - - - - - - - - - -                                                            *
 *                                                                                     *
 *  This function converts a given string from UTF-8 (multibyte) format to type        *
 *  'wchar_t'. The converted string is saved globally in 'm_CityName'.                 *
 *                                                                                     *
 *  Input:                                                                             *
 *     str (const char*)                                                               *
 *        string to convert in UTF-8 (multibyte) format                                *
 *                                                                                     *
 *  Returns:                                                                           *
 *     (int)                                                                           *
 *         1  =  success                                                               *
 *        -1  =  SetLocale() failed                                                    *
 *        -2  =  mbsrtowcs() failede                                                   *
 *                                                                                     *
 *-------------------------------------------------------------------------------------*/
int ConvertStringToWChar (const char* str);


#endif  // Cities_h
