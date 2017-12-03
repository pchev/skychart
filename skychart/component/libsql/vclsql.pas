unit vclsql;

interface

uses Forms, StdCtrls, Grids, passql;

implementation

    {$IFDEF WITH_GUI}
    function QueryComboBox (SQL:String; Combobox:TComboBox; AddEmpty:Boolean=False):Boolean;
    function QueryStringGrid (SQL:String; Grid:TStringGrid):Boolean;
    {$ENDIF}
{$IFDEF WITH_GUI}
function TLiteDB.QueryComboBox;
var S:String;
begin
  S:=ComboBox.Text;
  Result := QueryStrings (SQL, ComboBox.Items);
  if Result then
    begin
      //if ComboBox.IndexOf(S)>=0 then
      //  ComboBox.ItemIndex := ComboBox.IndexOf(S);
      //if style=dropdownlist then this may not have effect
      ComboBox.Text := S;
    end;
  //Add an empty item {not always wanted}
  if AddEmpty then
    ComboBox.Items.Add ('');
end;

function TLiteDB.QueryStringGrid;
var i, j:Integer;
begin
  Result := Query (SQL);
  Grid.RowCount := FRowCount + 1;
  Grid.ColCount := FFields.Count + 1;
  for i:=0 to FFields.Count - 1 do
    begin
      Grid.Cells[i+1, 0] := FFields[i];
      Grid.ColWidths [i+1] := Grid.Canvas.TextWidth(FFields[i])+6;
    end;
  Grid.ColWidths [0] := 6;
  for i:=0 to FRowCount - 1 do
    begin
      Grid.Cells[0, i+1] := IntToStr(i+1);
      if Grid.ColWidths [0] < (Grid.Canvas.TextWidth(IntToStr(i+1)) + 6) then
        Grid.ColWidths [0] := Grid.Canvas.TextWidth(IntToStr(i+1)) + 6;
      for j:=0 to FFields.Count - 1 do
        begin
          Grid.Cells[1+j, i+1] := Results[i][j];
          if Grid.ColWidths [j+1]<(Grid.Canvas.TextWidth(Results[i][j])+6) then
            Grid.ColWidths [j+1] := Grid.Canvas.TextWidth(Results[i][j])+6;
        end;
    end;
end;
{$ENDIF}


end.
