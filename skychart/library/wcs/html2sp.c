/* File html2sp.c
 * November 5, 2018
 * By Jessica Mink Harvard-Smithsonian Center for Astrophysics)
 * Send bug reports to jmink@cfa.harvard.edu

   Copyright (C) 2018 
   Smithsonian Astrophysical Observatory, Cambridge, MA USA

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <math.h>
#include "libwcs/fitsfile.h"

#define MAXKWD 50
static int maxnkwd = MAXKWD;

static void usage();

static int verbose = 0;		/* verbose/debugging flag */
static int version = 0;		/* If 1, print only program name and version */
static char spchar = '_';

static char *RevMsg = "CHAR2SP WCSTools 3.9.6, 28 August 2018, Jessica Mink (jmink@cfa.harvard.edu)";

int
main (ac, av)
int ac;
char **av;
{
    char *str;
    char **kwd;
    int nkwd = 0;
    int lstr;
    int ikwd, i;

    nkwd = 0;
    kwd = (char **)calloc (maxnkwd, sizeof(char *));
    for (ikwd = 0; ikwd < maxnkwd; ikwd++) {
	kwd[ikwd] = NULL;
	}

    /* Check for help or version command first */
    str = *(av+1);
    if (!str || !strcmp (str, "help") || !strcmp (str, "-help"))
	usage();
    if (!strcmp (str, "version") || !strcmp (str, "-version")) {
	version = 1;
	usage();
	}

    /* crack arguments */
    for (av++; --ac > 0; av++) {
	if (*(str = *av) == '-') {
	    char c;
	    while ((c = *++str))
	    switch (c) {

		case 's':	/* Replace this character with spaces in string arguments */
		    if (ac > 1) {
			spchar= *++av[0];
			ac--;
			}
		    break;

		case 'v':	/* more verbosity */
		    verbose++;
		    break;

		default:
		    usage();
		    break;
		}
	    }

	/* String component */
	else {
	    if (nkwd >= maxnkwd) {
		maxnkwd = maxnkwd * 2;
		kwd = (char **) realloc ((void *)kwd, maxnkwd);
		}
	    kwd[nkwd] = *av;
	    nkwd++;
	    }
	}

    if (nkwd <= 0 )
	usage ();
    else if (nkwd <= 0) {
	fprintf (stderr, "HTML2SP: no string components specified\n");
	exit (1);
	}
    else stripHTMLTags (


int
stripHTMLTags (char *instring, size_t size)
{
int i=0,j=0,k=0;
int flag = 0; // 0: searching for < or & (& as in &bspn; etc), 1: searching for >, 2: searching for ; after &, 3: searching for </script>,</style>, -->
char tempbuf[1024*1024] = "";
char searchbuf[1024] =  "";

while(i<size) {

    if (flag == 0) {
	if (instring[i] == '<') {
	    flag = 1;
	    tempbuf[0] = '\0';
	    k=0; // track for <script>,<style>, <!-- --> etc
	    }
	else if (instring[i] == '&') {
	    flag = 2;
	    }
	else {
	    instring[j] = instring[i];
	    j++;
	    }
	}

    else if (flag == 1) {
	tempbuf[k] = instring[i];
	k++;
	tempbuf[k] = '\0';

	//printf("DEBUG: %s\n",tempbuf);

	if ((0 == strcmp(tempbuf,"script"))) {
	    flag = 3;
	    strcpy(searchbuf,"</script>");
	    //printf("DEBUG: Detected %s\n",tempbuf);
	    tempbuf[0] = '\0';
	    k = 0;
	    }
	else if ((0 == strcmp(tempbuf,"style"))) {
	    flag = 3;
	    strcpy(searchbuf,"</style>");
	    //printf("DEBUG: Detected %s\n",tempbuf);
	    tempbuf[0] = '\0';
	    k = 0;
	    }
	else if((0 == strcmp(tempbuf,"!--"))) {
	    flag = 3;
	    strcpy(searchbuf,"-->");
	    //printf("DEBUG: Detected %s\n",tempbuf);
	    tempbuf[0] = '\0';
	    k = 0;
	    }

	if (instring[i] == '>') {
	    instring[j] = ' ';
	    j++;
	    flag = 0;
	    }

	}

    else if (flag == 2) {
	if(instring[i] == ';') {
	    sToClean[j] = ' ';
	    j++;
	    flag = 0;
	    }
	}

    else if(flag == 3) {
	tempbuf[k] = sToClean[i];
	k++;
	tempbuf[k] = '\0';

	//printf("DEBUG: %s\n",tempbuf);
	//printf("DEBUG: Searching for %s\n",searchbuf);

	if (0 == strcmp(&tempbuf[0] + k - strlen(searchbuf),searchbuf)) {
	    flag = 0;
	    //printf("DEBUG: Detected END OF %s\n",searchbuf);

	    searchbuf[0] = '\0';
	    tempbuf[0] = '\0';
	    k = 0;
	    }
	}

    i++;
    }

instring[j] = '\0';

return j;
}
s
	lstr = strlen (kwd[ikwd]);
	for (i = 0; i < lstr; i++) {
	    if (kwd[ikwd][i] == spchar)
		kwd[ikwd][i] = ' ';
	    }
	printf ("%s", kwd[ikwd]);
	if (ikwd < nkwd - 1)
	    printf (" ");
	else
	    printf ("\n");
	}

    free (kwd);

    return (0);
}

static void
usage ()
{
    fprintf (stderr,"%s\n",RevMsg);
    if (version)
	exit (-1);
    fprintf (stderr,"Removes HTML code from a string with spaces (def=_)\n");
    fprintf(stderr,"Usage: [-v][-s char] string [string2][...][string n]\n");
    fprintf(stderr,"  -s [char]: Replace this character with spaces in output\n");
    fprintf(stderr,"  -v: Verbose\n");
    exit (1);
}

/* Jan  8 2002	New program
 *
 * Apr  3 2006	Declare main to be int
 * Jun 20 2006	Drop unused variables
 */
