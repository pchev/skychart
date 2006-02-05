#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <limits>
#include <string>
#include <vector>


struct City
{
	// city name
    string m_Name;

	// geogr. latitude
    int    m_Latitude;

	// geogr. longitude
    int    m_Longitude;
};


int main (int argc, char **argv)
{
    int          Lat, Long;
	string       ofilename (".dat");
	string       rc, ufi, uni, dd_lat, dd_long, Latitude, Longitude, utm, jog, fc, dsg, pc, cc1, adm1, adm2,
		         dim, cc2, nt, lc, short_form, generic, sort_name, full_name, full_name_nd, modify_date;

	const string eol   ("\r\n");
	const string space (" ");
	size_t       length = 0, lines = 0, i, j;
	vector<City> CityVec;
	vector<size_t> IdentVec;
	const char   tab = '\t';

	if (argc < 2)
	{
		cerr << "No input file given!" << endl;
		exit (-1);
	}

	// open output file stream
	wifstream ifile (argv[1], ios::binary | ios::in);

	if (! ifile)
	{
		cerr << "Cannot open file '" << argv[1] << "'!" << endl;
		exit (-1);
	}

	while (1)
	{
		getline (ifile, rc,            tab);
		getline (ifile, ufi,           tab);
		getline (ifile, uni,           tab);
		getline (ifile, dd_lat,        tab);
		getline (ifile, dd_long,       tab);
		getline (ifile, Latitude,      tab);
		getline (ifile, Longitude,     tab);
		getline (ifile, utm,           tab);
		getline (ifile, jog,           tab);
		getline (ifile, fc,            tab);
		getline (ifile, dsg,           tab);
		getline (ifile, pc,            tab);
		getline (ifile, cc1,           tab);
		getline (ifile, adm1,          tab);
		getline (ifile, adm2,          tab);
		getline (ifile, dim,           tab);
		getline (ifile, cc2,           tab);
		getline (ifile, nt,            tab);
		getline (ifile, lc,            tab);
		getline (ifile, short_form,    tab);
		getline (ifile, generic,       tab);
		getline (ifile, sort_name,     tab);
		getline (ifile, full_name,     tab);
		getline (ifile, full_name_nd,  tab);
		getline (ifile, modify_date);

		if (ifile.eof ())
			break;

		// permit only 'populated places'
		if (dsg.find ("PPL") == string::npos)
			continue;

		// omit abandoned and destroyed 'populated places'
		if (dsg.find ("PPLQ") != string::npos || dsg.find ("PPLW") != string::npos)
			continue;

		// process latitude
		if (Latitude.find (" ") != string::npos)
		{
			while (1)
			{
				string::size_type pos = Latitude.find (" ");
				if (pos == string::npos)
					break;
				Latitude.erase (pos);
			}
		}

		// process longitude
		if (Longitude.find (" ") != string::npos)
		{
			while (1)
			{
				string::size_type pos = Longitude.find (" ");
				if (pos == string::npos)
					break;
				Longitude.erase (pos);
			}
		}

		Lat  = atoi (Latitude.c_str ());
		Long = atoi (Longitude.c_str ());

//		cout << rc << " " << ufi << " " << uni << " " << dd_lat << " " << dd_long << " " << Latitude << " " << Longitude << " " << utm << " " << jog << " " << fc << " " << dsg << " " << pc << " "
//			 << cc1 << " " << adm1 << " " << adm2 << " " << dim << " " << cc2 << " " << nt << " " << lc << " " << short_form << " " << generic << " " << sort_name << " " << full_name << " "
//			 << full_name_nd << " " << modify_date << endl;

		City city = { full_name, Lat, Long };

		CityVec.push_back (city);

		if (full_name.length () > length)
			length = full_name.length ();
	}

	ifile.close ();

	// open output file stream
	ofilename = argv[1] + ofilename;

	wofstream ofile (ofilename.c_str (), ios::binary | ios::out);

	if (! ofile)
	{
		cerr << "Cannot open file '" << ofilename << "'!" << endl;
		exit (-1);
	}

	// write a place holder for the number of lines to the file
	ofile.write (reinterpret_cast<const char*> (&lines), sizeof (lines));

	// find doubled entries
	for (i = 0; i < CityVec.size (); i++)
	{

		for (j = i + 1; j < CityVec.size (); j++)
		{
			if (CityVec[i].m_Name       == CityVec[j].m_Name      &&
				CityVec[i].m_Latitude   == CityVec[j].m_Latitude  &&
				CityVec[i].m_Longitude  == CityVec[j].m_Longitude)
			{
				cout << "Found identical entry: ";
				cout << CityVec[i].m_Name     << " " << CityVec[i].m_Latitude << " " << CityVec[i].m_Longitude << endl;
				break;
			}
		}

		if (j == CityVec.size ())
		{
			ofile.write (reinterpret_cast<const char*> (CityVec[i].m_Name.c_str()),
														CityVec[i].m_Name.length () + 1); 
			ofile.write (reinterpret_cast<const char*> (&(CityVec[i].m_Latitude)),
														sizeof (CityVec[i].m_Latitude));
			ofile.write (reinterpret_cast<const char*> (&(CityVec[i].m_Longitude)),
														sizeof (CityVec[i].m_Longitude));

			lines++;

			if (lines % 10000 == 0)
				cout << lines << endl;
		}
	}

	// write the number of City entries to the file
	ofile.seekp (0);
	ofile.write (reinterpret_cast<const char*> (&lines), sizeof (lines));

	ofile.close ();

	cout << argv[1] << ": " << lines << "  " << length << endl;

	return 0;
}
