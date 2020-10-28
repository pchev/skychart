/* File passpice.c
   
   Shared library for using SPICE from Skychart
   
*/ 
   #include <stdio.h>
   #include "SpiceUsr.h"
   
   #define     FILE_SIZE 512
   #define     WORD_SIZE 80
   #define     MSG_SIZE 1024

 struct TSpiceData
{
   int obs;		/* input observer body */ 
   int target;		/* input target body */ 
   double et;		/* input time */
   double x;		/* output X */
   double y;		/* output Y */
   double z;		/* output Z */
   char segid[WORD_SIZE]; /* output Segment ID */
   int err;		/* error code */
};  

void initerr() 
{
  /*
   Initialize error process by Skychart
  */  
   errprt_c (  "SET", 0, "NONE" );   
   erract_c (  "SET", 0, "RETURN"  );
}

int loadspk (fn)
char *fn;
{
  /*
   Load a kernel file
  */  
  SpiceChar spk [FILE_SIZE]; 
  sprintf(spk,"%s",fn);
  reset_c();
  furnsh_c ( spk );  
   if ( failed_c() )
      {
         return(1);
      }  
}    

void computepos(data)
struct TSpiceData *data;
{
  /*
   Compute position vector from observer to target
   For Skychart frame is fixed to J2000 and correction only for light time
  */  
   SpiceDouble    state[3];
   SpiceDouble    lt;
   SpiceDouble    et;
   SpiceInt       targ;
   SpiceInt       obs;
   SpiceChar      frame [WORD_SIZE] = "J2000";
   SpiceChar      abcorr[WORD_SIZE] = "LT";
   SpiceInt       fhandle;
   SpiceDouble    descr[5];
   SpiceChar      ident [WORD_SIZE];
   SpiceBoolean   found;  
 
   reset_c();
   data->err = 0;
   et = data->et;
   obs = data->obs;
   targ = data->target;
   
   spkezp_c ( targ, et, frame, abcorr, obs, state, &lt );
   
   if ( failed_c() )
      {
         data->err = 1;
         return;
      }  
      
   data->x = state[0];
   data->y = state[1];
   data->z = state[2];

   spksfs_c ( targ, et, WORD_SIZE, &fhandle, descr, ident, &found);
   
   if (found)
   {
      sprintf(data->segid,"%s",ident); 
   }
   else
   {
      sprintf(data->segid,"%s","Unknown"); 
   }
   
}

void getshorterror(char *msg)
{
  /*
   Get last short error message
  */  
  SpiceChar  lmsg  [MSG_SIZE];
   getmsg_c ( "SHORT", MSG_SIZE, lmsg);
   sprintf(msg,"%s",lmsg);
}

void getlongerror(char *msg)
{
  /*
   Get last long error message
  */  
   SpiceChar  lmsg  [MSG_SIZE];
   getmsg_c ( "LONG", MSG_SIZE, lmsg);
   sprintf(msg,"%s",lmsg);
}
