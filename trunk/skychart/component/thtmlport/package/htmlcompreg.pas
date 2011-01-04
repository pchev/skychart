unit HtmlCompReg;

interface

uses
  Classes, LResources, HTMLView, FramView, FramBrwz;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('HTML Components', [THTMLViewer, TFrameViewer, TFrameBrowser]);
end;

initialization
{$I htmlcomp.lrs}

end.
