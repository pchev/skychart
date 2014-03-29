program demo404;
{
  Test program for libplan404

  The default jd date and the reference result are
  from the original Steve Moshier example.

  This program run only with the CLX, you can
  quickly copy it if you want to test with the VCL.

}

uses
  QForms,
  demo404u in 'demo404u.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
