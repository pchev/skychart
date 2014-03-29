#define ENVIRONMENT_DATA struct environment_data

/*
   21 Aug 98:  Chris Marriott:  changed the 'cd_drive_letter' (char)
to 'szDrive',  to allow for possibility of data on a network (or,
possibly,  loaded into a directory on a hard drive);   also,  added
an 'hWnd' parameter to extract_realsky_as_fits( ).
   21 Aug 98:  BJG:  Decided the ask_for_guide_cd and
prompt_for_correct_realsky_cd options could be safely placed in the _calling_
function instead of within the GET_DSS library.
*/

ENVIRONMENT_DATA
   {
   char plate_list_name[260];
   char override_plate_name[20];
   char szDrive[256];      /*2001-12-10mn*/
// char szDrive[32];
   char output_file_name[260];
   int subsamp;
// int ask_for_guide_cd;
// int prompt_for_correct_realsky_cd;
   int low_contrast;
   int high_contrast;
   double image_ra;
   double image_dec;         /* in decimal degrees */
   int pixels_wide;
   int pixels_high;
   int clip_image;
   int add_line_to_realsky_dot_dat;
   };

#ifdef _WIN32
#define DLL_FUNC __stdcall
#else
#define DLL_FUNC
#endif

#ifdef __cplusplus
extern "C" {
#endif   /* __cplusplus */

int DLL_FUNC grab_realsky_chunk( const char *szDrive, const char *plate,
                               const int x1, const int y1,
                               const int x2, const int y2,
                               FILE *ofile, int subsamp, long *histogram);
int DLL_FUNC get_environment_data( ENVIRONMENT_DATA *edata,
                                   const char *filename);
int DLL_FUNC set_environment_data( const ENVIRONMENT_DATA *edata,
                                   const char *filename);
int DLL_FUNC create_image_line( char *oline, ENVIRONMENT_DATA *edata);
int DLL_FUNC parse_image_line( ENVIRONMENT_DATA *edata, const char *iline);
void DLL_FUNC remount_drive( const char *pDrive );
int DLL_FUNC extract_realsky_as_fits( const PLATE_DATA *pdata,
                                          const ENVIRONMENT_DATA *edata);
int DLL_FUNC set_debug_file( const char *path);

#ifdef __cplusplus
}
#endif   /* __cplusplus */
