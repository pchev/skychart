unit u_types;

interface

type
    PInit_object = ^Tinit_object;      // pointeur sur un element servant a l initialisation des codeurs
    Tinit_object = record
       name:string;
       alpha:double;
       delta:double;
       alt:double;
       az:double;
       steps_x:integer;
       steps_y:integer;
       phi:double;
       theta:double;
       time:tdatetime;
       error:double;
end;

implementation
end.
 
