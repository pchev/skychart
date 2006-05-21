unit Unit1; 

{$mode objfpc}{$H+}

interface

uses passql, pasmysql, passqlite,
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  Buttons, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    db:TSqlDB;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  
const DBtype=0;
      dbn='test1';

implementation

{ TForm1 }


procedure TForm1.Button1Click(Sender: TObject);
begin
memo1.clear;
if db.Active then begin
 if DBtype=0 then
  db.Query('CREATE TABLE TEST (col1 varchar(80), col2 varchar(80), col3 varchar(80))')
 else
  db.Query('CREATE TABLE TEST (col1 varchar, col2 varchar, col3 varchar)');
end;
memo1.Lines.Add(db.ErrorMessage);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
memo1.clear;
if db.Active then begin
  db.Query('INSERT INTO TEST VALUES("line1","aa","aaa")');
  db.Query('INSERT INTO TEST VALUES("line2","bb","bbb")');
  db.Query('INSERT INTO TEST VALUES("line3","cc","ccc")');
end;
memo1.Lines.Add(db.ErrorMessage);
end;

procedure TForm1.Button3Click(Sender: TObject);
var i: integer;
begin
memo1.clear;
if db.Active then begin
  db.Query('SELECT * FROM TEST');
  i:=0;
  while i<db.RowCount do begin
    memo1.Lines.Add(db.Results[i][0]+' '+db.Results[i][1]+' '+db.Results[i][2]);
    inc(i);
  end;
end;
memo1.Lines.Add(db.ErrorMessage);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
memo1.clear;
if DBtype=0 then begin // mysql
   db.SetPort(3306);
   db.Connect('localhost','root','','');
   memo1.Lines.Add(db.ErrorMessage);
   db.Query('Create Database if not exists '+dbn);
   memo1.Lines.Add(db.ErrorMessage);
   db.Connect('localhost','root','',dbn);
   memo1.Lines.Add(db.ErrorMessage);
end;
if db.database<>dbn then db.Use(dbn);
memo1.Lines.Add(db.ErrorMessage);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
if DBtype=0 then  // mysql
   db:=TMyDB.create(self)
else             // sqlite
   db:=TLiteDB.create(self);
end;

initialization
  {$I unit1.lrs}

end.

