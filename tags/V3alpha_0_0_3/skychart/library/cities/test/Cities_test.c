#include <stdio.h>
#include <string.h>
#include "Cities.h"

int main (int argc, char **argv)
{
	int          entries, index;
	char         city[100];
	struct City  *cities;
	struct City  entry = { "Papenburg", { 500000, 100000 } };

#ifdef _WIN32
	char         directory[] = "C:\\temp\\city";
#else
	char         directory[] = "/home/mgottschalk/city";
#endif

#ifdef _WIN32
	// declare functions used below
	typedef void (*SetDirectoryPtr)    (const char* dir);
	typedef int  (*ReadCountryFilePtr) (const char* country, struct City **cities);
	typedef int  (*SaveFilePtr)        ();
	typedef int  (*AddCityPtr)         (const struct City *city);
	typedef int  (*ModifyCityPtr)      (int index, const struct City *city);
	typedef int  (*RemoveCityPtr)      (int index, const struct City *city);
	typedef int  (*ReleaseCitiesPtr)   ();
	typedef int  (*SearchCityPtr)      (const char* str);

	SetDirectoryPtr     SetDirectory;
	ReadCountryFilePtr  ReadCountryFile;
	AddCityPtr          AddCity;
	ModifyCityPtr       ModifyCity;
	RemoveCityPtr       RemoveCity;
	ReleaseCitiesPtr    ReleaseCities;
	SearchCityPtr       SearchCity;

	// load dll's
	HINSTANCE Cities_DLL = LoadLibrary("C:\\temp\\city\\city.dll");

	if (Cities_DLL != NULL)
	{
		SetDirectory      = (SetDirectoryPtr)    GetProcAddress (Cities_DLL, "SetDirectory");
		ReadCountryFile   = (ReadCountryFilePtr) GetProcAddress (Cities_DLL, "ReadCountryFile");
		AddCity           = (AddCityPtr) GetProcAddress (Cities_DLL, "AddCity");
		ModifyCity        = (ModifyCityPtr) GetProcAddress (Cities_DLL, "ModifyCity");
		RemoveCity        = (RemoveCityPtr) GetProcAddress (Cities_DLL, "RemoveCity");
		ReleaseCities     = (ReleaseCitiesPtr) GetProcAddress (Cities_DLL, "ReleaseCities");
		SearchCity        = (SearchCityPtr) GetProcAddress (Cities_DLL, "SearchCity");

		if (! (SetDirectory && ReadCountryFile && AddCity && ModifyCity && RemoveCity &&
			   ReleaseCities && SearchCity))
		{
			// handle the error
			FreeLibrary (Cities_DLL);
			printf ("\nUnable to get AstroTime function pointers!\n\n");
			exit (-1);
		}
	}
	else
	{
		printf ("\nUnable to load 'AstroTime.dll'!\n\n");
		exit (-1);
	}

#endif

	// sets the directory where the country files are located
	SetDirectory (directory);

	if (argc < 2)
	{
		printf ("No input file given!\n");
		exit (-1);
	}

	entries = ReadCountryFile (argv[1], &cities);

	if (entries < 0)
	{
		printf ("error = %d\n", entries);
		exit (-1);
	}

	printf ("%d\n", entries);

/*	for (i = 0; i < entries; i++)
	{
//		for (j = 0; m_Cities[i].m_Name[j] != 0; j++) // UTF-8
//			printf ("%c", m_Cities[i].m_Name[j]);    // UTF-8

		for (j = 0; m_CityNames[i][j] != 0; j++)
			printf ("%c", m_CityNames[i][j]);

		printf ("  %d  ", m_Cities[i].m_Coord[0]);
		printf ("%d\n",   m_Cities[i].m_Coord[1]);
	}*/

//	while (1)
	{
		memset (city, '\0', sizeof (city));

		printf ("\nSearch City: ");
		fgets (city, 100, stdin);

		if (city[0] != '\n')
		{
			// replace terminating '\n' by '\0'
			city[strlen(city)-1] = '\0';

			index = SearchCity (city);

			if (index == -1)
				printf ("No city for '%s' found!\n", city);
			else if (index == -2)
				printf ("City name '%s' cannot be converted to wide-characters!\n", city);
			else
				printf ("City found:\n%s  %d  %d\n", cities[index].m_Name,
						cities[index].m_Coord[0],
						cities[index].m_Coord[1]);
		}

		printf ("\nModify City: ");
		fgets (city, 100, stdin);

		if (city[0] != '\n')
		{
			// replace terminating '\n' by '\0'
			city[strlen(city)-1] = '\0';

			// normally calling 'SearchCity()' would'nt be necessary here since the "real"
			// program would offer 'index', e.g. as the city's index within a ComboBox
			index = SearchCity (city);

			if (index == -1)
				printf ("No city for '%s' found!\n", city);
			else if (index == -2)
				printf ("City name '%s' cannot be converted to wide-characters!\n", city);
			else
				printf ("City found:\n%s  %d  %d\n", cities[index].m_Name,
						cities[index].m_Coord[0],
						cities[index].m_Coord[1]);

			if (ModifyCity (index, &entry) != 1)
				printf ("ModifyCity returned with error!\n");
			else
				printf ("City modified:\n%s  %d  %d\n", cities[index].m_Name,
						cities[index].m_Coord[0],
						cities[index].m_Coord[1]);
		}

		printf ("\nAdd default City: ");
		fgets (city, 100, stdin);

		if (city[0] != '\n')
		{
			if (AddCity (&entry) != 1)
				printf ("AddCity returned with error!\n");
			else
			{
				// 'SearchCity()' is called only to illustrate the successfull addition
				index = SearchCity (entry.m_Name);

				if (index == -1)
					printf ("No city for '%s' found!\n", entry.m_Name);
				else if (index == -2)
					printf ("City name '%s' cannot be converted to wide-characters!\n",
							entry.m_Name);
				else
				{
					printf ("City added:\n");
					printf ("%s  %d  %d\n", cities[index-1].m_Name,
							cities[index-1].m_Coord[0],
							cities[index-1].m_Coord[1]);
					printf ("%s  %d  %d\n", cities[index].m_Name,
							cities[index].m_Coord[0],
							cities[index].m_Coord[1]);
					printf ("%s  %d  %d\n", cities[index+1].m_Name,
							cities[index+1].m_Coord[0],
							cities[index+1].m_Coord[1]);
				}
			}
		}

		printf ("\nRemove City: ");
		fgets (city, 100, stdin);

		if (city[0] != '\n')
		{
            // replace terminating '\n' by '\0'
            city[strlen(city)-1] = '\0';

			// normally calling 'SearchCity()' would'nt be necessary here since the "real"
			// program would offer 'index', e.g. as the city's index within a ComboBox
            index = SearchCity (city);

            if (index == -1)
                printf ("No city for '%s' found!\n", city);
            else if (index == -2)
                printf ("City name '%s' cannot be converted to wide-characters!\n", city);
            else
                printf ("City found:\n%s  %d  %d\n", cities[index].m_Name,
                        cities[index].m_Coord[0],
                        cities[index].m_Coord[1]);

            if (RemoveCity (index, &entry) != 1)
                printf ("RemoveCity returned with error!\n");
            else
			{
				printf ("City removed:\n");
				printf ("%s  %d  %d\n", cities[index-1].m_Name,
						cities[index-1].m_Coord[0],
						cities[index-1].m_Coord[1]);
				printf ("%s  %d  %d\n", cities[index].m_Name,
						cities[index].m_Coord[0],
						cities[index].m_Coord[1]);
				printf ("%s  %d  %d\n", cities[index+1].m_Name,
						cities[index+1].m_Coord[0],
						cities[index+1].m_Coord[1]);
			}
		}
	}

	if (ReleaseCities () != 1)
		printf ("error on releasing ''!\n");

	return 0;
}
