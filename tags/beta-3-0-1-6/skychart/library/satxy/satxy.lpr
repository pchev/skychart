library satxy;

{$MODE Delphi}

//
// Modified 02-Sep-2000, J. Burton
//
// The following line should be included when processing the elsat and
// ixsat files generated using the high-precision data files.  If the
// low precision data was used, comment out the following line.
//
//{$DEFINE HIGHPREC}

uses  satxymain;

  {$LIBPREFIX 'lib'}

{$ifdef linux}
exports  Satxyfm ;
{$endif}
{$ifdef mswindows}
exports  Satxyfm index 1 ;
{$endif}


begin
end.
