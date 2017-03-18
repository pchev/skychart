#define BITFILE struct bitfile

BITFILE
   {
   uint8_t *buff, *loc, *endptr;
   unsigned bit_loc, length;
   int error_code;
   };

#define input_nybble( infile)    input_nbits( infile, 4)

int input_bit( BITFILE *infile);
int input_nbits( BITFILE *infile, const int n);
