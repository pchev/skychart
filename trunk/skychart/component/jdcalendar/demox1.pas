unit demox1;

interface

uses Math,
  SysUtils, Variants, Classes,  QControls, QForms,
  QComCtrls, cu_jdcalendar, QExtCtrls, QStdCtrls,
  QButtons, QMask;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    JDDatePicker1: TJDDatePicker;
    JDMonthlyCalendar1: TJDMonthlyCalendar;
    Button5: TButton;
    Edit5: TEdit;
    Button6: TButton;
    TimePicker1: TTimePicker;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.xfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
edit1.Text:=inttostr(JDDatePicker1.Year);
edit2.Text:=inttostr(JDDatePicker1.Month);
edit3.Text:=inttostr(JDDatePicker1.Day);
edit4.Text:=floattostr(JDDatePicker1.JD);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
JDDatePicker1.Year:=strtoint(edit1.text);
JDDatePicker1.Month:=strtoint(edit2.text);
JDDatePicker1.Day:=strtoint(edit3.text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
JDDatePicker1.JD:=strtofloat(edit4.Text);
end;

procedure TForm1.Button4Click(Sender: TObject);
var lang: TLabelsArray;
begin
lang.mon:='Lun';
lang.tue:='Mar';
lang.wed:='Mer';
lang.thu:='Jeu';
lang.fri:='Ven';
lang.sat:='Sam';
lang.sun:='Dim';
lang.today:='aujourd''hui';
lang.jd:='Date Julienne = ';
JDDatePicker1.labels:=lang;
JDMonthlyCalendar1.labels:=lang;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
edit5.Text:=timetostr(timepicker1.Time);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
timepicker1.Time:=now;
end;

end.
