#define PLATE_DATA struct plate_data

PLATE_DATA
   {
   char header_text[101 * 80];
   char plate_name[10], gsc_plate_name[10];
   int xpixel, ypixel, dist_from_edge, cd_number, is_uk_survey;
   int real_width, real_height;        /* after clipping */
   double year_imaged;
   };

#ifdef _WIN32
#define DLL_FUNC __stdcall
#else
#define DLL_FUNC
#endif

#ifdef __cplusplus
extern "C" {
#endif      /* __cplusplus */

PLATE_DATA * DLL_FUNC get_plate_list( const char *szDataDir,
          const double ra, const double dec,
          const int width, const int height,
          const char *lis_file_name, int *n_found);

#ifdef __cplusplus
}
#endif      /* __cplusplus */
