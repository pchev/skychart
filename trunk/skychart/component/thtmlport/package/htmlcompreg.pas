unit HtmlCompReg;

interface

uses
  Classes, LResources, PropEdits, GraphPropEdits,
  HTMLView, FramView, FramBrwz;

procedure Register;

implementation

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(AnsiString), THTMLViewer, 'DefFontName', TFontNamePropertyEditor);
  RegisterPropertyEditor(TypeInfo(AnsiString), THTMLViewer, 'DefPreFontName', TFontNamePropertyEditor);

  RegisterPropertyEditor(TypeInfo(AnsiString), TFrameViewer, 'DefFontName', TFontNamePropertyEditor);
  RegisterPropertyEditor(TypeInfo(AnsiString), TFrameViewer, 'DefPreFontName', TFontNamePropertyEditor);

  RegisterPropertyEditor(TypeInfo(AnsiString), TFrameBrowser, 'DefFontName', TFontNamePropertyEditor);
  RegisterPropertyEditor(TypeInfo(AnsiString), TFrameBrowser, 'DefPreFontName', TFontNamePropertyEditor);

  RegisterComponents('HTML Components', [THTMLViewer, TFrameViewer, TFrameBrowser]);
end;

initialization
{$I htmlcomp.lrs}

end.
